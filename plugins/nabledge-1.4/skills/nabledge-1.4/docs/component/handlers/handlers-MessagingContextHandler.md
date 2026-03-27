# メッセージングコンテキスト管理ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.MessagingContextHandler`

リクエストスレッド毎にメッセージングコンテキストの初期化とスレッドローカル変数への格納、および終端処理を行う。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DataReadHandler](handlers-DataReadHandler.md) (MessageReader使用時) | [../reader/MessageReader](../readers/readers-MessageReader.md) を使用して受信電文を読み込む際、本ハンドラが初期化するメッセージングコンテキストを使用する。そのため、[DataReadHandler](handlers-DataReadHandler.md) は本ハンドラの後続に配置する必要がある。 |
| [MessageReplyHandler](handlers-MessageReplyHandler.md) | メッセージ応答処理で本ハンドラが初期化するメッセージングコンテキストを使用するため、本ハンドラの後続に配置する必要がある。 |

<details>
<summary>keywords</summary>

MessagingContextHandler, nablarch.fw.messaging.handler.MessagingContextHandler, メッセージングコンテキスト管理, DataReadHandler, MessageReplyHandler, ハンドラ配置順序, スレッドローカル

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 設定された**メッセージングプロバイダ**からメッセージングコンテキストを取得する。
2. 取得したインスタンスをスレッドローカルに保持する。
3. 後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**

4. メッセージングコンテキストをクローズし、メッセージングサーバへの接続をコネクションプールに返却する。スレッドローカル上からメッセージングコンテキストへの参照を除去する。
5. 処理結果をリターンして終了する。

**[例外処理]**

3a. 本ハンドラおよび後続ハンドラの処理中に実行時例外/エラーが発生した場合でも、終端処理（手順4）を実行してからエラーを再送出する。

<details>
<summary>keywords</summary>

メッセージングコンテキスト取得, スレッドローカル設定, 終端処理, コネクションプール返却, 例外時終端処理, ハンドラ処理フロー

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| messagingProvider | MessagingProvider | ○ | | メッセージングプロバイダ |

メッセージングプロバイダの設定については、[../core_library/enterprise_messaging_mom](../libraries/libraries-enterprise_messaging_mom.md) を参照すること。

```xml
<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="messagingProvider" />
</component>
```

<details>
<summary>keywords</summary>

messagingProvider, MessagingProvider, メッセージングプロバイダ設定, XML設定例, 必須プロパティ

</details>
