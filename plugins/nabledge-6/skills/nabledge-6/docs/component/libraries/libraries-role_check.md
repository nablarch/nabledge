# アノテーションによる認可チェック

## 機能概要

アノテーションによる認可チェックでは、ユーザにロール(役割)を割り当て、機能にも実行に必要なロールを割り当て、ユーザが機能のロールを持つかどうかで認可判定を行う。機能とロールの割り当てはアノテーションで行い、ユーザとロールの割り当て方法はフレームワークでは規定しない。[permission_check](libraries-permission_check.md) より単純なデータ構造で権限管理できる。

**アノテーション**: `@CheckRole`

```java
@CheckRole("ADMIN")
public HttpResponse index(HttpRequest request, ExecutionContext context) {
```

## ハンドラによる認可チェックとの使い分け

- **本認可チェックが適している場合**: ロール自体の増減やロールに割り当てる機能の変更が頻繁に発生しない場合。ロールと機能の組み合わせが固定されており今後大きく変化しない場合。
- **[permission_check](libraries-permission_check.md) を推奨する場合**: 組織変更でロールや機能の組み合わせが頻繁に変わるシステム（例: 部署によって権限が変わる場合）。本認可チェックでは変更のたびにアノテーションの書き換えが必要になるため、[permission_check](libraries-permission_check.md) を使って権限の組み合わせをデータで管理することを推奨する。

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

## 使用方法

## コンポーネントの定義

**クラス**: `nablarch.common.authorization.role.BasicRoleEvaluator`, `nablarch.common.authorization.role.session.SessionStoreUserRoleResolver`

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

## interceptorsOrderへの追加

コンポーネント定義に `interceptorsOrder` を定義している場合は `nablarch.common.authorization.role.CheckRole` を追加する必要がある。`interceptorsOrder` を定義していない場合、または `nablarch/webui/interceptors.xml` を読み込んでいる場合は対応不要。

```xml
<list name="interceptorsOrder">
  <value>nablarch.common.authorization.role.CheckRole</value>
</list>
```

## ロールの定義

ロールは任意の文字列。文字種やフォーマットに制限はないが、理解しやすい値を推奨。アノテーションで指定する際は文字列リテラルではなく定数で管理することを推奨（修正が容易になる）。

```java
public class Roles {
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_PROJECT_MANAGER = "PROJECT_MANAGER";
}
```

## ユーザのロールをセッションストアへ保存

ログイン時にユーザのロールを解決し、`SessionStoreUserRoleUtil` の `save` メソッドでセッションストアに保存する。以降の認可チェックはセッションストアの情報を使用する。

```java
List<String> userRoles = resolveUserRoles(loginId);
SessionStoreUserRoleUtil.save(userRoles, executionContext);
```

> **補足**: ユーザからロールを解決する方法はフレームワークでは規定しない。プロジェクトごとに実装する（多くの場合はDBから解決）。

## アクションメソッドへのロール割り当て

**アノテーション**: `@CheckRole` (`nablarch.common.authorization.role.CheckRole`)

```java
@CheckRole(Roles.ROLE_ADMIN)
public HttpResponse index(HttpRequest request, ExecutionContext context) {
```

`ADMIN` ロールを持たないユーザがメソッドを実行しようとした場合は `Forbidden` がスローされる。

複数ロールの指定:
- **AND条件（デフォルト）**: `@CheckRole({Roles.ROLE_ADMIN, Roles.ROLE_PROJECT_MANAGER})`
- **OR条件**: `anyOf = true` を指定

```java
@CheckRole(
    value = {Roles.ROLE_ADMIN, Roles.ROLE_PROJECT_MANAGER},
    anyOf = true
)
public HttpResponse index(HttpRequest request, ExecutionContext context) {
```

## CheckRoleLoggerによるアノテーション設定の確認

`CheckRoleLogger` を `BasicApplicationInitializer` の `initializeList` に設定することで、システム起動時にデバッグレベルのログにアノテーション設定状況を出力できる。

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

| プロパティ名 | 説明 |
|---|---|
| `targetPackage` | アクションクラスが存在するパッケージ（サブパッケージも対象） |
| `targetClassPattern` | 対象クラスの正規表現（デフォルト: 末尾が `Action` で終わるクラス） |

上記設定が完了したら、**ログレベルをデバッグレベルにしてシステムを起動する**。これにより、システム起動時にアノテーション設定状況がログに出力されるようになる。

ログ出力要素（タブ区切り）:

| 要素 | 説明 |
|---|---|
| `class` | クラスの完全修飾名 |
| `signature` | メソッドのシグネチャ |
| `role` | 割り当てられているロール（未設定の場合は空） |
| `anyOf` | `@CheckRole` の `anyOf` 値（未設定の場合は空） |

複数ロールが割り当てられている場合、それぞれのロールは別行で出力される。

## プログラムによるロール判定

**クラス**: `nablarch.common.authorization.role.CheckRoleUtil`

```java
if (CheckRoleUtil.checkRole(Roles.ROLE_ADMIN, executionContext)) {
    // ADMIN ロールを持つ場合の処理
}
```

複数ロール指定: `checkRoleAllOf`（AND条件）または `checkRoleAnyOf`（OR条件）を使用。

## JSPでの表示制御

JSPでの表示・非表示はサーバー側でロールを判定した結果をセッションストアに保存して実現する（JSP用カスタムタグは提供されていない）。`UserContext` はプロジェクトごとに作成するJava Beans。

```java
UserContext userContext = new UserContext();
userContext.setAdmin(CheckRoleUtil.checkRole(Roles.ROLE_ADMIN, executionContext));
userContext.setProjectManager(CheckRoleUtil.checkRole(Roles.ROLE_PROJECT_MANAGER, executionContext));
SessionUtil.put(executionContext, "userContext", userContext);
```

JSP側でEL式/JSTLを使って制御する:

```jsp
<c:if test="${userContext.admin}">
  <%-- ADMIN ロールを持つ場合に表示 --%>
</c:if>
<c:if test="${userContext.projectManager}">
  <%-- PROJECT_MANAGER ロールを持つ場合に表示 --%>
</c:if>
```

## 仕組み

アノテーションによるチェック処理はNablarchの `インターセプタ` の仕組みを使って実現している。`CheckRole` アノテーションはこのインターセプタを実装したものである。

**処理の委譲関係**:
- `CheckRole` / `CheckRoleUtil` は直接認可チェックを行わず、`RoleEvaluator` に委譲する
- `RoleEvaluator` のインスタンスは `SystemRepository` から `roleEvaluator` という名前で取得する
- チェック処理に渡すユーザIDは `ThreadContext` の `getUserId` メソッドで取得する
- `BasicRoleEvaluator`（`RoleEvaluator` のデフォルト実装）はユーザのロール解決を `UserRoleResolver` に委譲する
- `SessionStoreUserRoleResolver`（`UserRoleResolver` のデフォルト実装）はセッションストアに保存された情報でユーザのロールを解決する

## 拡張方法

`RoleEvaluator` または `UserRoleResolver` の実体を差し替えることで拡張できる。

**RoleEvaluatorの差し替え**: `RoleEvaluator` を実装した独自クラスを `roleEvaluator` という名前でコンポーネント登録する。

```xml
<component name="roleEvaluator" class="com.example.CustomRoleEvaluator" />
```

**UserRoleResolverのみ差し替え**: `BasicRoleEvaluator` はそのまま使いつつ `UserRoleResolver` のみ差し替えたい場合、デフォルトコンフィグレーションを使用しているときは `userRoleResolver` という名前で独自クラスを定義することで差し替えできる。

```xml
<component name="userRoleResolver" class="com.example.CustomUserRoleResolver" />
```
