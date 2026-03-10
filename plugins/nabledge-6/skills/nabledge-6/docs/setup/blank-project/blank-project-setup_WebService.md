# RESTfulウェブサービスプロジェクトの初期セットアップ

## RESTfulウェブサービスプロジェクトの初期セットアップ

RESTfulウェブサービスブランクプロジェクトの初期セットアップ手順。以下の2つの作業を行う:

- RESTfulウェブサービスプロジェクトの生成
- RESTfulウェブサービスプロジェクトの動作確認

## 事前準備

起動確認（:ref:`setup_webService_startup_test`）で使用するため、以下のいずれかをインストールしておく必要がある。

- Firefox
- Chrome

## 生成するプロジェクトの概要

生成されるプロジェクトの仕様:

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | Jersey用アダプタ（:ref:`jaxrs_adaptor`）、ルーティングアダプタ（:ref:`router_adaptor`） |
| 含まれるもの | NablarchのRESTfulウェブサービス用基本設定、疎通確認用RESTfulウェブサービス、Mavenと連動するツールの初期設定（:ref:`about_maven_parent_module`） |

他のプロジェクトとの関係・ディレクトリ構成: [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md)

## ブランクプロジェクト作成

[Maven Archetype Plugin](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用してブランクプロジェクトを生成する。

### mvnコマンドの実行

任意のディレクトリに移動後、以下のコマンドを実行する:

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-jaxrs-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョン。Nablarch 6u2以降を指定すること。 |

### プロジェクト情報の入力

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-jaxrs` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字・数字・ドットのみ使用可、ハイフンは使用不可。

入力完了後、「Y」で生成確定、「N」で入力やり直し。正常終了するとカレントディレクトリ配下にブランクプロジェクトが作成される。

## 疎通確認

### 自動テスト

生成プロジェクトに含まれるユニットテスト:

| ユニットテストクラス | テスト内容 |
|---|---|
| SampleActionTest | DBアクセスを伴うテストが可能かを確認する |

実行コマンド:

```text
cd myapp-jaxrs
mvn test
```

成功時ログ（抜粋）: `Tests run: 4, Failures: 0, Errors: 0, Skipped: 0` / `BUILD SUCCESS`

> **補足**: MavenのBuilt-in Lifecycleについては [Built-in Lifecycle Bindings](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Built-in_Lifecycle_Bindings) を参照。

### 起動確認

生成プロジェクトに含まれるサービス:

| クラス | 内容 |
|---|---|
| SampleAction | RESTfulウェブサービスの動作確認用サービス。JSONレスポンスとXMLレスポンスの2種類が存在する。 |

起動コマンド:

```text
cd myapp-jaxrs
mvn jetty:run
```

> **補足**: `jetty:run` はJetty Maven Pluginのrunゴール。compileゴールも合わせて実行されるため明示的な実行不要。[Jetty Maven Plugin](https://jetty.org/docs/jetty/12/programming-guide/maven-jetty/jetty-maven-plugin.html) 参照。

起動に成功するとコンソールに以下のようなログが出力される:

```text
2020-04-28 08:46:53.366 -INFO- nablarch.fw.web.servlet.NablarchServletContextListener [null] boot_proc = [] proc_sys = [jaxrs] req_id = [null] usr_id = [null] [nablarch.fw.web.servlet.NablarchServletContextListener#contextInitialized] initialization completed.
```

### 応答にJSONを使用するサービスを呼び出す

JSONサービス確認URL: `http://localhost:9080/find/json`（末尾の「/」は不要）

成功時レスポンス例:
```text
[{"userId":1,"kanjiName":"名部楽太郎","kanaName":"なぶらくたろう"},{"userId":2,"kanjiName":"名部楽次郎","kanaName":"なぶらくじろう"}]
```

> **注意**: Firefox/Chromeの代わりにInternet Explorer 11を使用すると、ダウンロードするか否かの確認メッセージが表示される。

### 応答にXMLを使用するサービスを呼び出す

XMLサービス確認URL: `http://localhost:9080/find/xml`（末尾の「/」は不要）

成功時レスポンス例:
```xml
<userList>
  <sampleUser>
    <kanaName>なぶらくたろう</kanaName>
    <kanjiName>名部楽太郎</kanjiName>
    <userId>1</userId>
  </sampleUser>
  <sampleUser>
    <kanaName>なぶらくじろう</kanaName>
    <kanjiName>名部楽次郎</kanjiName>
    <userId>2</userId>
  </sampleUser>
</userList>
```

疎通確認に失敗する場合は :ref:`firstStepGenerateJaxrsBlankProject` からやり直すこと。

## データベースに関する設定を行う

ブランクプロジェクトはデフォルトでH2 Database Engineを使用するよう設定されている。RDBMSを変更する場合は :ref:`customize-db` を参照して設定すること。

ER図からのDDL生成・実行、Entityクラスの自動生成を行う場合は、gsp-dba-maven-pluginの初期設定および実行が必要。詳細は :ref:`gsp-maven-plugin` を参照。

## 補足

H2のデータ確認方法およびブランクプロジェクトに組み込まれているツールについては [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。
