# class DbConnectionException

**パッケージ:** nablarch.core.db.connection.exception

**継承階層:**
```
java.lang.Object
  └─ DbAccessException
      └─ nablarch.core.db.connection.exception.DbConnectionException
```

**実装されたインタフェース:**
- Retryable

---

```java
public class DbConnectionException
extends DbAccessException
implements Retryable
```

データベース接続に関する問題が発生した場合に送出される例外。

**作成者:** Kiyohito Itoh  

---

## コンストラクタの詳細

### DbConnectionException

```java
public DbConnectionException(String message, SQLException e)
```

DbConnectionExceptionを生成する。

**パラメータ:**
- `message` - エラーメッセージ
- `e` - SQL例外

---
