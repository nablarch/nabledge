# class BasicRoleEvaluator

**パッケージ:** nablarch.common.authorization.role

**実装されたインタフェース:**
- RoleEvaluator

---

```java
public class BasicRoleEvaluator
implements RoleEvaluator
```

{@link RoleEvaluator}の基本的な実装を提供するクラス。
<p>
このクラスは、{@link UserRoleResolver}を使ってユーザに紐づくロールの一覧を取得し、
そのロール一覧を用いて権限の有無を判定する。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### userRoleResolver

```java
private UserRoleResolver userRoleResolver
```

---

## メソッドの詳細

### evaluateAnyOf

```java
public boolean evaluateAnyOf(String userId, Collection<String> roles, ExecutionContext context)
```

---

### evaluateAllOf

```java
public boolean evaluateAllOf(String userId, Collection<String> roles, ExecutionContext context)
```

---

### checkUserRoleResolverIsNotNull

```java
private void checkUserRoleResolverIsNotNull()
```

{@link UserRoleResolver}が設定されていることを検証する。

---

### setUserRoleResolver

```java
public void setUserRoleResolver(UserRoleResolver userRoleResolver)
```

{@link UserRoleResolver}を設定する。

**パラメータ:**
- `userRoleResolver` - {@link UserRoleResolver}のインスタンス

---
