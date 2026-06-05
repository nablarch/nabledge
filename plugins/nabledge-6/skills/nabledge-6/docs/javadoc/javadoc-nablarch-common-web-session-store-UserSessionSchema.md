# class UserSessionSchema

**パッケージ:** nablarch.common.web.session.store

**継承階層:**
```
java.lang.Object
  └─ TableSchema
      └─ nablarch.common.web.session.store.UserSessionSchema
```

---

```java
public final class UserSessionSchema
extends TableSchema
```

ユーザセッションテーブルのスキーマ情報を保持するクラス。

**作成者:** TIS  

---

## フィールドの詳細

### sessionIdName

```java
private String sessionIdName
```

セッションIDカラムの名前

---

### sessionObjectName

```java
private String sessionObjectName
```

セッションオブジェクトカラムの名前

---

### expirationDatetimeName

```java
private String expirationDatetimeName
```

有効期限（DATETIME）カラムの名前

---

## メソッドの詳細

### getSessionIdName

```java
public String getSessionIdName()
```

セッションIDカラムの名前を取得する。

**戻り値:**
セッションIDカラムの名前

---

### setSessionIdName

```java
public void setSessionIdName(String sessionIdName)
```

セッションIDカラムの名前を設定する。

**パラメータ:**
- `sessionIdName` - セッションIDカラムの名前

---

### getSessionObjectName

```java
public String getSessionObjectName()
```

セッションオブジェクトカラムの名前を取得する。

**戻り値:**
セッションオブジェクトカラムの名前

---

### setSessionObjectName

```java
public void setSessionObjectName(String sessionObjectName)
```

セッションオブジェクトカラムの名前を設定する。

**パラメータ:**
- `sessionObjectName` - セッションオブジェクトカラムの名前

---

### getExpirationDatetimeName

```java
public String getExpirationDatetimeName()
```

有効期限（DATETIME）カラムの名前を取得する。

**戻り値:**
有効期限（DATETIME）カラムの名前

---

### setExpirationDatetimeName

```java
public void setExpirationDatetimeName(String expirationDatetimeName)
```

有効期限（DATETIME）カラムの名前を設定する。

**パラメータ:**
- `expirationDatetimeName` - 有効期限（DATETIME）カラムの名前

---
