# class AsyncMessageReceiveAction

**パッケージ:** nablarch.fw.messaging.action

**継承階層:**
```
java.lang.Object
  └─ BatchAction<RequestMessage>
      └─ nablarch.fw.messaging.action.AsyncMessageReceiveAction
```

---

```java
public class AsyncMessageReceiveAction
extends BatchAction<RequestMessage>
```

MQ応答なし受信用アクション。
<p/>
本クラスでは、受信したメッセージが保持するリクエストID({@link nablarch.fw.messaging.RequestMessage#getRequestPath()})を元に、
受信テーブルに電文を保存する。
<p/>
受信テーブルの構造は、必ず下記構造にすること。
<pre>
----------------- -----------------------------------------------------
受信電文連番       主キー
                  受信した電文(メッセージ)を一意に識別するためのIDを格納するカラム。
                  本カラムに設定する値は、#generateReceivedSequence()にて採番を行う。
                  カラムの桁数は、任意の桁数を設定可能となっている。
----------------- -----------------------------------------------------
業務電文部         業務電文を格納するカラムを定義する。
                  電文の種類に応じて、業務電文の各項目に対するカラムを定義すれば良い。
----------------- -----------------------------------------------------
共通項目部         各プロジェクトの方式に応じて必要なカラムを定義する。
                  たとえば、下記のカラムを定義することが想定される。
                  ・登録情報(ユーザID、タイムスタンプ、リクエストID、実行時ID)
                  ・更新情報(ユーザID、タイムスタンプ)
----------------- -----------------------------------------------------
</pre>
<p/>
本クラスは1電文を1レコードとして受信テーブルに保存する場合に利用できる。
1電文を複数レコードとして登録する場合や、複数テーブルに保存する場合は本クラスを継承し
#handle(nablarch.fw.messaging.RequestMessage, nablarch.fw.ExecutionContext)や
#insertMessageTable(String, Object)をオーバライドすること。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### ACTION_SETTINGS_KEY

```java
private static final String ACTION_SETTINGS_KEY
```

システムリポジトリ上の設定クラスの格納キー値

---

## メソッドの詳細

### handle

```java
public Result handle(RequestMessage inputData, ExecutionContext ctx)
```

{@inheritDoc}
<p/>
本処理では、メッセージキューから受信した電文オブジェクトを、{@link nablarch.fw.messaging.RequestMessage#getRequestPath()}
より取得したリクエストIDに対応する受信テーブルに格納する。
<p/>
リクエストIDに対応した受信テーブルに格納する際には、下記オブジェクトや定義が必要になるため、
リクエストID単位に作成する必要がある。
<p/>
<ol>
<li>リクエストIDに対応したFormクラス</li>
<li>受信電文INSERT用のSQL文</li>
<li></li>
</ol>

---

### createReader

```java
public DataReader<RequestMessage> createReader(ExecutionContext ctx)
```

{@inheritDoc}
本実装では、{@link DataReader}の生成は行わない。
このため、メッセージキューからメッセージをリードするための{@link DataReader}の設定は、
コンポーネント設定ファイル側に行う必要がある。

---

### insertMessageTable

```java
protected void insertMessageTable(String requestId, Object form)
```

業務用の受信テーブルに受信電文を登録する。

**パラメータ:**
- `requestId` - リクエストID
- `form` - 登録対象の電文を持ったオブジェクト

---

### createForm

```java
protected Object createForm(String requestId, RequestMessage message)
```

受信テーブルにINSERTを行うためのFormオブジェクトを生成する。
<p/>
生成するフォームクラスのクラス名は、パッケージ名:nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings#getFormClassPackage()
から取得したパッケージ名、クラス名:リクエストID + "Form"となる。
<p/>
また、Formクラスには下記引数を持つコンストラクタを定義し、受信メッセージの内容を保持すること。
<oi>
<li>受信電文連番:{@link String}</li>
<li>受信メッセージ:{@link RequestMessage}</li>
</oi>

**パラメータ:**
- `requestId` - リクエストID
- `message` - リクエストメッセージ

**戻り値:**
生成したFormオブジェクト

---

### generateReceivedSequence

```java
protected String generateReceivedSequence()
```

受信電文連番を採番する。
<p/>
受信電文連番採番時には、nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings#getReceivedSequenceFormatter()
で取得したフォーマッタを使用して、IDのフォーマットを行う。
採番対象を識別するためのIDは、nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings#getTargetGenerateId()より取得する

**戻り値:**
受信メッセージID

---

### getSettings

```java
protected AsyncMessageReceiveActionSettings getSettings()
```

本アクションを実行するために必要となる設定値を保持するオブジェクトを取得する。
<p/>
デフォルト動作では、リポジトリ({@link SystemRepository})から設定オブジェクトを取得する。

**戻り値:**
設定オブジェクト

---

### getSqlResource

```java
private String getSqlResource(String requestId)
```

電文を受信テーブルに登録するためのINSERT文を表すSQLリソースを取得する。
<p/>
SQLリソースは、「SQLリソース名」 + "#" + 「SQL_ID」形式となる。
<ol>
<li>SQLリソースは、「{@link AsyncMessageReceiveActionSettings#getSqlFilePackage()} + /<電文のリクエストID>」であること。</li>
<li>SQL_IDは、INSERT_MESSAGEであること</li>
</ol>

**パラメータ:**
- `requestId` - リクエストID

**戻り値:**
SQLリソース

---
