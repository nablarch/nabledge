# マルチスレッド実行制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/multi_thread_execution_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.MultiStatus.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/MultiThreadExecutionHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ExecutionHandlerCallback.html)

## ハンドラクラス名

サブスレッドを作成し、ハンドラキュー上の後続ハンドラの処理を各サブスレッド上で並行実行するハンドラ。処理結果は `MultiStatus` で集約される。

**クラス名**: `nablarch.fw.handler.MultiThreadExecutionHandler`

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, nablarch.fw.handler.MultiThreadExecutionHandler, MultiStatus, nablarch.fw.Result.MultiStatus, マルチスレッド実行制御ハンドラ, サブスレッド並行実行

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係

</details>

## 制約

特に無し

<details>
<summary>keywords</summary>

制約なし, マルチスレッド実行制御ハンドラ制約

</details>

## スレッド数を指定する

デフォルトでは後続サブスレッドを1つ起動。`concurrentNumber` プロパティで多重度を変更可能。

```xml
<component class="nablarch.fw.handler.MultiThreadExecutionHandler">
  <!-- 後続ハンドラを8多重で実行する -->
  <property name="concurrentNumber" value="8" />
</component>
```

> **重要**: 本ハンドラ以降の処理を複数スレッドで実行する場合、後続のハンドラやバッチアクションはスレッドセーフな実装が必要。スレッドセーフでない処理を複数スレッドで実行すると、予期せぬ例外やデータ不整合の原因となる。

<details>
<summary>keywords</summary>

concurrentNumber, スレッド数設定, 並列実行数, スレッドセーフ, 多重度設定

</details>

## スレッド起動前後で任意の処理を実行したい

コールバック処理は以下の3ポイントで実行:

1. サブスレッド起動前
2. サブスレッドで例外発生後の全スレッド終了後
3. 全サブスレッド終了後（サブスレッドで例外が発生した場合でも実行）

コールバックされる処理: 後続ハンドラの中で `ExecutionHandlerCallback` を実装しているもの。複数ハンドラが実装している場合は手前から順次実行。

> **重要**: 複数ハンドラがコールバック処理を実装していた場合で、コールバック処理中にエラーや例外が発生した場合は、残りのハンドラに対するコールバック処理は実行しない。

> **重要**: コールバック処理でのDB処理は、親スレッド側の [transaction_management_handler](handlers-transaction_management_handler.md) のトランザクションで確定(コミット)される。コールバック内で即確定が必要な場合は個別トランザクションを使用すること（[universal_dao-transaction](../libraries/libraries-universal_dao.md)、[database-new_transaction](../libraries/libraries-database.md) 参照）。

```java
public class SampleHandler implements Handler<Object, Result>, ExecutionHandlerCallback<Object, Result> {
  @Override
  public Result handle(Object input, ExecutionContext context) {
    return context.handleNext(input);
  }
  @Override
  public void preExecution(Object input, ExecutionContext context) {
    // サブスレッド起動前のコールバック処理
  }
  @Override
  public void errorInExecution(Throwable error, ExecutionContext context) {
    // サブスレッドでエラーが発生した場合のコールバック処理
  }
  @Override
  public void postExecution(Result result, ExecutionContext context) {
    if (result.isSuccess()) {
      // サブスレッドが正常終了
    } else {
      // サブスレッドが異常終了
    }
  }
}
```

<details>
<summary>keywords</summary>

ExecutionHandlerCallback, nablarch.fw.handler.ExecutionHandlerCallback, preExecution, errorInExecution, postExecution, コールバック処理, サブスレッド起動前後, 個別トランザクション, transaction_management_handler

</details>

## データベース接続に関する設定について

- 親スレッド側にDB接続が必要な場合: 本ハンドラ以前に [database_connection_management_handler](handlers-database_connection_management_handler.md) を設定（トランザクション制御ハンドラも必要）
- サブスレッド側にDB接続が必要な場合: 本ハンドラ以降のサブスレッドで実行されるハンドラに [database_connection_management_handler](handlers-database_connection_management_handler.md) を設定（トランザクション制御ハンドラも必要）

親スレッドとサブスレッド両方でDBアクセスを行う場合、最低でも2つのDB接続が必要。サブスレッドが10の場合、合計11個のDB接続が必要。

<details>
<summary>keywords</summary>

database_connection_management_handler, データベース接続設定, 親スレッド接続, サブスレッド接続, DB接続数, transaction_management_handler, トランザクション制御ハンドラ

</details>

## サブスレッドでの例外発生時の振る舞い

サブスレッドで予期せぬ例外が発生した場合、`ThreadPoolExecutor#shutdownNow()` を呼び出して他のサブスレッドを安全に終了させる。

サブスレッド毎にトランザクション管理する場合の例外発生時の動作:

1. 例外が発生したサブスレッドは処理が中断されロールバック
2. 親スレッドは各サブスレッドで使用されるデータリーダをクローズ
3. 親スレッドは全サブスレッドに停止要求
4. 各サブスレッドはデータリーダクローズ後、実行中の処理が終わったタイミングで正常終了

> **重要**: `InterruptedException` を捕捉している場合は、割り込み要求により安全に処理できないため、例外を送出する等で処理を異常終了させること。

<details>
<summary>keywords</summary>

ThreadPoolExecutor, InterruptedException, 例外発生時の振る舞い, ロールバック, shutdownNow, データリーダクローズ

</details>
