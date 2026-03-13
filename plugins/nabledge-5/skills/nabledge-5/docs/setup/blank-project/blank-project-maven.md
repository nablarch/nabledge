# Apache Mavenについて

**公式ドキュメント**: [Apache Mavenについて](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/maven.html)

## Mavenとは / Mavenリポジトリ / インストール / Mavenの設定

Nablarchはモジュール管理にApache Mavenの使用を推奨している。ブランクプロジェクトの生成にもMavenを使用する。

## Mavenとは

Mavenのビルドツールとしての主な特徴:

| 特徴 | 説明 |
|---|---|
| ブランクプロジェクトの生成機能 | アーキタイプと呼ばれるテンプレートに沿ったブランクプロジェクトを生成できる。Nablarchのプロジェクトもこの機能で生成可能 |
| 依存関係の管理機能 | プロジェクトが依存するライブラリをリポジトリから自動ダウンロード |
| モデルベースビルド | WAR、JARといったモデルをスクリプトを書くことなく生成できる |
| プラグインによる機能拡張 | プラグインを組み込むことでコンパイル時等に自動実行可能。プラグイン単独での起動も可能 |

## Mavenリポジトリ

Nablarch開発で登場するリポジトリ:

| 名称 | 説明 |
|---|---|
| Local Repository | mvnコマンドを実行するマシン上に自動作成されるリポジトリ。他リポジトリから取得したjarをキャッシュする |
| Project Local Repository | 各プロジェクト固有のjarを格納するリポジトリ。複数モジュール開発時の共通部品や、プロプライエタリなライブラリ（RDBMSのJDBCドライバ等）の格納に使用 |
| Maven Central Repository | Nablarchが依存するモジュール、Mavenの各種プラグイン、各種OSSが格納されているリポジトリ |
| 3rd Party Repository | プロダクト独自のMavenリポジトリ（例: http://maven.seasar.org/maven2/） |

> **補足**: Project Local Repositoryの管理ツール（Artifactory等）にはプロキシ機能があり、インターネットへ直接接続できない環境でも、Project Local Repository経由でモジュールを取得できる。

## Mavenのインストール方法

- ダウンロード元: [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
- インストール方法: [https://maven.apache.org/install.html](https://maven.apache.org/install.html)
- インストールするバージョンは :ref:`firstStepPreamble` を参照

インストール後に設定が必要な環境変数:

| 環境変数 | 説明 |
|---|---|
| JAVA_HOME | JDKのインストールされているディレクトリを設定する |
| PATH | Mavenをインストールしたディレクトリのbinディレクトリをパスに追加する |

## Mavenの設定

MavenはデフォルトではMaven Central RepositoryのURLしか保持していないため、Project Local Repositoryと3rd Party RepositoryのURLを設定する必要がある。

設定ファイル: `<ホームディレクトリ>/.m2/settings.xml`

> **重要**: 設定ファイルは `~/.m2/settings.xml` と `<Mavenインストール先>/conf/settings.xml` の2箇所に存在する。両方を併用すると設定の優先順位が不明確になるため、どちらか一方のみ使用すること。

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

> **補足**: プロキシを使用する設定の場合、必要に応じて `nonProxyHosts`（除外設定）を記述すること。Project Local Repositoryがローカルネットワーク環境にある場合は除外設定が必要となる。
> ```xml
> <proxies>
>   <proxy>
>     <id>proxy1</id>
>     <active>true</active>
>     <protocol>http</protocol>
>     <host><!-- プロキシサーバのホスト --></host>
>     <port><!-- プロキシサーバのポート --></port>
>     <nonProxyHosts>localhost|127.0.0.1|<!-- Project Local Repository --></nonProxyHosts>
>   </proxy>
>   <proxy>
>     <id>proxy2</id>
>     <active>true</active>
>     <protocol>https</protocol>
>     <host><!-- プロキシサーバのホスト --></host>
>     <port><!-- プロキシサーバのポート --></port>
>     <nonProxyHosts>localhost|127.0.0.1|<!-- Project Local Repository --></nonProxyHosts>
>   </proxy>
> </proxies>
> ```

<details>
<summary>keywords</summary>

Maven, Apache Maven, pom.xml, settings.xml, Mavenリポジトリ, Local Repository, Project Local Repository, Maven Central Repository, 3rd Party Repository, Mavenインストール, 環境変数JAVA_HOME, 環境変数PATH, 依存関係管理, ブランクプロジェクト生成, リポジトリ設定, nonProxyHosts, プロキシ設定

</details>

## Return code is: 503 , ReasonPhrase:Service Unavailable.が返ってくる

MavenリポジトリにURLが到達できない場合、以下のようなエラーが出力される:

```
Return code is: 503 , ReasonPhrase:Service Unavailable.
```

この場合、`repository` の設定や `proxy` の設定が誤っていないか確認すること。

<details>
<summary>keywords</summary>

503エラー, Service Unavailable, Mavenリポジトリ接続エラー, プロキシ設定エラー, repository設定, Maven依存解決エラー

</details>

## Mavenのゴール

Mavenを実行する際のゴール指定例: `mvn clean`

使用頻度の高いゴール:

| ゴール | 説明 |
|---|---|
| [archetype:generate](https://maven.apache.org/archetype/maven-archetype-plugin/generate-mojo.html) | ブランクプロジェクトを生成する。どのようなプロジェクトを生成するかは実行時引数で指定 |
| [clean](https://maven.apache.org/plugins/maven-clean-plugin/) | ビルドに使用するワークディレクトリ（targetディレクトリ）を削除する |
| [install](https://maven.apache.org/plugins/maven-install-plugin/) | モジュールをビルドし、ローカルリポジトリにインストールする |
| [test](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Lifecycle_Reference) | ユニットテストを実行する |
| [package](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Lifecycle_Reference) | warまたはjarを生成する。どちらが生成されるかはpom.xmlで決定。test等のwarファイル生成に必要なゴールも合わせて実行される |
| [dependency:tree](https://maven.apache.org/plugins/maven-dependency-plugin/tree-mojo.html) | 依存するモジュールをツリー表示する |

<details>
<summary>keywords</summary>

Mavenゴール, archetype:generate, clean, install, test, package, dependency:tree, mvnコマンド, ブランクプロジェクト生成, 依存モジュールツリー

</details>

## mvnコマンドの結果が期待と異なる

mvnコマンドの結果が期待と異なる場合（warに想定外のファイルが含まれる等）の対処法:

1. IDEを終了する
2. `mvn clean` を実行する
3. 本来実行したかったゴールを実行する

原因:
- IDEが自動的にビルドした結果を使用してしまっている
- 前回のビルド結果を参照してしまっている

<details>
<summary>keywords</summary>

mvnコマンド, ビルド結果が期待と異なる, IDEビルド競合, mvn clean, ビルドキャッシュ, 前回ビルド結果

</details>
