## 同期応答メッセージ送信ユーティリティ

対外システムに対するメッセージの同期送信を行うユーティリティクラスである。

本ユーティリティは、MOMメッセージングとHTTPメッセージングに対応している。

> **Note:**
> 本ユーティリティでは、同期応答メッセージ送信処理のみをサポートしている。
> 応答を伴わない、もしくは、非同期応答を伴うメッセージの送信については、
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
> このクラスは、カレントスレッドに紐づけられている [メッセージングコンテキスト](../../component/libraries/libraries-enterprise-messaging-mom.md#メッセージング基盤api) を
> 利用してメッセージ送信を行うため、 [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-MessagingContextHandler.md) を
> ハンドラキュー上に配置しておく必要がある。

### 設定項目・拡張ポイント

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

#### 送信定義ファイルの設定項目

**送信設定一覧(キューメッセージング、HTTPメッセージング共通)**

**共通設定**

| 項目名 | 内容 |
|---|---|
| messageSender.DEFAULT.syncMessagingEventHookNames | MessageSender拡張用クラスをリポジトリから取得する際に使用するコンポーネント名 (複数指定可。セパレータは「,」) |

**リクエストID毎設定**

| 項目名 | 内容 |
|---|---|
| messageSender.リクエストID.syncMessagingEventHookNames | MessageSender拡張用クラスをリポジトリから取得する際に使用するコンポーネント名 (複数指定可。セパレータは「,」) |

**送信設定一覧（キューメッセージング向け）**

**共通設定**

| 項目名 | 内容 |
|---|---|
| messageSender.DEFAULT.messagingProviderName | [メッセージングプロバイダ](../../component/libraries/libraries-enterprise-messaging-mom.md#メッセージングプロバイダ) をリポジトリから取得する際に 使用するコンポーネント名 |
| messageSender.DEFAULT.destination | 送信キュー名(論理名) |
| messageSender.DEFAULT.replyTo | 応答受信キュー名(論理名) |
| messageSender.DEFAULT.retryCount | タイムアウト発生時の再送回数。再送しない場合は0以下を指定。デフォルトは-1 |
| messageSender.DEFAULT.formatDir | フォーマット定義ファイルの格納ディレクトリ(論理名)。デフォルトは"format" |
| messageSender.DEFAULT.headerFormatName | ヘッダフォーマット名 |
| messageSender.DEFAULT.messageConvertorName | [SyncMessageConvertor](../../javadoc/nablarch/fw/messaging/SyncMessageConvertor.html) をリポジトリから取得する際に使用するコンポーネント名 |

**リクエストID毎設定**

| 項目名 | 内容 |
|---|---|
| messageSender.リクエストID.messagingProviderName | MessagingProviderをリポジトリから取得する際に使用するコンポーネント名。 デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.destination | 送信キュー名(論理名)。デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.replyTo | 応答受信キュー名(論理名)。デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.timeout | 応答タイムアウト(単位:ミリ秒)。デフォルトは-1。 0以下または指定がない場合はの設定値となる |
| messageSender.リクエストID.retryCount | タイムアウト発生時の再送回数。再送しない場合は0以下を指定 |
| messageSender.リクエストID.headerFormatName | ヘッダフォーマット名。デフォルト設定を指定しない場合は必須 |
| messageSender.リクエストID.sendingRequestId | 送信用リクエストID。メッセージ処理用のリクエストIDが重複する場合に使用する。 送信用リクエストIDが指定された場合は、送信用リクエストIDの値をヘッダのリクエストIDに設定する。 |
| messageSender.リクエストID.messageConvertorName | [SyncMessageConvertor](../../javadoc/nablarch/fw/messaging/SyncMessageConvertor.html) をリポジトリから取得する際に使用するコンポーネント名 |

> **Note:**
> MOMメッセージングについては、 [フレームワーク制御ヘッダ](../../component/libraries/libraries-enterprise-messaging-mom.md#データモデル) の利用を前提とし、
> 再送電文フラグを利用した再送/タイムアウト制御等の機能を実装している。

**送信設定一覧（HTTPメッセージング向け）**

**共通設定**

| 項目名 | 内容 |
|---|---|
| messageSender.DEFAULT.httpMessagingUserId | フレームワーク制御ヘッダーに設定するユーザID(任意項目) |
| messageSender.DEFAULT.httpMethod | HTTPメソッド。GET,POST,PUT,DELETEのいずれかを設定 |
| messageSender.DEFAULT.httpConnectTimeout | 接続タイムアウト時間[ミリ秒]。デフォルトは0（タイムアウトなし） |
| messageSender.DEFAULT.httpReadTimeout | データ読込タイムアウト時間[ミリ秒]。デフォルトは0（タイムアウトなし） |
| messageSender.DEFAULT.sslContextComponentName | SSLContext外部設定値取得用クラス |
| messageSender.DEFAULT.httpProxyHost | HttpProxy用のホスト名 |
| messageSender.DEFAULT.httpProxyPort | HttpProxy用のポート番号 |
| messageSender.DEFAULT.httpMessageIdGeneratorComponentName | HTTPヘッダに付与するメッセージID(キー名：X-Message-Id)の採番コンポーネント(任意項目)。  設定されている場合は、フレームワークがコンポーネントを呼び出して、メッセージIDを採番し、HTTPヘッダに設定する。未設定の場合は、メッセージIDは付与されない。 |

**リクエストID毎設定**

| 項目名 | 内容 |
|---|---|
| messageSender.リクエストID.messageSenderClient | MessageSenderClient通信クライアント(論理名)。HTTP通信時は必須。 |
| messageSender.リクエストID.httpMessagingUserId | フレームワーク制御ヘッダーに設定するユーザID(任意項目) |
| messageSender.リクエストID.uri | 接続先URI |
| messageSender.リクエストID.httpMethod | HTTPメソッド。GET,POST,PUT,DELETEのいずれかを設定 |
| messageSender.リクエストID.httpConnectTimeout | 接続タイムアウト時間[ミリ秒]。デフォルトは0（タイムアウトなし） |
| messageSender.リクエストID.httpReadTimeout | データ読込タイムアウト時間[ミリ秒]。デフォルトは0（タイムアウトなし） |
| messageSender.リクエストID.sslContextComponentName | SSLContext外部設定値取得用クラス |
| messageSender.リクエストID.httpProxyHost | HttpProxy用のホスト名 |
| messageSender.リクエストID.httpProxyPort | HttpProxy用のポート番号 |
| messageSender.リクエストID.httpMessageIdGeneratorComponentName | HTTPヘッダに付与するメッセージID(キー名：X-Message-Id)の採番コンポーネント(任意項目)。  設定されている場合は、フレームワークがコンポーネントを呼び出して、メッセージIDを採番し、HTTPヘッダに設定する。未設定の場合は、メッセージIDは付与されない。 |

#### メッセージ送信前後処理の追加

メッセージの送信前後(MessageSender#sendSyncの呼び出し前後)に処理を追加したい場合は、SyncMessagingEventHookを実装し、送信定義ファイルにそのクラスのコンポーネント名を指定する。

SyncMessagingEventHookを実装することは以下の用途で使用されることを想定している。

* 送受信時のデータの加工
* ログ出力の追加
* 特定の応答を業務例外として送出すること

以下にSyncMessagingEventHookに実装すべきメソッドを示す。

| メソッド | 引数 | 戻り値 | 処理内容 |
|---|---|---|---|
| beforeSend | MessageSenderSettings  settings | void | メッセージ送信前に呼ばれる処理。 |
|  | SyncMessage requestMessage |  |  |
| afterSend | MessageSenderSettings settings | void | メッセージ送信後、レスポンスを受け取った後に呼ばれる処理。 |
|  | SyncMessage requestMessage |  |  |
|  | SyncMessage responseMessage |  |  |
| onError | RuntimeException e | boolean | メッセージ送信中のエラー発生時に呼ばれる処理。  　戻り値がtrueの場合は処理継続。次のSyncMessagingEventHookに処理を委譲する。 次のSyncMessagingEventHookが存在しない場合は、 引数responseMessageに設定されている値をMessageSenderの呼び出し元に返す。  　戻り値がfalseの場合は、本メソッド終了後に引数eをthrowする。 |
|  | boolean hasNext |  |  |
|  | MessageSenderSettings settings |  |  |
|  | SyncMessage requestMessage |  |  |
|  | SyncMessage responseMessage |  |  |

*通信前後処理の実装例*

以下に、本インターフェースを使用したHTTPメッセージングの例外処理のカスタマイズ例を示す。

```java
public class HttpSyncMessagingEventHook implements SyncMessagingEventHook {

    /**
     * メッセージ送信前に呼ばれる処理。
     *
     * @param settings メッセージ送信設定
     * @param requestMessage 送信対象メッセージ
     */
    @Override
    public void beforeSend(MessageSenderSettings settings, SyncMessage requestMessage) {
        //何もしない
        return;
    }

    /**
     * メッセージ送信後、レスポンスを受け取った後に呼ばれる処理。<br>
     * <p>
     * ステータスコードをチェックして、正常終了であるか、業務エラーであるかを判定する。
     * </p>
     * @param settings メッセージ送信設定
     * @param requestMessage リクエストメッセージ
     * @param responseMessage レスポンスメッセージ
     */
    @Override
    public void afterSend(MessageSenderSettings settings, SyncMessage requestMessage,
            SyncMessage responseMessage) {
        String statusCode = (String) responseMessage.getHeaderRecord().get(HttpMessagingClient.SYNCMESSAGE_STATUS_CODE);
        if (!"200".equals(statusCode)) {
            // ステータスコード200以外の場合は業務エラーとして扱い、ユーザに再試行を促す。
            throw new ApplicationException(
                  MessageUtil.createMessage(MessageLevel.ERROR, "MSG00025"));
        }
    }

    /**
     * メッセージ送信中のエラー発生時に呼ばれる処理。<br>
     * <p>
     * ステータスコードをチェックして、業務エラーであるか、システム例外であるかを判定する。
     * </p>
     *
     * @param e 発生した例外
     * @param hasNext 次に呼び出される{@link SyncMessagingEventHook}が存在する場合にtrue
     * @param settings メッセージ送信設定
     * @param requestMessage リクエストメッセージ
     * @param responseMessage レスポンスメッセージとして使用するオブジェクト。本オブジェクトは最終的に{@link MessageSender#sendSync(SyncMessage)}の戻り値として返却される。
     * @return trueの場合は処理継続。次の{@link SyncMessagingEventHook#onError(RuntimeException, MessageSenderSettings, SyncMessage)}を呼ぶ。<br />
     * 次がない場合は、{@link MessageSender#sendSync(SyncMessage)}}の戻り値として、引数responseMessageの値を返す。<br />
     * falseの場合は、本メソッド終了後に引数eをthrowする
     */
    @Override
    public boolean onError(RuntimeException e,
            boolean hasNext, MessageSenderSettings settings, SyncMessage requestMessage, SyncMessage responseMessage) {
        if (e instanceof HttpMessagingInvalidDataFormatException) {
            //接続先から応答があったものの、期待するフォーマットの電文ではなかった場合は、業務エラーとする。
            throw new ApplicationException(
                    MessageUtil.createMessage(MessageLevel.ERROR, "MSG00025"));
        } else {
            //接続タイムアウト等、電文フォーマット変換以外の例外の場合は、例外をそのまま送出する(システム例外とする)。
            return false;
        }
    }
}
```

*送信設定の設定例*

```text
messageSender.リクエストID.syncMessagingEventHookNames=handleHttpStatusHook
```

*DIの設定例*

```xml
<component name="handleHttpStatusHook" class="please.change.me.tutorial.messaging.HandleHttpStatusHook">
</component>
```

#### メッセージID採番処理の追加

メッセージIDを採番したい場合は、HttpMessageIdGeneratorインターフェースを実装し、送信定義ファイルにそのクラスのコンポーネント名を指定する。

以下にHttpMessageIdGeneratorに実装すべきメソッドを示す。

| メソッド | 引数 | 戻り値 | 処理内容 |
|---|---|---|---|
| generateId | なし | void | メッセージIDの採番時に呼ばれる処理。  呼び出されるたびにユニークなメッセージIDを採番して返却する。 |

*メッセージID採番処理の実装例*

以下に、本インターフェースを使用したメッセージID採番処理の実装例を示す。
以下は簡易的な実装であり、IDがユニークである保証は無い。

```java
public class DefaultHttpMessageIdGenerator implements HttpMessageIdGenerator {
    /**
     * HTTP通信で使用するメッセージIDを採番する。
     * @return メッセージID
     */
    @Override
    public String generateId() {
        return Long.toString(System.currentTimeMillis());
    }
}
```

*送信設定の設定例*

```text
messageSender.リクエストID.httpMessageIdGeneratorComponentName=defaultHttpMessageIdGenerator
```

*DIの設定例*

```xml
<component name="defaultHttpMessageIdGenerator" class="please.change.me.tutorial.messaging.DefaultHttpMessageIdGenerator">
</component>
```
