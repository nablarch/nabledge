# class JmsMessagingProvider

**パッケージ:** nablarch.fw.messaging.provider

**実装されたインタフェース:**
- MessagingProvider

---

```java
public class JmsMessagingProvider
implements MessagingProvider
```

JMSプロバイダを利用したメッセージング機能の実装。

各JMSプロバイダが実装するConnectionFactoryおよびQueueオブジェクトを設定
することにより、メッセージング機能が利用可能となる。
<p/>

<dv><b>Poison電文の退避</b></div>
<hr/>
本実装ではPoison電文の退避処理を独自に実装しており、リトライ上限、
退避キュー名称を指定することができる。
ただし、この機能はJMSXDeliveryCountヘッダに依存しているため、同ヘッダを
サポートしない一部のMOM製品/バージョンでは利用できない。
なお、以下のMOMについては最新版における同ヘッダのサポートを確認している。
<pre>
- IBM MQ
- WebLogic MQ
- ActiveMQ
</pre>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

メッセージングログを出力するロガー

---

### factory

```java
private ConnectionFactory factory
```

JMSプロバイダによるコネクションファクトリ実装

---

### queueTable

```java
private final Map<String,Queue> queueTable
```

キュー名をキーとするJMS QueueオブジェクトのMap

---

### poisonQueueNamePattern

```java
private String poisonQueueNamePattern
```

退避キュー論理名のパターン

---

### defaultPoisonQueue

```java
private String defaultPoisonQueue
```

デフォルト退避キューの論理名

---

### redeliveryLimit

```java
private int redeliveryLimit
```

MOMによる受信リトライ上限値

---

### timeout

```java
private long timeout
```

同期送信デフォルトタイムアウト値 (msec)

---

### timeToLive

```java
private long timeToLive
```

送信電文デフォルト有効期間 (msec)

---

### messagingExceptionFactory

```java
private MessagingExceptionFactory messagingExceptionFactory
```

{@link MessagingException}ファクトリオブジェクト

---

## メソッドの詳細

### createContext

```java
public MessagingContext createContext()
```

{@inheritDoc}
 この実装では、コネクションファクトリからJMSコネクションを取得し、
 新規セッションを作成する。

---

### setDefaultResponseTimeout

```java
public MessagingProvider setDefaultResponseTimeout(long timeout)
```

{@inheritDoc}
同期送信処理におけるデフォルトタイムアウト値を設定する。
デフォルトタイムアウトを明示的に設定しなかった場合のデフォルトタイムアウトは
5分間となる。

---

### setDefaultTimeToLive

```java
public MessagingProvider setDefaultTimeToLive(long timeToLive)
```

{@inheritDoc}
送信電文のデフォルト有効期間を設定する。
デフォルト値を明示的に設定しなかった場合の有効期間は30秒(30000msec)となる。

---

### setConnectionFactory

```java
public JmsMessagingProvider setConnectionFactory(ConnectionFactory factory)
```

コネクションファクトリを設定する。

このクラスではコネクションプール機能を提供していないため、
コネクションプール機能を内蔵したコネクションファクトリを使用することを
強く推奨する。

**パラメータ:**
- `factory` - コネクションファクトリ

**戻り値:**
このオブジェクト自体

---

### getConnectionFactory

```java
public ConnectionFactory getConnectionFactory()
```

コネクションファクトリを返す。

**戻り値:**
コネクションファクトリ

---

### setDestinations

```java
public JmsMessagingProvider setDestinations(Map<String,Queue> table)
```

メッセージング機能で使用する宛先の論理名とJMS Destinationオブジェクトとの
マッピングを設定する。
（既存の設定があった場合は上書きされる。）

**パラメータ:**
- `table` - キューの論理名とそれに対応するQueueオブジェクトとのマッピング

**戻り値:**
このオブジェクト自体

---

### setPoisonQueueNamePattern

```java
public JmsMessagingProvider setPoisonQueueNamePattern(String pattern)
```

各受信キューに対する退避キューの論理名を決定する際に使用する
パターン文字列を設定する。
明示的に指定しなかった場合のデフォルトは、
<code>(受信キュー名).POISON</code>
となる。
当該のキューが存在しなかった場合はデフォルトの退避キュー名を使用する。

**パラメータ:**
- `pattern` - 退避キューの論理名を決定する際に使用するパターン文字列

**戻り値:**
このオブジェクト自体

---

### setDefaultPoisonQueue

```java
public JmsMessagingProvider setDefaultPoisonQueue(String queueName)
```

デフォルトで使用する受信退避キューの論理名を設定する。
当該のキューが存在しなかった場合は、MessgingExceptionを送出する。
明示的に指定しなかった場合は、<code>DEFAULT.POISON</code>を使用する。

**パラメータ:**
- `queueName` - キュー名称

**戻り値:**
このオブジェクト自体

---

### setRedeliveryLimit

```java
public JmsMessagingProvider setRedeliveryLimit(int limit)
```

MOMによる受信リトライの上限回数を設定する。
受信メッセージのJMSXDeliveryCountヘッダの値がこの上限値を越えると、
メッセージを退避キューに転送した上で、MessagingExceptionを送出する。

この値が0以下の数値であった場合は、退避処理自体が無効化される。
明示的に指定しない場合のデフォルトは0である。

**パラメータ:**
- `limit` - 受信リトライの上限回数

**戻り値:**
このオブジェクト自体。

---

### setMessagingExceptionFactory

```java
public MessagingProvider setMessagingExceptionFactory(MessagingExceptionFactory messagingExceptionFactory)
```

{@link MessagingException}ファクトリオブジェクトを設定する。
<p/>
デフォルトは{@link BasicMessagingExceptionFactory}。

**パラメータ:**
- `messagingExceptionFactory` - {@link MessagingException}ファクトリオブジェクト

**戻り値:**
このオブジェクト自体

---
