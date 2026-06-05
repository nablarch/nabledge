# class SessionStoreUserRoleUtil

**パッケージ:** nablarch.common.authorization.role.session

---

```java
public class SessionStoreUserRoleUtil
```

ユーザに紐づくロールをセッションストアに保存するAPIを提供するクラス。

**作成者:** Tanaka Tomoyuki  

---

## コンストラクタの詳細

### SessionStoreUserRoleUtil

```java
private SessionStoreUserRoleUtil()
```

本クラスはインスタンスを生成しない。

---

## メソッドの詳細

### save

```java
public static void save(Collection<String> roles, ExecutionContext context)
```

現在のセッションに紐づくユーザが持つロールをセッションストアに保存する。

**パラメータ:**
- `roles` - ユーザが持つロールの一覧
- `context` - 実行コンテキスト

**例外:**
- `IllegalStateException` - {@code "userRoleResolver"}という名前で{@link SessionStoreUserRoleResolver}のコンポーネントがシステムリポジトリから取得できない場合

---
