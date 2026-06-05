# interface LogListener

**パッケージ:** nablarch.core.log.basic

---

```java
public interface LogListener
```

{@link LogPublisher}によって公開された{@link LogContext}を受け取るインタフェース。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### onWritten

```java
void onWritten(LogContext context)
```

公開された{@link LogContext}を受け取る。

**パラメータ:**
- `context` - {@link LogContext}

---
