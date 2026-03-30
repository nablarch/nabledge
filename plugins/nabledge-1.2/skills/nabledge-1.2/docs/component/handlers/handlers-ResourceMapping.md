# リソースマッピングハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.ResourceMapping`

業務アクションを経由せずに、リクエストパスと[コンテンツパス](handlers-HttpMethodBinding.md)のマッピング定義に基づいてレスポンスリソースを決定するハンドラ。ログイン画面（ビジネスロジック不要なJSP）や静的リソース（JavaScript、画像）のレスポンスに使用する。

**サポートするスキーム**（マッピング先に指定可能）:
1. `servlet://` — サーブレット/JSPフォーワード（**デフォルト**）
2. `forward://` — 内部フォーワードの実行結果
3. `classpath://` — コンテキストクラスローダ上のリソース

> **注意**: `file://`スキーム（ファイルシステム上のローカルファイル）はセキュリティ上の理由から指定不可。スキーム省略時は`servlet://`として扱われる。

> **注意**: JSP・画像などのリソースはサーブレットコンテキスト配下に直接配置することを推奨。デフォルトでは全リソースへの直接アクセスは拒否され、業務アクションのレスポンスまたは本ハンドラのマッピング定義対象のリソースのみアクセス可能となる。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 本ハンドラが返却したHTTPレスポンスの[コンテンツパス](handlers-HttpMethodBinding.md)に基づきレスポンス処理 |
| [ForwardingHandler](handlers-ForwardingHandler.md) | [コンテンツパス](handlers-HttpMethodBinding.md)が`forward://`で始まる場合の内部フォーワード処理 |
| [RequestHandlerEntry](handlers-RequestHandlerEntry.md) | マッピング対象リクエストを限定するために必ず組み合わせて使用する |

<details>
<summary>keywords</summary>

ResourceMapping, nablarch.fw.web.handler.ResourceMapping, リソースマッピング, 静的リソース, servlet://スキーム, forward://スキーム, classpath://スキーム, file://スキーム, JSP直接表示, HttpResponseHandler, ForwardingHandler, RequestHandlerEntry

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **マッピング対象リクエスト判定**: 設定した`baseUri`がリクエストパス（サーブレットコンテキストからの相対パス）に前方一致するか判定。
   - 一致しない場合 → ステータスコード**404**のレスポンスを返し終了。
2. **マッピング先コンテンツパスの算出**: リクエストパスの前方一致部分を`basePath`に置換。`basePath`にスキームがない場合は`servlet://`を補完。
3. **マッピング先コンテンツパス実在チェック**: `classpath://`スキームの場合、リソースが実在するか確認。存在しない場合 → ステータスコード**404**のレスポンスを返し終了。
4. **HTTPレスポンスの返却**: ステータスコード**200**のHTTPレスポンスを作成し、算出した[コンテンツパス](handlers-HttpMethodBinding.md)を設定してリターン。

**[復路処理]**: 後続ハンドラへの処理委譲なし。

**[例外処理]**: 後続ハンドラへの処理委譲なし。

<details>
<summary>keywords</summary>

往路処理, 404レスポンス, マッピング対象リクエスト判定, baseUri前方一致, コンテンツパス算出, classpath実在チェック, 200レスポンス

</details>

## 設定項目・拡張ポイント

**設定プロパティ**:

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| baseUri | String | ○ | | リクエストURIの置換対象となる部分文字列（前方一致） |
| basePath | String | ○ | | リクエストURI中のbaseUriを置換するコンテンツパス（[コンテンツパス](handlers-HttpMethodBinding.md)）。スキーム省略時は`servlet://`として扱われる |

**画像ファイルへのマッピング設定例**（`/img/`配下のリクエストを`/resources/img/`にマッピング）:

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

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/img/logo.png | servlet:///resource/img/logo.png |
| GET /webapp/img/page1/figure01.png | servlet:///resource/img/page1/figure01.png |

**直接表示可能なJSP設定例**（末尾が`-public.jsp`のリソースへの直接アクセスを許可）:

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

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/jsp/login-public.jsp | servlet:///jsp/login-public.jsp |
| GET /webapp/jsp/welcome.jsp | (404エラー) |

<details>
<summary>keywords</summary>

baseUri, basePath, 設定プロパティ, 画像ファイルマッピング, JSP直接アクセス, requestPattern, nablarch.fw.RequestHandlerEntry

</details>
