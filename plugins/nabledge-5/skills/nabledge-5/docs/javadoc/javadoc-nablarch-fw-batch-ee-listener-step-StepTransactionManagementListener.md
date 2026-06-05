# class StepTransactionManagementListener

**パッケージ:** nablarch.fw.batch.ee.listener.step

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchStepListener
      └─ nablarch.fw.batch.ee.listener.step.StepTransactionManagementListener
```

---

```java
public class StepTransactionManagementListener
extends AbstractNablarchStepListener
```

Stepレベルのトランザクション制御を行う{@link NablarchStepListener}実装クラス。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### transactionFactory

```java
private TransactionFactory transactionFactory
```

トランザクションファクトリ

---

### transactionName

```java
private String transactionName
```

トランザクション名

---

## メソッドの詳細

### setTransactionFactory

```java
public void setTransactionFactory(TransactionFactory transactionFactory)
```

トランザクションファクトリを設定する。

**パラメータ:**
- `transactionFactory` - トランザクションファクトリ

---

### setTransactionName

```java
public void setTransactionName(String transactionName)
```

トランザクション名

**パラメータ:**
- `transactionName` - トランザクション名

---

### beforeStep

```java
public void beforeStep(NablarchListenerContext context)
```

新しいトランザクションを生成し、コンテキストに設定する。

---

### afterStep

```java
public void afterStep(NablarchListenerContext context)
```

トランザクションを終了しコンテキストから削除する。
<p/>
ステップの実行に失敗した場合({@link javax.batch.runtime.context.StepContext#getException()}が設定されている場合や
{@link javax.batch.runtime.context.JobContext#getBatchStatus()}が{@link BatchStatus#FAILED}の場合)には、
トランザクションをロールバックする。

---

### isStepCompleted

```java
protected boolean isStepCompleted(NablarchListenerContext context)
```

ステップの処理が完了しているか否か。

**パラメータ:**
- `context` - {@link NablarchListenerContext}

**戻り値:**
正常に完了している場合は{@code true}

---
