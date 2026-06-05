# class ConnectionFactorySupport

**パッケージ:** nablarch.core.db.connection

**実装されたインタフェース:**
- ConnectionFactory

---

```java
public abstract class ConnectionFactorySupport
implements ConnectionFactory
```

{@link ConnectionFactory}の実装をサポートするクラス。
<p/>
本クラスは、実装クラスで必要となる{@link nablarch.core.db.statement.StatementFactory}とStatementキャッシュの設定値をもつ。

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### statementFactory

```java
protected StatementFactory statementFactory
```

---

### statementReuse

```java
protected boolean statementReuse
```

---

### dbAccessExceptionFactory

```java
protected DbAccessExceptionFactory dbAccessExceptionFactory
```

---

### dialect

```java
protected Dialect dialect
```

---

## メソッドの詳細

### setStatementFactory

```java
public void setStatementFactory(StatementFactory statementFactory)
```

{@link StatementFactory}実装クラスを設定する。<br>

**パラメータ:**
- `statementFactory` - ステートメントファクトリオブジェクト

---

### setStatementReuse

```java
public void setStatementReuse(boolean statementReuse)
```

ステートメントのキャッシュ有無を設定する。<br>

**パラメータ:**
- `statementReuse` - ステートメントのキャッシュ有無

---

### setDbAccessExceptionFactory

```java
public void setDbAccessExceptionFactory(DbAccessExceptionFactory dbAccessExceptionFactory)
```

{@link nablarch.core.db.DbAccessException}ファクトリオブジェクトを設定する。

**パラメータ:**
- `dbAccessExceptionFactory` - {@link nablarch.core.db.DbAccessException}ファクトリオブジェクト

---

### setDialect

```java
public void setDialect(Dialect dialect)
```

SQL方言を設定する。

**パラメータ:**
- `dialect` - SQL方言

---

### initConnection

```java
protected void initConnection(BasicDbConnection dbConnection, String connectionName)
```

データベース接続オブジェクトの初期化を行う。
<p/>
下記の処理を行う。
<ul>
<li>BasicDbConnection#initialize()を呼び出し初期化を行う。</li>
<li>Statement生成用Factoryを設定する。</li>
<li>ステートメントのキャッシュ有無を設定する。</li>
<li>{@link nablarch.core.db.DbAccessException}ファクトリオブジェクトを設定する。</li>
</ul>

**パラメータ:**
- `dbConnection` - データベース接続オブジェクト
- `connectionName` - 接続名

---

### setContext

```java
protected void setContext(BasicDbConnection dbConnection, String connectionName)
```

コンテキストを設定する。

**パラメータ:**
- `dbConnection` - データベース接続オブジェクト
- `connectionName` - 接続名

---
