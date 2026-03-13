# AWSにおける分散トレーシング

**公式ドキュメント**: [AWSにおける分散トレーシング](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/cloud_native/distributed_tracing/aws_distributed_tracing.html)

## AWSにおける分散トレーシング（概要）

Nablarchはフレームワークの構造上、自動計測エージェントが使用できない。そのためAWS X-Ray SDK for Javaをアプリケーションに組み込む方法を使用する。

> **重要**: 2020年10月にAWS Distro for OpenTelemetryが発表された。2021年3月現在production-readyだが正式リリースはされていない。Nablarchでの動作確認がとれた場合、本章はAWS Distro for OpenTelemetryを使用した手順に差し替わる可能性がある。

[xray_configuration_incoming_request](#) の設定だけでサービス間の関連はトレースできる。[xray_configuration_outgoing_http_calls](#) と [xray_configuration_sql_queries](#) はアプリケーションの要件に応じて設定する。

<details>
<summary>keywords</summary>

分散トレーシング, AWS X-Ray, 自動計測エージェント, AWS Distro for OpenTelemetry, Nablarch制約

</details>

## 依存関係の追加

**モジュール** (BOM: `com.amazonaws:aws-xray-recorder-sdk-bom:2.4.0`):

```xml
<dependency>
  <groupId>com.amazonaws</groupId>
  <artifactId>aws-xray-recorder-sdk-core</artifactId>
</dependency>
<dependency>
  <groupId>com.amazonaws</groupId>
  <artifactId>aws-xray-recorder-sdk-apache-http</artifactId>
</dependency>
<dependency>
  <groupId>com.amazonaws</groupId>
  <artifactId>aws-xray-recorder-sdk-sql</artifactId>
</dependency>
```

> **補足**: AWS公式ドキュメントではSQLクエリのトレースに`aws-xray-recorder-sdk-sql-postgres`または`aws-xray-recorder-sdk-sql-mysql`を推奨しているが、本手順では任意のJDBCデータソースをトレース可能な`aws-xray-recorder-sdk-sql`を使用する。

<details>
<summary>keywords</summary>

aws-xray-recorder-sdk-bom, aws-xray-recorder-sdk-core, aws-xray-recorder-sdk-apache-http, aws-xray-recorder-sdk-sql, Maven依存関係, pom.xml

</details>

## 受信HTTPリクエスト

`AWSXRayServletFilter`を`src/main/webapp/WEB-INF/web.xml`に追加する。`AWSXRayServletFilter`のfilter-mappingは既存のfilter-mappingより上に配置する必要がある。

```xml
<filter>
  <filter-name>AWSXRayServletFilter</filter-name>
  <filter-class>com.amazonaws.xray.javax.servlet.AWSXRayServletFilter</filter-class>
  <init-param>
    <param-name>fixedName</param-name>
    <!-- サービスマップでアプリケーションを識別する名前を指定する -->
    <param-value>example-app</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>AWSXRayServletFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
<!-- ↑既存のfilter-mappingより上に記載する -->
```

<details>
<summary>keywords</summary>

AWSXRayServletFilter, 受信HTTPリクエスト, X-Rayサーブレットフィルタ, web.xml, filter-mapping

</details>

## 送信HTTP呼び出し

JerseyはデフォルトでHTTP通信に`java.net.HttpURLConnection`を使用するため、Apache HttpComponentsを利用するには`ConnectorProvider`の設定が必要。`org.glassfish.jersey.apache.connector.ApacheConnectorProvider`を`ConnectorProvider`として使用し、`org.glassfish.jersey.apache.connector.ApacheHttpClientBuilderConfigurator`で`HttpClientBuilder`をAWS SDKの`com.amazonaws.xray.proxies.apache.http.HttpClientBuilder`に差し替える。

**モジュール** (BOM: `org.glassfish.jersey:jersey-bom:2.32`):

```xml
<dependency>
  <groupId>org.glassfish.jersey.core</groupId>
  <artifactId>jersey-client</artifactId>
</dependency>
<dependency>
  <groupId>org.glassfish.jersey.connectors</groupId>
  <artifactId>jersey-apache-connector</artifactId>
</dependency>
<dependency>
  <groupId>org.glassfish.jersey.media</groupId>
  <artifactId>jersey-media-json-jackson</artifactId>
</dependency>
<dependency>
  <groupId>org.glassfish.jersey.inject</groupId>
  <artifactId>jersey-hk2</artifactId>
</dependency>
```

**クラス**: `com.example.JerseyHttpClientWithAWSXRayFactory` (`nablarch.core.repository.di.ComponentFactory<Client>`実装):

```java
public class JerseyHttpClientWithAWSXRayFactory implements ComponentFactory<Client> {
    @Override
    public Client createObject() {
        ApacheHttpClientBuilderConfigurator clientBuilderConfigurator
                = (httpClientBuilder) -> HttpClientBuilder.create();
        Configuration config = new ClientConfig()
                .register(clientBuilderConfigurator)
                .connectorProvider(new ApacheConnectorProvider());
        return ClientBuilder.newClient(config);
    }
}
```

`src/main/resources/rest-component-configuration.xml`に登録:

```xml
<component name="httpClient" class="com.example.system.httpclient.JerseyHttpClientWithAWSXRayFactory" />
```

HTTPクライアントの利用方法: `@SystemRepositoryComponent`クラスで`@ComponentRef("httpClient")`によるコンストラクタインジェクション、またはシステムリポジトリから直接取得 (`SystemRepository.get("httpclient")`) が可能。

```java
@SystemRepositoryComponent
public class HttpProductRepository {
    private final Client httpClient;
    private final String productAPI;

    public HttpProductRepository(@ComponentRef("httpClient") Client httpClient,
                                @ConfigValue("${api.product.url}") String productAPI) {
        this.httpClient = httpClient;
        this.productAPI = productAPI;
    }
}
```

<details>
<summary>keywords</summary>

JerseyHttpClientWithAWSXRayFactory, ApacheConnectorProvider, ApacheHttpClientBuilderConfigurator, jersey-apache-connector, 送信HTTP呼び出し, HttpClientBuilder, @SystemRepositoryComponent, @ComponentRef, @ConfigValue, HttpProductRepository, SystemRepository, ClientConfig

</details>

## SQLクエリ

データソースを`com.amazonaws.xray.sql.TracingDataSource`でデコレートすることでSQLクエリの計測が可能。Nablarchは`dataSource`という名前でデータソースコンポーネントを取得するため、`TracingDataSourceFactory`を`dataSource`という名前で定義する。

**クラス**: `com.example.TracingDataSourceFactory` (`nablarch.core.repository.di.ComponentFactory<DataSource>`実装):

```java
public class TracingDataSourceFactory implements ComponentFactory<DataSource> {
    private DataSource dataSource;

    @Override
    public DataSource createObject() {
        return TracingDataSource.decorate(dataSource);
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
```

`src/main/resources/data-source.xml`の変更手順:
1. `com.zaxxer.hikari.HikariDataSource`コンポーネントの名前を`dataSource`から`rawDataSource`に変更する
2. `TracingDataSourceFactory`を`dataSource`という名前で定義し、`rawDataSource`を`dataSource`プロパティに設定する

```xml
<component name="rawDataSource" class="com.zaxxer.hikari.HikariDataSource" autowireType="None">
  <property name="driverClassName" value="${nablarch.db.jdbcDriver}"/>
  <property name="jdbcUrl" value="${nablarch.db.url}"/>
  <property name="username" value="${nablarch.db.user}"/>
  <property name="password" value="${nablarch.db.password}"/>
  <property name="maximumPoolSize" value="${nablarch.db.maxPoolSize}"/>
  <property name="minimumIdle" value="${nablarch.db.minimumIdle}"/>
  <property name="connectionTimeout" value="${nablarch.db.connectionTimeout}"/>
  <property name="idleTimeout" value="${nablarch.db.idleTimeout}"/>
  <property name="maxLifetime" value="${nablarch.db.maxLifetime}"/>
  <property name="validationTimeout" value="${nablarch.db.validationTimeout}"/>
</component>
<component name="dataSource" class="com.example.system.awsxray.TracingDataSourceFactory">
  <property name="dataSource" ref="rawDataSource" />
</component>
```

<details>
<summary>keywords</summary>

TracingDataSource, TracingDataSourceFactory, SQLクエリトレース, dataSource, rawDataSource, HikariDataSource

</details>
