# コンテナ用ウェブプロジェクトの初期セットアップ

**公式ドキュメント**: [コンテナ用ウェブプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerWeb.html)

## コンテナ用ウェブプロジェクトの初期セットアップ

コンテナ用ウェブプロジェクトの初期セットアップで行う作業:
1. コンテナ用ウェブプロジェクトの生成
2. コンテナ用ウェブプロジェクトの動作確認
3. コンテナイメージの作成
4. コンテナイメージの実行

<details>
<summary>keywords</summary>

コンテナ用ウェブプロジェクト, 初期セットアップ, コンテナイメージ作成, ウェブプロジェクト生成

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | ルーティングアダプタ（[router_adaptor](../../component/adapters/adapters-router_adaptor.md) 参照） |
| 含まれるもの | Nablarchウェブアプリ用基本設定、疎通確認用ウェブアプリ、Mavenと連動するツールの初期設定（[about_maven_parent_module](blank-project-MavenModuleStructures.md) 参照） |

<details>
<summary>keywords</summary>

プロジェクト概要, Mavenプロジェクト, H2 Database Engine, ルーティングアダプタ, router_adaptor, about_maven_parent_module

</details>

## ブランクプロジェクト作成

## mvnコマンドの実行

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-web-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョンを指定する（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前のバージョンでブランクプロジェクトを生成する場合は、`archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更すること。
>
> ```bat
> mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-web-archetype -DarchetypeVersion=5u24
> ```

## プロジェクト情報の入力

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-web` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字・数字・ドットのみ使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :` と表示される。
- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

ブランクプロジェクト作成, mvn archetype:generate, nablarch-container-web-archetype, archetypeVersion, groupId, artifactId, 5u24, 5u25

</details>

## 疎通確認

疎通確認の仕組みや手順は通常のウェブプロジェクトと同じ。:ref:`firstStepWebStartupTest` を参照。

> **注意**: アーティファクトIDが `myapp-container-web` になっている点は適宜読み替えること。

<details>
<summary>keywords</summary>

疎通確認, firstStepWebStartupTest, ウェブプロジェクト動作確認

</details>

## コンテナイメージを作成する

ブランクプロジェクトには [Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) プラグインがあらかじめ組み込まれている。`jib:dockerBuild` ゴールを実行することでコンテナイメージを作成できる。

```text
cd myapp-container-web
mvn package jib:dockerBuild
```

ビルドされたDockerイメージはローカルリポジトリに保存される。以下のコマンドでローカルリポジトリに保存されたイメージを確認できる。

```text
docker image ls
REPOSITORY              TAG         IMAGE ID       CREATED        SIZE
myapp-container-web     0.1.0       dd60cbdc7722   50 years ago   449MB
myapp-container-web     latest      dd60cbdc7722   50 years ago   449MB
```

`jib:dockerBuild` を実行すると次の2つのイメージが作成される:
- `${project.artifactId}:latest`
- `${project.artifactId}:${project.version}`

初期設定のベースイメージは [Tomcatのイメージ](https://hub.docker.com/_/tomcat)。`jib.from.image` プロパティで変更可能。

```xml
<properties>
  <jib.from.image>tomcat:9.0.36-jdk11-adoptopenjdk-hotspot</jib.from.image>
</properties>
```

> **補足**: イメージをタグで指定すると最新バージョンが選択される。プロジェクトでの検証完了後は、バージョン固定のためにダイジェストで指定することを推奨する。
>
> ```xml
> <jib.from.image>tomcat@sha256:7d59567f61e79f5dc1226a3ee26b4a4c2befc5cae182f7e0823199cf5885409b</jib.from.image>
> ```

<details>
<summary>keywords</summary>

コンテナイメージ作成, Jib, jib:dockerBuild, jib.from.image, Tomcatイメージ, Dockerイメージビルド, mvn package, docker image ls

</details>

## コンテナイメージを実行する

```text
cd myapp-container-web
docker run -d -p 8080:8080 -v %CD%\h2:/usr/local/tomcat/h2 --name myapp-container-web myapp-container-web
```

コンテナ起動後、`http://localhost:8080/` でアプリケーションの動作確認が可能。

> **補足**: 上記コマンドはSAMPLE.h2.dbを使用する場合の例。SAMPLE.h2.dbを使用しない場合はボリューム指定（`-v`）は不要。

> **補足**: Dockerの実行はDocker Desktopを使用していることを前提としている。Docker Toolboxを使用している場合は上記のボリューム指定ではエラーになる。DockerはVirtualBox上のVMで動作するため、ボリュームのホスト側にはVM上のパスを指定すること。Windowsではデフォルトで `C:\Users` がVM上の `/c/users` にマウントされているため、`-v /c/users/path/to/project/h2:/usr/local/tomcat/h2` のように指定する。

コンテナを終了する:
```text
docker stop myapp-container-web
```

コンテナを削除する:
```text
docker rm myapp-container-web
```

<details>
<summary>keywords</summary>

コンテナイメージ実行, docker run, docker stop, docker rm, Docker Toolbox, ボリューム指定

</details>

## 補足

H2のデータの確認方法やブランクプロジェクトに組み込まれているツールについては [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照すること。

<details>
<summary>keywords</summary>

H2データベース確認, ブランクプロジェクト補足, firststep_complement

</details>
