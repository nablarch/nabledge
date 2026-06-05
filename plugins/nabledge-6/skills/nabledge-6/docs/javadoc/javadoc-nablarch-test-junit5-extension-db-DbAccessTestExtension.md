# class DbAccessTestExtension

**パッケージ:** nablarch.test.junit5.extension.db

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcherExtension
      └─ nablarch.test.junit5.extension.db.DbAccessTestExtension
```

---

```java
public class DbAccessTestExtension
extends TestEventDispatcherExtension
```

{@link DbAccessTestSupport} を JUnit 5 で使用するための Extension 実装。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### createSupport

```java
protected DbAccessTestSupport createSupport(Object testInstance, ExtensionContext context)
```

---

### beforeEach

```java
public void beforeEach(ExtensionContext context)
                throws Exception
```

---

### afterEach

```java
public void afterEach(ExtensionContext context)
               throws Exception
```

---
