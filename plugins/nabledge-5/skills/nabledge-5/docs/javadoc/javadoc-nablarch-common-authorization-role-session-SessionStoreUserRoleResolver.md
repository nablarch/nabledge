# class SessionStoreUserRoleResolver

**パッケージ:** nablarch.common.authorization.role.session

**実装されたインタフェース:**
- UserRoleResolver

---

```java
public class SessionStoreUserRoleResolver
implements UserRoleResolver
```

ユーザに紐づくロールをセッションストアから解決する{@link UserRoleResolver}実装。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### sessionStoreKey

```java
private String sessionStoreKey
```

---

## メソッドの詳細

### resolve

```java
public Collection<String> resolve(String userId, ExecutionContext context)
```

---

### save

```java
public void save(Collection<String> roles, ExecutionContext context)
```

セッションストアにロール一覧を保存する。

**パラメータ:**
- `roles` - ロール一覧
- `context` - 実行コンテキスト

---

### setSessionStoreKey

```java
public void setSessionStoreKey(String sessionStoreKey)
```

セッションストアにロールを保存するときに使用するキーを設定する。

**パラメータ:**
- `sessionStoreKey` - セッションストアにロールを保存するときに使用するキー

---

### getSessionStoreKey

```java
public String getSessionStoreKey()
```

セッションストアにロールを保存するときに使用するキーを取得する。

**戻り値:**
セッションストアにロールを保存するときに使用するキー

---
