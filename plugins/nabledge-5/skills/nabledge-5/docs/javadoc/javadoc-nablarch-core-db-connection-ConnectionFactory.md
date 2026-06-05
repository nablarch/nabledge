# interface ConnectionFactory

**パッケージ:** nablarch.core.db.connection

---

```java
public interface ConnectionFactory
```

データベース接続({@link TransactionManagerConnection})を生成するインタフェース。

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### getConnection

```java
TransactionManagerConnection getConnection(String connectionName)
```

データベース接続を取得する。

**パラメータ:**
- `connectionName` - コネクション名

**戻り値:**
データベース接続オブジェクト

---
