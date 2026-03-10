# メッセージングコンテキスト管理ハンドラ

## ハンドラクラス名

後続のハンドラ及びライブラリで使用するためのMQ接続をスレッド上で管理するハンドラ。

処理:
1. MQ接続の取得
2. MQ接続の解放

**クラス**: `MessagingContextHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

## 制約

なし。

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
