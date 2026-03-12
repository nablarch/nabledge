# 認可チェックハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/permission_check_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/permission/PermissionFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/InternalRequestIdAttribute.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/permission/Permission.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/Forbidden.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/permission/PermissionCheckHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.permission.PermissionCheckHandler`

本ハンドラを使用するには、`PermissionFactory` を実装したクラスを本ハンドラに設定する必要がある。

<details>
<summary>keywords</summary>

PermissionCheckHandler, nablarch.common.permission.PermissionCheckHandler, PermissionFactory, nablarch.common.permission.PermissionFactory, 認可チェックハンドラ, ハンドラクラス

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

nablarch-common-auth, com.nablarch.framework, モジュール, 依存関係

</details>

## 制約

- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること。スレッドコンテキスト上のリクエストIDとユーザIDをもとに認可チェックを行うため。
- [forwarding_handler](handlers-forwarding_handler.md) より後ろに配置すること。内部フォーワード先の [内部リクエストID](handlers-forwarding_handler.md) をもとに認可チェックしたい場合。この場合、[thread_context_handler](handlers-thread_context_handler.md) の `attributes` に `InternalRequestIdAttribute` を追加すること。
- [http_error_handler](handlers-HttpErrorHandler.md) より後ろに配置すること。認可チェックエラー時に表示するエラーページを指定するため。

<details>
<summary>keywords</summary>

InternalRequestIdAttribute, nablarch.common.handler.threadcontext.InternalRequestIdAttribute, ハンドラ配置順序, 制約, スレッドコンテキスト, 内部リクエストID

</details>

## リクエストに対する認可チェック

ログイン中のユーザが現在のリクエスト（リクエストID）に対して権限を持っているかをチェックする（詳細は :ref:`permission_check` 参照）。

- **権限がある場合**: `Permission` をスレッドローカルに設定し、後続ハンドラを呼び出す。:ref:`permission_check-server_side_check` や :ref:`permission_check-view_control` で参照可能。
- **権限がない場合**: `Forbidden(403)` を送出する。

チェック対象のリクエストIDをフォーワード先のリクエストIDに変更する場合は、`PermissionCheckHandler.setUsesInternalRequestId` で `true` を指定する（デフォルト: `false`）。

<details>
<summary>keywords</summary>

PermissionCheckHandler, Permission, nablarch.common.permission.Permission, Forbidden, nablarch.fw.results.Forbidden, setUsesInternalRequestId, リクエスト認可チェック, 権限チェック, 403エラー, 内部リクエストID

</details>

## 権限がない場合に表示するエラーページを指定する

権限がない場合に表示するエラーページは、[http_error_handler](handlers-HttpErrorHandler.md) （HTTPエラー制御ハンドラ）で指定する。指定方法は :ref:`HttpErrorHandler_DefaultPage` 参照。

<details>
<summary>keywords</summary>

エラーページ指定, 403エラーページ, HTTPエラー制御ハンドラ, HttpErrorHandler_DefaultPage

</details>

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

<details>
<summary>keywords</summary>

setIgnoreRequestIds, PermissionCheckHandler, nablarch.common.permission.PermissionCheckHandler, 認可チェック除外, ログイン前リクエスト

</details>
