# HTTPアクセスログハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/http_access_log_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/HttpAccessLogHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.web.handler.HttpAccessLogHandler`

このハンドラでは、以下の処理を行う。
- リクエスト処理開始時のアクセスログを出力する
- リクエスト処理完了時のアクセスログを出力する

<details>
<summary>keywords</summary>

HttpAccessLogHandler, nablarch.common.web.handler.HttpAccessLogHandler, HTTPアクセスログハンドラ, リクエスト処理開始, リクエスト処理完了, アクセスログ出力タイミング

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

nablarch-fw-web, モジュール依存関係, Maven

</details>

## 制約

- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること。ログ出力処理で `ThreadContext` に保持する内容が必要なため。
- [http_error_handler](handlers-HttpErrorHandler.md) より前に配置すること。完了時のログ出力にエラーコードが必要なため。
- セッションストアIDを出力する場合は [session_store_handler](handlers-SessionStoreHandler.md) より後ろに配置すること。詳細は [http_access_log-session_store_id](../libraries/libraries-http_access_log.md) を参照。

<details>
<summary>keywords</summary>

ThreadContext, thread_context_handler, http_error_handler, session_store_handler, ハンドラ配置順序, 制約

</details>

## アクセスログ出力内容の切り替え

アクセスログの出力内容の切り替え方法は、[log](../libraries/libraries-log.md) および [http_access_log](../libraries/libraries-http_access_log.md) を参照すること。

<details>
<summary>keywords</summary>

アクセスログ出力内容切り替え, http_access_log, ログ設定

</details>
