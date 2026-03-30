# 同期応答メッセージ送信ユーティリティ

## 概要

対外システムに対するメッセージの同期送信を行うユーティリティクラス。

**前提条件**: :ref:`フレームワーク制御ヘッダ<fw_header>` の利用を前提とし、再送電文フラグを利用した再送/タイムアウト制御等の機能を実装している。

> **注意**: 本ユーティリティでは、**同期応答メッセージ送信処理のみ**をサポートしている。応答を伴わない、もしくは非同期応答を伴うメッセージの送信については、`messaging_sending_batch` を使用する。

<details>
<summary>keywords</summary>

同期応答メッセージ送信, フレームワーク制御ヘッダ, 再送電文フラグ, 再送制御, タイムアウト制御, messaging_sending_batch, 非同期応答, 同期応答のみ

</details>

## 使用方法

**クラス**: `MessageSender`, `SyncMessage`

- `MessageSender`: ユーティリティ本体。`sendSync()` メソッドで同期応答送信を実行する。
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

> **注意**: [../handler/MessagingContextHandler](../handlers/handlers-MessagingContextHandler.md) をハンドラキュー上に配置する必要がある（カレントスレッドの [メッセージングコンテキスト](libraries-enterprise_messaging.md) を利用するため）。

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, MessageSendSyncTimeoutException, ApplicationException, MessageUtil, MessageLevel, sendSync, 同期応答送信, メッセージ送信, MessagingContextHandler

</details>

## 設定項目

以下2つの設定ファイルが必要。

**電文フォーマット定義ファイル**
- 格納場所: "format" 論理パス配下（論理パス名は設定変更可能）
- 送信電文ファイル名: リクエストID＋"_SEND"
- 受信電文ファイル名: リクエストID＋"_RECEIVE"
- フォーマット定義の記述方法: [record_format](libraries-record_format.md) 参照

**送信設定ファイル** ([../02_FunctionDemandSpecifications/01_Core/02_Repository](libraries-02_Repository.md) のプロパティファイルとして作成)

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

# リクエストID毎設定例
messageSender.RM11AD0101.timeout=3000
```

**共通設定 (messageSender.DEFAULT.*)**

| プロパティ名 | 説明 | デフォルト |
|---|---|---|
| messagingProviderName | [メッセージングプロバイダ](libraries-enterprise_messaging.md) のコンポーネント名 | |
| destination | 送信キュー名（論理名） | |
| replyTo | 応答受信キュー名（論理名） | |
| retryCount | タイムアウト時の再送回数（再送しない場合は0以下） | -1 |
| formatDir | フォーマット定義ファイルの格納ディレクトリ（論理名） | "format" |
| headerFormatName | ヘッダフォーマット名 | |
| messageConvertorName | `SyncMessageConvertor` のコンポーネント名 | |

**リクエストID毎設定 (messageSender.{リクエストID}.*)**

| プロパティ名 | 説明 | デフォルト |
|---|---|---|
| messagingProviderName | MessagingProviderのコンポーネント名。DEFAULT未設定時は必須 | |
| destination | 送信キュー名（論理名）。DEFAULT未設定時は必須 | |
| replyTo | 応答受信キュー名（論理名）。DEFAULT未設定時は必須 | |
| timeout | 応答タイムアウト（ミリ秒）。0以下または未指定の場合はDEFAULT設定値を使用 | -1 |
| retryCount | タイムアウト時の再送回数（再送しない場合は0以下） | |
| headerFormatName | ヘッダフォーマット名。DEFAULT未設定時は必須 | |
| sendingRequestId | 送信用リクエストID。メッセージ処理用リクエストIDが重複する場合に使用。指定時はヘッダのリクエストIDにこの値を設定する | |
| messageConvertorName | `SyncMessageConvertor` のコンポーネント名 | |

<details>
<summary>keywords</summary>

SyncMessageConvertor, messageSender.DEFAULT, messagingProviderName, destination, replyTo, retryCount, formatDir, headerFormatName, timeout, sendingRequestId, 電文フォーマット定義ファイル, 送信設定ファイル, 同期応答送信設定

</details>
