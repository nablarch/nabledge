# サービス提供可否チェックハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* リクエストに対するサービス提供可否チェック

本ハンドラでは、 [リクエストに対するサービス提供可否チェック](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md#serviceavailabilitycheckhandler-request-checking) を行う。

サービス提供可否チェックは、ライブラリの [サービス提供可否チェック](../../component/libraries/libraries-service-availability.md#service-availability) を使用して行う。
そのため、本ハンドラを使用するには、
ServiceAvailability を実装したクラスを本ハンドラに設定する必要がある。

本ハンドラでは、以下の処理を行う。

* サービス提供可否チェック

処理の流れは以下のとおり。

![ServiceAvailabilityCheckHandler_flow.png](../../../knowledge/assets/handlers-ServiceAvailabilityCheckHandler/ServiceAvailabilityCheckHandler_flow.png)

## ハンドラクラス名

* nablarch.common.availability.ServiceAvailabilityCheckHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth</artifactId>
</dependency>
```

## 制約

[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) より後ろに配置すること
本ハンドラではスレッドコンテキスト上に設定されたリクエストIDをもとにサービス提供可否チェックを行うため、
[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) より後ろに本ハンドラを配置する必要がある。
[内部フォーワードハンドラ](../../component/handlers/handlers-forwarding-handler.md#forwarding-handler) より後ろに配置すること
内部フォーワードが行われた際に、フォーワード先のリクエストID（ [内部リクエストID](../../component/handlers/handlers-forwarding-handler.md#internal-request-id) ）をもとに
サービス提供可否チェックを行いたい場合は、 [内部フォーワードハンドラ](../../component/handlers/handlers-forwarding-handler.md#forwarding-handler) より後ろに本ハンドラを配置する必要がある。
合わせて、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) の `attributes` に InternalRequestIdAttribute を追加すること。

## リクエストに対するサービス提供可否チェック

ThreadContext からリクエストIDを取得し、サービス提供可否をチェックする。
チェックの詳細は、 [サービス提供可否チェック](../../component/libraries/libraries-service-availability.md#service-availability) を参照。

OK(サービス提供可)の場合
後続ハンドラを呼び出す。
NG(サービス提供不可)の場合
ServiceUnavailable (503) を送出する。

チェック対象のリクエストIDをフォーワード先のリクエストIDに変更したい場合は、
ServiceAvailabilityCheckHandler.setUsesInternalRequestId
でtrueを指定する。デフォルトはfalseである。
