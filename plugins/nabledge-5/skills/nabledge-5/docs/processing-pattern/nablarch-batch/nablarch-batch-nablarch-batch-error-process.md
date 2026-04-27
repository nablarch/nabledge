# Nablarchバッチアプリケーションのエラー処理

**目次**

* バッチ処理をリランできるようにする
* バッチ処理でエラー発生時に処理を継続する
* バッチ処理を異常終了にする

## バッチ処理をリランできるようにする

Nablarchバッチアプリケーションでは、ファイル入力を除き、
バッチ処理をリランできるようにする機能を提供していない。

そのため、処理対象レコードにステータスを持たせ、
処理成功や失敗時にステータスを変更するといった、
アプリケーションでの設計と実装が必要となる。
処理成功や失敗時のステータス変更の実装方法については、
[トランザクション終了時に任意の処理を実行したい](../../component/handlers/handlers-loop-handler.md#loop-handler-callback) を参照。

ファイル入力については、
ResumeDataReader (レジューム機能付き読み込み)
を使用することで、障害発生ポイントからの再実行ができる。

## バッチ処理でエラー発生時に処理を継続する

エラー発生時の処理継続は、 [常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-resident-batch) のみ対応している。
[都度起動バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-each-time-batch) は対応していない。

[常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-resident-batch) では、
TransactionAbnormalEnd
を送出すると、 [リトライハンドラ](../../component/handlers/handlers-retry-handler.md#retry-handler) により処理が継続される。
ただし、 [バッチ処理をリランできるようにする](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-error-process.md#nablarch-batch-error-process-rerun) に記載した内容で、
バッチ処理がリランできるようになっている必要がある。

> **Tip:**
> [都度起動バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-each-time-batch) で
> TransactionAbnormalEnd
> が送出されると、バッチ処理が異常終了となる。

## バッチ処理を異常終了にする

アプリケーションでエラーを検知した場合に、
処理を継続せずにバッチ処理を異常終了させたい場合がある。

Nablarchバッチアプリケーションでは、
ProcessAbnormalEnd
を送出すると、バッチ処理を異常終了にできる。
ProcessAbnormalEnd
が送出された場合、プロセス終了コードはこのクラスに指定された値となる。
