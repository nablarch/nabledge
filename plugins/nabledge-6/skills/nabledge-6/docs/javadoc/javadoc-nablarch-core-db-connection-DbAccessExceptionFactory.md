# interface DbAccessExceptionFactory

**パッケージ:** nablarch.core.db.connection

---

```java
public interface DbAccessExceptionFactory
```

SQL文実行時例外の内容に応じて、{@link DbAccessException}を生成するインタフェース。
<p/>
実装クラスでは{@link SQLException}の内容を元に、{@link DbAccessException}を生成すること。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### createDbAccessException

```java
DbAccessException createDbAccessException(String message, SQLException cause, TransactionManagerConnection connection)
```

発生したSQL実行時例外の内容に応じた{@link DbAccessException}を生成する。

**パラメータ:**
- `message` - エラーメッセージ
- `cause` - 発生した{@link SQLException}
- `connection` - 例外発生時のデータベース接続

**戻り値:**
発生したSQL実行時例外の内容に応じた{@link DbAccessException}

---
