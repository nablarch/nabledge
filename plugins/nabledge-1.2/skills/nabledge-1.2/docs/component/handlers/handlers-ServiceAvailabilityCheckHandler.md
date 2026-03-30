# 開閉局制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.ServiceAvailabilityCheckHandler`

リクエストID単位での開閉局制御を行うハンドラ。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラはスレッドコンテキスト上の [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) をもとに開閉局判定を行うため、本ハンドラの上位に配置する必要がある。 |
| [ForwardingHandler](handlers-ForwardingHandler.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) で内部フォーワードが行われた際に、フォーワード先のリクエストID（[内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md)）で制御する必要がある場合は、本ハンドラを [ForwardingHandler](handlers-ForwardingHandler.md) より下位に配置する必要がある。 |
| [DataReadHandler](handlers-DataReadHandler.md) | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では受信電文のフレームワークヘッダ内 **requestId** ヘッダ値で開閉局制御を行う。この場合 [../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) がスレッドコンテキストに設定するため、[ThreadContextHandler](handlers-ThreadContextHandler.md) は不要。 |

<details>
<summary>keywords</summary>

ServiceAvailabilityCheckHandler, nablarch.common.handler.ServiceAvailabilityCheckHandler, ThreadContextHandler, ForwardingHandler, DataReadHandler, FwHeaderReader, 開閉局制御, リクエストID単位, ハンドラ配置順序, 内部リクエストID

</details>

## ハンドラ処理フロー

**[往路処理]**

1. スレッドコンテキストから [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) または [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) を取得する。
2. 設定された **serviceAvailability** オブジェクトを使用して、取得したリクエストIDのサービスが開局中かを確認する。
   - 閉局中の場合: 後続ハンドラを実行せず、`Result.ServiceUnavailable` (ステータスコード: 503) を送出して終了する。
3. 開局中の場合: 後続ハンドラを実行し、結果を取得する。

**[復路処理]**

4. 後続ハンドラの処理結果をリターンして終了する。

**[例外処理]**

後続ハンドラの実行中にエラーが発生した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

Result.ServiceUnavailable, 開閉局判定, ハンドラ処理フロー, 往路処理, 復路処理, 503エラー, serviceAvailability

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| serviceAvailability | ServiceAvailability | ○ | | サービス開閉局判定コンポーネント |
| usesInternalRequestId | boolean | | false | 内部リクエストIDによる判定を行うかどうか |

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

serviceAvailability, usesInternalRequestId, ServiceAvailability, 設定項目, 内部リクエストID判定

</details>
