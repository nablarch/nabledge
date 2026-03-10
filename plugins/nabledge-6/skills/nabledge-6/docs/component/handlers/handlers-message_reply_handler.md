# 電文応答制御ハンドラ

## ハンドラクラス名

後続ハンドラの処理結果（`ResponseMessage`）をもとに応答電文を作成し、接続先システムに返却する。

**クラス名**: `nablarch.fw.messaging.handler.MessageReplyHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

## 制約

- :ref:`messaging_context_handler` より後ろに設定すること。本ハンドラはMQへ応答電文を送信するため、MQ接続を確立する :ref:`messaging_context_handler` より後ろに配置する必要がある。
- :ref:`transaction_management_handler` との位置関係は2相コミットの使用有無で異なる。
  - **2相コミットを使用する場合**: DBトランザクションとMQ（Jakarta Messaging）トランザクションをトランザクションマネージャでまとめてコミットするため、トランザクション制御前に応答電文を送信する必要がある。:ref:`transaction_management_handler` より後ろに本ハンドラを設定すること。
  - **2相コミットを使用しない場合**: 本ハンドラが応答を送信する前に業務処理の結果を確定させる必要がある。:ref:`transaction_management_handler` は本ハンドラより後ろに設定すること。

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
