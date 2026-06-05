# class H2Dialect

**パッケージ:** nablarch.core.db.dialect

**継承階層:**
```
java.lang.Object
  └─ DefaultDialect
      └─ nablarch.core.db.dialect.H2Dialect
```

---

```java
public class H2Dialect
extends DefaultDialect
```

H2用のSQL方言クラス。
<p>
このクラスは、1.4.191 および 2.1.214 により動作確認を行っている。

**作成者:** Masaya Seko  

---

## フィールドの詳細

### UNIQUE_ERROR_SQL_STATE

```java
private static final String UNIQUE_ERROR_SQL_STATE
```

一意制約違反を表すSQLState

---

### QUERY_CANCEL_SQL_STATE

```java
private static final String QUERY_CANCEL_SQL_STATE
```

Query Timeアウト時に発生する例外のエラーコード

---

### LOCK_TIMEOUT_SQL_STATE

```java
private static final String LOCK_TIMEOUT_SQL_STATE
```

2.1.214 でロック試行タイムアウト時に発生する例外のエラーコード

---

## メソッドの詳細

### supportsIdentity

```java
public boolean supportsIdentity()
```

{@inheritDoc}
<p/>
H2では、IDENTITYカラムを使用できるため、 {@code true}を返す。

---

### supportsIdentityWithBatchInsert

```java
public boolean supportsIdentityWithBatchInsert()
```

{@inheritDoc}

H2では、batch insertでIDENTITYカラムが使用できるため、{@code true}を返す。

---

### supportsSequence

```java
public boolean supportsSequence()
```

{@inheritDoc}
<p/>
H2では、シーケンスオブジェクトが使用できるので、 {@code true}を返す。

---

### supportsOffset

```java
public boolean supportsOffset()
```

{@inheritDoc}
<p/>
H2では、{@code offset}がサポートされるので{@code true}を返す。

---

### isDuplicateException

```java
public boolean isDuplicateException(SQLException sqlException)
```

{@inheritDoc}
<p/>
{@link SQLException#getSQLState()}が23505(unique_violation:一意制約違反)の場合、一意制約違反とする。

---

### isTransactionTimeoutError

```java
public boolean isTransactionTimeoutError(SQLException sqlException)
```

{@inheritDoc}
<p/>
H2の場合、以下例外の場合タイムアウト対象の例外として扱う。
<ul>
<li>SQLState:57014(クエリタイムアウト時に送出される例外コード)</li>
<li>SQLState:HYT00(ロック試行タイムアウト時に送出される例外コード)</li>
</ul>

---

### buildSequenceGeneratorSql

```java
public String buildSequenceGeneratorSql(String sequenceName)
```

{@inheritDoc}
<p/>
{@code nextval}関数を使用して、次の順序を取得するSQL文を構築する。

---

### convertPaginationSql

```java
public String convertPaginationSql(String sql, SelectOption selectOption)
```

{@inheritDoc}
<p/>
{@code offset}と{@code limit}を使用したSQL文に変換する。

---

### getPingSql

```java
public String getPingSql()
```

---
