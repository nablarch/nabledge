# メッセージングコンテキスト管理ハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* MQの接続先を設定する

後続のハンドラ及びライブラリで使用するためのMQ接続を、スレッド上で管理するハンドラ。

MOMメッセージングの詳細は、 [システム間メッセージング](../../component/libraries/libraries-system-messaging.md#system-messaging) を参照。

本ハンドラでは、以下の処理を行う。

* MQ接続の取得
* MQ接続の解放

処理の流れは以下のとおり。

![MessagingContextHandler_flow.png](../../../knowledge/assets/handlers-messaging-context-handler/MessagingContextHandler_flow.png)

## ハンドラクラス名

* nablarch.fw.messaging.handler.MessagingContextHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

## 制約

なし。

## MQの接続先を設定する

このハンドラは、 messagingProvider
プロパティに設定されたプロバイダクラス( MessagingProvider 実装クラス)を使用してMQ接続を取得する。

以下に設定例を示す。
プロバイダクラスの設定内容については、使用する
MessagingProvider 実装クラスのJavadocを参照。

```xml
<!-- メッセージコンテキスト管理ハンドラ -->
<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="messagingProvider" />
</component>

<!-- プロバイダクラス -->
<component name="messagingProvider"
    class="nablarch.fw.messaging.provider.JmsMessagingProvider">
  <!-- プロパティの設定は省略 -->
</component>
```
