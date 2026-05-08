## 同期応答メッセージ送信ユーティリティ

対外システムに対するメッセージの同期送信を行うユーティリティクラス。

本ユーティリティは [フレームワーク制御ヘッダ](../../component/libraries/libraries-enterprise-messaging.md#基本概念) の利用を前提とし、
再送電文フラグを利用した再送/タイムアウト制御等の機能を実装している。

> **Note:**
> 本ユーティリティでは、同期応答メッセージ送信処理のみをサポートしている。
> 応答を伴わない、もしくは、、非同期応答を伴うメッセージの送信については、
> [応答不要メッセージ送信常駐バッチ](../../component/libraries/libraries-messaging-sending-batch.md) を使用する。

-----

-----

### 使用方法

本ユーティリティでは以下の2つのクラスを使用する。

* [MessageSender](../../javadoc/nablarch/fw/messaging/MessageSender.html)

  ユーティリティ本体。
  このクラスに定義された **sendSync()** メソッドを使用することによって、同期応答送信を行うことができる。
* [SyncMessage](../../javadoc/nablarch/fw/messaging/SyncMessage.html)

  送信メッセージおよび、応答されたメッセージの内容を格納するオブジェクト。

**コードサンプル**

以下はこれらのクラス機能を使用して実際にメッセージ送信処理を行う例である。

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

> **Note:**
> このクラスは、カレントスレッドに紐づけられている [メッセージングコンテキスト](../../component/libraries/libraries-enterprise-messaging.md#メッセージング基盤api) を
> 利用してメッセージ送信を行うため、 [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-MessagingContextHandler.md) を
> ハンドラキュー上に配置しておく必要がある。

### 設定項目

本機能を利用するには、以下の2つの設定ファイルを用意する必要がある。

**電文フォーマット定義ファイル**

送受信電文内のメッセージボディ領域のフォーマット定義を記述したファイル。
"format"論理パス配下にある以下のファイル名で作成する。

* **送信電文:** リクエストID＋"_SEND"
* **受信電文:** リクエストID＋"_RECEIVE"

フォーマット定義ファイルを配置する論理パス名は、設定により変更することができる。(後述)
フォーマット定義の記述方法については、 [汎用データフォーマット機能](../../component/libraries/libraries-record-format.md) を参照すること。

**送信設定ファイル**

送受信キューの論理名や再送要求の有無といった、送信処理の各種設定を記述したファイル。
[リポジトリ](../../component/libraries/libraries-02-Repository.md) のプロパティファイルとして作成する。

以下は、その定義例である。

**リポジトリ定義ファイル内のプロパティファイル定義**

```xml
<!-- 送信設定ファイル -->
<config-file file="nablarch/common/web/demo/messageSender.config" />
```

**送信定義ファイルの内容**

```bash
# 共通設定
messageSender.DEFAULT.messagingProviderName=messagingProvider
messageSender.DEFAULT.destination=QUEUE1
messageSender.DEFAULT.replyTo=REPLY1
messageSender.DEFAULT.retryCount=3
messageSender.DEFAULT.formatDir=format
messageSender.DEFAULT.headerFormatName=HEADER

# リクエストIDごとの設定

# リクエストID: RM11AD0101
messageSender.RM11AD0101.timeout=3000

#(後略)
```

**送信設定一覧**

**共通設定**

| 項目名 | 内容 |
|---|---|
| messageSender.DEFAULT.messagingProviderName | [メッセージングプロバイダ](../../component/libraries/libraries-enterprise-messaging.md#メッセージングプロバイダ) をリポジトリから取得する際に 使用するコンポーネント名 |
| messageSender.DEFAULT.destination | 送信キュー名(論理名) |
| messageSender.DEFAULT.replyTo | 応答受信キュー名(論理名) |
| messageSender.DEFAULT.retryCount | タイムアウト発生時の再送回数。再送しない場合は0以下を指定。デフォルトは-1 |
| messageSender.DEFAULT.formatDir | フォーマット定義ファイルの格納ディレクトリ(論理名)。デフォルトは"format" |
| messageSender.DEFAULT.headerFormatName | ヘッダフォーマット名 |
| messageSender.DEFAULT.messageConvertorName | [SyncMessageConvertor](../../javadoc/nablarch/fw/messaging/SyncMessageConvertor.html) をリポジトリから取得する際に使用するコンポーネント名 |

**リクエストID毎設定**

| 項目名 | 内容 |
|---|---|
| messageSender.**リクエストID.messagingProviderName | MessagingProviderをリポジトリから取得する際に使用するコンポーネント名。 デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.destination | 送信キュー名(論理名)。デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.replyTo | 応答受信キュー名(論理名)。デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.timeout | 応答タイムアウト(単位:ミリ秒)。デフォルトは-1。 0以下または指定がない場合はの設定値となる |
| messageSender.リクエストID.retryCount | タイムアウト発生時の再送回数。再送しない場合は0以下を指定 |
| messageSender.リクエストID.headerFormatName | ヘッダフォーマット名。デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.sendingRequestId | 送信用リクエストID。メッセージ処理用のリクエストIDが重複する場合に使用する。 送信用リクエストIDが指定された場合は、送信用リクエストIDの値をヘッダのリクエストIDに設定する。 |
| messageSender.リクエストID.messageConvertorName | [SyncMessageConvertor](../../javadoc/nablarch/fw/messaging/SyncMessageConvertor.html) をリポジトリから取得する際に使用するコンポーネント名 |
