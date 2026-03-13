# Java17で使用する場合のセットアップ方法

**公式ドキュメント**: [Java17で使用する場合のセットアップ方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java17.html)

## Java17で使用する場合のセットアップ方法

ブランクプロジェクトをJava17で使用する場合、各ブランクプロジェクトの疎通確認前に以下の手順を行う。

1. 依存モジュールの追加
2. gsp-dba-maven-pluginがJava17で動くように設定する
3. 自動テストで使用するJettyのモジュール変更（ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ）
4. --add-opensオプションの追加（JSR352に準拠したバッチプロジェクトの場合のみ）
5. Javaバージョンの変更

<details>
<summary>keywords</summary>

Java17セットアップ, ブランクプロジェクトJava17対応, 疎通確認前準備, Java17必須手順

</details>

## 依存モジュールの追加

Java 11でJAXBなど一部モジュールが標準ライブラリから削除されたため、作成したブランクプロジェクトのPOMに以下のモジュールを追加する。

:ref:`setup_blank_project_for_Java11_add_dependencies` との相違点:
- `jaxb-impl` のバージョンに `2.3.5` を指定する（Java 17で強化されたカプセル化への対応がこのバージョンに含まれるため）
- `jaxb-api` アーティファクトは除外する（`jaxb-impl 2.3.5` が `jakarta.xml.bind-api` という別のアーティファクトを推移的に使用するため）

```xml
<dependencies>
  <dependency>
    <groupId>com.sun.activation</groupId>
    <artifactId>javax.activation</artifactId>
    <version>1.2.0</version>
  </dependency>
  <dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-core</artifactId>
    <version>2.3.0</version>
  </dependency>
  <dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-impl</artifactId>
    <version>2.3.5</version>
  </dependency>
  <dependency>
    <groupId>javax.annotation</groupId>
    <artifactId>javax.annotation-api</artifactId>
    <version>1.3.2</version>
  </dependency>
</dependencies>
```

<details>
<summary>keywords</summary>

JAXB依存モジュール追加, javax.activation, jaxb-core, jaxb-impl, javax.annotation-api, Java17依存関係, JAXBバージョン2.3.5, jakarta.xml.bind-api

</details>

## gsp-dba-maven-pluginがJava17で動くように設定する

gsp-dba-maven-pluginのJava17対応設定は、[Java 17 での設定](https://github.com/coastland/gsp-dba-maven-plugin/tree/4.x.x-main?tab=readme-ov-file#java17%E3%81%A7%E3%81%AE%E8%A8%AD%E5%AE%9A) を参照して設定する。

<details>
<summary>keywords</summary>

gsp-dba-maven-plugin, Java17設定, DBアクセス設定, Maven plugin Java17

</details>

## 自動テストで使用するJettyのモジュール変更(ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ)

ブランクプロジェクトのデフォルトJettyバージョンはJava17非対応のため、以下の2ファイルを変更する。

**pom.xml**: `nablarch-testing-jetty6` を `nablarch-testing-jetty9` に変更する。

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-jetty9</artifactId>
  <scope>test</scope>
</dependency>
```

**src/test/resources/unit-test.xml**: `HttpServerFactoryJetty6` を `HttpServerFactoryJetty9` に変更する。

```xml
<component name="httpServerFactory" class="nablarch.fw.web.httpserver.HttpServerFactoryJetty9"/>
```

<details>
<summary>keywords</summary>

Jettyモジュール変更, nablarch-testing-jetty9, HttpServerFactoryJetty9, unit-test.xml, ウェブプロジェクト自動テスト, RESTfulウェブサービス自動テスト

</details>

## --add-opensオプションの追加（JSR352に準拠したバッチプロジェクトの場合のみ）

Java 17のカプセル化強化により、デフォルトでは内部APIをリフレクションで使用できなくなった。この変更に対する正規の対応は代替APIへの移行となるが、JSR352の実装であるjBeretにはこの対応が入っていない。そのため、JSR352に準拠したバッチプロジェクトでJava17を動かすためには、回避策として以下のJVMオプションを設定して内部APIをリフレクションで使用できるようにする必要がある。

- `--add-opens java.base/java.lang=ALL-UNNAMED`
- `--add-opens java.base/java.security=ALL-UNNAMED`

> **補足**: このJVMオプションの指定は、jBeretを組み込んでいるWildFlyでも使用されている方法である（参考: [Running WildFly with SE 17](https://www.wildfly.org/news/2021/12/16/WildFly26-Final-Released/#running-wildfly-with-se-17)）。

```batch
java --add-opens java.base/java.lang=ALL-UNNAMED ^
     --add-opens java.base/java.security=ALL-UNNAMED ^
     -jar target\myapp-batch-ee-0.1.0\myapp-batch-ee-0.1.0.jar ^
     sample-batchlet
```

> **補足**: Mavenから実行する場合は、環境変数 [MAVEN_OPTS](https://maven.apache.org/configure.html#MAVEN_OPTS_environment_variable.3A) を使うことでJVMオプションを設定できる。

<details>
<summary>keywords</summary>

--add-opens, JVMオプション, jBeret, JSR352バッチプロジェクト, カプセル化対応, java.base/java.lang, java.base/java.security, MAVEN_OPTS, WildFly, 回避策

</details>

## Javaバージョンの変更

ブランクプロジェクトではソース及びclassファイルが準拠するJavaのバージョンとしてJava8が設定されているため、pom.xmlを以下のように変更する。

```xml
<java.version>17</java.version>
```

<details>
<summary>keywords</summary>

Javaバージョン変更, java.version, pom.xmlバージョン設定, Java8からJava17

</details>
