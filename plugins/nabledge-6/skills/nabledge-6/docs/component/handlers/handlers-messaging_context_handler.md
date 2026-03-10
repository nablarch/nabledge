# メッセージングコンテキスト管理ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/mom_messaging/messaging_context_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/MessagingContextHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessagingProvider.html)

## ハンドラクラス名

後続のハンドラ及びライブラリで使用するためのMQ接続をスレッド上で管理するハンドラ。

処理:
1. MQ接続の取得
2. MQ接続の解放

**クラス**: `MessagingContextHandler`

<details>
<summary>keywords</summary>

MessagingContextHandler, nablarch.fw.messaging.handler.MessagingContextHandler, MOMメッセージング, MQ接続管理, スレッド管理

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

nablarch-fw-messaging, com.nablarch.framework, モジュール, 依存関係

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約, なし

</details>

## MQの接続先を設定する

`messagingProvider` プロパティに `MessagingProvider` 実装クラスを設定してMQ接続を取得する。

```xml
<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="messagingProvider" />
</component>

<component name="messagingProvider"
    class="nablarch.fw.messaging.provider.JmsMessagingProvider">
</component>
```

<details>
<summary>keywords</summary>

MessagingProvider, nablarch.fw.messaging.MessagingProvider, JmsMessagingProvider, nablarch.fw.messaging.provider.JmsMessagingProvider, messagingProvider, MQ接続設定, プロバイダクラス設定

</details>
