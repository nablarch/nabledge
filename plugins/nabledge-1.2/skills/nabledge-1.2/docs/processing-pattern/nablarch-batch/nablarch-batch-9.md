# 入力データが存在しないバッチ処理はどのように作成するのでしょうか？

## 入力データが存在しないバッチ処理の実装

インプットデータが存在しないバッチ処理（業務日付更新処理、一括開閉局制御処理など）は、`nablarch.fw.action.NoInputDataBatchAction` を継承してバッチアクションクラスを実装する。`NoInputDataBatchAction` を継承した場合、`handle` メソッドが一度だけ実行されるため、必要な処理を `handle` メソッドに実装する。実装方法が不明な場合は、Nablarch Sample Project の `nablarch.sample.ss99ZZ.B99ZZ011Action` を参照。

<details>
<summary>keywords</summary>

NoInputDataBatchAction, nablarch.fw.action.NoInputDataBatchAction, handle, インプットデータなしバッチ, 業務日付更新処理, 一括開閉局制御処理, B99ZZ011Action, nablarch.sample.ss99ZZ.B99ZZ011Action, Nablarch Sample Project

</details>
