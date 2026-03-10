# Apache Mavenについて

**公式ドキュメント**: [Apache Mavenについて](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/maven.html)

## Maven概要・リポジトリ・インストール

Nablarchはモジュール管理にApache Mavenの使用を推奨している。ブランクプロジェクトの生成もMavenを使用する。

MavenはApache Software Foundationで開発しているビルドツールである。ビルドや単体テストの実行を、簡単な設定ファイル（pom.xmlと呼ばれる）で実現することができる。

**Mavenの特徴:**

| 特徴 | 説明 |
|---|---|
| ブランクプロジェクトの生成 | アーキタイプを使用してNablarchプロジェクトを生成できる |
| 依存関係の管理 | 依存ライブラリをリポジトリから自動ダウンロード |
| モデルベースビルド | WAR/JARをスクリプトなしで生成 |
| プラグインによる機能拡張 | プラグインをコンパイル時等に自動実行、または単独起動が可能 |

**Mavenリポジトリの種類:**

| 名称 | 説明 |
|---|---|
| Local Repository | mvnコマンドを実行するマシン上に自動作成されるキャッシュリポジトリ |
| Project Local Repository | プロジェクト固有のjar格納（共通部品、プロプライエタリなライブラリ等） |
| Maven Central Repository | Nablarchが依存するモジュールおよび各種OSSを格納 |
| 3rd Party Repository | プロダクト独自のMavenリポジトリ（例: gsp-dba-maven-pluginが使用するjar: http://maven.seasar.org/maven2/ ） |

> **補足**: Project Local Repositoryの管理ツール（Artifactory等）にはプロキシ機能がある。mvnコマンドを実行するマシンがインターネットに直接接続できない環境でも、Project Local Repository経由でモジュールを取得できる。

**インストール:**

インストールするバージョンは :ref:`firstStepPreamble` を参照。

| サイト | URL |
|---|---|
| ダウンロード元 | [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi) |
| インストール方法 | [https://maven.apache.org/install.html](https://maven.apache.org/install.html) |

インストール後に以下の環境変数を設定すること:

| 環境変数 | 説明 |
|---|---|
| JAVA_HOME | JDKのインストールされているディレクトリを設定 |
| PATH | mavenのインストールディレクトリのbinをパスに追加 |

<details>
<summary>keywords</summary>

Apache Maven, ブランクプロジェクト生成, アーキタイプ, Mavenリポジトリ, Local Repository, Project Local Repository, Maven Central Repository, 3rd Party Repository, インストール, JAVA_HOME, PATH, pom.xml

</details>

## Return code is: 503エラー

503エラーが返る場合、Mavenリポジトリに到達できていないことが多い。`repository`の設定や`proxy`の設定が誤っていないか確認すること。

```text
[ERROR] Failed to execute goal on project myapp-batch: Could not resolve dependencies for project com.example:myapp-batch:jar:0.1.0: Failed to collect dependencies at com.nablarch.profile:nablarch-batch:jar:1.0.4 -> com.nablarch.framework:nablarch-fw-batch:jar:1.0.0: Failed to read artifact descriptor for com.nablarch.framework:nablarch-fw-batch:jar:1.0.0: Could not transfer artifact com.nablarch.framework:nablarch-fw-batch:pom:1.0.0 from/to nablarch-example-release (http://nablarch.intra.tis.co.jp/repository/nablarch-release): Failed to transfer file: http://nablarch.intra.tis.co.jp/repository/nablarch-release/com/nablarch/framework/nablarch-fw-batch/1.0.0/nablarch-fw-batch-1.0.0.pom. Return code is: 503 , ReasonPhrase:Service Unavailable. -> [Help 1]
```

<details>
<summary>keywords</summary>

503エラー, Service Unavailable, 依存関係解決エラー, Mavenリポジトリ接続失敗, Return code is: 503, nablarch-example-release

</details>

## Mavenの設定とゴール

**Mavenの設定 (`~/.m2/settings.xml`):**

Mavenの初期状態はMaven Central RepositoryのURLのみ保持している。Project Local RepositoryおよびThird Party RepositoryのURLを `<ホームディレクトリ>/.m2/settings.xml` に設定する必要がある。

> **重要**: `<Mavenのインストール先>/conf/settings.xml` にも設定ファイルが存在する。両方の設定ファイルを併用すると混乱の元となるため、どちらか一方のみ使うこと。

Project Local Repositoryの設定例:

```xml
<settings>
  <profiles>
    <profile>
      <id>my-repository</id>
      <repositories>
        <repository>
          <id>my-repository-release</id>
          <url><!-- Project Local Release Repository の URL --></url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>false</enabled></snapshots>
        </repository>
        <repository>
          <id>my-repository-snapshot</id>
          <url><!-- Project Local Snapshot Repository の URL --></url>
          <releases><enabled>false</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>my-repository-release</id>
          <url><!-- Project Local Release Repository の URL --></url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>false</enabled></snapshots>
        </pluginRepository>
        <pluginRepository>
          <id>my-repository-snapshot</id>
          <url><!-- Project Local Snapshot Repository の URL --></url>
          <releases><enabled>false</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </pluginRepository>
      </pluginRepositories>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>my-repository</activeProfile>
  </activeProfiles>
</settings>
```

> **補足**: プロキシを使用する場合、Project Local Repositoryがローカルネットワーク環境にあるときは `nonProxyHosts`（除外設定）を記述すること。

```xml
<settings>
  <proxies>
    <proxy>
      <id>proxy1</id>
      <active>true</active>
      <protocol>http</protocol>
      <host><!-- プロキシサーバのホスト --></host>
      <port><!-- プロキシサーバのポート--></port>
      <nonProxyHosts>localhost|127.0.0.1|<!-- Project Local Repository --></nonProxyHosts>
    </proxy>
    <proxy>
      <id>proxy2</id>
      <active>true</active>
      <protocol>https</protocol>
      <host><!-- プロキシサーバのホスト --></host>
      <port><!-- プロキシサーバのポート--></port>
      <nonProxyHosts>localhost|127.0.0.1|<!-- Project Local Repository --></nonProxyHosts>
    </proxy>
  </proxies>
</settings>
```

**Mavenのゴール:**

| ゴール | 説明 |
|---|---|
| [archetype:generate](https://maven.apache.org/archetype/maven-archetype-plugin/generate-mojo.html) | ブランクプロジェクト生成。実行時引数でプロジェクト種別を指定 |
| [clean](https://maven.apache.org/plugins/maven-clean-plugin/) | ビルドのワークディレクトリ（targetディレクトリ）を削除 |
| [Install](https://maven.apache.org/plugins/maven-install-plugin/) | モジュールをビルドしてローカルリポジトリにインストール |
| [test](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Lifecycle_Reference) | ユニットテストを実行 |
| [package](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Lifecycle_Reference) | warまたはjarを生成（pom.xmlで決定）。test等の必要なゴールもあわせて実行 |
| [dependency:tree](https://maven.apache.org/plugins/maven-dependency-plugin/tree-mojo.html) | 依存するモジュールをツリー表示 |

<details>
<summary>keywords</summary>

settings.xml, Mavenの設定, nonProxyHosts, プロキシ設定, pluginRepositories, Mavenゴール, archetype:generate, clean, install, test, package, dependency:tree, .m2

</details>

## mvnコマンドの結果が期待と異なる

warに想定外のファイルが含まれる等、mvnコマンドの結果が期待と異なる場合は、IDEを終了し「`mvn clean`」を実行してから本来実行したかったゴールを実行することで解決することがある。

原因:
- IDEが自動的にビルドした結果を使用してしまっている
- 前回のビルド結果を参照してしまっている

<details>
<summary>keywords</summary>

mvn clean, ビルド結果が期待と異なる, IDE, ビルドキャッシュ, targetディレクトリ, warファイル

</details>
