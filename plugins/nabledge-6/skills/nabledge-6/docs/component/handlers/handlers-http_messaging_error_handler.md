# HTTPメッセージングエラー制御ハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingErrorHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-http</artifactId>
</dependency>
```

## 制約

- :ref:`http_response_handler` より後ろに配置すること。本ハンドラが生成した `HttpResponse` を :ref:`http_response_handler` が処理するため。

## 例外の種類に応じたログ出力とレスポンス生成

| 例外/エラー | ログレベル | レスポンス | 説明 |
|---|---|---|---|
| `NoMoreHandlerException` | INFO | 404 | リクエストを処理すべきハンドラが存在しなかったことを意味するため、証跡ログとして記録する。また、処理すべき action class が存在しなかったことを意味するため、HTTPステータスコードが 404 のレスポンスを生成する。 |
| `HttpErrorResponse` | なし | `HttpErrorResponse#getResponse()` | 後続のハンドラで業務例外(バリデーションなどを行った結果の例外)が発生したことを意味するので、ログ出力は行わない。 |
| `Result.Error` | 設定による | `Error#getStatusCode()` | `writeFailureLogPattern` の設定による。詳細は下記参照。 |
| `ApplicationException`, `MessagingException` | — | 400 | クライアントからのリクエストが不正であることを示す例外のため、HTTPステータスコードが 400 のレスポンスを生成する。 |
| 上記以外の例外・エラー | FATAL | 500 | 障害扱いとしてログ出力を行う。予期しない例外やエラーであるため、レスポンスは 500 としている。 |

**`writeFailureLogPattern` の設定**: `setWriteFailureLogPattern` に正規表現を設定する。正規表現が `Error#getStatusCode()` にマッチした場合のみ、FATAL レベルでログ出力。

## レスポンスボディが空の場合のデフォルトレスポンスの設定

詳細は :ref:`HTTPエラー制御ハンドラのデフォルトページの設定 <HttpErrorHandler_DefaultPage>` を参照。
