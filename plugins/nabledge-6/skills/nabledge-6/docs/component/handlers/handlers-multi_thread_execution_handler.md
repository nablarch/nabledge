# マルチスレッド実行制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/multi_thread_execution_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.MultiStatus.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ExecutionHandlerCallback.html)

## 概要

サブスレッドを作成し、ハンドラキュー上の後続ハンドラの処理を各サブスレッド上で並行実行するハンドラ。

**処理結果**: このハンドラでの処理結果は、各サブスレッドでの実行結果を集約したオブジェクト（`nablarch.fw.Result.MultiStatus`）となる。

本ハンドラでは以下の処理を行う:
- サブスレッド起動前のコールバック処理
- サブスレッドの起動
- サブスレッドでの後続ハンドラの実行
- サブスレッドで例外及びエラー発生時のコールバック処理
- サブスレッドでの処理終了後のコールバック処理

<details>
<summary>keywords</summary>

マルチスレッド実行制御ハンドラ, サブスレッド, 並行実行, MultiStatus, nablarch.fw.Result.MultiStatus, 処理結果, 集約

</details>

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.MultiThreadExecutionHandler`

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, nablarch.fw.handler.MultiThreadExecutionHandler, ハンドラクラス名

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

nablarch-fw-standalone, モジュール一覧, 依存関係

</details>

## 制約

特に無し

<details>
<summary>keywords</summary>

制約, マルチスレッド実行制御ハンドラ, スタンドアロン

</details>

## スレッド数を指定する

デフォルトはサブスレッド1つ。`concurrentNumber` プロパティで後続ハンドラの並列実行数を変更可能。

```xml
<component class="nablarch.fw.handler.MultiThreadExecutionHandler">
  <!-- 後続ハンドラを8多重で実行する -->
  <property name="concurrentNumber" value="8" />
</component>
```

> **重要**: 本ハンドラ以降の処理を複数スレッドで実行する場合、後続のハンドラやバッチアクションはスレッドセーフな実装が必要。スレッドセーフでない処理を複数スレッドで実行すると、予期せぬ例外やデータ不整合が発生する。

<details>
<summary>keywords</summary>

concurrentNumber, スレッド数, 並列実行, スレッドセーフ, 多重実行

</details>

## スレッド起動前後で任意の処理を実行したい

コールバック処理は以下の3タイミングで実行される:

1. サブスレッド起動前
2. サブスレッドで例外発生後の全スレッド終了後
3. 全サブスレッド終了後（サブスレッドで例外が発生した場合でも実行）

コールバック対象: このハンドラより後続に設定されたハンドラで `ExecutionHandlerCallback` を実装しているもの。複数のハンドラが実装している場合は、より手前のハンドラから順に実行される。

> **重要**: コールバック処理中にエラーや例外が発生した場合、残りのハンドラへのコールバック処理は実行されない。

> **重要**: コールバック処理でのDB操作は、親スレッド側のDBコネクションとトランザクションが使用される。コールバック内での更新は本ハンドラ終了後に親スレッドの `:ref:transaction_management_handler` でコミットされる。即時確定が必要な場合は個別トランザクションを使用すること（`:ref:universal_dao-transaction`、`:ref:database-new_transaction` 参照）。

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
    // サブスレッド終了後のコールバック処理
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

ExecutionHandlerCallback, nablarch.fw.handler.ExecutionHandlerCallback, preExecution, errorInExecution, postExecution, コールバック処理, サブスレッド起動前後, トランザクション確定

</details>

## データベース接続に関する設定について

- 親スレッド側でDBアクセスが必要な場合: 本ハンドラより前に `:ref:database_connection_management_handler` の設定が必要
- サブスレッド側でDBアクセスが必要な場合: 本ハンドラより後のサブスレッドで実行されるハンドラ構成に `:ref:database_connection_management_handler` の設定が必要（トランザクション制御ハンドラも同様）
- 親スレッド・サブスレッドの両方でDBアクセスする場合、最低2つのDBコネクションが必要。サブスレッドが複数の場合はスレッド数分が追加で必要（例: サブスレッド10の場合、合計11コネクション）

<details>
<summary>keywords</summary>

database_connection_management_handler, データベース接続設定, DBコネクション数, 親スレッド, サブスレッド

</details>

## サブスレッドでの例外発生時の振る舞い

サブスレッドで予期せぬ例外が発生した場合、`ThreadPoolExecutor#shutdownNow()` を呼び出し、他の処理中のサブスレッドをデータ処理完了後に安全に終了させる。

サブスレッドに `:ref:database_connection_management_handler` および `:ref:transaction_management_handler` を設定した場合の例外時の動作:

1. 例外が発生したサブスレッドは処理が中断されロールバックされる
2. 親スレッドは各サブスレッドで使用されるデータリーダをクローズする
3. 親スレッドは全サブスレッドに対し停止要求を行う
4. 各サブスレッドはデータリーダがクローズされているため、実行中の処理が終わったタイミングで正常終了する

> **重要**: `InterruptedException` を捕捉している場合は、割り込み要求により安全に処理できないことを示しているため、例外を送出する等で処理を異常終了させること。

<details>
<summary>keywords</summary>

ThreadPoolExecutor, InterruptedException, サブスレッド例外, shutdownNow, ロールバック, 割り込み処理

</details>
