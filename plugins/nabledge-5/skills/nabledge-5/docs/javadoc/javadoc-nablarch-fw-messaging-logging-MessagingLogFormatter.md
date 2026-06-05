# class MessagingLogFormatter

**パッケージ:** nablarch.fw.messaging.logging

---

```java
public class MessagingLogFormatter
```

メッセージ送受信処理の中でログ出力を行うクラス。

ログファイルはキュー毎に個別に設定できる。
ログが出力されるタイミングは以下のとおり
<pre>
1. 送信処理完了時 (ローカルキューへのPUT完了直後)
2. 電文受信時
</pre>

出力可能な項目は以下のとおり。
<pre>
1. 共通プロトコルヘッダ
  - メッセージID (String)
  - 関連メッセージID (String)
  - 送信宛先キュー論理名 (String)
  - 応答宛先キュー論理名 (String)

2. メッセージボディデータ
  - メッセージボディのバイト長 (int)
  - メッセージボディ
  - メッセージボディのヘキサダンプ

  ※メッセージボディに含まれる個人情報や機密情報はマスクして出力することが可能である(マスク用の設定が必要)

3. MOM固有プロトコルヘッダ(以下はJmsMessagingProviderの場合)
    JMSType
    JMSDeliveryMode
    JMSPriority
    JMSTimestamp
    JMSExpiration   
    JMSRedelivered
    JMSXDeliveryCount
    JMSXGroupID
    JMSXGroupSeq
    JMSXProducerTXID

4. そのほか
    - スレッド名
    - メッセージヘッダ
</pre>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### PROPS_PREFIX

```java
public static final String PROPS_PREFIX
```

プロパティ名のプレフィックス

---

### PROPS_MASKING_CHAR

```java
private static final String PROPS_MASKING_CHAR
```

マスク文字を取得する際に使用するプロパティ名

---

### PROPS_MASKING_PATTERNS

```java
private static final String PROPS_MASKING_PATTERNS
```

本文のマスク対象のパターンを取得する際に使用するプロパティ名

---

### DEFAULT_MASKING_CHAR

```java
private static final String DEFAULT_MASKING_CHAR
```

デフォルトのマスク文字

---

### DEFAULT_MASKING_PATTERNS

```java
private static final Pattern[] DEFAULT_MASKING_PATTERNS
```

デフォルトのマスク対象のパターン

---

### MULTIVALUE_SEPARATOR_PATTERN

```java
private static final Pattern MULTIVALUE_SEPARATOR_PATTERN
```

多値指定(カンマ区切り)のプロパティを分割する際に使用するパターン

---

### props

```java
private Map<String,String> props
```

プロパティ

---

### logItems

```java
private Map<String,LogItem<MessagingLogContext>> logItems
```

ログ出力項目

---

### sentMessageLogItems

```java
private final LogItem<MessagingLogContext>[] sentMessageLogItems
```

ログ出力項目

---

### PROPS_SENT_MESSAGE_FORMAT

```java
private static final String PROPS_SENT_MESSAGE_FORMAT
```

フォーマット定義のプロパティ名

---

### DEFAULT_SENT_MESSAGE_FORMAT

```java
private static final String DEFAULT_SENT_MESSAGE_FORMAT
```

デフォルトのフォーマット

---

### receivedMessageLogItems

```java
private final LogItem<MessagingLogContext>[] receivedMessageLogItems
```

ログ出力項目

---

### PROPS_RECEIVED_MESSAGE_FORMAT

```java
private static final String PROPS_RECEIVED_MESSAGE_FORMAT
```

フォーマット定義のプロパティ名

---

### DEFAULT_RECEIVED_MESSAGE_FORMAT

```java
private static final String DEFAULT_RECEIVED_MESSAGE_FORMAT
```

デフォルトのフォーマット

---

### httpSentMessageLogItems

```java
private final LogItem<MessagingLogContext>[] httpSentMessageLogItems
```

ログ出力項目

---

### PROPS_HTTP_SENT_MESSAGE_FORMAT

```java
private static final String PROPS_HTTP_SENT_MESSAGE_FORMAT
```

フォーマット定義のプロパティ名

---

### DEFAULT_HTTP_SENT_MESSAGE_FORMAT

```java
private static final String DEFAULT_HTTP_SENT_MESSAGE_FORMAT
```

デフォルトのフォーマット

---

### httpReceivedMessageLogItems

```java
private final LogItem<MessagingLogContext>[] httpReceivedMessageLogItems
```

ログ出力項目

---

### PROPS_HTTP_RECEIVED_MESSAGE_FORMAT

```java
private static final String PROPS_HTTP_RECEIVED_MESSAGE_FORMAT
```

フォーマット定義のプロパティ名

---

### DEFAULT_HTTP_RECEIVED_MESSAGE_FORMAT

```java
private static final String DEFAULT_HTTP_RECEIVED_MESSAGE_FORMAT
```

デフォルトのフォーマット

---

## メソッドの詳細

### getSentMessageLog

```java
public String getSentMessageLog(SendingMessage message)
```

同期送信処理開始時に出力されるログ文字列を生成する。

**パラメータ:**
- `message` - 電文オブジェクト

**戻り値:**
ログ文字列

---

### getReceivedMessageLog

```java
public String getReceivedMessageLog(ReceivedMessage message)
```

同期送信処理開始時に出力されるログ文字列を生成する。

**パラメータ:**
- `message` - 電文オブジェクト

**戻り値:**
ログ文字列

---

### getHttpSentMessageLog

```java
public String getHttpSentMessageLog(SendingMessage message, Charset charset)
```

同期送信処理開始時に出力されるログ文字列を生成する。

**パラメータ:**
- `message` - 電文オブジェクト
- `charset` - 出力に使用する文字セット

**戻り値:**
ログ文字列

---

### getHttpReceivedMessageLog

```java
public String getHttpReceivedMessageLog(ReceivedMessage message, Charset charset)
```

同期送信処理開始時に出力されるログ文字列を生成する。

**パラメータ:**
- `message` - 電文オブジェクト
- `charset` - 出力に使用する文字セット

**戻り値:**
ログ文字列

---

### getFormattedLogItems

```java
protected LogItem<MessagingLogContext>[] getFormattedLogItems(Map<String,LogItem<MessagingLogContext>> logItems, Map<String,String> props, String formatPropName, String defaultFormat)
```

フォーマット済みのログ出力項目を取得する。

**パラメータ:**
- `logItems` - フォーマット対象のログ出力項目
- `props` - 各種ログ出力の設定情報
- `formatPropName` - フォーマットのプロパティ名
- `defaultFormat` - デフォルトのフォーマット

**戻り値:**
フォーマット済みのログ出力項目

---

### getLogItems

```java
protected Map<String,LogItem<MessagingLogContext>> getLogItems()
```

フォーマット対象のログ出力項目を取得する。

**戻り値:**
フォーマット対象のログ出力項目

---

### getMaskingChar

```java
protected char getMaskingChar(Map<String,String> props)
```

マスク文字を取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
マスク文字

---

### getBodyMaskingPatterns

```java
protected Pattern[] getBodyMaskingPatterns(Map<String,String> props)
```

本文のマスク対象のパラメータ名を取得する。<br>
プロパティの指定がない場合はデフォルト値を返す。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
マスク対象のパラメータ名

---

### getProp

```java
protected String getProp(Map<String,String> props, String propName, String defaultValue)
```

プロパティを取得する。<br>
プロパティの指定がない場合はデフォルト値を返す。

**パラメータ:**
- `props` - 各種ログの設定情報
- `propName` - プロパティ名
- `defaultValue` - プロパティのデフォルト値

**戻り値:**
プロパティ

---
