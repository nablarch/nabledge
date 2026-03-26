# 入力データが存在しないバッチ処理はどのように作成するのでしょうか？

## 入力データが存在しないバッチ処理の実装方法

インプットデータが存在しないバッチ処理（業務日付更新処理、一括開閉局制御処理など）は、`nablarch.fw.action.NoInputDataBatchAction` を継承してバッチアクションクラスを実装する。

**クラス**: `nablarch.fw.action.NoInputDataBatchAction`

`NoInputDataBatchAction` を継承した場合、`handle` メソッドが一度だけ実行される。必要な処理を `handle` メソッドに実装すること。

実装方法が不明な場合は、チュートリアルに含まれている下記クラスを参照すること。

- `please.change.me.tutorial.ss99ZZ.B99ZZ011Action`

<details>
<summary>keywords</summary>

NoInputDataBatchAction, nablarch.fw.action.NoInputDataBatchAction, handle, インプットデータなしバッチ処理, 業務日付更新処理, 一括開閉局制御処理, NoInputDataBatchAction継承, B99ZZ011Action, please.change.me.tutorial.ss99ZZ.B99ZZ011Action

</details>
