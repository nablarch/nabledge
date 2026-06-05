# class StepProgressLogListener

**パッケージ:** nablarch.fw.batch.ee.listener.step

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchStepListener
      └─ nablarch.fw.batch.ee.listener.step.StepProgressLogListener
```

---

```java
public class StepProgressLogListener
extends AbstractNablarchStepListener
```

ステップの進捗ログを出力するクラス。<br>
ステップ開始時と終了時にログを出力する。

**作成者:** Shohei Ukawa  

---

## メソッドの詳細

### beforeStep

```java
public void beforeStep(NablarchListenerContext context)
```

ステップ開始のログを出力する。

---

### afterStep

```java
public void afterStep(NablarchListenerContext context)
```

ステップ終了のログを出力する。

---
