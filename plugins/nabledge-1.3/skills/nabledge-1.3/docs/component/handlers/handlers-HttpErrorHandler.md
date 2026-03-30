# HTTPエラー制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.HttpErrorHandler`

後続ハンドラ処理中の例外を捕捉し、障害ログ出力後HTTPエラーレスポンスを返す。正常終了時に遷移先画面・応答内容がどちらも未設定の場合は既定のエラー画面を設定する。

**関連ハンドラ**:
- [HttpResponseHandler](handlers-HttpResponseHandler.md): レスポンス処理はHttpResponseHandler側で行われるため、本ハンドラの上位に配置する必要がある。

<details>
<summary>keywords</summary>

HttpErrorHandler, nablarch.fw.handler.HttpErrorHandler, HTTPエラー制御, 例外捕捉, HTTPエラーレスポンス, HttpResponseHandler

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 後続ハンドラへ処理委譲。特段の処理なし。引数をそのまま後続ハンドラに渡しHTTPレスポンスオブジェクトを取得する。

**[復路処理]**
2. レスポンスボディ確認。以下のいずれかが満たされていればHTTPレスポンスオブジェクトを返却して終了:
   1. コンテンツパスが設定されている
   2. `HttpResponse#setInputStream()` によりInputStreamが設定されている
   3. `HttpResponse#write()` によりレスポンスボディがバッファリングされている

2a. レスポンスボディ未設定の場合、`HttpResponse#getStatusCode()` の値に対応するデフォルトページのコンテンツパスを設定して返却。デフォルトページ（設定省略時）:

| ステータスコード | コンテンツパス |
|---|---|
| 404 | servlet:///jsp/notFound.jsp |
| 401 | servlet:///jsp/unauthorized.jsp |
| 3.. (300〜399) | servlet:///jsp/redirecting.jsp |
| 4.. (400〜499、401/404除く) | servlet:///jsp/userError.jsp |
| 5.. (500〜599) | servlet:///jsp/systemError.jsp |

**[例外処理]**
送出された例外はリクエストコンテキストにキー名 **nablarch_error** で設定される。

| 捕捉した例外クラス | ログ出力 | 処理内容 |
|---|---|---|
| `nablarch.fw.NoMoreHandlerException` | Info | ステータスコード404のデフォルトページを設定したHTTPレスポンスを返却 |
| `nablarch.fw.web.HttpErrorResponse` | なし | この例外に指定されているHTTPレスポンスオブジェクトを返却 |
| `nablarch.fw.Result.Error` | なし | 例外のステータスコードに対応するデフォルトページを設定したHTTPレスポンスを返却。`writeFailureLogPattern`にマッチするステータスコードの場合は障害ログを出力 |
| `java.lang.StackOverflowError` | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスを返却 |
| `java.lang.ThreadDeath` | なし | 捕捉した例外を再送出（ログ出力は[GlobalErrorHandler](handlers-GlobalErrorHandler.md)で行われる） |
| `java.lang.VirtualMachineError`（StackOverflowError除く） | なし | 捕捉した例外を再送出（ログ出力は[GlobalErrorHandler](handlers-GlobalErrorHandler.md)で行われる） |
| 上記以外の実行時例外・エラー | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスを返却 |

<details>
<summary>keywords</summary>

HttpErrorHandler, NoMoreHandlerException, nablarch.fw.NoMoreHandlerException, HttpErrorResponse, nablarch.fw.web.HttpErrorResponse, nablarch.fw.Result.Error, StackOverflowError, ThreadDeath, VirtualMachineError, nablarch_error, デフォルトページ, ステータスコード, 例外処理, HttpResponse#setInputStream, HttpResponse#write, GlobalErrorHandler, HttpResponse#getStatusCode

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultPages | Map<String, String> | | ハンドラ処理フロー参照 | ステータスコード毎のデフォルト遷移先 |
| writeFailureLogPattern | String | | 500〜599（503除く） | Result.Error発生時の障害通知ログ出力対象ステータスコード（正規表現で指定） |

ステータスコードに `.` を含めることでワイルドカード指定可能。複数マッチの場合はワイルドカードの使用桁がより少ない方が優先される（例: ステータスコード404に対しては `4..` より `404` が優先）。

**defaultPages設定例**:
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

**writeFailureLogPattern設定例**（500〜599全て障害通知ログを出力する場合）:
```xml
<component class="nablarch.fw.web.handler.HttpErrorHandler">
    <property name="writeFailureLogPattern" value="5[0-9][0-9]" />
</component>
```

<details>
<summary>keywords</summary>

defaultPages, writeFailureLogPattern, デフォルト遷移先, 障害通知ログ, ワイルドカード設定, HttpErrorHandler, nablarch.fw.web.handler.HttpErrorHandler

</details>
