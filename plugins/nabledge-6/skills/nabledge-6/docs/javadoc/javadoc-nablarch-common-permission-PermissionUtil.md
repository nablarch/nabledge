# class PermissionUtil

**パッケージ:** nablarch.common.permission

---

```java
public final class PermissionUtil
```

権限管理に使用するユーティリティクラス。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### PERMISSION_KEY

```java
private static final String PERMISSION_KEY
```

Permissionのキー

---

## コンストラクタの詳細

### PermissionUtil

```java
private PermissionUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### getPermission

```java
public static Permission getPermission()
```

{@link ThreadContext}から{@link Permission}を取得する。
<p/>
ThreadContextにPermissionが設定されていない場合は{@code null}を返却する。

**戻り値:**
取得したPermissionオブジェクト

---

### setPermission

```java
public static void setPermission(Permission permission)
```

{@link ThreadContext}に{@link Permission}を設定する。
<p/>
既にThreadContextにPermissionが登録されている場合は上書きする。

**パラメータ:**
- `permission` - 設定するPermissionオブジェクト

---
