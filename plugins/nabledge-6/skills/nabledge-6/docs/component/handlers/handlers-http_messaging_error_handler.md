# HTTPメッセージングエラー制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/http_messaging/http_messaging_error_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/HttpMessagingErrorHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/NoMoreHandlerException.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Error.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessagingException.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpErrorHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingErrorHandler`

<details>
<summary>keywords</summary>

HttpMessagingErrorHandler, nablarch.fw.messaging.handler.HttpMessagingErrorHandler, ハンドラクラス

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

nablarch-fw-messaging-http, com.nablarch.framework, Mavenモジュール, 依存関係

</details>

## 制約

- [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること。本ハンドラが生成した `HttpResponse` を [http_response_handler](handlers-http_response_handler.md) が処理するため。

<details>
<summary>keywords</summary>

http_response_handler, HttpResponse, ハンドラ配置順序, 制約

</details>

## 例外の種類に応じたログ出力とレスポンス生成

| 例外/エラー | ログレベル | レスポンス | 説明 |
|---|---|---|---|
| `NoMoreHandlerException` | INFO | 404 | リクエストを処理すべきハンドラが存在しなかったことを意味するため、証跡ログとして記録する。また、処理すべき action class が存在しなかったことを意味するため、HTTPステータスコードが 404 のレスポンスを生成する。 |
| `HttpErrorResponse` | なし | `HttpErrorResponse#getResponse()` | 後続のハンドラで業務例外(バリデーションなどを行った結果の例外)が発生したことを意味するので、ログ出力は行わない。 |
| `Result.Error` | 設定による | `Error#getStatusCode()` | `writeFailureLogPattern` の設定による。詳細は下記参照。 |
| `ApplicationException`, `MessagingException` | — | 400 | クライアントからのリクエストが不正であることを示す例外のため、HTTPステータスコードが 400 のレスポンスを生成する。 |
| 上記以外の例外・エラー | FATAL | 500 | 障害扱いとしてログ出力を行う。予期しない例外やエラーであるため、レスポンスは 500 としている。 |

**`writeFailureLogPattern` の設定**: `setWriteFailureLogPattern` に正規表現を設定する。正規表現が `Error#getStatusCode()` にマッチした場合のみ、FATAL レベルでログ出力。

<details>
<summary>keywords</summary>

NoMoreHandlerException, HttpErrorResponse, Result.Error, ApplicationException, MessagingException, writeFailureLogPattern, ログ出力, レスポンス生成, 例外処理, エラーレスポンス

</details>

## レスポンスボディが空の場合のデフォルトレスポンスの設定

詳細は :ref:`HTTPエラー制御ハンドラのデフォルトページの設定 <HttpErrorHandler_DefaultPage>` を参照。

<details>
<summary>keywords</summary>

HttpErrorHandler_DefaultPage, デフォルトレスポンスボディ, デフォルトページ, レスポンスボディ空

</details>
