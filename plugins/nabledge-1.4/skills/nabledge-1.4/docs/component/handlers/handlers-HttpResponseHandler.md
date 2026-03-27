# HTTPレスポンスハンドラ

## 

**クラス名**: `nablarch.fw.handler.HttpResponseHandler`

後続ハンドラの処理結果であるHTTPレスポンスオブジェクトの内容に沿って、サーブレットフォーワードやサーバソケットへの出力などのレスポンス処理を行う。HTTPレスポンスオブジェクトは情報格納用クラスであり、実際のレスポンス処理はこのハンドラが実行する。

<details>
<summary>keywords</summary>

HttpResponseHandler, nablarch.fw.handler.HttpResponseHandler, nablarch.fw.web.handler.HttpResponseHandler, HTTPレスポンスハンドラ, HTTPレスポンスオブジェクト, レスポンス処理

</details>

## 概要

レスポンスボディの指定方法:
1. HTTPレスポンスオブジェクトに直接設定（[../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../libraries/libraries-05_FileDownload.md) 等で使用）
2. [コンテンツパス](handlers-HttpMethodBinding.md) 文字列で指定（通常業務機能で主に使用）

**ハンドラキュー**: HttpResponseHandler → ResourceMapping → HttpMethodBinding

**関連するハンドラ**

| ハンドラ | 説明 |
|---|---|
| [ResourceMapping](handlers-ResourceMapping.md), [HttpMethodBinding](handlers-HttpMethodBinding.md) | 本ハンドラはこれらのハンドラの上位に配置する必要がある |

<details>
<summary>keywords</summary>

ResourceMapping, HttpMethodBinding, ハンドラキュー, 関連するハンドラ, コンテンツパス, レスポンスボディ指定方法

</details>

## 

HTTPレスポンスハンドラは内部で404等のエラー用レスポンスが返された際に、200へステータスコードを変換する（ブラウザのレスポンスコードによる挙動差異を防ぐため）。

以下の場合は例外的に内部のエラーコードをそのままステータスコードとする:
- 300系リダイレクションレスポンスの場合
- リクエストヘッダ `X-Requested-With` の値が `XMLHttpRequest` の場合（AJAXリクエスト）

<details>
<summary>keywords</summary>

ステータスコード変換, 404から200, X-Requested-With, XMLHttpRequest, AJAXリクエスト, 300系リダイレクション, http_response_handler_response_code_conversion

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 後続ハンドラへ処理委譲（往路では本ハンドラは処理を行わない）

**[復路処理]**
2. [コンテンツパス](handlers-HttpMethodBinding.md) 文字列を取得
3. **forward://** で開始: サーブレットフォーワードを実行。レスポンス出力はフォーワード先サーブレットが行う。完了後にHTTPレスポンスオブジェクトをリターン
4. HTTPレスポンスヘッダーをクライアントに送信（ボディはChunkedエンコーディングで送信）
5. **redirect://**、**http://**、**https://** で開始: Locationヘッダに設定しリダイレクト送信。**redirect://** かつ絶対パス指定の場合はサーブレットコンテキストルートのパスを補完
6. **file://** で開始: ファイルシステム上のファイル内容をレスポンスボディとして送信
7. **classpath://** で開始: コンテキストクラスローダからリソースを取得しレスポンスボディとして送信
8. InputStreamが直接設定されている場合、または `HttpResponse#write()` でバッファリングされている場合: その内容をレスポンスボディとして送信
9. 入出力ストリームをクローズ。HTTPレスポンスオブジェクト上にバッファリングされたレスポンス内容を削除
10. HTTPレスポンスオブジェクトをリターン

**[例外処理]**
- 後続ハンドラ実行中の例外: 既定のエラー画面をレスポンスし例外を再送出（サーブレットフォーワード処理中の場合はログ出力のみ）
- フォーワード先JSP/サーブレットでのエラー: システムエラー画面をクライアントに送信して終了
- サーブレットフォーワード中のIOエラー: WARNレベルのログを出力しHTTPレスポンスオブジェクトをリターン
- レスポンス処理・終端処理中のIOエラー: WARNレベルのログを出力して処理継続
- レスポンス処理・終端処理中のその他の例外: システムエラー画面を送信し終端処理後に例外を再送出

<details>
<summary>keywords</summary>

往路処理, 復路処理, 例外処理, forward://, redirect://, file://, classpath://, HTTPリダイレクション, サーブレットフォーワード, IOエラー, HttpResponse#write()

</details>

## 

HTTPリクエストから取得した言語設定に基づき、フォーワード先を動的に切り替える機能。`ResourcePathRule` 抽象クラスのサブクラスを使用。

| クラス名 | 説明 |
|---|---|
| `ResourcePathRule` | 言語対応リソースパスのルール基底クラス。言語は :ref:`ThreadContextHandler` で設定されたスレッドコンテキストから取得。言語未取得時、対応ファイルが存在しない場合、または指定されたリソースパスに拡張子を含まない場合は指定パスをそのまま返す |
| `DirectoryBasedResourcePathRule` | コンテキストルート直下のディレクトリを言語切り替えに使用（例: `/ja/management/user/search.jsp`） |
| `FilenameBasedResourcePathRule` | ファイル名サフィックスを言語切り替えに使用（例: `search_ja.jsp`, `search_en.jsp`） |

<details>
<summary>keywords</summary>

言語切り替え, ResourcePathRule, DirectoryBasedResourcePathRule, FilenameBasedResourcePathRule, 多言語対応, コンテンツパス切り替え, i18n, http_response_handler_i18n, ThreadContextHandler

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| contentPathRule | ResourcePathRule | | DirectoryBasedResourcePathRule | 言語毎コンテンツパスの対応ルール |
| forceFlushAfterWritingHeaders | boolean | | true | レスポンスをChunkedエンコーディングで送信するかどうか |
| xFrameOptions | String | | SAMEORIGIN | レスポンスの"X-Frame-Options"の設定 |

X-Frame-Optionsの設定値:
- `DENY`: すべてのページにおいて表示を禁止
- `SAMEORIGIN`: アドレスバーに表示されたドメインと同じページのみ表示を許可
- `NONE`: すべてのページにおいて表示を許可（HTTPレスポンスヘッダに"X-Frame-Options"項目自体を設定しない）

> **注意**: `xFrameOptions` に `NONE` を設定した場合は `SAMEORIGIN` や `DENY` とは異なり、HTTPレスポンスヘッダに"X-Frame-Options"項目自体を設定しない。

**標準設定**:
```xml
<component class="nablarch.fw.web.handler.HttpResponseHandler" />
```

**言語毎のコンテンツパス切り替え設定**:
```xml
<component name="resourcePathRule" class="nablarch.fw.web.i18n.DirectoryBasedResourcePathRule" />
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="contentPathRule" ref="resourcePathRule" />
</component>
```

スレッドコンテキストの言語とコンテンツパスの例:
```bash
# HttpResponseオブジェクトに設定されたコンテンツパス
servlet:///management/user/search.jsp

# スレッドコンテキストの言語 -> 使用されるコンテンツパス
ja -> /ja/management/user/search.jsp
en -> /en/management/user/search.jsp
it -> /management/user/search.jsp
```

**ChunkedエンコーディングなしのHTTPレスポンス送信設定** (HTTP1.1未対応の通信先の場合):
```xml
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="forceFlushAfterWritingHeaders" value="false" />
</component>
```

> **警告**: 上記設定でChunkedエンコーディングなしに設定した場合でも、APサーバの設定によってChunkedエンコーディングで送信されることがある。その場合はAPサーバの設定を確認・変更すること。

**クリックジャッキング攻撃対策設定** (デフォルト: SAMEORIGIN):
```xml
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="xFrameOptions" value="DENY" />
</component>
```

<details>
<summary>keywords</summary>

contentPathRule, forceFlushAfterWritingHeaders, xFrameOptions, Chunkedエンコーディング, X-Frame-Options, クリックジャッキング対策, DirectoryBasedResourcePathRule, nablarch.fw.web.handler.HttpResponseHandler

</details>
