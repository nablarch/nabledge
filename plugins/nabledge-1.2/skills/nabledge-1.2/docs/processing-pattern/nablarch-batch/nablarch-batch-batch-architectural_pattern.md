# バッチ実行制御基盤

## バッチ実行制御基盤

[batch](nablarch-batch-batch-architectural_pattern.md) は、以下の2種類に分かれる。

- [batch_single_shot](nablarch-batch-batch_single_shot.md): DBやファイルのデータレコード1件ごとに業務処理を繰り返し実行する基本的なバッチ処理。
- [batch_resident](nablarch-batch-batch_resident.md): 一定間隔ごとにバッチ処理を実行する常駐型プロセス。オンライン処理で作成されたトランザクションデータを定期的に一括処理するようなケースで使用する。

<details>
<summary>keywords</summary>

バッチ実行制御, シングルショットバッチ, 常駐バッチ, バッチ処理, batch_single_shot, batch_resident

</details>
