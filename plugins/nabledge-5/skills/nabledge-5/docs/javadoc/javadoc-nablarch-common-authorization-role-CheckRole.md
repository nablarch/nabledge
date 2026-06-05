# @interface CheckRole

**パッケージ:** nablarch.common.authorization.role

---

```java
public @interface CheckRole
```

アクションのメソッドを実行するために必要なロールを、
アクセスしてきたユーザが持つかチェックする{@link Interceptor}。
<p>
このアノテーションをアクションのメソッドに設定することで、
そのメソッドを実行するために必要なロールをアクセスしてきたユーザが持つかどうかを
チェックできるようになる。<br>
アクセスしてきたユーザの識別子は、{@link ThreadContext#getUserId() ThreadContextのgetUserIdメソッド}で
取得できるものが利用される。<br>
また、ロールの有無の判定は{@link RoleEvaluator}に委譲して行われる。
この{@link RoleEvaluator}のインスタンスは、システムリポジトリから{@code "roleEvaluator"}という名前で
取得したものを使用する。
</p>
<p>
判定の結果ロールを持たないと判断された場合は、{@link Forbidden}がスローされる。
</p>

**作成者:** Tanaka Tomoyuki  

---
