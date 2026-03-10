# コンテナ用ウェブプロジェクトの初期セットアップ

## コンテナ用ウェブプロジェクトの初期セットアップ

コンテナ用ウェブプロジェクトの初期セットアップで行う作業:

1. コンテナ用ウェブプロジェクトの生成
2. コンテナ用ウェブプロジェクトの動作確認
3. コンテナイメージの作成
4. コンテナイメージの実行

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | ルーティングアダプタ（:ref:`router_adaptor` 参照） |
| 生成するプロジェクトに含まれるもの | Nablarchウェブアプリケーション用の基本設定、疎通確認用ウェブアプリケーション、Mavenと連動して動作するツールの初期設定（:ref:`about_maven_parent_module` 参照） |

他のプロジェクトとの関係およびディレクトリ構成は [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md) を参照。

## ブランクプロジェクト作成

[Maven Archetype Plugin](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用してブランクプロジェクトを生成する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-web-archetype -DarchetypeVersion={nablarch_version}
```

バージョン変更時のパラメータ:

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョン（Nablarch 6u2以降を指定すること） |

プロジェクト情報の入力項目:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-web` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字、数字、ドットを使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :` と表示される。

- 入力した内容をもとにひな形を生成する場合には「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合には「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

## 疎通確認

疎通確認の仕組みや手順は通常のウェブプロジェクトと同じ。:ref:`firstStepWebStartupTest` を参照。

> **注意**: アーティファクトIDが `myapp-container-web` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

## コンテナイメージを作成する

ブランクプロジェクトには [Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) プラグインが組み込まれており、`jib:dockerBuild` ゴールでコンテナイメージを作成できる。

```text
cd myapp-container-web
mvn package jib:dockerBuild
```

ビルドされたDockerイメージは、ローカルリポジトリに保存される。以下のコマンドでローカルリポジトリに保存されたイメージを確認できる。

```text
docker image ls
REPOSITORY              TAG         IMAGE ID       CREATED        SIZE
myapp-container-web     0.1.0       dd60cbdc7722   50 years ago   449MB
myapp-container-web     latest      dd60cbdc7722   50 years ago   449MB
```

作成されるイメージ（デフォルト設定）:
- `${project.artifactId}:latest`
- `${project.artifactId}:${project.version}`

初期設定のベースイメージ: [Tomcat のイメージ](https://hub.docker.com/_/tomcat)

ベースイメージは `jib.from.image` プロパティで変更できる。`pom.xml` への設定例:

```xml
<properties>
  <jib.from.image>tomcat:10.1.34-jre17-temurin-jammy</jib.from.image>
</properties>
```

> **補足**: タグが指すイメージが変更されると検証時と異なるバージョンが選択される可能性がある。検証完了後はダイジェストで指定することを推奨する。ダイジェスト指定例: `<jib.from.image>tomcat@sha256:28fde3a9cf9ff62b250cd2ce5b8981a75eedbe6a37a9954c8432f6f52483cfb8</jib.from.image>`

## コンテナイメージを実行する

```text
cd myapp-container-web
docker run -d -p 8080:8080 -v %CD%\h2:/usr/local/tomcat/h2 --name myapp-container-web myapp-container-web
```

起動後、`http://localhost:8080/` でアプリケーションの動作を確認できる。

> **補足**: 上記コマンドはSAMPLE.h2.dbを使用する場合の例。SAMPLE.h2.dbを使用しない場合はボリューム指定（`-v`）は不要。

> **前提**: Dockerの実行はDocker Desktopを使用していることを前提としている（:ref:`firstStepPreamble` 参照）。

> **補足**: Docker Toolboxを使用している場合、ボリューム指定でエラーになる。DockerはVirtualBox上のVMで動作するため、ボリュームのホスト側に指定できるパスはVM上のパスになる。Windowsのデフォルトでは `C:\Users` がVM上の `/c/users` にマウントされているため、ボリューム指定を `-v /c/users/path/to/project/h2:/usr/local/tomcat/h2` のようにする必要がある。

コンテナ停止:
```text
docker stop myapp-container-web
```

コンテナ削除:
```text
docker rm myapp-container-web
```

## データベースに関する設定を行う

初期状態ではH2 Database Engineを使用するように設定されている。使用するRDBMSを変更する場合は :ref:`customize-db` を参照。

ER図からのDDL生成・実行、Entityクラスの自動生成にはgsp-dba-maven-pluginの初期設定と実行が必要。詳細は :ref:`gsp-maven-plugin` を参照。

## 補足

H2のデータの確認方法やブランクプロジェクトに組み込まれているツールの詳細は [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。
