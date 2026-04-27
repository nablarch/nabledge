# バッチアプリケーションで実行中の状態を保持する

バッチアプリケーションの実行中の状態を保持したい場合がある。
例えば、バッチアクションで行った登録件数や更新件数を保持したい場合などが該当する。
このような場合は、バッチアクション内で状態を保持しすることで対応する。

以下に、登録件数を保持するアクションの実装例を示す。

マルチスレッドで実行されるバッチについては、アプリケーション側でスレッドセーフであることを保証する必要がある。
この例では、 AtomicInteger を使用して保証している。

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

> **Tip:**
> ExecutionContext のスコープを使用して、上記実装例と同じことが実現できる。
> ただし、 ExecutionContext を使用した場合、
> どのような値を保持しているかが分かりづらいデメリットがある。
> このため、 ExecutionContext を使用するのではなく、上記実装例のようにバッチアクション側で状態を保持することを推奨する。

> なお、 ExecutionContext を使用した場合、スコープの考え方は以下のようになる。

> スレッドごとに状態を保持する領域

> バッチ全体の状態を保持する領域
