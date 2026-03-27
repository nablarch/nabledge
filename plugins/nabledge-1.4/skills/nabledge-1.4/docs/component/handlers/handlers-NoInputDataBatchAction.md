# 入力データを使用しないバッチ処理用業務アクションハンドラのテンプレートクラス

## 

**クラス名**: `nablarch.fw.action.NoInputDataBatchAction`

<details>
<summary>keywords</summary>

NoInputDataBatchAction, nablarch.fw.action.NoInputDataBatchAction, バッチアクションハンドラ, テンプレートクラス, 入力データなしバッチ

</details>

## 概要

[../architectural_pattern/batch_single_shot](../../processing-pattern/nablarch-batch/nablarch-batch-batch_single_shot.md) において、一括データ削除のようなクリーニングバッチ（単発処理）を実装するためのアクションハンドラテンプレートクラス。一度だけダミー読込みを行うデータリーダを使用することで、アクションハンドラが1回だけ実行される。

<details>
<summary>keywords</summary>

NoInputDataBatchAction, シングルショットバッチ, ダミーデータリーダ, クリーニングバッチ, 単発処理バッチ, 入力データなしバッチ

</details>

## 

本クラスを継承して実装するテンプレートメソッド:

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| handle() | 必須 | 業務処理を実装。[BatchAction](handlers-BatchAction.md) とは異なりデータリーダーを使用せず、常に1度だけ呼ばれる。引数は実行コンテキストのみ（オーバーロード）。 |
| initialize() | 任意 | バッチ処理開始前に一度だけ呼ばれる。デフォルトでは何もしない。 |
| error() | 任意 | 実行時例外/エラー発生によりバッチがエラー終了した場合に一度だけコールバック。デフォルトでは何もしない。 |
| terminate() | 任意 | バッチ処理が全件終了またはエラー終了後に一度だけコールバック。デフォルトでは何もしない。 |

各テンプレートメソッドの呼び出しタイミング:

```java
CommandLine command;      // バッチ起動時のコマンドライン
ExecutionContext ctx;      // 実行コンテキスト

initialize(command, ctx); // バッチ処理開始前に一度だけ呼ばれる。

Result result = null;

try {
    result = handle(ctx); // 業務処理を実行。
    commit();             // 業務トランザクションをコミット

} catch(e) {
    rollback();           // 業務トランザクションをロールバック
    error(e, ctx);        // バッチがエラー終了した場合に、一度だけ呼ばれる。

} finally {
    terminate(result, ctx); // バッチが終了した後、一度だけ呼ばれる。
}
```

> **注意**: このコードは説明用に単純化したものであり、実際の処理フローはハンドラ構成によって制御される。

<details>
<summary>keywords</summary>

handle(), initialize(), error(), terminate(), テンプレートメソッド, コールバックメソッド, BatchAction

</details>

## ハンドラ処理フロー

**[コールバック]**

1. (バッチ処理開始前初期処理): [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に `initialize()` を実行する。
2. (データリーダ生成): [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のコールバックでダミーのデータリーダを作成して返す。このデータリーダでは1度だけダミーの読込みを行い、それ以降はデータリーダがクローズされた場合と同じ動作となる。これによりアクションハンドラが1度だけ実行される。

**[往路処理]**

3. (業務処理を実行): 業務処理を実行する。

**[復路処理]**

4. (正常終了): 正常終了を表すマーカオブジェクト (`Result.Success`) をリターンする。

**[例外処理]**

4a. (エラー終了): 業務処理に失敗した場合は、実行時例外を送出する。

**[コールバック]**

5. (バッチエラー終了時): [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドがエラーにより停止した場合、本ハンドラの `error()` を実行する。
6. (バッチ終了時): [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドが終了した場合、本ハンドラの `terminate()` を実行する。（このコールバックは、バッチがエラー終了した場合でも、**6.** の処理の後で呼ばれる。）

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, ハンドラ処理フロー, ダミーデータリーダ生成, initialize, error, terminate, バッチ処理フロー, Result.Success

</details>
