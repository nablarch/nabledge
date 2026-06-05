# class DbTokenSchema

**パッケージ:** nablarch.common.web.token

**継承階層:**
```
java.lang.Object
  └─ TableSchema
      └─ nablarch.common.web.token.DbTokenSchema
```

---

```java
public class DbTokenSchema
extends TableSchema
```

トークンテーブルのスキーマ情報を保持するクラス。

**作成者:** Goro Kumano  

---

## フィールドの詳細

### tokenName

```java
private String tokenName
```

トークンカラム名

---

### createdAtName

```java
private String createdAtName
```

作成日時カラム名

---

## メソッドの詳細

### getTokenName

```java
public String getTokenName()
```

トークンカラム名 を取得する。

**戻り値:**
トークンカラム名

---

### getCreatedAtName

```java
public String getCreatedAtName()
```

作成日時カラム名 を取得する。

**戻り値:**
作成日時カラム名

---

### setTokenName

```java
public void setTokenName(String tokenName)
```

トークンカラム名 を設定する

**パラメータ:**
- `tokenName` - トークンカラム名

---

### setCreatedAtName

```java
public void setCreatedAtName(String createdAtName)
```

作成日時カラム名 を設定する

**パラメータ:**
- `createdAtName` - 作成日時カラム名

---
