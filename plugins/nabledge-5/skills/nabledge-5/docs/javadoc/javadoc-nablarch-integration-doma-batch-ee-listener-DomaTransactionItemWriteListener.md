# class DomaTransactionItemWriteListener

**パッケージ:** nablarch.integration.doma.batch.ee.listener

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchItemWriteListener
      └─ nablarch.integration.doma.batch.ee.listener.DomaTransactionItemWriteListener
```

---

```java
public class DomaTransactionItemWriteListener
extends AbstractNablarchItemWriteListener
```

{@link javax.batch.api.chunk.listener.ItemWriteListener}レベルでDomaのトランザクション制御を行う{@link NablarchItemWriteListener}の実装クラス。
<p>
前段に配置した{@link DomaTransactionStepListener}からDomaの{@link LocalTransaction}を取得し、トランザクション制御を行う。
<p>
{@link javax.batch.api.chunk.ItemWriter}が正常に終了した場合には、トランザクションの確定({@link LocalTransaction#commit()})を実行し、
その後に{@link LocalTransaction}を開始({@link LocalTransaction#begin()})する。
<br>
{@link javax.batch.api.chunk.ItemWriter}で{@link Exception}が発生した場合には、トランザクションの破棄({@link LocalTransaction#rollback()}を行う。

**作成者:** d-maeno  

---

## フィールドの詳細

### connectionFactory

```java
private ConnectionFactoryFromDomaConnection connectionFactory
```

コネクションファクトリ

---

## メソッドの詳細

### afterWrite

```java
public void afterWrite(NablarchListenerContext context, List<Object> items)
```

---

### onWriteError

```java
public void onWriteError(NablarchListenerContext context, List<Object> items, Exception ex)
```

---

### removeNablarchConnection

```java
private void removeNablarchConnection()
```

nablarch用のデータベース接続の破棄処理を行う。

---

### addConnectionToNablarch

```java
private void addConnectionToNablarch()
```

Nablarchのデータベースアクセスが利用出来るようにコネクションを{@link DbConnectionContext}の設定する。

---

### setConnectionFactory

```java
public void setConnectionFactory(ConnectionFactoryFromDomaConnection connectionFactory)
```

コネクションファクトリを設定する。

**パラメータ:**
- `connectionFactory` - コネクションファクトリ

---
