# HTTP同期応答メッセージ送信処理のアプリケーション構造

## 概要

HTTP同期応答型メッセージ送信処理の特徴:

- **Nablarch共通の実装方法**: MOMによるメッセージング処理と同様の実装にて、HTTPメッセージングを実現できる。
- **データ形式**: JSON/XML形式を汎用データフォーマッターでサポート。固定長ファイルやCSV/TSVと同様に扱える。

<details>
<summary>keywords</summary>

HTTPメッセージング, MOMメッセージング, JSON/XML, データ形式, 汎用データフォーマッター, Nablarch共通実装

</details>

## クラス構造

クラス構造は [../04_Explanation_send_sync/02_basic](../mom-messaging/mom-messaging-02_basic.md) と同様。

タイムアウトが発生し正常終了しなかった場合、`HttpMessagingTimeoutException` がスローされる。

<details>
<summary>keywords</summary>

HttpMessagingTimeoutException, クラス構造, タイムアウト

</details>

## 処理の流れ

業務ActionがMessageSenderを実行してHTTP同期応答メッセージを送信する流れ:

1. 業務Actionは `SyncMessage` にリクエストID[1]と要求電文パラメータを設定し、`MessageSender#sendSync` を呼び出す。
2. `MessageSender` は `SyncMessage` から要求電文を生成してWebコンテナに送信する。
3. Webコンテナから応答電文が返却される。
4. `MessageSender` は応答電文の解析結果を `SyncMessage` に格納して呼び出し元（業務Action）に返却する。

[1] ここでのリクエストIDは、送信先システムの機能を一意に識別するIDであり、画面オンライン処理やバッチ処理のリクエストIDとは意味が異なる。このリクエストIDに基づき以下が決定する:
- 要求電文および応答電文のフォーマット
- メッセージングの基盤（MOM/HTTP）

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, sendSync, HTTP同期応答, 処理フロー, リクエストID

</details>
