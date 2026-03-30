# HTTPレスポンスハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.HttpResponseHandler`

HTTPレスポンスオブジェクトの内容に沿って、サーブレットフォーワード処理やサーバソケットへの出力等のレスポンス処理を行うハンドラ。HTTPレスポンスオブジェクトを生成しただけではレスポンス処理は行われない。

レスポンスボディの指定方法は2種類:
1. HTTPレスポンスオブジェクトに直接ボディ内容を設定する方法（主に [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../libraries/libraries-05_FileDownload.md) で使用）
2. [コンテンツパス](handlers-HttpMethodBinding.md) と呼ばれる文字列で指定する方法（通常の業務機能では主にこちら）

**関連ハンドラ**: [ResourceMapping](handlers-ResourceMapping.md), [HttpMethodBinding](handlers-HttpMethodBinding.md) — 本ハンドラはこれらの上位に配置する必要がある。

<details>
<summary>keywords</summary>

HttpResponseHandler, nablarch.fw.handler.HttpResponseHandler, HTTPレスポンスハンドラ, コンテンツパス, サーブレットフォーワード, レスポンスボディ, ResourceMapping, HttpMethodBinding

</details>

## ハンドラ処理フロー

**往路処理**

1. 後続ハンドラへ処理を委譲し、HTTPレスポンスオブジェクトを取得する（往路では特段の処理なし）。

**復路処理**

2. HTTPレスポンスオブジェクトに設定された [コンテンツパス](handlers-HttpMethodBinding.md) 文字列を取得する。
3. [コンテンツパス](handlers-HttpMethodBinding.md) が `forward://` で始まる場合 → サーブレットフォーワードを実行。完了後にHTTPレスポンスオブジェクトをリターンして終了。
4. HTTPレスポンスに設定されたHTTPヘッダーをクライアントに送信（ボディはChunkedエンコーディング）。
5. [コンテンツパス](handlers-HttpMethodBinding.md) が `redirect://`, `http://`, `https://` で始まる場合 → Locationヘッダにパスを設定してリダイレクト送信。`redirect://` かつ絶対パスの場合はサーブレットコンテキストルートのパスを補完。
6. [コンテンツパス](handlers-HttpMethodBinding.md) が `file://` で始まる場合 → ファイルシステム上のファイル内容をレスポンスボディとして送信。
7. [コンテンツパス](handlers-HttpMethodBinding.md) が `classpath://` で始まる場合 → コンテキストクラスローダからリソースを取得し、その内容をレスポンスボディとして送信。
8. `HttpResponse` オブジェクトにInputStreamが直接設定されている場合、または `HttpResponse#write()` でバッファリングされている場合 → その内容をレスポンスボディとして送信。
9. レスポンス処理で使用した入出力ストリームを全てクローズ。バッファリングされているレスポンス内容は削除。
10. HTTPレスポンスオブジェクトをリターンして終了。

**例外処理**

- 後続ハンドラ実行中に例外送出 → 既定のエラー画面をレスポンス後、例外を再送出。サーブレットフォーワード処理中のエラーはログ出力のみ。
- フォーワード先のJSP/サーブレットでエラー発生 → システムエラー画面をクライアントに送信して終了。
- サーブレットフォーワード処理中のIOエラー → WARNログ出力後、HTTPレスポンスオブジェクトをリターンして終了。
- レスポンス処理・終端処理中のIOエラー → WARNログ出力して処理継続。
- レスポンス処理・終端処理中のその他の例外 → システムエラー画面をクライアントに送信し、終端処理後に例外を再送出。

<details>
<summary>keywords</summary>

コンテンツパス, サーブレットフォーワード, HTTPリダイレクション, レスポンスボディ送信, 往路処理, 復路処理, 例外処理, forward://, redirect://, file://, classpath://, HttpResponse#write(), HttpResponse

</details>

## ステータスコードの変換

HTTPレスポンスハンドラは、内部で404などのエラー用レスポンスが返された際に、200にステータスコードを変換する（ブラウザのレスポンスコードによる挙動の差異を防ぐため）。

以下の場合は変換せず、内部のエラーコードをそのままステータスコードとして使用する:
- 300系（転送用）レスポンスコードの場合
- リクエストヘッダ `X-Requested-With` の値が `XMLHttpRequest` の場合（AJAXリクエスト）

<details>
<summary>keywords</summary>

ステータスコード変換, エラーレスポンス, AJAX, XMLHttpRequest, X-Requested-With, 404, 200, 300系

</details>

## 言語毎のコンテンツパスの切り替え

HTTPリクエストから取得した言語設定をもとに、フォーワード先を動的に切り替える機能。`ResourcePathRule` のサブクラスを使用して言語毎のコンテンツパスを取得する。言語は :ref:`ThreadContextHandler` が設定するスレッドコンテキストから取得する。

| クラス名 | 説明 |
|---|---|
| `ResourcePathRule` | 言語対応リソースパスのルールを表す抽象クラス。スレッドコンテキストから言語を取得できない場合は指定されたリソースパスをそのまま返す。言語対応ファイルが存在しない場合、または拡張子がない場合も指定パスをそのまま返す |
| `DirectoryBasedResourcePathRule` | コンテキストルート直下のディレクトリを言語切り替えに使用する |
| `FilenameBasedResourcePathRule` | ファイル名に `_言語名` サフィックスを付けて言語切り替えを行う |

`DirectoryBasedResourcePathRule` のファイル配置例（`/management/user/search.jsp` を日本語・英語対応する場合）:

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

`FilenameBasedResourcePathRule` のファイル配置例:

```bash
コンテキストルート
└─management
        └─user
             search_en.jsp
             search_ja.jsp
```

<details>
<summary>keywords</summary>

ResourcePathRule, DirectoryBasedResourcePathRule, FilenameBasedResourcePathRule, 言語切り替え, 多言語対応, コンテンツパス切り替え, i18n, ThreadContextHandler

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| contentPathRule | ResourcePathRule | | DirectoryBasedResourcePathRule | 言語毎コンテンツパスの対応ルール |

標準設定:

```xml
<component class="nablarch.fw.web.handler.HttpResponseHandler" />
```

言語毎のコンテンツパス切り替えを行う場合の設定:

```xml
<component name="resourcePathRule" class="nablarch.fw.web.i18n.DirectoryBasedResourcePathRule" />
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="contentPathRule" ref="resourcePathRule" />
</component>
```

言語→使用コンテンツパスの例（`servlet:///management/user/search.jsp` が設定されている場合）:

```bash
ja -> /ja/management/user/search.jsp
en -> /en/management/user/search.jsp
it -> /management/user/search.jsp
```

<details>
<summary>keywords</summary>

contentPathRule, ResourcePathRule, DirectoryBasedResourcePathRule, FilenameBasedResourcePathRule, nablarch.fw.web.handler.HttpResponseHandler, nablarch.fw.web.i18n.DirectoryBasedResourcePathRule, DI設定

</details>
