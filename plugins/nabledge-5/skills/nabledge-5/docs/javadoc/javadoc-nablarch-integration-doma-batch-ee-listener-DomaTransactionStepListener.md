# class DomaTransactionStepListener

**パッケージ:** nablarch.integration.doma.batch.ee.listener

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchStepListener
      └─ nablarch.integration.doma.batch.ee.listener.DomaTransactionStepListener
```

---

```java
public class DomaTransactionStepListener
extends AbstractNablarchStepListener
```

ステップレベルで、Domaのトランザクション制御を行う{@link NablarchStepListener}の実装クラス。
<p>
ステップ開始時にトランザクションを開始し、ステップ終了時に正常終了していれば{@link LocalTransaction#commit()}、
そうでなければ、{@link LocalTransaction#rollback()}を呼び出す。

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

### beforeStep

```java
public void beforeStep(NablarchListenerContext context)
```

---

### afterStep

```java
public void afterStep(NablarchListenerContext context)
```

---

### removeNablarchConnection

```java
private void removeNablarchConnection()
```

nablarch用のデータベース接続の破棄処理を行う。

---

### setConnectionFactory

```java
public void setConnectionFactory(ConnectionFactoryFromDomaConnection connectionFactory)
```

コネクションファクトリを設定する。

**パラメータ:**
- `connectionFactory` - コネクションファクトリ

---
