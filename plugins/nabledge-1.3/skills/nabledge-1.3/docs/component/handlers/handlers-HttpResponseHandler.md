# HTTPレスポンスハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.HttpResponseHandler`

後続ハンドラの処理結果であるHTTPレスポンスオブジェクトの内容に基づき、サーブレットフォーワードやレスポンス出力を行うハンドラ。HTTPレスポンスオブジェクト自体はレスポンス処理を行わず、実際の処理はこのハンドラが担う。

レスポンスボディの指定方法:
1. HTTPレスポンスオブジェクトに直接設定する方法（[../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../libraries/libraries-05_FileDownload.md) 等で使用）
2. [コンテンツパス](handlers-HttpMethodBinding.md) 文字列による指定（通常の業務機能で主に使用）

**関連ハンドラ**: [ResourceMapping](handlers-ResourceMapping.md), [HttpMethodBinding](handlers-HttpMethodBinding.md) の上位に本ハンドラを配置する必要がある。

<details>
<summary>keywords</summary>

HttpResponseHandler, nablarch.fw.handler.HttpResponseHandler, ResourceMapping, HttpMethodBinding, HTTPレスポンス処理, コンテンツパス, サーブレットフォーワード

</details>

## ハンドラ処理フロー

**往路**: 後続ハンドラへ処理委譲し、HTTPレスポンスオブジェクトを取得する。

**復路**:
1. [コンテンツパス](handlers-HttpMethodBinding.md) を取得する
2. `forward://` で始まる場合: サーブレットフォーワードを実行（フォーワード完了後リターン）
3. HTTPレスポンスヘッダーを送信（ボディはChunkedエンコーディング）
4. `redirect://`、`http://`、`https://` で始まる場合: Locationヘッダー設定でリダイレクト。`redirect://` かつ絶対パスの場合はサーブレットコンテキストルートのパスを補完
5. `file://` で始まる場合: 指定ファイルの内容をレスポンスボディとして送信
6. `classpath://` で始まる場合: コンテキストクラスローダからリソースを取得してレスポンスボディとして送信
7. InputStreamが直接設定、または `HttpResponse#write()` でバッファリングされている場合: その内容をレスポンスボディとして送信
8. 入出力ストリームをすべてクローズし、バッファリングされたレスポンス内容を削除
9. HTTPレスポンスオブジェクトをリターン

**例外処理**:
- 後続ハンドラ実行中の例外: 既定のエラー画面をレスポンス後に例外を再送出。サーブレットフォーワード処理中はログ出力のみ
- フォーワード先（JSP/サーブレット）でエラー: システムエラー画面を送信して終了
- フォーワード中のIOエラー: ワーニングレベルのログを出力してリターン
- レスポンス処理・終端処理中のIOエラー: ワーニングレベルのログを出力して処理継続
- レスポンス処理・終端処理中のその他の例外: システムエラー画面を送信し、終端処理後に例外を再送出

<details>
<summary>keywords</summary>

forward://, redirect://, file://, classpath://, HttpResponse#write, ハンドラ処理フロー, レスポンスボディ送信, 例外処理, Chunkedエンコーディング

</details>

## ステータスコードの変換

404 等のエラー用レスポンスが返された際に、ステータスコードを 200 に変換する（ブラウザのレスポンスコードによる挙動差異を防ぐため）。

以下の場合は内部のエラーコードをそのままステータスコードとして使用する:
- 300 系のレスポンスコードの場合（転送用）
- リクエストヘッダー `X-Requested-With` の値が `XMLHttpRequest` の場合（AJAX リクエスト）

<details>
<summary>keywords</summary>

ステータスコード変換, X-Requested-With, XMLHttpRequest, AJAXリクエスト, 404エラー変換, 200変換

</details>

## 言語毎のコンテンツパスの切り替え

HTTPリクエストから取得した言語設定に基づき、フォーワード先を動的に切り替える機能。`ResourcePathRule` 抽象クラスのサブクラスを使用する。

| クラス名 | 説明 |
|---|---|
| `ResourcePathRule` | 言語対応リソースパスのルールを表す抽象クラス。言語はスレッドコンテキストから取得（:ref:`ThreadContextHandler` 参照）。スレッドコンテキストから言語を取得できない場合は指定されたリソースパスをそのまま返す。言語対応ファイルが存在する場合のみ言語対応パスを返す。ファイルが存在しない、またはリソースパスに拡張子がない場合は指定パスをそのまま返す |
| `DirectoryBasedResourcePathRule` | コンテキストルート直下のディレクトリを言語切り替えに使用。言語名のディレクトリを作成し、同パスでコンテンツを配置する |
| `FilenameBasedResourcePathRule` | ファイル名を言語切り替えに使用。ファイル名にサフィックス `"_" + 言語名` を付ける |

**DirectoryBasedResourcePathRule のディレクトリ構成例**:
```bash
コンテキストルート
├─en
│  └─management
│      └─user
│           search.jsp
└─ja
    └─management
        └─user
             search.jsp
```

**FilenameBasedResourcePathRule のファイル配置例**:
```bash
コンテキストルート
└─management
        └─user
             search_en.jsp
             search_ja.jsp
```

<details>
<summary>keywords</summary>

ResourcePathRule, DirectoryBasedResourcePathRule, FilenameBasedResourcePathRule, 言語切り替え, コンテンツパス切り替え, i18n, ThreadContextHandler

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| contentPathRule | ResourcePathRule | | DirectoryBasedResourcePathRule | 言語毎コンテンツパスの対応ルール |

**標準設定**:
```xml
<component class="nablarch.fw.web.handler.HttpResponseHandler" />
```

**言語毎コンテンツパス切り替え設定**:
```xml
<!-- リソースパスルール -->
<component name="resourcePathRule" class="nablarch.fw.web.i18n.DirectoryBasedResourcePathRule" />

<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="contentPathRule" ref="resourcePathRule" />
</component>
```

スレッドコンテキストの言語と使用されるコンテンツパスの例（`DirectoryBasedResourcePathRule` 使用時）:
```bash
# HttpResponseオブジェクトに設定されたコンテンツパス
servlet:///management/user/search.jsp

# スレッドコンテキストの言語 -> 使用されるコンテンツパス
ja -> /ja/management/user/search.jsp
en -> /en/management/user/search.jsp
it -> /management/user/search.jsp
```

<details>
<summary>keywords</summary>

contentPathRule, DirectoryBasedResourcePathRule, 設定例, 言語設定, nablarch.fw.web.handler.HttpResponseHandler, nablarch.fw.web.i18n.DirectoryBasedResourcePathRule

</details>
