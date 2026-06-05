# class DefaultDialect

**パッケージ:** nablarch.core.db.dialect

**実装されたインタフェース:**
- Dialect

---

```java
public class DefaultDialect
implements Dialect
```

デフォルトの{@link Dialect}実装クラス。
<p/>
本実装では、全ての方言が無効化される。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### RESULT_SET_CONVERTOR

```java
private static final ResultSetConvertor RESULT_SET_CONVERTOR
```

{@link ResultSet}から値を取得するクラス

---

## メソッドの詳細

### supportsIdentity

```java
public boolean supportsIdentity()
```

**戻り値:**
{@code false}を返す。

---

### supportsIdentityWithBatchInsert

```java
public boolean supportsIdentityWithBatchInsert()
```

**戻り値:**
{@code false}を返す。

---

### supportsSequence

```java
public boolean supportsSequence()
```

**戻り値:**
{@code false}を返す。

---

### supportsOffset

```java
public boolean supportsOffset()
```

**戻り値:**
{@code false}を返す。

---

### isTransactionTimeoutError

```java
public boolean isTransactionTimeoutError(SQLException sqlException)
```

**戻り値:**
{@code false}を返す。

---

### isDuplicateException

```java
public boolean isDuplicateException(SQLException sqlException)
```

**戻り値:**
{@code false}を返す。

---

### getResultSetConvertor

```java
public ResultSetConvertor getResultSetConvertor()
```

{@inheritDoc}
<p>
全てのカラムを{@link ResultSet#getObject(int)}で取得するコンバータを返す。

---

### buildSequenceGeneratorSql

```java
public String buildSequenceGeneratorSql(String sequenceName)
                                 throws UnsupportedOperationException
```

{@inheritDoc}
<p/>
シーケンス採番はサポートしない。

**例外:**
- `UnsupportedOperationException` - 呼び出された場合

---

### convertPaginationSql

```java
public String convertPaginationSql(String sql, SelectOption selectOption)
```

SQL文を変換せずに返す。

---

### convertCountSql

```java
public String convertCountSql(String sql)
```

{@inheritDoc}
<p/>
以下形式のCOUNT文取得用SQL文に変換する。<br/>
{@code SELECT COUNT(*) COUNT_ FROM ('引数のSQL') SUB_}

---

### convertCountSql

```java
public String convertCountSql(String sqlId, Object condition, StatementFactory statementFactory)
```

{@inheritDoc}

デフォルトでは、{@link this#convertCountSql(String)}を使用して、
{@link StatementFactory}から取得したSQLをレコード数取得用SQLに変換する。

---

### getPingSql

```java
public String getPingSql()
```

{@inheritDoc}

デフォルト実装では、本メソッドはサポートしない。

---
