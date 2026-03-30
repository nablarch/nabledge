# メッセージングコンテキスト管理ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.MessagingContextHandler`

リクエストスレッド毎にメッセージングコンテキストの初期化とスレッドローカル変数への格納、および終端処理を行う。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DataReadHandler](handlers-DataReadHandler.md) (MessageReader使用時) | メッセージ受信処理で [../reader/MessageReader](../readers/readers-MessageReader.md) を使用する際、本ハンドラが初期化するメッセージングコンテキストを使用するため、**本ハンドラの後続に配置する必要がある**。 |
| [MessageReplyHandler](handlers-MessageReplyHandler.md) | メッセージ応答処理で本ハンドラが初期化するメッセージングコンテキストを使用するため、**本ハンドラの後続に配置する必要がある**。 |

<details>
<summary>keywords</summary>

MessagingContextHandler, nablarch.fw.messaging.handler.MessagingContextHandler, メッセージングコンテキスト管理, DataReadHandler, MessageReplyHandler, ハンドラ配置順序

</details>

## ハンドラ処理フロー

**[往路処理]**

1. メッセージングプロバイダからメッセージングコンテキストを取得する。
2. 取得したインスタンスをスレッドローカルに保持する。
3. 後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**

4. 終端処理: メッセージングコンテキストをクローズし、使用していたメッセージングサーバへの接続をコネクションプールに返却、スレッドローカル上からメッセージングコンテキストへの参照を除去する。
5. 処理結果をリターンし、終了する。

**[例外処理]**

3a. 本ハンドラおよび後続ハンドラの処理中に実行時例外/エラーが発生した場合でも、終端処理（4.）を実行してからエラーを再送出する。

<details>
<summary>keywords</summary>

MessagingContextHandler, メッセージングコンテキスト初期化, スレッドローカル, コネクションプール返却, 終端処理, 例外時終端処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| messagingProvider | MessagingProvider | ○ | メッセージングプロバイダ |

メッセージングプロバイダの設定については [../core_library/enterprise_messaging](../libraries/libraries-enterprise_messaging.md) を参照。

```xml
<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="messagingProvider" />
</component>
```

<details>
<summary>keywords</summary>

messagingProvider, MessagingProvider, メッセージングプロバイダ設定, MessagingContextHandler XML設定

</details>
