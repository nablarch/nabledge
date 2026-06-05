# class NablarchItemWriteListenerExecutor

**パッケージ:** nablarch.fw.batch.ee.listener.chunk

**実装されたインタフェース:**
- ItemWriteListener

---

```java
public class NablarchItemWriteListenerExecutor
implements ItemWriteListener
```

{@link ItemWriteListener}を実装したクラスで、{@link NablarchItemWriteListener}を順次実行するクラス。
<p/>
本クラスでは、{@link SystemRepository}から実行対象のリスナー({@link NablarchItemWriteListener})のリストを取得する。
{@link SystemRepository}からリスナーリストを取得する方法は以下のとおり。
<ol>
<li>ジョブ名称 + ステップ名 + ".itemWriteListeners"でリスナーリストが登録されている場合、そのリストを使用する。</li>
<li>ジョブ名称 + ".itemWriteListeners"でリスナーリストが登録されている場合、そのリストを使用する。</li>
<li>itemWriteListenersでリスナーリストが登録されている場合、そのリストを使用する。</li>
<li>上記に該当しない場合、このリスナーは何もしない。</li>
</ol>

**作成者:** Naoki Yamamoto  

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
private NablarchListenerExecutor<NablarchItemWriteListener> executor
```

{@link NablarchListenerExecutor}

---

## メソッドの詳細

### beforeWrite

```java
public void beforeWrite(List<Object> items)
                 throws Exception
```

{@link NablarchItemWriteListener#beforeWrite(NablarchListenerContext, List)}を順次実行する。

**パラメータ:**
- `items` - 書き込み処理対象の{@link Object}

**例外:**
- `Exception` - {@link NablarchItemWriteListener#beforeWrite(NablarchListenerContext, List)} 実行時に送出された例外

---

### afterWrite

```java
public void afterWrite(List<Object> items)
                throws Exception
```

{@link NablarchItemWriteListener#afterWrite(NablarchListenerContext, List)}を逆順で実行する。

**パラメータ:**
- `items` - 書き込み処理対象の{@link Object}

**例外:**
- `Exception` - {@link NablarchItemWriteListener#afterWrite(NablarchListenerContext, List)} 実行時に送出された例外

---

### onWriteError

```java
public void onWriteError(List<Object> items, Exception ex)
                  throws Exception
```

{@link NablarchItemWriteListener#onWriteError(NablarchListenerContext, List, Exception)} を逆順で実行する。

**パラメータ:**
- `items` - 書き込み処理対象の{@link Object}
- `ex` - 書き込み処理時に発生した{@link Exception}

**例外:**
- `Exception` - {@link NablarchItemWriteListener#onWriteError(NablarchListenerContext, List, Exception)} 実行時に送出された例外

---
