# class LogPublisher

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- LogWriter

---

```java
public class LogPublisher
implements LogWriter
```

書き出されたログを、登録された{@link LogListener}に公開する{@link LogWriter}の実装クラス。
<p>
{@link LogWriter}のインスタンスは外部から取得できないため、
公開対象の{@link LogListener}は{@code static}変数で保持している。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### LISTENERS

```java
private static final CopyOnWriteArrayList<LogListener> LISTENERS
```

ログの公開先となる{@link LogListener}のリスト。

---

## メソッドの詳細

### addListener

```java
public static void addListener(LogListener listener)
```

公開対象の{@link LogListener}を追加する。

**パラメータ:**
- `listener` - {@link LogListener}

---

### removeListener

```java
public static void removeListener(LogListener listener)
```

公開対象から指定した{@link LogListener}を削除する。

**パラメータ:**
- `listener` - {@link LogListener}

---

### removeAllListeners

```java
public static void removeAllListeners()
```

登録されているすべての{@link LogListener}を削除する。

---

### write

```java
public void write(LogContext context)
```

---

### initialize

```java
public void initialize(ObjectSettings settings)
```

---

### terminate

```java
public void terminate()
```

---
