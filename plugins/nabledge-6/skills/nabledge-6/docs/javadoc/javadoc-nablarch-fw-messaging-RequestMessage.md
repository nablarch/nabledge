# class RequestMessage

**パッケージ:** nablarch.fw.messaging

**継承階層:**
```
java.lang.Object
  └─ ReceivedMessage
      └─ nablarch.fw.messaging.RequestMessage
```

**実装されたインタフェース:**
- Request<Object>

---

```java
public class RequestMessage
extends ReceivedMessage
implements Request<Object>
```

外部システムから受信した処理要求電文の内容を格納し、対応する応答電文を作成するクラス。
<p/>
{@link ReceivedMessage}と比べて、以下の処理が追加されている。
<ul>
    <li>フレームワーク制御ヘッダ({@link FwHeader})を保持する</li>
    <li>応答電文({@link ResponseMessage})オブジェクトを作成する</li>
</ul>
<p/>
本クラスは以下のデータを格納する。
<pre>
  1. プロトコルヘッダ (Map)
       - メッセージID (String)
       - 宛先キュー名 (String)   ...等

  2.  フレームワーク制御ヘッダ (Map)
       - リクエストID (String)
       - ユーザID (String)
       - 再送制御フラグ (Boolean)
       - 処理結果ステータスコード (String)  ...等

  3.  メッセージボディ(byte[])
     ※ フレームワーク制御ヘッダに相当するデータは含まれない。
</pre>
<p/>
このクラスは{@link Request}インタフェースを実装しており、後続業務処理の入力となる。
(リクエストパスとして、フレームワーク制御ヘッダのリクエストIDを使用する。)

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### fwHeader

```java
private final FwHeader fwHeader
```

フレームワーク制御ヘッダ

---

### formatterOfReply

```java
private DataRecordFormatter formatterOfReply
```

応答電文のフォーマッタ *

---

## コンストラクタの詳細

### RequestMessage

```java
public RequestMessage(FwHeader header, ReceivedMessage message)
```

**パラメータ:**
- `header` - フレームワーク制御ヘッダ
- `message` - 受信電文オブジェクト(フレームワーク制御ヘッダに相当するデータが抜き出し済みであること)

---

## メソッドの詳細

### reply

```java
public ResponseMessage reply()
                      throws UnsupportedOperationException
```

この電文に対する応答電文({@link ResponseMessage})オブジェクトを作成する。
<p/>
{@link RequestMessage#setFormatter}で応答電文のフォーマットが指定されている場合はそれを設定する。
指定がなければ、{@link InterSystemMessage#getFormatter}を実行し、電文共通のフォーマットを取得して設定する。
<p/>
応答電文オブジェクトの生成については、{@link #createResponseMessage}を参照。

**戻り値:**
返信用電文オブジェクト

**例外:**
- `MessagingException` - この電文にReplyToヘッダが指定されていない場合。

---

### createResponseMessage

```java
protected ResponseMessage createResponseMessage()
```

応答電文オブジェクトを作成する。
<p/>
この実装では、応答電文オブジェクトのヘッダの設定は
{@link ResponseMessage#ResponseMessage(RequestMessage)}にて行われる。
<p/>
デフォルト以外の応答電文クラスを使用する場合はサブクラスで本メソッドをオーバーライドすること。

**戻り値:**
応答電文オブジェクト

---

### getRequestPath

```java
public String getRequestPath()
```

{@inheritDoc}

**例外:**
- `IllegalArgumentException` - {@code requestPath}が{@code null}か空文字である場合

---

### setRequestPath

```java
public RequestMessage setRequestPath(String requestPath)
```

{@inheritDoc}

---

### getFwHeader

```java
public FwHeader getFwHeader()
```

フレームワーク制御ヘッダの内容を返す。

**戻り値:**
フレームワーク制御ヘッダ部の内容

---

### setFormatterOfReply

```java
public RequestMessage setFormatterOfReply(DataRecordFormatter formatter)
```

応答電文のフォーマットを指定する。

**パラメータ:**
- `formatter` - 応答電文のフォーマット

**戻り値:**
このオブジェクト自体

---
