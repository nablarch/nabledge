# 同期応答メッセージ送信処理のアプリケーション構造

## 同期応答メッセージ送信処理のアプリケーション構造

**概要:**

アプリケーションプログラマは、ユーティリティクラス（`MessageSender`）を使用して同期応答メッセージの送信を行う。ユーティリティクラスを使用する場合、アプリケーションプログラマは以下の実装のみ行えばよい:

- **フォーマット定義ファイルを作成する**
- **フィールド名をキーに持つMap型データ**を使用して、送信時と受信時のデータの受け渡しを行う

---

**クラス**: `MessageSender`, `SyncMessage`
**例外**: `MessageSendSyncTimeoutException`

![クラス図](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic/class_diagram.png)

| メソッド | 概要 |
|---|---|
| `SyncMessage sendSync(SyncMessage requestMessage) throws MessageSendSyncTimeoutException` | 同期応答メッセージ送信。タイムアウト発生時はMessageSendSyncTimeoutExceptionをスロー。 |

**処理の流れ:**

1. 業務ActionはSyncMessageにリクエストIDと要求電文パラメータを設定し、MessageSender#sendSyncを実行する。
2. MessageSenderはSyncMessageから要求電文を生成し、送信キューにPUTする。
3. 後続処理が送信キューから電文をGETし、業務処理後に受信キューへ応答電文をPUTする。
4. MessageSenderは受信キューから応答電文をGETする。
5. MessageSenderは応答電文の解析結果をSyncMessageに格納し、呼び出し元（業務Action）に返却する。

![シーケンス図](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic/sequence.png)

> **注意**: リクエストIDは相手先システムの機能を一意に識別するIDであり、画面オンライン処理やバッチ処理で使用するリクエストIDとは意味が異なる。このリクエストIDに基づき、要求電文・応答電文のフォーマット、送信キュー名、受信キュー名が決定する。

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, MessageSendSyncTimeoutException, sendSync, 同期応答メッセージ送信, 送信キュー, 受信キュー, リクエストID, 処理の流れ, クラス構造, フォーマット定義ファイル, Map型データ, ユーティリティクラス

</details>
