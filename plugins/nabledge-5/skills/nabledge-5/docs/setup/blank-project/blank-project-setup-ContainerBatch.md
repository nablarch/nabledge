# コンテナ用Nablarchバッチプロジェクトの初期セットアップ

コンテナ用Nablarchバッチプロジェクトの初期セットアップでは以下を行う。

* コンテナ用Nablarchバッチプロジェクトの生成
* コンテナ用Nablarchバッチプロジェクトの動作確認
* コンテナイメージの作成
* コンテナイメージの実行

## 生成するプロジェクトの概要

本手順で生成するプロジェクトの概要は以下の通りである。

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Databaes Engine(アプリケーションに組み込み) |
| 生成するプロジェクトに含まれるもの | 生成されたプロジェクトには以下が含まれる。  * Nablarchバッチアプリケーション用の基本的な設定 * 疎通確認用の都度起動バッチアプリケーション * 疎通確認用のテーブルをキューとして使ったメッセージング * メール送信バッチの設定  [1] * Mavenと連動して動作するツールの初期設定( [nablarch-archetype-parent(親プロジェクト)](../../setup/blank-project/blank-project-MavenModuleStructures.md#about-maven-parent-module) を参照することによって取り込んでいる)。 |

メール送信バッチは、[常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-resident-batch)  として動作し、SMTPサーバに対してメールを送信するものである。
コンポーネント設定ファイルのサンプルは `src/main/resources/mail-sender-boot.xml` に存在する。
メール送信バッチは初期環境構築時には必要ないが、必要になったタイミングで [メール送信](../../component/libraries/libraries-mail.md#mail) の解説を読んだ上で使用する。

他のプロジェクトとの関係、及びディレクトリ構成は、 [Mavenアーキタイプの構成](../../setup/blank-project/blank-project-MavenModuleStructures.md) を参照。

## ブランクプロジェクト作成

Nablarchが提供するアーキタイプを使用してブランクプロジェクトを生成する。

### mvnコマンドの実行

[Maven Archetype Plugin(外部サイト、英語)](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用して、ブランクプロジェクトを生成する。

カレントディレクトリを、ブランクプロジェクトを作成したいディレクトリ(任意のディレクトリで可)に変更する。

その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-batch-archetype -DarchetypeVersion={nablarch_version}
```

上記コマンドで使用されているNablarchのバージョンは ​ となっている。バージョンを変更したい場合は、以下のパラメータを変更すること。

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する。（Nablarch 5u25以降を指定すること） |

> **Tip:**
> Nablarch 5u24以前のバージョンでブランクプロジェクトを生成したい場合は、上記コマンドの `archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更して以下の例のように実行すること。

> ```bat
> mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-container-batch-archetype -DarchetypeVersion=5u24
> ```

> この例で使用されているNablarchのバージョンは 5u24 となっている。バージョン変更したい場合は、同様にパラメータarchetypeVersionを変更すること。

### プロジェクト情報の入力

上記コマンドを実行すると、以下の項目について入力を求められるので、 生成されるブランクプロジェクトに関する情報を入力する。

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名を入力） | `com.example` |
| artifactId | アーティファクトID | `myapp-container-batch` |
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

疎通確認の仕組みや手順は通常のNablarchバッチプロジェクトと同じなので、 [Nablarchバッチプロジェクトの初期セットアップ手順](../../setup/blank-project/blank-project-setup-NablarchBatch.md#firststepbatchstartuptest) を参照。

> **Note:**
> アーティファクトID が `myapp-container-batch` になっている点は、適宜読み替えてディレクトリやコマンドを指定すること。

## コンテナイメージを作成する

ブランクプロジェクトには、Dockerコンテナのイメージを作成するために [Jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) (外部サイト、英語)というプラグインがあらかじめ組み込まれている。

このプラグインの `jib:dockerBuild` ゴールを実行することで、コンテナイメージを作成できる。

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

ビルドされたDockerイメージは、ローカルリポジトリに保存される。
以下のコマンドで、ローカルリポジトリに保存されたイメージを確認できる。

```text
docker image ls
REPOSITORY              TAG         IMAGE ID       CREATED        SIZE
myapp-container-batch   0.1.0       1cafd4108237   51 years ago   253MB
myapp-container-batch   latest      1cafd4108237   51 years ago   253MB
```

`myapp-container-batch:0.1.0` と `myapp-container-batch:latest` という２つのイメージが登録されていることが分かる。

このように、ブランクプロジェクトでは `jib:dockerBuild` を実行すると次の２つのイメージが作成されるように設定されている。

* `${project.artifactId}:latest`
* `${project.artifactId}:${project.version}`

また、初期設定ではベースイメージとして [OpenJDK のイメージ](https://hub.docker.com/_/adoptopenjdk) (外部サイト、英語)が使用される。

ベースイメージは `jib.from.image` プロパティで変更できる。
例えば、ベースイメージに `adoptopenjdk:11.0.11_9-jre-hotspot` を使用したい場合は、次のように `pom.xml` に記述する。

```xml
<project>
  <!--省略...-->
  <properties>
    <!--省略...-->
    <jib.from.image>adoptopenjdk:11.0.11_9-jre-hotspot</jib.from.image>
    <!--省略...-->
  </properties>
  <!--省略...-->
</project>
```

> **Tip:**
> ブランクプロジェクトではイメージをタグで指定しているが、この場合、指定したイメージの最新バージョンが選択される。
> 検証時と異なるバージョンが選択された場合、アプリケーションの動作に影響が出る可能性があるので、
> プロジェクトにおける検証が完了した段階で、バージョンを固定するために、イメージをダイジェストで指定することを推奨する。

> ダイジェストによる設定例を以下に示す。

> ```xml
> <jib.from.image>adoptopenjdk@sha256:df316691a2c655de2f835a626f8611c74af67dad2cf92711f6608b54e5aa6c61</jib.from.image>
> ```

## コンテナイメージを実行する

作成したコンテナイメージは、次のコマンドで実行できる。

### 都度起動バッチ

```text
cd myapp-container-batch
docker run --rm -v %CD%\\h2:/h2 -v %CD%\\src\\main\\format:/var/nablarch/format -v %CD%\\work\\output:/var/nablarch/output --name myapp-container-batch myapp-container-batch:latest -diConfig classpath:batch-boot.xml -requestPath SampleBatch -userId batch_user
```

動作は [疎通確認(都度起動バッチ)](../../setup/blank-project/blank-project-setup-NablarchBatch.md#firststepbatchstartuptest) と同じである。
起動に成功すると、[都度起動バッチアプリケーションの起動](../../setup/blank-project/blank-project-setup-NablarchBatch.md#firststepbatchexecondemandbatch) と同様なログがコンソールに出力される。

### テーブルをキューとして使ったメッセージング

```text
cd myapp-container-batch
docker run -it --rm -v %CD%\\h2:/h2 --name myapp-container-batch myapp-container-batch:latest -diConfig classpath:resident-batch-boot.xml -requestPath SampleResiBatch -userId batch_user
```

動作は [疎通確認(テーブルをキューとして使ったメッセージング)](../../setup/blank-project/blank-project-setup-NablarchBatch.md#firststepbatchstartuptestdbmessagingbatch) と同じである。
起動に成功すると、[アプリケーションの起動](../../setup/blank-project/blank-project-setup-NablarchBatch.md#firststepbatchexecdbmessagingbatch) と同様なログがコンソールに出力される。
待機状態となるので、確認後はctrl+c等で強制終了させる。

## 補足

コンテナイメージの実行コマンドについて
* 上記コマンドを実行すると、コンテナが起動し、バッチ処理実行後、コンテナは自動的に終了する。
  また、 `-rmオプション` により、コンテナ終了時に、コンテナを自動削除するようにしている。
* 上記コマンドは、データベースとしてブランクプロジェクトにあらかじめ組み込んでいるSAMPLE.h2.dbを使用する場合の例となっている。
  SAMPLE.h2.dbを使用しない場合は、`%CD%\\h2:/h2` のボリュームの指定(`-v`)は不要になる。
* [都度起動バッチ](../../setup/blank-project/blank-project-setup-ContainerBatch.md#firststepcontainerbatchstartupinnerbatchondemand) では上記に加えてブランクプロジェクトの `./work/format` , `./work/output` のディレクトリをコンテナにマウントしている。
* [テーブルをキューとして使ったメッセージング](../../setup/blank-project/blank-project-setup-ContainerBatch.md#firststepcontainerbatchstartupinnerbatchdbmessaging) においてもdockerコマンドの `-itオプション` は省略できるが、ホスト側からのctrl+cでバッチを強制終了できなくなる。
  その場合は、以下のコマンドにてコンテナを終了させればよい。

  ```text
  docker stop myapp-container-batch
  ```
Docker環境について
Dockerの実行は、Docker Desktopを使用していることを [前提](../../setup/blank-project/blank-project-beforeFirstStep.md#firststeppreamble) としている。
Docker Toolboxを使用している場合は、上記例のボリューム指定ではエラーになる。

Docker Toolboxを使用している場合、DockerはVirtualBox上のVMで動いている。
このため、ボリュームのホスト側に指定できるパスは、VM上のパスになる。

Windowsの場合、デフォルトでは `C:\Users` がVM上の `/c/users` にマウントされている。
したがって、Docker Toolboxを使用している場合は、ボリュームの指定を `-v /c/users/path/to/project/h2:/usr/local/tomcat/h2` のようにしなければならない。
H2、ツールについて
H2のデータの確認方法や、ブランクプロジェクトに組み込まれているツールに関しては、 [初期セットアップ手順　補足事項](../../setup/blank-project/blank-project-firststep-complement.md) を参照すること。
