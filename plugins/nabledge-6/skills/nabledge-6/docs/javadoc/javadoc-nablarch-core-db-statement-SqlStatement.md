# interface SqlStatement

**パッケージ:** nablarch.core.db.statement

---

```java
public interface SqlStatement
```

SQL文を実行するインタフェース。
<p/>
本インタフェースでは、JDBC標準SQL(バインド変数が「?」)と拡張SQL(バインド変数が名前付き変数)で共通となるインタフェースを定義している。
<p/>
このクラスはリソースを解放する必要があるが、リソースの解放処理は{@link nablarch.core.db.connection.TransactionManagerConnection#terminate()}で行われるため、
Statementを明示的にクローズする必要はない。

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### close

```java
void close()
```

{@link java.sql.PreparedStatement#close}のラッパー。

---

### isClosed

```java
boolean isClosed()
```

Statementがクローズされているか否か。

**戻り値:**
このStatementオブジェクトがクローズされている場合は {@code true}、まだオープンしている場合は {@code false}

---

### executeBatch

```java
int[] executeBatch()
```

{@link java.sql.PreparedStatement#executeBatch}のラッパー。

**戻り値:**
更新件数

---

### getBatchSize

```java
int getBatchSize()
```

バッチサイズを取得する。

**戻り値:**
サイズ

---

### setJdbcTransactionTimeoutHandler

```java
void setJdbcTransactionTimeoutHandler(JdbcTransactionTimeoutHandler jdbcTransactionTimeoutHandler)
```

トランザクションタイムアウトタイマーを設定する。
<p/>
本設定値を省略した場合、トランザクションのタイムアウト処理は行われない。

**パラメータ:**
- `jdbcTransactionTimeoutHandler` - トランザクションタイムアウトタイマー

---

### getConnection

```java
AppDbConnection getConnection()
```

Statementを生成した{@link AppDbConnection}を取得する。

**戻り値:**
データベース接続オブジェクト

---

### getFetchSize

```java
int getFetchSize()
```

{@link java.sql.PreparedStatement#getFetchSize}のラッパー。

**戻り値:**
フェッチする行数

---

### setFetchSize

```java
void setFetchSize(int rows)
```

{@link java.sql.PreparedStatement#setFetchSize}のラッパー。

**パラメータ:**
- `rows` - フェッチする行数

---

### getUpdateCount

```java
int getUpdateCount()
```

{@link java.sql.PreparedStatement#getUpdateCount}のラッパー。

**戻り値:**
更新件数

---

### setQueryTimeout

```java
void setQueryTimeout(int seconds)
```

{@link java.sql.PreparedStatement#setQueryTimeout}のラッパー。

**パラメータ:**
- `seconds` - タイムアウト時間

---

### getQueryTimeout

```java
int getQueryTimeout()
```

{@link java.sql.PreparedStatement#getQueryTimeout}のラッパー。

**戻り値:**
タイムアウト時間

---

### getMaxRows

```java
int getMaxRows()
```

{@link java.sql.PreparedStatement#getMaxRows}のラッパー。

**戻り値:**
この Statement オブジェクトによって生成される{@link java.sql.ResultSet}オブジェクトの現在の最大行数。ゼロは無制限を意味する。

---

### setMaxRows

```java
void setMaxRows(int max)
```

{@link java.sql.PreparedStatement#setMaxRows}のラッパー。

**パラメータ:**
- `max` - 新しい最大行数の制限値。ゼロは無制限を意味する。

---

### clearBatch

```java
void clearBatch()
```

{@link java.sql.PreparedStatement#clearBatch}のラッパー。

---
