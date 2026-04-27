# Dockerコンテナ化

**目次**

* クラウド環境に適したシステムに必要なこと

  * クラウドネイティブ
  * The Twelve-Factor App
* Nablarchウェブアプリケーションに必要な修正
* Nablarchバッチアプリケーションに必要な修正
* コンテナ用のアーキタイプ

本章では、Nablarchで作ったアプリケーションを、クラウドネイティブを意識した形でDockerコンテナイメージにする方法について説明する。

まず、コンテナ化するためには従来のNablarchアプリケーションに対して、どのような修正を入れなければならないのかについて説明する。
そして、あらかじめコンテナ化のための設定を組み込んだブランクプロジェクトを作成する、専用のアーキタイプについて説明する。

## クラウド環境に適したシステムに必要なこと

### クラウドネイティブ

**クラウドネイティブ** とは、はじめからAWSなどのクラウド環境で動かすことを前提とし、クラウド環境に最適化して開発されたシステムのことを指す。

クラウド環境に適したシステムには、オンプレミス環境で動かすような従来のシステムとは異なる設計が必要となる。
例えば、スケーラビリティを持たせるためにアプリケーションが状態を持たないようにするといった対応が必要になる。

### The Twelve-Factor App

[The Twelve-Factor App](https://12factor.net/ja/) (外部サイト)とは、 [Heroku](https://jp.heroku.com/) (外部サイト、英語)のエンジニアが提唱したシステム開発の方法論で、クラウド環境に適したシステムを開発するときに考慮すべきことを12の要素（Twelve-Factor）にまとめたものになる。

本章で説明するコンテナ化のために必要となるNablarchアプリケーションの修正内容は、この [The Twelve-Factor App](https://12factor.net/ja/) (外部サイト)で説明されている方法をもとにしている。

## Nablarchウェブアプリケーションに必要な修正

[標準のウェブアプリケーションのブランクプロジェクト](../../setup/blank-project/blank-project-setup-Web.md#firststepgeneratewebblankproject) を使ってNablarchウェブアプリケーションを構築した場合、以下の点が [The Twelve-Factor App](https://12factor.net/ja/) (外部サイト)に反した状態になっている。

ステートレス
[VI. プロセス](https://12factor.net/ja/processes) (外部サイト)では、アプリケーションはステートレスでなければならないとされている。
つまり、個々のアプリケーションは状態を保持してはいけない、ということになる。

標準のブランクプロジェクトでは、HTTPセッションを使った状態管理が有効となっているため、この方針に反している。

Nablarchウェブアプリケーションをステートレスにするための設定については、 [Webアプリケーションをステートレスにする](../../component/libraries/libraries-stateless-web-app.md#stateless-web-app) を参照。
ログ出力
[XI. ログ](https://12factor.net/ja/logs) (外部サイト)では、アプリケーションのログはすべて標準出力に書き出し、ファイルには出力すべきでないとされている。

標準のブランクプロジェクトでは、ロガーの出力先にファイルが指定されているため、この方針に反している。

Nablarchのログ出力設定については、 [ログ出力の設定](../../component/libraries/libraries-log.md#log-basic-setting) を参照。
環境変数を使った設定
[III. 設定](https://12factor.net/ja/config) (外部サイト)では、環境ごとによって切り替える設定（連携する他サービスとの接続設定など）は、アプリケーション内部に持たずに環境変数から設定すべきとしている。

標準のブランクプロジェクトでは、開発環境と本番環境の設定の違いをMavenのプロファイルを使って切り替えているため、この方針に反している。

環境変数を使って環境依存値を上書きする方法については、 [OS環境変数を使って環境依存値を上書きする](../../component/libraries/libraries-repository.md#repository-overwrite-environment-configuration-by-os-env-var) を参照。

## Nablarchバッチアプリケーションに必要な修正

[The Twelve-Factor App](https://12factor.net/ja/) (外部サイト)はSaaSアプリケーションを開発するための方法論であるが、その要素の多くは、クラウド環境に適したバッチアプリケーションを開発するときにおいても適用できる。

[標準のバッチアプリケーションのブランクプロジェクト](../../setup/blank-project/blank-project-setup-NablarchBatch.md#firststepgeneratebatchblankproject) を使ってNablarchバッチアプリケーションを構築した場合に修正が必要な点は、以下の通りである。

ログ出力
(Nablarchウェブアプリケーションのものと同じなので記述省略)
環境変数を使った設定
(Nablarchウェブアプリケーションのものと同じなので記述省略)

## コンテナ用のアーキタイプ

Nablarchでは、Dockerコンテナ上で動かすことを前提としたウェブアプリケーションとバッチアプリケーションのアーキタイプを用意している。

このアーキタイプを使って生成されるブランクプロジェクトには、 [Nablarchウェブアプリケーションに必要な修正](../../setup/cloud-native/cloud-native-containerize.md#modify-nablarch-app-for-cloud-native) や [Nablarchバッチアプリケーションに必要な修正](../../setup/cloud-native/cloud-native-containerize.md#modify-nablarch-batch-for-cloud-native) で説明した修正があらかじめ適用されている。
また、 [Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) (外部サイト、英語)というDockerコンテナを簡単に生成するためのMavenプラグインが組み込まれているため、開発者はすぐにDockerコンテナ用のNablarchアプリケーションの開発を始めることができる。

> **Tip:**
> Jibを使用すると、Dockerfileを書かなくてもコンテナイメージを作成できる。

> DockerfileはDockerのコンテナイメージを作成するための、最も基本的な命令を記述できる。
> このため、Dockerfileを使用すれば自由な形でコンテナイメージを作成できる。
> しかし一方で、Dockerfileを使用することには次のようなデメリットもある。

> * >   基本的な命令で記述するため、内容が複雑になりやすい
> * >   コンテナイメージのレイヤ構造など、ベストプラクティスを意識した記述が必要で高い知識が要求される

> JibはJavaアプリケーションのDockerコンテナイメージを作成することに特化したツールとなっている。
> 設定の記述はJavaアプリケーション向けに抽象化され、特別な設定をしなくてもベストプラクティスを考慮した形でコンテナイメージを作成できるようになっている。

> 以上の理由により、Nablarchのコンテナ用アーキタイプは、Dockerfileを直接記述するのではなくJibを使用してコンテナイメージを作成する方式を採用している。

Dockerコンテナ用のアーキタイプの説明については以下を参照。

* [前提条件](../../setup/blank-project/blank-project-beforeFirstStep.md#firststeppreamble)
* [プロジェクトの構成](../../setup/blank-project/blank-project-MavenModuleStructures.md#container-web-project-summary)
* [環境ごとの設定の切り替えについて](../../setup/blank-project/blank-project-CustomizeDB.md#container-production-config)
* [初期セットアップ手順](../../setup/blank-project/blank-project-FirstStepContainer.md#first-step-container)
