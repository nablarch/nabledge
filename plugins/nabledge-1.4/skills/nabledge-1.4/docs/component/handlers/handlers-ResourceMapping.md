# リソースマッピングハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.ResourceMapping`

業務アクションを経由せずに直接レスポンスするリソースを決定するハンドラ。ログイン画面のような静的JSPや画像・JavaScriptなどの静的リソースのレスポンスに使用する。

マッピング先スキーム（以下のいずれかを指定可）:
1. `servlet://` — サーブレット/JSPフォーワード **[デフォルト]**
2. `forward://` — 内部フォーワードの実行結果
3. `classpath://` — コンテキストクラスローダ上のリソース

> **注意**: セキュリティ上の理由から `file://` スキームは指定不可。スキーム省略時は `servlet://` とみなされる。

> **リソース配置の推奨方針**: 通常のサーブレットアプリケーションでは直接アクセス不可能なリソースを `/WEB-INF/` 配下に配置するのが一般的だが、本フレームワークでは JSP・画像などのリソースは全てサーブレットコンテキスト配下に直接配置することを推奨している。この場合、デフォルトでは全リソースへの直接アクセスは拒否され、業務アクションのレスポンスか、本ハンドラのマッピング定義対象リソースのみアクセス可能となる。

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 本ハンドラが返却したHTTPレスポンスの [コンテンツパス](handlers-HttpMethodBinding.md) に基づいてレスポンス処理を行う |
| [ForwardingHandler](handlers-ForwardingHandler.md) | コンテンツパスが `forward://` で始まる場合に内部フォーワード処理を行う |
| [RequestHandlerEntry](handlers-RequestHandlerEntry.md) | マッピング対象リクエストを限定するために **必ず** 組み合わせて使用する |

<details>
<summary>keywords</summary>

ResourceMapping, nablarch.fw.web.handler.ResourceMapping, HttpResponseHandler, ForwardingHandler, RequestHandlerEntry, リソースマッピング, 静的リソース配信, 直接アクセス制御, サーブレットフォーワード, servlet://, classpath://, forward://, WEB-INF, サーブレットコンテキスト配下, リソース配置推奨

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 本ハンドラに設定された **マッピング元ベースURI** がリクエストパス（サーブレットコンテキストからの相対パス）に前方一致するか判定
2. 不一致の場合、ステータスコード **404** をリターンして終了
3. 一致した場合、リクエストパスの前方一致部分を **マッピング先ベースコンテンツパス** に置換してマッピング先コンテンツパスを算出。マッピング先ベースコンテンツパスにスキーム未指定時は `servlet://` を補完
4. マッピング先が `classpath://` の場合、リソースの実在チェックを実施。存在しなければステータスコード **404** をリターンして終了
5. ステータスコード **200** のHTTPレスポンスを作成し、算出した [コンテンツパス](handlers-HttpMethodBinding.md) を設定してリターン

**[復路処理]**: 後続ハンドラへの処理委譲なし。

**[例外処理]**: 後続ハンドラへの処理委譲なし。

<details>
<summary>keywords</summary>

ResourceMapping, 往路処理, コンテンツパス算出, 404レスポンス, classpath実在チェック, 前方一致, スキーム補完

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| baseUri | String | ○ | | リクエストURIの置換対象となる部分文字列（前方一致）|
| basePath | String | ○ | | リクエストURI中のbaseUriを置換する文字列（[コンテンツパス](handlers-HttpMethodBinding.md)）。スキーム省略時は `servlet://` とみなされる |

**画像ファイルに対するマッピングの設定例** (`/img/` 配下を `/resources/img/` にマッピング):

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/img//*.png"/>
  <property name="handler">
    <component class="nablarch.fw.web.handler.ResourceMapping">
      <property name="baseUri" value="/img/"/>
      <property name="basePath" value="servlet:///resources/img/"/>
    </component>
  </property>
</component>
```

マッピング結果例（コンテキストパス `/webapp/`）:

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/img/logo.png | servlet:///resource/img/logo.png |
| GET /webapp/img/page1/figure01.png | servlet:///resource/img/page1/figure01.png |

**直接表示可能なJSP画面の設定例** (末尾が `-public.jsp` のリソースへの直接アクセスを許可):

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/jsp//*-public.jsp"/>
  <property name="handler">
    <component class="nablarch.fw.web.handler.ResourceMapping">
      <property name="baseUri" value="/"/>
      <property name="basePath" value="servlet:///"/>
    </component>
  </property>
</component>
```

マッピング結果例（コンテキストパス `/webapp/`）:

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/jsp/login-public.jsp | servlet:///jsp/login-public.jsp |
| GET /webapp/jsp/welcome.jsp | (404エラー) |

<details>
<summary>keywords</summary>

baseUri, basePath, ResourceMapping設定, 静的リソースマッピング, JSP直接アクセス, 画像ファイルマッピング, RequestHandlerEntry, requestPattern

</details>
