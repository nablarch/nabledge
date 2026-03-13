# ウェブプロジェクトの初期セットアップ

**公式ドキュメント**: [ウェブプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Web.html)

## ウェブプロジェクトの初期セットアップ

ウェブプロジェクトの初期セットアップ手順。ブランクプロジェクトの生成と動作確認（自動テスト・起動確認）を行う。

<details>
<summary>keywords</summary>

ウェブプロジェクト初期セットアップ, ブランクプロジェクト生成, 動作確認

</details>

## 生成するプロジェクトの概要

生成されるプロジェクトの概要：

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | ルーティングアダプタ（[router_adaptor](../../component/adapters/adapters-router_adaptor.md) 参照） |
| 含まれるもの | Nablarchのウェブアプリケーション用の基本設定、疎通確認用ウェブアプリケーション、Mavenと連動するツールの初期設定（[about_maven_parent_module](blank-project-MavenModuleStructures.md) 参照） |

<details>
<summary>keywords</summary>

Mavenプロジェクト, H2 Database Engine, ルーティングアダプタ, router_adaptor, 単一プロジェクト構成, about_maven_parent_module

</details>

## ブランクプロジェクト作成

### mvnコマンドの実行

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-web-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョン（Nablarch 5u25以降を指定） |

> **補足**: Nablarch 5u24以前でブランクプロジェクトを生成する場合は、`archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更して実行すること。
> ```bat
> mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-web-archetype -DarchetypeVersion=5u24
> ```

### プロジェクト情報の入力

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-web` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字・数字・ドットのみ使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :` と表示される。

- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

nablarch-web-archetype, mvn archetype:generate, archetypeVersion, groupId, artifactId, version, package, Maven Archetype Plugin, ブランクプロジェクト作成, プロジェクト情報入力

</details>

## 疎通確認

### 自動テスト

| ユニットテストクラス | テスト内容 |
|---|---|
| `SampleActionRequestTest` | Nablarchのテスティングフレームワークを使用して画面表示可能かを確認 |

```text
cd myapp-web
mvn test
```

### 起動確認

| 画面表示クラス | 内容 |
|---|---|
| `SampleAction` | ウェブアプリケーション実装時に一般的に使用するNablarchの機能の動作確認 |

```text
cd myapp-web
mvn compile
mvn waitt:run
```

> **補足**: `waitt:run` は [waitt maven plugin](https://github.com/kawasima/waitt) のrunゴール。起動成功時はブラウザが自動的に立ち上がり疎通確認画面が表示される。

起動に成功したら、表示されたページの内容を読み成功していることを確認する。また、ログを確認しエラーが出ていないことを確認する。

疎通確認に失敗する場合は、:ref:`firstStepGenerateWebBlankProject` からやり直すこと。

<details>
<summary>keywords</summary>

SampleActionRequestTest, SampleAction, mvn test, waitt:run, 自動テスト, 起動確認, 疎通確認, firstStepGenerateWebBlankProject

</details>

## 補足（web.xml）

JNDI経由で接続を取得する場合、web.xmlに`<resource-ref>`要素の定義が必要。web.xmlは環境別に分けず共用する設計。

本番環境のみJNDI経由で接続する場合、`<resource-ref>`要素はローカル開発環境では不要だが、アプリケーション内でその定義を使用するコードを書かない限り`<resource-ref>`要素は使用されないため、ローカル環境での動作に問題は発生しない。

> **補足**: waitt maven pluginが起動するTomcatには独自のserver.xmlを読み込ませることができない。そのため、waitt maven pluginを使用する場合、web.xmlに`<resource-ref>`要素を定義してもJNDIは使用できない。

<details>
<summary>keywords</summary>

web.xml, resource-ref, JNDI, waitt maven plugin, Tomcat, JNDI接続制約

</details>

## 補足

H2のデータ確認方法やブランクプロジェクトに組み込まれているツールの詳細については、[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。

<details>
<summary>keywords</summary>

H2データ確認, firststep_complement, 組み込みツール

</details>
