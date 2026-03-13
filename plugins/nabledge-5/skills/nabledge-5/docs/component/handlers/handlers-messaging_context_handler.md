# メッセージングコンテキスト管理ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/mom_messaging/messaging_context_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/MessagingContextHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessagingProvider.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/provider/JmsMessagingProvider.html)

## ハンドラクラス名

後続のハンドラ及びライブラリで使用するためのMQ接続を、スレッド上で管理するハンドラ。

処理の流れ:
1. MQ接続の取得
2. MQ接続の解放

**クラス名**: `nablarch.fw.messaging.handler.MessagingContextHandler`

<details>
<summary>keywords</summary>

MessagingContextHandler, nablarch.fw.messaging.handler.MessagingContextHandler, MQ接続管理, メッセージングコンテキスト, MOMメッセージング

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

nablarch-fw-messaging, com.nablarch.framework, モジュール依存, Maven設定

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約なし, MOMメッセージング制約

</details>

## MQの接続先を設定する

`messagingProvider` プロパティに `MessagingProvider` 実装クラスを設定してMQ接続を取得する。

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

<details>
<summary>keywords</summary>

messagingProvider, MessagingProvider, nablarch.fw.messaging.MessagingProvider, JmsMessagingProvider, nablarch.fw.messaging.provider.JmsMessagingProvider, MQ接続設定, プロバイダクラス設定

</details>
