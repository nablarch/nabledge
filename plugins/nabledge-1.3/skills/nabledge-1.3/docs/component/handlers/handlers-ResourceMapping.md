# リソースマッピングハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.ResourceMapping`

業務アクションを経由せずに直接レスポンスとして返すリソースを決定するハンドラ。ログイン画面などビジネスロジックなしで表示するJSPや、JavaScriptや画像などの静的リソースのレスポンスに使用する。レスポンスされるリソースは、事前に定義されたリクエストパスと [コンテンツパス](handlers-HttpMethodBinding.md) とのマッピング定義を元に決定される。

マッピング先として指定可能なリソース:
1. サーブレット/JSPフォーワード (**servlet://** スキーム) **[デフォルト]**
2. 内部フォーワードの実行結果 (**forward://** スキーム)
3. コンテキストクラスローダ上のリソース (**classpath://** スキーム)

> **警告**: セキュリティ上の理由から、ファイルシステム上のローカルファイル（**file://** スキーム）はマッピング先に指定不可。スキーム省略時は **servlet://** とみなされる。

> **注意**: JSPや画像などのリソースはサーブレットコンテキスト配下に直接配置することを推奨。デフォルトで全リソースへの直接アクセスは拒否され、業務アクションのレスポンスまたは本ハンドラのマッピング定義対象リソースのみアクセス可能となる。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 本ハンドラが返却したHTTPレスポンスオブジェクト中の [コンテンツパス](handlers-HttpMethodBinding.md) の内容に基づいてレスポンス処理を行う |
| [ForwardingHandler](handlers-ForwardingHandler.md) | [コンテンツパス](handlers-HttpMethodBinding.md) が **forward://** で開始されている場合に内部フォーワード処理を行う |
| [RequestHandlerEntry](handlers-RequestHandlerEntry.md) | マッピング対象リクエストを限定するために必ず組み合わせて使用する |

<details>
<summary>keywords</summary>

ResourceMapping, nablarch.fw.web.handler.ResourceMapping, リソースマッピング, 静的リソース, JSP直接アクセス, HttpResponseHandler, ForwardingHandler, RequestHandlerEntry, servlet://, classpath://, forward://, file://

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(マッピング対象リクエスト判定)**: 設定された **マッピング元ベースURI** がリクエストパス（サーブレットコンテキストからの相対パス）に前方一致するかを判定する
   - 不一致の場合: ステータスコード **404** を返して終了
2. **(マッピング先コンテンツパスの算出)**: リクエストパス中の前方一致部分を **マッピング先ベースコンテンツパス** に置換して **マッピング先コンテンツパス** とする。スキーム未指定時は **servlet://** を補完する
3. **(マッピング先コンテンツパス実在チェック)**: スキームが **classpath://** の場合、パス上にリソースが実在するかをチェックし、存在しなければステータスコード **404** を返して終了
4. **(HTTPレスポンスの返却)**: ステータスコード **200** のHTTPレスポンスを作成し、算出した [コンテンツパス](handlers-HttpMethodBinding.md) を設定してリターンする

**[復路処理]**

後続ハンドラへの処理委譲は行わない。

**[例外処理]**

後続ハンドラへの処理委譲は行わない。

<details>
<summary>keywords</summary>

リソースマッピング処理フロー, マッピング対象リクエスト判定, コンテンツパス算出, classpath://実在チェック, 404レスポンス, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| baseUri | String | ○ | | リクエストURIの置換対象となる部分文字列（前方一致） |
| basePath | String | ○ | | リクエストURI中のマッピング元ベースURIを置換する [コンテンツパス](handlers-HttpMethodBinding.md) 。スキーム省略時は **servlet://** とみなされる |

**画像ファイルに対するマッピングの設定例**

リクエストパス **/img/** 配下を **/resources/img/** にマッピングする例:

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

マッピング結果（コンテキストパス **/webapp/**）:

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/img/logo.png | servlet:///resource/img/logo.png |
| GET /webapp/img/page1/figure01.png | servlet:///resource/img/page1/figure01.png |

**直接表示可能なJSP画面の設定例**

リソース名末尾が **-public.jsp** の場合のみ直接アクセスを許可する例:

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

マッピング結果（コンテキストパス **/webapp/**）:

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/jsp/login-public.jsp | servlet:///jsp/login-public.jsp |
| GET /webapp/jsp/welcome.jsp | (404エラー) |

<details>
<summary>keywords</summary>

baseUri, basePath, 静的リソースマッピング設定, 画像ファイルマッピング, JSPマッピング, RequestHandlerEntry, servlet://, リクエストパス前方一致

</details>
