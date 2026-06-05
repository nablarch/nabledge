# class DuplicateJobRunningCheckListener

**パッケージ:** nablarch.fw.batch.ee.listener.job

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchJobListener
      └─ nablarch.fw.batch.ee.listener.job.DuplicateJobRunningCheckListener
```

---

```java
public class DuplicateJobRunningCheckListener
extends AbstractNablarchJobListener
```

同一ジョブが同時に複数実行されないことを保証するための{@link NablarchJobListener}実装クラス。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### EXIT_STATUS

```java
private static final String EXIT_STATUS
```

複数起動時の場合に設定する終了ステータス

---

### duplicateProcessChecker

```java
private DuplicateProcessChecker duplicateProcessChecker
```

多重起動チェックを行うクラス。

---

## メソッドの詳細

### setDuplicateProcessChecker

```java
public void setDuplicateProcessChecker(DuplicateProcessChecker duplicateProcessChecker)
```

多重起動チェックするクラスを設定する。

**パラメータ:**
- `duplicateProcessChecker` - 多重起動をチェックするクラス

---

### beforeJob

```java
public void beforeJob(NablarchListenerContext context)
```

プロセス(JOB)の多重起動防止チェックを行う。
<p/>
多重起動ではない場合、現在のジョブをアクティブ状態に変更する。

---

### afterJob

```java
public void afterJob(NablarchListenerContext context)
```

プロセス(JOB)の非活性化を行う。

---
