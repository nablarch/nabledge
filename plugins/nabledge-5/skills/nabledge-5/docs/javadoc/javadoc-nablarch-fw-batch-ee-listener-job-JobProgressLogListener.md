# class JobProgressLogListener

**パッケージ:** nablarch.fw.batch.ee.listener.job

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchJobListener
      └─ nablarch.fw.batch.ee.listener.job.JobProgressLogListener
```

---

```java
public class JobProgressLogListener
extends AbstractNablarchJobListener
```

JOBの進捗ログを出力するリスナークラス。<br>
JOB開始時と終了時にログを出力し、終了時にはステータスも併せて出力する。

**作成者:** Shohei Ukawa  

---

## メソッドの詳細

### beforeJob

```java
public void beforeJob(NablarchListenerContext context)
```

JOB開始のログを出力する。

---

### afterJob

```java
public void afterJob(NablarchListenerContext context)
```

JOB終了のログを出力する。

---
