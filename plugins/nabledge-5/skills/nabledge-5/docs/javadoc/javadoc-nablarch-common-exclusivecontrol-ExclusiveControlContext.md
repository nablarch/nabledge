# class ExclusiveControlContext

**パッケージ:** nablarch.common.exclusivecontrol

---

```java
public class ExclusiveControlContext
```

排他制御の実行に必要な情報を保持するクラス。
<p/>
排他制御用テーブルのスキーマ情報と排他制御対象のデータを指定する主キー条件を保持する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### tableName

```java
private String tableName
```

排他制御用テーブルのテーブル名

---

### versionColumnName

```java
private String versionColumnName
```

バージョン番号カラム名

---

### primaryKeyColumnNames

```java
private Enum<?>[] primaryKeyColumnNames
```

主キーのカラム名

---

### condition

```java
private Map<String,Object> condition
```

排他制御対象の行データを指定する条件

---

## メソッドの詳細

### getTableName

```java
public String getTableName()
```

排他制御用テーブルのテーブル名を取得する。

**戻り値:**
排他制御用テーブルのテーブル名

---

### setTableName

```java
protected void setTableName(String tableName)
```

排他制御用テーブルのテーブル名を設定する。

**パラメータ:**
- `tableName` - 排他制御用テーブルのテーブル名

---

### getVersionColumnName

```java
public String getVersionColumnName()
```

バージョン番号カラム名を取得する。

**戻り値:**
バージョン番号カラム名

---

### setVersionColumnName

```java
protected void setVersionColumnName(String versionColumnName)
```

バージョン番号カラム名を設定する。

**パラメータ:**
- `versionColumnName` - バージョン番号カラム名

---

### getPrimaryKeyColumnNames

```java
public Enum<?>[] getPrimaryKeyColumnNames()
```

主キーのカラム名を取得する。

**戻り値:**
主キーのカラム名

---

### setPrimaryKeyColumnNames

```java
protected void setPrimaryKeyColumnNames(Enum<?> primaryKeyColumnNames)
```

主キーのカラム名を設定する。

**パラメータ:**
- `primaryKeyColumnNames` - 主キーのカラム名

---

### getCondition

```java
public Map<String,Object> getCondition()
```

排他制御対象の行データを指定する条件を取得する。

**戻り値:**
排他制御対象の行データを指定する条件

---

### appendCondition

```java
public ExclusiveControlContext appendCondition(Enum<?> columnName, Object value)
```

排他制御対象の行データを指定する条件を追加する。

**パラメータ:**
- `columnName` - 主キーのカラム名
- `value` - 検索する値

**戻り値:**
本オブジェクト

---
