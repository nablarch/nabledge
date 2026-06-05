# class InterSystemMessage

**パッケージ:** nablarch.fw.messaging

---

```java
public abstract class InterSystemMessage
```

外部システムに対する送受信電文の内容を格納するデータオブジェクト。

このオブジェクトは以下のデータを保持する。
<ul>
<li> プロトコルヘッダー
<li> メッセージボディ
</ul>

<h4>プロトコルヘッダー</h4>
<p>
プロトコルヘッダーはMOM間のメッセージ転送制御に関連する制御情報であり、
MOM側で自動的に解析される。
これらの情報の多くは、MOM製品に依存した仕様であるため、本フレームワークは
プロトコルヘッダーに極力依存しない設計となっている。
</p>
本フレームワークが直接使用するプロトコルヘッダーは以下の5つのみである。
<ul>
<li> メッセージIDヘッダ
<li> 関連メッセージIDヘッダ
<li> 送信宛先ヘッダ
<li> 応答宛先ヘッダ
<li> メッセージ有効期間ヘッダ (送信電文のみ)
</ul>

<h4>メッセージボディ</h4>
<p>
プロトコルヘッダーを除いた電文のデータ部をメッセージボディと呼ぶ。
メッセージボディ部は、MOM側では単にバイナリデータとして扱うものとし、
解析は全てフレームワーク側で行う。
</p>
<p>
メッセージボディのフォーマットは nablarch.core.dataformat パッケージが提供する
機能を用いて定義する。解析後の電文はList-Map形式でアクセスすることが可能である。
</p>
メッセージボディ内は通常、以下に示すような階層構造をもち、その解析は各階層に
対応したデータリーダもしくはハンドラによって段階的に行われる。
<ul>
<li> フレームワーク制御ヘッダ
<li> 業務共通ヘッダ
<li> 業務データ
</ul>
なお、メッセージボディの階層化はデータリーダやハンドラの構成を含め、フレームワークの
全体構造に関わる重要な要素なので、可能な限り早い段階で確定させておく必要がある。

<h4>クラス構成</h4>
<p>
このクラスは各電文クラスに共通する機能やデータ構造を実装するものの、
直接インスタンスを作成することはできない。
これは、JMSのjavax.jms.Messageのような汎用メッセージオブジェクトを使いまわすのではなく、
その用途に応じて以下の4つの具象クラスを使いわける設計となっているためである。
<p>
<ol>
<li> ReceivedMessage (受信メッセージ)
<li> SendingMessage  (送信メッセージ)
<li> RequestMessage  (被仕向け要求受信メッセージ) : ReceivedMessageのサブクラス
<li> ResponseMessage (応答送信メッセージ) : SendingMessageのサブクラス
</ol>

**param:** 各具象クラスの型  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### headers

```java
private final Map<String,Object> headers
```

メッセージヘッダ情報を格納するMap

---

### bodyData

```java
private final List<DataRecord> bodyData
```

メッセージボディデータ

---

### formatter

```java
private DataRecordFormatter formatter
```

メッセージボディのフォーマッター

---

## コンストラクタの詳細

### InterSystemMessage

```java
public InterSystemMessage()
```

デフォルトコンストラクタ

---

### InterSystemMessage

```java
public InterSystemMessage(InterSystemMessage<?> orgMessage)
```

コピーコンストラクタ

**パラメータ:**
- `orgMessage` - コピー元電文

---

## メソッドの詳細

### setFormatter

```java
public TSelf setFormatter(DataRecordFormatter formatter)
```

メッセージボディのフォーマット定義を設定する。

**パラメータ:**
- `formatter` - フォーマット定義オブジェクト

**戻り値:**
このオブジェクト自体

---

### getFormatter

```java
public DataRecordFormatter getFormatter()
```

メッセージボディのフォーマット定義を返す。

**戻り値:**
メッセージボディのフォーマット定義

---

### getRecordOf

```java
public DataRecord getRecordOf(String recordType)
```

指定された種別のレコードを返す。
複数存在する場合は、その先頭のレコードを返す。
存在しない場合はnullを返す。

**パラメータ:**
- `recordType` - レコード名

**戻り値:**
指定した種別のデータレコード (存在しない場合はnull)

---

### getRecords

```java
public List<DataRecord> getRecords()
```

メッセージボディに含まれる全レコードを返す。

**戻り値:**
メッセージボディに含まれる全てのレコード

---

### getRecordsOf

```java
public List<DataRecord> getRecordsOf(String recordType)
```

メッセージボディに含まれる指定された種別の全レコードを返す。
該当するレコードが存在しない場合は空のリストを返す。

**パラメータ:**
- `recordType` - レコード種別

**戻り値:**
メッセージボディに含まれる指定された種別の全レコード

---

### getParamMap

```java
public Map<String,Object> getParamMap()
```

電文のデータ部の末尾レコードを返す。
<p/>
主にシングルレコード形式の電文で使用することを想定している。
レコードが存在しない場合はnullを返す。

**戻り値:**
受信電文内の各フィールドの値を格納したMap

---

### getParam

```java
public Object getParam(String name)
```

電文のデータ部の末尾レコードの中から指定されたフィールドの値を取得して返す。
<p/>
主にシングルレコード形式の電文で使用することを想定している。
レコードが存在しない場合、もしくは、レコードに指定された項目が存在しない
場合はnullを返す。
。

**パラメータ:**
- `name` - 取得するフィールドの名称

**戻り値:**
フィールドの値

---

### getBodyBytes

```java
public abstract byte[] getBodyBytes()
```

メッセーボディのバイナリ表現を返す。

送信(仕向)電文の場合はデータレコードをレコードフォーマッタで直列化したものを返す。
受信(被仕向)電文の場合はパース前の送信電文の内容をそのまま返す。

**戻り値:**
メッセーボディのバイナリ表現

---

### getHeaderMap

```java
public Map<String,Object> getHeaderMap()
```

ヘッダーの一覧をMap形式で返す。

**戻り値:**
ヘッダーの一覧

---

### getHeader

```java
public T getHeader(String headerName)
```

ヘッダーの値を返す。

**パラメータ:**
- `<T>` - 期待するヘッダの型
- `headerName` - 値を取得するヘッダーの名前

**戻り値:**
ヘッダーの値

---

### setHeader

```java
public TSelf setHeader(String name, Object value)
```

ヘッダーの値を設定する。

**パラメータ:**
- `name` - 値を設定するヘッダーの名前
- `value` - ヘッダーの値

**戻り値:**
このオブジェクト自体

---

### setHeaderMap

```java
public TSelf setHeaderMap(Map<String,?> headers)
```

ヘッダーの一覧を設定する。
(既存のヘッダーは全て削除される。)

**パラメータ:**
- `headers` - ヘッダーの一覧

**戻り値:**
このオブジェクト自体

---

### getMessageId

```java
public String getMessageId()
```

この電文に割り当てられた識別子(メッセージID)を返す。

メッセージIDは電文送信時にMOMによって自動的に割り振られるため、
書式や一意性の範囲は製品依存となる。
また、送信前の電文にはnullが設定されている。

**戻り値:**
この電文のID文字列 (送信前はnull)

---

### setMessageId

```java
public TSelf setMessageId(String messageId)
```

メッセージIDを設定する。

メッセージIDはMOM側で採番される値であり、
このメソッドは単体テスト用に便宜的に容易されているものである。

**パラメータ:**
- `messageId` - メッセージIDとして指定する文字列

**戻り値:**
このオブジェクト自体

---

### getDestination

```java
public String getDestination()
```

この電文の宛先キューの論理名を取得する。

MessagingContext.send(SendingMessage) メソッドでは、この戻り値に対応する
宛先に送信される。

**戻り値:**
宛先キューの論理名

---

### setDestination

```java
public TSelf setDestination(String destination)
```

送信宛先キューの論理名を設定する。

**パラメータ:**
- `destination` - 応答宛先キューの論理名

**戻り値:**
このオブジェクト自体

---

### getCorrelationId

```java
public String getCorrelationId()
```

この電文に関連付けられているメッセージのメッセージIDを返す。

**戻り値:**
この電文のID文字列

---

### setCorrelationId

```java
public TSelf setCorrelationId(String messageId)
```

この電文に既存のメッセージのIDを関連付ける。

**パラメータ:**
- `messageId` - 関連付けるメッセージのID

**戻り値:**
この電文のID文字列

---

### getReplyTo

```java
public String getReplyTo()
```

応答宛先キューの論理名を返す。

**戻り値:**
この電文のID文字列

---

### setReplyTo

```java
public TSelf setReplyTo(String replyTo)
```

この電文に対する応答宛先となるキューの論理名を設定する。

**パラメータ:**
- `replyTo` - 応答宛先キューの論理名

**戻り値:**
このオブジェクト自体

---
