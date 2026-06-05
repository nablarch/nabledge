# class SessionManager

**パッケージ:** nablarch.common.web.session

---

```java
public class SessionManager
```

セッションストアの管理および、セッションオブジェクトの生成を行うクラス。

**作成者:** kawasima  
**作成者:** tajima  

---

## フィールドの詳細

### defaultStoreName

```java
private String defaultStoreName
```

デフォルトのストア名

---

### availableStores

```java
private Map<String,SessionStore> availableStores
```

このマネージャから利用可能なセッションストアの一覧

---

### orderedStores

```java
private List<SessionStore> orderedStores
```

設定時の順序を保持したセッションストアの一覧

---

### defaultEncoder

```java
private StateEncoder defaultEncoder
```

明示的に指定されなかった場合に使用する{@link StateEncoder}

---

## コンストラクタの詳細

### SessionManager

```java
public SessionManager()
```

コンストラクタ。

---

## メソッドの詳細

### create

```java
public Session create(ExecutionContext executionContext)
```

セッションを生成する。

**パラメータ:**
- `executionContext` - コンテキスト

**戻り値:**
生成したセッション

---

### setDefaultStoreName

```java
public void setDefaultStoreName(String defaultStoreName)
```

デフォルトのストア名を設定する。

**パラメータ:**
- `defaultStoreName` - デフォルトのストア名

---

### setAvailableStores

```java
public void setAvailableStores(List<SessionStore> sessionStores)
```

セッションストアを設定する。

**パラメータ:**
- `sessionStores` - 設定するセッションストア

---

### getAvailableStores

```java
public List<SessionStore> getAvailableStores()
```

セッションストアを取得する。

**戻り値:**
セッションストア

---

### findSessionStore

```java
public SessionStore findSessionStore(String storeName)
```

セッションストアを検索する。

**パラメータ:**
- `storeName` - ストア名

**戻り値:**
セッションストア

---

### getDefaultStore

```java
public SessionStore getDefaultStore()
```

デフォルトのセッションストアを取得する。

**戻り値:**
セッションストア

---

### getDefaultEncoder

```java
public StateEncoder getDefaultEncoder()
```

デフォルトエンコーダを取得する。

**戻り値:**
デフォルトエンコーダ

---

### setDefaultEncoder

```java
public void setDefaultEncoder(StateEncoder defaultEncoder)
```

デフォルトエンコーダを設定する。

**パラメータ:**
- `defaultEncoder` - デフォルトエンコーダ

---
