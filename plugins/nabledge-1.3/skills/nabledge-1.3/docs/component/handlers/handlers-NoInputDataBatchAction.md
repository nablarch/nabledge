# 入力データを使用しないバッチ処理用業務アクションハンドラのテンプレートクラス

## 概要

**クラス名**: `nablarch.fw.action.NoInputDataBatchAction`

[../architectural_pattern/batch_single_shot](../../processing-pattern/nablarch-batch/nablarch-batch-batch_single_shot.md) において、一括データ削除クリーニングバッチのように単発処理を実行するバッチを実装する場合に使用するアクションハンドラのテンプレートクラス。ダミーデータリーダーを使用することにより、アクションハンドラを1度だけ実行させる。

継承して実装するテンプレートメソッド:

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| `handle(ctx)` | 必須 | 業務処理を実装。[BatchAction](handlers-BatchAction.md) と異なりデータリーダーを使用せず常に1度だけ呼ばれる。引数は実行コンテキストのみ。(オーバーロード: `BatchAction` の `handle(InputData data, ExecutionContext ctx)` をオーバーロードしたメソッド) |
| `initialize(command, ctx)` | 任意 | バッチ処理開始前に一度だけ呼ばれる。デフォルト: 何もしない |
| `error(e, ctx)` | 任意 | 実行時例外/エラーでバッチエラー終了した場合に一度だけコールバック。デフォルト: 何もしない |
| `terminate(result, ctx)` | 任意 | バッチが全件終了またはエラー終了後に一度だけコールバック。デフォルト: 何もしない |

<details>
<summary>keywords</summary>

NoInputDataBatchAction, nablarch.fw.action.NoInputDataBatchAction, handle(), initialize(), error(), terminate(), バッチシングルショット, 入力データなしバッチ, ダミーデータリーダ, テンプレートメソッド, BatchAction, オーバーロード

</details>

## ハンドラ処理フロー

1. **[コールバック] バッチ処理開始前初期処理**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に `initialize()` を実行
2. **[コールバック] データリーダ生成**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のコールバックでダミーデータリーダを作成。1度だけダミー読込みを行い、以降はデータリーダがクローズされた場合と同じ動作となる。これによりアクションハンドラが1度だけ実行される
3. **[往路処理] 業務処理を実行**
4. **[復路処理] 正常終了**: 正常終了を表すマーカオブジェクト `Result.Success` をリターン
4a. **[例外処理] エラー終了**: 業務処理に失敗した場合は実行時例外を送出
5. **[コールバック] バッチエラー終了時**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドがエラーにより停止した場合、`error()` を実行
6. **[コールバック] バッチ終了時**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドが終了した場合、`terminate()` を実行(エラー終了でも 5. の処理の後で呼ばれる)

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, initialize(), error(), terminate(), Result.Success, ダミーデータリーダ, バッチ処理フロー, コールバック処理

</details>
