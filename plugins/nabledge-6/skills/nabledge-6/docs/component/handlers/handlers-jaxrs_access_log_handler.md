# HTTPアクセスログ（RESTfulウェブサービス用）ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/jaxrs_access_log_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessLogHandler.html)

## 概要

RESTfulウェブサービス用のHTTPアクセスログを出力するハンドラ。

本ハンドラでは、以下の処理を行う。

- リクエスト処理開始時のアクセスログを出力する
- リクエスト処理完了時のアクセスログを出力する

<details>
<summary>keywords</summary>

HTTPアクセスログ, RESTfulウェブサービス, アクセスログ出力タイミング, リクエスト処理開始, リクエスト処理完了

</details>

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.JaxRsAccessLogHandler`

<details>
<summary>keywords</summary>

JaxRsAccessLogHandler, nablarch.fw.jaxrs.JaxRsAccessLogHandler, HTTPアクセスログハンドラ, RESTfulウェブサービス

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

nablarch-fw-jaxrs, com.nablarch.framework, Mavenモジュール, 依存関係

</details>

## 制約

配置順序の制約:

1. :ref:`thread_context_handler` より後ろに配置すること。ログ出力処理でThreadContext（`nablarch.core.ThreadContext`）の内容が必要なため。
2. :ref:`http_error_handler` より前に配置すること。完了時のログ出力にエラーコードが必要なため。
3. セッションストアIDを出力する場合は :ref:`session_store_handler` より後ろに配置すること（詳細は :ref:`jaxrs_access_log-session_store_id` を参照）。

<details>
<summary>keywords</summary>

ハンドラ配置順序, ThreadContext, nablarch.core.ThreadContext, エラーコード, セッションストアID, thread_context_handler, http_error_handler, session_store_handler

</details>

## アクセスログ出力内容の切り替え

アクセスログの出力内容の切り替え方法は、:ref:`log` および :ref:`jaxrs_access_log` を参照すること。

<details>
<summary>keywords</summary>

アクセスログ出力内容切り替え, ログ設定, jaxrs_access_log, log

</details>
