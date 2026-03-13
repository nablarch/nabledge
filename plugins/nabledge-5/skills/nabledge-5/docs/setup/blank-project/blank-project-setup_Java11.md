# Java11で使用する場合のセットアップ方法

**公式ドキュメント**: [Java11で使用する場合のセットアップ方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java11.html)

## Java11で使用する場合のセットアップ方法

Java 11でブランクプロジェクトを使用する場合、疎通確認前に以下の手順が必要:

1. 依存モジュールの追加
2. gsp-dba-maven-pluginが使用する依存モジュールの追加
3. 自動テストで使用するJettyのモジュール変更(ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ)
4. Javaバージョンの変更

> **補足**: コンテナ用のブランクプロジェクトはJava11を前提としており、本章の修正があらかじめ適用されている。コンテナ用ブランクプロジェクトでは本章の手順は不要。

<details>
<summary>keywords</summary>

Java11, ブランクプロジェクト, セットアップ手順, コンテナ用ブランクプロジェクト, 疎通確認

</details>

## 依存モジュールの追加

Java 11でJAXBなど一部のモジュールが標準ライブラリから削除されたため、POMに以下を追加する:

```xml
<dependency>
  <groupId>com.sun.activation</groupId>
  <artifactId>javax.activation</artifactId>
  <version>1.2.0</version>
</dependency>
<dependency>
  <groupId>javax.xml.bind</groupId>
  <artifactId>jaxb-api</artifactId>
  <version>2.3.0</version>
</dependency>
<dependency>
  <groupId>com.sun.xml.bind</groupId>
  <artifactId>jaxb-core</artifactId>
  <version>2.3.0</version>
</dependency>
<dependency>
  <groupId>com.sun.xml.bind</groupId>
  <artifactId>jaxb-impl</artifactId>
  <version>2.3.0</version>
</dependency>
<dependency>
  <groupId>javax.annotation</groupId>
  <artifactId>javax.annotation-api</artifactId>
  <version>1.3.2</version>
</dependency>
```

<details>
<summary>keywords</summary>

javax.activation, jaxb-api, jaxb-core, jaxb-impl, javax.annotation-api, JAXB, 依存モジュール追加, Java11

</details>

## gsp-dba-maven-pluginが使用する依存モジュールの追加

gsp-dba-maven-pluginのJava 11対応設定は以下を参照:

[Java 11 での設定](https://github.com/coastland/gsp-dba-maven-plugin/tree/4.x.x-main?tab=readme-ov-file#java11%E3%81%A7%E3%81%AE%E8%A8%AD%E5%AE%9A)

<details>
<summary>keywords</summary>

gsp-dba-maven-plugin, Java11設定, 依存モジュール

</details>

## 自動テストで使用するJettyのモジュール変更(ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ)

ブランクプロジェクトのデフォルトJettyはJava11非対応。ウェブプロジェクトまたはRESTfulウェブサービスプロジェクトの場合、以下2ファイルを変更する:

**pom.xml** (`nablarch-testing-jetty6`を以下に変更):

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-jetty9</artifactId>
  <scope>test</scope>
</dependency>
```

**src/test/resources/unit-test.xml** (`HttpServerFactoryJetty6`を以下に変更):

```xml
<component name="httpServerFactory" class="nablarch.fw.web.httpserver.HttpServerFactoryJetty9"/>
```

<details>
<summary>keywords</summary>

Jetty, nablarch-testing-jetty9, nablarch-testing-jetty6, HttpServerFactoryJetty9, HttpServerFactoryJetty6, 自動テスト, ウェブプロジェクト, RESTfulウェブサービス, unit-test.xml

</details>

## Javaバージョンの変更

ブランクプロジェクトのデフォルトはJava8設定。pom.xmlのJavaバージョンを以下に変更する:

```xml
<java.version>11</java.version>
```

<details>
<summary>keywords</summary>

java.version, Javaバージョン設定, pom.xml, Java11

</details>
