# HTTPアクセスログハンドラ

## ハンドラクラス名

:ref:`HTTPアクセスログ <http_access_log>` を出力するハンドラ。リクエスト処理開始時と完了時にアクセスログを出力する。

**クラス名**: `nablarch.common.web.handler.HttpAccessLogHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

- :ref:`thread_context_handler` より後ろに配置すること。ログ出力処理で `ThreadContext` の内容が必要なため。
- :ref:`http_error_handler` より前に配置すること。完了時ログにエラーコードが必要なため。
- セッションストアIDを出力する場合は :ref:`session_store_handler` より後ろに配置すること。詳細は :ref:`http_access_log-session_store_id` を参照。

## アクセスログ出力内容の切り替え

出力内容の切り替え方法は :ref:`log` および :ref:`http_access_log` を参照すること。
