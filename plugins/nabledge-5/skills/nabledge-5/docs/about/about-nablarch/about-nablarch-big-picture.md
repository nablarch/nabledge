# 全体像

Nablarchアプリケーションフレームワークの全体像を以下に示す。

![framework.png](../../../knowledge/assets/about-nablarch-big-picture/framework.png)

Nablarchアプリケーションフレームワークは、ウェブやバッチといった処理方式に合わせた実行制御基盤と、
データベースアクセスやバリデーションといった個別の機能を提供するライブラリから構成される。

Nablarchアプリケーションフレームワークは、以下の特長がある。

様々な処理方式に対応できる
Nablarchアプリケーションフレームワークでは、
実行制御基盤および [ライブラリ](../../component/libraries/libraries-libraries.md#library) を組み合わせることにより、
様々な処理方式に対応できる。

実行制御基盤
* [ウェブアプリケーション編](../../processing-pattern/web-application/web-application-web.md#web-application)
* [ウェブサービス編](../../processing-pattern/restful-web-service/restful-web-service-web-service.md#web-service)
* [バッチアプリケーション編](../../processing-pattern/nablarch-batch/nablarch-batch-batch.md#batch-application)
* [メッセージング編](../../processing-pattern/db-messaging/db-messaging-messaging.md#messaging)
すべての実行制御基盤で共通のアーキテクチャを採用している
[共通アーキテクチャ](../../about/about-nablarch/about-nablarch-architecture.md#nablarch-architecture) では、
パイプライン型の処理モデルに従ってすべてのデータ処理を行う。
特に複数の処理方式を組み合わせて構築するシステムは、
[共通アーキテクチャ](../../about/about-nablarch/about-nablarch-architecture.md#nablarch-architecture) によって、以下のメリットを享受できる。

柔軟な機能追加・変更
パイプライン型の処理モデルでは、パイプラインの構成要素であるハンドラの差し替えを容易に行うことができる。
これにより、機能追加・変更要求に対して、非常に柔軟な対応が可能となる。
また、ハンドラは処理方式間での共有が可能なので、
従来の開発のように処理方式ごとに同じ機能を重複して作成する必要がない。
開発方法の共通化
各実行制御基盤上で動作するアプリケーションは、ほぼ同様の方法で作成・テストできるので、
ある処理方式で開発してスキルを身につけた開発者は、
最小限の学習で他の処理方式でも開発できる。
これにより、開発者の生産性向上・学習コスト低減を実現でき、
また、開発要員の確保も容易になる。
