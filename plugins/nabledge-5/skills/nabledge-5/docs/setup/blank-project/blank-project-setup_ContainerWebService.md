# コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ

**公式ドキュメント**: [コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerWebService.html)

## コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ

コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップでは以下を行う。

1. RESTfulウェブサービスプロジェクトの生成
2. RESTfulウェブサービスプロジェクトの動作確認
3. コンテナイメージの作成
4. コンテナイメージの実行

<details>
<summary>keywords</summary>

RESTfulウェブサービスプロジェクト初期セットアップ, コンテナ用ウェブサービス, nablarch-container-jaxrs

</details>

## 事前準備

:ref:`firstStepContainerWebServiceStartupTest` で使用するため、以下のいずれかをインストールする。

- Firefox
- Chrome

<details>
<summary>keywords</summary>

事前準備, ブラウザインストール, Firefox, Chrome

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | Jersey用アダプタ（[jaxrs_adaptor](../../component/adapters/adapters-jaxrs_adaptor.md) 参照）、ルーティングアダプタ（[router_adaptor](../../component/adapters/adapters-router_adaptor.md) 参照） |
| 生成するプロジェクトに含まれるもの | NablarchのRESTfulウェブサービス用の基本的な設定、疎通確認用RESTfulウェブサービス、Mavenと連動して動作するツールの初期設定（[about_maven_parent_module](blank-project-MavenModuleStructures.md) 参照） |

他のプロジェクトとの関係およびディレクトリ構成は [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md) を参照。

<details>
<summary>keywords</summary>

プロジェクト概要, Mavenプロジェクト, H2 Database Engine, Jersey用アダプタ, ルーティングアダプタ, jaxrs_adaptor, router_adaptor, about_maven_parent_module

</details>

## ブランクプロジェクト作成

アーキタイプ `nablarch-container-jaxrs-archetype` を使用してブランクプロジェクトを生成する。

**mvnコマンドの実行**

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-jaxrs-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョン（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前の場合は `archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更すること。
> ```bat
> mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-jaxrs-archetype -DarchetypeVersion=5u24
> ```

**プロジェクト情報の入力**

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-jaxrs` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字、数字、ドットを使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :` と表示される。

- ひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

コマンドが正常終了すると、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

ブランクプロジェクト作成, mvn archetype:generate, nablarch-container-jaxrs-archetype, archetypeVersion, groupId, artifactId, version, package, maven-archetype-plugin, 5u24, 5u25

</details>

## 疎通確認

疎通確認の仕組みや手順は通常のRESTfulウェブサービスプロジェクトと同じ。:ref:`RESTfulウェブサービスプロジェクトの初期セットアップ <firstStepWebServiceStartupTest>` を参照。

> **注意**: アーティファクトIDが `myapp-container-jaxrs` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

疎通確認, RESTfulウェブサービス動作確認, myapp-container-jaxrs, firstStepWebServiceStartupTest

</details>

## コンテナイメージを作成する

コンテナイメージの作成方法はコンテナ用のウェブプロジェクトと同じ。:ref:`コンテナ用ウェブプロジェクトの初期セットアップ <firstStepBuildContainerWebDockerImage>` を参照。

> **注意**: アーティファクトIDが `myapp-container-jaxrs` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

コンテナイメージ作成, Dockerイメージビルド, myapp-container-jaxrs, firstStepBuildContainerWebDockerImage

</details>

## コンテナイメージを実行する

コンテナイメージの実行方法はコンテナ用のウェブプロジェクトと同じ。:ref:`コンテナ用ウェブプロジェクトの初期セットアップ <firstStepRunContainerWebDockerImage>` を参照。

> **注意**: アーティファクトIDが `myapp-container-jaxrs` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

動作確認URL:
- `http://localhost:8080/find/json`
- `http://localhost:8080/find/xml`

<details>
<summary>keywords</summary>

コンテナイメージ実行, Docker実行, localhost:8080/find/json, localhost:8080/find/xml, myapp-container-jaxrs, firstStepRunContainerWebDockerImage

</details>

## 補足

H2のデータ確認方法やブランクプロジェクトに組み込まれているツールについては、[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。

<details>
<summary>keywords</summary>

H2データ確認, ブランクプロジェクト組み込みツール, firststep_complement

</details>
