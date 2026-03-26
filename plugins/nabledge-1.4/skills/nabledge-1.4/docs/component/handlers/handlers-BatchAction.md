# バッチ処理用業務アクションハンドラのテンプレートクラス

## 

**クラス名**: `nablarch.fw.action.BatchAction`

<details>
<summary>keywords</summary>

BatchAction, nablarch.fw.action.BatchAction, バッチ処理用アクションハンドラ

</details>

## バッチ処理用アクションハンドラのバリエーション

バッチ処理アクションハンドラ実装のテンプレートクラス。要件に応じて適切なものを選択すること。

| テンプレートクラス | 内容 |
|---|---|
| [BatchAction](handlers-BatchAction.md) | バッチ処理の実装において汎用的に利用できる標準実装。 |
| [FileBatchAction](handlers-FileBatchAction.md) | ファイルを入力とし、レコード種別（ヘッダー、データ、トレーラ等）ごとに業務処理を呼び分けたい場合に使用する。 |
| [NoInputDataBatchAction](handlers-NoInputDataBatchAction.md) | レコード1件ごとに業務処理を行うのではなく、一回だけ特定の処理を実行したい場合（アンロード処理などの単発処理）に使用する。 |

<details>
<summary>keywords</summary>

BatchAction, FileBatchAction, NoInputDataBatchAction, テンプレートクラス選択, バッチ処理用アクションハンドラのバリエーション

</details>

## 

なし

<details>
<summary>keywords</summary>

BatchAction, バッチ処理用アクションハンドラ

</details>

## 概要

[../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) における業務アクションハンドラを実装する際に使用するテンプレートクラス。

動作:
- [データリーダ](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) の `read()` メソッド（1トランザクション分のレコード読込み）と、本クラスの `handle()` メソッド（業務処理実行）を交互に呼び出す
- データリーダからレコードが読み込めなくなった時点で終了する
- 使用するデータリーダは `createReader()` の戻り値

<details>
<summary>keywords</summary>

BatchAction, データリーダ, createReader, handle, バッチ処理, DataReader, read

</details>

## 

本クラスを継承してアクションハンドラを実装する際のテンプレートメソッド:

| メソッド名 | 必須 | 内容 |
|---|---|---|
| `createReader()` | ○ | バッチの処理対象レコード読込みに使用する [データリーダ](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) を生成して返す |
| `handle()` | ○ | 処理対象レコード1件ごとに呼び出される。業務処理を実行し、正常時は `Result.Success` を返す |
| `transactionSuccess()` | | 業務トランザクションのコミット完了後にコールバックされる（デフォルト: 何もしない） |
| `transactionFailure()` | | 業務トランザクションのロールバック後にコールバックされる（デフォルト: 何もしない） |
| `initialize()` | | バッチ処理開始前に一度だけ呼ばれる（デフォルト: 何もしない） |
| `error()` | | 実行時例外/エラーでバッチがエラー終了した場合に一度だけコールバックされる（デフォルト: 何もしない） |
| `terminate()` | | バッチ処理終了後（正常・エラー問わず）に一度だけコールバックされる（デフォルト: 何もしない） |

各テンプレートメソッドの呼び出しタイミング（説明用疑似コード）:
```java
CommandLine      command;   // バッチ起動時のコマンドライン
ExecutionContext ctx;       // 実行コンテキスト

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

> **注意**: このコードはあくまで説明用に単純化したものであり、実際の処理フローはこのようなロジックでは無く、ハンドラ構成によって制御されており、全く別物である。

<details>
<summary>keywords</summary>

createReader, handle, transactionSuccess, transactionFailure, initialize, error, terminate, Result.Success, テンプレートメソッド, コールバック

</details>

## ハンドラ処理フロー

**[コールバック]**
1. **(バッチ処理開始前初期処理)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) 処理開始時に `initialize()` を実行する。
2. **(データリーダ生成)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) 処理開始時に `createReader()` を実行する。返された [データリーダ](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) は実行コンテキストに設定され、以降の処理で使用する。

**[往路処理]**
3. **(入力レコード1件に対する業務処理を実行)** 引数として渡された入力レコードに対する業務処理を実行する。

**[復路処理]**
4. **(正常終了)** 正常終了マーカーオブジェクト `Result.Success` をリターンする。

**[例外処理]**
4a. **(エラー終了)** 業務処理失敗時は実行時例外を送出する。

**[コールバック]**
5. **(業務トランザクション正常終了時の処理)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションが正常にコミットされた場合、`transactionSuccess()` を実行する。
5a. **(業務トランザクションロールバック時の処理)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、`transactionFailure()` を実行する。
6. **(バッチエラー終了時)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドがエラーにより停止した場合、`error()` を実行する。
7. **(バッチ終了時)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドが終了した場合、`terminate()` を実行する（エラー終了後でも6.の処理の後に呼ばれる）。

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, TransactionManagementHandler, initialize, createReader, transactionSuccess, transactionFailure, error, terminate, Result.Success, ハンドラ処理フロー

</details>
