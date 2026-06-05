# class CodePatternSchema

**パッケージ:** nablarch.common.code.schema

**継承階層:**
```
java.lang.Object
  └─ TableSchema
      └─ nablarch.common.code.schema.CodePatternSchema
```

---

```java
public final class CodePatternSchema
extends TableSchema
```

コード名称テーブルのスキーマ情報を保持するクラス。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### idColumnName

```java
private String idColumnName
```

コードIDカラムの名前

---

### valueColumnName

```java
private String valueColumnName
```

コード値カラムの名前

---

### patternColumnNames

```java
private String[] patternColumnNames
```

パターンカラムの名前

---

## メソッドの詳細

### getIdColumnName

```java
public String getIdColumnName()
```

コードIDカラムの名前を取得する。

**戻り値:**
コードIDカラムの名前

---

### setIdColumnName

```java
public void setIdColumnName(String idColumnName)
```

コードIDカラムの名前を設定する。

**パラメータ:**
- `idColumnName` - コードIDカラムの名前

---

### getValueColumnName

```java
public String getValueColumnName()
```

コード値カラムの名前を取得する。

**戻り値:**
コード値カラムの名前

---

### setValueColumnName

```java
public void setValueColumnName(String valueColumnName)
```

コード値カラムの名前を設定する。

**パラメータ:**
- `valueColumnName` - コード値カラムの名前

---

### getPatternColumnNames

```java
public String[] getPatternColumnNames()
```

パターンカラムの名前を取得する。

**戻り値:**
パターンカラムの名前

---

### setPatternColumnNames

```java
public void setPatternColumnNames(String[] patternColumnNames)
```

パターンカラムの名前を設定する。

**パラメータ:**
- `patternColumnNames` - パターンカラムの名前

---
