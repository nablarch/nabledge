# HTTPエラー制御ハンドラ

## 

**クラス名**: `nablarch.fw.handler.HttpErrorHandler`

<details>
<summary>keywords</summary>

HttpErrorHandler, nablarch.fw.handler.HttpErrorHandler, HTTPエラー制御ハンドラ, クラス名

</details>

## 概要

後続ハンドラの処理中に送出された例外を捕捉し、障害ログを出力後、HTTPエラーレスポンスオブジェクトを作成して返す。

後続ハンドラが正常終了し、遷移先画面も応答内容も設定されていない場合は、既定のエラー画面を遷移先として指定する。

<details>
<summary>keywords</summary>

HTTPエラーレスポンス, 例外処理, 障害ログ, デフォルトエラー画面, 後続ハンドラ

</details>

## 

ハンドラキュー内の位置: `HttpResponseHandler → HttpErrorHandler`

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 捕捉した例外に対するHTTPレスポンスオブジェクトを作成するが、レスポンス処理自体はHttpResponseHandler側で行われるため、本ハンドラの上位に配置する必要がある。 |

<details>
<summary>keywords</summary>

HttpResponseHandler, ハンドラキュー, 関連するハンドラ, ハンドラ処理概要

</details>

## ハンドラ処理フロー

**往路処理**

1. 後続ハンドラへの処理委譲: 往路では特段の処理を行わない。引数をそのまま後続ハンドラに渡す。

**復路処理**

2. レスポンスボディ内容の確認: 以下のいずれかが満たされていれば、HTTPレスポンスオブジェクトを返却して終了する:
   1. コンテンツパスが設定されている
   2. `HttpResponse#setInputStream()` によりInputStreamが設定されている
   3. `HttpResponse#write()` によりレスポンスボディがバッファリングされている

2a. レスポンスボディが設定されていない場合: `HttpResponse#getStatusCode()` の値に合致するデフォルトページへのコンテンツパスを設定して返却する。

デフォルトページ（設定省略時）:

| ステータスコード | コンテンツパス |
|---|---|
| 404 | servlet:///jsp/notFound.jsp |
| 401 | servlet:///jsp/unauthorized.jsp |
| 3xx（300〜399） | servlet:///jsp/redirecting.jsp |
| 4xx（400〜499、401/404除く） | servlet:///jsp/userError.jsp |
| 5xx（500〜599） | servlet:///jsp/systemError.jsp |

**例外処理**

後続ハンドラ実行中に例外が送出された場合、送出された例外はリクエストコンテキストにキー名 `nablarch_error` で設定される。

| 捕捉した例外クラス | ログ出力 | 処理内容 |
|---|---|---|
| nablarch.fw.NoMoreHandlerException | Info | ステータスコード404のデフォルトページを設定したHTTPレスポンスを返却 |
| nablarch.fw.web.HttpErrorResponse | なし | この例外に指定されているHTTPレスポンスオブジェクトを返却 |
| nablarch.fw.Result.Error | なし | 例外のステータスコードに対応するデフォルトページを遷移先とするHTTPレスポンスを返却 |
| java.lang.StackOverflowError | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスを返却 |
| java.lang.ThreadDeath | なし | 何もせずに捕捉した例外を再送出（ログ出力は[GlobalErrorHandler](handlers-GlobalErrorHandler.md)で行われる） |
| java.lang.VirtualMachineError（StackOverflowError除く） | なし | 何もせずに捕捉した例外を再送出（ログ出力は[GlobalErrorHandler](handlers-GlobalErrorHandler.md)で行われる） |
| 上記以外の実行時例外・エラー | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスを返却 |

> **注意**: `writeFailureLogPattern`プロパティで指定された正規表現にマッチするステータスコードをもつResult.Errorオブジェクトの場合には、障害ログを出力する。

<details>
<summary>keywords</summary>

NoMoreHandlerException, HttpErrorResponse, Result.Error, StackOverflowError, ThreadDeath, VirtualMachineError, GlobalErrorHandler, 往路処理, 復路処理, 例外処理, nablarch_error, ステータスコード, デフォルトページ, HttpResponse

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultPages | Map<String, String> | | ハンドラ処理フロー参照 | ステータスコード毎のデフォルト遷移先 |
| writeFailureLogPattern | String | | 500〜599（503除く） | Result.Error発生時の障害通知ログ出力対象ステータスコード（正規表現で指定） |

> **補足**: `writeFailureLogPattern`で全ステータスコードを対象にする場合は `".*"` と指定する。

**標準設定例:**
```xml
<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler" />
```

**ステータスコード毎のデフォルト遷移先を設定する場合:**

ステータスコードに `"."` を含めることでワイルドカード指定可能。複数の遷移先がマッチする場合は、ワイルドカードの使用桁が少ない方を優先（例: ステータスコード404に対して `"4.."` と `"404"` がマッチする場合、`"404"` が優先）。

```xml
<component class="nablarch.fw.web.handler.HttpErrorHandler">
    <property name="defaultPages">
        <map>
        <entry key="4.." value="/USER_ERROR.jsp" />
        <entry key="404" value="/NOT_FOUND.jsp" />
        <entry key="5.." value="/ERROR.jsp" />
        <entry key="503" value="/NOT_IN_SERVICE.jsp" />
        </map>
    </property>
</component>
```

**Result.Error発生時の障害通知ログ出力ステータスコードを変更する場合:**

```xml
<component class="nablarch.fw.web.handler.HttpErrorHandler">
    <property name="writeFailureLogPattern" value="5[0-9][0-9]" />
</component>
```

<details>
<summary>keywords</summary>

defaultPages, writeFailureLogPattern, DI設定, ワイルドカード指定, デフォルト遷移先, XML設定例

</details>
