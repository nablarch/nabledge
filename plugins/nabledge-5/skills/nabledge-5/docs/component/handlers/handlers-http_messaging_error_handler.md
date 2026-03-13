# HTTPメッセージングエラー制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/http_messaging/http_messaging_error_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/HttpMessagingErrorHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/NoMoreHandlerException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Error.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessagingException.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpErrorHandler.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingErrorHandler`

後続ハンドラで発生した例外・エラーを補足し、例外に応じたログ出力とHTTPレスポンスを生成する。レスポンスボディが未設定の場合、HTTPステータスコードに対応したデフォルトボディをレスポンスに設定する。

<details>
<summary>keywords</summary>

HttpMessagingErrorHandler, nablarch.fw.messaging.handler.HttpMessagingErrorHandler, HTTPメッセージングエラー制御ハンドラ, 例外処理, レスポンス生成, デフォルトボディ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-http</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-messaging-http, com.nablarch.framework, モジュール依存関係, Maven

</details>

## 制約

> **重要**: [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること。本ハンドラが生成した `HttpResponse` を [http_response_handler](handlers-http_response_handler.md) が処理するため、本ハンドラを [http_response_handler](handlers-http_response_handler.md) より後ろに設定する必要がある。

<details>
<summary>keywords</summary>

http_response_handler, ハンドラ配置順序, HttpResponse, 制約

</details>

## 例外の種類に応じたログ出力とレスポンス生成

| 例外クラス | ログレベル | レスポンス | 説明 |
|---|---|---|---|
| `NoMoreHandlerException` | INFO | 404 | 処理すべきaction classが存在しない |
| `HttpErrorResponse` | ログなし | `HttpErrorResponse#getResponse()` の値 | 業務例外（バリデーション等）のためログ出力なし |
| `Error` | 設定による | `Error#getStatusCode()` の値 | `writeFailureLogPattern` で制御 |
| `ApplicationException`, `MessagingException` | — | 400 | クライアントリクエスト不正 |
| 上記以外 | FATAL | 500 | 予期しない例外・エラー（障害扱い） |

**`writeFailureLogPattern` の設定**: `writeFailureLogPattern` プロパティに正規表現を設定する。`Error#getStatusCode()` の値とマッチした場合に `FATAL` レベルのログを出力する。

<details>
<summary>keywords</summary>

NoMoreHandlerException, HttpErrorResponse, Result.Error, ApplicationException, MessagingException, writeFailureLogPattern, ログレベル, エラーレスポンス, 例外ハンドリング, HTTPステータスコード, FATAL

</details>

## レスポンスボディが空の場合のデフォルトレスポンスの設定

後続ハンドラでレスポンスボディが設定されていない場合、HTTPステータスコードに対応したデフォルトボディをレスポンスに設定する。詳細は :ref:`HTTPエラー制御ハンドラのデフォルトページの設定 <HttpErrorHandler_DefaultPage>` を参照。

<details>
<summary>keywords</summary>

HttpErrorHandler_DefaultPage, デフォルトレスポンスボディ, HTTPステータスコード, デフォルトページ, レスポンスボディ未設定

</details>
