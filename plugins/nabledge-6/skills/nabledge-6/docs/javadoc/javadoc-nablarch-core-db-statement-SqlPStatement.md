# interface SqlPStatement

**パッケージ:** nablarch.core.db.statement

**継承階層:**
```
java.lang.Object
  └─ SqlStatement
      └─ nablarch.core.db.statement.SqlPStatement
```

---

```java
public interface SqlPStatement
extends SqlStatement
```

バインド変数をもつSQL文を実行するインタフェース。<br>

**作成者:** Hisaaki Sioiri  
**関連項目:** java.sql.PreparedStatement  

---

## メソッドの詳細

### retrieve

```java
SqlResultSet retrieve()
                      throws SqlStatementException
```

簡易検索機能。
下記設定で検索を実行する。
<ul>
    <li>読み込み開始位置 = 1</li>
    <li>最大行数 = 無制限</li>
</ul>
本メソッドを使用すると{@link #setMaxRows}で事前に設定した値は無視する。

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合。

---

### retrieve

```java
SqlResultSet retrieve(int start, int max)
                      throws SqlStatementException
```

簡易検索機能。

**パラメータ:**
- `start` - 取得開始位置
- `max` - 取得最大件数

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合。

---

### executeQuery

```java
ResultSetIterator executeQuery()
                               throws SqlStatementException
```

{@link java.sql.PreparedStatement#executeQuery}のラッパー。

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合。

---

### executeUpdate

```java
int executeUpdate()
                  throws SqlStatementException
```

{@link java.sql.PreparedStatement#executeUpdate}のラッパー。

**戻り値:**
更新件数

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合。

---

### setNull

```java
void setNull(int parameterIndex, int sqlType)
```

{@link java.sql.PreparedStatement#setNull}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `sqlType` - SQLタイプ({@link java.sql.Types})

---

### setBoolean

```java
void setBoolean(int parameterIndex, boolean x)
```

{@link java.sql.PreparedStatement#setBoolean}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setByte

```java
void setByte(int parameterIndex, byte x)
```

{@link java.sql.PreparedStatement#setByte}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setShort

```java
void setShort(int parameterIndex, short x)
```

{@link java.sql.PreparedStatement#setShort}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setInt

```java
void setInt(int parameterIndex, int x)
```

{@link java.sql.PreparedStatement#setInt}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setLong

```java
void setLong(int parameterIndex, long x)
```

{@link java.sql.PreparedStatement#setLong}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setFloat

```java
void setFloat(int parameterIndex, float x)
```

{@link java.sql.PreparedStatement#setFloat}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setDouble

```java
void setDouble(int parameterIndex, double x)
```

{@link java.sql.PreparedStatement#setDouble}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setBigDecimal

```java
void setBigDecimal(int parameterIndex, BigDecimal x)
```

{@link java.sql.PreparedStatement#setBigDecimal}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setString

```java
void setString(int parameterIndex, String x)
```

{@link java.sql.PreparedStatement#setString}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setBytes

```java
void setBytes(int parameterIndex, byte[] x)
```

{@link java.sql.PreparedStatement#setBytes}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setDate

```java
void setDate(int parameterIndex, Date x)
```

{@link java.sql.PreparedStatement#setDate}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setTime

```java
void setTime(int parameterIndex, Time x)
```

{@link java.sql.PreparedStatement#setTime}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setTimestamp

```java
void setTimestamp(int parameterIndex, Timestamp x)
```

{@link java.sql.PreparedStatement#setTimestamp}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setAsciiStream

```java
void setAsciiStream(int parameterIndex, InputStream x, int length)
```

{@link java.sql.PreparedStatement#setAsciiStream(int, java.io.InputStream, int)}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ
- `length` - ストリームのバイト数

---

### setBinaryStream

```java
void setBinaryStream(int parameterIndex, InputStream x, int length)
```

{@link java.sql.PreparedStatement#setBinaryStream(int, java.io.InputStream, int)}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ
- `length` - ストリームのバイト数

---

### clearParameters

```java
void clearParameters()
```

{@link java.sql.PreparedStatement#clearParameters}のラッパー。

---

### setObject

```java
void setObject(int parameterIndex, Object x, int targetSqlType)
```

{@link java.sql.PreparedStatement#setObject}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ
- `targetSqlType` - SQLタイプ(<code>java.sql.Types</code>)

---

### setObject

```java
void setObject(int parameterIndex, Object x)
```

{@link java.sql.PreparedStatement#setObject}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### execute

```java
boolean execute()
                throws SqlStatementException
```

{@link java.sql.PreparedStatement#execute}のラッパー。

**戻り値:**
最初の結果が{@link java.sql.ResultSet}オブジェクトの場合は{@code true}。
  更新カウントであるか、または結果がない場合は{@code false}。

**例外:**
- `SqlStatementException` - 例外発生時

---

### addBatch

```java
void addBatch()
```

{@link java.sql.PreparedStatement#addBatch}のラッパー。

---

### setCharacterStream

```java
void setCharacterStream(int parameterIndex, Reader reader, int length)
```

{@link java.sql.PreparedStatement#setCharacterStream(int, java.io.Reader, int)}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `reader` - パラメータ
- `length` - ストリームないの文字数

---

### setRef

```java
void setRef(int parameterIndex, Ref x)
```

{@link java.sql.PreparedStatement#setRef}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setBlob

```java
void setBlob(int parameterIndex, Blob x)
```

{@link java.sql.PreparedStatement#setBlob}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setClob

```java
void setClob(int parameterIndex, Clob x)
```

{@link java.sql.PreparedStatement#setClob}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### setArray

```java
void setArray(int parameterIndex, Array x)
```

{@link java.sql.PreparedStatement#setArray}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### getMetaData

```java
ResultSetMetaData getMetaData()
```

{@link java.sql.PreparedStatement#getMetaData}のラッパー。

**戻り値:**
ResultSetMetaData

---

### setDate

```java
void setDate(int parameterIndex, Date x, Calendar cal)
```

{@link java.sql.PreparedStatement#setDate(int, java.sql.Date, java.util.Calendar)}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ
- `cal` - ドライバが日付を作成するために使用する{@link java.util.Calendar}オブジェクト

---

### setTime

```java
void setTime(int parameterIndex, Time x, Calendar cal)
```

{@link java.sql.PreparedStatement#setTime(int, java.sql.Time, java.util.Calendar)}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ
- `cal` - ドライバが日付を作成するために使用する{@link java.util.Calendar}オブジェクト

---

### setTimestamp

```java
void setTimestamp(int parameterIndex, Timestamp x, Calendar cal)
```

{@link java.sql.PreparedStatement#setTimestamp(int, java.sql.Timestamp, java.util.Calendar)}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ
- `cal` - ドライバが日付を作成するために使用する{@link java.util.Calendar}オブジェクト

---

### setNull

```java
void setNull(int parameterIndex, int sqlType, String typeName)
```

{@link java.sql.PreparedStatement#setNull(int, int, String)}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `sqlType` - SQLタイプ
- `typeName` - SQL ユーザー定義型の完全指定の名前。
                パラメータがユーザー定義型でも{@link java.sql.Ref}でもない場合は無視される。

---

### setURL

```java
void setURL(int parameterIndex, URL x)
```

{@link java.sql.PreparedStatement#setURL}のラッパー。

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `x` - パラメータ

---

### getResultSet

```java
ResultSet getResultSet()
```

{@link java.sql.PreparedStatement#getResultSet}のラッパー。

**戻り値:**
{@link java.sql.ResultSet}オブジェクトとしての現在の結果。
  更新カウントであるか、結果がない場合は{@code null}。

---

### getMoreResults

```java
boolean getMoreResults()
```

{@link java.sql.PreparedStatement#getMoreResults}のラッパー。

**戻り値:**
次の結果が{@link java.sql.ResultSet}オブジェクトの場合は{@code true}。
  更新カウントであるか、結果がない場合は{@code false}。

---

### setFetchDirection

```java
void setFetchDirection(int direction)
```

{@link java.sql.PreparedStatement#setFetchDirection}のラッパー。

**パラメータ:**
- `direction` - 行を処理する初期方向

---

### getFetchDirection

```java
int getFetchDirection()
```

{@link java.sql.PreparedStatement#getFetchDirection}のラッパー。

**戻り値:**
この Statement オブジェクトから生成された結果セットのデフォルトのフェッチ方向

---

### getResultSetConcurrency

```java
int getResultSetConcurrency()
```

{@link java.sql.PreparedStatement#getResultSetConcurrency}のラッパー。

**戻り値:**
{@link java.sql.ResultSet#CONCUR_READ_ONLY}
  または{@link java.sql.ResultSet#CONCUR_UPDATABLE}。

---

### getResultSetType

```java
int getResultSetType()
```

{@link java.sql.PreparedStatement#getResultSetType}のラッパー。

**戻り値:**
{@link java.sql.ResultSet#TYPE_FORWARD_ONLY}、
  {@link java.sql.ResultSet#TYPE_SCROLL_INSENSITIVE}、
  {@link java.sql.ResultSet#TYPE_SCROLL_SENSITIVE}のうちの1つ。

---

### getMoreResults

```java
boolean getMoreResults(int current)
```

{@link java.sql.PreparedStatement#getMoreResults}のラッパー。

**パラメータ:**
- `current` - getResultSet メソッドを使用して取得した、
               現在の {@link java.sql.ResultSet} オブジェクトに生じる状態を示す Statement 定数。
               {@link java.sql.Statement#CLOSE_CURRENT_RESULT}、
               {@link java.sql.Statement#KEEP_CURRENT_RESULT}、
               {@link java.sql.Statement#CLOSE_ALL_RESULTS}のうちの 1 つ。

**戻り値:**
次の結果が{@link java.sql.ResultSet}オブジェクトの場合は{@code true}。
  更新カウントであるか、または結果がない場合は{@code false}。

---

### getGeneratedKeys

```java
ResultSet getGeneratedKeys()
```

{@link java.sql.PreparedStatement#getGeneratedKeys}のラッパー。

**戻り値:**
この Statement オブジェクトの実行で生成された自動生成キーを含む{@link java.sql.ResultSet}オブジェクト

---

### getResultSetHoldability

```java
int getResultSetHoldability()
```

{@link java.sql.PreparedStatement#getResultSetHoldability}のラッパー。

**戻り値:**
{@link java.sql.ResultSet#HOLD_CURSORS_OVER_COMMIT}
  または{@link java.sql.ResultSet#CLOSE_CURSORS_AT_COMMIT}。

---
