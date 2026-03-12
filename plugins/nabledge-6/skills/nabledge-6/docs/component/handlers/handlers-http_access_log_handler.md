# HTTPアクセスログハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/http_access_log_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html)

## ハンドラクラス名

[HTTPアクセスログ](../libraries/libraries-http_access_log.md) を出力するハンドラ。リクエスト処理開始時と完了時にアクセスログを出力する。

**クラス名**: `nablarch.common.web.handler.HttpAccessLogHandler`

<details>
<summary>keywords</summary>

HttpAccessLogHandler, nablarch.common.web.handler.HttpAccessLogHandler, HTTPアクセスログ, アクセスログ出力, リクエスト処理

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

nablarch-fw-web, com.nablarch.framework, モジュール, 依存関係

</details>

## 制約

- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること。ログ出力処理で `ThreadContext` の内容が必要なため。
- [http_error_handler](handlers-HttpErrorHandler.md) より前に配置すること。完了時ログにエラーコードが必要なため。
- セッションストアIDを出力する場合は [session_store_handler](handlers-SessionStoreHandler.md) より後ろに配置すること。詳細は [http_access_log-session_store_id](../libraries/libraries-http_access_log.md) を参照。

<details>
<summary>keywords</summary>

ThreadContext, nablarch.core.ThreadContext, 配置順序, ハンドラ制約, スレッドコンテキスト, セッションストアID

</details>

## アクセスログ出力内容の切り替え

出力内容の切り替え方法は [log](../libraries/libraries-log.md) および [http_access_log](../libraries/libraries-http_access_log.md) を参照すること。

<details>
<summary>keywords</summary>

アクセスログ切り替え, 出力内容設定, ログ設定

</details>
