# class DatabaseRecordReader

**パッケージ:** nablarch.fw.reader

**実装されたインタフェース:**
- DataReader<SqlRow>

---

```java
public class DatabaseRecordReader
implements DataReader<SqlRow>
```

データベースの参照結果を1レコードづつ読み込むデータリーダ。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### records

```java
private Iterator<SqlRow> records
```

参照結果レコードのイテレータ

---

### statement

```java
private SqlPStatement statement
```

テーブル参照用SQLステートメント

---

### parameterizedSqlPStatement

```java
private ParameterizedSqlPStatement parameterizedSqlPStatement
```

テーブル参照用SQLステートメント(オブジェクトを条件に指定する場合)

---

### condition

```java
private Object condition
```

条件

---

### listener

```java
private DatabaseRecordListener listener
```

データベースレコードリスナ

---

## コンストラクタの詳細

### DatabaseRecordReader

```java
public DatabaseRecordReader()
```

{@code DatabaseRecordReader}オブジェクトを生成する。

---

## メソッドの詳細

### read

```java
public synchronized SqlRow read(ExecutionContext ctx)
```

参照結果のレコードを1行づつ返却する。
<p/>
初回読み込み時にデータベースからレコードを取得し、キャッシュする。<br/>
レコードはそのキャッシュから返却する。<br/>
参照結果に次のレコードが存在しない場合、{@code null}を返す。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
レコードデータをキャッシュするオブジェクト

---

### hasNext

```java
public synchronized boolean hasNext(ExecutionContext ctx)
```

参照結果から次のレコードが存在するかどうかを返却する。
<p/>
初回読み込み時にデータベースからレコードを取得し、キャッシュする。<br/>
結果はそのキャッシュから返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
次に読み込むレコードが存在する場合 {@code true}

---

### close

```java
public synchronized void close(ExecutionContext ctx)
```

内部的にキャッシュしている各種リソースを解放する。
 <p/>
 この実装では、レコードの読み込みに使用したステートメントオブジェクトが
 {@code null}でない場合、解放する。

**パラメータ:**
- `ctx` - 実行コンテキスト

---

### reopen

```java
public synchronized void reopen(ExecutionContext ctx)
```

ステートメントを再実行し、最新の情報を取得し直す。
<p/>
取得した参照結果をキャッシュする。

**パラメータ:**
- `ctx` - 実行コンテキスト

---

### readRecords

```java
private void readRecords()
```

参照結果のイテレータをキャッシュする。

**例外:**
- `IllegalStateException` - SQLステートメントが{@code null}の場合

---

### setStatement

```java
public synchronized DatabaseRecordReader setStatement(SqlPStatement statement)
```

テーブルを参照するSQLステートメントを設定する。

**パラメータ:**
- `statement` - SQLステートメント

**戻り値:**
このオブジェクト自体

---

### setStatement

```java
public DatabaseRecordReader setStatement(ParameterizedSqlPStatement parameterizedSqlPStatement, Object condition)
```

テーブルを参照するSQLステートメント及び条件を設定する。

**パラメータ:**
- `parameterizedSqlPStatement` - SQLステートメント
- `condition` - ステートメントのINパラメータに設定する値を持つオブジェクト

**戻り値:**
このオブジェクト自体

---

### setListener

```java
public DatabaseRecordReader setListener(DatabaseRecordListener listener)
```

データベースレコードリスナを設定する。
<p/>
リスナに定義されたコールバック処理は、
処理対象レコードをキャッシュするためのデータベースアクセス前に実行される。
<p/>
本リーダにリスナを設定することで、
処理対象レコードをデータベースから取得する前に任意の処理を実行することができる。

**パラメータ:**
- `listener` - データベースレコードリスナ

**戻り値:**
このオブジェクト自体

---
