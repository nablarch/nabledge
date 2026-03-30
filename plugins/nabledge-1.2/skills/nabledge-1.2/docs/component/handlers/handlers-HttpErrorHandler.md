# HTTPエラー制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.HttpErrorHandler`

後続ハンドラの処理中に送出された例外を捕捉し、障害ログ出力後にHTTPエラーレスポンスオブジェクトを作成して返す。後続ハンドラが正常終了した場合でも、処理結果に遷移先画面も応答内容も設定されていなければ、既定のエラー画面を遷移先として指定する。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 捕捉した例外に対するHTTPレスポンスオブジェクトの作成はこのハンドラが行うが、レスポンス処理自体は [HttpResponseHandler](handlers-HttpResponseHandler.md) 側で行われるため、このハンドラより上位に配置する必要がある。 |

<details>
<summary>keywords</summary>

HttpErrorHandler, nablarch.fw.handler.HttpErrorHandler, HttpResponseHandler, HTTPエラー制御, 例外捕捉, 障害ログ, エラーレスポンス

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 後続ハンドラへ処理委譲し、HTTPレスポンスオブジェクトを取得する（往路では特段の処理を行わない）。

**[復路処理]**

2. HTTPレスポンスオブジェクトにレスポンスボディの内容が設定されているか確認する。以下のいずれかが満たされていればHTTPレスポンスオブジェクトを返却して終了する。
   1. コンテンツパスが設定されている
   2. `HttpResponse#setInputStream()` によりInputStreamが設定されている
   3. `HttpResponse#write()` によりバッファリングされている

2a. レスポンスボディ内容が設定されていない場合、`HttpResponse#getStatusCode()` の値に合致するデフォルトページのコンテンツパスを設定して返却する（設定省略時のデフォルト）:

| ステータスコード | コンテンツパス |
|---|---|
| 404 | servlet:///jsp/notFound.jsp |
| 401 | servlet:///jsp/unauthorized.jsp |
| 3.. (300～399) | servlet:///jsp/redirecting.jsp |
| 4.. (400～499、401/404を除く) | servlet:///jsp/userError.jsp |
| 5.. (500～599) | servlet:///jsp/systemError.jsp |

**[例外処理]**

後続ハンドラ実行中に例外が送出された場合、送出された例外はリクエストコンテキストにキー名 **nablarch_error** で設定される。

| 捕捉した例外クラス | ログ出力 | 処理内容 |
|---|---|---|
| `nablarch.fw.NoMoreHandlerException` | Info | ハンドラキューが空の状態で後続ハンドラに委譲した場合に送出。ステータスコード404のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |
| `nablarch.fw.web.HttpErrorResponse` | なし | この例外に指定されているHTTPレスポンスオブジェクトを返却する。 |
| `nablarch.fw.Result.Error` | なし（条件付き） | 例外オブジェクトのステータスコードに対応するデフォルトページを遷移先とするHTTPレスポンスオブジェクトを返却する。`writeFailureLogPattern` に一致するステータスコードの場合は障害ログを出力する。 |
| `java.lang.StackOverflowError` | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |
| `java.lang.ThreadDeath` | なし | 捕捉した例外を再送出する（ログ出力は [GlobalErrorHandler](handlers-GlobalErrorHandler.md) で行われる）。 |
| `java.lang.VirtualMachineError`（StackOverflowErrorを除く） | なし | 捕捉した例外を再送出する（ログ出力は [GlobalErrorHandler](handlers-GlobalErrorHandler.md) で行われる）。 |
| 上記以外の実行時例外・エラー | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |

<details>
<summary>keywords</summary>

NoMoreHandlerException, nablarch.fw.NoMoreHandlerException, HttpErrorResponse, nablarch.fw.web.HttpErrorResponse, nablarch.fw.Result.Error, HttpResponse#setInputStream, HttpResponse#write, HttpResponse#getStatusCode, StackOverflowError, ThreadDeath, VirtualMachineError, GlobalErrorHandler, nablarch_error, デフォルトページ, ステータスコード, 例外処理フロー

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultPages | Map<String, String> | | ハンドラ処理フロー参照 | ステータスコード毎のデフォルト遷移先。ステータスコードに"."を含めることでワイルドカード指定可能。複数マッチする場合はワイルドカードの使用桁が少ない方を優先。 |
| writeFailureLogPattern | String | | 500～599（503を除く） | Result.Error発生時の障害通知ログ出力対象ステータスコードを正規表現で指定。 |

**標準設定（DI設定例）**:
```xml
<component class="nablarch.fw.web.handler.HttpResponseHandler" />
```

**ステータスコード毎のデフォルト遷移先を設定する場合**:

> **注意**: ステータスコードに"."を含めることでワイルドカード指定可能。複数マッチする場合はワイルドカードの使用桁が少ない遷移先を優先する（例: ステータスコード404は"4.."より"404"のエントリが優先される）。

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

**Result.Error発生時の障害通知ログ出力ステータスコードを変更する場合**:

```xml
<component class="nablarch.fw.web.handler.HttpErrorHandler">
  <property name="writeFailureLogPattern" value="5[0-9][0-9]" />
</component>
```

<details>
<summary>keywords</summary>

defaultPages, writeFailureLogPattern, ステータスコード毎のデフォルト遷移先, ワイルドカード設定, 障害通知ログ

</details>
