# リクエスト単体テスト（画面オンライン処理）

## 前提事項とクラス概要

**前提事項**

リクエスト単体テスト（内蔵サーバを利用してHTMLダンプを出力する方式）は、**1リクエスト1画面遷移のシンクライアント型Webアプリケーション**を対象としている。

- Ajaxやリッチクライアントを利用したアプリケーションでは、**HTMLダンプによるレイアウト確認は使用できない**
- JSP以外のViewテクノロジでも、サーブレットコンテナ上で画面全体をレンダリングする方式であればHTMLダンプの出力が可能

**主なクラスとリソース**

| 名称 | 役割 |
|------|------|
| テストクラス | テストロジックを実装する（テスト対象クラス(Action)につき1つ作成） |
| テストデータ（Excelファイル） | 準備データ・期待結果・HTTPパラメータなどのテストデータを記載（テストクラスにつき1つ作成） |
| テスト対象クラス(Action) | テスト対象のクラス（Action以降の業務ロジックを実装する各クラスを含む） |
| `DbAccessTestSupport` | 準備データ投入などデータベースを使用するテストに必要な機能を提供 |
| `HttpServer` | 内蔵サーバ。サーブレットコンテナとして動作し、HTTPレスポンスをファイル出力する |
| `HttpRequestTestSupport` | 内蔵サーバの起動やリクエスト単体テストで必要となる各種アサートを提供 |
| `AbstractHttpRequestTestTemplate` / `BasicHttpRequestTestTemplate` | リクエスト単体テストをテンプレート化するクラス。テストソース・テストデータを定型化する |
| `TestCaseInfo` | データシートに定義されたテストケース情報を格納するクラス |

上記のクラス群は、内蔵サーバも含め**全て同一のJVM上で動作する**。このため、リクエストやセッション等のサーバ側のオブジェクトを加工できる。

<details>
<summary>keywords</summary>

前提事項, シンクライアント, 1リクエスト1画面遷移, Ajax, リッチクライアント, HTMLダンプ制約, HttpServer, 内蔵サーバ, 同一JVM, BasicHttpRequestTestTemplate, AbstractHttpRequestTestTemplate, TestCaseInfo, DbAccessTestSupport, HttpRequestTestSupport

</details>

## BasicHttpRequestTestTemplate

**クラス**: `BasicHttpRequestTestTemplate`

各テストクラスのスーパクラス。本クラスを使用することで、リクエスト単体テストのテストソース・テストデータを定型化でき、**テストソース記述量を大きく削減できる**。

具体的な使用方法は [../05_UnitTestGuide/02_RequestUnitTest/index](testing-framework-02_RequestUnitTest.md) を参照。

<details>
<summary>keywords</summary>

BasicHttpRequestTestTemplate, スーパクラス, テストソース定型化, テストデータ定型化, 記述量削減

</details>

## AbstractHttpRequestTestTemplateとTestCaseInfo

**AbstractHttpRequestTestTemplate**

アプリケーションプログラマが直接使用することはない。テストデータの書き方を変えたい場合など、**自動テストフレームワークを拡張する際**に用いる。

**TestCaseInfo**

データシートに定義されたテストケース情報を格納するクラス。テストデータの書き方を変えたい場合は、本クラスおよび`AbstractHttpRequestTestTemplate`を継承する。

<details>
<summary>keywords</summary>

AbstractHttpRequestTestTemplate, TestCaseInfo, フレームワーク拡張, テストデータ書き方変更, 継承, データシート

</details>

## データベース関連機能

**クラス**: `HttpRequestTestSupport`, `DbAccessTestSupport`

`HttpRequestTestSupport`のデータベース機能は`DbAccessTestSupport`クラスに委譲して実現。

リクエスト単体テストでは不要なため、以下のメソッドは意図的に委譲されていない（誤用防止）:
- `public void beginTransactions()`
- `public void commitTransactions()`
- `public void endTransactions()`
- `public void setThreadContextValues(String sheetName, String id)`

詳細は [02_DbAccessTest](testing-framework-02_DbAccessTest.md) を参照。

<details>
<summary>keywords</summary>

HttpRequestTestSupport, DbAccessTestSupport, beginTransactions, commitTransactions, endTransactions, setThreadContextValues, データベース関連機能, 委譲除外メソッド

</details>

## 事前準備補助機能

**クラス**: `HttpRequestTestSupport`

**HttpRequest生成**:
```java
HttpRequest createHttpRequest(String requestUri, Map<String, String[]> params)
```
リクエストURIとリクエストパラメータからHttpRequestインスタンスを生成し、HTTPメソッドをPOSTに設定して返却。

> **ベストプラクティス**: HttpRequestにリクエストパラメータやURI以外のデータを設定したい場合は、本メソッド呼び出しにより取得したインスタンスに対してデータの設定を行うとよい。

**ExecutionContext生成**:
```java
ExecutionContext createExecutionContext(String userId)
```
引数のユーザIDはセッションに格納され、そのユーザIDでログイン状態となる。

**トークン発行** ([how_to_set_token_in_request_unit_test](testing-framework-02_RequestUnitTest.md)):
2重サブミット防止を施しているURIのテストには、事前にトークンを発行してセッションに設定する必要がある。

```java
void setValidToken(HttpRequest request, ExecutionContext context)
```
トークンを発行してセッションに格納する。

```java
void setToken(HttpRequest request, ExecutionContext context, boolean valid)
```
- `true`: `setValidToken`と同じ動作（トークン発行・格納）
- `false`: セッションからトークン情報を除去

使用例（テストデータからトークン設定を制御）:
```java
String isTokenValid; // テストデータから取得
setToken(req, ctx, Boolean.parseBoolean(isTokenValid));
```

<details>
<summary>keywords</summary>

HttpRequestTestSupport, createHttpRequest, createExecutionContext, setValidToken, setToken, HttpRequest, ExecutionContext, トークン発行, 2重サブミット防止, 事前準備

</details>

## 実行とリポジトリの初期化

**クラス**: `HttpRequestTestSupport`

**実行メソッド**:
```java
HttpResponse execute(String caseName, HttpRequest req, ExecutionContext ctx)
```
テストケース名（HTMLダンプ出力ファイル名に使用）、HttpRequest、ExecutionContextを引数に取り、内蔵サーバを起動してリクエストを送信する。

**executeメソッド内部のリポジトリ再初期化処理**:
1. 現在のリポジトリの状態をバックアップ
2. テスト対象Webアプリのコンポーネント設定ファイルを用いてリポジトリを再初期化
3. executeメソッド終了時にバックアップしたリポジトリを復元

これにより、クラス単体テストとリクエスト単体テストで設定を分けずに連続実行できる。

テスト対象Webアプリに関する設定については :ref:`howToConfigureRequestUnitTestEnv` を参照。

<details>
<summary>keywords</summary>

HttpRequestTestSupport, execute, HttpResponse, リポジトリ初期化, バックアップと復元, クラス単体テスト連続実行

</details>

## メッセージ

**クラス**: `HttpRequestTestSupport`

アプリケーション例外のメッセージ確認メソッド:

```java
void assertApplicationMessageId(String expectedCommaSeparated, ExecutionContext actual)
```
- 第1引数: 期待するメッセージID（複数の場合はカンマ区切り）
- 第2引数: ExecutionContext

例外が発生しなかった場合、またはアプリケーション例外以外の例外が発生した場合はアサート失敗。

> **注意**: メッセージIDの比較はIDをソートした状態で行うため、テストデータの記載順序は問わない。

<details>
<summary>keywords</summary>

HttpRequestTestSupport, assertApplicationMessageId, アプリケーション例外, メッセージID確認, ExecutionContext

</details>

## HTMLダンプ出力ディレクトリ

テスト実行時、プロジェクトルートディレクトリに`tmp/html_dump`ディレクトリが作成される。

- `tmp/html_dump/{テストクラス名}/`: テストクラス毎に同名ディレクトリを作成
- そのディレクトリ配下にテストケース名と同名のHTMLダンプファイルが出力
- HTMLリソース（スタイルシート、画像等）も同ディレクトリに出力（別環境でも同じ表示が可能）

`html_dump`ディレクトリが既に存在する場合は`html_dump_bk`という名前でバックアップされる。

![HTMLダンプディレクトリ構造](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_RequestUnitTest-06_TestFWGuide/htmlDumpDir.png)

<details>
<summary>keywords</summary>

HTMLダンプ, html_dump, html_dump_bk, tmp/html_dump, HTMLダンプ出力ディレクトリ, テストケース名

</details>
