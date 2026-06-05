# class ItemWriteTransactionManagementListener

**パッケージ:** nablarch.fw.batch.ee.listener.chunk

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchItemWriteListener
      └─ nablarch.fw.batch.ee.listener.chunk.ItemWriteTransactionManagementListener
```

---

```java
public class ItemWriteTransactionManagementListener
extends AbstractNablarchItemWriteListener
```

{@link jakarta.batch.api.chunk.listener.ItemWriteListener}レベルでトランザクション制御を行う{@link NablarchItemWriteListener}の実装クラス。
<p/>
{@link TransactionContext}から{@link Transaction}を取得しトランザクション制御を行う。
{@link Transaction}は、前段のリスナーにて{@link TransactionContext}に設定しておく必要がある。
{@link #setTransactionName(String)}で設定するトランザクション名は、前段のリスナーで設定したトランザクション名と一致させる必要がある。
複数のトランザクションを設定する必要がないのであれば、デフォルトのトランザクション名を使用することを推奨する。
(デフォルトのトランザクション名は、設定不要の場合に自動的に選択される。)
<p/>
{@link jakarta.batch.api.chunk.ItemWriter}が正常に終了した場合には、トランザクションの確定({@link Transaction#commit()})を実行し、
{@link jakarta.batch.api.chunk.ItemWriter}で{@link Exception}が発生した場合には、トランザクションの破棄({@link Transaction#rollback()}を行う。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### transactionName

```java
private String transactionName
```

トランザクション名

---

## メソッドの詳細

### setTransactionName

```java
public void setTransactionName(String transactionName)
```

トランザクション名を設定する。

**パラメータ:**
- `transactionName` - トランザクション名

---

### afterWrite

```java
public void afterWrite(NablarchListenerContext context, List<Object> items)
```

トランザクションを確定(commit)する。

---

### onWriteError

```java
public void onWriteError(NablarchListenerContext context, List<Object> items, Exception ex)
```

トランザクションを破棄(rollback)する。

---
