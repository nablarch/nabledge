# 認可制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.PermissionCheckHandler`

リクエストIDを単位とした認可判定を行うハンドラ。認可通過以降、認可関連情報をスレッドコンテキスト経由で取得可能。

**関連するハンドラ（配置制約）**

| ハンドラ | 配置制約 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | スレッドコンテキスト上のリクエストID/ユーザIDを使うため、本ハンドラの上位に配置する必要がある |
| [ForwardingHandler](handlers-ForwardingHandler.md) | 内部フォーワード先のリクエストID（[内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md)）で認可判定する場合、[ForwardingHandler](handlers-ForwardingHandler.md) より下位に配置する必要がある |
| [DataReadHandler](handlers-DataReadHandler.md) | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) が受信電文中のフレームワークヘッダ部を解析する際に、**requestId** および **userId** ヘッダの値をスレッドコンテキストに設定する |

<details>
<summary>keywords</summary>

PermissionCheckHandler, nablarch.common.handler.PermissionCheckHandler, ThreadContextHandler, ForwardingHandler, DataReadHandler, FwHeaderReader, 認可制御, 認可判定, リクエストID単位の認可, メッセージング, 受信電文, フレームワークヘッダ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. スレッドコンテキストから [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) または [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) を取得する。
   - 1a. リクエストIDが **認可対象外リクエストIDリスト** に含まれる場合、後続ハンドラに処理を委譲してリターン（認可処理スキップ）。
2. スレッドコンテキストからユーザIDを取得する。
3. **認可情報取得コンポーネント** を用いて、ユーザIDに対する認可情報を取得する。
4. リクエストIDが認可情報に含まれることを確認し、認可情報をスレッドローカルに格納する。
   - 4a. リクエストIDが認可情報に含まれない場合、実行時例外 `Result.Forbidden` を送出して終了（認可エラー）。
5. 後続ハンドラに処理を委譲し、結果を取得する。

**[往路での処理]**

6. 処理結果をリターンし終了する。

**[例外処理]**

5a. 後続ハンドラ実行中にエラーが発生した場合、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

PermissionCheckHandler, Result.Forbidden, 認可処理フロー, 認可対象外リクエストID, 認可情報取得, 認可エラー, スレッドローカル格納

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| permissionFactory | PermissionFactorry | ○ | | 認可情報取得コンポーネント |
| ignoreRequestIds | String[] | | 空のリスト | 認可判定対象外リクエストIDリスト |
| usesInternalRequestId | boolean | | false | 内部リクエストIDによる判定を行うかどうか |

> **注意**: `permissionFactory` は必須。認可情報取得コンポーネントの詳細設定は [../02_FunctionDemandSpecifications/03_Common/04_Permission](../libraries/libraries-04_Permission.md) を参照。

**設定例（Webアプリケーション）**: `ignoreRequestIds` にはログイン画面のリクエストIDを設定する必要がある。

```xml
<component name="permissionCheckHandler"
           class="nablarch.common.handler.PermissionCheckHandler">
  <property name="permissionFactory" ref="permissionFactory" />
  <property name="ignoreRequestIds" value="login001, login002" />
  <property name="usesInternalRequestId" value="true" />
</component>
```

<details>
<summary>keywords</summary>

permissionFactory, ignoreRequestIds, usesInternalRequestId, PermissionFactory, 認可設定, 認可判定対象外リクエストIDリスト, 内部リクエストID

</details>
