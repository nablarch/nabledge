# class BasicCodeLoader

**パッケージ:** nablarch.common.code

**実装されたインタフェース:**
- StaticDataLoader<Code>
- Initializable

---

```java
public class BasicCodeLoader
implements StaticDataLoader<Code>, Initializable
```

データベースからコードをロードするクラス。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### dbSchema

```java
private Map<String,String> dbSchema
```

使用するテーブル名／カラム名

---

### patternColumnNames

```java
private String[] patternColumnNames
```

パターンカラム名

---

### optionNameColumnNames

```java
private String[] optionNameColumnNames
```

オプション名称のカラム名

---

### dbManager

```java
private SimpleDbTransactionManager dbManager
```

データベーストランザクションマネージャ

---

### selectAllStatement

```java
private String selectAllStatement
```

全てのコードをロードするSQL文。

---

### selectOneCodeStatement

```java
private String selectOneCodeStatement
```

1つのコードをロードするSQL文。

---

## メソッドの詳細

### setCodeNameSchema

```java
public void setCodeNameSchema(CodeNameSchema codeNameSchema)
```

コード名称テーブルのスキーマ情報を設定する。

**パラメータ:**
- `codeNameSchema` - コード名称テーブルのスキーマ情報

---

### setCodePatternSchema

```java
public void setCodePatternSchema(CodePatternSchema codePatternSchema)
```

コードパターンテーブルのスキーマ情報を設定する。

**パラメータ:**
- `codePatternSchema` - コードパターンテーブルのスキーマ情報

---

### setDbManager

```java
public void setDbManager(SimpleDbTransactionManager dbManager)
```

データベーストランザクションマネージャを設定する。

**パラメータ:**
- `dbManager` - データベーストランザクションマネージャ

---

### generateIndexKey

```java
public Object generateIndexKey(String indexName, Code value)
```

{@inheritDoc}<br/>
<br/>

本機能ではインデックスは提供しないためnullを返す。

---

### getId

```java
public Object getId(Code value)
```

{@inheritDoc}

---

### getIndexNames

```java
public List<String> getIndexNames()
```

{@inheritDoc}<br/>
<br/>

本機能ではインデックスは提供しないためnullを返す。

---

### getValue

```java
public Code getValue(Object id)
```

{@inheritDoc}

---

### getValues

```java
public List<Code> getValues(String indexName, Object key)
```

{@inheritDoc}<br/>
<br/>

本機能ではインデックスは提供しないためnullを返す。

---

### loadAll

```java
public List<Code> loadAll()
```

{@inheritDoc}

---

### createResult

```java
private List<Code> createResult(SqlResultSet queryResults)
```

データベースの検索結果からBasicCodeのListを作成する。

**パラメータ:**
- `queryResults` - データベースの検索結果

**戻り値:**
BasicCodeのList

---

### initializeStatements

```java
private void initializeStatements()
```

SQL文を初期化する。

---

### initialize

```java
public void initialize()
```

{@inheritDoc}

---

### replaceStatement

```java
private String replaceStatement(String statement)
```

SQL文の置き換え文字の置き換えを行う。

**パラメータ:**
- `statement` - 置き換え対象の文字

**戻り値:**
置き換え文字を置き換えた文字列。

---
