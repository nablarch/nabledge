# Nablarch 5から6への移行ガイド

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/migration/index.html) [2](https://nablarch.github.io/docs/5-LATEST/doc/releases/index.html) [3](https://nablarch.github.io/docs/5-LATEST/doc/application_framework/application_framework/blank_project/FirstStep.html) [4](https://jakarta.ee/specifications/servlet/6.0/#details) [5](https://jakarta.ee/specifications/tags/3.0/)

## Nablarch 5と6で大きく異なる点

Nablarch 5プロジェクトのNablarch 6への移行方法について説明する。

> **重要**: Nablarch 6のバージョン6/6u1は先行リリースバージョンであり、6u2が正式リリース後の最初のバージョンとなる。ここで説明する手順はNablarch 5の最新バージョンからNablarch **6u2**へのバージョンアップを前提としている。アーキタイプから作ったプロジェクトに組み込まれているgsp-dba-maven-pluginは6u2と合わせてリリースされた**5.1.0**の使用を前提としている。6u3以降へバージョンアップする場合は、6u3以降のリリースノートを順に参照してバージョンアップ手順を確認すること。

Java EE仕様の実装ライブラリが組み込まれている場合、Jakarta EEのものに置き換える。各`dependency`がJava EE仕様かどうかは個別に調査し、Jakarta EE対応版の`dependency`は実装ライブラリごとに異なるため公式サイトで確認する。

> **補足**: Nablarch 6はJava 17以上前提のため、[Nablarch 5のセットアップ手順](https://nablarch.github.io/docs/5-LATEST/doc/application_framework/application_framework/blank_project/FirstStep.html)でJava 17動作のために追加したモジュールが不要になる場合がある。[dependency:tree](https://maven.apache.org/plugins/maven-dependency-plugin/tree-mojo.html)等で依存関係を確認し、更新または削除を判断する。

### Bean Validation → Jakarta Bean Validation

```xml
<!-- 修正前 -->
<dependency>
  <groupId>org.hibernate</groupId>
  <artifactId>hibernate-validator</artifactId>
  <version>5.3.6.Final</version>
</dependency>
```

```xml
<!-- 修正後 -->
<dependency>
  <groupId>org.hibernate.validator</groupId>
  <artifactId>hibernate-validator</artifactId>
  <version>8.0.0.Final</version>
</dependency>
```

### JSTL → Jakarta Standard Tag Library

```xml
<!-- 修正前 -->
<dependency>
  <groupId>taglibs</groupId>
  <artifactId>standard</artifactId>
  <version>...</version>
</dependency>
```

```xml
<!-- 修正後 -->
<dependency>
  <groupId>org.glassfish.web</groupId>
  <artifactId>jakarta.servlet.jsp.jstl</artifactId>
  <version>3.0.0</version>
</dependency>
```

### JAX-RS → Jakarta RESTful Web Services

jersey-bomのバージョンを`3.1.8`に更新する（他のdependencyは変更なし）。

```xml
<!-- 修正後: jersey-bom バージョン変更 -->
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.glassfish.jersey</groupId>
      <artifactId>jersey-bom</artifactId>
      <version>3.1.8</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

### JMS → Jakarta Messaging

`activemq-all`を以下3モジュール（バージョン`2.37.0`）に置き換える。

```xml
<dependency>
  <groupId>org.apache.activemq</groupId>
  <artifactId>artemis-server</artifactId>
  <version>2.37.0</version>
</dependency>
<dependency>
  <groupId>org.apache.activemq</groupId>
  <artifactId>artemis-jakarta-server</artifactId>
  <version>2.37.0</version>
</dependency>
<dependency>
  <groupId>org.apache.activemq</groupId>
  <artifactId>artemis-jakarta-client</artifactId>
  <version>2.37.0</version>
</dependency>
```

JSPのtaglibディレクティブのネームスペースをJakarta EE 10対応のネームスペースに変更する。

**修正前**
```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```

**修正後**
```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
```

Jakarta EE 10で提供されているネームスペースは[Jakarta Standard Tag Library 3.0](https://jakarta.ee/specifications/tags/3.0/)で確認できる。

<details>
<summary>keywords</summary>

Nablarch 5から6への移行, 移行ガイド概要, 6u2, 先行リリース, gsp-dba-maven-plugin, Bean Validation, JSTL, JAX-RS, JMS, Jakarta EE移行, 依存関係更新, hibernate-validator, jakarta.servlet.jsp.jstl, jersey-bom, artemis, taglib, ネームスペース変更, Jakarta EE 10, JSP, jakarta.tags.core, javax.servlet.jsp.jstl, taglib ディレクティブ

</details>

## Jakarta EE 10に対応

Nablarch 6はJakarta EE 10に対応している。Jakarta EEはJava EEがEclipse Foundationに移管された後の名前。Jakarta EE 9で名前空間が`javax.*`から`jakarta.*`に変更された。

Nablarch 5からNablarch 6へ移行するためには、NablarchのバージョンアップだけでなくプロジェクトのJakarta EE 10対応が必要。名前空間変更により後方互換性が維持されないため、動作にはJakarta EE 10対応のアプリケーションサーバが必要。

Domaアダプタが組み込まれている場合、依存関係の設定が必要。詳細は :ref:`doma_dependency` を参照。

新バージョンで推奨する実装方法への対応については :ref:`migration_doma2.44.0` を参照し、必要に応じて対応する。

JSR352に準拠したバッチアプリケーションは、JBeretと関連するライブラリの更新が複雑であるため、pom.xmlの依存関係を以下のように修正する必要がある。

**修正前**
```xml
<dependency>
  <groupId>org.glassfish</groupId>
  <artifactId>javax.el</artifactId>
  <version>...</version>
</dependency>

...

<!-- JBeretに最低限必要な依存関係 -->
<dependency>
  <groupId>org.jboss.spec.javax.batch</groupId>
  <artifactId>jboss-batch-api_1.0_spec</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>javax.inject</groupId>
  <artifactId>javax.inject</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>javax.enterprise</groupId>
  <artifactId>cdi-api</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>org.jboss.spec.javax.transaction</groupId>
  <artifactId>jboss-transaction-api_1.2_spec</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>org.jberet</groupId>
  <artifactId>jberet-core</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>org.jboss.marshalling</groupId>
  <artifactId>jboss-marshalling</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>org.jboss.logging</groupId>
  <artifactId>jboss-logging</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>org.jboss.weld</groupId>
  <artifactId>weld-core</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>org.wildfly.security</groupId>
  <artifactId>wildfly-security-manager</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>com.google.guava</groupId>
  <artifactId>guava</artifactId>
  <version>...</version>
</dependency>

<!-- JBeretをJavaSEで動作させるための依存関係 -->
<dependency>
  <groupId>org.jberet</groupId>
  <artifactId>jberet-se</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>org.jboss.weld.se</groupId>
  <artifactId>weld-se</artifactId>
  <version>...</version>
</dependency>

<!-- Logbackでログを出力している場合の依存関係 -->
<dependency>
  <groupId>org.slf4j</groupId>
  <artifactId>slf4j-api</artifactId>
  <version>...</version>
</dependency>
<dependency>
  <groupId>ch.qos.logback</groupId>
  <artifactId>logback-classic</artifactId>
  <version>...</version>
</dependency>
```

**修正後**
```xml
<dependency>
  <groupId>org.glassfish.expressly</groupId>
  <artifactId>expressly</artifactId>
  <version>5.0.0</version>
</dependency>

...

<!-- JBeretに最低限必要な依存関係 -->
<dependency>
  <groupId>jakarta.batch</groupId>
  <artifactId>jakarta.batch-api</artifactId>
</dependency>
<dependency>
  <groupId>jakarta.inject</groupId>
  <artifactId>jakarta.inject-api</artifactId>
</dependency>
<dependency>
  <groupId>jakarta.enterprise</groupId>
  <artifactId>jakarta.enterprise.cdi-api</artifactId>
</dependency>
<dependency>
  <groupId>jakarta.transaction</groupId>
  <artifactId>jakarta.transaction-api</artifactId>
</dependency>
<dependency>
  <groupId>org.jberet</groupId>
  <artifactId>jberet-core</artifactId>
  <version>2.1.4.Final</version>
</dependency>
<dependency>
  <groupId>org.jboss.marshalling</groupId>
  <artifactId>jboss-marshalling</artifactId>
  <version>2.1.3.Final</version>
</dependency>
<dependency>
  <groupId>org.jboss.logging</groupId>
  <artifactId>jboss-logging</artifactId>
  <version>3.5.3.Final</version>
</dependency>
<dependency>
  <groupId>org.jboss.weld</groupId>
  <artifactId>weld-core-impl</artifactId>
  <version>5.0.1.Final</version>
</dependency>
<dependency>
  <groupId>org.wildfly.security</groupId>
  <artifactId>wildfly-elytron-security-manager</artifactId>
  <version>2.2.2.Final</version>
</dependency>
<dependency>
  <groupId>com.google.guava</groupId>
  <artifactId>guava</artifactId>
  <version>32.1.1-jre</version>
</dependency>

<!-- JBeretをJavaSEで動作させるための依存関係 -->
<dependency>
  <groupId>org.jberet</groupId>
  <artifactId>jberet-se</artifactId>
  <version>2.1.4.Final</version>
</dependency>
<dependency>
  <groupId>org.jboss.weld.se</groupId>
  <artifactId>weld-se-core</artifactId>
  <version>5.0.1.Final</version>
</dependency>

<!-- Logbackでログを出力している場合の依存関係 -->
<dependency>
  <groupId>org.slf4j</groupId>
  <artifactId>slf4j-api</artifactId>
  <version>2.0.11</version>
</dependency>
<dependency>
  <groupId>ch.qos.logback</groupId>
  <artifactId>logback-classic</artifactId>
  <version>1.5.6</version>
</dependency>
```

<details>
<summary>keywords</summary>

Jakarta EE 10, javax から jakarta 名前空間変更, Java EE後継, アプリケーションサーバ要件, 後方互換性なし, Domaアダプタ, 依存関係設定, Jakarta EE移行, doma_dependency, migration_doma2.44.0, JSR352, JBeret, jberet-core, jberet-se, weld-core-impl, weld-se-core, wildfly-elytron-security-manager, jakarta.batch-api, jakarta.inject-api, jakarta.enterprise.cdi-api, jakarta.transaction-api, expressly, pom.xml, 依存関係, groupId変更, artifactId変更, javax.inject, javax.enterprise, jboss-batch-api_1.0_spec, weld-core, wildfly-security-manager, javax.el, org.glassfish.expressly, jboss-marshalling, jboss-logging, guava, slf4j-api, logback-classic, バッチアプリケーション移行

</details>

## 動作に必要なJavaの最低バージョンを17に変更

Nablarch 6のモジュールはJava 17でコンパイルされているため、動作させるにはJava 17以上が必要となる。

Micrometerアダプタが組み込まれ監視サービスと連携している場合、依存関係に追加しているMicrometerモジュールのバージョン更新が必要。詳細は [micrometer_collaboration](../../component/adapters/adapters-micrometer_adaptor.md) を参照。

JSR352バッチアプリケーションの実行時エラーへの対処方法。Nablarch 6移行後に発生する可能性があるエラーのうち、`NoClassDefFoundError` については次のセクションで説明する。

<details>
<summary>keywords</summary>

Java 17, 最低Javaバージョン要件, Java 17以上, コンパイル要件, Micrometerアダプタ, 監視サービス連携, バージョン更新, micrometer_collaboration, Jakarta EE移行, 実行時エラー, JSR352バッチ, NoClassDefFoundError, WeldException, エラー対処

</details>

## 前提条件

手順はNablarch 5の最新版へのバージョンアップ済みであることを前提としている。古いバージョンのプロジェクトは先にNablarch 5の最新版へバージョンアップすること。Nablarch 5の最新版へのバージョンアップに必要な修正内容は[Nablarch 5のリリースノート](https://nablarch.github.io/docs/5-LATEST/doc/releases/index.html)を参照。

動作にはJava 17以上およびJakarta EE 10対応のアプリケーションサーバが必要。

> **補足**: Nablarch 5の最新版バージョンアップの他に、Java 17以上で使用するための対応も必要。対応内容は[Nablarch 5のセットアップ手順](https://nablarch.github.io/docs/5-LATEST/doc/application_framework/application_framework/blank_project/FirstStep.html)を参照。

アーキタイプから作ったプロジェクトには[gsp-dba-maven-plugin](https://github.com/coastland/gsp-dba-maven-plugin)があらかじめ組み込まれている。`generate-entity`が生成するエンティティクラスにはJPAなどJava EEのアノテーションが設定されるため、そのままではJakarta EE環境で使用不可。

gsp-dba-maven-plugin 5.1.0でJakarta EEおよびNablarch 6u2に対応したため、`pom.xml`の`<version>`を`5.1.0`に変更する。

```xml
<plugin>
  <groupId>jp.co.tis.gsp</groupId>
  <artifactId>gsp-dba-maven-plugin</artifactId>
  <version>5.1.0</version>
  <configuration>
  ...
</plugin>
```

バージョンアップ後はJava 17設定が組み込まれるため、[Java 17での設定ガイド](https://github.com/coastland/gsp-dba-maven-plugin/tree/4.x.x-main?tab=readme-ov-file#java17%E3%81%A7%E3%81%AE%E8%A8%AD%E5%AE%9A)に沿って追加した依存関係は削除する。

Jakarta EE対応の`generate-entity`を使用するには`dependency`とJVM引数の追加が必要。詳細は[gsp-dba-maven-pluginのガイド](https://github.com/coastland/gsp-dba-maven-plugin?tab=readme-ov-file#generate-entity)を参照。

以下のスタックトレースが出力されてエラーになる場合、クラスパスの順序で`slf4j-nablarch-adaptor`をLogbackより後にすることで解消できる。

```text
org.jboss.weld.exceptions.WeldException
    at org.jboss.weld.executor.AbstractExecutorServices.checkForExceptions (AbstractExecutorServices.java:82)
    ...
Caused by: java.lang.NoClassDefFoundError
    at jdk.internal.reflect.NativeConstructorAccessorImpl.newInstance0 (Native Method)
    ...
Caused by: java.lang.NoClassDefFoundError: Could not initialize class org.jboss.weld.logging.BeanLogger
    at org.jboss.weld.util.Beans.getBeanConstructor (Beans.java:279)
```

Mavenで実行する場合、`pom.xml`上の`slf4j-nablarch-adaptor`の位置をLogbackより下に配置することで順序を変更できる。

```xml
<dependency>
  <groupId>ch.qos.logback</groupId>
  <artifactId>logback-classic</artifactId>
  <version>...</version>
</dependency>

<!-- Logbackより下にslf4j-nablarch-adaptorを配置する -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
  <scope>runtime</scope>
</dependency>
```

<details>
<summary>keywords</summary>

前提条件, Nablarch 5最新版へのバージョンアップ, Java 17以上, Jakarta EE 10対応アプリケーションサーバ, gsp-dba-maven-plugin, generate-entity, Jakarta EE対応, エンティティ生成, JPA, 5.1.0, Nablarch 6u2, NoClassDefFoundError, WeldException, slf4j-nablarch-adaptor, クラスパス順序, Logback, BeanLogger, jboss-logging, AbstractExecutorServices

</details>

## 移行手順の概要

Nablarch 5のプロジェクトをNablarch 6へ移行するために必要な修正：

1. **Nablarchのバージョンアップ**: NablarchのバージョンをBOMで5から6に変更
2. **Jakarta EE対応**: Jakarta EE 10対応。Jakarta EE 9の名前空間変更（`javax.*`→`jakarta.*`）対応と、Java EE依存ライブラリのJakarta EE対応版への変更を含む

waitt-maven-pluginはJakarta EE非対応のため、Jakarta EEに対応したjetty-ee10-maven-pluginに変更する。

**修正前:**
```xml
<plugin>
  <groupId>net.unit8.waitt</groupId>
  <artifactId>waitt-maven-plugin</artifactId>
  <version>1.2.3</version>
  <configuration>
    <servers>
      <server>
        <groupId>net.unit8.waitt.server</groupId>
        <artifactId>waitt-tomcat8</artifactId>
        <version>1.2.3</version>
      </server>
    </servers>
  </configuration>
</plugin>
```

**修正後:**
```xml
<plugin>
  <groupId>org.eclipse.jetty.ee10</groupId>
  <artifactId>jetty-ee10-maven-plugin</artifactId>
  <version>12.0.12</version>
</plugin>
```

起動コマンド:
```batch
mvn jetty:run
```

| Java EE | 省略名 | 名前空間プレフィックス | Jakarta EE |
|---|---|---|---|
| Java Servlet | | `javax.servlet` | [Jakarta Servlet](https://jakarta.ee/specifications/servlet/) |
| JavaServer Faces | JSF | `javax.faces` | [Jakarta Faces](https://jakarta.ee/specifications/faces/) |
| Java API for WebSocket | | `javax.websocket` | [Jakarta WebSocket](https://jakarta.ee/specifications/websocket/) |
| Concurrency Utilities for Java EE | | `javax.enterprise.concurrent` | [Jakarta Concurrency](https://jakarta.ee/specifications/concurrency/) |
| Interceptors | | `javax.interceptor` | [Jakarta Interceptors](https://jakarta.ee/specifications/interceptors/) |
| Java Authentication SPI for Containers | JASPIC | `javax.security.auth.message` | [Jakarta Authentication](https://jakarta.ee/specifications/authentication/) |
| Java Authorization Contract for Containers | JACC | `javax.security.jacc` | [Jakarta Authorization](https://jakarta.ee/specifications/authorization/) |
| Java EE Security API | | `javax.security.enterprise` | [Jakarta Security](https://jakarta.ee/specifications/security/) |
| Java Message Service | JMS | `javax.jms` | [Jakarta Messaging](https://jakarta.ee/specifications/messaging/) |
| Java Persistence API | JPA | `javax.persistence` | [Jakarta Persistence](https://jakarta.ee/specifications/persistence/) |
| Java Transaction API | JTA | `javax.transaction` | [Jakarta Transactions](https://jakarta.ee/specifications/transactions/) |
| Batch Application for the Java Platform | jBatch | `javax.batch` | [Jakarta Batch](https://jakarta.ee/specifications/batch/) |
| JavaMail | | `javax.mail` | [Jakarta Mail](https://jakarta.ee/specifications/mail/) |
| Java EE Connector Architecture | JCA | `javax.resource` | [Jakarta Connectors](https://jakarta.ee/specifications/connectors/) |
| Common Annotations for the Java Platform | | `javax.annotation` | [Jakarta Annotations](https://jakarta.ee/specifications/annotations/) |
| JavaBeans Activation Framework | JAF | `javax.activation` | [Jakarta Activation](https://jakarta.ee/specifications/activation/) |
| Bean Validation | | `javax.validation` | [Jakarta Bean Validation](https://jakarta.ee/specifications/bean-validation/) |
| Expression Language | EL | `javax.el` | [Jakarta Expression Language](https://jakarta.ee/specifications/expression-language/) |
| Enterprise JavaBeans | EJB | `javax.ejb` | [Jakarta Enterprise Beans](https://jakarta.ee/specifications/enterprise-beans/) |
| Java Architecture for XML Binding | JAXB | `javax.xml.bind` | [Jakarta XML Binding](https://jakarta.ee/specifications/xml-binding/) |
| Java API for JSON Binding | JSON-B | `javax.json.bind` | [Jakarta JSON Binding](https://jakarta.ee/specifications/jsonb/) |
| Java API for JSON Processing | JSON-P | `javax.json`, `javax.json.spi`, `javax.json.stream` | [Jakarta JSON Processing](https://jakarta.ee/specifications/jsonp/) |
| JavaServer Pages | JSP | `javax.servlet.jsp` | [Jakarta Server Pages](https://jakarta.ee/specifications/pages/) |
| Java API for XML-Based Web Services | JAX-WS | `javax.xml.ws` | [Jakarta XML Web Services](https://jakarta.ee/specifications/xml-web-services/) |
| Java API for RESTful Web Services | JAX-RS | `javax.ws.rs` | [Jakarta RESTful Web Services](https://jakarta.ee/specifications/restful-ws/) |
| JavaServer Pages Standard Tag Library | JSTL | `javax.servlet.jsp.jstl` | [Jakarta Standard Tag Library](https://jakarta.ee/specifications/tags/) |
| Contexts and Dependency Injection for Java | CDI | `javax.decorator`, `javax.enterprise.context`, `javax.enterprise.event`, `javax.enterprise.inject`, `javax.enterprise.util` | [Jakarta Contexts and Dependency Injection](https://jakarta.ee/specifications/cdi/) |
| Dependency Injection for Java | | `javax.inject` | [Jakarta Dependency Injection](https://jakarta.ee/specifications/dependency-injection/) |

<details>
<summary>keywords</summary>

移行手順概要, Nablarchバージョンアップ, Jakarta EE対応, 移行に必要な2つの修正, waitt-maven-plugin, jetty-ee10-maven-plugin, 組み込みサーバ, Jakarta EE非対応, mvn jetty:run, Jetty 12, Java EE, Jakarta EE, 仕様対応表, javax, jakarta, 名前空間プレフィックス変更, JSF, JPA, JTA, CDI, JAX-RS, JAXB, JMS, JSTL, EJB, JASPIC, JACC, JAF, JSON-B, JSON-P, JCA, jBatch, EL, JAX-WS

</details>

## 移行手順の詳細

プロジェクトによっては不要な手順が含まれる場合がある。例えば、waitt-to-jettyセクションやupdate-ntf-jettyセクションはウェブプロジェクト固有の手順なので、バッチプロジェクトでは読み飛ばして問題ない。

NTFを使用するウェブアプリケーションで`nablarch-testing-jetty6`が使用されている場合、Jetty 6はJakarta EE非対応のため`nablarch-testing-jetty12`に変更する。

> **補足**: Java 11以上のプロジェクトで`nablarch-testing-jetty9`を使用している場合も、Jakarta EE非対応のため`nablarch-testing-jetty12`に変更が必要。

**1. `pom.xml`のartifactIdを変更する:**

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-jetty12</artifactId>
  <scope>test</scope>
</dependency>
```

**2. `HttpServerFactory`のコンポーネント定義を変更する:**

修正前:
```xml
<component name="httpServerFactory" class="nablarch.fw.web.httpserver.HttpServerFactoryJetty6"/>
```

修正後:
```xml
<component name="httpServerFactory" class="nablarch.fw.web.httpserver.HttpServerFactoryJetty12"/>
```

nablarch-example-webの場合、上記設定は`src/test/resources/unit-test.xml`に存在する。

<details>
<summary>keywords</summary>

移行手順詳細, ウェブプロジェクト固有手順, バッチプロジェクト, waitt-to-jetty, update-ntf-jetty, nablarch-testing-jetty6, nablarch-testing-jetty12, nablarch-testing-jetty9, NTF, Nablarch Testing Framework, HttpServerFactoryJetty12, HttpServerFactoryJetty6, unit-test.xml

</details>

## Nablarchのバージョンアップ

`pom.xml`のNablarch BOMの`<version>`を`6u2`に変更する：

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.nablarch.profile</groupId>
      <artifactId>nablarch-bom</artifactId>
      <version>6u2</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

javax名前空間からjakarta名前空間への変更手順:

1. `javax`名前空間でimportしている部分がコンパイルエラーになるため、`jakarta`名前空間に変更する
2. コンパイルエラーにならない場所（文字列キー、JSP、設定ファイル内）も対象となるため、プロジェクト全体を`javax`でGrep検索する
3. 検索にヒットした箇所がJava EEの名前空間かどうか判定する
4. Java EEの名前空間であれば`javax`を`jakarta`に置換する

`javax`でヒットしてもJava EEの名前空間でない場合がある。例：`javax.crypto.SecretKeyFactory`は標準ライブラリの暗号処理クラスであり置換対象外。各仕様の名前空間は [java_ee_jakarta_ee_comparation](#) を参照すること。

コンパイルエラーにならない置換対象の例:
- 文字列キー: `javax.servlet.forward.request_uri` → `jakarta.servlet.forward.request_uri`
- import文: `import javax.validation.ConstraintValidator;` → `import jakarta.validation.ConstraintValidator;`

<details>
<summary>keywords</summary>

nablarch-bom, pom.xml BOM, 6u2, Nablarchバージョンアップ手順, com.nablarch.profile, javax, jakarta, 名前空間変更, import文, Grep検索, Jakarta EE 9, javax.servlet.forward.request_uri, jakarta.servlet.forward.request_uri, ConstraintValidator

</details>

## Jakarta EE対応

Java EEのAPI依存関係（`dependency`）をJakarta EEのものに変更する必要がある。Java EEのAPIの`dependency`は提供元やバージョンによって統一されていないため、`groupId`などから機械的に判断できない。どの`dependency`がJava EEのAPIなのかは`groupId`や`artifactId`、jarに含まれるクラスから判断する必要がある。

バージョン管理簡素化のためJakarta EE BOMの使用を推奨する（個別バージョン指定が不要になる）：

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>jakarta.platform</groupId>
      <artifactId>jakarta.jakartaee-bom</artifactId>
      <version>10.0.0</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

ここに記載されていない依存関係については、付録のJava EE/Jakarta EE対応表を参照。各仕様のページにMaven coordinatesが記載されている（例: [Jakarta Servlet 6.0仕様ページ](https://jakarta.ee/specifications/servlet/6.0/#details)）。

`web.xml`等のXMLファイルのスキーマをJakarta EE 10対応のものに変更する。提供されているスキーマは[Jakarta EE XML Schemas](https://jakarta.ee/xml/ns/jakartaee/#10)で確認できる。

**修正前:**
```xml
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
```

**修正後:**
```xml
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
                             web-app_6_0.xsd"
         version="6.0">
```

<details>
<summary>keywords</summary>

Jakarta EE BOM, jakarta.jakartaee-bom, jakarta.platform, Java EE依存関係変更方針, BOM推奨, web.xml, XMLスキーマ, Jakarta EE 10, jakartaee, web-app_6_0.xsd, xmlns, xsi:schemaLocation

</details>

## Java EEの依存関係をJakarta EEに変更する

Java EEのAPIをJakarta EEに変更する際の`groupId`/`artifactId`の対応（Jakarta EE BOMを使用する場合はバージョン指定不要）：

| API | 修正前 (groupId:artifactId) | 修正後 (groupId:artifactId) | scope |
|---|---|---|---|
| Java Servlet → Jakarta Servlet | `javax.servlet:javax.servlet-api` | `jakarta.servlet:jakarta.servlet-api` | provided |
| JSP → Jakarta Server Pages | `javax.servlet.jsp:javax.servlet.jsp-api` | `jakarta.servlet.jsp:jakarta.servlet.jsp-api` | provided |
| JSTL → Jakarta Standard Tag Library | `javax.servlet.jsp.jstl:javax.servlet.jsp.jstl-api` | `jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api` | |
| JPA → Jakarta Persistence | `org.apache.geronimo.specs:geronimo-jpa_2.0_spec` | `jakarta.persistence:jakarta.persistence-api` | |
| JAX-RS → Jakarta RESTful Web Services | `javax.ws.rs:javax.ws.rs-api` | `jakarta.ws.rs:jakarta.ws.rs-api` | |
| Common Annotations → Jakarta Annotations | `javax.annotation:javax.annotation-api` | `jakarta.annotation:jakarta.annotation-api` | |

<details>
<summary>keywords</summary>

javax.servlet, jakarta.servlet, javax.servlet.jsp, jakarta.persistence, javax.ws.rs, jakarta.ws.rs, javax.annotation, jakarta.annotation, Jakarta Servlet, Jakarta Server Pages, JSTL, JPA, JAX-RS, Jakarta Annotations

</details>

## 付録

Java EEとJakarta EEの仕様の対応表（`java_ee_jakarta_ee_comparation`）を含む付録セクション。ここに記載されていない依存関係の変更を調べる際の参考として記載されている。

<details>
<summary>keywords</summary>

付録, Java EE, Jakarta EE, java_ee_jakarta_ee_comparation, 仕様対応表参照

</details>
