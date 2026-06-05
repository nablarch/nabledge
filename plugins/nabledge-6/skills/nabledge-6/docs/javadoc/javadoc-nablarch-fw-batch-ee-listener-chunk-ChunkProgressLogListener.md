# class ChunkProgressLogListener

**パッケージ:** nablarch.fw.batch.ee.listener.chunk

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchItemWriteListener
      └─ nablarch.fw.batch.ee.listener.chunk.ChunkProgressLogListener
```

---

```java
public class ChunkProgressLogListener
extends AbstractNablarchItemWriteListener
```

chunkの進捗ログを出力するリスナークラス。

**非推奨:** chunkの進捗ログを出力するリスナは、
{@link nablarch.fw.batch.ee.progress.ProgressLogListener}に置き換わりました。  
**作成者:** Shohei Ukawa  

---

## メソッドの詳細

### afterWrite

```java
public void afterWrite(NablarchListenerContext context, List<Object> items)
```

chunkの進捗ログを出力する。

---
