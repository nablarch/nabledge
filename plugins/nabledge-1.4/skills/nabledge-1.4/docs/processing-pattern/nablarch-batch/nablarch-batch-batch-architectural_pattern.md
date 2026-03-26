# バッチ実行制御基盤

## バッチ実行制御基盤の概要

バッチ処理は以下の2つに分かれる。

- [batch_single_shot](nablarch-batch-batch_single_shot.md): DBやファイルに格納されたデータレコード1件ごとに業務処理を繰り返し実行する基本的なバッチ処理
- [batch_resident](nablarch-batch-batch_resident.md): 要求データを随時処理する常駐型バッチ処理。オンライン処理で作成されたトランザクションデータを随時処理するような場合に使用する

<details>
<summary>keywords</summary>

バッチ実行制御基盤, シングルショットバッチ, 常駐型バッチ, バッチ処理パターン, batch_single_shot, batch_resident, batch_resident_thread_sync

</details>
