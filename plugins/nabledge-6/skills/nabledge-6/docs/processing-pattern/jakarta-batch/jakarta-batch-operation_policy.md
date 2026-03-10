# 運用方針

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/operation_policy.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/JobExecutor.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/Main.html)

## 運用方針の概要

Jakarta Batchに準拠したバッチアプリケーションでは、以下の方針に従った障害監視、ログ出力方針を推奨している。

- 障害監視はバッチの終了ステータスで行う（:ref:`jsr352-failure_monitoring` 参照）
- 予期できる障害（取り込みファイル不在等）のリカバリ用に、運用担当者向けログを出力する
- 予期できない障害（アプリケーション不具合等）の調査用に、全てのログを出力する（例外発生時のログ出力: :ref:`jsr352-batch_error_flow` 参照）
- バッチ処理遅延時の終了時刻予測のため、進捗ログを出力する

これらの方針に従うことで以下のメリットが得られる。障害発生時や顧客の問い合わせ対応に対して運用担当者のみで対応できることが増え、開発者の運用負荷の軽減が期待できる。

- 障害発生時に運用担当者向けログにリカバリ手順を出力しておけば、運用担当者がリカバリを行うことができる
- 進捗ログを出力しておけば、開発者が別の手段で進捗状況を確認する必要がなくなり、運用担当者は進捗ログを参照して終了予定時間を顧客に回答できる

> **重要**: バッチの設計者は予期できる障害とその対処方法を洗い出し、[運用担当者向けログ](jakarta-batch-operator_notice_log.md) に出力するようにバッチを設計すること。

![障害検知時のログ参照イメージ](../../knowledge/processing-pattern/jakarta-batch/assets/jakarta-batch-operation_policy/operation-image.png)

![バッチ処理遅延時のログ参照イメージ](../../knowledge/processing-pattern/jakarta-batch/assets/jakarta-batch-operation_policy/progress-image.png)

<details>
<summary>keywords</summary>

運用方針, operator_notice_log, jsr352-batch_error_flow, 運用担当者向けログ, 進捗ログ, リカバリ, 運用負荷軽減, メリット, 障害監視方針

</details>

## 障害監視

バッチの終了ステータスをもとに障害監視する。

| 終了ステータス | 意味 | 対応 |
|---|---|---|
| 正常終了 | バッチ処理が正常に終了 | — |
| 異常終了 | 何らかの理由で異常終了し、後続のジョブが実行できない | 運用担当者がログを参照し障害対応 |
| 警告終了 | 何らかの問題が発生したが、後続のジョブは実行できる | 運用担当者がログを参照し問題内容を確認 |

終了ステータス（Javaプロセスのリターンコード）の詳細: `JobExecutor` および `Main`

> **補足**: 終了コードをさらに細かく分類したい場合は、起動クラス（Main）を独自に作成して対応する。

<details>
<summary>keywords</summary>

JobExecutor, Main, nablarch.fw.batch.ee.JobExecutor, nablarch.fw.batch.ee.Main, 障害監視, 終了ステータス, 異常終了, 警告終了, 正常終了, リターンコード, jsr352-failure_monitoring

</details>

## ログの出力方針

| ログ種別 | 内容 | 詳細 |
|---|---|---|
| 運用担当者向けログ | 発生した障害とその対処方法を記載したメッセージを出力。スタックトレース等の詳細情報は含まない | [operator_notice_log](jakarta-batch-operator_notice_log.md) 参照 |
| 進捗ログ | バッチ処理の進捗状況を出力。遅延時に終了予測と続行/停止判断に使用 | [progress_log](jakarta-batch-progress_log.md) 参照 |
| 全てのログ | 進捗ログを除く全てのログを出力。運用担当者向けログに対応する詳細情報（スタックトレース）も含む | — |

<details>
<summary>keywords</summary>

運用担当者向けログ, 進捗ログ, スタックトレース, ログ出力方針, バッチ処理遅延, 全てのログ

</details>
