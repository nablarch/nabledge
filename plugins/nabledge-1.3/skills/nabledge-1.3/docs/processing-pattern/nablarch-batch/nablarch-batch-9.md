# 入力データが存在しないバッチ処理はどのように作成するのでしょうか？

## 入力データが存在しないバッチ処理の実装方法

インプットデータが存在しないバッチ処理（業務日付更新、一括開閉局制御など）は `NoInputDataBatchAction` を継承してバッチアクションクラスを実装する。継承した場合、`handle` メソッドが一度だけ実行されるため、必要な処理を `handle` メソッドに実装する。

**クラス**: `nablarch.fw.action.NoInputDataBatchAction`

実装例: `nablarch.sample.ss99ZZ.B99ZZ011Action`

<details>
<summary>keywords</summary>

NoInputDataBatchAction, nablarch.fw.action.NoInputDataBatchAction, handle, B99ZZ011Action, インプットデータなしバッチ, 入力データなしバッチ処理

</details>
