# コンテナ用Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ

**公式ドキュメント**: [コンテナ用Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch_Dbless.html)

## コンテナ用Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ

コンテナ用Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップでは以下を行う。

1. ブランクプロジェクトの生成
2. 動作確認（疎通確認）
3. コンテナイメージの作成
4. コンテナイメージの実行

<details>
<summary>keywords</summary>

コンテナ用Nablarchバッチ DB接続無し 初期セットアップ, ブランクプロジェクト生成, コンテナイメージ作成, コンテナイメージ実行, 都度起動バッチ

</details>

## 生成するプロジェクトの概要

生成されるプロジェクトの概要:

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 含まれるもの | Nablarchバッチアプリケーション用の基本的な設定、疎通確認用の都度起動バッチアプリケーション、Mavenと連動して動作するツールの初期設定（[about_maven_parent_module](blank-project-MavenModuleStructures.md) 参照） |

他のプロジェクトとの関係およびディレクトリ構成は [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md) を参照。

<details>
<summary>keywords</summary>

Mavenプロジェクト, 単一プロジェクト構成, 都度起動バッチアプリケーション, about_maven_parent_module, MavenModuleStructures

</details>

## ブランクプロジェクト作成

**アーキタイプ**: `nablarch-container-batch-dbless-archetype`（groupId: `com.nablarch.archetype`）

カレントディレクトリを、ブランクプロジェクトを作成したいディレクトリ（任意のディレクトリで可）に変更する。その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-batch-dbless-archetype -DarchetypeVersion={nablarch_version}
```

| パラメータ | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョン（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前のバージョンでブランクプロジェクトを生成したい場合は、`archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更して実行すること。
>
> ```bat
> mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-batch-dbless-archetype -DarchetypeVersion=5u24
> ```

プロジェクト情報の入力項目:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-batch-dbless` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされるため、英小文字・数字・ドットのみ使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :` と表示される。

- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

nablarch-container-batch-dbless-archetype, com.nablarch.archetype, archetypeVersion, Maven Archetype Plugin, ブランクプロジェクト生成コマンド, groupId ハイフン禁止, 5u25, 5u24

</details>

## 疎通確認

疎通確認の仕組みや手順は通常のNablarchバッチ（DB接続無し）プロジェクトと同じ。:ref:`firstStepDblessBatchStartupTest` を参照すること。

> **注意**: アーティファクトIDが `myapp-container-batch-dbless` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

疎通確認, firstStepDblessBatchStartupTest, myapp-container-batch-dbless, 動作確認

</details>

## コンテナイメージを作成する

コンテナイメージの作成手順は通常のコンテナ用Nablarchバッチプロジェクトと同じ。:ref:`firstStepBuildContainerBatchDockerImage` を参照すること。

> **注意**: アーティファクトIDが `myapp-container-batch-dbless` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

コンテナイメージ作成, firstStepBuildContainerBatchDockerImage, Docker, myapp-container-batch-dbless

</details>

## コンテナイメージを実行する

コンテナイメージの実行手順は通常のコンテナ用Nablarchバッチプロジェクトと同じ。:ref:`firstStepRunContainerBatchDockerImage` を参照すること。

> **注意**: アーティファクトIDが `myapp-container-batch-dbless` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

> **重要**: コンテナ用Nablarchバッチ（DB接続無し）プロジェクトでは都度起動バッチのみ実行可能である。

<details>
<summary>keywords</summary>

コンテナイメージ実行, firstStepRunContainerBatchDockerImage, 都度起動バッチのみ実行可能, DB接続無し 実行制約, myapp-container-batch-dbless

</details>
