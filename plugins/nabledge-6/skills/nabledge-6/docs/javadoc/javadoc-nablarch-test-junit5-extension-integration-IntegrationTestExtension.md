# class IntegrationTestExtension

**パッケージ:** nablarch.test.junit5.extension.integration

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcherExtension
      └─ nablarch.test.junit5.extension.integration.IntegrationTestExtension
```

---

```java
public class IntegrationTestExtension
extends TestEventDispatcherExtension
```

{@link IntegrationTestSupport} を JUnit 5 で使用するための Extension 実装。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### createSupport

```java
protected TestEventDispatcher createSupport(Object testInstance, ExtensionContext context)
```

---

### beforeEach

```java
public void beforeEach(ExtensionContext context)
                throws Exception
```

---
