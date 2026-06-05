# interface Dialect

**パッケージ:** nablarch.core.db.dialect

---

```java
public interface Dialect
```

データベースの実装依存の方言を吸収するためのインタフェース。

**作成者:** hisaaki shioiri  

---

## メソッドの詳細

### supportsIdentity

```java
boolean supportsIdentity()
```

IDENTITY(オートインクリメントカラム)が使用できるか否か。
<p/>

**戻り値:**
使用可能な場合は、 {@code true}

---

### supportsIdentityWithBatchInsert

```java
boolean supportsIdentityWithBatchInsert()
```

batch insert時にIDENTITY(オートインクリメントカラム)が使用できるか否か。

**戻り値:**
使用可能な場合は、{@code true}

---

### supportsSequence

```java
boolean supportsSequence()
```

SEQUENCEが使用できるか否か。
<p/>

**戻り値:**
使用可能な場合は、 {@code true}

---

### supportsOffset

```java
boolean supportsOffset()
```

SQL文でのオフセット指定が使用できるか否か

**戻り値:**
使用可能な場合は、{@code true}

---

### isTransactionTimeoutError

```java
boolean isTransactionTimeoutError(SQLException sqlException)
```

SQL例外がトランザクションタイムアウトと判断すべき例外か否か。

**パラメータ:**
- `sqlException` - SQL例外

**戻り値:**
トランザクションタイムアウトと判断すべき場合{@code true}

---

### isDuplicateException

```java
boolean isDuplicateException(SQLException sqlException)
```

SQL例外が一意制約違反による例外か否か。
<p/>

**パラメータ:**
- `sqlException` - SQL例外

**戻り値:**
SQL例外が一意制約違反の場合{@code true}

---

### getResultSetConvertor

```java
ResultSetConvertor getResultSetConvertor()
```

{@link java.sql.ResultSet}から値を取得するための変換クラスを返却する。

**戻り値:**
変換クラス。

---

### buildSequenceGeneratorSql

```java
String buildSequenceGeneratorSql(String sequenceName)
```

シーケンスオブジェクトの次の値を取得するSQL文を構築する。
<p/>

**パラメータ:**
- `sequenceName` - シーケンス名

**戻り値:**
シーケンスオブジェクトの次の値を取得するSQL文

---

### convertPaginationSql

```java
String convertPaginationSql(String sql, SelectOption selectOption)
```

SQL文をページング用のSQL文に変換する。

**パラメータ:**
- `sql` - SQL文
- `selectOption` - 検索時のオプション

**戻り値:**
変換したSQL文

---

### convertCountSql

```java
String convertCountSql(String sql)
```

SQL文をレコード数取得用のSQL文に変換する。

**パラメータ:**
- `sql` - SQL文

**戻り値:**
変換したSQL文

---

### convertCountSql

```java
String convertCountSql(String sqlId, Object condition, StatementFactory statementFactory)
```

SQLIDからレコード数取得用のSQL文を取得する。

**パラメータ:**
- `sqlId` - SQLID
- `condition` - 可変条件に設定される条件をもつオブジェクト
- `statementFactory` - ステートメントファクトリ

**戻り値:**
レコード数取得用のSQL文

---

### getPingSql

```java
String getPingSql()
```

ping用のSQL文を返す。
<p/>
データベースへの死活チェックを行うための、ping用SQL文を生成する。

**戻り値:**
ping用のSQL文

---
