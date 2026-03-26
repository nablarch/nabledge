# HTTPメッセージングエラー制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingErrorHandler`

後続ハンドラの処理中に送出された例外を捕捉し、障害ログを出力後、HTTPエラーレスポンスオブジェクトを作成して返す。後続処理が正常終了し、遷移先画面・応答内容のいずれも設定されていない場合は、既定のエラー画面を遷移先として指定する。

> **注意**: 本ハンドラを経由したリクエストのレスポンスでは、内部ステータスコードをそのままHTTPステータスコードとして使用する（通常の画面オンライン処理ではエラー画面のレスポンスをステータスコード200で行うが、本ハンドラ経由では異なる）。

**ハンドラキュー構成** (コンテキスト: handler sub_thread data_read):
1. HttpResponseHandler
2. HttpMessagingErrorHandler

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 本ハンドラで作成したHTTPレスポンスオブジェクトのレスポンス処理を担当。本ハンドラの上位に配置すること。 |

<details>
<summary>keywords</summary>

HttpMessagingErrorHandler, nablarch.fw.messaging.handler.HttpMessagingErrorHandler, HttpResponseHandler, HTTPメッセージングエラー制御, HTTPエラーレスポンス, 例外捕捉

</details>

## ハンドラ処理フロー

**[往路処理]**

1. HTTPリクエストヘッダ `X-Requested-With` を設定し、後続処理で外部APIとして扱われるようにする（HTTPレスポンスハンドラが内部ステータスコードをそのままHTTPステータスコードとして応答するようになる）。後続ハンドラに処理を委譲し、HTTPレスポンスオブジェクトを取得する。

**[復路処理]**

2. HTTPレスポンスオブジェクトにレスポンスボディ内容が設定されているか確認。以下のいずれかが満たされていればHTTPレスポンスオブジェクトを返却して終了:
   1. コンテンツパスが設定されている
   2. `HttpResponse#setInputStream()` でInputStreamが設定されている
   3. `HttpResponse#write()` でバッファリングされている

2a. レスポンスボディ未設定の場合、`HttpResponse#getStatusCode()` に対応するデフォルトページのコンテンツパスを設定して返却。デフォルトページ:

| ステータスコード | コンテンツパス |
|---|---|
| 404 | servlet:///jsp/notFound.jsp |
| 401 | servlet:///jsp/unauthorized.jsp |
| 3.. (300～399) | servlet:///jsp/redirecting.jsp |
| 4.. (400～499、401/404除く) | servlet:///jsp/userError.jsp |
| 5.. (500～599) | servlet:///jsp/systemError.jsp |

**[例外処理]**

後続ハンドラ処理中に例外が送出された場合、捕捉した例外をリクエストコンテキストにキー名 `nablarch_error` で設定した上で、以下のように処理する:

| 捕捉した例外クラス | ログ出力 | 処理内容 |
|---|---|---|
| `nablarch.fw.NoMoreHandlerException` | Info | ステータスコード404のデフォルトページを設定したHTTPレスポンスを返却 |
| `nablarch.fw.web.HttpErrorResponse` | なし | この例外に指定されているHTTPレスポンスオブジェクトを返却 |
| `nablarch.fw.Result.Error` | なし（※） | 例外のステータスコードに対応するデフォルトページを設定したHTTPレスポンスを返却 |
| `java.lang.StackOverflowError` | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスを返却 |
| `java.lang.ThreadDeath` | なし | 捕捉した例外を再送出（ログ出力は [GlobalErrorHandler](handlers-GlobalErrorHandler.md) で行われる） |
| `java.lang.VirtualMachineError`（StackOverflowError除く） | なし | 捕捉した例外を再送出（ログ出力は [GlobalErrorHandler](handlers-GlobalErrorHandler.md) で行われる） |
| 上記以外の実行時例外・エラー | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスを返却 |

> **注意**: `nablarch.fw.Result.Error`（※）の場合、`writeFailureLogPattern` プロパティで指定した正規表現にマッチするステータスコードを持つErrorオブジェクトは障害ログを出力する。

<details>
<summary>keywords</summary>

X-Requested-With, HttpResponse, HttpResponse#setInputStream(), HttpResponse#write(), HttpResponse#getStatusCode(), NoMoreHandlerException, nablarch.fw.NoMoreHandlerException, HttpErrorResponse, nablarch.fw.web.HttpErrorResponse, Result.Error, nablarch.fw.Result.Error, StackOverflowError, ThreadDeath, VirtualMachineError, GlobalErrorHandler, nablarch_error, デフォルトページ, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultPages | Map\<String, String\> | | ハンドラ処理フロー参照 | ステータスコード毎のデフォルト遷移先。キーはステータスコード（`.`でワイルドカード指定可）、値はコンテンツパス。複数マッチする場合はワイルドカード使用桁が少ない方を優先。 |
| writeFailureLogPattern | String | | 500～599（503を除く） | `Result.Error`発生時に障害通知ログを出力するステータスコードの正規表現。全コードで出力する場合は`.*`を指定。 |

**標準設定**:

```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingErrorHandler" />
```

**ステータスコード毎のデフォルト遷移先を設定する場合**:

> **注意**: ステータスコードに `.` を含めることでワイルドカード指定可。複数マッチする場合はワイルドカード使用桁が少ない方を優先（例: ステータスコード404に対し `4..` と `404` が両方設定されていれば `404` が優先）。

```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingErrorHandler">
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

**Result.Error発生時の障害通知ログ出力対象ステータスコードを変更する場合**:

```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingErrorHandler">
    <!-- 500～599のステータスコードは全て障害通知ログを出力する場合 -->
    <property name="writeFailureLogPattern" value="5[0-9][0-9]" />
</component>
```

<details>
<summary>keywords</summary>

defaultPages, writeFailureLogPattern, ステータスコードデフォルト遷移先, 障害通知ログ, DI設定, ワイルドカード指定

</details>
