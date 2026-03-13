# アノテーションによる認可チェック

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/authorization/role_check.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/BasicRoleEvaluator.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/session/SessionStoreUserRoleResolver.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/CheckRole.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/Forbidden.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/CheckRoleLogger.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/BasicApplicationInitializer.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/CheckRoleUtil.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/session/SessionStoreUserRoleUtil.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/RoleEvaluator.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/authorization/role/UserRoleResolver.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Interceptor.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/SystemRepository.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html)

## 機能概要

ユーザにロールを割り当て、機能(アクションメソッド)にも必要なロールをアノテーションで定義し、ユーザが対象ロールを持つかどうかで認可判定を行う。[permission_check](libraries-permission_check.md) より単純なデータ構造で権限管理が可能。

**使い分け基準**:
- ロール自体の増減や機能とロールの割り当て変更が**頻繁に発生しない**場合 → 本認可チェックが適切
- 組織変更などで権限の組み合わせが大きく変わるシステム → [permission_check](libraries-permission_check.md) を使用（本認可チェックを使うと変更のたびにアノテーション書き換えが必要となり修正工数が増大する）

```java
@CheckRole("ADMIN")
public HttpResponse index(HttpRequest request, ExecutionContext context) {
```

<details>
<summary>keywords</summary>

CheckRole, @CheckRole, permission_check, 認可チェック, ロール管理, アノテーション認可, 使い分け基準

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth-session</artifactId>
</dependency>
<!-- デフォルトコンフィグレーションを利用する場合 -->
<dependency>
  <groupId>com.nablarch.configuration</groupId>
  <artifactId>nablarch-main-default-configuration</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-common-auth, nablarch-common-auth-session, nablarch-main-default-configuration, モジュール依存関係

</details>

## 使用方法

### コンポーネント定義

`BasicRoleEvaluator` のコンポーネントを定義し、`userRoleResolver` プロパティに `SessionStoreUserRoleResolver` を設定する。

```xml
<component name="roleEvaluator"
           class="nablarch.common.authorization.role.BasicRoleEvaluator">
    <property name="userRoleResolver" ref="userRoleResolver" />
</component>
<component name="userRoleResolver"
           class="nablarch.common.authorization.role.session.SessionStoreUserRoleResolver" />
```

デフォルトコンフィグレーションを使う場合:

```xml
<import file="nablarch/common/authorization/role/session/authorization-session.xml" />
```

### interceptorsOrder への追加

既に `interceptorsOrder` を定義している場合は `CheckRole` を追加する。`nablarch/webui/interceptors.xml` を読み込んでいる場合は不要。

```xml
<list name="interceptorsOrder">
  <value>nablarch.common.authorization.role.CheckRole</value>
</list>
```

### ロール定義

ロールは任意の文字列。アノテーションで指定する際は文字列リテラルを直接指定することも可能だが、修正が容易になるように定数クラスで管理することを推奨する。

```java
public class Roles {
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_PROJECT_MANAGER = "PROJECT_MANAGER";
}
```

### ユーザのロールをセッションストアに保存

ログイン時に `SessionStoreUserRoleUtil` の `save` メソッドでロールをセッションストアに保存する。

```java
List<String> userRoles = resolveUserRoles(loginId);
SessionStoreUserRoleUtil.save(userRoles, executionContext);
```

> **補足**: `resolveUserRoles` の実装はフレームワークで規定しておらず、プロジェクトごとに作成する（例: DBのフラグ列やユーザ・ロール関連テーブルから解決）。

### @CheckRole アノテーションの使い方

`CheckRole` アノテーションをアクションメソッドに設定する。ロールを持たないユーザが実行しようとすると `Forbidden` がスローされる。

```java
// 単一ロール（ADMIN ロールが必要）
@CheckRole(Roles.ROLE_ADMIN)
public HttpResponse index(HttpRequest request, ExecutionContext context) {

// 複数ロール（AND条件: ADMIN と PROJECT_MANAGER の両方が必要）
@CheckRole({Roles.ROLE_ADMIN, Roles.ROLE_PROJECT_MANAGER})
public HttpResponse index(HttpRequest request, ExecutionContext context) {

// 複数ロール（OR条件: anyOf = true でいずれか一方があれば可）
@CheckRole(
    value = {Roles.ROLE_ADMIN, Roles.ROLE_PROJECT_MANAGER},
    anyOf = true
)
public HttpResponse index(HttpRequest request, ExecutionContext context) {
```

### CheckRoleLogger によるアノテーション設定の一覧確認

`CheckRoleLogger` を `BasicApplicationInitializer` の `initializeList` に設定する。`targetPackage` にアクションクラスのパッケージを指定（サブパッケージも対象）。デフォルトでは末尾が `Action` のクラスが対象（`targetClassPattern` プロパティで正規表現を指定して変更可）。

```xml
<component name="initializer"
           class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component class="nablarch.common.authorization.role.CheckRoleLogger">
        <property name="targetPackage" value="com.nablarch.example.app.web.action" />
      </component>
    </list>
  </property>
</component>
```

デバッグレベルでシステムを起動すると、以下の要素がタブ区切りでログ出力される:

| 要素 | 説明 |
|---|---|
| `class` | クラスの完全修飾名 |
| `signature` | メソッドのシグネチャ |
| `role` | 割り当てられているロール（未設定の場合は空） |
| `anyOf` | `@CheckRole` の `anyOf` の値（未設定の場合は空） |

複数のロールが割り当てられている場合、ロールごとに別行で出力される。

### プログラムによる判定

`CheckRoleUtil` を使用する。

```java
if (CheckRoleUtil.checkRole(Roles.ROLE_ADMIN, executionContext)) {
    // ADMIN ロールを持つ場合の処理
}
```

複数ロールの判定: `checkRoleAllOf`（AND）または `checkRoleAnyOf`（OR）を使用。

### JSPでの表示制御

本認可チェックにはJSPカスタムタグによる表示制御の仕組みは提供されていない。サーバー側で判定した結果をセッションストアに保存して制御する。

```java
UserContext userContext = new UserContext();
userContext.setAdmin(CheckRoleUtil.checkRole(Roles.ROLE_ADMIN, executionContext));
userContext.setProjectManager(CheckRoleUtil.checkRole(Roles.ROLE_PROJECT_MANAGER, executionContext));
SessionUtil.put(executionContext, "userContext", userContext);
```

```jsp
<c:if test="${userContext.admin}"><%-- ADMIN ロールを持つ場合に表示 --%></c:if>
<c:if test="${userContext.projectManager}"><%-- PROJECT_MANAGER ロールを持つ場合に表示 --%></c:if>
```

<details>
<summary>keywords</summary>

BasicRoleEvaluator, SessionStoreUserRoleResolver, CheckRole, @CheckRole, CheckRoleLogger, CheckRoleUtil, SessionStoreUserRoleUtil, SessionUtil, Forbidden, BasicApplicationInitializer, userRoleResolver, interceptorsOrder, targetPackage, targetClassPattern, anyOf, checkRoleAllOf, checkRoleAnyOf, 認可チェック設定, ロール割り当て, セッションストア, JSP表示制御, プログラム判定

</details>

## 仕組み

アノテーションによるチェックは `インターセプタ` の仕組みを利用して実現。`CheckRole` はこのインターセプタを実装したもの。

`CheckRole` と `CheckRoleUtil` は直接認可チェックを行わず、`RoleEvaluator` に処理を委譲する。

- `RoleEvaluator` のインスタンスは `SystemRepository` から `roleEvaluator` という名前で取得
- ユーザIDは `ThreadContext` の `getUserId` メソッドで取得

**デフォルト実装**:
- **クラス**: `nablarch.common.authorization.role.BasicRoleEvaluator` — ユーザのロールと引数のロールを比較して条件を判定。ユーザのロール解決は `UserRoleResolver` に委譲
- **クラス**: `nablarch.common.authorization.role.session.SessionStoreUserRoleResolver` — セッションストアに保存された情報でユーザのロールを解決

<details>
<summary>keywords</summary>

BasicRoleEvaluator, RoleEvaluator, UserRoleResolver, SessionStoreUserRoleResolver, CheckRole, CheckRoleUtil, SystemRepository, ThreadContext, Interceptor, 認可チェック仕組み, ロール評価, roleEvaluator

</details>

## 拡張方法

`RoleEvaluator` または `UserRoleResolver` の実体を差し替えることで拡張できる。

**`RoleEvaluator` の差し替え**: `RoleEvaluator` を実装した独自クラスを `roleEvaluator` という名前でコンポーネント登録する。

```xml
<component name="roleEvaluator" class="com.example.CustomRoleEvaluator" />
```

**`UserRoleResolver` の差し替え**: `BasicRoleEvaluator` はそのまま使い、`userRoleResolver` プロパティのコンポーネントだけを差し替える。デフォルトコンフィグレーションを利用している場合は、`userRoleResolver` という名前で独自クラスのコンポーネントを定義することで差し替えられる。

```xml
<component name="userRoleResolver" class="com.example.CustomUserRoleResolver" />
```

<details>
<summary>keywords</summary>

RoleEvaluator, UserRoleResolver, BasicRoleEvaluator, roleEvaluator, userRoleResolver, 拡張, カスタム認可

</details>
