# HTTPアクセスログ（RESTfulウェブサービス用）ハンドラ

## 概要

RESTfulウェブサービス用のHTTPアクセスログを出力するハンドラ。

本ハンドラでは、以下の処理を行う。

- リクエスト処理開始時のアクセスログを出力する
- リクエスト処理完了時のアクセスログを出力する

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.JaxRsAccessLogHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>
```

## 制約

配置順序の制約:

1. :ref:`thread_context_handler` より後ろに配置すること。ログ出力処理でThreadContext（`nablarch.core.ThreadContext`）の内容が必要なため。
2. :ref:`http_error_handler` より前に配置すること。完了時のログ出力にエラーコードが必要なため。
3. セッションストアIDを出力する場合は :ref:`session_store_handler` より後ろに配置すること（詳細は :ref:`jaxrs_access_log-session_store_id` を参照）。

## アクセスログ出力内容の切り替え

アクセスログの出力内容の切り替え方法は、:ref:`log` および :ref:`jaxrs_access_log` を参照すること。
