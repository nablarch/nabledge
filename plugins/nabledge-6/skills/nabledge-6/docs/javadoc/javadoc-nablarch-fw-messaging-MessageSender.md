# class MessageSender

**パッケージ:** nablarch.fw.messaging

---

```java
public final class MessageSender
```

対外システムに対するメッセージの同期送信を行うユーティリティクラス。
<p/>
本ユーティリティはキューを使用した通信と、HTTP通信をサポートする。
<p/>
キューを使用した通信について<br/>
本ユーティリティはフレームワーク制御ヘッダの利用を前提としており、
再送電文フラグを利用した再送/タイムアウト制御等の機能を実装している。
<br>
キューを使用した通信では、カレントスレッドに紐づけられている{@link MessagingContext}を利用してメッセージ送信を行う。
そのため、{@link nablarch.fw.messaging.handler.MessagingContextHandler}をハンドラキューに追加する必要がある。
MessagingContextの設定方法については{@link MessageSenderSettings#MessageSenderSettings(String)}を参照。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### DEFAULT_MESSAGE_CONVERTOR

```java
private static final SyncMessageConvertor DEFAULT_MESSAGE_CONVERTOR
```

デフォルトのSyncMessageConvertor

---

## コンストラクタの詳細

### MessageSender

```java
private MessageSender()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### sendSync

```java
public static SyncMessage sendSync(SyncMessage requestMessage)
                     throws MessageSendSyncTimeoutException
```

対外システムにメッセージを送信し、応答された電文を返す。
<p/>
電文の設定情報について<br>
{@link MessageSenderSettings#MessageSenderSettings(String)}を実行して、対象リクエストの設定情報を取得する。
<p/>
要求電文の作成について<br>
要求電文の作成処理は{@link SyncMessageConvertor}に委譲する。
SyncMessageConvertorの取得方法は、{@link #getSyncMessageConvertor(MessageSenderSettings)}メソッドのJavaDocを参照。
デフォルトでは、フレームワークが提供するSyncMessageConvertorをそのまま使用する。
<p/>
メッセージの再送について<br>
キューを使用した通信では、設定によりリトライ回数が指定されている場合、
タイムアウト発生時に指定された回数まで再送を行う。<br>
HTTP通信では再送を行わない。
<p/>
メッセージ送受信中にエラーが発生した場合、{@link SyncMessagingEventHook}にエラー処理を委譲する。
SyncMessagingEventHookの設定方法は{@link MessageSenderSettings#MessageSenderSettings(String)}のJavaDocを参照。

**パラメータ:**
- `requestMessage` - 要求電文

**戻り値:**
応答電文

**例外:**
- `IllegalArgumentException` - 要求電文の設定情報に問題がある場合
- `MessageSendSyncTimeoutException` - タイムアウトが発生し、同期送信が正常終了しなかった場合

---

### sendSyncWithMessageSenderClient

```java
private static SyncMessage sendSyncWithMessageSenderClient(MessageSenderSettings settings, SyncMessage requestMessage)
```

MessageClientを使用した通信を行う。

**パラメータ:**
- `settings` - {@link MessageSender}の設定情報
- `requestMessage` - 要求電文

**戻り値:**
応答電文

---

### sendSyncWithProvider

```java
private static SyncMessage sendSyncWithProvider(MessageSenderSettings settings, SyncMessage requestMessage)
```

キューを用いた通信を行う。

**パラメータ:**
- `settings` - {@link MessageSender}の設定情報
- `requestMessage` - 要求電文

**戻り値:**
応答電文

---

### getSyncMessageConvertor

```java
private static SyncMessageConvertor getSyncMessageConvertor(MessageSenderSettings settings)
```

SyncMessageConvertorを取得する。
<pre>
設定情報で指定されたSyncMessageConvertorを返す。
設定情報でSyncMessageConvertorの指定がない場合は、
フレームワークが提供するSyncMessageConvertorをそのまま使用する。

SyncMessageConvertorの処理内容を変更したい場合は、
SyncMessageConvertorを継承したクラスをリポジトリに登録し、
設定情報に指定する。
</pre>

**パラメータ:**
- `settings` - 送信電文の設定情報

**戻り値:**
SyncMessageConvertor

---
