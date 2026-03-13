# HTTPアクセスログ（RESTfulウェブサービス用）ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/jaxrs_access_log_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessLogHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.JaxRsAccessLogHandler`

このハンドラでは、以下の処理を行う:

- リクエスト処理開始時のアクセスログを出力する
- リクエスト処理完了時のアクセスログを出力する

<details>
<summary>keywords</summary>

JaxRsAccessLogHandler, nablarch.fw.jaxrs.JaxRsAccessLogHandler, HTTPアクセスログハンドラ, RESTfulウェブサービス用アクセスログ, リクエスト処理開始時, リクエスト処理完了時, アクセスログ出力

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-jaxrs, com.nablarch.framework, モジュール依存関係, Maven依存設定

</details>

## 制約

ハンドラの配置順序に関する制約:

- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること。ログ出力処理内では、通常 ThreadContext に保持する内容が必要となるため。
- [http_error_handler](handlers-HttpErrorHandler.md) より前に配置すること。完了時のログ出力にエラーコードが必要なため。
- セッションストアIDを出力する場合は [session_store_handler](handlers-SessionStoreHandler.md) より後ろに配置すること。詳細は [jaxrs_access_log-session_store_id](../libraries/libraries-jaxrs_access_log.md) を参照。

<details>
<summary>keywords</summary>

ハンドラ配置順序, thread_context_handler, http_error_handler, session_store_handler, ThreadContext, セッションストアID, 配置制約

</details>

## アクセスログ出力内容の切り替え

アクセスログの出力内容の切り替え方法は [log](../libraries/libraries-log.md) および [jaxrs_access_log](../libraries/libraries-jaxrs_access_log.md) を参照すること。

<details>
<summary>keywords</summary>

アクセスログ出力内容, ログ設定切り替え, jaxrs_access_log, log設定

</details>
