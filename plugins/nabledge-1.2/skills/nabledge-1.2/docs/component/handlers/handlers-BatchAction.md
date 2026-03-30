# バッチ処理用業務アクションハンドラのテンプレートクラス

## バッチ処理用アクションハンドラのバリエーション

**クラス名**: `nablarch.fw.action.BatchAction`

要件と照らし合わせて以下のテンプレートクラスから適切なものを選択する。

| テンプレートクラス | 内容 |
|---|---|
| [BatchAction](handlers-BatchAction.md) | (本ハンドラ) バッチ処理の実装において汎用的に利用できる標準実装。 |
| [FileBatchAction](handlers-FileBatchAction.md) | ファイルを入力とし、レコード種別（ヘッダー、データ、トレーラ等）ごとに業務処理を呼び分けたい場合に使用する。 |
| [NoInputDataBatchAction](handlers-NoInputDataBatchAction.md) | レコード1件ごとに業務処理を行うのではなく、一回だけ特定の処理を実行したい場合に使用する（アンロード処理のような単発処理）。 |

<details>
<summary>keywords</summary>

BatchAction, FileBatchAction, NoInputDataBatchAction, テンプレートクラス選択, バッチアクション, nablarch.fw.action.BatchAction

</details>

## 概要

**クラス名**: `nablarch.fw.action.BatchAction`

[../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) における業務アクションハンドラを実装するテンプレートクラス。フレームワークはデータリーダの `read()` と本クラスの `handle()` を交互に呼び出し、レコードが読み込めなくなった時点で終了する。データリーダは `createReader()` の戻り値が使用される。

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| createReader() | 必須 | バッチ処理対象レコードの読込みに使用する [データリーダ](../../about/about-nablarch/about-nablarch-concept.md) を生成して返す。 |
| handle() | 必須 | 処理対象レコード1件ごとに呼び出される。業務処理を実行し、正常終了時は `Result.Success` を返す。 |
| transactionSuccess() | 任意 | 業務トランザクションのコミット完了後にコールバックされる。デフォルトは何もしない。 |
| transactionFailure() | 任意 | 業務トランザクションのロールバック後にコールバックされる。デフォルトは何もしない。 |
| initialize() | 任意 | バッチ処理開始前に一度だけ呼ばれる。デフォルトは何もしない。 |
| error() | 任意 | 実行時例外/エラーによるバッチエラー終了時に一度だけコールバックされる。デフォルトは何もしない。 |
| terminate() | 任意 | バッチ処理が全件終了またはエラー終了後に一度だけコールバックされる。デフォルトは何もしない。 |

```java
CommandLine command;
ExecutionContext ctx;

initialize(command, ctx);
DataReader<TData> reader = createReader(ctx);
Result result = null;
try {
    while(reader.hasNext()) {
        TData data = reader.read(ctx);
        try {
            result = handle(data, ctx);
            commit();
            transactionSuccess(data, ctx);
        } catch(e) {
            rollback();
            transactionFailure(data, ctx);
            throw e;
        }
    }
} catch(e) {
    error(e, ctx);
} finally {
    terminate(result, ctx)
}
```

> **注意**: このコードは説明用に単純化したものであり、実際の処理フローはハンドラ構成によって制御されており全く別物である。

<details>
<summary>keywords</summary>

BatchAction, createReader, handle, transactionSuccess, transactionFailure, initialize, error, terminate, Result.Success, データリーダ, バッチ業務アクション実装, nablarch.fw.action.BatchAction

</details>

## ハンドラ処理フロー

**コールバック:**

1. **(バッチ処理開始前初期処理)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に `initialize()` を実行する。
2. **(データリーダ生成)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に `createReader()` を実行する。返された [データリーダ](../../about/about-nablarch/about-nablarch-concept.md) は実行コンテキストに設定され、以降の処理で使用する。

**往路処理:**

3. **(入力レコード1件に対する業務処理を実行)** 引数として渡された入力レコードに対する業務処理を実行する。

**復路処理:**

4. **(正常終了)** 正常終了を表すマーカーオブジェクト（`Result.Success`）を返す。

**例外処理:**

4a. **(エラー終了)** 業務処理に失敗した場合は、実行時例外を送出する。

**コールバック（トランザクション/終了）:**

5. **(業務トランザクション正常終了時)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションが正常にコミットされた後、`transactionSuccess()` を実行する。
5a. **(業務トランザクションロールバック時)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた後、`transactionFailure()` を実行する。
6. **(バッチエラー終了時)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でサブスレッドがエラーにより停止した場合、`error()` を実行する。
7. **(バッチ終了時)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でサブスレッドが終了した場合、`terminate()` を実行する。バッチがエラー終了した場合でも、手順6の後で呼ばれる。

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, TransactionManagementHandler, initialize, createReader, handle, transactionSuccess, transactionFailure, error, terminate, ハンドラ処理フロー, コールバック

</details>
