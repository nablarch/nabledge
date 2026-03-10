# 認可チェックハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.common.permission.PermissionCheckHandler`

本ハンドラを使用するには、`PermissionFactory` を実装したクラスを本ハンドラに設定する必要がある。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth</artifactId>
</dependency>
```

## 制約

- :ref:`thread_context_handler` より後ろに配置すること。スレッドコンテキスト上のリクエストIDとユーザIDをもとに認可チェックを行うため。
- :ref:`forwarding_handler` より後ろに配置すること。内部フォーワード先の :ref:`内部リクエストID <internal_request_id>` をもとに認可チェックしたい場合。この場合、:ref:`thread_context_handler` の `attributes` に `InternalRequestIdAttribute` を追加すること。
- :ref:`http_error_handler` より後ろに配置すること。認可チェックエラー時に表示するエラーページを指定するため。

## リクエストに対する認可チェック

ログイン中のユーザが現在のリクエスト（リクエストID）に対して権限を持っているかをチェックする（詳細は :ref:`permission_check` 参照）。

- **権限がある場合**: `Permission` をスレッドローカルに設定し、後続ハンドラを呼び出す。:ref:`permission_check-server_side_check` や :ref:`permission_check-view_control` で参照可能。
- **権限がない場合**: `Forbidden(403)` を送出する。

チェック対象のリクエストIDをフォーワード先のリクエストIDに変更する場合は、`PermissionCheckHandler.setUsesInternalRequestId` で `true` を指定する（デフォルト: `false`）。

## 権限がない場合に表示するエラーページを指定する

権限がない場合に表示するエラーページは、:ref:`http_error_handler` （HTTPエラー制御ハンドラ）で指定する。指定方法は :ref:`HttpErrorHandler_DefaultPage` 参照。

## 特定のリクエストを認可チェックから除外する

認可チェックを除外したいリクエスト（ログイン前のリクエストなど）は、`PermissionCheckHandler.setIgnoreRequestIds` で指定する。

```xml
<component name="permissionCheckHandler"
           class="nablarch.common.permission.PermissionCheckHandler">
  <property name="permissionFactory" ref="permissionFactory"/>
  <!-- 認可チェックを除外するリクエストIDをカンマ区切りで指定する -->
  <property name="ignoreRequestIds" value="/action/login,/action/logout" />
</component>
```
