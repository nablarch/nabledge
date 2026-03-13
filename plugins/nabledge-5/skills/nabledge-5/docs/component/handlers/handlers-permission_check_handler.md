# 認可チェックハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/permission_check_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/permission/PermissionFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/permission/PermissionCheckHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/InternalRequestIdAttribute.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/permission/Permission.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/Forbidden.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.permission.PermissionCheckHandler`

**前提条件**: 本ハンドラを使用するには、`PermissionFactory` を実装したクラスを本ハンドラに設定する必要がある。

<details>
<summary>keywords</summary>

PermissionCheckHandler, nablarch.common.permission.PermissionCheckHandler, 認可チェックハンドラ, PermissionFactory, nablarch.common.permission.PermissionFactory, 前提条件, 必須設定

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

nablarch-common-auth, com.nablarch.framework, 認可チェック, モジュール依存

</details>

## 制約

- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること。本ハンドラはスレッドコンテキスト上のリクエストIDとユーザIDをもとに認可チェックを行うため。
- 内部フォーワード先のリクエストID（[内部リクエストID](handlers-forwarding_handler.md)）で認可チェックを行いたい場合は、[forwarding_handler](handlers-forwarding_handler.md) より後ろに配置すること。合わせて、[thread_context_handler](handlers-thread_context_handler.md) の `attributes` に `InternalRequestIdAttribute` を追加すること。
- 認可チェックエラー時のエラーページ指定のため、[http_error_handler](handlers-HttpErrorHandler.md) より後ろに配置すること。

<details>
<summary>keywords</summary>

thread_context_handler, forwarding_handler, http_error_handler, InternalRequestIdAttribute, ハンドラ配置順序, 内部リクエストID

</details>

## リクエストに対する認可チェック

ログイン中のユーザが現在のリクエスト（リクエストID）に対して権限を持っているかをチェックする（:ref:`permission_check` 参照）。

- **権限あり**: 認可チェックに使用した `Permission` をスレッドローカルに設定し、後続ハンドラを呼び出す。
- **権限なし**: `Forbidden(403)` を送出する。

チェック対象をフォーワード先の内部リクエストIDに変更する場合は、`PermissionCheckHandler.setUsesInternalRequestId` で `true` を指定する（デフォルト: `false`）。

<details>
<summary>keywords</summary>

PermissionCheckHandler, Permission, Forbidden, setUsesInternalRequestId, 認可チェック, リクエスト権限確認, 403エラー, 内部リクエストID

</details>

## 権限がない場合に表示するエラーページを指定する

権限なし時のエラーページはHTTPエラー制御ハンドラで指定する。設定方法は :ref:`HttpErrorHandler_DefaultPage` を参照。

<details>
<summary>keywords</summary>

HttpErrorHandler_DefaultPage, 403エラーページ, エラーページ設定, http_error_handler

</details>

## 特定のリクエストを認可チェックから除外する

ログイン前のリクエストなど認可チェックを除外したいリクエストは、`PermissionCheckHandler.setIgnoreRequestIds` で指定する。

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

PermissionCheckHandler, setIgnoreRequestIds, ignoreRequestIds, 認可チェック除外, ログイン前リクエスト

</details>
