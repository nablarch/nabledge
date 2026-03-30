# メッセージングコンテキスト管理ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.MessagingContextHandler`

リクエストスレッド毎にメッセージングコンテキストの初期化とスレッドローカル変数への格納、および終端処理を行うハンドラ。

**関連するハンドラ（配置順序の制約）**

| ハンドラ | 制約 |
|---|---|
| DataReadHandler (MessageReader使用時) | MessageReader でメッセージングコンテキストを使用するため、本ハンドラの後続に配置すること |
| MessageReplyHandler | メッセージングコンテキストを使用するため、本ハンドラの後続に配置すること |

<details>
<summary>keywords</summary>

MessagingContextHandler, nablarch.fw.messaging.handler.MessagingContextHandler, メッセージングコンテキスト管理, DataReadHandler, MessageReplyHandler, MessageReader, ハンドラ配置順序, スレッドローカル

</details>

## ハンドラ処理フロー

**[往路処理]**
1. メッセージングプロバイダからメッセージングコンテキストを取得する
2. 取得したインスタンスをスレッドローカルに保持する
3. 後続ハンドラに処理を委譲し、結果を取得する

**[復路処理]**

4. メッセージングコンテキストをクローズ（メッセージングサーバへの接続をコネクションプールへ返却）し、スレッドローカルから参照を除去する
5. 処理結果をリターンして終了する

**[例外処理]**

3a. 実行時例外/エラーが発生した場合も、終端処理（4.）を必ず実行してからエラーを再送出する

<details>
<summary>keywords</summary>

MessagingContextHandler, メッセージングコンテキスト, スレッドローカル, コネクションプール返却, 往路処理, 復路処理, 例外処理, 終端処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| messagingProvider | MessagingProvider | ○ | | メッセージングプロバイダ |

```xml
<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="messagingProvider" />
</component>
```

<details>
<summary>keywords</summary>

messagingProvider, MessagingProvider, メッセージングプロバイダ設定, XML設定, MessagingContextHandler

</details>
