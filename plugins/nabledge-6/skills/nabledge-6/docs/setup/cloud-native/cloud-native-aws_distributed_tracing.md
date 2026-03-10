# AWSにおける分散トレーシング

## 概要

> **重要**: 2020年10月に[AWS Distro for OpenTelemetry](https://aws.amazon.com/jp/otel/?otel-blogs.sort-by=item.additionalFields.createdDate&otel-blogs.sort-order=desc)が発表されたが、2021年3月現在production-readyとなっているが、正式リリースはされていない。正式リリース後、Nablarchでの動作確認がとれた場合は本章をAWS Distro for OpenTelemetryを使用した手順に差し替える可能性がある。

Nablarchはフレームワークの構造上、[自動計測エージェント](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/aws-x-ray-auto-instrumentation-agent-for-java.html)が使用できないため、[AWS X-Ray SDK for Java](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-sdk-java.html)をアプリケーションに組み込む方式を使用する。

以下はコンテナ用アーキタイプを使用した場合の例を示す。設定の判断基準:
- 受信HTTPリクエスト の設定のみでサービス間の関連はトレースできる
- 送信HTTP呼び出し と SQLクエリ はアプリケーションの要件に応じて設定する

## 依存関係の追加

**モジュール**:
```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.amazonaws</groupId>
      <artifactId>aws-xray-recorder-sdk-bom</artifactId>
      <version>2.15.0</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<dependencies>
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
</dependencies>
```

> **補足**: SQLクエリのトレースには `aws-xray-recorder-sdk-sql-postgres` や `aws-xray-recorder-sdk-sql-mysql` ではなく、任意のJDBCデータソースをトレース可能な `aws-xray-recorder-sdk-sql` を使用する。

## 受信HTTPリクエスト

受信HTTPリクエストのトレースには `com.amazonaws.xray.jakarta.servlet.AWSXRayServletFilter` を `src/main/webapp/WEB-INF/web.xml` に追加する。AWSXRayServletFilterのfilter-mappingは既存のfilter-mappingより上に記載する。

```xml
<filter>
  <filter-name>AWSXRayServletFilter</filter-name>
  <filter-class>com.amazonaws.xray.jakarta.servlet.AWSXRayServletFilter</filter-class>
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
<filter-mapping>
  <filter-name>entryPoint</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
```

## 送信HTTP呼び出し

送信HTTP呼び出しのトレースには、Jersey経由でApache HttpComponentsを使用し、`HttpClientBuilder`をAWS X-Ray SDKの `com.amazonaws.xray.proxies.apache.http.HttpClientBuilder` に差し替える。JerseyはデフォルトでHTTP通信に `java.net.HttpURLConnection` を使用するため、Apache HttpComponentsを利用するには `org.glassfish.jersey.apache.connector.ApacheConnectorProvider` の設定が必要。

**Jerseyモジュール**:
```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.glassfish.jersey</groupId>
      <artifactId>jersey-bom</artifactId>
      <version>3.1.1</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<dependencies>
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
</dependencies>
```

`org.glassfish.jersey.apache.connector.ApacheHttpClientBuilderConfigurator` を使用して `HttpClientBuilder` をAWS X-Ray SDKのものに差し替えるファクトリクラスを作成する:

```java
package com.example;

import com.amazonaws.xray.proxies.apache.http.HttpClientBuilder;
import nablarch.core.repository.di.ComponentFactory;
import org.glassfish.jersey.apache.connector.ApacheConnectorProvider;
import org.glassfish.jersey.apache.connector.ApacheHttpClientBuilderConfigurator;
import org.glassfish.jersey.client.ClientConfig;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.core.Configuration;

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

`src/main/resources/rest-component-configuration.xml` にコンポーネントを登録する:

```xml
<component name="httpClient" class="com.example.system.httpclient.JerseyHttpClientWithAWSXRayFactory" />
```

システムリポジトリに登録したHTTPクライアントを使用するクラスには `@SystemRepositoryComponent` を付与することでDIコンテナの構築対象となり、コンストラクタインジェクションでHTTPクライアントが登録される。`@ComponentRef` でコンポーネントを、`@ConfigValue` で設定値を注入できる:

```java
package com.example;

import nablarch.core.repository.di.config.externalize.annotation.ComponentRef;
import nablarch.core.repository.di.config.externalize.annotation.ConfigValue;
import nablarch.core.repository.di.config.externalize.annotation.SystemRepositoryComponent;
import jakarta.ws.rs.client.Client;

@SystemRepositoryComponent
public class HttpProductRepository {

    private final Client httpClient;
    private final String productAPI;

    public HttpProductRepository(@ComponentRef("httpClient") Client httpClient,
                                @ConfigValue("${api.product.url}") String productAPI) {
        this.httpClient = httpClient;
        this.productAPI = productAPI;
    }

    public ProductList findAll() {
        WebTarget target = httpClient.target(productAPI).path("/products");
        return target.request().get(ProductList.class);
    }
}
```

また、システムリポジトリから直接HTTPクライアントを取得して使用することも可能:

```java
Client httpClient = SystemRepository.get("httpclient");
WebTarget target = httpClient.target(productAPI).path("/products");
ProductResponse products = target.request().get(ProductResponse.class);
```

## SQLクエリ

データソースを `com.amazonaws.xray.sql.TracingDataSource` でデコレートすることでSQLクエリが計測される。Nablarchは `dataSource` という名前でデータソースコンポーネントを取得するため、元のデータソースを `rawDataSource` に名前変更し、`TracingDataSourceFactory` を `dataSource` という名前で登録する。

デコレートするファクトリクラスを作成する:

```java
package com.example;

import com.amazonaws.xray.sql.TracingDataSource;
import nablarch.core.log.Logger;
import nablarch.core.log.LoggerManager;
import nablarch.core.repository.di.ComponentFactory;

import javax.sql.DataSource;

public class TracingDataSourceFactory implements ComponentFactory<DataSource> {
    private static final Logger LOGGER = LoggerManager.get(TracingDataSourceFactory.class);
    private DataSource dataSource;

    @Override
    public DataSource createObject() {
        LOGGER.logInfo("Wrap " + dataSource + " in " + TracingDataSource.class.getName());
        return TracingDataSource.decorate(dataSource);
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
```

`src/main/resources/data-source.xml` を以下のように編集する:
- `com.zaxxer.hikari.HikariDataSource` のコンポーネント名を `dataSource` から `rawDataSource` に変更
- `TracingDataSourceFactory` を `dataSource` という名前で定義し、`rawDataSource` をプロパティに設定

```xml
<component name="rawDataSource"
           class="com.zaxxer.hikari.HikariDataSource" autowireType="None">
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
