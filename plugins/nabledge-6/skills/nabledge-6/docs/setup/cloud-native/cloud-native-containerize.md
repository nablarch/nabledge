# Dockerコンテナ化

**公式ドキュメント**: [Dockerコンテナ化](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/cloud_native/containerize/index.html)

## クラウド環境に適したシステムに必要なこと

**クラウドネイティブ**とは、AWSなどのクラウド環境で動かすことを前提とし、クラウド環境に最適化して開発されたシステムのことを指す。スケーラビリティを持たせるため、アプリケーションが状態を持たないようにするといった対応が必要となる。

**[The Twelve-Factor App](https://12factor.net/ja/)** は、クラウド環境に適したシステムを開発するときに考慮すべきことを12の要素にまとめた方法論（[Heroku](https://jp.heroku.com/)のエンジニアが提唱）。本章で説明するNablarchアプリケーションの修正内容は、The Twelve-Factor Appの方法をもとにしている。

<details>
<summary>keywords</summary>

クラウドネイティブ, The Twelve-Factor App, ステートレス, スケーラビリティ, クラウド環境最適化

</details>

## Nablarchウェブアプリケーションに必要な修正

:ref:`標準のウェブアプリケーションのブランクプロジェクト <firstStepGenerateWebBlankProject>` を使ったNablarchウェブアプリケーションには、以下の修正が必要。

**ステートレス化**
[The Twelve-Factor App VI. プロセス](https://12factor.net/ja/processes)では、アプリケーションはステートレスでなければならないとされている。標準ブランクプロジェクトはHTTPセッションを使った状態管理が有効なため、この方針に反している。
設定方法: :ref:`stateless_web_app`

**ログ出力**
[The Twelve-Factor App XI. ログ](https://12factor.net/ja/logs)では、ログはすべて標準出力に書き出し、ファイルには出力すべきでないとされている。標準ブランクプロジェクトはロガーの出力先にファイルが指定されているため、この方針に反している。
設定方法: [log-basic_setting](../../component/libraries/libraries-log.md)

**環境変数を使った設定**
[The Twelve-Factor App III. 設定](https://12factor.net/ja/config)では、環境ごとに切り替える設定（他サービスとの接続設定など）は環境変数から設定すべきとされている。標準ブランクプロジェクトはMavenのプロファイルで切り替えているため、この方針に反している。
設定方法: [repository-overwrite_environment_configuration_by_os_env_var](../../component/libraries/libraries-repository.md)

<details>
<summary>keywords</summary>

ステートレス化, HTTPセッション, ログ標準出力, 環境変数設定, Mavenプロファイル, stateless_web_app, log-basic_setting

</details>

## Nablarchバッチアプリケーションに必要な修正

The Twelve-Factor AppはSaaSアプリケーションを開発するための方法論であるが、その要素の多くは、クラウド環境に適したバッチアプリケーションを開発するときにおいても適用できる。

:ref:`標準のバッチアプリケーションのブランクプロジェクト <firstStepGenerateBatchBlankProject>` を使ったNablarchバッチアプリケーションには、以下の修正が必要。

**ログ出力**: ウェブアプリケーションと同様に、ログの出力先をファイルから標準出力に変更する。設定方法: [log-basic_setting](../../component/libraries/libraries-log.md)

**環境変数を使った設定**: ウェブアプリケーションと同様に、Mavenプロファイルから環境変数による設定切り替えに変更する。設定方法: [repository-overwrite_environment_configuration_by_os_env_var](../../component/libraries/libraries-repository.md)

<details>
<summary>keywords</summary>

バッチアプリケーション, ログ標準出力, 環境変数設定, クラウドネイティブ対応

</details>

## コンテナ用のアーキタイプ

NablarchはDockerコンテナ上で動かすことを前提としたウェブアプリケーションとバッチアプリケーションのアーキタイプを提供している。このアーキタイプで生成されたブランクプロジェクトには、[modify_nablarch_app_for_cloud_native](#s1) および [modify_nablarch_batch_for_cloud_native](#s2) で説明した修正があらかじめ適用されている。また、[Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin)（JavaアプリケーションのDockerコンテナイメージ作成に特化したMavenプラグイン）が組み込まれているため、開発者はすぐにDockerコンテナ用のNablarchアプリケーション開発を始めることができる。

> **補足**: JibはDockerfileを書かなくてもコンテナイメージを作成できる。Javaアプリケーション向けに抽象化されており、特別な設定なしにベストプラクティスを考慮したコンテナイメージを作成できる。Dockerfileを直接使う場合はレイヤ構造など高い知識が必要だが、Jibはその複雑さを吸収している。

詳細:
- :ref:`前提条件 <firstStepPreamble>`
- [プロジェクトの構成](../blank-project/blank-project-MavenModuleStructures.md)
- [環境ごとの設定の切り替えについて](../blank-project/blank-project-CustomizeDB.md)
- [初期セットアップ手順](../blank-project/blank-project-FirstStepContainer.md)

<details>
<summary>keywords</summary>

Jib, Dockerコンテナ, MavenプラグインJib, Dockerfile不要, コンテナイメージ, アーキタイプ

</details>
