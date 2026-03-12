# Example

**公式ドキュメント**: [Example](https://nablarch.github.io/docs/LATEST/doc/examples/index.html)

## 環境構築手順

> **補足**: ExampleはNablarchアプリケーションフレームワークの機能使用方法を示した実装例。本格的なアプリケーション作成には使用しないこと。本格的なアプリケーションは [blank_project](../../setup/blank-project/blank-project-blank_project.md) から作成すること。

ExampleはApache Mavenを使用してビルド・実行する。Apache MavenのPCへのインストール及び必要な設定は :ref:`maven` を参照すること。

<details>
<summary>keywords</summary>

Apache Maven, 環境構築, Exampleセットアップ, Mavenインストール, ビルド設定

</details>

## 実行手順

Exampleの実行手順は、各ExampleのGitHubリポジトリトップにあるREADMEを参照すること。

<details>
<summary>keywords</summary>

Example実行, GitHub README, アプリケーション起動

</details>

## Java 21 で動かす場合

ExampleはJava 17での実行を前提としている。Java 21で動かす場合は個別にセットアップが必要。詳細は :ref:`setup_blank_project_for_Java21` を参照。

<details>
<summary>keywords</summary>

Java 21, Java 17, JDK設定, Java 21セットアップ

</details>

## ウェブアプリケーション

- [ウェブアプリケーション (JSP)](https://github.com/nablarch/nablarch-example-web) (:ref:`解説 <getting_started>`)
- [ウェブアプリケーション (Thymeleaf)](https://github.com/nablarch/nablarch-example-thymeleaf-web) ([解説](../../component/adapters/adapters-web_thymeleaf_adaptor.md))

<details>
<summary>keywords</summary>

JSP, Thymeleaf, ウェブアプリケーション, nablarch-example-web, nablarch-example-thymeleaf-web

</details>

## ウェブサービス

- [RESTfulウェブサービス](https://github.com/nablarch/nablarch-example-rest) (:ref:`解説 <rest_getting_started>`)
- [HTTPメッセージング (受信)](https://github.com/nablarch/nablarch-example-http-messaging) (:ref:`解説 <http-messaging_getting_started>`)
- [HTTPメッセージング (送信)](https://github.com/nablarch/nablarch-example-http-messaging-send) ([解説](../../component/libraries/libraries-http_system_messaging.md))

<details>
<summary>keywords</summary>

RESTful, HTTPメッセージング, ウェブサービス, nablarch-example-rest, nablarch-example-http-messaging, nablarch-example-http-messaging-send

</details>

## バッチアプリケーション

- [Jakarta Batchに準拠したバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch-ee) (:ref:`解説 <jBatch_getting_started>`)
- [Nablarchバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch) (:ref:`解説 <nablarch_Batch_getting_started>`)

<details>
<summary>keywords</summary>

Jakarta Batch, Nablarchバッチ, バッチアプリケーション, nablarch-example-batch-ee, nablarch-example-batch

</details>

## メッセージング

- MOMによるメッセージング (:ref:`解説 <mom_messaging_getting_started>`)
  - [応答不要メッセージ送信](https://github.com/nablarch/nablarch-example-mom-delayed-send)
  - [同期応答メッセージ送信](https://github.com/nablarch/nablarch-example-mom-sync-send-batch)
  - [応答不要メッセージ受信](https://github.com/nablarch/nablarch-example-mom-delayed-receive)
  - [同期応答メッセージ受信](https://github.com/nablarch/nablarch-example-mom-sync-receive)
- [テーブルをキューとして使ったメッセージング](https://github.com/nablarch/nablarch-example-db-queue) (:ref:`解説 <db_messaging_getting_started>`)

<details>
<summary>keywords</summary>

MOMメッセージング, DBキュー, テーブルキュー, メッセージング, nablarch-example-mom, nablarch-example-db-queue

</details>
