# バッチアプリケーションで実行中の状態を保持する

## バッチアプリケーションで実行中の状態を保持する

**状態保持方法**: バッチアクション内でフィールドとして状態を保持する

> **重要**: マルチスレッドバッチでは、アプリケーション側でスレッドセーフを保証すること

**実装例** (登録件数カウンタ):

```java
public class BatchActionSample extends BatchAction<Object> {
    /** 登録件数 */
    private AtomicInteger insertedCount = new AtomicInteger(0);

    @Override
    public Result handle(final Object inputData, final ExecutionContext ctx) {
        // 業務処理
        insertedCount.incrementAndGet();
        return new Result.Success();
    }
}
```

**クラス**: `AtomicInteger` (スレッドセーフなカウンタ)

> **補足**: `ExecutionContext` のスコープでも同等実装可能だが、保持値が分かりづらいため非推奨。バッチアクション側での状態保持を推奨する。
> 
> ExecutionContextのスコープ:
> - **リクエストスコープ**: スレッドごとの状態
> - **セッションスコープ**: バッチ全体の状態
