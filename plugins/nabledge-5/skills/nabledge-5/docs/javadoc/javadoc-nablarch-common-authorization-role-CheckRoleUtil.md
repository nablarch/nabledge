# class CheckRoleUtil

**パッケージ:** nablarch.common.authorization.role

---

```java
public class CheckRoleUtil
```

{@link RoleEvaluator}を用いたロール管理をプログラムから利用するためのユーティリティ。
<p>
本クラスが提供するメソッドは、{@link ThreadContext#getUserId()} で取得したユーザIDを元に
現在のアクセスユーザを特定する。
そして、そのアクセスユーザが指定されたロールを有するかどうかを判定する。
</p>
<p>
ロールの判定には {@link RoleEvaluator} を使用する。
このインスタンスは、システムリポジトリから {@code "roleEvaluator"} という名前で取得する。
</p>

**作成者:** Tanaka Tomoyuki  

---

## コンストラクタの詳細

### CheckRoleUtil

```java
private CheckRoleUtil()
```

本クラスはインスタンス化しない。

---

## メソッドの詳細

### checkRole

```java
public static boolean checkRole(String role, ExecutionContext context)
```

現在のアクセスユーザが指定されたロールを有することを判定する。

**パラメータ:**
- `role` - ロール
- `context` - 実行コンテキスト

**戻り値:**
ロールを有する場合は {@code true}

---

### checkRoleAllOf

```java
public static boolean checkRoleAllOf(Collection<String> roles, ExecutionContext context)
```

現在のアクセスユーザが指定されたロールを全て有することを判定する。

**パラメータ:**
- `roles` - ロールの一覧
- `context` - 実行コンテキスト

**戻り値:**
ロールを全て有する場合は {@code true}

---

### checkRoleAnyOf

```java
public static boolean checkRoleAnyOf(Collection<String> roles, ExecutionContext context)
```

現在のアクセスユーザが指定されたロールを1つでも有することを判定する。

**パラメータ:**
- `roles` - ロールの一覧
- `context` - 実行コンテキスト

**戻り値:**
ロールを1つでも有する場合は {@code true}

---

### obtainRoleEvaluator

```java
private static RoleEvaluator obtainRoleEvaluator()
```

{@link RoleEvaluator}を取得する。

**戻り値:**
{@link RoleEvaluator}

---
