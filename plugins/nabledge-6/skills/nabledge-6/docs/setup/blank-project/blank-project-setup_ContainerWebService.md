# コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ

**公式ドキュメント**: [コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerWebService.html)

## コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ

コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップでは以下を行う。

- RESTfulウェブサービスプロジェクトの生成
- RESTfulウェブサービスプロジェクトの動作確認
- コンテナイメージの作成
- コンテナイメージの実行

<details>
<summary>keywords</summary>

コンテナ用RESTfulウェブサービス, 初期セットアップ, ブランクプロジェクト, コンテナイメージ, RESTfulウェブサービスプロジェクト生成

</details>

## 事前準備

:ref:`firstStepContainerWebServiceStartupTest` で使用するため、以下のいずれかをインストールする。

- Firefox
- Chrome

<details>
<summary>keywords</summary>

事前準備, ブラウザインストール, Firefox, Chrome, 疎通確認準備

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | Jersey用アダプタ（:ref:`jaxrs_adaptor`）、ルーティングアダプタ（:ref:`router_adaptor`） |
| 生成するプロジェクトに含まれるもの | NablarchのRESTfulウェブサービス用の基本的な設定、疎通確認用RESTfulウェブサービス、Mavenと連動して動作するツールの初期設定 |

<details>
<summary>keywords</summary>

Mavenプロジェクト, H2 Database Engine, Jerseyアダプタ, ルーティングアダプタ, 単一プロジェクト構成

</details>

## ブランクプロジェクト作成

[Maven Archetype Plugin](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用してブランクプロジェクトを生成する。

まず、カレントディレクトリをブランクプロジェクトを作成したいディレクトリ（任意のディレクトリで可）に変更する。その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-jaxrs-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する。（Nablarch 6u2以降を指定すること） |

プロジェクト情報の入力項目：

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名を入力） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-jaxrs` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageは、Javaのパッケージ名にマッピングされる。入力値には英小文字、数字、ドットを使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y:` と表示される。

- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

mvn archetype:generate, nablarch-container-jaxrs-archetype, groupId, artifactId, archetypeVersion

</details>

## 疎通確認

疎通確認の手順は通常のRESTfulウェブサービスプロジェクトと同じ。:ref:`firstStepWebServiceStartupTest` を参照。

> **注意**: アーティファクトID が `myapp-container-jaxrs` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

疎通確認, myapp-container-jaxrs, RESTfulウェブサービス動作確認

</details>

## コンテナイメージを作成する

コンテナイメージの作成方法はコンテナ用ウェブプロジェクトと同じ。:ref:`firstStepBuildContainerWebDockerImage` を参照。

> **注意**: アーティファクトID が `myapp-container-jaxrs` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

コンテナイメージ作成, Dockerイメージビルド, myapp-container-jaxrs

</details>

## コンテナイメージを実行する

コンテナイメージの実行方法はコンテナ用ウェブプロジェクトと同じ。:ref:`firstStepRunContainerWebDockerImage` を参照。

> **注意**: アーティファクトID が `myapp-container-jaxrs` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

動作確認URL:
- `http://localhost:8080/find/json`
- `http://localhost:8080/find/xml`

<details>
<summary>keywords</summary>

コンテナイメージ実行, localhost:8080, find/json, find/xml, myapp-container-jaxrs

</details>

## データベースに関する設定を行う

ブランクプロジェクトの初期状態ではH2 Database Engineを使用するように設定されている。使用するRDBMSを変更する場合は、:ref:`customize-db` を参照。

ER図からのDDL生成や実行、Entityクラスの自動生成には、gsp-dba-maven-pluginの初期設定および実行が必要。詳細は :ref:`gsp-maven-plugin` を参照。

<details>
<summary>keywords</summary>

H2 Database Engine, データベース設定, RDBMS変更, gsp-dba-maven-plugin, DDL生成

</details>

## 補足

H2のデータの確認方法や、ブランクプロジェクトに組み込まれているツールに関しては、[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。

<details>
<summary>keywords</summary>

H2データ確認, ブランクプロジェクト補足, 組み込みツール

</details>
