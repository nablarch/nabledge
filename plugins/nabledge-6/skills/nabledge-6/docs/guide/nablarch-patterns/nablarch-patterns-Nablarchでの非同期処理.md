# Nablarchでの非同期処理

## Nablarchでの非同期処理

Nablarch Webアプリで1リクエストの処理時間が長い場合、[テーブルをキューとして使ったメッセージング](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/index.html)と組み合わせることで非同期処理を実現できる。

処理フロー:
1. WebアプリがリクエストをDBに登録し、レスポンスを返却する
2. テーブルをキューとして使ったメッセージングがDB登録を検知し、当該データを処理する

## メール送信を行う場合

Nablarchの[メール送信](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/mail.html)機能は[常駐バッチ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html#nablarch-batch-resident-batch)を前提としている。

常駐バッチの問題: マルチスレッドで動かした場合、並列実行された全スレッドが終了するまで次のデータ登録の監視が始まらない。このため、新規プロジェクトでは常駐バッチよりテーブルをキューとして使ったメッセージングの使用が推奨されている。

ただし、メール送信はマルチスレッドを必要とする大量送信を想定していないため、メール送信には常駐バッチを使用して問題ない。
