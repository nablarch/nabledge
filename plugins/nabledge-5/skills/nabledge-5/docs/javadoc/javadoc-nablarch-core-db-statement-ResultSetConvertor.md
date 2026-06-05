# interface ResultSetConvertor

**パッケージ:** nablarch.core.db.statement

---

```java
public interface ResultSetConvertor
```

{@link java.sql.ResultSet}から1カラムのデータを取得するインタフェース。<br>
<br>
{@link java.sql.ResultSet#getObject(int)} 以外を使用して、値を取得する必要がある場合には、
本クラスのサブクラスを作成しgetObject(int)以外を使用してデータの取得を行うこと。<br>
<br>
主に、getObject(int)を使用した場合にアプリケーションで処理する際に不都合なデータ型が返却される場合に、
本インタフェースの実装クラスが必要となる。<br>
<br>
例えば、getObject(int)ではdoubleが返却されるため、{@link java.sql.ResultSet#getBigDecimal(int)}を使用して、明示的に{@link java.math.BigDecimal}を取得したい場合が該当する。

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### convert

```java
Object convert(ResultSet rs, ResultSetMetaData rsmd, int columnIndex)
               throws SQLException
```

{@link java.sql.ResultSet}から指定されたカラムのデータを取得する。<br>

**パラメータ:**
- `rs` - ResultSet
- `rsmd` - ResultSetMetaData
- `columnIndex` - カラムインデックス

**戻り値:**
ResultSetから取得した対象カラムのデータ

**例外:**
- `java.sql.SQLException` - SQL例外発生時

---

### isConvertible

```java
boolean isConvertible(ResultSetMetaData rsmd, int columnIndex)
                      throws SQLException
```

指定されたカラムが変換対象のカラムかを返却する。<br>
指定された、{@link java.sql.ResultSetMetaData}とカラムインデックスから、
{@link java.sql.ResultSet#getObject(int)}以外でデータを取得するか否かを返却する。<br>

**パラメータ:**
- `rsmd` - ResultSetMetaData
- `columnIndex` - カラムインデックス

**戻り値:**
{@link java.sql.ResultSet#getObject(int)}以外でデータを取得する必要がある場愛には、true

**例外:**
- `SQLException` - SQL例外発生時

---
