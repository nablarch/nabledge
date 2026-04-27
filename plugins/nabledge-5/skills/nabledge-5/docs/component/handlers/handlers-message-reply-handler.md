# 電文応答制御ハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* フレームワーク制御ヘッダの設定

本ハンドラでは、後続ハンドラの処理結果である ResponseMessage オブジェクトの内容をもとに、
応答電文を作成し接続先システムに返却(送信)する。

本ハンドラでは、以下の処理を行う。

* 応答電文の送信処理を行う

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-message-reply-handler/flow.png)

## ハンドラクラス名

* nablarch.fw.messaging.handler.MessageReplyHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

## 制約

[メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-messaging-context-handler.md#messaging-context-handler) よりも後ろに設定すること
本ハンドラは、応答電文を送信(メッセージキューへのプット)する。
このため、MQへの接続を確立する [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-messaging-context-handler.md#messaging-context-handler) より後ろに本ハンドラを設定する必要がある。
[トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) との位置関係について
[トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) との位置関係は、2相コミットを使用するか否かで変わる。

2相コミットを使用する場合
データベースのトランザクションとメッセージキュー(JMS)のトランザクションを、トランザクションマネージャで纏めてコミットする。
このため、トランザクション制御前に応答電文を送信する必要があり、 [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) より後ろに本ハンドラを設定する必要がある。
2相コミットを使用しない場合
本ハンドラが応答を送信する前に業務処理の結果を確定させる必要がある。
このため、 [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) は、本ハンドラより後ろに設定する必要がある。

## フレームワーク制御ヘッダの設定

応答電文内のフレームワーク制御ヘッダの定義を変更する場合には、プロジェクトで拡張したフレームワーク制御ヘッダの定義を設定する必要がある。
設定しない場合は、デフォルトの StandardFwHeaderDefinition が使用される。

フレームワーク制御ヘッダの詳細は、 [フレームワーク制御ヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-fw-header) を参照。

以下に設定例を示す。

```xml
<component class="nablarch.fw.messaging.handler.MessageReplyHandler">
  <!-- フレームワーク制御ヘッダの設定 -->
  <property name="fwHeaderDefinition">
    <component class="sample.SampleFwHeaderDefinition" />
  </property>
</component>
```
