# 電文応答制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/mom_messaging/message_reply_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/MessageReplyHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/StandardFwHeaderDefinition.html)

## ハンドラクラス名

後続ハンドラの処理結果である `ResponseMessage` (`nablarch.fw.messaging.ResponseMessage`) オブジェクトの内容をもとに、応答電文を作成し接続先システムに返却(送信)する。

**クラス名**: `nablarch.fw.messaging.handler.MessageReplyHandler`

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, 電文応答制御ハンドラ, 応答電文送信, ResponseMessage, nablarch.fw.messaging.ResponseMessage, 後続ハンドラ, 接続先システム

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

nablarch-fw-messaging, com.nablarch.framework, MOMメッセージング, モジュール依存関係

</details>

## 制約

- [messaging_context_handler](handlers-messaging_context_handler.md) よりも後ろに設定すること。本ハンドラはMQへの応答電文プットを行うため、MQへの接続を確立する [messaging_context_handler](handlers-messaging_context_handler.md) より後ろに配置する必要がある。
- [transaction_management_handler](handlers-transaction_management_handler.md) との位置関係は2相コミットの使用有無で異なる。
  - **2相コミットを使用する場合**: データベースとMQ(JMS)のトランザクションをトランザクションマネージャで纏めてコミットするため、トランザクション制御前に応答電文を送信する必要がある。 [transaction_management_handler](handlers-transaction_management_handler.md) より**後ろ**に本ハンドラを設定すること。
  - **2相コミットを使用しない場合**: 応答送信前に業務処理の結果を確定させる必要があるため、 [transaction_management_handler](handlers-transaction_management_handler.md) は本ハンドラより**後ろ**に設定すること。

<details>
<summary>keywords</summary>

messaging_context_handler, transaction_management_handler, 2相コミット, ハンドラ設定順序, MQトランザクション, JMSトランザクション

</details>

## フレームワーク制御ヘッダの設定

応答電文内のフレームワーク制御ヘッダの定義を変更する場合は、プロジェクトで拡張したフレームワーク制御ヘッダの定義を設定する。設定しない場合は `StandardFwHeaderDefinition` がデフォルトで使用される。

```xml
<component class="nablarch.fw.messaging.handler.MessageReplyHandler">
  <property name="fwHeaderDefinition">
    <component class="sample.SampleFwHeaderDefinition" />
  </property>
</component>
```

フレームワーク制御ヘッダの詳細は [mom_system_messaging-fw_header](../libraries/libraries-mom_system_messaging.md) を参照。

<details>
<summary>keywords</summary>

StandardFwHeaderDefinition, nablarch.fw.messaging.StandardFwHeaderDefinition, fwHeaderDefinition, フレームワーク制御ヘッダ, 応答電文ヘッダ定義

</details>
