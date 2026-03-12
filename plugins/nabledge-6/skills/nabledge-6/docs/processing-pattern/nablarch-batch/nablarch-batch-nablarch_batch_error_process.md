# Nablarchバッチアプリケーションのエラー処理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details/nablarch_batch_error_process.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/TransactionAbnormalEnd.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html)

## バッチ処理をリランできるようにする

ファイル入力を除き、バッチ処理をリランできるようにする機能は提供されていない。処理対象レコードにステータスを持たせ、処理成功・失敗時にステータスを変更するアプリケーション設計と実装が必要。ステータス変更の実装方法は [loop_handler-callback](../../component/handlers/handlers-loop_handler.md) を参照。

ファイル入力の場合は `ResumeDataReader` を使用することで、障害発生ポイントからの再実行が可能。

<details>
<summary>keywords</summary>

ResumeDataReader, nablarch.fw.reader.ResumeDataReader, リラン, 再実行, ステータス管理, ファイル入力, 障害復旧

</details>

## バッチ処理でエラー発生時に処理を継続する

エラー発生時の処理継続は [常駐バッチ](nablarch-batch-architecture.md) のみ対応。[都度起動バッチ](nablarch-batch-architecture.md) は対応していない。

[常駐バッチ](nablarch-batch-architecture.md) では `TransactionAbnormalEnd` を送出すると、[retry_handler](../../component/handlers/handlers-retry_handler.md) により処理が継続される。ただし、[nablarch_batch_error_process-rerun](#s1) に記載の通り、バッチ処理がリランできる設計になっている必要がある。

> **補足**: [都度起動バッチ](nablarch-batch-architecture.md) で `TransactionAbnormalEnd` が送出されると、バッチ処理が異常終了となる。

<details>
<summary>keywords</summary>

TransactionAbnormalEnd, nablarch.fw.results.TransactionAbnormalEnd, エラー継続, 常駐バッチ, 都度起動バッチ, retry_handler, 処理継続

</details>

## バッチ処理を異常終了にする

`ProcessAbnormalEnd` を送出するとバッチ処理を異常終了にできる。送出された場合のプロセス終了コードはこのクラスに指定された値となる。

<details>
<summary>keywords</summary>

ProcessAbnormalEnd, nablarch.fw.launcher.ProcessAbnormalEnd, 異常終了, プロセス終了コード, バッチ異常終了

</details>
