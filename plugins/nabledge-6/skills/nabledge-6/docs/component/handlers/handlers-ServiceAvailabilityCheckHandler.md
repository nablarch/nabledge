# サービス提供可否チェックハンドラ

## 概要

サービス提供可否チェックは、ライブラリの :ref:`service_availability` を使用して行う。

**前提条件**: 本ハンドラを使用するには、`ServiceAvailability` を実装したクラスを本ハンドラに設定する必要がある。

## ハンドラクラス名

**クラス名**: `nablarch.common.availability.ServiceAvailabilityCheckHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth</artifactId>
</dependency>
```

## 制約

- :ref:`thread_context_handler` より後ろに配置すること: スレッドコンテキスト上のリクエストIDを使用するため、:ref:`thread_context_handler` より後ろに配置する必要がある。
- :ref:`forwarding_handler` より後ろに配置すること: 内部フォーワード時にフォーワード先の :ref:`内部リクエストID <internal_request_id>` でチェックしたい場合。あわせて :ref:`thread_context_handler` の `attributes` に `InternalRequestIdAttribute` を追加すること。

## リクエストに対するサービス提供可否チェック

`ThreadContext` からリクエストIDを取得し、:ref:`service_availability` を使用してサービス提供可否をチェックする。

処理フロー:
1. `ThreadContext` からリクエストIDを取得
2. :ref:`service_availability` を使用してサービス提供可否チェック
3. OK（サービス提供可）→ 後続ハンドラを呼び出す
4. NG（サービス提供不可）→ `ServiceUnavailable` (503) を送出

フォーワード先のリクエストIDでチェックしたい場合は、`ServiceAvailabilityCheckHandler.setUsesInternalRequestId(boolean)` で `true` を指定（デフォルト: `false`）。
