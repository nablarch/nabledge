# interface UserRoleResolver

**パッケージ:** nablarch.common.authorization.role

---

```java
public interface UserRoleResolver
```

ユーザに紐づくロールの一覧を解決するインタフェース。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### resolve

```java
Collection<String> resolve(String userId, ExecutionContext context)
```

指定されたユーザに紐づくロールの一覧を解決して返却する。

**パラメータ:**
- `userId` - ユーザID
- `context` - 実行コンテキスト

**戻り値:**
ユーザに紐づくロールの一覧(ロールが無い場合は空のコレクションを返す)

---
