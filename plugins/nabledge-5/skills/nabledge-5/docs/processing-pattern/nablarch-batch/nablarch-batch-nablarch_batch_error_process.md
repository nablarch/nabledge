# Nablarchバッチアプリケーションのエラー処理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details/nablarch_batch_error_process.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/TransactionAbnormalEnd.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html)

## バッチ処理をリランできるようにする

## バッチ処理をリランできるようにする

ファイル入力を除き、バッチ処理をリランできるようにする機能は提供していない。処理対象レコードにステータスを持たせ、処理成功・失敗時にステータスを変更するアプリケーション設計と実装が必要。実装方法は [loop_handler-callback](../../component/handlers/handlers-loop_handler.md) を参照。

ファイル入力の場合は、`ResumeDataReader (レジューム機能付き読み込み)` を使用することで、障害発生ポイントからの再実行が可能。

<details>
<summary>keywords</summary>

リラン, 再実行, ステータス管理, ファイル入力, ResumeDataReader

</details>

## バッチ処理でエラー発生時に処理を継続する

## バッチ処理でエラー発生時に処理を継続する

エラー発生時の処理継続は [常駐バッチ](nablarch-batch-architecture.md) のみ対応。[都度起動バッチ](nablarch-batch-architecture.md) は非対応。

[常駐バッチ](nablarch-batch-architecture.md) では `TransactionAbnormalEnd` を送出すると、[retry_handler](../../component/handlers/handlers-retry_handler.md) により処理が継続される。ただし、[nablarch_batch_error_process-rerun](#s1) に記載した内容で、バッチ処理がリランできるようになっている必要がある。

> **補足**: [都度起動バッチ](nablarch-batch-architecture.md) で `TransactionAbnormalEnd` が送出されると、バッチ処理が異常終了となる。

<details>
<summary>keywords</summary>

エラー処理継続, 常駐バッチ, 都度起動バッチ, TransactionAbnormalEnd, retry_handler

</details>

## バッチ処理を異常終了にする

## バッチ処理を異常終了にする

処理を継続せずに異常終了させたい場合は、`ProcessAbnormalEnd` を送出する。送出された場合のプロセス終了コードはこのクラスに指定された値となる。

<details>
<summary>keywords</summary>

異常終了, プロセス終了コード, ProcessAbnormalEnd

</details>
