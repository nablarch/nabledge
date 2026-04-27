# コンテナ用ウェブプロジェクトの初期セットアップ

コンテナ用ウェブプロジェクトの初期セットアップでは以下を行う。

* コンテナ用ウェブプロジェクトの生成
* コンテナ用ウェブプロジェクトの動作確認
* コンテナイメージの作成
* コンテナイメージの実行

## 生成するプロジェクトの概要

本手順で生成するプロジェクトの概要は以下の通りである。

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Databaes Engine(アプリケーションに組み込み) |
| 組み込まれているアダプタ | ルーティングアダプタ(詳細は、 [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) を参照) |
| 生成するプロジェクトに含まれるもの | 生成されたプロジェクトには以下が含まれる。  * Nablarchのウェブアプリケーション用の基本的な設定 * 疎通確認用ウェブアプリケーション * Mavenと連動して動作するツールの初期設定( [nablarch-archetype-parent(親プロジェクト)](../../setup/blank-project/blank-project-MavenModuleStructures.md#about-maven-parent-module) を参照することによって取り込んでいる)。 |

他のプロジェクトとの関係、及びディレクトリ構成は、 [Mavenアーキタイプの構成](../../setup/blank-project/blank-project-MavenModuleStructures.md) を参照。

## ブランクプロジェクト作成

Nablarchが提供するアーキタイプを使用してブランクプロジェクトを生成する。

### mvnコマンドの実行

[Maven Archetype Plugin(外部サイト、英語)](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用して、ブランクプロジェクトを生成する。

カレントディレクトリを、ブランクプロジェクトを作成したいディレクトリ(任意のディレクトリで可)に変更する。

その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-web-archetype -DarchetypeVersion={nablarch_version}
```

上記コマンドで使用されているNablarchのバージョンは ​ となっている。バージョンを変更したい場合は、以下のパラメータを変更すること。

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する。（Nablarch 6u2以降を指定すること） |

### プロジェクト情報の入力

上記コマンドを実行すると、以下の項目について入力を求められるので、 生成されるブランクプロジェクトに関する情報を入力する。

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名を入力） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-web` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ(通常はグループIDと同じ) | `com.example` |

> **Important:**
> 項目groupIdおよびpackageは、Javaのパッケージ名にマッピングされる。
> よって、これらの入力値には、英小文字、数字、ドットを使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、Y: :と表示される。

* 入力した内容をもとに、ひな形を生成する場合には「Y」を入力してください。
* プロジェクト情報の入力をやり直したい場合には「N」を入力してください。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

## 疎通確認

疎通確認の仕組みや手順は通常のウェブプロジェクトと同じなので、 [ウェブプロジェクトの初期セットアップ手順](../../setup/blank-project/blank-project-setup-Web.md#firststepwebstartuptest) を参照。

> **Note:**
> アーティファクトID が `myapp-container-web` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

## コンテナイメージを作成する

ブランクプロジェクトには、Dockerコンテナのイメージを作成するために [Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) (外部サイト、英語)というプラグインがあらかじめ組み込まれている。

このプラグインの `jib:dockerBuild` ゴールを実行することで、コンテナイメージを作成できる。

```text
cd myapp-container-web
mvn package jib:dockerBuild
```

実行に成功すると、以下のようなログがコンソールに出力される。

```text
(中略)
[INFO] Built image to Docker daemon as myapp-container-web, myapp-container-web, myapp-container-web:0.1.0
(中略)
[INFO] Executing tasks:
[INFO] [==============================] 100.0% complete
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
(以下略)
```

ビルドされたDockerイメージは、ローカルリポジトリに保存される。
以下のコマンドで、ローカルリポジトリに保存されたイメージを確認できる。

```text
docker image ls
REPOSITORY              TAG         IMAGE ID       CREATED        SIZE
myapp-container-web     0.1.0       dd60cbdc7722   50 years ago   449MB
myapp-container-web     latest      dd60cbdc7722   50 years ago   449MB
```

`myapp-container-web:0.1.0` と `myapp-container-web:latest` という２つのイメージが登録されていることが分かる。

このように、ブランクプロジェクトでは `jib:dockerBuild` を実行すると次の２つのイメージが作成されるように設定されている。

* `${project.artifactId}:latest`
* `${project.artifactId}:${project.version}`

また、初期設定ではベースイメージとして [Tomcat のイメージ](https://hub.docker.com/_/tomcat) (外部サイト、英語)が使用される。

ベースイメージは `jib.from.image` プロパティで変更できる。
例えば、ベースイメージに `tomcat:10.1.34-jre17-temurin-jammy` を使用したい場合は、次のように `pom.xml` に記述する。

```xml
<project>
  <!--省略...-->
  <properties>
    <!--省略...-->
    <jib.from.image>tomcat:10.1.34-jre17-temurin-jammy</jib.from.image>
    <!--省略...-->
  </properties>
  <!--省略...-->
</project>
```

> **Tip:**
> ブランクプロジェクトではイメージをタグで指定しているが、もしもタグが指すイメージが変更されると検証時と異なるバージョンの
> イメージが選択され、アプリケーションの動作に影響が出る可能性がある。
> プロジェクトにおける検証が完了した段階で、バージョンを固定するためにイメージをダイジェストで指定することを推奨する。

> ダイジェストによる設定例を以下に示す。

> ```xml
> <jib.from.image>tomcat@sha256:28fde3a9cf9ff62b250cd2ce5b8981a75eedbe6a37a9954c8432f6f52483cfb8</jib.from.image>
> ```

## コンテナイメージを実行する

作成したコンテナイメージは、次のコマンドで実行できる。

```text
cd myapp-container-web
docker run -d -p 8080:8080 -v %CD%\h2:/usr/local/tomcat/h2 --name myapp-container-web myapp-container-web
```

コンテナが起動したら、ウェブブラウザで `http://localhost:8080/` にアクセスすることで、アプリケーションの動作を確認できる。

> **Tip:**
> 上記コマンドは、データベースとしてブランクプロジェクトにあらかじめ組み込んでいるSAMPLE.h2.dbを使用する場合の例となっている。
> SAMPLE.h2.dbを使用しない場合は、ボリュームの指定(`-v`)は不要になる。

> **Tip:**
> Dockerの実行は、Docker Desktopを使用していることを [前提](../../setup/blank-project/blank-project-beforeFirstStep.md#firststeppreamble) としている。
> Docker Toolboxを使用している場合は、上記例のボリューム指定ではエラーになる。

> Docker Toolboxを使用している場合、DockerはVirtualBox上のVMで動いている。
> このため、ボリュームのホスト側に指定できるパスは、VM上のパスになる。

> Windowsの場合、デフォルトでは `C:\Users` がVM上の `/c/users` にマウントされている。
> したがって、Docker Toolboxを使用している場合は、ボリュームの指定を `-v /c/users/path/to/project/h2:/usr/local/tomcat/h2` のようにしなければならない。

コンテナを終了するには、次のコマンドを実行する。

```text
docker stop myapp-container-web
```

また、コンテナを削除するには、次のコマンドを実行する。

```text
docker rm myapp-container-web
```

## データベースに関する設定を行う

ブランクプロジェクトは、初期状態ではH2 Database Engineを使用するように設定されている。使用するRDBMSを変更する場合は、[使用するRDBMSの変更手順](../../setup/blank-project/blank-project-CustomizeDB.md#customize-db) を参照して設定すること。

またER図からのDDL生成や実行、Entityクラスの自動生成を行うにはgsp-dba-maven-pluginの初期設定および実行を行う。詳細は [gsp-dba-maven-plugin(DBA作業支援ツール)の初期設定方法](../../setup/blank-project/blank-project-addin-gsp.md#gsp-maven-plugin) を参照。

## 補足

H2のデータの確認方法や、ブランクプロジェクトに組み込まれているツールに関しては、 [初期セットアップ手順　補足事項](../../setup/blank-project/blank-project-firststep-complement.md) を参照すること。
