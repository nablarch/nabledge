# RESTfulウェブサービスプロジェクトの初期セットアップ

**公式ドキュメント**: [RESTfulウェブサービスプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_WebService.html)

## RESTfulウェブサービスプロジェクトの初期セットアップ

RESTfulウェブサービスプロジェクトの初期セットアップで行う内容:

1. RESTfulウェブサービスプロジェクトの生成
2. RESTfulウェブサービスプロジェクトの動作確認

<details>
<summary>keywords</summary>

RESTfulウェブサービスプロジェクト初期セットアップ, プロジェクト生成, 動作確認, JAX-RS, ウェブサービス初期化

</details>

## 事前準備

:ref:`setup_webService_startup_test` で使用するため、以下のいずれかをインストールする。

- Firefox
- Chrome

<details>
<summary>keywords</summary>

事前準備, Firefox, Chrome, ブラウザインストール, 起動確認

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | Jersey用アダプタ（[jaxrs_adaptor](../../component/adapters/adapters-jaxrs_adaptor.md)）、ルーティングアダプタ（[router_adaptor](../../component/adapters/adapters-router_adaptor.md)） |
| 含まれるもの | NablarchのRESTfulウェブサービス用の基本設定、疎通確認用RESTfulウェブサービス、Mavenと連動して動作するツールの初期設定（[about_maven_parent_module](blank-project-MavenModuleStructures.md)） |

ディレクトリ構成は [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md) を参照。

<details>
<summary>keywords</summary>

プロジェクト概要, Mavenプロジェクト, H2 Database, Jersey用アダプタ, ルーティングアダプタ, 単一プロジェクト構成, jaxrs_adaptor, router_adaptor

</details>

## ブランクプロジェクト作成

Nablarchが提供するアーキタイプを使用してブランクプロジェクトを生成する。

まず、カレントディレクトリをブランクプロジェクトを作成したいディレクトリ（任意のディレクトリで可）に変更する。

その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-jaxrs-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョン（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前でブランクプロジェクトを生成する場合は、`archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更して実行すること。例: `mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-jaxrs-archetype -DarchetypeVersion=5u24`

コマンド実行後、以下の項目の入力が求められる:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-jaxrs` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字・数字・ドットのみ使用し、ハイフンは使用不可。

プロジェクト情報の入力が終わると、`Y: :` と表示される。

- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

ブランクプロジェクト作成, Maven archetype, nablarch-jaxrs-archetype, archetypeVersion, mvn archetype:generate, groupId, artifactId, 5u25, 5u24

</details>

## 疎通確認

## 自動テスト

アーキタイプから生成したプロジェクトに含まれるユニットテスト:

| ユニットテストのクラス | テスト内容 |
|---|---|
| SampleActionTest | DBアクセスを伴うテストが可能かを確認する |

```
cd myapp-jaxrs
mvn test
```

成功時のログ例:
```
[INFO] Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

## 起動確認

生成したプロジェクトに含まれるサービス:

| クラス | 内容 |
|---|---|
| SampleAction | RESTfulウェブサービス動作確認用。JSONレスポンスとXMLレスポンスのサービスが存在する。 |

サービスの起動手順:

```
cd myapp-jaxrs
mvn compile
mvn waitt:run-headless
```

起動成功時のログ: `initialization completed.`

**JSONサービス確認**: `http://localhost:9080/find/json`（末尾「/」不要）

成功時のレスポンス例:
```json
[{"userId":1,"kanjiName":"名部楽太郎","kanaName":"なぶらくたろう"},{"userId":2,"kanjiName":"名部楽次郎","kanaName":"なぶらくじろう"}]
```

> **注意**: FireFoxまたはChromeの代わりにInternet Explorer 11を使用すると、ダウンロードするか否かの確認メッセージが表示される。

**XMLサービス確認**: `http://localhost:9080/find/xml`（末尾「/」不要）

成功時のレスポンス例:
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

<details>
<summary>keywords</summary>

疎通確認, 自動テスト, SampleActionTest, mvn test, waitt:run-headless, 起動確認, localhost:9080, JSON, XML, SampleAction

</details>

## 補足

H2のデータ確認方法やブランクプロジェクトに組み込まれているツールについては [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。

<details>
<summary>keywords</summary>

補足, H2データ確認, ブランクプロジェクト組み込みツール, firststep_complement

</details>
