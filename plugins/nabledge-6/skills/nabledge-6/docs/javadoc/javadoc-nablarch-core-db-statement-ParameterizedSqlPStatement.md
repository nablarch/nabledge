# interface ParameterizedSqlPStatement

**パッケージ:** nablarch.core.db.statement

**継承階層:**
```
java.lang.Object
  └─ SqlStatement
      └─ nablarch.core.db.statement.ParameterizedSqlPStatement
```

---

```java
public interface ParameterizedSqlPStatement
extends SqlStatement
```

名前付きバインド変数をもつSQL文を実行するインタフェース。

**作成者:** Hisaaki Sioiri  
**関連項目:** java.sql.PreparedStatement  

---

## メソッドの詳細

### retrieve

```java
SqlResultSet retrieve(Map<String,?> data)
                      throws SqlStatementException
```

簡易検索機能。
<p/>
下記設定で検索を実行する。
<ul>
    <li>読み込み開始位置 = 1</li>
    <li>最大行数 = 無制限</li>
</ul>
本メソッドを使用すると{@link #setMaxRows}で事前に設定した値は適用されない。

**パラメータ:**
- `data` - 検索条件を要素にもつMap

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合

---

### retrieve

```java
SqlResultSet retrieve(int startPos, int max, Map<String,?> data)
                      throws SqlStatementException
```

簡易検索機能。

**パラメータ:**
- `startPos` - 取得開始位置
- `max` - 取得最大件数
- `data` - 検索条件を要素にもつMap

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合

---

### retrieve

```java
SqlResultSet retrieve(Object data)
                      throws SqlStatementException
```

簡易検索機能。
<p/>
下記設定で検索を実行する。
<ul>
    <li>読み込み開始位置 = 1</li>
    <li>最大行数 = 無制限</li>
</ul>
本メソッドを使用すると{@link #setMaxRows}で事前に設定した値は適用されない。

**パラメータ:**
- `data` - 検索条件をフィールドにもつオブジェクト

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合

---

### retrieve

```java
SqlResultSet retrieve(int startPos, int max, Object data)
                      throws SqlStatementException
```

簡易検索機能。

**パラメータ:**
- `startPos` - 取得開始位置
- `max` - 取得最大件数
- `data` - 検索条件をフィールドにもつオブジェクト

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合

---

### executeQueryByMap

```java
ResultSetIterator executeQueryByMap(Map<String,?> data)
                                    throws SqlStatementException
```

{@link java.sql.PreparedStatement#executeQuery}のラッパー。

**パラメータ:**
- `data` - 検索条件を要素にもつMap

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合

---

### executeQueryByObject

```java
ResultSetIterator executeQueryByObject(Object data)
                                       throws SqlStatementException
```

{@link java.sql.PreparedStatement#executeQuery}のラッパー。

**パラメータ:**
- `data` - 検索条件をフィールドの値にもつオブジェクト

**戻り値:**
取得結果

**例外:**
- `SqlStatementException` - SQL実行時に{@link java.sql.SQLException}が発生した場合

---

### executeUpdateByObject

```java
int executeUpdateByObject(Object data)
                          throws SqlStatementException
```

オブジェクトのフィールドの値をバインド変数に設定しSQLを実行する。

**パラメータ:**
- `data` - バインド変数にセットする値を保持したオブジェクト

**戻り値:**
更新件数

**例外:**
- `SqlStatementException` - 例外発生時

---

### addBatchObject

```java
void addBatchObject(Object data)
```

バッチ実行用にオブジェクトのフィールドの値をバインド変数にセットする。

**パラメータ:**
- `data` - バインド変数にセットする値を保持したオブジェクト

---

### executeUpdateByMap

```java
int executeUpdateByMap(Map<String,?> data)
                       throws SqlStatementException
```

Mapのvalueをバインド変数にセットしSQLを実行する。

**パラメータ:**
- `data` - バインド変数にセットする値を保持したMap

**戻り値:**
登録または、更新件数

**例外:**
- `SqlStatementException` - 例外発生時

---

### addBatchMap

```java
void addBatchMap(Map<String,?> data)
```

バッチ実行用にMapのvalueをバインド変数にセットする。

**パラメータ:**
- `data` - バインド変数にセットする値を保持したMap

---
