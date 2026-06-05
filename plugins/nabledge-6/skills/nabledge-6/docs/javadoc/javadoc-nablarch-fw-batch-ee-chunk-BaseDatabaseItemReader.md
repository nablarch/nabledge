# class BaseDatabaseItemReader

**パッケージ:** nablarch.fw.batch.ee.chunk

**継承階層:**
```
java.lang.Object
  └─ AbstractItemReader
      └─ nablarch.fw.batch.ee.chunk.BaseDatabaseItemReader
```

---

```java
public abstract class BaseDatabaseItemReader
extends AbstractItemReader
```

データベースを入力とする{@link jakarta.batch.api.chunk.ItemReader}の抽象クラス。
<p/>
本リーダを継承することで、リーダ専用のコネクションを使用してデータを読み込むことができる。
<p/>
DB製品によっては、トランザクション制御時にカーソルが閉じられてしまうため、リーダ専用のコネクションを使用して読み込みを行っている。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### connection

```java
private TransactionManagerConnection connection
```

リーダ専用のコネクション

---

## メソッドの詳細

### open

```java
public final void open(Serializable checkpoint)
          throws Exception
```

---

### close

```java
public final void close()
           throws Exception
```

---

### doOpen

```java
protected abstract void doOpen(Serializable checkpoint)
            throws Exception
```

データベースからのデータ読み込みを行う。

**パラメータ:**
- `checkpoint` - チェックポイント

**例外:**
- `Exception` - 発生した例外

---

### doClose

```java
protected void doClose()
             throws Exception
```

リーダの終了処理（リソースの解放など）を行う。

**例外:**
- `Exception` - 発生した例外

---
