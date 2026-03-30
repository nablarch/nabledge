# バッチ処理用業務アクションハンドラのテンプレートクラス

## バッチ処理用アクションハンドラのバリエーション

**クラス名**: `nablarch.fw.action.BatchAction`

バッチ処理の実装では、要件に応じて以下のテンプレートクラスから適切なものを選択すること。

| テンプレートクラス | 内容 |
|---|---|
| [BatchAction](handlers-BatchAction.md) | バッチ処理の実装において汎用的に利用できる標準実装。 |
| [FileBatchAction](handlers-FileBatchAction.md) | ファイルを入力とし、レコード種別（ヘッダー、データ、トレーラ等）ごとに実行する業務処理を呼び分けたい場合に使用する。 |
| [NoInputDataBatchAction](handlers-NoInputDataBatchAction.md) | レコード1件ごとに業務処理を行うのではなく、一回だけ特定の処理を実行したい場合に使用する（アンロード処理のような単発処理）。 |

<details>
<summary>keywords</summary>

BatchAction, FileBatchAction, NoInputDataBatchAction, バッチアクション選択, バリエーション, アンロード処理, ファイル入力バッチ, 単発処理

</details>

## 概要

本クラスは、[../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) における業務アクションハンドラを実装するためのテンプレートクラス。

[../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) では、[データリーダ](../../about/about-nablarch/about-nablarch-concept.md) の **read()** メソッドと本クラスの **handle()** メソッドを交互に呼び出し、データリーダからレコードが読み込めなくなった時点で終了する。データリーダは **createReader()** の戻り値が使用される。

本クラスを継承してアクションハンドラを実装する際のテンプレートメソッド:

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| createReader() | 必須 | バッチの処理対象レコード読込みに使用する [データリーダ](../../about/about-nablarch/about-nablarch-concept.md) を生成してリターンする。 |
| handle() | 必須 | バッチの処理対象レコード1件ごとに呼び出される。正常終了時は `Result.Success`_ をリターンする。 |
| transactionSuccess() | 任意 | 業務トランザクションのコミット完了後にコールバックされる。デフォルトは何もしない。 |
| transactionFailure() | 任意 | 業務トランザクションのロールバック後にコールバックされる。デフォルトは何もしない。 |
| initialize() | 任意 | バッチ処理の開始前に一度だけ呼ばれる。デフォルトは何もしない。 |
| error() | 任意 | 実行時例外/エラーの発生によってバッチがエラー終了した場合に一度だけコールバックされる。デフォルトは何もしない。 |
| terminate() | 任意 | バッチ処理が全件終了もしくはエラーにより終了した後で一度だけコールバックされる。デフォルトは何もしない。 |

各テンプレートメソッドの呼び出しタイミング（説明用擬似コード）:

```java
initialize(command, ctx);                       // バッチ処理開始前に一度だけ呼ばれる。
DataReader<TData> reader = createReader(ctx);   // バッチ処理開始前に一度だけ呼ばれる。
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

> **注意**: このコードはあくまで説明用に単純化したものであり、実際の処理フローはハンドラ構成によって制御されており、全く別物である。

<details>
<summary>keywords</summary>

BatchAction, createReader, handle, transactionSuccess, transactionFailure, initialize, error, terminate, DataReader, Result.Success, バッチ処理テンプレートクラス, テンプレートメソッド

</details>

## ハンドラ処理フロー

1. **(バッチ処理開始前初期処理 — コールバック)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に **initialize()** を実行する。
2. **(データリーダ生成 — コールバック)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に **createReader()** を実行する。戻り値の [データリーダ](../../about/about-nablarch/about-nablarch-concept.md) は実行コンテキストに設定され以降の処理で使用する。
3. **(往路処理: 業務処理実行)** 引数として渡された入力レコードに対する業務処理を実行する。
4. **(復路処理: 正常終了)** 正常終了を表すマーカオブジェクト `Result.Success`_ をリターンする。
4a. **(例外処理: エラー終了)** 業務処理に失敗した場合は、実行時例外を送出する。
5. **(業務トランザクション正常終了時 — コールバック)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションが正常にコミットされた場合、**transactionSuccess()** を実行する。
5a. **(業務トランザクションロールバック時 — コールバック)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、**transactionFailure()** を実行する。
6. **(バッチエラー終了時 — コールバック)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドがエラーにより停止した場合、**error()** を実行する。
7. **(バッチ終了時 — コールバック)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドが終了した場合、**terminate()** を実行する。バッチがエラー終了した場合でも、6. の処理の後で呼ばれる。

<details>
<summary>keywords</summary>

BatchAction, initialize, createReader, handle, transactionSuccess, transactionFailure, error, terminate, MultiThreadExecutionHandler, TransactionManagementHandler, ハンドラ処理フロー, コールバック

</details>
