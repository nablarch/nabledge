# class BasicStringResourceLoader

**パッケージ:** nablarch.core.message

**実装されたインタフェース:**
- StaticDataLoader<StringResource>

---

```java
public class BasicStringResourceLoader
implements StaticDataLoader<StringResource>
```

StringResourceHolderが使うキャッシュに必要な文字列リソースをデータベースから取得するクラス。<br/>
StringResourceの実装にはBasicStringResourceを用いる。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### dbManager

```java
private SimpleDbTransactionManager dbManager
```

データロードに使用するSimpleDbTransactionManagerのインスタンス。

---

### tableName

```java
private String tableName
```

メッセージが格納されたテーブルのテーブル名。

---

### idColumnName

```java
private String idColumnName
```

メッセージIDカラム名。

---

### langColumnName

```java
private String langColumnName
```

言語カラム名。

---

### valueColumnName

```java
private String valueColumnName
```

メッセージカラム名。

---

### idQueryCreated

```java
private boolean idQueryCreated
```

SQL文作成済みフラグ。

---

### selectByIdQuery

```java
private String selectByIdQuery
```

IDによるクエリ用SQL文

---

## メソッドの詳細

### setDbManager

```java
public void setDbManager(SimpleDbTransactionManager dbManager)
```

データロードに使用するDbManagerのインスタンスをセットする。

**パラメータ:**
- `dbManager` - データロードに使用するDbManagerのインスタンス

---

### setTableName

```java
public void setTableName(String tableName)
```

メッセージが格納されたテーブルのテーブル名をセットする。

**パラメータ:**
- `tableName` - メッセージが格納されたテーブルのテーブル名

---

### setIdColumnName

```java
public void setIdColumnName(String idColumnName)
```

メッセージIDカラム名をセットする。

**パラメータ:**
- `idColumnName` - メッセージIDカラム名

---

### setLangColumnName

```java
public void setLangColumnName(String langColumnName)
```

言語カラム名をセットする。

**パラメータ:**
- `langColumnName` - 言語カラム名

---

### setValueColumnName

```java
public void setValueColumnName(String valueColumnName)
```

メッセージカラム名をセットする。

**パラメータ:**
- `valueColumnName` - メッセージカラム名

---

### getId

```java
public Object getId(StringResource value)
```

{@inheritDoc}

---

### generateIndexKey

```java
public Object generateIndexKey(String indexName, StringResource value)
```

{@inheritDoc}<br/>
本実装ではindexの使用を想定しないため、nullを返す。

---

### getIndexNames

```java
public List<String> getIndexNames()
```

{@inheritDoc}<br/>
本実装ではindexの使用を想定しないため、nullを返す。

---

### getValue

```java
public StringResource getValue(Object id)
```

メッセージを格納したテーブルからメッセージIDに対応するメッセージを取得する。

**パラメータ:**
- `id` - メッセージID

**戻り値:**
メッセージIDに対応するメッセージ

---

### getMessage

```java
private SqlResultSet getMessage(Object id)
```

指定されたIDに紐づくメッセージ情報をデータベースから取得する。

**パラメータ:**
- `id` - ID

**戻り値:**
取得したメッセージ情報

---

### getValues

```java
public List<StringResource> getValues(String indexName, Object key)
```

メッセージを格納したテーブルからメッセージIDに対応するメッセージを取得する。

**パラメータ:**
- `indexName` - インデックス名
- `key` - 静的データのキー

**戻り値:**
インデックス名、キーに対応するデータのリスト

---

### loadAll

```java
public List<StringResource> loadAll()
```

メッセージを格納したテーブルから全てのメッセージを取得する。

**戻り値:**
全てのメッセージのリスト。

---

### createMessage

```java
private List<StringResource> createMessage(SqlResultSet results)
```

SqlResultSetを元に、メッセージのリストを作成する。

**パラメータ:**
- `results` - 元となるSqlResultSet

**戻り値:**
作成したメッセージのリスト

---
