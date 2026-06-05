# interface TransactionFactory

**パッケージ:** nablarch.core.transaction

---

```java
public interface TransactionFactory
```

トランザクション制御オブジェクト({@link Transaction})を生成するインタフェース。。

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### getTransaction

```java
Transaction getTransaction(String resourceName)
```

トランザクションオブジェクトを生成する。

**パラメータ:**
- `resourceName` - リソース名

**戻り値:**
トランザクションオブジェクト

---
