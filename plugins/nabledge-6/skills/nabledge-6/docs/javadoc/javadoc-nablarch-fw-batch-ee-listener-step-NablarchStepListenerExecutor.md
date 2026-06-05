# class NablarchStepListenerExecutor

**パッケージ:** nablarch.fw.batch.ee.listener.step

**実装されたインタフェース:**
- StepListener

---

```java
public class NablarchStepListenerExecutor
implements StepListener
```

{@link StepListener}を実装したクラスで、{@link NablarchStepListener}を順次実行するクラス。
<p/>
本クラスでは、{@link SystemRepository}から実行対象のリスナー({@link NablarchStepListener})のリストを取得する。
{@link SystemRepository}からリスナーリストを取得する方法は以下のとおり。
<ol>
<li>ジョブ名称 + ステップ名 + ".stepListeners"でリスナーリストが登録されている場合、そのリストを使用する。</li>
<li>ジョブ名称 + ".stepListeners"でリスナーリストが登録されている場合、そのリストを使用する。</li>
<li>stepListenersでリスナーリストが登録されている場合、そのリストを使用する。</li>
<li>上記に該当しない場合、このリスナーは何もしない。</li>
</ol>

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### LISTENER_LIST_NAME

```java
private static final String LISTENER_LIST_NAME
```

{@link SystemRepository}からリスナーリストを取得する際のコンポーネント名

---

### jobContext

```java
private JobContext jobContext
```

{@link JobContext }

---

### stepContext

```java
private StepContext stepContext
```

{@link StepContext}

---

### executor

```java
private NablarchListenerExecutor<NablarchStepListener> executor
```

{@link NablarchListenerExecutor}

---

## メソッドの詳細

### beforeStep

```java
public void beforeStep()
                throws Exception
```

{@link NablarchStepListener#beforeStep(NablarchListenerContext)}を順次実行する。

**例外:**
- `Exception` - {@link NablarchStepListener#beforeStep(NablarchListenerContext)}実行時に送出された例外

---

### afterStep

```java
public void afterStep()
               throws Exception
```

{@link NablarchStepListener#afterStep(NablarchListenerContext)}を逆順で実行する。

**例外:**
- `Exception` - {@link NablarchStepListener#afterStep(NablarchListenerContext)}実行時に送出された例外

---
