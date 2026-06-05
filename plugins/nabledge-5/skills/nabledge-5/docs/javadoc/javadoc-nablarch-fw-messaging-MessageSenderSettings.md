# class MessageSenderSettings

**パッケージ:** nablarch.fw.messaging

---

```java
public class MessageSenderSettings
```

{@link MessageSender}の設定情報を保持するクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### KEY_SEPARATOR

```java
private static final String KEY_SEPARATOR
```

設定情報キーのセパレータ

---

### KEY_PREFIX

```java
private static final String KEY_PREFIX
```

設定情報キーのプレフィックス

---

### KEY_DEFAULT_TARGET

```java
private static final String KEY_DEFAULT_TARGET
```

設定情報キーのデフォルト設定に使用するターゲット

---

### settingRequestId

```java
private final String settingRequestId
```

設定情報キーのリクエストID

---

### sendingRequestId

```java
private final String sendingRequestId
```

送信用リクエストID

---

### messagingProvider

```java
private MessagingProvider messagingProvider
```

{@link nablarch.fw.messaging.MessagingProvider}

---

### destination

```java
private String destination
```

送信キュー名(論理名)

---

### replyTo

```java
private String replyTo
```

受信キュー名(論理名)

---

### retryCount

```java
private int retryCount
```

リトライ回数

---

### timeout

```java
private long timeout
```

応答タイムアウト(単位:ミリ秒)

---

### headerFormatter

```java
private DataRecordFormatter headerFormatter
```

ヘッダのフォーマッタ(送信電文と受信電文で共通)

---

### sendingDataFormatter

```java
private DataRecordFormatter sendingDataFormatter
```

送信電文データのフォーマッタ

---

### receivedDataFormatter

```java
private DataRecordFormatter receivedDataFormatter
```

受信電文データのフォーマッタ

---

### messageConvertor

```java
private SyncMessageConvertor messageConvertor
```

{@link nablarch.fw.messaging.SyncMessageConvertor}

---

### syncMessagingEventHookList

```java
private final List<SyncMessagingEventHook> syncMessagingEventHookList
```

メッセージ送信の処理前後に処理を行うためのインターフェイス

---

### messageSenderClient

```java
private final MessageSenderClient messageSenderClient
```

MessageSenderから呼び出される基本APIを実装したインターフェース

---

### httpMessagingUserId

```java
private String httpMessagingUserId
```

HTTP通信に使用するユーザID

---

### httpConnectTimeout

```java
private int httpConnectTimeout
```

HTTP通信で使用する接続タイムアウト

---

### httpReadTimeout

```java
private int httpReadTimeout
```

HTTP通信で使用する読み取りタイムアウト

---

### uri

```java
private String uri
```

HTTP通信用URI

---

### httpMethod

```java
private String httpMethod
```

HTTP通信で使用するHTTPメソッド

---

### httpMessageIdGenerator

```java
private HttpMessageIdGenerator httpMessageIdGenerator
```

HTTP通信で使用するメッセージID採番クラス

---

### sslContextSettings

```java
private HttpSSLContextSettings sslContextSettings
```

HTTP通信で使用するSSL情報

---

### httpProxyHost

```java
private String httpProxyHost
```

HTTP通信で使用するプロキシのホスト

---

### httpProxyPort

```java
private Integer httpProxyPort
```

HTTP通信で使用するプロキシのホスト

---

## コンストラクタの詳細

### MessageSenderSettings

```java
public MessageSenderSettings(String requestId)
```

コンストラクタ。
<pre>
リポジトリから設定値を取得し初期化を行う。

&lt;キューを使用した通信で使用する設定項目&gt;
デフォルト設定
messageSender.DEFAULT.messagingProviderName=MessagingProviderをリポジトリから取得する際に使用するコンポーネント名
messageSender.DEFAULT.destination=送信キュー名(論理名)
messageSender.DEFAULT.replyTo=受信キュー名(論理名)
messageSender.DEFAULT.retryCount=タイムアウト発生時の再送回数。再送しない場合は0以下を指定。デフォルトは-1
messageSender.DEFAULT.formatDir=フォーマット定義ファイルの格納ディレクトリ(論理名)。デフォルトはformat
messageSender.DEFAULT.headerFormatName=ヘッダフォーマット名
messageSender.DEFAULT.messageConvertorName=SyncMessageConvertorをリポジトリから取得する際に使用するコンポーネント名

個別設定
messageSender.リクエストID.messagingProviderName=MessagingProviderをリポジトリから取得する際に使用するコンポーネント名。デフォルト設定を指定しない場合は必須
messageSender.リクエストID.destination=送信キュー名(論理名)。デフォルト設定を指定しない場合は必須
messageSender.リクエストID.replyTo=受信キュー名(論理名)。デフォルト設定を指定しない場合は必須
messageSender.リクエストID.timeout=応答タイムアウト(単位:ミリ秒)。デフォルトは-1。0以下または指定がない場合はMessagingProviderの設定値となる
messageSender.リクエストID.retryCount=タイムアウト発生時の再送回数。再送しない場合は0以下を指定
messageSender.リクエストID.headerFormatName=ヘッダフォーマット名。デフォルト設定を指定しない場合は必須
messageSender.リクエストID.sendingRequestId=送信用リクエストID。メッセージ処理用のリクエストIDが重複する場合に使用する。
                                            送信用リクエストIDが指定された場合は、送信用リクエストIDの値をヘッダのリクエストIDに設定する。
messageSender.リクエストID.messageConvertorName=SyncMessageConvertorをリポジトリから取得する際に使用するコンポーネント名


&lt;HTTP通信で使用する設定項目&gt;
以下の項目が定義されているリクエストについて、「HTTP通信を行う」とみなす。
・messageSender.リクエストID.messageSenderClient

デフォルト設定
messageSender.DEFAULT.httpMessagingUserId=フレームワーク制御ヘッダーに設定するユーザID
messageSender.DEFAULT.httpMethod=通信に使用するHTTPメソッド
messageSender.DEFAULT.httpConnectTimeout=コネクションタイムアウト(単位:ミリ秒)。0の場合は、サーバから切断されるまで待ち続ける。
messageSender.DEFAULT.httpReadTimeout=読み取りタイムアウト(単位:ミリ秒)。0の場合は、サーバからデータを読み終わるまで待ち続ける。
messageSender.DEFAULT.sslContextComponentName=SSLContext取得コンポーネント(論理名)。SSL通信時、証明書の設定を行いたい場合に設定する。
messageSender.DEFAULT.httpProxyHost=プロキシサーバ
messageSender.DEFAULT.httpProxyPort=プロキシサーバのポート
messageSender.DEFAULT.httpMessageIdGeneratorComponentName=HTTPヘッダに付与するメッセージID(キー名：X-Message-Id)の採番コンポーネント(任意項目)。

個別設定
messageSender.リクエストID.messageSenderClient=MessageSenderClient通信クライアント(論理名)。HTTP通信時は必須。
messageSender.リクエストID.httpMessagingUserId=フレームワーク制御ヘッダーに設定するユーザID。任意項目。
messageSender.リクエストID.uri=接続先uri。必須項目
messageSender.リクエストID.httpMethod=通信に使用するHTTPメソッド
messageSender.リクエストID.httpConnectTimeout=コネクションタイムアウト(単位:ミリ秒)。デフォルト値にも、本項目にも指定がない場合は、0を設定したとみなす。
messageSender.リクエストID.httpReadTimeout=コネクションタイムアウト(単位:ミリ秒)。デフォルト値にも、本項目にも指定がない場合は、0を設定したとみなす。
messageSender.リクエストID.sslContextComponentName=SSLContext取得コンポーネント(論理名)。任意項目。
messageSender.リクエストID.httpProxyHost=プロキシサーバ
messageSender.リクエストID.httpProxyPort=プロキシサーバのポート
messageSender.リクエストID.httpMessageIdGeneratorComponentName=HTTPヘッダに付与するメッセージID(キー名：X-Message-Id)の採番コンポーネント(任意項目)。


&lt;キューを使用した通信、HTTP通信共通事項&gt;
デフォルト設定
messageSender.DEFAULT.syncMessagingEventHookNames=同期送信の前後処理をリポジトリから取得する際に使用するコンポーネント名(論理名)。複数指定可（「,」で区切って指定）。任意項目。

個別設定
messageSender.リクエストID.syncMessagingEventHookNames=同期送信の前後処理をリポジトリから取得する際に使用するコンポーネント名(論理名)。複数指定可（「,」で区切って指定）。任意項目。

送信電文データと受信電文データのフォーマッタは下記のフォーマット名から取得する。

    送信電文データのフォーマット名: リクエストID＋"_SEND"
    受信電文データのフォーマット名: リクエストID＋"_RECEIVE"
</pre>

**パラメータ:**
- `requestId` - リクエストID

---

## メソッドの詳細

### canUseMessageSenderClient

```java
public boolean canUseMessageSenderClient()
```

messageSenderClientを使用した通信を行うか否かを取得する。

**戻り値:**
trueの場合にmessageSenderClientを使用した通信を行う。

---

### getComponent

```java
public T getComponent(String propertyName, SettingType settingType, boolean required)
```

コンポーネント名の設定値を使用してリポジトリからコンポーネントを取得する。
<pre>
{@link #getStringSetting(String, SettingType, boolean, String)}メソッドを使用して
取得したコンポーネント名を使用してリポジトリからコンポーネントを取得する。
コンポーネント名取得の詳細は{@link #getStringSetting(String, SettingType, boolean, String)}メソッド
のJavaDocを参照。

コンポーネント名が指定され、かつrequired属性がtrueの場合に、
リポジトリからコンポーネントが取得できない場合は実行時例外を送出する。
</pre>

**パラメータ:**
- `<T>` - コンポーネントの型
- `propertyName` - プロパティ名
- `settingType` - 設定値のタイプ
- `required` - 必須の場合はtrue

**戻り値:**
コンポーネント

---

### getComponentList

```java
public List<T> getComponentList(String propertyName, SettingType settingType, boolean required)
```

コンポーネント名の設定値を使用してリポジトリからコンポーネントを取得する(「,」区切りで定義された複数コンポーネントの読み込みに対応)。
<pre>
{@link #getStringSetting(String, SettingType, boolean, String)}メソッドを使用して
取得したコンポーネント名を使用してリポジトリからコンポーネントを取得する。
コンポーネント名取得の詳細は{@link #getStringSetting(String, SettingType, boolean, String)}メソッド
のJavaDocを参照。

コンポーネント名が指定され、かつrequired属性がtrueの場合に、
リポジトリからコンポーネントが取得できない場合は実行時例外を送出する。
</pre>

**パラメータ:**
- `<T>` - コンポーネントの型
- `propertyName` - プロパティ名
- `settingType` - 設定値のタイプ
- `required` - 必須の場合はtrue

**戻り値:**
コンポーネント

---

### getFormatter

```java
public DataRecordFormatter getFormatter(String propertyName, SettingType settingType, String formatDir, String formatName)
```

指定されたフォーマット名に対応するフォーマッタを取得する。

**パラメータ:**
- `propertyName` - プロパティ名
- `settingType` - 設定値のタイプ
- `formatDir` - フォーマット定義ファイルの格納ディレクトリ(論理名)
- `formatName` - フォーマット名

**戻り値:**
指定されたフォーマット名に対応するフォーマッタ

---

### getSettingRequestId

```java
public String getSettingRequestId()
```

設定情報キーのリクエストIDを取得する。

**戻り値:**
設定情報キーのリクエストID

---

### getSendingRequestId

```java
public String getSendingRequestId()
```

送信用リクエストIDを取得する。
<p/>
送信用リクエストIDが設定されない場合は、設定情報キーのリクエストIDが返される。

**戻り値:**
送信用リクエストID

---

### getMessagingProvider

```java
public MessagingProvider getMessagingProvider()
```

{@link nablarch.fw.messaging.MessagingProvider}を取得する。

**戻り値:**
{@link nablarch.fw.messaging.MessagingProvider}

---

### getMessageConvertor

```java
public SyncMessageConvertor getMessageConvertor()
```

{@link nablarch.fw.messaging.SyncMessageConvertor}を取得する。

**戻り値:**
{@link nablarch.fw.messaging.SyncMessageConvertor}。
         指定がない場合はnull

---

### getDestination

```java
public String getDestination()
```

送信キュー名(論理名)を取得する。

**戻り値:**
送信キュー名(論理名)

---

### getReplyTo

```java
public String getReplyTo()
```

受信キュー名(論理名)を取得する。

**戻り値:**
受信キュー名(論理名)

---

### getRetryCount

```java
public int getRetryCount()
```

リトライ回数を取得する。

**戻り値:**
リトライ回数

---

### getTimeout

```java
public long getTimeout()
```

応答タイムアウト(単位:ミリ秒)を取得する。

**戻り値:**
応答タイムアウト(単位:ミリ秒)

---

### getHeaderFormatter

```java
public DataRecordFormatter getHeaderFormatter()
```

ヘッダのフォーマッタ(送信電文と受信電文で共通)を取得する。

**戻り値:**
ヘッダのフォーマッタ(送信電文と受信電文で共通)

---

### getSendingDataFormatter

```java
public DataRecordFormatter getSendingDataFormatter()
```

送信電文データのフォーマッタを取得する。

**戻り値:**
送信電文データのフォーマッタ

---

### getReceivedDataFormatter

```java
public DataRecordFormatter getReceivedDataFormatter()
```

受信電文データのフォーマッタを取得する。

**戻り値:**
受信電文データのフォーマッタ

---

### getSyncMessagingEventHookList

```java
public List<SyncMessagingEventHook> getSyncMessagingEventHookList()
```

メッセージ送信の処理前後に行う処理を取得する。

**戻り値:**
メッセージ送信の処理前後に行う処理

---

### getMessageSenderClient

```java
public MessageSenderClient getMessageSenderClient()
```

MessageSenderから呼び出される基本APIを実装したインターフェースを取得する。<br>
<p>
{@link MessagingProvider}と{@link MessageSenderClient}が共に本クラスに設定されている場合は、{@link MessageSenderClient}を優先的に使用する。
</p>
</br>

**戻り値:**
MessageSenderから呼び出される基本APIを実装したインターフェース

---

### getHttpMessagingUserId

```java
public String getHttpMessagingUserId()
```

リアルタイム通信で使用するユーザIDを取得する。

**戻り値:**
リアルタイム通信で使用するユーザID

---

### getHttpConnectTimeout

```java
public int getHttpConnectTimeout()
```

HTTP通信用接続タイムアウトを取得する。

**戻り値:**
接続タイムアウト

---

### getHttpReadTimeout

```java
public int getHttpReadTimeout()
```

HTTP通信用読み取りタイムアウトを取得する。

**戻り値:**
読み取りタイムアウト

---

### getHttpMethod

```java
public String getHttpMethod()
```

HTTPMethodを取得する。

**戻り値:**
HTTPMethod

---

### getHttpMessageIdGenerator

```java
public HttpMessageIdGenerator getHttpMessageIdGenerator()
```

HTTP通信時に使用するメッセージID採番コンポーネントを取得する。

**戻り値:**
HTTP通信の接続先URI

---

### getUri

```java
public String getUri()
```

HTTP通信の接続先URIを取得する。

**戻り値:**
HTTP通信の接続先URI

---

### getSslContextSettings

```java
public HttpSSLContextSettings getSslContextSettings()
```

HTTP通信時に使用するSSLContextを取得する。

**戻り値:**
HTTP通信の接続先URI

---

### getHttpProxyHost

```java
public String getHttpProxyHost()
```

HTTP通信時に使用するProxyのホストを取得する。

**戻り値:**
HTTP通信時に使用するProxyのホスト

---

### getHttpProxyPort

```java
public Integer getHttpProxyPort()
```

HTTP通信時に使用するProxyのポートを取得する。

**戻り値:**
HTTP通信時に使用するProxyのポート

---

### createSettingKey

```java
private String createSettingKey(String targetName, String propertyName)
```

設定情報キーを作成する。
<pre>
設定情報キーの形式は下記のとおり。

    "messageSender" + "." + ターゲット名 + "." + プロパティ名

ターゲット名の値は下記のとおり。

    デフォルト設定の場合: "DEFAULT"
    個別設定の場合: リクエストID

</pre>

**パラメータ:**
- `targetName` - ターゲット名
- `propertyName` - プロパティ名

**戻り値:**
設定情報キー

---

### getIntSetting

```java
public Integer getIntSetting(String propertyName, SettingType settingType, boolean required, Integer defaultValue)
```

Integer型の設定値を取得する。
<pre>
{@link #getStringSetting(String, SettingType, boolean, String)}メソッドを使用して
取得した設定値をInteger型に変換して返す。
設定値取得の詳細は{@link #getStringSetting(String, SettingType, boolean, String)}メソッド
のJavaDocを参照。
</pre>

**パラメータ:**
- `propertyName` - プロパティ名
- `settingType` - 設定値のタイプ
- `required` - 必須の場合はtrue
- `defaultValue` - デフォルト値

**戻り値:**
Integer型の設定値

---

### getLongSetting

```java
public Long getLongSetting(String propertyName, SettingType settingType, boolean required, Long defaultValue)
```

Long型の設定値を取得する。
<pre>
{@link #getStringSetting(String, SettingType, boolean, String)}メソッドを使用して
取得した設定値をLong型に変換して返す。
設定値取得の詳細は{@link #getStringSetting(String, SettingType, boolean, String)}メソッド
のJavaDocを参照。
</pre>

**パラメータ:**
- `propertyName` - プロパティ名
- `settingType` - 設定値のタイプ
- `required` - 必須の場合はtrue
- `defaultValue` - デフォルト値

**戻り値:**
Long型の設定値

---

### getStringSetting

```java
public String getStringSetting(String propertyName, SettingType settingType, boolean required, String defaultValue)
```

String型の設定値を取得する。
<pre>
{@link #createSettingKey(String, String)}メソッドを使用し設定情報キーを取得する。

はじめに個別設定の取得を試み、取得できない場合はデフォルト設定の取得を試みる。
ただし、settingType引数の指定に応じて個別設定とデフォルト設定の取得を行う。

設定値を取得できない、かつrequired引数がtrueの場合は、実行時例外を送出する。
設定値を取得できない、かつrequired引数がfalseの場合は、デフォルト値を返す。
</pre>

**パラメータ:**
- `propertyName` - プロパティ名
- `settingType` - 設定値のタイプ
- `required` - 必須の場合はtrue
- `defaultValue` - デフォルト値

**戻り値:**
String型の設定値

---

### createSettingKeyMessage

```java
public String createSettingKeyMessage(SettingType settingType, String propertyName)
```

エラーメッセージに付加する設定値のタイプに応じた設定情報キーのメッセージを作成する。
<pre>
メッセージの形式は下記のとおり。

    デフォルト設定のみ            : "defaultKey = [デフォルト設定キー]"
    個別設定のみ                  : "key = [個別設定キー]"
    デフォルト設定と個別設定の両方: "defaultKey = [デフォルト設定キー] or key = [個別設定キー]"

キーは{@link #createSettingKey(String, String)}メソッドを使用して取得する。
</pre>

**パラメータ:**
- `settingType` - 設定値のタイプ
- `propertyName` - プロパティ名

**戻り値:**
エラーメッセージに付加する設定値のタイプに応じた設定情報キーのメッセージ

---
