# Example

## 環境構築手順

> **補足**: ExampleはNablarchアプリケーションフレームワークの機能使用方法を示した実装例。本格的なアプリケーション作成には使用しないこと。本格的なアプリケーションは :ref:`blank_project` から作成すること。

ExampleはApache Mavenを使用してビルド・実行する。Apache MavenのPCへのインストール及び必要な設定は :ref:`maven` を参照すること。

## 実行手順

Exampleの実行手順は、各ExampleのGitHubリポジトリトップにあるREADMEを参照すること。

## Java 21 で動かす場合

ExampleはJava 17での実行を前提としている。Java 21で動かす場合は個別にセットアップが必要。詳細は :ref:`setup_blank_project_for_Java21` を参照。

## ウェブアプリケーション

- [ウェブアプリケーション (JSP)](https://github.com/nablarch/nablarch-example-web) (:ref:`解説 <getting_started>`)
- [ウェブアプリケーション (Thymeleaf)](https://github.com/nablarch/nablarch-example-thymeleaf-web) (:ref:`解説 <web_thymeleaf_adaptor>`)

## ウェブサービス

- [RESTfulウェブサービス](https://github.com/nablarch/nablarch-example-rest) (:ref:`解説 <rest_getting_started>`)
- [HTTPメッセージング (受信)](https://github.com/nablarch/nablarch-example-http-messaging) (:ref:`解説 <http-messaging_getting_started>`)
- [HTTPメッセージング (送信)](https://github.com/nablarch/nablarch-example-http-messaging-send) (:ref:`解説 <http_system_messaging-message_send>`)

## バッチアプリケーション

- [Jakarta Batchに準拠したバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch-ee) (:ref:`解説 <jBatch_getting_started>`)
- [Nablarchバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch) (:ref:`解説 <nablarch_Batch_getting_started>`)

## メッセージング

- MOMによるメッセージング ([解説](mom-messaging-getting_started.md))
  - [応答不要メッセージ送信](https://github.com/nablarch/nablarch-example-mom-delayed-send)
  - [同期応答メッセージ送信](https://github.com/nablarch/nablarch-example-mom-sync-send-batch)
  - [応答不要メッセージ受信](https://github.com/nablarch/nablarch-example-mom-delayed-receive)
  - [同期応答メッセージ受信](https://github.com/nablarch/nablarch-example-mom-sync-receive)
- [テーブルをキューとして使ったメッセージング](https://github.com/nablarch/nablarch-example-db-queue) ([解説](db-messaging-getting_started.md))
