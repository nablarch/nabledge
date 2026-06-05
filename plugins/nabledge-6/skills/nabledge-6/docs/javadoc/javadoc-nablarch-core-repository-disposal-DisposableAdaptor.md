# class DisposableAdaptor

**パッケージ:** nablarch.core.repository.disposal

**実装されたインタフェース:**
- Disposable

---

```java
public class DisposableAdaptor
implements Disposable
```

{@link Closeable}オブジェクトを{@link Disposable}として扱うためのアダプタ。
<p>
Nablarch 5uXXはJava SE 6以上をサポートしているため、{@code AutoCloseable}(Java SE 7 で追加)ではなく
{@link Closeable}を対象としている。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### target

```java
private Closeable target
```

---

## メソッドの詳細

### dispose

```java
public void dispose()
             throws Exception
```

---

### setTarget

```java
public void setTarget(Closeable target)
```

廃棄処理対象を設定する。

**パラメータ:**
- `target` - 廃棄処理対象

---
