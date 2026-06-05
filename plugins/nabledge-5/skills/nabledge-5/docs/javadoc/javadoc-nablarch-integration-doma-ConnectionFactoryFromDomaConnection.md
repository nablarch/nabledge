# class ConnectionFactoryFromDomaConnection

**パッケージ:** nablarch.integration.doma

**継承階層:**
```
java.lang.Object
  └─ ConnectionFactorySupport
      └─ nablarch.integration.doma.ConnectionFactoryFromDomaConnection
```

---

```java
public class ConnectionFactoryFromDomaConnection
extends ConnectionFactorySupport
```

Domaで生成したデータベース接続をNablarch用の{@link TransactionManagerConnection}に変換するクラス。

**作成者:** siosio  

---

## メソッドの詳細

### getConnection

```java
public TransactionManagerConnection getConnection(String connectionName)
```

---
