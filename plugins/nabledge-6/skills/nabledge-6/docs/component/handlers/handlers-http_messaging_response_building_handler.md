# HTTPメッセージングレスポンス変換ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/http_messaging/http_messaging_response_building_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/HttpMessagingResponseBuildingHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/InterSystemMessage.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/DataRecordFormatterSupport.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/StructuredFwHeaderDefinition.html)

## 概要

後続のハンドラが作成した応答電文オブジェクトをHTTPレスポンスオブジェクトに変換するハンドラ。具体的には以下の処理を行う。

- 応答電文オブジェクトの内容をHTTPレスポンスオブジェクトに変換する
- 応答電文オブジェクト内のプロトコルヘッダの値を、対応するHTTPヘッダに設定する
- XMLやJSONなどの形式への直列化（シリアライズ）を行う

<details>
<summary>keywords</summary>

HTTPメッセージングレスポンス変換ハンドラ, 応答電文オブジェクト, HTTPレスポンスオブジェクト変換, 直列化, シリアライズ, XML, JSON, プロトコルヘッダ, HTTPヘッダ設定

</details>

## ハンドラクラス名

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler`

<details>
<summary>keywords</summary>

HttpMessagingResponseBuildingHandler, nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler, HTTPメッセージング, レスポンス変換ハンドラ, ハンドラクラス

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

nablarch-fw-messaging-http, com.nablarch.framework, モジュール, Maven依存関係, HTTPメッセージング

</details>

## 制約

- [http_response_handler](handlers-http_response_handler.md) よりも後ろに設定すること。[http_response_handler](handlers-http_response_handler.md) がこのハンドラで生成した `HTTPレスポンスオブジェクト` をクライアントに返却するため。

<details>
<summary>keywords</summary>

http_response_handler, HttpResponse, nablarch.fw.web.HttpResponse, ハンドラ順序, 制約, 設定順

</details>

## レスポンスヘッダに設定される値

後続ハンドラで作成された応答電文オブジェクトをもとに以下のレスポンスヘッダを設定する。

| ヘッダ名 | 設定値 |
|---|---|
| Status-Code | 応答電文オブジェクトのステータスコード |
| Content-Type | フォーマッタのMIMEとcharsetを組み合わせた値（例: `application/json;charset=utf-8`） |
| X-Correlation-Id | 応答電文オブジェクトのヘッダに設定された `CorrelationId` の値 |

Content-TypeはフォーマッタのMIME（`DataRecordFormatterSupport#getMimeType()`）とcharset（`DataRecordFormatterSupport#getDefaultEncoding()`）から生成される。取得元は `InterSystemMessage.getFormatter()`。

> **重要**: このハンドラでは上記に記載のないレスポンスヘッダを設定できない。上記以外のレスポンスヘッダが必要な場合はプロジェクトでハンドラを作成すること。

<details>
<summary>keywords</summary>

Status-Code, Content-Type, X-Correlation-Id, CorrelationId, InterSystemMessage, DataRecordFormatterSupport, レスポンスヘッダ, HTTPヘッダ設定, Content-Type生成

</details>

## フレームワーク制御ヘッダのレイアウトを変更する

応答電文内のフレームワーク制御ヘッダの定義を変更する場合、`fwHeaderDefinition` プロパティにプロジェクトで拡張したフレームワーク制御ヘッダ定義を設定する。未設定時はデフォルトの `StructuredFwHeaderDefinition` が使用される。

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

StructuredFwHeaderDefinition, nablarch.fw.messaging.reader.StructuredFwHeaderDefinition, fwHeaderDefinition, フレームワーク制御ヘッダ, ヘッダ定義変更, FwHeaderDefinition

</details>
