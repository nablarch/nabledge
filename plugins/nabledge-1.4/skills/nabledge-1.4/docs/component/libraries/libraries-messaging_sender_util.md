# 同期応答メッセージ送信ユーティリティ

## 

対外システムへの同期応答メッセージ送信ユーティリティ。MOMメッセージングとHTTPメッセージングに対応。

> **注意**: 同期応答のみをサポート。応答なし・非同期応答の送信は [messaging_sending_batch](libraries-messaging_sending_batch.md) を使用すること。

> **注意**: カレントスレッドに紐づけられている [メッセージングコンテキスト](libraries-enterprise_messaging_mom.md) を利用するため、 [../handler/MessagingContextHandler](../handlers/handlers-MessagingContextHandler.md) をハンドラキュー上に配置すること。

**クラス**: `MessageSender` - `sendSync()` メソッドで同期応答送信を実行。
**クラス**: `SyncMessage` - 送信メッセージおよび応答メッセージの内容を格納。
**例外**: `MessageSendSyncTimeoutException` - タイムアウト時にスロー。

```java
String requestId = "RM11AD0101";
String timeoutErrorMessageId = "MW11AD01";

Map<String, Object> data = new HashMap<String, Object>();
data.put("title", form.getTitle());
data.put("publisher", form.getPublisher());
data.put("authors", form.getAuthors());

SyncMessage responseMessage;
try {
    responseMessage = MessageSender.sendSync(new SyncMessage(requestId).addDataRecord(data));
} catch (MessageSendSyncTimeoutException e) {
    throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, timeoutErrorMessageId));
}
```

<details>
<summary>keywords</summary>

MessageSender, SyncMessage, sendSync, MessageSendSyncTimeoutException, 同期応答メッセージ送信, MOMメッセージング, HTTPメッセージング, MessagingContextHandler

</details>

## 送信定義ファイルの設定項目

**共通設定（キューメッセージング・HTTPメッセージング共通）**

| プロパティ名 | 内容 |
|---|---|
| messageSender.DEFAULT.syncMessagingEventHookNames | MessageSender拡張用クラスのコンポーネント名（複数指定可、セパレータは「,」） |
| messageSender.リクエストID.syncMessagingEventHookNames | MessageSender拡張用クラスのコンポーネント名（複数指定可、セパレータは「,」） |

**キューメッセージング向け共通設定**

| プロパティ名 | 内容 |
|---|---|
| messageSender.DEFAULT.messagingProviderName | [メッセージングプロバイダ](libraries-enterprise_messaging_mom.md) のコンポーネント名 |
| messageSender.DEFAULT.destination | 送信キュー名（論理名） |
| messageSender.DEFAULT.replyTo | 応答受信キュー名（論理名） |
| messageSender.DEFAULT.retryCount | タイムアウト発生時の再送回数。再送しない場合は0以下。デフォルトは-1 |
| messageSender.DEFAULT.formatDir | フォーマット定義ファイルの格納ディレクトリ（論理名）。デフォルトは"format" |
| messageSender.DEFAULT.headerFormatName | ヘッダフォーマット名 |
| messageSender.DEFAULT.messageConvertorName | `SyncMessageConvertor` のコンポーネント名 |

**キューメッセージング向けリクエストID毎設定**

| プロパティ名 | 内容 |
|---|---|
| messageSender.リクエストID.messagingProviderName | MessagingProviderのコンポーネント名。DEFAULT未指定時は必須 |
| messageSender.リクエストID.destination | 送信キュー名（論理名）。DEFAULT未指定時は必須 |
| messageSender.リクエストID.replyTo | 応答受信キュー名（論理名）。DEFAULT未指定時は必須 |
| messageSender.リクエストID.timeout | 応答タイムアウト（ミリ秒）。デフォルトは-1。0以下または未指定の場合はDEFAULTの設定値 |
| messageSender.リクエストID.retryCount | タイムアウト発生時の再送回数。再送しない場合は0以下 |
| messageSender.リクエストID.headerFormatName | ヘッダフォーマット名。DEFAULT未指定時は必須 |
| messageSender.リクエストID.sendingRequestId | 送信用リクエストID。メッセージ処理用リクエストIDが重複する場合に使用。指定時はヘッダのリクエストIDに設定 |
| messageSender.リクエストID.messageConvertorName | `SyncMessageConvertor` のコンポーネント名 |

> **注意**: MOMメッセージングは :ref:`フレームワーク制御ヘッダ<fw_header>` の利用を前提とし、再送電文フラグによる再送/タイムアウト制御機能を実装している。

**HTTPメッセージング向け共通設定**

| プロパティ名 | 内容 |
|---|---|
| messageSender.DEFAULT.httpMessagingUserId | フレームワーク制御ヘッダーに設定するユーザID（任意） |
| messageSender.DEFAULT.httpMethod | HTTPメソッド。GET/POST/PUT/DELETEのいずれか |
| messageSender.DEFAULT.httpConnectTimeout | 接続タイムアウト時間（ミリ秒）。デフォルトは0（タイムアウトなし） |
| messageSender.DEFAULT.httpReadTimeout | データ読込タイムアウト時間（ミリ秒）。デフォルトは0（タイムアウトなし） |
| messageSender.DEFAULT.sslContextComponentName | SSLContext外部設定値取得用クラス |
| messageSender.DEFAULT.httpProxyHost | HttpProxy用ホスト名 |
| messageSender.DEFAULT.httpProxyPort | HttpProxy用ポート番号 |
| messageSender.DEFAULT.httpMessageIdGeneratorComponentName | HTTPヘッダに付与するメッセージID（X-Message-Id）の採番コンポーネント（任意）。設定時はフレームワークがIDを採番してHTTPヘッダに設定する。未設定の場合はメッセージIDは付与されない |

**HTTPメッセージング向けリクエストID毎設定**

| プロパティ名 | 内容 |
|---|---|
| messageSender.リクエストID.messageSenderClient | MessageSenderClient通信クライアント（論理名）。HTTP通信時は必須 |
| messageSender.リクエストID.httpMessagingUserId | フレームワーク制御ヘッダーに設定するユーザID（任意） |
| messageSender.リクエストID.uri | 接続先URI |
| messageSender.リクエストID.httpMethod | HTTPメソッド。GET/POST/PUT/DELETEのいずれか |
| messageSender.リクエストID.httpConnectTimeout | 接続タイムアウト時間（ミリ秒）。デフォルトは0（タイムアウトなし） |
| messageSender.リクエストID.httpReadTimeout | データ読込タイムアウト時間（ミリ秒）。デフォルトは0（タイムアウトなし） |
| messageSender.リクエストID.sslContextComponentName | SSLContext外部設定値取得用クラス |
| messageSender.リクエストID.httpProxyHost | HttpProxy用ホスト名 |
| messageSender.リクエストID.httpProxyPort | HttpProxy用ポート番号 |
| messageSender.リクエストID.httpMessageIdGeneratorComponentName | メッセージID採番コンポーネント（任意）。設定時はフレームワークがIDを採番してHTTPヘッダに設定する。未設定の場合はメッセージIDは付与されない |

<details>
<summary>keywords</summary>

syncMessagingEventHookNames, messagingProviderName, destination, replyTo, retryCount, formatDir, headerFormatName, messageConvertorName, timeout, sendingRequestId, messageSenderClient, uri, httpMethod, httpConnectTimeout, httpReadTimeout, sslContextComponentName, httpProxyHost, httpProxyPort, httpMessageIdGeneratorComponentName, httpMessagingUserId, キューメッセージング設定, HTTPメッセージング設定

</details>

## 

本機能を利用するには以下の2つの設定ファイルが必要。

**電文フォーマット定義ファイル**: 送受信電文のメッセージボディ領域のフォーマット定義。"format"論理パス配下に以下の名前で作成する。
- 送信電文: リクエストID + "_SEND"
- 受信電文: リクエストID + "_RECEIVE"

フォーマット定義の記述は [record_format](libraries-record_format.md) を参照。フォーマット定義ファイルを配置する論理パス名は設定で変更可能（`messageSender.DEFAULT.formatDir` で指定）。

**送信設定ファイル**: 送受信キューの論理名・再送要求の有無などの設定を記述したプロパティファイル。[../02_FunctionDemandSpecifications/01_Core/02_Repository](libraries-02_Repository.md) のプロパティファイルとして作成する。

```xml
<!-- 送信設定ファイル -->
<config-file file="nablarch/common/web/demo/messageSender.config" />
```

```
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

<details>
<summary>keywords</summary>

電文フォーマット定義ファイル, 送信設定ファイル, _SEND, _RECEIVE, formatDir, フォーマット定義, 設定ファイル準備

</details>

## メッセージ送信前後処理の追加

`MessageSender#sendSync()` の呼び出し前後に処理を追加したい場合は `SyncMessagingEventHook` を実装し、送信定義ファイルにコンポーネント名を指定する。

使用用途:
- 送受信時のデータ加工
- ログ出力の追加
- 特定の応答を業務例外として送出

**インターフェース**: `SyncMessagingEventHook`

| メソッド | 引数 | 戻り値 | 処理内容 |
|---|---|---|---|
| beforeSend | MessageSenderSettings settings, SyncMessage requestMessage | void | メッセージ送信前に呼ばれる処理 |
| afterSend | MessageSenderSettings settings, SyncMessage requestMessage, SyncMessage responseMessage | void | メッセージ送信後、レスポンスを受け取った後に呼ばれる処理 |
| onError | RuntimeException e, boolean hasNext, MessageSenderSettings settings, SyncMessage requestMessage, SyncMessage responseMessage | boolean | メッセージ送信中のエラー発生時に呼ばれる処理。trueの場合は処理継続（次のSyncMessagingEventHookに委譲）。次のSyncMessagingEventHookが存在しない場合は、引数responseMessageに設定されている値をMessageSenderの呼び出し元に返す。falseの場合は引数eをthrow |

```java
public class HttpSyncMessagingEventHook implements SyncMessagingEventHook {
    @Override
    public void beforeSend(MessageSenderSettings settings, SyncMessage requestMessage) {
        return;
    }

    @Override
    public void afterSend(MessageSenderSettings settings, SyncMessage requestMessage,
            SyncMessage responseMessage) {
        String statusCode = (String) responseMessage.getHeaderRecord().get(HttpMessagingClient.SYNCMESSAGE_STATUS_CODE);
        if (!"200".equals(statusCode)) {
            throw new ApplicationException(
                  MessageUtil.createMessage(MessageLevel.ERROR, "MSG00025"));
        }
    }

    @Override
    public boolean onError(RuntimeException e,
            boolean hasNext, MessageSenderSettings settings, SyncMessage requestMessage, SyncMessage responseMessage) {
        if (e instanceof HttpMessagingInvalidDataFormatException) {
            throw new ApplicationException(
                    MessageUtil.createMessage(MessageLevel.ERROR, "MSG00025"));
        } else {
            return false;
        }
    }
}
```

<details>
<summary>keywords</summary>

SyncMessagingEventHook, beforeSend, afterSend, onError, HttpSyncMessagingEventHook, MessageSenderSettings, HttpMessagingInvalidDataFormatException, 送信前後処理, メッセージ送受信フック

</details>

## 

SyncMessagingEventHookの設定例・DI設定例。

**送信設定**:

```
messageSender.リクエストID.syncMessagingEventHookNames=handleHttpStatusHook
```

**DI設定**:

```xml
<component name="handleHttpStatusHook" class="please.change.me.tutorial.messaging.HandleHttpStatusHook">
</component>
```

<details>
<summary>keywords</summary>

syncMessagingEventHookNames, SyncMessagingEventHook, DI設定, コンポーネント設定

</details>

## メッセージID採番処理の追加

HTTPヘッダに付与するメッセージID（X-Message-Id）を採番したい場合は `HttpMessageIdGenerator` を実装し、送信定義ファイルにコンポーネント名を指定する。

**インターフェース**: `HttpMessageIdGenerator`

| メソッド | 引数 | 戻り値 | 処理内容 |
|---|---|---|---|
| generateId | なし | void | メッセージID採番時に呼ばれる処理。 |

```java
public class DefaultHttpMessageIdGenerator implements HttpMessageIdGenerator {
    @Override
    public String generateId() {
        return Long.toString(System.currentTimeMillis());
    }
}
```

**送信設定**:

```
messageSender.リクエストID.httpMessageIdGeneratorComponentName=defaultHttpMessageIdGenerator
```

**DI設定**:

```xml
<component name="defaultHttpMessageIdGenerator" class="please.change.me.tutorial.messaging.DefaultHttpMessageIdGenerator">
</component>
```

<details>
<summary>keywords</summary>

HttpMessageIdGenerator, generateId, DefaultHttpMessageIdGenerator, httpMessageIdGeneratorComponentName, メッセージID採番, X-Message-Id

</details>
