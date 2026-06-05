# class SqlStatementException

**パッケージ:** nablarch.core.db.statement.exception

**継承階層:**
```
java.lang.Object
  └─ DbAccessException
      └─ nablarch.core.db.statement.exception.SqlStatementException
```

---

```java
public class SqlStatementException
extends DbAccessException
```

SQL文実行時に発生する例外クラス。

**作成者:** Hisaaki Sioiri  

---

## コンストラクタの詳細

### SqlStatementException

```java
public SqlStatementException(String message, SQLException e)
```

{@code SqlStatementException}オブジェクトを生成する。

**パラメータ:**
- `message` - エラーメッセージ
- `e` - SQLException

---
