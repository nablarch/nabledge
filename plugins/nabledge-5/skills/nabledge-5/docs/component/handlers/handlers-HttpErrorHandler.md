# HTTPエラー制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/HttpErrorHandler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpErrorHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/NoMoreHandlerException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Error.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/message/ErrorMessages.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/WebConfig.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.HttpErrorHandler`

<details>
<summary>keywords</summary>

HttpErrorHandler, nablarch.fw.web.handler.HttpErrorHandler, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, モジュール依存関係

</details>

## 制約

- [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること。本ハンドラで生成した `HttpResponse` をHTTPレスポンスハンドラが処理するため。
- [http_access_log_handler](handlers-http_access_log_handler.md) より後ろに配置すること。本ハンドラで生成したエラー用 `HttpResponse` を元にログ出力を行うため。

<details>
<summary>keywords</summary>

http_response_handler, http_access_log_handler, 配置順序制約, ハンドラ配置順序

</details>

## 例外の種類に応じた処理とレスポンスの生成

| 例外/エラー | ログレベル | レスポンス | 説明 |
|---|---|---|---|
| `NoMoreHandlerException` | INFO | 404 | リクエストを処理すべきハンドラが存在しなかった。証跡ログとして記録。 |
| `HttpErrorResponse` | なし | `HttpErrorResponse#getResponse()` の戻り値 | 業務例外のためログ出力なし。 |
| `Error` | 設定による | `Error#getStatusCode()` の戻り値 | `writeFailureLogPattern` の設定による（下記参照）。 |
| `StackOverflowError` | FATAL | 500 | データや実装バグに起因する可能性があるため障害として通知。 |
| `ThreadDeath`、`VirtualMachineError`（StackOverflowError以外） | — | — | 本ハンドラでは何もせず上位ハンドラにエラーを再送出。 |
| 上記以外の例外・エラー | FATAL | 500 | 障害扱いとしてログ出力。 |

**HttpErrorResponseの原因例外がApplicationExceptionの場合の処理:**
1. `ApplicationException` が保持するメッセージ情報を `ErrorMessages` に変換する。
2. `ErrorMessages` をリクエストスコープに設定する。デフォルトのキー名は `errors`。`errorMessageRequestAttributeName` プロパティで変更可能:

```xml
<component name="webConfig" class="nablarch.common.web.WebConfig">
  <property name="errorMessageRequestAttributeName" value="messages" />
</component>
```

**Result.Errorのログ出力:**
`writeFailureLogPattern` に正規表現を設定する。`Error#getStatusCode()` とマッチした場合に `FATAL` レベルのログを出力する。

<details>
<summary>keywords</summary>

NoMoreHandlerException, HttpErrorResponse, ApplicationException, ErrorMessages, writeFailureLogPattern, errorMessageRequestAttributeName, 例外処理, ログ出力, エラーレスポンス生成, Result.Error, StackOverflowError, ThreadDeath, VirtualMachineError, WebConfig

</details>

## デフォルトページの設定

後続ハンドラや本ハンドラのエラー処理で作成した `HttpResponse` に対してデフォルトページを適用する機能。HttpResponseにページが設定されていなかった場合、`defaultPage` または `defaultPages` で設定されたデフォルトのページを適用する。

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

> **重要**: この機能を使用した場合、`web.xml` へのエラーページ設定（`error-page`要素）と重複してJSPの設定が必要となる。`web.xml` へ設定しなかった場合、エラーの発生場所によってはウェブサーバのデフォルトのエラーページが表示される。デフォルトのエラーページ設定は本機能ではなく `web.xml` へ行うことを推奨する。

<details>
<summary>keywords</summary>

defaultPages, defaultPage, デフォルトページ設定, エラーページ, web.xml, HttpResponse

</details>
