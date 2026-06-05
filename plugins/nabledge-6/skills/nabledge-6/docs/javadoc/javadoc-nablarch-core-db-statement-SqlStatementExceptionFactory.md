# interface SqlStatementExceptionFactory

**パッケージ:** nablarch.core.db.statement

---

```java
public interface SqlStatementExceptionFactory
```

{@link SqlStatementException}を生成するインタフェース。<br>
SQLのエラー内容({@link java.sql.SQLException#getSQLState()}や{@link java.sql.SQLException#getErrorCode()}の結果)に応じて、
生成する{@link SqlStatementException}を切り替える場合には、具象クラスで生成するExceptionの切り替えを行う。

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### createSqlStatementException

```java
SqlStatementException createSqlStatementException(String msg, SQLException e, DbExecutionContext context)
```

{@link nablarch.core.db.statement.exception.SqlStatementException}を生成し返却する。

**パラメータ:**
- `msg` - メッセージ
- `e` - SQLException
- `context` - DBアクセス実行コンテキスト

**戻り値:**
生成したSqlStatementException

---
