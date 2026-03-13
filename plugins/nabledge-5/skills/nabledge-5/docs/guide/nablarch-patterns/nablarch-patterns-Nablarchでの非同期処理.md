# Nablarchでの非同期処理

**公式ドキュメント**: [1](https://fintan.jp/page/252/) [2](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/index.html) [3](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/mail.html) [4](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html#nablarch-batch-resident-batch)

## 非同期処理の実現パターン

NablarchのWebアプリケーションで非同期処理を実現するには、[テーブルをキューとして使ったメッセージング](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/index.html)を組み合わせる。

実現パターン:
1. WebアプリはリクエストをDBに登録してレスポンスを返却する
2. テーブルをキューとして使ったメッセージングがDB登録を検知し、当該データを処理する

![非同期処理シーケンス](../../../knowledge/guide/nablarch-patterns/assets/nablarch-patterns-Nablarchでの非同期処理/nablarch-async-pattern.png)

<details>
<summary>keywords</summary>

非同期処理, テーブルをキューとして使ったメッセージング, Webアプリケーション, DBキュー, メッセージング

</details>

## メール送信を行う場合

Nablarchの[メール送信](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/mail.html)機能は[常駐バッチ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html#nablarch-batch-resident-batch)を前提としている。

> **注意**: 常駐バッチはマルチスレッドで動かした場合、並列実行された全スレッドが終了するまで次のデータ登録の監視が始まらない問題がある。このため新規プロジェクトでは常駐バッチよりテーブルをキューとして使ったメッセージングが推奨される。

ただし、メール送信はマルチスレッドを必要とする大量送信には使用しない前提のため、メール送信には常駐バッチを使って問題ない。

<details>
<summary>keywords</summary>

メール送信, 常駐バッチ, テーブルをキューとして使ったメッセージング, 非同期処理, マルチスレッド

</details>
