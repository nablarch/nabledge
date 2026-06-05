# class ThreadContextClearHandler

**パッケージ:** nablarch.common.handler.threadcontext

**実装されたインタフェース:**
- Handler<Object,Object>
- InboundHandleable
- OutboundHandleable

---

```java
public class ThreadContextClearHandler
implements Handler<Object,Object>, InboundHandleable, OutboundHandleable
```

{@link ThreadContextHandler}で設定した{@link nablarch.core.ThreadContext}上の値をクリアするハンドラ。
<p>
このハンドラより手前では、復路処理でも{@link ThreadContext}にアクセスすることはできない。
このため、極力先頭に設定する必要がある。

**作成者:** siosio  

---

## メソッドの詳細

### handle

```java
public Object handle(Object o, ExecutionContext context)
```

---

### handleInbound

```java
public Result handleInbound(ExecutionContext context)
```

---

### handleOutbound

```java
public Result handleOutbound(ExecutionContext context)
```

---
