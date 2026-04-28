# ファイルダウンロード

## 概要

ファイルをクライアントへダウンロードする機能を提供する。

## 特徴

### 実装の容易性

HTTPレスポンスオブジェクト（ `HttpResponse` クラス）が提供するメソッドのみを使用し、単純な実装方法でダウンロードを実現できる。
アプリケーションプログラマは、ダウンロード用の特別なクラスの仕様などを学習する必要はない。
使用するHTTPレスポンスオブジェクトのメソッドを以下に記す。

1. コンテンツタイプ、文字コードの設定

  `HttpResponse#setContentType(String)`
2. ダウンロードファイル名、およびインライン表示有無の設定

  `HttpResponse#setContentDisposition(String)`
3. レスポンスボディに対するデータの書き込み

  a) バイト配列(byte[])の場合 ： `HttpResponse#write(byte[])`
  b) 文字シーケンス(CharSequence)の場合 ： `HttpResponse#write(CharSequence)`
  c) 入力ストリーム(java.io.InputStream)の場合 ： `HttpResponse#setBodyStream(InputStream)`
  d) ファイルパス指定(String)の場合 ： `HttpResponse#setContentPath(String)`

バイト配列、文字シーケンス、入力ストリーム、ファイルパス指定と、４種類のデータ型によるレスポンスデータの作成に対応しているので、通常複雑になりがちなダウンロード処理を容易に実装することができる。

> **Note:**
> writeメソッド、setBodyStreamメソッド、setContentPathメソッドが同時に使用された場合の優先順位を以下に記す。
> 　1. setContentPathメソッド
> 　2. setBodyStreamメソッド
> 　3. writeメソッド
> たとえば、setBodyStreamメソッドとwriteメソッドが同時に呼ばれた場合、setBodyStreamメソッドで設定した内容がダウンロードされ、writeメソッドで設定した内容は無視される。

以下に、コード例を記す。

```java
/** 文字シーケンスをShift_JISのデータとしてダウンロードする。 */
public HttpResponse doDownloadCharSequence(HttpRequest req, ExecutionContext context) {

    HttpResponse res = new HttpResponse();

    // HttpResponseのsetContentTypeメソッドを使用して、Content-Typeを設定する。
    res.setContentType("text/csv; charset=Shift_JIS");

    // HttpResponseのwriteメソッドを使用して、ダウンロードデータを生成する
    res.write("ユーザID, ユーザ名\n");
    res.write("0000001, nabla\n");
    res.write("0000002, arch\n");
    res.write("0000003, arch\n");

    // ファイル名を設定する
    res.setContentDisposition("サンプルCSVファイル.csv");

    return res;
}
```

> **Note:**
> HttpResponseクラスのwriteメソッドでダウンロードされる文字シーケンスは、Content-Typeヘッダに設定した文字コード（charset）でエンコードされるので、原則writeメソッド実行前に文字コードを設定しておく必要がある。
> もし文字コードの設定を行わず、writeメソッドを実行した場合、ダウンロードされる文字シーケンスはUTF-8でエンコードされる。

### サイズが大きいファイルをダウンロードする場合でもメモリリソースを圧迫しない

HttpResponseオブジェクトのwriteメソッドを用いてダウンロードデータを作成する際に、データサイズが一定の閾値を超えると、自動的にデータの保存先をメモリから一時ファイルに切り替える機能を提供する。
本機能を使用することで、アプリケーションプログラマがデータのサイズ（データ量）を意識した実装を行わなくとも、データサイズに応じて自動的に選択された最適な方式でダウンロードが行われる。
（データサイズが小さい場合はメモリ経由で高速なダウンロードが行われ、データサイズが大きい場合は一時ファイル経由でメモリ消費量を抑えたダウンロードが行われる）

## 要求

### 実装済み

* ファイルのダウンロードができる。
* テキストファイル、バイナリファイルのダウンロードができる。
* ダウンロードしたファイルのインライン表示ができる。

  通常、ファイルをダウンロードする場合、ファイルの保存先を選択するダイアログが表示されるが、
  インライン表示オプションを有効にすることで、ブラウザ上に直接ファイルを表示できる。
  本機能はイントラ環境等で、ダウンロードしたExcelファイルを直接ブラウザ上で表示する場合などに使用される。

  > **Note:**
> インライン表示の挙動はブラウザの種類やセキュリティ設定に依存する。
* データサイズが大きいダウンロードファイルを作成する際に、データの保存先を一時ファイルにできる。
* ダウンロードファイル名に日本語などの非ASCII文字(多言語)を使用できる。

  > **Note:**
> ファイル名に非ASCII文字(多言語)の使用をサポートをするブラウザは、Internet Explorer、Firefox、Google Chromeの３種類。
  > Windows版Safariは非Ascii文字には未対応（Ascii文字は使用可能）。

### 未実装

* ダウンロード履歴を残すことができる

  ダウンロードの際に使用した一時ファイルをサーバ上に保管することで履歴管理できる（byte配列、文字シーケンスを使う場合だけでなく、入力ストリームも保管する。また保管する一時ファイル名には、ダウンロードファイル名（+拡張子）が含まれるようにする。また、HTTPログと紐付けられるような情報を残す。

## 構成

### クラス図

![FileDownload_ClassDiagram.png](../../../knowledge/assets/libraries-05-FileDownload/FileDownload_ClassDiagram.png)

### 各クラスの責務

#### インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| nablarch.fw.web.download.encorder.DownloadFileNameEncoder | ダウンロードファイル名のエンコーダのインタフェース。本インタフェースの実装クラスを用いて、ファイル名を適切にエンコードすることで、非ASCII文字の使用が可能となる。標準では、URLエンコーディング方式およびMIME-Bエンコーディング方式の実装クラスを提供する。 URLエンコーディング方式およびMIME-Bエンコーディング方式以外のエンコーダが必要な場合は、本インタフェースを実装することにより実現可能。 現状、URLエンコーディング方式またはMIME-Bエンコーディング方式でほとんどのブラウザに対応可能なので、通常、利用者側で独自のエンコーダを実装する必要はない。 |

##### クラス定義

a) nablarch.fw.web.download.encorder.DownloadFileNameEncoderの実装クラス

| クラス名 | 概要 |
|---|---|
| nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder | ダウンロードファイル名をRFC2047の仕様に従い、MIME-Bエンコード方式でダウンロードファイル名をエンコードするエンコーダ。本ドキュメントでは、このエンコーダを「MIME-Bエンコーダ」と称する。 |
| nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder | URLエンコード方式でダウンロードファイル名をエンコードするエンコーダ。本ドキュメントでは、このエンコーダを「URLエンコーダ」と称する。 |

b) nablarch.fw.Handlerの実装クラス

| クラス名 | 概要 |
|---|---|
| nablarch.fw.web.handler.HttpResponseHandler | アプリケーションプログラマがHttpResponseクラスに設定したダウンロードデータおよびHTTPヘッダ情報をレスポンスに出力するハンドラ。 ダウンロードファイル名のエンコーダを取得するクラス（DownloadFileNameEncoderFactory）を用いて、ダウンロードファイル名のエンコーダを取得し、エンコードしたファイル名を、Content-Dispositionに設定する。 ダウンロードデータが一時ファイルに保存されている場合は、レスポンス出力後に不要になった一時ファイルを削除する。 |

c) その他のクラス

| クラス名 | 概要 |
|---|---|
| nablarch.fw.web.HttpResponse | アプリケーションプログラマがダウンロードデータおよびHTTPヘッダ情報を設定するHTTPレスポンスオブジェクト。 ダウンロードデータの出力、Content-Dispositionヘッダ、Content-Typeヘッダの設定機能を持つ。 |
| nablarch.fw.web.ResponseBody | ダウンロードデータを保持するクラス。 ダウンロードデータのサイズが一定量を超えると、データの保存先をメモリから一時ファイルに変更し、メモリ消費量を抑制する機能を持つ。 |
| nablarch.fw.web.HttpResponseSetting | レスポンスに関連する設定を保持するクラス。コンポーネント設定ファイルで本クラスを定義することで、設定の変更が可能となる。 具体的には、以下の設定を行うことができる。 ・ ダウンロードデータをメモリにバッファリングするサイズの上限 ・ 一時ファイルの出力先フォルダのパス ・ 一時ファイルの使用有無などの設定を保持するクラス コンポーネント設定ファイルについては、 [HTTPレスポンスの設定](../../component/libraries/libraries-05-FileDownload.md#compornentdifinitionresponse) の項を参照すること。 |
| nablarch.fw.web.download.encorder.DownloadFileNameEncoderEntry | User-Agentヘッダのパターン（例：「.*MSIE.*」）とダウンロードファイル名のエンコーダの関連を保持するエントリ。 |
| nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactory | ダウンロードファイル名のエンコーダを取得（生成）するクラス。User-Agentヘッダとエンコーダの関連は、コンポーネント設定ファイルで容易に編集が可能。 コンポーネント設定ファイルについては、 [ファイル名のエンコーダの設定の記述](../../component/libraries/libraries-05-FileDownload.md#compornentdifinition) の項を参照すること。 |

### クラス詳細

#### nablarch.fw.web.HttpResponseクラスのメソッド

| メソッド名 | 概要 |
|---|---|
| setContentType(String contentType) | Content-Typeヘッダを設定するメソッド 。省略した場合、setContentDispositionメソッドの引数で指定されたファイル名の拡張子をもとに自動的にContent-Typeが設定される。 アプリケーションプログラマが任意でContent-Typeを設定する場合は、本メソッドを使用する。 特に、writeメソッドで文字シーケンスデータを作成する場合は、Content-Typeヘッダに設定した文字コード（charset）でエンコードされるので、writeメソッド実行前に必ず本メソッドを実行し、文字コードを設定しておく必要がある。たとえば、Shift_JISの文字シーケンスデータを作成する場合は、本メソッドの引数に「text/csv; charset=Shift_JIS」のような値を設定すれば良い。 バイト配列、ストリーム、ファイルパスのデータをダウンロードする場合は、Content-Typeヘッダに設定した文字コードでエンコードは行われずそのままデータがレスポンスに出力される。 |
| setContentDisposition(String fileName) | Content-Dispositionヘッダを設定するメソッド。ダウンロードファイル名を指定する。このメソッドを使用する場合、インライン表示は行われない。 |
| setContentDisposition(String fileName, boolean inline) | Content-Dispositionヘッダを設定するメソッド。ダウンロードファイル名およびインライン表示の有無を指定する。 |
| write(byte[] bytes) | ダウンロードデータとしてバイト配列を使用する際に使用するメソッド 。 |
| write(CharSequence text) | ダウンロードデータとして文字シーケンスを使用する際に使用するメソッド 。 |
| setBodyStream(InputStream bodyStream) | ダウンロードデータとして入力ストリームを使用する際に使用するメソッド 。引数で渡された入力ストリームがダウンロードされる。 |
| setContentPath(String path) | ダウンロードデータとしてファイルパスを使用する際に使用するメソッド 。引数で渡されたパスに存在するファイルがダウンロードされる。 |

### シーケンス図

本機能のシーケンス図を下記に示す。

![FileDownload_SequenceDiagram.png](../../../knowledge/assets/libraries-05-FileDownload/FileDownload_SequenceDiagram.png)

## 設定の記述

ファイルダウンロード機能は、リポジトリ機能を利用して設定を行うことができる。

### HTTPレスポンスの設定

```xml
<!-- レスポンスの設定を保持するクラス -->
<component name="responseSetting" class="nablarch.fw.web.HttpResponseSetting">
    <!-- データをメモリにバッファリングするサイズの上限（KB）  -->
    <property name="bufferLimitSizeKb" value="512" />
    <!-- 一時ファイルが生成されるディレクトリ -->
    <property name="tempDirPath" value="/temp/download" />
</component>
```

#### 設定内容詳細

##### nablarch.fw.web.HttpResponseの設定

| property名 | 設定内容 |
|---|---|
| bufferLimitSizeKb | データをメモリにバッファリングするサイズの上限（KB）。 本プロパティの設定を省略した場合は「1024」（1MB）が設定される。 本プロパティで設定したサイズを超えるダウンロードデータは、 メモリではなく一時ファイルに保存される。 本プロパティの設定の最小値は「16」(KB)とする。 |
| tempDirPath | 一時ファイルが作成されるディレクトリパス。 本プロパティで設定されたパスにディレクトリが存在しない場合、 一時ファイル作成時に例外が発生する。 本プロパティの設定を省略した場合、OSデフォルトの一時ディレクトリに 一時ファイルが生成される （たとえばWINDOWSならば「C:\\WINDOWS\\Temp」が一時ディレクトリとなる。 詳細はjava.io.FileクラスのcreateTempFileメソッドのAPI仕様を参照すること）。 本番環境では本プロパティは省略せず、事前に適切なサイズ設計、 権限設定が行われたディレクトリを用意し、そのパスを本プロパティに設定すること。 |

### ファイル名のエンコーダの設定の記述

本機能は、クライアントのブラウザから送信されるUser-Agentヘッダの内容をもとに、使用するダウンロードファイル名のエンコーダを選択する。
User-Agentヘッダとエンコーダの関連は、コンポーネント設定ファイルで定義できる。

標準サポートのブラウザ（Internet Explorer、Google Chrome、Firefox）のみを想定する場合、コンポーネント設定ファイルの定義をすべて省略しても、ファイル名は適切にエンコードされる。
サポート外のブラウザに対応する必要がでてきた場合や、ブラウザのバージョンアップでUser-Agentヘッダの仕様が変わった場合は、コンポーネント設定ファイルに独自の設定を定義する。

> **Note:**
> コンポーネント設定ファイルの定義をすべて省略した場合、User-Agentヘッダの内容が「.*MSIE.*」、
> 「.*WebKit.*」のパターンにマッチする場合にはURLエンコーダ、「.*Gecko.*」のパターンにマッチする場合にはMIME-Bエンコーダ、
> いずれのパターンにもマッチしない場合はURLエンコーダが使用される。
> コンポーネント設定ファイルに独自の設定を定義する場合は、
> 初期ハンドラ構成を変更し、HTTPレスポンスハンドラにダウンロードファイル名のエンコーダを取得するクラス
> （DownloadFileNameEncoderFactory）を設定する必要がある。初期ハンドラ構成については、
>  [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md#web-gui) の標準ハンドラ構成の項を参照すること。

```xml
<!-- 初期ハンドラ構成 -->
<list name="handlerQueue">
    <!-- 他のコンポーネントは省略 -->
    <!-- HTTPレスポンスハンドラ -->
    <component class="nablarch.fw.web.handler.HttpResposeHandler">
        <!-- ダウンロードファイル名のエンコーダを取得するクラスを設定する -->
        <property name="downloadFileNameEncoderFactory" ref="downloadFileNameEncoderFactory" />
    </component>
    <!-- 他のコンポーネントは省略 -->
</list>

<!-- ダウンロードファイル名のエンコーダを取得するクラス -->
<component name="downloadFileNameEncoderFactory" class="nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactory">
    <!-- User-Agentヘッダのパターンとエンコード方式の関連を保持するエントリ  -->
    <property name="downloadFileNameEncoderEntries" ref="downloadFileNameEncoderEntries" />
    <!-- 標準のエンコーダを指定する -->
    <property name="defaultEncoder" ref="urlEncoder" />
</component>

<!--
  User-Agentヘッダとエンコーダの関連を保持するエントリ
           エントリに定義した順番で（上から下に）、User-Agentヘッダのパターンマッチが行われる。
           本設定例であれば、「.*MSIE.*」「.*WebKit.*」「.*Gecko.*」の順番でパターンマッチが行われる。
-->
<list name="downloadFileNameEncoderEntries">
    <!-- 「MSIE」が含まれる場合はURLエンコーダを使用する-->
    <component class="nablarch.fw.web.download.DownloadFileNameEncoderEntry">
        <property name="userAgentPattern" value=".*MSIE.*"/>
        <property name="encoder" ref="urlEncoder" />
    </component>
    <!-- 「WebKit」が含まれる場合はURLエンコーダを使用する -->
    <component class="nablarch.fw.web.download.DownloadFileNameEncoderEntry">
        <property name="userAgentPattern" value=".*WebKit.*"/>
        <property name="encoder" ref="urlEncoder" />
    </component>
    <!-- 「Gecko」が含まれる場合はMIME-Bエンコーダを使用する -->
    <component class="nablarch.fw.web.download.DownloadFileNameEncoderEntry">
        <property name="userAgentPattern" value=".*Gecko.*"/>
        <property name="encoder" ref="mimeBEncoder" />
    </component>
</list>

<!-- MIME-Bエンコーダの設定 -->
<component name="mimeBEncoder" class="nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder">
    <!-- 標準の文字コード -->
    <property name="charset" value="UTF-8" />
</component>

<!-- URLエンコーダの設定 -->
<component name="urlEncoder" class="nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder">
    <!-- 標準の文字コード -->
    <property name="charset" value="UTF-8" />
</component>
```

#### 設定内容詳細

##### nablarch.fw.web.handler.HttpResposeHandlerの設定

| property名 | 設定内容 |
|---|---|
| downloadFileNameEncoderFactory | ダウンロードファイル名のエンコーダを取得するクラス。 本プロパティの設定を省略した場合、DownloadFileNameEncoderFactoryクラスが使用され、DownloadFileNameEncoderFactoryクラスのdownloadFileNameEncoderEntriesプロパティおよびdefaultEncoderプロパティには、デフォルト値が設定される。 DownloadFileNameEncoderFactoryのデフォルト値（プロパティの設定を省略した場合の値）については、 [nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactoryの設定](../../component/libraries/libraries-05-FileDownload.md#downloadfilenameencoderfactory) を参照すること。 |

##### nablarch.fw.web.download.encorder.DownloadFileNameEncoderFactoryの設定

| property名 | 設定内容 |
|---|---|
| downloadFileNameEncoderEntries | User-Agentヘッダのパターンと、ダウンロードファイル名のエンコーダの関連を保持するエントリ のList。 本プロパティの設定を省略した場合、以下の３種類のエントリがデフォルトで登録される。 1.User-Agentパターン「".*MSIE.*"」、エンコーダ「URLエンコーダ」。 2.User-Agentパターン「".*WebKit.*"」、エンコーダ「URLエンコーダ」。 3.User-Agentパターン「".*Gecko.*"」、エンコーダ「Mime-Bエンコーダ」。 |
| defaultEncoder | 標準のダウンロードファイル名のエンコーダ。本プロパティの設定を省略した場合、URLエンコーダが使用される。 |

##### nablarch.fw.web.download.DownloadFileNameEncoderEntryの設定

| property名 | 設定内容 |
|---|---|
| userAgentPattern(必須) | User-Agentヘッダにマッチするパターン。本プロパティが設定されていない場合、DIコンテナ起動時に例外がスローされる。 |
| encoder | ダウンロードファイル名をエンコードするクラス。本プロパティの設定を省略した場合、URLエンコーダが使用される。 |

##### nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoderの設定

| property名 | 設定内容 |
|---|---|
| charset | ファイル名のエンコードに使用する文字コードを設定する。本プロパティの設定を省略した場合、「UTF-8」が使用される。 |

##### nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoderの設定

| property名 | 設定内容 |
|---|---|
| charset | ファイル名のエンコードに使用する文字コードを設定する。本プロパティの設定を省略した場合、「UTF-8」が使用される。 |

## 使用例

```java
/** 文字シーケンスをShift_JISのデータとしてダウンロードする。 */
public HttpResponse doDownloadCharSequence(HttpRequest req, ExecutionContext context) {

    HttpResponse res = new HttpResponse();

    // HttpResponseのsetContentTypeメソッドを使用して、Content-Typeを設定する。
    res.setContentType("text/csv; charset=Shift_JIS");

    // HttpResponseのwriteメソッドを使用して、ダウンロードデータを生成する
    res.write("ユーザID, ユーザ名\n");
    res.write("0000001, nabla\n");
    res.write("0000002, arch\n");
    res.write("0000003, arch\n");

    // ファイル名を設定する
    res.setContentDisposition("サンプルCSVファイル.csv");

    return res;
}
```
