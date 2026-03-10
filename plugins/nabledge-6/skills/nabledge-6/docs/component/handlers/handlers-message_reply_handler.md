# 電文応答制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/mom_messaging/message_reply_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/StandardFwHeaderDefinition.html)

## ハンドラクラス名

後続ハンドラの処理結果（`ResponseMessage`）をもとに応答電文を作成し、接続先システムに返却する。

**クラス名**: `nablarch.fw.messaging.handler.MessageReplyHandler`

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, ResponseMessage, 電文応答制御ハンドラ, 応答電文送信

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-messaging, com.nablarch.framework, Mavenモジュール, 依存関係設定

</details>

## 制約

- :ref:`messaging_context_handler` より後ろに設定すること。本ハンドラはMQへ応答電文を送信するため、MQ接続を確立する :ref:`messaging_context_handler` より後ろに配置する必要がある。
- :ref:`transaction_management_handler` との位置関係は2相コミットの使用有無で異なる。
  - **2相コミットを使用する場合**: DBトランザクションとMQ（Jakarta Messaging）トランザクションをトランザクションマネージャでまとめてコミットするため、トランザクション制御前に応答電文を送信する必要がある。:ref:`transaction_management_handler` より後ろに本ハンドラを設定すること。
  - **2相コミットを使用しない場合**: 本ハンドラが応答を送信する前に業務処理の結果を確定させる必要がある。:ref:`transaction_management_handler` は本ハンドラより後ろに設定すること。

<details>
<summary>keywords</summary>

messaging_context_handler, transaction_management_handler, ハンドラ配置順序, 2相コミット, トランザクション制御, メッセージキュー配置制約

</details>

## フレームワーク制御ヘッダの設定

応答電文内のフレームワーク制御ヘッダ定義を変更する場合、プロジェクトで拡張したフレームワーク制御ヘッダ定義を設定する。未設定の場合は `StandardFwHeaderDefinition` が使用される。

フレームワーク制御ヘッダの詳細は :ref:`フレームワーク制御ヘッダ <mom_system_messaging-fw_header>` を参照。

```xml
<component class="nablarch.fw.messaging.handler.MessageReplyHandler">
  <property name="fwHeaderDefinition">
    <component class="sample.SampleFwHeaderDefinition" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

StandardFwHeaderDefinition, nablarch.fw.messaging.StandardFwHeaderDefinition, fwHeaderDefinition, フレームワーク制御ヘッダ, カスタマイズ, mom_system_messaging-fw_header

</details>
