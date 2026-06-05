# class SqlRow

**パッケージ:** nablarch.core.db.statement

**継承階層:**
```
java.lang.Object
  └─ MultipleKeyCaseMap<Object>
      └─ nablarch.core.db.statement.SqlRow
```

---

```java
public class SqlRow
extends MultipleKeyCaseMap<Object>
```

簡易取得結果1行分のデータを保持するクラス。
<p/>
各カラムの内容は、そのデータ型に対応したgetメソッドにより取得できる。
この際、カラム名の大文字/小文字の違い、アンダースコアの有無は区別せず、
同一のカラム名とみなされる。
<p/>
例:
<ul>
<li>USER_NAMEとuser_nameは同一のカラム名とみなされる。(大文字小文字の区別はしないため)
<li>USER_NAMEとuserNameは同一のカラム名とみなされる。(アンダースコアの有無は区別しないため)
</ul>

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### colType

```java
private Map<String,Integer> colType
```

データタイプ情報

---

## コンストラクタの詳細

### SqlRow

```java
public SqlRow(Map<String,Object> row, Map<String,Integer> colType)
```

指定されたMapを元にオブジェクトを構築する。

**パラメータ:**
- `row` - 1行分のデータを持つMap
- `colType` - カラムタイプ

---

### SqlRow

```java
public SqlRow(Map<String,Object> row, Map<String,Integer> colType, Map<String,String> ignored)
```

指定されたMapを元にオブジェクトを構築する。

**パラメータ:**
- `row` - 1行分のデータを持つMap
- `colType` - カラムタイプ
- `ignored` - カラム名の紐付け情報(本引数は使用しない)

---

### SqlRow

```java
protected SqlRow(SqlRow orig)
```

コピー元となる{@code SqlRow}からオブジェクトを構築する。

**パラメータ:**
- `orig` - コピー元となるインスタンス

---

## メソッドの詳細

### getString

```java
public final String getString(String colName)
```

指定されたカラムの情報を文字列で取得する。

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するString型データ(toString()した結果を返却する)。
         データベースの検索結果が{@code null}の場合には、{@code null}を返却する

**例外:**
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### clobToString

```java
private String clobToString(Object o)
```

Clob型のオブジェクトをString型に変換

**パラメータ:**
- `o` - 変換対象

**戻り値:**
変換結果

---

### getInteger

```java
public final Integer getInteger(String colName)
```

指定されたカラムの情報を{@link Integer}として取得する。
<p/>
データベースから取得したデータがInteger型である場合、その値をそのまま返却する。<br/>
それ以外の型の場合、そのデータの文字列表現(toString()した結果)を、
{@link Integer#valueOf(String)}を使用してInteger型に変換し返却する。
<p/>
データベースから取得したデータがどのような文字列表現を返却するかは、
使用するRDBMSのJDBCドライバに依存する。
<p/>
以下に例を示す。
<pre>
| 文字列表現 | 結果                  |
|------------+-----------------------|
| "1"        |                     1 |
| "-1"       |                    -1 |
|"2147483648"| NumberFormatException |
| "1.0"      | NumberFormatException |
| "ABC"      | NumberFormatException |
</pre>

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するInteger型データ。
         データベースの検索結果が{@code null}の場合には、{@code null}を返却する

**例外:**
- `NumberFormatException` - データベースから取得したデータの文字列表現が、Integer型として解釈できない場合
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### getLong

```java
public final Long getLong(String colName)
```

指定されたカラムの情報を{@link Long}として取得する。
<p/>
データベースから取得したデータがLong型である場合、その値をそのまま返却する。<br/>
それ以外の型の場合、そのデータの文字列表現(toString()した結果)を、
{@link Long#valueOf(String)}を使用してLong型に変換し返却する。
<p/>
データベースから取得したデータがどのような文字列表現を返却するかは、
使用するRDBMSのJDBCドライバに依存する。
</p>
以下に例を示す。
<pre>
| 文字列表現 | 結果                  |
|------------+-----------------------|
| "1"        |                     1 |
| "-1"       |                    -1 |
|"2147483648"|            2147483648 |
| "1.0"      | NumberFormatException |
| "ABC"      | NumberFormatException |
</pre>

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するLong型データ。
         データベースの検索結果が{@code null}の場合には、{@code null}を返却する

**例外:**
- `NumberFormatException` - データベースから取得したデータの文字列表現が、Long型として解釈できない場合
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### getBoolean

```java
public Boolean getBoolean(String colName)
```

指定されたカラムの情報を{@link Boolean}として取得する。
<p/>
以下の値の場合、{@link Boolean#TRUE}を返却し、それ以外は全て{@link Boolean#FALSE}を返却する。
<ul>
    <li>booleanの{@code true}の場合</li>
    <li>{@link String}の場合で"1" or "on" or "true"の場合(大文字、小文字の区別はしない)</li>
    <li>数値型で0以外の場合</li>
</ul>
<p/>
データベースから取得したデータのデータタイプが下記に該当しない場合は、{@link IllegalStateException}を送出する。
<ul>
<li>{@link Boolean}</li>
<li>{@link String}</li>
<li>{@link Number}のサブクラス</li>
</ul>

**パラメータ:**
- `colName` - カラム名

**戻り値:**
{@code true} or {@code false}を返却する。
         データベースの検索結果が{@code null}の場合には、{@code null}を返却する

**例外:**
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### getBigDecimal

```java
public final BigDecimal getBigDecimal(String colName)
```

指定されたカラムの情報を{@link BigDecimal}として取得する。

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するBigDecimal型データ。
         データベースの検索結果が{@code null}の場合には、{@code null}を返却する

**例外:**
- `NumberFormatException` - データベースから取得したデータの文字列表現(toString()した結果)が、BigDecimal型として解釈できない場合
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### toBigDecimal

```java
private BigDecimal toBigDecimal(Object o)
```

BigDecimalに変換する。

**パラメータ:**
- `o` - 変換対象

**戻り値:**
変換結果

---

### getDate

```java
public Date getDate(String colName)
```

指定されたカラムの情報を{@link java.util.Date}として取得する。
<p/>
データベースから取得したデータのデータタイプが下記のデータの場合、java.util.Dateとして取得する
下記に該当しない場合は、{@link IllegalStateException}を送出する。<br>
<ul>
<li>{@link java.util.Date}</li>
<li>{@link java.sql.Timestamp}</li>
</ul>

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するjava.util.Date型データ。
         データベースの検索結果が{@code null}の場合には、{@code null}を返却する

**例外:**
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### getTimestamp

```java
public Timestamp getTimestamp(String colName)
```

指定されたカラムの情報を{@link java.sql.Timestamp}として取得する。
<p/>
データベースから取得したデータのデータタイプが下記のデータの場合、{@link java.sql.Timestamp}として取得する。
下記に該当しない場合は、{@link IllegalStateException}を送出する。<br>
<ul>
<li>{@link java.sql.Timestamp}</li>
</ul>

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するjava.sql.Timestamp型データ

**例外:**
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### getBytes

```java
public byte[] getBytes(String colName)
```

指定されたカラムの情報をbyte配列として取得する。
<p/>
データベースから取得したデータのデータタイプが下記のデータの場合、byte配列として取得する。<br>
下記に該当しない場合は、{@link IllegalStateException}を送出する。
<ul>
<li>{@link java.sql.Types#BLOB}</li>
<li>{@link java.sql.Types#BINARY}</li>
<li>{@link java.sql.Types#VARBINARY}</li>
<li>{@link java.sql.Types#LONGVARBINARY}</li>
</ul>

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するbyte配列データ。
         データベースの検索結果が{@code null}の場合には、{@code null}を返却する

**例外:**
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合
- `DbAccessException` - データタイプが{@code BLOB}型である場合で、データの読み込みに失敗した場合

---

### getObject

```java
private Object getObject(String colName)
```

指定されたカラムの情報を{@link Object}オブジェクトとして取得する。

**パラメータ:**
- `colName` - カラム名

**戻り値:**
指定されたカラム名に対応するデータ。

**例外:**
- `IllegalArgumentException` - 指定されたカラム名が存在しない場合

---

### getColType

```java
protected int getColType(String colName)
```

指定されたカラム名のカラムタイプ({@link java.sql.Types})を取得する。

**パラメータ:**
- `colName` - カラム名

**戻り値:**
カラムタイプ

---
