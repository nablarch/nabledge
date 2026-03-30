# 開閉局制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.ServiceAvailabilityCheckHandler`

リクエストID単位での開閉局制御を行うハンドラ。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラはスレッドコンテキスト上の [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) をもとに開閉局判定を行うため、[ThreadContextHandler](handlers-ThreadContextHandler.md) を本ハンドラの上位に配置する必要がある。 |
| [ForwardingHandler](handlers-ForwardingHandler.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) で内部フォーワード発生時に、フォーワード先のリクエストID ([内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md)) で開閉局制御が必要な場合は、本ハンドラを [ForwardingHandler](handlers-ForwardingHandler.md) より下位に配置する必要がある。 |
| [DataReadHandler](handlers-DataReadHandler.md) | メッセージング処理では、受信電文のフレームワークヘッダ内の **requestId** ヘッダ値で開閉局制御を行う。この場合 [../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) が requestId をスレッドコンテキストに設定するため、[ThreadContextHandler](handlers-ThreadContextHandler.md) は不要。 |

<details>
<summary>keywords</summary>

nablarch.common.handler.ServiceAvailabilityCheckHandler, ServiceAvailabilityCheckHandler, ThreadContextHandler, ForwardingHandler, DataReadHandler, FwHeaderReader, 開閉局制御, リクエストID単位, サービス開閉局

</details>

## ハンドラ処理フロー

**[往路処理]**

1. リクエストIDの取得: スレッドコンテキストから [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) もしくは [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) を取得する。
2. 開閉局判定: 設定された **サービス開閉局判定オブジェクト** を使用して、取得したリクエストIDに対するサービスが開局中であることを確認する。
   - 2a. 閉局エラー: サービスが閉局中の場合は、後続ハンドラを実行せず、実行時例外 `Result.ServiceUnavailable` (ステータスコード: 503) を送出して終了する。
3. 後続ハンドラの実行: 開局状態であれば後続ハンドラを実行し、結果を取得する。

**[復路処理]**

4. 正常終了: 取得した処理結果をリターンして終了する。

**[例外処理]**

- 3a. 後続ハンドラの実行中にエラーが発生した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

Result.ServiceUnavailable, 開閉局判定, 503, 往路処理, 復路処理, 例外処理, ハンドラ処理フロー

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

serviceAvailability, usesInternalRequestId, ServiceAvailability, 設定項目, 開閉局制御設定

</details>
