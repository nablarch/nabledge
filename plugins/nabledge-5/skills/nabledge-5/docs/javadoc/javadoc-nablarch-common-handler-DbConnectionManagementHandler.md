# class DbConnectionManagementHandler

**パッケージ:** nablarch.common.handler

**実装されたインタフェース:**
- Handler<Object,Object>
- InboundHandleable
- OutboundHandleable

---

```java
public class DbConnectionManagementHandler
implements Handler<Object,Object>, InboundHandleable, OutboundHandleable
```

後続ハンドラの処理で必要となる、データベース接続オブジェクトを
スレッドローカル変数上で管理するハンドラ。
<pre>
デフォルトの設定では、トランザクションが暗黙的に使用する接続名
({@link TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY})
に対して接続オブジェクトを登録する。
接続名を明示的に指定する場合は、属性dbConnectionNameにその値を設定する。<br/>
&lt;!-- 設定例 --&gt;
&lt;component class="nablarch.common.handler.DbConnectionManagementHandler"&gt;
     &lt;!-- DbConnectionFactory --&gt;
     &lt;property name="dbConnectionFactory" ref="dbConnectionFactory"/&gt;
     &lt;!-- 追加するデータベース接続オブジェクトの名称 --&gt;
     &lt;property name="dbConnectionName" value="db"/&gt;
&lt;/component&gt;
</pre>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### connectionFactory

```java
private ConnectionFactory connectionFactory
```

データベース接続オブジェクトを取得するためのファクトリ

---

### connectionName

```java
private String connectionName
```

このハンドラが生成するコネクションの登録名

---

### LOGGER

```java
private static final Logger LOGGER
```

Logger

---

## メソッドの詳細

### setConnectionFactory

```java
public DbConnectionManagementHandler setConnectionFactory(ConnectionFactory connectionFactory)
```

データベース接続オブジェクトを生成するためのファクトリを設定する。

**パラメータ:**
- `connectionFactory` - データベース接続オブジェクトを生成するためのファクトリ

**戻り値:**
このハンドラ自体

---

### setConnectionName

```java
public void setConnectionName(String connectionName)
```

データベース接続のスレッドコンテキスト上の登録名を設定する。
<pre>
デフォルトでは既定のトランザクション名
({@link TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY})を使用する。
</pre>

**パラメータ:**
- `connectionName` - データベース接続のスレッドコンテキスト上の登録名

---

### handle

```java
public Object handle(Object inputData, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
このクラスの実装では後続ハンドラに対する処理委譲の前後に、
データベース接続オブジェクトの初期化と終了の処理をそれぞれ行う。
</pre>

---

### before

```java
public void before()
```

往路処理を行う。
<p/>
{@link ConnectionFactory}から{@link TransactionManagerConnection}を取得し、
{@link DbConnectionContext}に設定する。

---

### after

```java
public void after()
```

復路処理を行う。

<p>
{@link DbConnectionContext}からデータベース接続を削除し、リソースの開放処理を行う。

---

### writeWarnLog

```java
private static void writeWarnLog(Throwable throwable)
```

ワーニングログの出力を行う。
<br/>

**パラメータ:**
- `throwable` - ログに出力する例外

---

### handleInbound

```java
public Result handleInbound(ExecutionContext context)
```

---

### handleOutbound

```java
public Result handleOutbound(ExecutionContext context)
```

---
