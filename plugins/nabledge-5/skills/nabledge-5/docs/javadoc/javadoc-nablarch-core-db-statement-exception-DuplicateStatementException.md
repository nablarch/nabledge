# class DuplicateStatementException

**パッケージ:** nablarch.core.db.statement.exception

**継承階層:**
```
java.lang.Object
  └─ SqlStatementException
      └─ nablarch.core.db.statement.exception.DuplicateStatementException
```

---

```java
public class DuplicateStatementException
extends SqlStatementException
```

一意制約違反時に発生する例外クラス。

**作成者:** Hisaaki Sioiri  

---

## コンストラクタの詳細

### DuplicateStatementException

```java
public DuplicateStatementException(String message, SQLException e)
```

{@link SQLException}をラップした{@link DuplicateStatementException}を生成する。

**パラメータ:**
- `message` - エラーメッセージ
- `e` - SQLException

---
