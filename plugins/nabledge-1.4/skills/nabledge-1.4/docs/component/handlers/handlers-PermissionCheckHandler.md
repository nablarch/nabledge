# 認可制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.PermissionCheckHandler`

リクエストIDを単位とした認可判定を行うハンドラ。認可通過以降は、認可関連情報をスレッドコンテキスト経由で取得できる。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | スレッドコンテキスト上のリクエストID/ユーザIDをもとに認可判定を行うため、本ハンドラの上位に配置する必要がある |
| [ForwardingHandler](handlers-ForwardingHandler.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) において内部フォーワード時の認可判定をフォーワード先のリクエストID（[内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md)）で行う場合、本ハンドラは [ForwardingHandler](handlers-ForwardingHandler.md) より下位に配置する必要がある |
| [DataReadHandler](handlers-DataReadHandler.md) | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) が受信電文のフレームワークヘッダを解析する際に **requestId** および **userId** ヘッダの値をスレッドコンテキストに設定する |

<details>
<summary>keywords</summary>

PermissionCheckHandler, nablarch.common.handler.PermissionCheckHandler, ThreadContextHandler, ForwardingHandler, DataReadHandler, FwHeaderReader, 認可制御, リクエストID単位認可, スレッドコンテキスト, ハンドラ配置順序

</details>

## ハンドラ処理フロー

**[往路処理]**

1. スレッドコンテキストから [リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) もしくは [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) を取得する。
   - **1a.** 取得したリクエストIDが **認可対象外リクエストIDリスト** に含まれている場合、後続ハンドラに委譲してそのまま終了する（以降の処理はスキップ）。
2. スレッドコンテキストからユーザIDを取得する。
3. **認可情報取得コンポーネント** を用いて、ユーザIDに対する認可情報を取得する。
4. リクエストIDが認可情報に含まれていることを確認し、認可情報をスレッドローカルに格納する。
   - **4a.** リクエストIDが認可情報に含まれていない場合、後続ハンドラを実行せず実行時例外 `Result.Forbidden` を送出して終了する。
5. 後続ハンドラに処理を委譲し、結果を取得する。

**[往路での処理]**

6. 処理結果をリターンして終了する。

**[例外処理]**

- **5a.** 後続ハンドラの実行中にエラーが発生した場合、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

PermissionCheckHandler, Result.Forbidden, 認可判定フロー, 認可対象外リクエストIDリスト, スレッドローカル, 認可情報取得コンポーネント

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| permissionFactory | PermissionFactory | ○ | | 認可情報取得コンポーネント |
| ignoreRequestIds | String[] | | 空のリスト | 認可判定対象外リクエストIDリスト |
| usesInternalRequestId | boolean | | false | 内部リクエストIDによる判定を行うかどうか |

> **補足**: 認可情報取得コンポーネント（permissionFactory）の詳細設定については [../02_FunctionDemandSpecifications/03_Common/04_Permission](../libraries/libraries-04_Permission.md) を参照すること。

[../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) での設定例（**ignoreRequestIds** にログイン画面のリクエストIDを設定する必要がある）:

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

permissionFactory, ignoreRequestIds, usesInternalRequestId, PermissionFactory, 認可情報取得コンポーネント, 認可判定対象外リクエストIDリスト, PermissionCheckHandler設定

</details>
