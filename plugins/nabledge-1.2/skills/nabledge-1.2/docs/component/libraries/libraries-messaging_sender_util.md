# 同期応答メッセージ送信ユーティリティ

## 使用方法

:ref:`フレームワーク制御ヘッダ<fw_header>` の利用を前提とし、再送電文フラグを利用した再送/タイムアウト制御等の機能を実装している。

> **注意**: 同期応答メッセージ送信のみサポート。非同期応答または応答なし送信には [messaging_sending_batch](libraries-messaging_sending_batch.md) を使用する。

**クラス**: `MessageSender`, `SyncMessage`

- `MessageSender`: ユーティリティ本体。`sendSync()` メソッドで同期応答送信を実行。
- `SyncMessage`: 送信メッセージおよび応答メッセージの内容を格納するオブジェクト。

```java
String requestId = "RM11AD0101";
String timeoutErrorMessageId = "MW11AD01";

Map<String, Object> data = new HashMap<String, Object>();
data.put("title",     form.getTitle());
data.put("publisher", form.getPublisher());
data.put("authors",   form.getAuthors());

SyncMessage responseMessage;
try {
    responseMessage = MessageSender.sendSync(new SyncMessage(requestId).addDataRecord(data));
} catch (MessageSendSyncTimeoutException e) {
    throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, timeoutErrorMessageId));
}
```

> **注意**: [../handler/MessagingContextHandler](../handlers/handlers-MessagingContextHandler.md) をハンドラキュー上に配置しておく必要がある（カレントスレッドに紐づく [メッセージングコンテキスト](libraries-enterprise_messaging.md) を利用するため）。

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, MessageSendSyncTimeoutException, sendSync, 同期応答メッセージ送信, メッセージングコンテキスト, フレームワーク制御ヘッダ, MessagingContextHandler

</details>

## 設定項目

以下の2つの設定ファイルが必要。

**電文フォーマット定義ファイル**

送受信電文のメッセージボディ領域のフォーマット定義。"format"論理パス配下に配置（論理パス名は設定により変更可能）。
- 送信電文ファイル名: リクエストID＋`_SEND`
- 受信電文ファイル名: リクエストID＋`_RECEIVE`

フォーマット定義の記述方法は [record_format](libraries-record_format.md) 参照。

**送信設定ファイル**

[../02_FunctionDemandSpecifications/01_Core/02_Repository](libraries-02_Repository.md) のプロパティファイルとして作成。

```xml
<config-file file="nablarch/common/web/demo/messageSender.config" />
```

```bash
# 共通設定
messageSender.DEFAULT.messagingProviderName=messagingProvider
messageSender.DEFAULT.destination=QUEUE1
messageSender.DEFAULT.replyTo=REPLY1
messageSender.DEFAULT.retryCount=3
messageSender.DEFAULT.formatDir=format
messageSender.DEFAULT.headerFormatName=HEADER

# リクエストIDごとの設定
messageSender.RM11AD0101.timeout=3000
```

**共通設定**

| 項目名 | 内容 |
|---|---|
| messageSender.DEFAULT.messagingProviderName | [メッセージングプロバイダ](libraries-enterprise_messaging.md) をリポジトリから取得する際のコンポーネント名 |
| messageSender.DEFAULT.destination | 送信キュー名（論理名） |
| messageSender.DEFAULT.replyTo | 応答受信キュー名（論理名） |
| messageSender.DEFAULT.retryCount | タイムアウト時の再送回数。再送しない場合は0以下。デフォルト: -1 |
| messageSender.DEFAULT.formatDir | フォーマット定義ファイルの格納ディレクトリ（論理名）。デフォルト: "format" |
| messageSender.DEFAULT.headerFormatName | ヘッダフォーマット名 |
| messageSender.DEFAULT.messageConvertorName | `SyncMessageConvertor` をリポジトリから取得する際のコンポーネント名 |

**リクエストID毎設定**

| 項目名 | 内容 |
|---|---|
| messageSender.リクエストID.messagingProviderName | MessagingProviderをリポジトリから取得する際のコンポーネント名。DEFAULT未設定時は必須 |
| messageSender.リクエストID.destination | 送信キュー名（論理名）。DEFAULT未設定時は必須 |
| messageSender.リクエストID.replyTo | 応答受信キュー名（論理名）。DEFAULT未設定時は必須 |
| messageSender.リクエストID.timeout | 応答タイムアウト（ミリ秒）。デフォルト: -1。0以下または指定がない場合はDEFAULT設定値となる |
| messageSender.リクエストID.retryCount | タイムアウト時の再送回数。再送しない場合は0以下 |
| messageSender.リクエストID.headerFormatName | ヘッダフォーマット名。DEFAULT未設定時は必須 |
| messageSender.リクエストID.sendingRequestId | 送信用リクエストID。メッセージ処理用リクエストIDが重複する場合に使用。指定時はヘッダのリクエストIDにこの値を設定 |
| messageSender.リクエストID.messageConvertorName | `SyncMessageConvertor` をリポジトリから取得する際のコンポーネント名 |

<details>
<summary>keywords</summary>

電文フォーマット定義ファイル, 送信設定ファイル, SyncMessageConvertor, messageSender.DEFAULT.messagingProviderName, messageSender.DEFAULT.destination, messageSender.DEFAULT.replyTo, messageSender.DEFAULT.retryCount, messageSender.DEFAULT.formatDir, messageSender.DEFAULT.headerFormatName, messageSender.DEFAULT.messageConvertorName, messageSender.リクエストID.messagingProviderName, messageSender.リクエストID.destination, messageSender.リクエストID.replyTo, messageSender.リクエストID.timeout, messageSender.リクエストID.retryCount, messageSender.リクエストID.headerFormatName, messageSender.リクエストID.sendingRequestId, messageSender.リクエストID.messageConvertorName, 再送設定, タイムアウト設定, 送受信キュー設定

</details>
