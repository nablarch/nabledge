# interface PermissionFactory

**パッケージ:** nablarch.common.permission

---

```java
public interface PermissionFactory
```

{@link Permission}を生成するインタフェース。
<br>
認可情報の取得先毎に本インタフェースの実装クラスを作成する。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### getPermission

```java
Permission getPermission(String userId)
```

{@link Permission}を取得する。

**パラメータ:**
- `userId` - ユーザID

**戻り値:**
{@link Permission}

---
