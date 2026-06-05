# class SchemaReplacer

**パッケージ:** nablarch.core.db.statement.sqlloader

**実装されたインタフェース:**
- SqlLoaderCallback

---

```java
public class SchemaReplacer
implements SqlLoaderCallback
```

スキーマのプレースホルダーを置き換えるクラス。

SQL文中に{@literal #SCHEMA#}というプレースホルダーがあれば、それを指定されたスキーマ名で置換する。

**作成者:** Tsuyoshi Kawasaki  

---

## フィールドの詳細

### replacer

```java
private final SqlPlaceHolderReplacer replacer
```

実際の置換を行うクラス

---

### SCHEMA_PLACEHOLDER

```java
private static final String SCHEMA_PLACEHOLDER
```

プレースホルダー文字列

---

## メソッドの詳細

### processOnAfterLoad

```java
public String processOnAfterLoad(String sql, String sqlId)
```

---

### setSchemaName

```java
public void setSchemaName(String schemaName)
```

スキーマ名を設定する。

**パラメータ:**
- `schemaName` - スキーマ名

---
