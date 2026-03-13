# Example

**公式ドキュメント**: [Example](https://nablarch.github.io/docs/LATEST/doc/examples/index.html)

## 環境構築手順

> **補足**: Exampleを改修して本格的なアプリケーションを作成することは想定していない。本格的なアプリケーションを作成する場合は [blank_project](../../setup/blank-project/blank-project-blank_project.md) から作成すること。

ExampleはApache Mavenを使用してビルド・実行する。インストールと設定は :ref:`maven` を参照。

<details>
<summary>keywords</summary>

Apache Maven, ビルド環境構築, Exampleセットアップ, Maven設定, blank_project

</details>

## 実行手順

Exampleの実行手順は、各ExampleのGitHubリポジトリトップにあるREADMEを参照すること。

<details>
<summary>keywords</summary>

Exampleアプリケーション実行, GitHubリポジトリ, README

</details>

## Java 11 以上で動かす場合

ExampleはJava 8での実行を前提としている。Java 11以上で動かす場合は依存ライブラリの修正が必要。

詳細は以下を参照:
- :ref:`setup_blank_project_for_Java11`
- :ref:`setup_blank_project_for_Java17`
- :ref:`setup_blank_project_for_Java21`

<details>
<summary>keywords</summary>

Java 11, Java 17, Java 21, 依存ライブラリ修正, Javaバージョン対応

</details>

## ウェブアプリケーション

- [ウェブアプリケーション (JSP)](https://github.com/nablarch/nablarch-example-web) (:ref:`解説 <getting_started>`)
- [ウェブアプリケーション (Thymeleaf)](https://github.com/nablarch/nablarch-example-thymeleaf-web) ([解説](../../component/adapters/adapters-web_thymeleaf_adaptor.md))

<details>
<summary>keywords</summary>

JSP, Thymeleaf, ウェブアプリケーションExample, nablarch-example-web, nablarch-example-thymeleaf-web

</details>

## ウェブサービス

- [RESTfulウェブサービス](https://github.com/nablarch/nablarch-example-rest) (:ref:`解説 <rest_getting_started>`)
- [HTTPメッセージング (受信)](https://github.com/nablarch/nablarch-example-http-messaging) (:ref:`解説 <http-messaging_getting_started>`)
- [HTTPメッセージング (送信)](https://github.com/nablarch/nablarch-example-http-messaging-send) ([解説](../../component/libraries/libraries-http_system_messaging.md))

<details>
<summary>keywords</summary>

RESTful, HTTPメッセージング, ウェブサービスExample, nablarch-example-rest, nablarch-example-http-messaging

</details>

## バッチアプリケーション

- [JSR352に準拠したバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch-ee) (:ref:`解説 <jBatch_getting_started>`)
- [Nablarchバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch) (:ref:`解説 <nablarch_Batch_getting_started>`)

<details>
<summary>keywords</summary>

JSR352, バッチアプリケーション, nablarch-example-batch-ee, nablarch-example-batch

</details>

## メッセージング

MOMによるメッセージング (:ref:`解説 <mom_messaging_getting_started>`):
- [応答不要メッセージ送信](https://github.com/nablarch/nablarch-example-mom-delayed-send)
- [同期応答メッセージ送信](https://github.com/nablarch/nablarch-example-mom-sync-send-batch)
- [応答不要メッセージ受信](https://github.com/nablarch/nablarch-example-mom-delayed-receive)
- [同期応答メッセージ受信](https://github.com/nablarch/nablarch-example-mom-sync-receive)

[テーブルをキューとして使ったメッセージング](https://github.com/nablarch/nablarch-example-db-queue) (:ref:`解説 <db_messaging_getting_started>`)

<details>
<summary>keywords</summary>

MOM, メッセージング, 応答不要メッセージ, 同期応答メッセージ, テーブルキュー, nablarch-example-db-queue

</details>
