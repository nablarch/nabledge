# コンテナ用Nablarchバッチプロジェクトの初期セットアップ

**公式ドキュメント**: [コンテナ用Nablarchバッチプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch.html)

## コンテナ用Nablarchバッチプロジェクトの初期セットアップ

コンテナ用Nablarchバッチプロジェクトの初期セットアップでは以下を行う。

1. コンテナ用Nablarchバッチプロジェクトの生成
2. コンテナ用Nablarchバッチプロジェクトの動作確認
3. コンテナイメージの作成
4. コンテナイメージの実行

<details>
<summary>keywords</summary>

コンテナ用Nablarchバッチプロジェクト, 初期セットアップ, コンテナイメージ作成, セットアップ手順概要

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 含まれるもの | Nablarchバッチアプリケーション用の基本的な設定、疎通確認用の都度起動バッチアプリケーション、テーブルをキューとして使ったメッセージング、メール送信バッチの設定、Mavenと連動して動作するツールの初期設定（[about_maven_parent_module](blank-project-MavenModuleStructures.md)） |

> **注意**: メール送信バッチは[常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md)として動作し、SMTPサーバに対してメールを送信する。設定ファイルのサンプルは`src/main/resources/mail-sender-boot.xml`に存在する。初期環境構築時には不要で、必要になったタイミングで[メール送信](../../component/libraries/libraries-mail.md)の解説を参照して使用する。

他のプロジェクトとの関係・ディレクトリ構成は[../MavenModuleStructures/index](blank-project-MavenModuleStructures.md)を参照。

<details>
<summary>keywords</summary>

プロジェクト概要, H2 Database Engine, メール送信バッチ, 都度起動バッチ, Mavenプロジェクト, テーブルをキューとして使ったメッセージング

</details>

## ブランクプロジェクト作成

## mvnコマンドの実行

[Maven Archetype Plugin](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html)を使用してブランクプロジェクトを生成する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-batch-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する。（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前のバージョンでブランクプロジェクトを生成したい場合は、`archetype:generate`を`org.apache.maven.plugins:maven-archetype-plugin:2.4:generate`に変更して実行すること。
>
> ```bat
> mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-batch-archetype -DarchetypeVersion=5u24
> ```

## プロジェクト情報の入力

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-batch` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字、数字、ドットのみ使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :`と表示される。
- 入力した内容をもとに、ひな形を生成する場合には「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合には「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

Maven Archetype Plugin, nablarch-container-batch-archetype, archetypeVersion, groupId, artifactId, version, package, ブランクプロジェクト生成

</details>

## 疎通確認

疎通確認の仕組みや手順は通常のNablarchバッチプロジェクトと同じ。:ref:`firstStepBatchStartupTest`を参照。

> **注意**: アーティファクトIDが`myapp-container-batch`になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

<details>
<summary>keywords</summary>

疎通確認, コンテナバッチ疎通確認, myapp-container-batch

</details>

## コンテナイメージを作成する

ブランクプロジェクトには[Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin)プラグインがあらかじめ組み込まれている。`jib:dockerBuild`ゴールを実行することでコンテナイメージを作成できる。

```text
cd myapp-container-batch
mvn compile jib:dockerBuild
```

実行に成功すると、以下のようなログがコンソールに出力される。

```text
(中略)
[INFO] Built image to Docker daemon as myapp-container-batch, myapp-container-batch, myapp-container-batch:0.1.0
[INFO] Executing tasks:
[INFO] [==============================] 100.0% complete
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
(以下略)
```

ビルドされたDockerイメージはローカルリポジトリに保存される。以下のコマンドで確認できる。

```text
docker image ls
REPOSITORY              TAG         IMAGE ID       CREATED        SIZE
myapp-container-batch   0.1.0       1cafd4108237   51 years ago   253MB
myapp-container-batch   latest      1cafd4108237   51 years ago   253MB
```

`myapp-container-batch:0.1.0`と`myapp-container-batch:latest`という2つのイメージが登録されていることが分かる。

`jib:dockerBuild`を実行すると次の2つのイメージが作成される。
- `${project.artifactId}:latest`
- `${project.artifactId}:${project.version}`

初期設定ではベースイメージとして[OpenJDKのイメージ](https://hub.docker.com/_/adoptopenjdk)が使用される。ベースイメージは`jib.from.image`プロパティで変更できる。

```xml
<properties>
  <jib.from.image>adoptopenjdk:11.0.11_9-jre-hotspot</jib.from.image>
</properties>
```

> **補足**: タグ指定の場合、指定したイメージの最新バージョンが選択されアプリケーション動作に影響が出る可能性がある。プロジェクト検証完了後はイメージをダイジェストで指定することを推奨する。
>
> ```xml
> <jib.from.image>adoptopenjdk@sha256:df316691a2c655de2f835a626f8611c74af67dad2cf92711f6608b54e5aa6c61</jib.from.image>
> ```

<details>
<summary>keywords</summary>

Jib, jib:dockerBuild, jib.from.image, コンテナイメージビルド, ベースイメージ, Dockerイメージ作成, adoptopenjdk

</details>

## コンテナイメージを実行する

## 都度起動バッチ

```text
cd myapp-container-batch
docker run --rm -v %CD%\\h2:/h2 -v %CD%\\src\\main\\format:/var/nablarch/format -v %CD%\\work\\output:/var/nablarch/output --name myapp-container-batch myapp-container-batch:latest -diConfig classpath:batch-boot.xml -requestPath SampleBatch -userId batch_user
```

## テーブルをキューとして使ったメッセージング

```text
cd myapp-container-batch
docker run -it --rm -v %CD%\\h2:/h2 --name myapp-container-batch myapp-container-batch:latest -diConfig classpath:resident-batch-boot.xml -requestPath SampleResiBatch -userId batch_user
```

待機状態となるので、確認後はctrl+c等で強制終了させる。

<details>
<summary>keywords</summary>

docker run, コンテナイメージ実行, 都度起動バッチ実行, テーブルをキューとして使ったメッセージング実行, コンテナ実行コマンド

</details>

## 補足

**コンテナイメージの実行コマンドについて**
- コマンドを実行すると、コンテナが起動し、バッチ処理実行後、コンテナは自動的に終了する。
- `--rm`オプションにより、コンテナ終了時にコンテナが自動削除される。
- SAMPLE.h2.dbを使用しない場合は、`%CD%\\h2:/h2`のボリューム指定（`-v`）は不要。
- :ref:`都度起動バッチ<firstStepContainerBatchStartupInnerBatchOndemand>`では`./work/format`と`./work/output`ディレクトリもコンテナにマウントされる。
- :ref:`テーブルをキューとして使ったメッセージング<firstStepContainerBatchStartupInnerBatchDbMessaging>`で`-it`オプションを省略するとホスト側からctrl+cで強制終了できなくなる。その場合は以下のコマンドでコンテナを終了させること。

```text
docker stop myapp-container-batch
```

**Docker環境について**
- Docker Desktopを使用していることを:ref:`前提<firstStepPreamble>`としている。
- Docker Toolbox使用時はボリューム指定でエラーになる。Docker ToolboxではDockerがVirtualBox上のVMで動作するため、ボリュームのホスト側パスはVM上のパスを指定する必要がある。Windowsのデフォルトでは`C:\\Users`がVM上の`/c/users`にマウントされているため、`-v /c/users/path/to/project/h2:/usr/local/tomcat/h2`のように指定する。

H2のデータ確認方法やブランクプロジェクトに組み込まれているツールについては[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md)を参照。

<details>
<summary>keywords</summary>

Docker Toolbox, Docker Desktop, ボリュームマウント, docker stop, コンテナ終了, H2データ確認

</details>
