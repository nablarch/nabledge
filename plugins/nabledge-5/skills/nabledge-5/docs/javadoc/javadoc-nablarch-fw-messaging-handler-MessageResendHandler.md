# class MessageResendHandler

**パッケージ:** nablarch.fw.messaging.handler

**実装されたインタフェース:**
- Handler<RequestMessage,ResponseMessage>

---

```java
public class MessageResendHandler
implements Handler<RequestMessage,ResponseMessage>
```

応答電文の再送処理制御を行うハンドラ。
<p/>
一般に、外部システムに対する要求電文がタイムアウトした場合、その補償電文として
再送要求電文、もしくは、取り消し電文を送信することになる。
本ハンドラでは、このうち再送要求電文に対する制御をフレームワークレベルで実装している。
<p/>
※ 本機能では、初回電文/再送要求電文の判定をフレームワーク制御ヘッダ中の
   再送要求フラグの値を用いて行う。
   このため、フレームワーク制御ヘッダが定義されていない電文に対しては
   再送制御を行うことができない。

<div><b>再送制御</b></div>
<hr/>
本システムに対する処理要求メッセージ(初回電文)が、転送経路上のネットワークエラーや
遅延により外部システム側でタイムアウトし、その補償電文として再送要求電文が送信されたとする。
この際、再送要求電文を受信した時点でのシステムの状態は、以下の4つに分類できる。

<pre>
1. ネットワークエラーもしくは遅延により、初回電文が未受信。
2. 初回電文を処理中。
3. 初回電文に対する業務処理は正常終了(トランザクションをコミット)したが、
   ネットワークエラーもしくは遅延により応答電文が未達。
4. 初回電文に対する業務処理が異常終了(トランザクションをロールバック)し、
   ネットワークエラーもしくは遅延によりエラー応答電文が未達。
</pre>

それぞれのケースについて、本システムの挙動は以下のようになる。

<pre>
1. 初回電文が未受信
   再送要求電文を初回電文として処理する。
   この場合、再送要求電文を処理中に、遅延していた初回電文を並行実行する可能性があるが
   先にコミットされたトランザクションのみ正常終了し、それ以外はロールバックする。
   また、ロールバックされた要求の応答として、先に正常終了した電文の応答を再送する。

2. 本システムで初回電文を処理中
   再送要求電文も初回電文として処理し、先に完了したトランザクションをコミットし、
   もう一方をロールバックする。
   (1.と同じ扱い。)

3. 業務処理は正常終了したが応答電文が未達
   再送用電文テーブルから当該メッセージIDの電文データを取得し、応答電文として送信する。
   業務処理は実行されない。

4. 業務処理が正常終了したがエラー応答電文が未達
   再送要求電文を初回電文として処理する。
</pre>

本機能は大きく以下の2つの機能によって構成されている。

<pre>
再送応答機能:
   接続先システムから再送要求電文が送信された場合に、
   後述の送信済電文保存機能が保持する過去の応答電文の内容を再送信する機能。

送信済電文保存機能:
   ローカルキューに対するPUT命令が完了したメッセージの内容をデータベース上の
   送信済電文テーブルに保存する機能。
   送信済み電文の内容は業務トランザクションとともにコミットされる。
   従って、業務処理がエラー終了した場合には再送用電文は残らない。

   再送電文管理テーブルのスキーマ構造については {@link SentMessageTableSchema}
   を参照すること。
</pre>

**関連項目:** SentMessageTableSchema  
**関連項目:** FwHeader#isResendingRequest()  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### schema

```java
private SentMessageTableSchema schema
```

再送電文管理テーブルスキーマ定義

---

### findAlreadySentMessageQuery

```java
private String findAlreadySentMessageQuery
```

再送対象の電文を検索する際に使用するSQLクエリー

---

### insertNewSentMessageDml

```java
private String insertNewSentMessageDml
```

再送電文管理テーブルに送信電文を新規登録するSQL文

---

### fwHeaderDefinition

```java
private FwHeaderDefinition fwHeaderDefinition
```

応答電文中のフレームワークヘッダ定義

---

## コンストラクタの詳細

### MessageResendHandler

```java
public MessageResendHandler()
```

デフォルトコンストラクタ。

---

## メソッドの詳細

### initialize

```java
public synchronized void initialize()
```

本ハンドラで使用するSQL文を構築する。

---

### handle

```java
public ResponseMessage handle(RequestMessage request, ExecutionContext context)
```

{@inheritDoc}
本ハンドラの実装では、再送電文管理テーブルを確認し、当該の受信電文に対する
応答電文が登録されているかどうかを確認する。
応答電文が登録されていればそれを返却する。
登録されていない場合は、要求電文を初回電文として処理し、その応答電文を返す。

---

### saveReply

```java
public void saveReply(RequestMessage request, ResponseMessage response)
```

応答電文を再送電文テーブルに格納する。

**パラメータ:**
- `request` - 要求電文オブジェクト
- `response` - 応答電文オブジェクト

---

### insertNewSentMessage

```java
public void insertNewSentMessage(Map<String,Object> values)
```

再送電文管理テーブルに送信電文を新規登録する。

**パラメータ:**
- `values` - 登録するレコード

---

### getAlreadySentReply

```java
public ResponseMessage getAlreadySentReply(RequestMessage request)
```

再送電文テーブルの内容を確認し、メッセージIDが一致する電文があれば
その内容をもとに応答電文を作成して返す
該当する電文が存在しなければnullを返す。

**パラメータ:**
- `request` - 要求電文オブジェクト

**戻り値:**
再送用応答電文オブジェクト。
         メッセージIDが一致するものが存在しない場合はnull

---

### findAlreadySentMessage

```java
public SqlRow findAlreadySentMessage(String messageId, String requestId)
```

再送対象の電文レコードを検索し、当該の電文のレコードを返却する。
レコードが存在しなかった場合はnullを返却する。

**パラメータ:**
- `messageId` - 初回電文のメッセージID (=再送要求電文の関連ID)
- `requestId` - 要求電文のリクエストID

**戻り値:**
当該電文のレコード

---

### setSentMessageTableSchema

```java
public MessageResendHandler setSentMessageTableSchema(SentMessageTableSchema schema)
```

再送電文管理テーブルのスキーマ定義を設定する。

**パラメータ:**
- `schema` - スキーマ定義

**戻り値:**
このオブジェクト自体

---

### setFwHeaderDefinition

```java
public MessageResendHandler setFwHeaderDefinition(FwHeaderDefinition def)
```

応答電文中のフレームワーク制御ヘッダ定義を設定する。

**パラメータ:**
- `def` - フレームワーク制御ヘッダ定義

**戻り値:**
このオブジェクト自体

---
