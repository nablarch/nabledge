# class SyncMessageConvertor

**パッケージ:** nablarch.fw.messaging

---

```java
public class SyncMessageConvertor
```

メッセージ同期送信に使用する電文を変換するクラス。
<pre>
本クラスは下記の変換を行う。

    要求電文({@link SyncMessage})→送信電文({@link SendingMessage})[初回送信時、再送時]
    受信電文({@link ReceivedMessage})→応答電文({@link SyncMessage})[受信時]

</pre>

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### convertOnSendSync

```java
public SendingMessage convertOnSendSync(MessageSenderSettings settings, SyncMessage requestMessage)
```

要求電文を送信電文に変換する。(初回送信時)
<pre>
指定された設定情報をもとに送信電文を作成する。
フレームワーク制御ヘッダ以外の設定は
{@link #createSendingMessage(MessageSenderSettings, SyncMessage)}メソッドに委譲する。

{@link FwHeader}を使用して下記のフレームワーク制御ヘッダを設定する。

    リクエストIDヘッダ: 送信電文の設定情報が保持している送信用リクエストID
    再送電文フラグ: 初回を表す"0"。再送しない場合は設定しない
</pre>

**パラメータ:**
- `settings` - 送信電文の設定情報
- `requestMessage` - 要求電文

**戻り値:**
送信電文

---

### convertOnRetry

```java
public SendingMessage convertOnRetry(MessageSenderSettings settings, SyncMessage requestMessage, SendingMessage timeoutMessage, int retryCount)
```

要求電文を送信電文に変換する。(再送時)
<pre>
指定された設定情報をもとに送信電文を作成する。
フレームワーク制御ヘッダ以外の設定は
{@link #createSendingMessage(MessageSenderSettings, SyncMessage)}メソッドに委譲する。

{@link FwHeader}を使用して下記のフレームワーク制御ヘッダを設定する。

    リクエストIDヘッダ: 送信電文の設定情報が保持している送信用リクエストID
    再送電文フラグ: 再送を表す"1"

再送する送信電文には、タイムアウトした送信電文と関連付けるために、
タイムアウトした送信電文のメッセージIDを設定する。

本実装ではリトライ回数を使用しない。
</pre>

**パラメータ:**
- `settings` - {@link MessageSender}の設定情報
- `requestMessage` - 要求電文
- `timeoutMessage` - タイムアウトした送信電文
- `retryCount` - リトライ回数。初回送信時は0

**戻り値:**
送信電文

---

### createSendingMessage

```java
protected SendingMessage createSendingMessage(MessageSenderSettings settings, SyncMessage requestMessage)
```

指定された設定情報をもとに送信電文を作成する。
<pre>
設定情報から下記の項目を送信電文に設定する。

    送信宛先キューの論理名
    応答宛先キューの論理名

メッセージボディ部にヘッダとデータを追加する。
下記のレコードタイプを使用する。

    ヘッダ: "header"
    データ: "data"

</pre>

**パラメータ:**
- `settings` - {@link MessageSender}の設定情報
- `requestMessage` - 要求電文

**戻り値:**
送信電文

---

### convertOnReceiveSync

```java
public SyncMessage convertOnReceiveSync(MessageSenderSettings settings, SyncMessage requestMessage, SendingMessage sendingMessage, ReceivedMessage receivedMessage)
```

受信電文を応答電文に変換する。(受信時)
<pre>
設定情報が提供するフォーマッタを使用して、
受信電文のメッセージボディ部からヘッダとデータを取り出し、応答電文を作成する。

本実装では送信電文を使用しない。
</pre>

**パラメータ:**
- `settings` - {@link MessageSender}の設定情報
- `requestMessage` - 要求電文
- `sendingMessage` - 送信電文
- `receivedMessage` - 受信電文

**戻り値:**
応答電文

---
