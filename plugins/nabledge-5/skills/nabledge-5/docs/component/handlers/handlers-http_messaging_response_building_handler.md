# HTTPメッセージングレスポンス変換ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/http_messaging/http_messaging_response_building_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/HttpMessagingResponseBuildingHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/InterSystemMessage.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/DataRecordFormatterSupport.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/StructuredFwHeaderDefinition.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler`

<details>
<summary>keywords</summary>

HttpMessagingResponseBuildingHandler, nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler, HTTPメッセージングレスポンス変換ハンドラ, ハンドラクラス

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-http</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-messaging-http, com.nablarch.framework, モジュール依存関係, Maven依存設定

</details>

## 制約

[http_response_handler](handlers-http_response_handler.md) よりも後ろに設定すること。このハンドラで生成した `HTTPレスポンスオブジェクト` を [http_response_handler](handlers-http_response_handler.md) がクライアントに返却するため。

<details>
<summary>keywords</summary>

http_response_handler, ハンドラ順序制約, HTTPレスポンスハンドラより後ろに設定, HttpResponse

</details>

## レスポンスヘッダに設定される値

後続のハンドラで作成された応答電文オブジェクトをもとに以下のレスポンスヘッダを設定する。

| ヘッダ | 設定値 |
|---|---|
| Status-Code | 応答電文オブジェクトのステータスコード |
| Content-Type | `InterSystemMessage.getFormatter()` から取得したMIME(`DataRecordFormatterSupport#getMimeType()`) + charset(`DataRecordFormatterSupport#getDefaultEncoding()`)。例: `application/json;charset=utf-8` |
| X-Correlation-Id | 応答電文オブジェクトのヘッダに設定された `CorrelationId` の値 |

> **重要**: このハンドラでは、上記以外のレスポンスヘッダを設定できない。上記外のレスポンスヘッダを使用したい場合は、プロジェクトでハンドラを作成し対応すること。

<details>
<summary>keywords</summary>

Status-Code, Content-Type, X-Correlation-Id, CorrelationId, InterSystemMessage, DataRecordFormatterSupport, レスポンスヘッダ設定, Content-Type設定

</details>

## フレームワーク制御ヘッダのレイアウトを変更する

応答電文内のフレームワーク制御ヘッダの定義を変更する場合、プロジェクトで拡張したフレームワーク制御ヘッダの定義を設定する必要がある。設定しない場合はデフォルトの `StructuredFwHeaderDefinition` が使用される。

フレームワーク制御ヘッダの詳細は [フレームワーク制御ヘッダ](../libraries/libraries-http_system_messaging.md) を参照。

```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler">
  <property name="fwHeaderDefinition">
    <component class="sample.SampleFwHeaderDefinition" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

StructuredFwHeaderDefinition, nablarch.fw.messaging.reader.StructuredFwHeaderDefinition, fwHeaderDefinition, フレームワーク制御ヘッダ, ヘッダレイアウト変更

</details>
