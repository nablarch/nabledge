# Dockerコンテナ化

**公式ドキュメント**: [Dockerコンテナ化](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/cloud_native/containerize/index.html)

## クラウド環境に適したシステムに必要なこと

## クラウド環境に適したシステムに必要なこと

**クラウドネイティブ** とは、はじめからAWSなどのクラウド環境で動かすことを前提とし、クラウド環境に最適化して開発されたシステムのこと。スケーラビリティのためにアプリケーションが状態を持たない（ステートレス）設計が必要となる。

**[The Twelve-Factor App](https://12factor.net/ja/)** は、[Heroku](https://jp.heroku.com/) のエンジニアが提唱したシステム開発の方法論で、クラウド環境に適したシステムを開発する際に考慮すべき12の要素にまとめたもの。本章で説明するNablarchアプリケーションのコンテナ化に必要な修正内容は、この方法論に基づいている。

<details>
<summary>keywords</summary>

クラウドネイティブ, The Twelve-Factor App, ステートレス設計, クラウド環境対応, コンテナ化前提設計

</details>

## Nablarchウェブアプリケーションに必要な修正

## Nablarchウェブアプリケーションに必要な修正

:ref:`標準のウェブアプリケーションのブランクプロジェクト <firstStepGenerateWebBlankProject>` を使って構築したNablarchウェブアプリケーションは、以下の点でThe Twelve-Factor Appに違反しているため修正が必要。

### ステートレス

[VI. プロセス](https://12factor.net/ja/processes) ではアプリケーションはステートレスでなければならないとされているが、標準ブランクプロジェクトではHTTPセッションを使った状態管理が有効になっているため違反している。

修正方法: :ref:`stateless_web_app`

### ログ出力

[XI. ログ](https://12factor.net/ja/logs) ではログはすべて標準出力に書き出しファイルには出力すべきでないとされているが、標準ブランクプロジェクトではロガーの出力先にファイルが指定されているため違反している。

修正方法: [log-basic_setting](../../component/libraries/libraries-log.md)

### 環境変数を使った設定

[III. 設定](https://12factor.net/ja/config) では環境ごとに切り替える設定（連携する他サービスとの接続設定など）は環境変数から設定すべきとされているが、標準ブランクプロジェクトではMavenのプロファイルを使って切り替えているため違反している。

修正方法: [repository-overwrite_environment_configuration_by_os_env_var](../../component/libraries/libraries-repository.md)

<details>
<summary>keywords</summary>

ステートレス, HTTPセッション無効化, ログ標準出力, 環境変数設定, Mavenプロファイル廃止, stateless_web_app, log-basic_setting, repository-overwrite_environment_configuration_by_os_env_var

</details>

## Nablarchバッチアプリケーションに必要な修正

## Nablarchバッチアプリケーションに必要な修正

The Twelve-Factor AppはSaaSアプリケーション向けの方法論だが、その要素の多くはクラウド環境に適したバッチアプリケーションにも適用できる。

:ref:`標準のバッチアプリケーションのブランクプロジェクト <firstStepGenerateBatchBlankProject>` を使って構築したNablarchバッチアプリケーションでは、以下の修正が必要。

- **ログ出力**: ウェブアプリケーションと同様に、ロガーの出力先を標準出力に変更する。修正方法: [log-basic_setting](../../component/libraries/libraries-log.md)
- **環境変数を使った設定**: ウェブアプリケーションと同様に、環境依存値を環境変数で上書きする方式に変更する。修正方法: [repository-overwrite_environment_configuration_by_os_env_var](../../component/libraries/libraries-repository.md)

<details>
<summary>keywords</summary>

バッチアプリ, ログ標準出力, 環境変数設定, クラウドネイティブバッチ, コンテナ化バッチ

</details>

## コンテナ用のアーキタイプ

## コンテナ用のアーキタイプ

Nablarchでは、Dockerコンテナ上で動かすことを前提としたウェブアプリケーションとバッチアプリケーションのアーキタイプを提供している。

このアーキタイプで生成されるブランクプロジェクトには、[modify_nablarch_app_for_cloud_native](#s1) および [modify_nablarch_batch_for_cloud_native](#s2) で説明した修正があらかじめ適用されている。また、[Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) というDockerコンテナを簡単に生成するためのMavenプラグインが組み込まれている。

> **補足**: JibはDockerfileを書かなくてもコンテナイメージを作成できる。JibはJavaアプリケーションのDockerコンテナイメージ作成に特化したツールで、設定はJavaアプリケーション向けに抽象化されており、特別な設定をしなくてもベストプラクティスを考慮した形でコンテナイメージが作成される。Dockerfileを直接記述する場合と比べて、内容が複雑になりやすくレイヤ構造などの高い知識が不要になる。

コンテナ用アーキタイプの詳細は以下を参照:

- :ref:`前提条件 <firstStepPreamble>`
- [プロジェクトの構成](../blank-project/blank-project-MavenModuleStructures.md)
- [環境ごとの設定の切り替えについて](../blank-project/blank-project-CustomizeDB.md)
- [初期セットアップ手順](../blank-project/blank-project-FirstStepContainer.md)

<details>
<summary>keywords</summary>

Jib, コンテナアーキタイプ, Dockerfileなし, コンテナイメージ作成, Mavenプラグイン, ウェブアプリケーションアーキタイプ, バッチアプリケーションアーキタイプ

</details>
