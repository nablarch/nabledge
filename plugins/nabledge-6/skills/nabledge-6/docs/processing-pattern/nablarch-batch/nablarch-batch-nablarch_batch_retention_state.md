# バッチアプリケーションで実行中の状態を保持する

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
