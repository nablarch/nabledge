# バッチアプリケーションで実行中の状態を保持する

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details/nablarch_batch_retention_state.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/java/util/concurrent/atomic/AtomicInteger.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html)

## バッチアクションでの状態保持

バッチアクション内でフィールドとして状態（登録件数・更新件数など）を保持できる。

マルチスレッドで実行されるバッチでは、アプリケーション側でスレッドセーフを保証すること（例: `AtomicInteger` を使用）。

```java
public class BatchActionSample extends BatchAction<Object> {
    
    /** 登録件数 */
    private AtomicInteger insertedCount = new AtomicInteger(0);

    @Override
    public Result handle(final Object inputData, final ExecutionContext ctx) {
        // 業務処理
        
        // 登録件数のインクリメント
        insertedCount.incrementAndGet();
        
        return new Result.Success();
    }
}
```

> **補足**: `ExecutionContext` のスコープでも同様のことは実現できるが、どのような値を保持しているかが分かりづらいため、バッチアクション側でフィールドとして状態を保持する方法を推奨する。ExecutionContextを使用する場合のスコープの考え方:
> - リクエストスコープ: スレッドごとに状態を保持する領域
> - セッションスコープ: バッチ全体の状態を保持する領域

<details>
<summary>keywords</summary>

AtomicInteger, ExecutionContext, BatchAction, Result.Success, 状態保持, マルチスレッド, スレッドセーフ, 登録件数, リクエストスコープ, セッションスコープ

</details>
