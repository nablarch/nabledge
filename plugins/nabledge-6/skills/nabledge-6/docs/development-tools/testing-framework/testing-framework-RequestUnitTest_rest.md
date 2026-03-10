# リクエスト単体テスト（RESTfulウェブサービス）

## ステータスコード

**クラス**: `RestTestSupport`

```java
void assertStatusCode(String message, HttpResponse.Status expected, HttpResponse response);
```

| 引数 | 説明 |
|---|---|
| `message` | アサート失敗時のメッセージ |
| `expected` | 期待するステータス（`HttpResponse.Status`のEnum） |
| `response` | 内蔵サーバから返却された`HttpResponse`インスタンス |

期待値とレスポンスのステータスコードが不一致の場合、アサート失敗となる。

## レスポンスボディ

フレームワーク自体はレスポンスボディ検証の仕組みを提供しない。各プロジェクトの要件に合わせて外部ライブラリを使用すること:
- [JSONAssert](https://jsonassert.skyscreamer.org/)
- [json-path-assert](https://github.com/json-path/JsonPath/tree/master/json-path-assert)
- [XMLUnit](https://github.com/xmlunit/user-guide/wiki)

> **補足**: RESTfulウェブサービスのブランクプロジェクトにはpom.xmlに上記ライブラリが記載済み。必要に応じて削除・差し替えを行うこと。

**補助機能**: 外部ライブラリが期待値として`String`のみ受け付ける場合に対応するため、ファイルを読み込んで`String`に変換するメソッドを提供:

```java
String readTextResource(String fileName)
```

テストクラスと同名ディレクトリのリソースからファイルを読み込む:

| ファイルの種類 | 配置ディレクトリ | ファイル名 |
|---|---|---|
| テストクラスソースファイル | `<PROJECT_ROOT>/test/java/com/example/` | `SampleTest.java` |
| レスポンスボディ期待値ファイル | `<PROJECT_ROOT>/test/resources/com/example/SampleTest` | `response.json`（引数に指定） |

## 概要・構造

## 主なクラス・リソースと作成単位

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ作成 |
| テストデータ（Excelファイル） | 準備データや期待する結果、HTTPパラメータなどテストデータを記載する | 必要に応じてテストクラスにつき１つ作成 |
| テスト対象クラス(Action) | テスト対象のクラス（Action以降の業務ロジックを実装する各クラスを含む） | 取引につき1クラス作成 |
| DbAccessTestSupport | 準備データ投入などデータベースを使用するテストに必要な機能を提供する | － |
| HttpServer | 内蔵サーバ。サーブレットコンテナとして動作する | － |
| RestTestSupport | 内蔵サーバの起動やリクエスト単体テストで必要となるステータスコードのアサートを提供する | － |

## モジュール

RESTfulウェブサービス用実行基盤は他の実行基盤より多くのモジュールが必要。

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
  <artifactId>nablarch-testing-jetty12</artifactId>
  <scope>test</scope>
</dependency>
```

> **重要**: `nablarch-testing-rest`は`nablarch-testing`に依存。上記モジュール追加でテスティングフレームワークのAPIも同時に使用可能。

## 設定

`src/test/resources/unit-test.xml`に以下を追加:

```xml
<import file="nablarch/test/rest-request-test.xml"/>
```

> **補足**: Nablarch5u18以降のアーキタイプからRESTfulウェブサービスのブランクプロジェクトを作成した場合は設定済み。ウェブプロジェクトやバッチプロジェクトでは追加が必要。

## テストスーパークラス

**クラス**: `SimpleRestTestSupport`

DBが不要なテストで使用する。実行・結果確認機能はRestTestSupportと同じ。

> **補足**: `RestTestSupport`を使用する場合、`dbInfo`または`testDataParser`のコンポーネント定義が必要。DB依存が不要な場合は`SimpleRestTestSupport`を使用することでコンポーネント定義を簡略化できる。

**クラス**: `RestTestSupport`

`SimpleRestTestSupport`を継承し、DB関連機能を持つ。DB関連機能は`DbAccessTestSupport`クラスへ委譲。

以下のメソッドはリクエスト単体テスト(REST)では意図的に委譲していない:
- `public void beginTransactions()`
- `public void commitTransactions()`
- `public void endTransactions()`
- `public void setThreadContextValues(String sheetName, String id)`
- `public void assertSqlResultSetEquals(String message, String sheetName, String id, SqlResultSet actual)`
- `public void assertSqlRowEquals(String message, String sheetName, String id, SqlRow actual)`

> **重要**: RESTfulウェブサービスの単体テストでは、`assertTableEquals`等でDBテーブル内容を直接確認するより、公開APIに問い合わせてDB非依存でデータを確認するテストを推奨。

## 事前準備補助機能（RestMockHttpRequest生成）

```java
RestMockHttpRequest get(String uri)
RestMockHttpRequest post(String uri)
RestMockHttpRequest put(String uri)
RestMockHttpRequest patch(String uri)
RestMockHttpRequest delete(String uri)
RestMockHttpRequest newRequest(String httpMethod, String uri)
```

引数はリクエストURIを指定。URI以外のデータはメソッド戻り値に設定する。`RestMockHttpRequest`はメソッドチェーン対応。

例:
```java
RestMockHttpRequest request = post("/projects")
                                  .setHeader("Authorization","Bearer token")
                                  .setCookie(cookie);
```

## 実行

```java
HttpResponse sendRequest(HttpRequest request)
```

## 各種設定値

環境依存の設定値はコンポーネント設定ファイルで変更可能。

| 設定項目名 | 説明 | デフォルト値 |
|---|---|---|
| `webBaseDir` | ウェブアプリケーションのルートディレクトリ | `src/main/webapp` |
| `webFrontControllerKey` | Webフロントコントローラーのリポジトリキー | `webFrontController` |

**webBaseDir**: PJ共通ウェブモジュールが存在する場合、カンマ区切りで複数ディレクトリを指定可能。先頭から順にリソースが読み込まれる。

```xml
<component name="restTestConfiguration" class="nablarch.test.core.http.RestTestConfiguration">
  <property name="webBaseDir" value="/path/to/web-a/,/path/to/web-common"/>
```

**webFrontControllerKey**: ウェブアプリ実行基盤とウェブサービス実行基盤を同一WARで実行する場合など、`WebFrontController`（`nablarch.fw.web.servlet.WebFrontController`）をデフォルト以外の名前でコンポーネント登録する場合に指定。デフォルトでは`webFrontController`（ウェブアプリ用）が使用される。ウェブサービス専用のWebフロントコントローラーを使用する場合は以下のように設定を上書き:

```xml
<!-- ハンドラキュー構成 -->
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- ウェブアプリ用ハンドラ -->
    </list>
  </property>
</component>

<component name="jaxrsController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- ウェブサービス用ハンドラ -->
    </list>
  </property>
</component>
```

```xml
<import file="nablarch/test/rest-request-test.xml"/>
<!--  デフォルトのコンポーネント定義をimport後に上書きする。-->
<component name="restTestConfiguration" class="nablarch.test.core.http.RestTestConfiguration">
  <property name="webFrontControllerKey" value="jaxrsController"/>
```
