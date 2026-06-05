# interface RoleEvaluator

**パッケージ:** nablarch.common.authorization.role

---

```java
public interface RoleEvaluator
```

ユーザにロールがあるか判定を行うインタフェース。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### evaluateAnyOf

```java
boolean evaluateAnyOf(String userId, Collection<String> roles, ExecutionContext context)
```

指定されたユーザが、指定されたロールをいずれか1つでも有していることを判定する。

**パラメータ:**
- `userId` - 判定対象のユーザID
- `roles` - ロールの一覧
- `context` - 実行コンテキスト

**戻り値:**
ロールを有する場合は {@code true}

---

### evaluateAllOf

```java
boolean evaluateAllOf(String userId, Collection<String> roles, ExecutionContext context)
```

指定されたユーザが、指定されたロールを全て有していることを判定する。

**パラメータ:**
- `userId` - 判定対象のユーザID
- `roles` - ロールの一覧
- `context` - 実行コンテキスト

**戻り値:**
ロールを有する場合は {@code true}

---
