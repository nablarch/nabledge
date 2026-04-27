# バッチ実行制御基盤

batch_single_shot
batch_resident
batch_resident_thread_sync

[バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) は、大きく以下の2つに分かれる。

* [都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md)
* [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md)

[都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md) は、
DBやファイルに格納されたデータレコード1件ごとに業務処理を繰り返し実行する基本的なバッチ処理の仕組みを提供する。

[常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) は、要求データを随時処理する常駐型バッチ処理の仕組みを提供する。
例えば、オンライン処理で作成されたトランザクションデータを随時処理するような場合に使用される。
