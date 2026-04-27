# Example

Exampleは、Nablarchアプリケーションフレームワークの機能の使用方法を示した実装例であり、 [実行制御基盤](../../about/about-nablarch/about-nablarch-big-picture.md#runtime-platform) 毎に作成している。
本章では、Exampleに必要な環境構築手順と、アプリケーションの実行手順を解説する。

> **Tip:**
> Exampleを改修して本格的なアプリケーションを作成することは想定していない。

> 本格的なアプリケーションを作成する場合は [ブランクプロジェクト](../../setup/blank-project/blank-project-blank-project.md#blank-project) から作成すること。

## Exampleの実行方法

### 環境構築手順

Exampleは、Apache Mavenを使用してアプリケーションをビルド、実行する。以下のページを参考に、ApacheMavenのPCへのインストール及び必要な設定を行うこと。

[Apache Mavenについて](../../setup/blank-project/blank-project-maven.md#maven)

### 実行手順

Exampleの実行手順は、各ExampleのGitHubリポジトリトップにあるREADMEを参照すること。

### Java 21 で動かす場合

ExampleはJava 17での実行を前提としている。
Java 21で動かす場合は、個別にセットアップが必要となる。
詳細は、以下のブランクプロジェクトの説明を参照のこと。

[Java21で使用する場合のセットアップ方法](../../setup/blank-project/blank-project-setup-Java21.md#setup-blank-project-for-java21)

## Exampleの一覧

実行制御基盤毎のExampleを以下に示す。実装の解説も用意しているので、必要に応じて、以下一覧の「解説」リンクより参照すること。

### ウェブアプリケーション

* [ウェブアプリケーション (JSP)](https://github.com/nablarch/nablarch-example-web) ([解説](../../processing-pattern/web-application/web-application-getting-started.md#getting-started))
* [ウェブアプリケーション (Thymeleaf)](https://github.com/nablarch/nablarch-example-thymeleaf-web) ([解説](../../component/adapters/adapters-web-thymeleaf-adaptor.md#web-thymeleaf-adaptor))

### ウェブサービス

* [RESTfulウェブサービス](https://github.com/nablarch/nablarch-example-rest) ([解説](../../processing-pattern/restful-web-service/restful-web-service-getting-started.md#rest-getting-started))
* [HTTPメッセージング (受信)](https://github.com/nablarch/nablarch-example-http-messaging) ([解説](../../processing-pattern/http-messaging/http-messaging-getting-started.md#http-messaging-getting-started))
* [HTTPメッセージング (送信)](https://github.com/nablarch/nablarch-example-http-messaging-send) ([解説](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-message-send))

### バッチアプリケーション

* [Jakarta Batchに準拠したバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch-ee) ([解説](../../processing-pattern/jakarta-batch/jakarta-batch-getting-started.md#jbatch-getting-started))
* [Nablarchバッチアプリケーション](https://github.com/nablarch/nablarch-example-batch) ([解説](../../processing-pattern/nablarch-batch/nablarch-batch-getting-started.md#nablarch-batch-getting-started))

### メッセージング

* MOMによるメッセージング ([解説](../../processing-pattern/mom-messaging/mom-messaging-getting-started.md#mom-messaging-getting-started))

  * [応答不要メッセージ送信](https://github.com/nablarch/nablarch-example-mom-delayed-send)
  * [同期応答メッセージ送信](https://github.com/nablarch/nablarch-example-mom-sync-send-batch)
  * [応答不要メッセージ受信](https://github.com/nablarch/nablarch-example-mom-delayed-receive)
  * [同期応答メッセージ受信](https://github.com/nablarch/nablarch-example-mom-sync-receive)
* [テーブルをキューとして使ったメッセージング](https://github.com/nablarch/nablarch-example-db-queue) ([解説](../../processing-pattern/db-messaging/db-messaging-getting-started.md#db-messaging-getting-started))
