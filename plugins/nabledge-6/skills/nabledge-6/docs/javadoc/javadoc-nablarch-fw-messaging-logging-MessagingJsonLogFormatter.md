# class MessagingJsonLogFormatter

**パッケージ:** nablarch.fw.messaging.logging

**継承階層:**
```
java.lang.Object
  └─ MessagingLogFormatter
      └─ nablarch.fw.messaging.logging.MessagingJsonLogFormatter
```

---

```java
public class MessagingJsonLogFormatter
extends MessagingLogFormatter
```

メッセージ送受信処理の中で出力するためのログをJSON形式でフォーマットするクラス。

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### TARGET_NAME_LABEL

```java
private static final String TARGET_NAME_LABEL
```

ラベルの項目名

---

### TARGET_NAME_THREAD_NAME

```java
private static final String TARGET_NAME_THREAD_NAME
```

出力項目(スレッド名)の項目名

---

### TARGET_NAME_MESSAGE_ID

```java
private static final String TARGET_NAME_MESSAGE_ID
```

出力項目(メッセージID)の項目名

---

### TARGET_NAME_DESTINATION

```java
private static final String TARGET_NAME_DESTINATION
```

出力項目(宛先キュー名)の項目名

---

### TARGET_NAME_CORRELATION_ID

```java
private static final String TARGET_NAME_CORRELATION_ID
```

出力項目(関連メッセージID)の項目名

---

### TARGET_NAME_REPLY_TO

```java
private static final String TARGET_NAME_REPLY_TO
```

出力項目(応答宛先キュー名)の項目名

---

### TARGET_NAME_TIME_TO_LIVE

```java
private static final String TARGET_NAME_TIME_TO_LIVE
```

出力項目(メッセージ有効期間)の項目名

---

### TARGET_NAME_MESSAGE_BODY

```java
private static final String TARGET_NAME_MESSAGE_BODY
```

出力項目(メッセージボディ内容)の項目名

---

### TARGET_NAME_MESSAGE_BODY_HEX

```java
private static final String TARGET_NAME_MESSAGE_BODY_HEX
```

出力項目(メッセージボディ内容)の項目名

---

### TARGET_NAME_MESSAGE_BODY_LENGTH

```java
private static final String TARGET_NAME_MESSAGE_BODY_LENGTH
```

出力項目(メッセージボディバイト長)の項目名

---

### TARGET_NAME_MESSAGE_HEADER

```java
private static final String TARGET_NAME_MESSAGE_HEADER
```

出力項目(メッセージヘッダ)の項目名

---

### PROPS_SENT_MESSAGE_TARGETS

```java
private static final String PROPS_SENT_MESSAGE_TARGETS
```

MOM送信メッセージの出力項目のプロパティ名

---

### PROPS_RECEIVED_MESSAGE_TARGETS

```java
private static final String PROPS_RECEIVED_MESSAGE_TARGETS
```

MOM受信メッセージの出力項目のプロパティ名

---

### PROPS_HTTP_SENT_MESSAGE_TARGETS

```java
private static final String PROPS_HTTP_SENT_MESSAGE_TARGETS
```

HTTP送信メッセージの出力項目のプロパティ名

---

### PROPS_HTTP_RECEIVED_MESSAGE_TARGETS

```java
private static final String PROPS_HTTP_RECEIVED_MESSAGE_TARGETS
```

HTTP受信メッセージの出力項目のプロパティ名

---

### PROPS_SENT_MESSAGE_LABEL

```java
private static final String PROPS_SENT_MESSAGE_LABEL
```

MOM送信メッセージのラベルのプロパティ名

---

### PROPS_RECEIVED_MESSAGE_LABEL

```java
private static final String PROPS_RECEIVED_MESSAGE_LABEL
```

MOM受信メッセージのラベルのプロパティ名

---

### PROPS_HTTP_SENT_MESSAGE_LABEL

```java
private static final String PROPS_HTTP_SENT_MESSAGE_LABEL
```

HTTP送信メッセージのラベルのプロパティ名

---

### PROPS_HTTP_RECEIVED_MESSAGE_LABEL

```java
private static final String PROPS_HTTP_RECEIVED_MESSAGE_LABEL
```

HTTP受信メッセージのラベルのプロパティ名

---

### DEFAULT_SENT_MESSAGE_TARGETS

```java
private static final String DEFAULT_SENT_MESSAGE_TARGETS
```

デフォルトのMOM送信メッセージの出力項目

---

### DEFAULT_RECEIVED_MESSAGE_TARGETS

```java
private static final String DEFAULT_RECEIVED_MESSAGE_TARGETS
```

デフォルトのMOM受信メッセージの出力項目

---

### DEFAULT_HTTP_SENT_MESSAGE_TARGETS

```java
private static final String DEFAULT_HTTP_SENT_MESSAGE_TARGETS
```

デフォルトのHTTP送信メッセージの出力項目

---

### DEFAULT_HTTP_RECEIVED_MESSAGE_TARGETS

```java
private static final String DEFAULT_HTTP_RECEIVED_MESSAGE_TARGETS
```

デフォルトのHTTP受信メッセージの出力項目

---

### DEFAULT_SENT_MESSAGE_LABEL

```java
private static final String DEFAULT_SENT_MESSAGE_LABEL
```

デフォルトのMOM送信メッセージのラベル

---

### DEFAULT_RECEIVED_MESSAGE_LABEL

```java
private static final String DEFAULT_RECEIVED_MESSAGE_LABEL
```

デフォルトのMOM受信メッセージのラベル

---

### DEFAULT_HTTP_SENT_MESSAGE_LABEL

```java
private static final String DEFAULT_HTTP_SENT_MESSAGE_LABEL
```

デフォルトのHTTP送信メッセージのラベル

---

### DEFAULT_HTTP_RECEIVED_MESSAGE_LABEL

```java
private static final String DEFAULT_HTTP_RECEIVED_MESSAGE_LABEL
```

デフォルトのHTTP受信メッセージのラベル

---

### sentMessageTargets

```java
private List<JsonLogObjectBuilder<MessagingLogContext>> sentMessageTargets
```

リクエスト処理開始時のフォーマット済みのログ出力項目

---

### receivedMessageTargets

```java
private List<JsonLogObjectBuilder<MessagingLogContext>> receivedMessageTargets
```

hiddenパラメータ復号後のフォーマット済みのログ出力項目

---

### httpSentMessageTargets

```java
private List<JsonLogObjectBuilder<MessagingLogContext>> httpSentMessageTargets
```

ディスパッチ先クラス決定後のフォーマット済みのログ出力項目

---

### httpReceivedMessageTargets

```java
private List<JsonLogObjectBuilder<MessagingLogContext>> httpReceivedMessageTargets
```

リクエスト処理終了時のフォーマット済みのログ出力項目

---

### support

```java
private JsonLogFormatterSupport support
```

各種ログのJSONフォーマット支援オブジェクト

---

## コンストラクタの詳細

### MessagingJsonLogFormatter

```java
public MessagingJsonLogFormatter()
```

コンストラクタ。

---

## メソッドの詳細

### initialize

```java
protected void initialize(Map<String,String> props)
```

初期化。
フォーマット済みのログ出力項目を初期化する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### createSerializationManager

```java
protected JsonSerializationManager createSerializationManager(JsonSerializationSettings settings)
```

変換処理に使用する{@link JsonSerializationManager}を生成する。

**パラメータ:**
- `settings` - 各種ログ出力の設定情報

**戻り値:**
{@link JsonSerializationManager}

---

### getObjectBuilders

```java
protected Map<String,JsonLogObjectBuilder<MessagingLogContext>> getObjectBuilders(Map<String,String> props)
```

フォーマット対象のログ出力項目を取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
フォーマット対象のログ出力項目

---

### getStructuredTargets

```java
private List<JsonLogObjectBuilder<MessagingLogContext>> getStructuredTargets(Map<String,JsonLogObjectBuilder<MessagingLogContext>> objectBuilders, Map<String,String> props, String targetsPropName, String defaultTargets)
```

ログ出力項目を取得する。

**パラメータ:**
- `objectBuilders` - オブジェクトビルダー
- `props` - 各種ログ出力の設定情報
- `targetsPropName` - 出力項目のプロパティ名
- `defaultTargets` - デフォルトの出力項目

**戻り値:**
ログ出力項目

---

### getSentMessageLog

```java
public String getSentMessageLog(SendingMessage message)
```

{@inheritDoc}

---

### getReceivedMessageLog

```java
public String getReceivedMessageLog(ReceivedMessage message)
```

{@inheritDoc}

---

### getHttpSentMessageLog

```java
public String getHttpSentMessageLog(SendingMessage message, Charset charset)
```

{@inheritDoc}

---

### getHttpReceivedMessageLog

```java
public String getHttpReceivedMessageLog(ReceivedMessage message, Charset charset)
```

{@inheritDoc}

---
