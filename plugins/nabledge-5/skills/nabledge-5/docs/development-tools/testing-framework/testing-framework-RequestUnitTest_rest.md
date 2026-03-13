# リクエスト単体テスト（RESTfulウェブサービス）

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/RequestUnitTest_rest.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/RestMockHttpRequest.html)

## ステータスコード

**クラス**: `RestTestSupport` / `SimpleRestTestSupport`

`SimpleRestTestSupport` は事前準備補助機能・実行・結果確認について `RestTestSupport` と同じ機能を持つ。

```java
void assertStatusCode(String message, HttpResponse.Status expected, HttpResponse response);
```

- `message`: アサート失敗時のメッセージ
- `expected`: 期待するステータス（`HttpResponse.Status` のEnum）
- `response`: 内蔵サーバから返却された `HttpResponse` インスタンス

期待するステータスコードとレスポンスのステータスコードが一致しない場合、アサート失敗となる。

<details>
<summary>keywords</summary>

assertStatusCode, RestTestSupport, SimpleRestTestSupport, ステータスコードアサート, HTTPステータスコード検証, HttpResponse.Status, HttpResponse

</details>

## レスポンスボディ

レスポンスボディの検証はフレームワークでは仕組みを用意していない。各プロジェクトの要件に合わせて [JSONAssert](https://jsonassert.skyscreamer.org/)、[json-path-assert](https://github.com/json-path/JsonPath/tree/master/json-path-assert)、[XMLUnit](https://github.com/xmlunit/user-guide/wiki) などのライブラリを使用すること。

> **補足**: RESTfulウェブサービスのブランクプロジェクトを作成した場合、上記ライブラリがpom.xmlに記載されている。必要に応じてライブラリの削除や差し替えを行うこと。

**レスポンスボディ検証補助機能**

**クラス**: `RestTestSupport` / `SimpleRestTestSupport`

`SimpleRestTestSupport` は事前準備補助機能・実行・結果確認について `RestTestSupport` と同じ機能を持つ。

```java
String readTextResource(String fileName)
```

テストクラスと同じ名前のディレクトリにあるリソースからファイルを読み込み `String` に変換する。

| ファイルの種類 | 配置ディレクトリ | ファイル名 |
|---|---|---|
| テストクラスソースファイル | `<PROJECT_ROOT>/test/java/com/example/` | `SampleTest.java` |
| レスポンスボディの期待値ファイル | `<PROJECT_ROOT>/test/resources/com/example/SampleTest` | `response.json`（引数のfileNameに指定） |

<details>
<summary>keywords</summary>

readTextResource, レスポンスボディ検証, JSONAssert, json-path-assert, XMLUnit, RestTestSupport, SimpleRestTestSupport, レスポンス検証補助

</details>

## 概要・設定・テスト実行

## 概要

リクエスト単体テスト(REST)では内蔵サーバを使用してテストを行う。RESTfulウェブサービス用実行基盤は他の実行基盤よりも必要なモジュールが多い。

**主なクラス・リソース**:

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ作成 |
| テストデータ（Excelファイル） | テーブルに格納する準備データや期待する結果、HTTPパラメータなどテストデータを記載する | 必要に応じてテストクラスにつき１つ作成 |
| テスト対象クラス(Action) | テスト対象のクラス（Action以降の業務ロジックを実装する各クラスを含む） | 取引につき1クラス作成 |
| DbAccessTestSupport | 準備データ投入などデータベースを使用するテストに必要な機能を提供する | － |
| HttpServer | 内蔵サーバ。サーブレットコンテナとして動作する。 | － |
| RestTestSupport | 内蔵サーバの起動やリクエスト単体テストで必要となるステータスコードのアサートを提供する | － |

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-rest</artifactId>
  <scope>test</scope>
</dependency>
<dependency>
  <groupId>com.nablarch.configuration</groupId>
  <artifactId>nablarch-testing-default-configuration</artifactId>
  <scope>test</scope>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-jetty6</artifactId>
  <scope>test</scope>
</dependency>
```

> **重要**: `nablarch-testing-rest` はテスティングフレームワーク（`nablarch-testing`）に依存している。上記モジュールを追加することでテスティングフレームワークのAPIも同時に使用できる。

> **補足**: Java11を使用している場合は「自動テストで使用するJettyのモジュール変更」の通り内蔵サーバを差し替えること。

## 設定

`src/test/resources/unit-test.xml` に以下を追加する:

```xml
<import file="nablarch/test/rest-request-test.xml"/>
```

> **補足**: Nablarch5u18以降のアーキタイプからRESTfulウェブサービスのブランクプロジェクトを作成した場合は既に設定済み。ウェブプロジェクトやバッチプロジェクトでは追加が必要。

## スーパークラスの選択

**`SimpleRestTestSupport`**: データベース関連機能が不要な場合に使用。`dbInfo` または `testDataParser` コンポーネントの定義が不要になる。事前準備補助機能・実行・結果確認については `RestTestSupport` と同じ機能を持つ。

**`RestTestSupport`**: `SimpleRestTestSupport` を継承し、`DbAccessTestSupport` への委譲によりデータベース関連機能を追加。

> **重要**: RESTfulウェブサービスの単体テストでは、`assertTableEquals` 等でDBテーブル内容を確認するよりも、公開APIに問い合わせてデータを確認する方法を推奨する。

以下のメソッドは `DbAccessTestSupport` から委譲されない（リクエスト単体テスト(REST)では不要のため）:
- `beginTransactions()`、`commitTransactions()`、`endTransactions()`
- `setThreadContextValues(String sheetName, String id)`
- `assertSqlResultSetEquals(...)`、`assertSqlRowEquals(...)`

## 事前準備補助機能（RestMockHttpRequest生成）

**クラス**: `RestTestSupport` / `SimpleRestTestSupport`

```java
RestMockHttpRequest get(String uri)
RestMockHttpRequest post(String uri)
RestMockHttpRequest put(String uri)
RestMockHttpRequest patch(String uri)
RestMockHttpRequest delete(String uri)
RestMockHttpRequest newRequest(String httpMethod, String uri)  // 上記以外のHTTPメソッド用
```

> **補足**: `RestMockHttpRequest` は流れるようなインターフェイスでパラメータ設定可能。例: `post("/projects").setHeader("Authorization","Bearer token").setCookie(cookie)` 詳細はJavadocを参照。

## 実行

内蔵サーバを起動してリクエストを送信するメソッド:

```java
HttpResponse sendRequest(HttpRequest request)
```

<details>
<summary>keywords</summary>

SimpleRestTestSupport, RestTestSupport, nablarch-testing-rest, nablarch-testing-jetty6, nablarch-testing-default-configuration, DbAccessTestSupport, RestMockHttpRequest, sendRequest, 内蔵サーバ, HTTPリクエスト作成, モジュール設定, rest-request-test.xml, HttpRequest, HttpResponse, HttpServer

</details>

## 各種設定値

環境設定に依存する設定値はコンポーネント設定ファイルで変更できる。

| 設定項目名 | 説明 | デフォルト値 |
|---|---|---|
| webBaseDir | ウェブアプリケーションのルートディレクトリ | `src/main/webapp` |
| webFrontControllerKey | Webフロントコントローラーのリポジトリキー | `webFrontController` |

**webBaseDir（複数指定）**: PJ共通のwebモジュールが存在する場合、カンマ区切りで複数ディレクトリを設定可能。先頭から順にリソースが読み込まれる。

```xml
<component name="restTestConfiguration" class="nablarch.test.core.http.RestTestConfiguration">
  <property name="webBaseDir" value="/path/to/web-a/,/path/to/web-common"/>
</component>
```

**webFrontControllerKey（複数コントローラー構成）**: Webフロントコントローラーをデフォルトの `webFrontController` 以外の名前で登録する場合に設定する。デフォルト設定では `webFrontController`（ウェブアプリケーション向け）が使用されるため、ウェブサービス向けコントローラーを使用するには以下のように上書きする:

```xml
<import file="nablarch/test/rest-request-test.xml"/>
<!--  デフォルトのコンポーネント定義をimport後に上書きする。-->
<component name="restTestConfiguration" class="nablarch.test.core.http.RestTestConfiguration">
  <property name="webFrontControllerKey" value="jaxrsController"/>
</component>
```

<details>
<summary>keywords</summary>

webBaseDir, webFrontControllerKey, RestTestConfiguration, WebFrontController, jaxrsController, コンポーネント設定, 複数webモジュール

</details>
