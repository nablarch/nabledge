# コンテナ用Nablarchバッチプロジェクトの初期セットアップ

**公式ドキュメント**: [コンテナ用Nablarchバッチプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch.html)

## コンテナ用Nablarchバッチプロジェクトの初期セットアップ

コンテナ用Nablarchバッチプロジェクトの初期セットアップ手順。以下の順に実施する:
1. ブランクプロジェクト作成
2. 疎通確認
3. コンテナイメージ作成
4. コンテナイメージ実行

<details>
<summary>keywords</summary>

コンテナバッチ初期セットアップ, ブランクプロジェクト作成手順, コンテナイメージ作成, コンテナイメージ実行

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 含まれるもの | Nablarchバッチアプリケーション用基本設定、疎通確認用都度起動バッチ、疎通確認用テーブルをキューとして使ったメッセージング、メール送信バッチ設定、Mavenと連動するツールの初期設定 |

メール送信バッチ: [常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md) として動作し、SMTPサーバへメール送信。設定ファイルサンプルは `src/main/resources/mail-sender-boot.xml`。初期環境構築時は不要。必要になったタイミングで [メール送信](../../component/libraries/libraries-mail.md) を参照。

他プロジェクトとの関係・ディレクトリ構成: [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md) 参照。

<details>
<summary>keywords</summary>

プロジェクト種別, H2 Database Engine, メール送信バッチ, Mavenプロジェクト, 単一プロジェクト構成

</details>

## ブランクプロジェクト作成

Maven Archetype Pluginを使用してブランクプロジェクトを生成する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-batch-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョン（Nablarch 6u2以降を指定すること） |

プロジェクト情報の入力:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-batch` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字、数字、ドットのみ使用可。ハイフンは使用不可。

コマンド正常終了後、ブランクプロジェクトがカレントディレクトリ配下に作成される。プロジェクト情報の入力が終わると確認が表示される:
- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

<details>
<summary>keywords</summary>

mvn archetype:generate, nablarch-container-batch-archetype, archetypeVersion, groupId, artifactId

</details>

## 疎通確認

疎通確認の手順は通常のNablarchバッチプロジェクトと同じ。:ref:`Nablarchバッチプロジェクトの初期セットアップ手順 <firstStepBatchStartupTest>` を参照。

> **注意**: アーティファクトIDが `myapp-container-batch` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

疎通確認, コンテナバッチ動作確認, myapp-container-batch, firstStepBatchStartupTest

</details>

## コンテナイメージを作成する

ブランクプロジェクトには [Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) プラグインが組み込み済み。`jib:dockerBuild` ゴールでコンテナイメージを作成する。

```text
cd myapp-container-batch
mvn compile jib:dockerBuild
```

ビルドされたDockerイメージはローカルリポジトリに保存される。以下のコマンドで確認できる:

```text
docker image ls
REPOSITORY              TAG         IMAGE ID       CREATED        SIZE
myapp-container-batch   0.1.0       1cafd4108237   51 years ago   253MB
myapp-container-batch   latest      1cafd4108237   51 years ago   253MB
```

`myapp-container-batch:0.1.0` と `myapp-container-batch:latest` の2つのイメージが登録されていることが分かる。

作成されるイメージ（2つ）:
- `${project.artifactId}:latest`
- `${project.artifactId}:${project.version}`

初期設定のベースイメージ: [eclipse-temurin (OpenJDK)](https://hub.docker.com/_/eclipse-temurin)

ベースイメージは `jib.from.image` プロパティで変更可能。

```xml
<properties>
  <jib.from.image>eclipse-temurin:17.0.6_10-jre-jammy</jib.from.image>
</properties>
```

> **補足**: タグ指定では最新バージョンが選択されるため、検証完了後はダイジェストで固定することを推奨。
> ```xml
> <jib.from.image>eclipse-temurin@sha256:7dacdab7c335d90cf4e110f5744ca27d5a3ed87901a7c08022c8c12055438bd2</jib.from.image>
> ```

<details>
<summary>keywords</summary>

Jib, jib:dockerBuild, jib.from.image, eclipse-temurin, Dockerイメージビルド, コンテナイメージ作成

</details>

## コンテナイメージを実行する

**都度起動バッチ**:

```text
cd myapp-container-batch
docker run --rm -v %CD%\\h2:/h2 -v %CD%\\src\\main\\format:/var/nablarch/format -v %CD%\\work\\output:/var/nablarch/output --name myapp-container-batch myapp-container-batch:latest -diConfig classpath:batch-boot.xml -requestPath SampleBatch -userId batch_user
```

動作は :ref:`疎通確認(都度起動バッチ)<firstStepBatchStartupTest>` と同じ。

**テーブルをキューとして使ったメッセージング**:

```text
cd myapp-container-batch
docker run -it --rm -v %CD%\\h2:/h2 --name myapp-container-batch myapp-container-batch:latest -diConfig classpath:resident-batch-boot.xml -requestPath SampleResiBatch -userId batch_user
```

動作は :ref:`疎通確認(テーブルをキューとして使ったメッセージング)<firstStepBatchStartupTestDbMessagingBatch>` と同じ。待機状態となるのでctrl+c等で強制終了。

<details>
<summary>keywords</summary>

docker run, 都度起動バッチ, テーブルをキューとして使ったメッセージング, batch-boot.xml, resident-batch-boot.xml, コンテナ実行, SampleBatch, SampleResiBatch

</details>

## データベースに関する設定を行う

- RDBMSを変更する場合: [customize-db](blank-project-CustomizeDB.md) を参照。
- ER図からのDDL生成・実行、Entityクラス自動生成には gsp-dba-maven-plugin の初期設定が必要。[gsp-maven-plugin](blank-project-addin_gsp.md) 参照。

<details>
<summary>keywords</summary>

H2 Database Engine, RDBMS変更, gsp-dba-maven-plugin, DDL生成, データベース設定

</details>

## 補足

**コンテナイメージの実行コマンドについて**:
- バッチ処理実行後、コンテナは自動終了。`-rmオプション`によりコンテナ終了時に自動削除される。
- `%CD%\\h2:/h2` のボリューム指定は SAMPLE.h2.db を使用する場合のみ必要。SAMPLE.h2.db 不使用時は不要。
- :ref:`都度起動バッチ<firstStepContainerBatchStartupInnerBatchOndemand>` では `./work/format`、`./work/output` ディレクトリもコンテナにマウント。
- :ref:`テーブルをキューとして使ったメッセージング<firstStepContainerBatchStartupInnerBatchDbMessaging>` で `-it` オプション省略時はctrl+cで強制終了不可。その場合は `docker stop myapp-container-batch` で停止。

**Docker環境について**:
- Docker Desktop使用を :ref:`前提 <firstStepPreamble>` としている。
- Docker Toolbox使用時、DockerはVirtualBox上のVMで動作するため、ボリュームのホスト側はVM上のパスを指定する必要がある。Windowsのデフォルトでは `C:\Users` がVM上の `/c/users` にマウント済み。ボリューム指定例: `-v /c/users/path/to/project/h2:/usr/local/tomcat/h2`

**H2、ツールについて**:
[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照すること。

<details>
<summary>keywords</summary>

コンテナイメージ実行オプション, Docker Desktop, Docker Toolbox, ボリューム指定, -rmオプション, SAMPLE.h2.db

</details>
