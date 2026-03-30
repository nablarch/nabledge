# 同期応答メッセージ送信処理のアプリケーション構造

## 概要

アプリケーションプログラマはユーティリティクラスを使用して同期応答メッセージの送信を行う。フォーマット定義ファイルを作成し、フィールド名をキーとするMap型データで送受信データの受け渡しを行う実装のみ行えばよい。

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, 同期応答メッセージ送信, ユーティリティクラス, フォーマット定義ファイル, Map型データ

</details>

## クラス構造

同期応答メッセージの送信には`MessageSender`の以下のメソッドを使用する。

| メソッド | 概要 |
|---|---|
| `SyncMessage sendSync(SyncMessage requestMessage) throws MessageSendSyncTimeoutException` | 同期応答メッセージを送信する。タイムアウトが発生し正常終了しなかった場合は`MessageSendSyncTimeoutException`がスローされる。 |

![クラス図](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic-04_Explanation_send_sync/class_diagram.png)

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, MessageSendSyncTimeoutException, sendSync, クラス構造

</details>

## 処理の流れ

業務ActionはMessageSenderを実行し、同期応答メッセージの送信を行う。

1. 業務ActionはSyncMessageにリクエストID[^1]と要求電文パラメータを設定し、`MessageSender.sendSync()`を実行する。
2. MessageSenderは要求電文を生成し、送信キューにPUTする。
3. 後続処理が送信キューからGETし、業務処理後に応答電文を受信キューにPUTする。
4. MessageSenderは受信キューから応答電文をGETする。
5. MessageSenderは応答電文の解析結果をSyncMessageに格納し、業務Actionに返却する。

[^1]: ここでのリクエストIDはメッセージ送信先システムの機能を一意識別するIDであり、画面オンライン処理やバッチ処理のリクエストIDとは意味が異なる。このリクエストIDに基づき、要求・応答電文のフォーマット、送信キュー名、受信キュー名が決定する。

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, sendSync, 送信キュー, 受信キュー, リクエストID, 処理の流れ

</details>
