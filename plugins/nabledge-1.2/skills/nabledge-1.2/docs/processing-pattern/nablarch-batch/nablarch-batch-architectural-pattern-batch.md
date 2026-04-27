# バッチ実行制御基盤

batch_single_shot
batch_resident

[バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) は、大きく以下の2つに分かれる。

* [都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md)
* [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md)

[都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md) は、
DBやファイルに格納されたデータレコード1件ごとに業務処理を繰り返し実行する基本的なバッチ処理の仕組みを提供する。

[常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) では、一定間隔ごとにバッチ処理を実行する常駐型プロセスを作成するための制御基盤を提供する。
例えば、オンライン処理で作成されたトランザクションデータを定期的に一括処理するような場合に使用される。
