# ファイルダウンロード

## 概要

ファイルをクライアントへダウンロードする機能を提供する。`nablarch.fw.web.HttpResponse` クラスのメソッドのみを使用してダウンロードを実装できる。

`HttpResponse` を使ったCSVファイルのダウンロード実装例。

- `setContentType(String)`: Content-Typeを設定する（例: `"text/csv; charset=Shift_JIS"`）
- `write(String)`: ダウンロードデータを書き込む
- `setContentDisposition(String)`: ダウンロードファイル名を設定する

```java
public HttpResponse doDownloadCharSequence(HttpRequest req, ExecutionContext context) {
    HttpResponse res = new HttpResponse();
    res.setContentType("text/csv; charset=Shift_JIS");
    res.write("ユーザID, ユーザ名\n");
    res.write("0000001, nabla\n");
    res.write("0000002, arch\n");
    res.write("0000003, arch\n");
    res.setContentDisposition("サンプルCSVファイル.csv");
    return res;
}
```

<details>
<summary>keywords</summary>

ファイルダウンロード, HttpResponse, ダウンロード機能, ファイル配信, nablarch.fw.web.HttpResponse, HttpRequest, ExecutionContext, setContentType, setContentDisposition, write, Content-Type設定, CSV出力, 文字シーケンスダウンロード

</details>

## 特徴 - 実装の容易性

## ダウンロードデータの作成方法

`HttpResponse` オブジェクトのメソッドのみを使用した単純な実装でダウンロードを実現できる。以下の4種類のデータ型でダウンロードデータを作成できる:

1. コンテンツタイプ・文字コードの設定: `HttpResponse#setContentType(String)`
2. ファイル名・インライン表示設定: `HttpResponse#setContentDisposition(String)`
3. レスポンスボディへのデータ書き込み:
   - バイト配列（`byte[]`）: `HttpResponse#write(byte[])`
   - 文字シーケンス（`CharSequence`）: `HttpResponse#write(CharSequence)`
   - 入力ストリーム（`InputStream`）: `HttpResponse#setBodyStream(InputStream)`
   - ファイルパス指定（`String`）: `HttpResponse#setContentPath(String)`

> **注意**: write / setBodyStream / setContentPath が同時に使用された場合の優先順位:
> 1. `setContentPath`（最優先）
> 2. `setBodyStream`
> 3. `write`（最低優先）
>
> 例: setBodyStreamとwriteが同時に呼ばれた場合、setBodyStreamの内容がダウンロードされ、writeの内容は無視される。

> **注意**: `write(CharSequence)` でダウンロードされる文字シーケンスは、Content-Typeヘッダのcharsetでエンコードされるためwriteメソッド実行前に `setContentType` で文字コードを設定すること。文字コードを設定しない場合はUTF-8でエンコードされる。バイト配列・ストリーム・ファイルパスのデータはContent-Typeのcharsetでエンコードされずそのままレスポンスに出力される。

## コード例（文字シーケンスをShift_JISでダウンロード）

```java
public HttpResponse doDownloadCharSequence(HttpRequest req, ExecutionContext context) {
    HttpResponse res = new HttpResponse();
    res.setContentType("text/csv; charset=Shift_JIS");
    res.write("ユーザID, ユーザ名\n");
    res.write("0000001, nabla\n");
    res.write("0000002, arch\n");
    res.write("0000003, arch\n");
    res.setContentDisposition("サンプルCSVファイル.csv");
    return res;
}
```

<details>
<summary>keywords</summary>

nablarch.fw.web.HttpResponse, setContentType, setContentDisposition, write, setBodyStream, setContentPath, ダウンロードデータ作成, 優先順位, 文字コードエンコード, 実装の容易性

</details>

## 特徴 - メモリリソースを圧迫しない大容量ファイルダウンロード

`write` メソッドでダウンロードデータを作成する際、データサイズが一定の閾値を超えると自動的にデータの保存先をメモリから一時ファイルに切り替える。

- データサイズが小さい場合: メモリ経由で高速ダウンロード
- データサイズが大きい場合: 一時ファイル経由でメモリ消費を抑制したダウンロード

アプリケーションプログラマがデータのサイズを意識した実装を行わなくとも、データサイズに応じて自動的に最適な方式が選択される。

<details>
<summary>keywords</summary>

一時ファイル切替, メモリ消費抑制, 大容量ファイル, バッファ閾値, ResponseBody, write, nablarch.fw.web.HttpResponse

</details>

## 要求

## 実装済み

- ファイルのダウンロード（テキスト/バイナリ）
- インライン表示（ブラウザ上に直接ファイルを表示）

  > **注意**: インライン表示の挙動はブラウザの種類やセキュリティ設定に依存する

- データサイズが大きい場合の一時ファイルへの切り替え
- ダウンロードファイル名への非ASCII文字（日本語等）の使用

  > **注意**: 非ASCII文字のファイル名をサポートするブラウザ: Internet Explorer、Firefox、Google Chrome。Windows版Safariは非ASCII文字未対応（ASCII文字は使用可能）

## 未実装

- ダウンロード履歴管理（一時ファイルをサーバ上に保管）

<details>
<summary>keywords</summary>

ダウンロード要件, インライン表示, 非ASCII文字, ダウンロード履歴, テキストファイル, バイナリファイル, 日本語ファイル名

</details>

## 構成

![クラス図](../../../knowledge/component/libraries/assets/libraries-05_FileDownload/FileDownload_ClassDiagram.png)

| クラス/インタフェース名 | 概要 |
|---|---|
| `nablarch.fw.web.HttpResponse` | ダウンロードデータとHTTPヘッダ情報を設定するHTTPレスポンスオブジェクト |
| `nablarch.fw.web.ResponseBody` | ダウンロードデータを保持するクラス。サイズが閾値を超えるとメモリから一時ファイルに切り替え |
| `nablarch.fw.web.HttpResponseSetting` | レスポンス関連設定（メモリバッファ上限・一時ファイルディレクトリ等）を保持するクラス。コンポーネント設定は :ref:`compornentDifinitionResponse` 参照 |
| `nablarch.fw.web.handler.HttpResponseHandler` | ダウンロードデータとHTTPヘッダをレスポンスに出力するハンドラ。一時ファイルはレスポンス出力後に削除 |
| `nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactory` | User-Agentヘッダに基づいてエンコーダを取得するクラス。コンポーネント設定は :ref:`compornentDifinition` 参照 |
| `nablarch.fw.web.download.encorder.DownloadFileNameEncoderEntry` | User-Agentヘッダパターンとエンコーダの関連を保持するエントリ |

<details>
<summary>keywords</summary>

nablarch.fw.web.HttpResponse, nablarch.fw.web.ResponseBody, nablarch.fw.web.HttpResponseSetting, nablarch.fw.web.handler.HttpResponseHandler, DownloadFileNameEncoderFactory, DownloadFileNameEncoderEntry, クラス構成, コンポーネント定義

</details>

## インタフェース定義

## インタフェース

| インタフェース名 | 概要 |
|---|---|
| `nablarch.fw.web.download.encorder.DownloadFileNameEncoder` | ダウンロードファイル名のエンコーダのインタフェース。URLエンコーディング方式とMIME-Bエンコーディング方式の実装クラスを標準提供。カスタムエンコーダが必要な場合は本インタフェースを実装する |

## 実装クラス（DownloadFileNameEncoderの実装）

| クラス名 | 概要 |
|---|---|
| `nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder` | RFC2047のMIME-Bエンコード方式でファイル名をエンコード |
| `nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder` | URLエンコード方式でファイル名をエンコード |

<details>
<summary>keywords</summary>

nablarch.fw.web.download.encorder.DownloadFileNameEncoder, nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder, nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder, エンコーダ, ファイル名エンコード, インタフェース定義

</details>

## nablarch.fw.web.HttpResponseクラスのメソッド

| メソッド名 | 概要 |
|---|---|
| `setContentType(String contentType)` | Content-Typeヘッダを設定。省略した場合はファイル名の拡張子から自動設定。`write(CharSequence)` 使用時はwriteメソッド実行前に必ず設定すること |
| `setContentDisposition(String fileName)` | Content-Dispositionヘッダを設定（インライン表示なし） |
| `setContentDisposition(String fileName, boolean inline)` | Content-Dispositionヘッダを設定（インライン表示の有無を指定） |
| `write(byte[] bytes)` | バイト配列をダウンロードデータとして設定 |
| `write(CharSequence text)` | 文字シーケンスをダウンロードデータとして設定。Content-TypeヘッダのcharsetでエンコードされるためsetContentType実行後に呼び出すこと |
| `setBodyStream(InputStream bodyStream)` | 入力ストリームをダウンロードデータとして設定 |
| `setContentPath(String path)` | ファイルパスを指定してダウンロード。指定パスに存在するファイルがダウンロードされる |

> **注意**: setContentPath > setBodyStream > writeの優先順位で有効になる。

![シーケンス図](../../../knowledge/component/libraries/assets/libraries-05_FileDownload/FileDownload_SequenceDiagram.png)

<details>
<summary>keywords</summary>

nablarch.fw.web.HttpResponse, setContentType, setContentDisposition, write, setBodyStream, setContentPath, メソッド一覧, ファイルダウンロード実装

</details>

## 設定の記述

## HTTPレスポンスの設定

```xml
<component name="responseSetting" class="nablarch.fw.web.HttpResponseSetting">
    <property name="bufferLimitSizeKb" value="512" />
    <property name="tempDirPath" value="/temp/download" />
</component>
```

## ファイル名エンコーダの設定

User-Agentヘッダに基づいてダウンロードファイル名のエンコーダを選択する。標準サポートのブラウザ（Internet Explorer、Google Chrome、Firefox）のみを対象とする場合はコンポーネント設定ファイルの定義を省略できる。

> **注意**: 設定を省略した場合のデフォルト動作: User-Agentが「`.*MSIE.*`」「`.*WebKit.*`」にマッチする場合はURLエンコーダ、「`.*Gecko.*`」にマッチする場合はMIME-Bエンコーダ、いずれにもマッチしない場合はURLエンコーダが使用される。

カスタム設定が必要な場合は初期ハンドラ構成を変更し、HttpResponseHandlerにDownloadFileNameEncoderFactoryを設定する（[web_gui](../../processing-pattern/web-application/web-application-web_gui.md) の標準ハンドラ構成参照）。

```xml
<list name="handlerQueue">
    <component class="nablarch.fw.web.handler.HttpResposeHandler">
        <property name="downloadFileNameEncoderFactory" ref="downloadFileNameEncoderFactory" />
    </component>
</list>

<component name="downloadFileNameEncoderFactory" class="nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactory">
    <property name="downloadFileNameEncoderEntries" ref="downloadFileNameEncoderEntries" />
    <property name="defaultEncoder" ref="urlEncoder" />
</component>

<list name="downloadFileNameEncoderEntries">
    <component class="nablarch.fw.web.download.DownloadFileNameEncoderEntry">
        <property name="userAgentPattern" value=".*MSIE.*"/>
        <property name="encoder" ref="urlEncoder" />
    </component>
    <component class="nablarch.fw.web.download.DownloadFileNameEncoderEntry">
        <property name="userAgentPattern" value=".*WebKit.*"/>
        <property name="encoder" ref="urlEncoder" />
    </component>
    <component class="nablarch.fw.web.download.DownloadFileNameEncoderEntry">
        <property name="userAgentPattern" value=".*Gecko.*"/>
        <property name="encoder" ref="mimeBEncoder" />
    </component>
</list>

<component name="mimeBEncoder" class="nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder">
    <property name="charset" value="UTF-8" />
</component>

<component name="urlEncoder" class="nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder">
    <property name="charset" value="UTF-8" />
</component>
```

<details>
<summary>keywords</summary>

HttpResponseSetting, bufferLimitSizeKb, tempDirPath, DownloadFileNameEncoderFactory, User-Agent, エンコーダ設定, handlerQueue, HttpResponseHandler, コンポーネント設定

</details>

## 設定内容詳細 - HTTPレスポンスの設定

**クラス**: `nablarch.fw.web.HttpResponseSetting`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| bufferLimitSizeKb | - | | 1024 | データをメモリにバッファリングするサイズの上限（KB）。この値を超えるダウンロードデータは一時ファイルに保存される |
| tempDirPath | String | | OSデフォルト（例: Windowsは `C:\WINDOWS\Temp`） | 一時ファイルが作成されるディレクトリパス。設定されたパスにディレクトリが存在しない場合は一時ファイル作成時に例外が発生する。本番環境では省略せず、適切なサイズ設計・権限設定が行われたディレクトリを指定すること |

<details>
<summary>keywords</summary>

nablarch.fw.web.HttpResponseSetting, bufferLimitSizeKb, tempDirPath, メモリバッファ上限, 一時ファイルディレクトリ

</details>

## 設定内容詳細 - ファイル名エンコーダの設定

**クラス**: `nablarch.fw.web.handler.HttpResponseHandler`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| downloadFileNameEncoderFactory | DownloadFileNameEncoderFactory | | デフォルトのDownloadFileNameEncoderFactory | ダウンロードファイル名のエンコーダを取得するクラス。省略した場合はDownloadFileNameEncoderFactoryのデフォルト値が使用される |

**クラス**: `nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactory`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| downloadFileNameEncoderEntries | List | | MSIE→URLエンコーダ, WebKit→URLエンコーダ, Gecko→MIME-Bエンコーダ | User-AgentパターンとエンコーダのエントリList |
| defaultEncoder | DownloadFileNameEncoder | | URLエンコーダ | デフォルトのダウンロードファイル名エンコーダ |

**クラス**: `nablarch.fw.web.download.DownloadFileNameEncoderEntry`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| userAgentPattern | String | ○ | | User-Agentヘッダにマッチする正規表現パターン。未設定の場合はDIコンテナ起動時に例外がスローされる |
| encoder | DownloadFileNameEncoder | | URLエンコーダ | ダウンロードファイル名をエンコードするクラス |

**クラス**: `nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| charset | String | | UTF-8 | ファイル名のエンコードに使用する文字コード |

**クラス**: `nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| charset | String | | UTF-8 | ファイル名のエンコードに使用する文字コード |

<details>
<summary>keywords</summary>

nablarch.fw.web.handler.HttpResponseHandler, nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactory, downloadFileNameEncoderEntries, defaultEncoder, nablarch.fw.web.download.DownloadFileNameEncoderEntry, userAgentPattern, encoder, downloadFileNameEncoderFactory, nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder, nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder, charset

</details>
