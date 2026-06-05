# interface SqlCStatement

**パッケージ:** nablarch.core.db.statement

**継承階層:**
```
java.lang.Object
  └─ SqlPStatement
      └─ nablarch.core.db.statement.SqlCStatement
```

---

```java
public interface SqlCStatement
extends SqlPStatement
```

ストアドプロシージャを実行するインタフェース。

**作成者:** hisaaki sioiri  
**関連項目:** java.sql.CallableStatement  

---

## メソッドの詳細

### registerOutParameter

```java
void registerOutParameter(int parameterIndex, int sqlType)
```

{@link java.sql.CallableStatement#registerOutParameter(int, int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `sqlType` - {@link java.sql.Types}

---

### registerOutParameter

```java
void registerOutParameter(int parameterIndex, int sqlType, int scale)
```

{@link java.sql.CallableStatement#registerOutParameter(int, int, int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス
- `sqlType` - {@link java.sql.Types}
- `scale` - 小数点以下の桁数(0以上であること)

---

### getObject

```java
Object getObject(int parameterIndex)
```

{@link java.sql.CallableStatement#getObject(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getString

```java
String getString(int parameterIndex)
```

{@link java.sql.CallableStatement#getString(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull)

---

### getBigDecimal

```java
BigDecimal getBigDecimal(int parameterIndex)
```

{@link java.sql.CallableStatement#getBigDecimal(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull)

---

### getInteger

```java
Integer getInteger(int parameterIndex)
```

{@link java.sql.CallableStatement#getInt(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getLong

```java
Long getLong(int parameterIndex)
```

{@link java.sql.CallableStatement#getInt(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getShort

```java
Short getShort(int parameterIndex)
```

{@link java.sql.CallableStatement#getShort(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getDate

```java
Date getDate(int parameterIndex)
```

{@link java.sql.CallableStatement#getDate(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getTime

```java
Time getTime(int parameterIndex)
```

{@link java.sql.CallableStatement#getTime(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getTimestamp

```java
Timestamp getTimestamp(int parameterIndex)
```

{@link java.sql.CallableStatement#getTimestamp(int)} (int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getBoolean

```java
Boolean getBoolean(int parameterIndex)
```

{@link java.sql.CallableStatement#getBoolean(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getBytes

```java
byte[] getBytes(int parameterIndex)
```

{@link java.sql.CallableStatement#getByte(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getBlob

```java
Blob getBlob(int parameterIndex)
```

{@link java.sql.CallableStatement#getBlob(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---

### getClob

```java
Clob getClob(int parameterIndex)
```

{@link java.sql.CallableStatement#getClob(int)}.

**パラメータ:**
- `parameterIndex` - パラメータインデックス

**戻り値:**
パラメータインデックスに対応する値(値がnullの場合はnull);

---
