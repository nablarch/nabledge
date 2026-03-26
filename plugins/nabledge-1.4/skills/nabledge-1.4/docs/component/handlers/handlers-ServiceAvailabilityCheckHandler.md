# 開閉局制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.ServiceAvailabilityCheckHandler`

リクエストID単位での開閉局制御を行うハンドラ。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | スレッドコンテキスト上の [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) をもとに開閉局判定を行うため、本ハンドラの上位に配置する必要がある。 |
| [ForwardingHandler](handlers-ForwardingHandler.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) で内部フォーワード時に、フォーワード先のリクエストID（[内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md)）で開閉局制御する場合は、本ハンドラを [ForwardingHandler](handlers-ForwardingHandler.md) より下位に配置する必要がある。 |
| [DataReadHandler](handlers-DataReadHandler.md) | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では、受信電文のフレームワークヘッダ内の **requestId** ヘッダ値で開閉局制御を行う。この場合、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) が **requestId** をスレッドコンテキストに設定するため、[ThreadContextHandler](handlers-ThreadContextHandler.md) は不要。 |

<details>
<summary>keywords</summary>

ServiceAvailabilityCheckHandler, nablarch.common.handler.ServiceAvailabilityCheckHandler, 開閉局制御, リクエストID, 内部リクエストID, ThreadContextHandler, ForwardingHandler, DataReadHandler

</details>

## ハンドラ処理フロー

**[往路処理]**

1. スレッドコンテキストから [リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) もしくは [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) を取得する。
2. 設定された **サービス開閉局判定オブジェクト** を使用して、取得したリクエストIDに対するサービスが開局中であることを確認する。
   - 2a. サービスが閉局中の場合は後続ハンドラを実行せず、実行時例外 `Result.ServiceUnavailable`（**ステータスコード: 503**）を送出して終了する。
3. 開局状態であれば後続ハンドラを実行し、処理結果を取得する。

**[復路処理]**

4. 取得した処理結果をリターンして終了する。

**[例外処理]**

- 3a. 後続ハンドラの実行中にエラーが発生した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

ServiceAvailabilityCheckHandler, 開閉局判定, Result.ServiceUnavailable, 503, 閉局エラー, サービス開閉局判定オブジェクト

</details>

## 設定項目・拡張ポイント

**設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| serviceAvailability | ServiceAvailability | ○ | | サービス開閉局判定コンポーネント |
| usesInternalRequestId | boolean | | false | 内部リクエストIDによる判定を行うかどうか |

**標準設定**

```xml
<component
  name="serviceAvailabilityCheckHandler"
  class="nablarch.common.handler.ServiceAvailabilityCheckHandler">
  <property name="serviceAvailability" ref="serviceAvailability" />
  <property name="usesInternalRequestId" value="true" />
</component>
```

<details>
<summary>keywords</summary>

ServiceAvailabilityCheckHandler, serviceAvailability, usesInternalRequestId, ServiceAvailability, 開閉局設定, 内部リクエストIDによる判定

</details>
