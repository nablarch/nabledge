# サービス提供可否チェックハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/ServiceAvailabilityCheckHandler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/availability/ServiceAvailability.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/availability/ServiceAvailabilityCheckHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/InternalRequestIdAttribute.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/ServiceUnavailable.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.availability.ServiceAvailabilityCheckHandler`

<details>
<summary>keywords</summary>

ServiceAvailabilityCheckHandler, nablarch.common.availability.ServiceAvailabilityCheckHandler, サービス提供可否チェックハンドラ, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-common-auth, com.nablarch.framework, モジュール依存関係, Maven依存設定

</details>

## 制約

- 本ハンドラを使用するには、`ServiceAvailability` を実装したクラスを本ハンドラに設定する必要がある。
- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること。スレッドコンテキスト上に設定されたリクエストIDをもとにサービス提供可否チェックを行うため。
- 内部フォーワード先のリクエストID（[内部リクエストID](handlers-forwarding_handler.md)）でチェックしたい場合は、[forwarding_handler](handlers-forwarding_handler.md) より後ろに配置すること。合わせて [thread_context_handler](handlers-thread_context_handler.md) の `attributes` に `InternalRequestIdAttribute` を追加すること。

<details>
<summary>keywords</summary>

thread_context_handler, forwarding_handler, InternalRequestIdAttribute, ハンドラ配置順序, 制約, 内部フォーワード, internal_request_id, ServiceAvailability, 設定必須, 前提条件

</details>

## リクエストに対するサービス提供可否チェック

`ThreadContext` からリクエストIDを取得してサービス提供可否をチェック（詳細は :ref:`service_availability` 参照）。

- OK（サービス提供可）: 後続ハンドラを呼び出す
- NG（サービス提供不可）: `ServiceUnavailable` (503) を送出

フォーワード先のリクエストIDをチェック対象にするには、`ServiceAvailabilityCheckHandler.setUsesInternalRequestId` に `true` を設定する（デフォルト: `false`）。

<details>
<summary>keywords</summary>

ThreadContext, ServiceUnavailable, setUsesInternalRequestId, リクエストID, サービス提供可否チェック, 503, 内部リクエストID, service_availability

</details>
