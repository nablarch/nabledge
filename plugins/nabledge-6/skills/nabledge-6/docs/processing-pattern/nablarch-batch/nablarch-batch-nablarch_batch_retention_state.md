# バッチアプリケーションで実行中の状態を保持する

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details/nablarch_batch_retention_state.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/java/util/concurrent/atomic/AtomicInteger.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html)

## バッチアプリケーションで実行中の状態を保持する

マルチスレッドで実行されるバッチはスレッドセーフであることをアプリケーション側で保証する必要がある。この例では、スレッドセーフの保証に `AtomicInteger` を使用している。

バッチアクション実装例（登録件数保持）:

```java
public class BatchActionSample extends BatchAction<Object> {

    /** 登録件数 */
    private AtomicInteger insertedCount = new AtomicInteger(0);

    @Override
    public Result handle(final Object inputData, final ExecutionContext ctx) {
        insertedCount.incrementAndGet();
        return new Result.Success();
    }
}
```

> **補足**: `ExecutionContext` のスコープでも同様に実現できるが、どのような値を保持しているかが分かりづらいため、バッチアクション側で状態を保持することを推奨する。`ExecutionContext` を使う場合のスコープ:
> - **リクエストスコープ**: スレッドごとに状態を保持する領域
> - **セッションスコープ**: バッチ全体の状態を保持する領域

<details>
<summary>keywords</summary>

AtomicInteger, ExecutionContext, BatchAction, BatchActionSample, Result, Result.Success, スレッドセーフ, 状態保持, バッチアクション, マルチスレッド, リクエストスコープ, セッションスコープ

</details>
