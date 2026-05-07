# 認可チェックハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* リクエストに対する認可チェック
* 権限がない場合に表示するエラーページを指定する
* 特定のリクエストを認可チェックから除外する

本ハンドラでは、 [リクエストに対する認可チェック](../../component/handlers/handlers-permission-check-handler.md#permission-check-handler-request-checking) を行う。

認可チェックは、ライブラリの [ハンドラによる認可チェック](../../component/libraries/libraries-authorization-permission-check.md#permission-check) を使用して行う。
そのため、本ハンドラを使用するには、
PermissionFactory を実装したクラスを本ハンドラに設定する必要がある。

本ハンドラでは、以下の処理を行う。

* 認可チェック

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-permission-check-handler/flow.png)

## ハンドラクラス名

* nablarch.common.permission.PermissionCheckHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth</artifactId>
</dependency>
```

## 制約

[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) より後ろに配置すること

本ハンドラではスレッドコンテキスト上に設定されたリクエストIDとユーザIDをもとに認可チェックを行うため、
[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) より後ろに本ハンドラを配置する必要がある。

[内部フォーワードハンドラ](../../component/handlers/handlers-forwarding-handler.md#forwarding-handler) より後ろに配置すること

内部フォーワードが行われた際に、フォーワード先のリクエストID（ [内部リクエストID](../../component/handlers/handlers-forwarding-handler.md#internal-request-id) ）をもとに
認可チェックを行いたい場合は、 [内部フォーワードハンドラ](../../component/handlers/handlers-forwarding-handler.md#forwarding-handler) より後ろに本ハンドラを配置する必要がある。
合わせて、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) の `attributes` に InternalRequestIdAttribute を追加すること。

[HTTPエラー制御ハンドラ](../../component/handlers/handlers-HttpErrorHandler.md#http-error-handler) より後ろに配置すること

認可チェックエラーの場合に表示するエラーページを指定するため、
[HTTPエラー制御ハンドラ](../../component/handlers/handlers-HttpErrorHandler.md#http-error-handler) より後ろに本ハンドラを配置する必要がある。

## リクエストに対する認可チェック

ログイン中のユーザが、現在のリクエスト(リクエストID)に対して権限を持っているかをチェックする。
チェックの詳細は、 [ハンドラによる認可チェック](../../component/libraries/libraries-authorization-permission-check.md#permission-check) を参照。

権限がある場合

[業務ロジック](../../component/libraries/libraries-authorization-permission-check.md#permission-check-server-side-check) や
[画面表示の制御](../../component/libraries/libraries-authorization-permission-check.md#permission-check-view-control) で参照できるように、
認可チェックに使用した Permission をスレッドローカルに設定する。
そして、後続ハンドラを呼び出す。

権限がない場合

Forbidden(403) を送出する。

チェック対象のリクエストIDをフォーワード先のリクエストIDに変更したい場合は、
PermissionCheckHandler.setUsesInternalRequestId
でtrueを指定する。デフォルトはfalseである。

## 権限がない場合に表示するエラーページを指定する

権限がない場合に表示するエラーページは、HTTPエラー制御ハンドラで指定する。
指定方法は、 [デフォルトページの設定](../../component/handlers/handlers-HttpErrorHandler.md#httperrorhandler-defaultpage) を参照。

## 特定のリクエストを認可チェックから除外する

ログイン前のリクエストなど、認可チェックを除外したいリクエストがある場合は、
PermissionCheckHandler.setIgnoreRequestIds
で指定する。

```xml
<component name="permissionCheckHandler"
           class="nablarch.common.permission.PermissionCheckHandler">
  <property name="permissionFactory" ref="permissionFactory"/>
  <!-- 認可チェックを除外するリクエストIDをカンマ区切りで指定する -->
  <property name="ignoreRequestIds" value="/action/login,/action/logout" />
</component>
```
