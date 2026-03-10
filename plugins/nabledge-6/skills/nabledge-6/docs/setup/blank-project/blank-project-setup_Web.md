# ウェブプロジェクトの初期セットアップ

## ウェブプロジェクトの初期セットアップ

ウェブプロジェクトの初期セットアップでは以下を行う。

- ウェブプロジェクトの生成
- ウェブプロジェクトの動作確認

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 組み込まれているアダプタ | ルーティングアダプタ（:ref:`router_adaptor` 参照） |
| 生成プロジェクトに含まれるもの | Nablarchウェブアプリケーション用基本設定、疎通確認用ウェブアプリケーション、Mavenと連動するツールの初期設定（:ref:`about_maven_parent_module` 参照） |

プロジェクト間の関係とディレクトリ構成については [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md) を参照。

## ブランクプロジェクト作成

Nablarchが提供するアーキタイプを使用してブランクプロジェクトを生成する。

**Mavenコマンド**:

まず、ブランクプロジェクトを作成したいディレクトリ（任意のディレクトリで可）にカレントディレクトリを変更する。その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-web-archetype -DarchetypeVersion={nablarch_version}
```

> **重要**: `archetypeVersion`にはNablarch 6u2以降のバージョンを指定すること。

**プロジェクト情報の入力項目**:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-web` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: `groupId`および`package`はJavaのパッケージ名にマッピングされる。英小文字・数字・ドットのみ使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :`と表示される。

- `Y`を入力すると、入力した内容をもとにひな形を生成する。
- `N`を入力すると、プロジェクト情報の入力をやり直せる。

## 疎通確認

**自動テスト**:

テストクラス `SampleActionRequestTest` — Nablarchテスティングフレームワークを使用して画面表示可能かを確認する。

```text
cd myapp-web
mvn test
```

実行に成功すると、以下のようなログがコンソールに出力される。

```text
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] BUILD SUCCESS
```

**起動確認**:

生成したプロジェクトには以下の画面が含まれている。

| 画面表示に使用するクラス | 内容 |
|---|---|
| SampleAction | ウェブアプリケーション実装する際に一般的に使用するNablarchの機能についての動作確認 |

まだ、生成したプロジェクトにカレントディレクトリを移動していない場合は移動する。

```text
cd myapp-web
```

その後、以下のコマンドを実行することで、疎通確認用のアプリケーションをビルドしてから起動する。

```text
mvn jetty:run
```

> **ヒント**: アプリケーションのビルドを行う`compile`ゴールは`jetty:run`で合わせて実行されるため、明示的に実行する必要はない。

起動に成功すると、コンソールに以下のようなログが出力される。

```text
2023-03-30 10:04:42.148 -INFO- nablarch.fw.web.servlet.NablarchServletContextListener [null] boot_proc = [] proc_sys = [web] req_id = [null] usr_id = [null] [nablarch.fw.web.servlet.NablarchServletContextListener#contextInitialized] initialization completed.
```

起動成功後、ブラウザで `http://localhost:9080/` にアクセスして疎通確認画面を表示し、ログにエラーがないことを確認する。

**疎通確認に失敗する場合**: 原因不明の場合は :ref:`firstStepGenerateWebBlankProject` からやり直すこと。

## データベースに関する設定を行う

ブランクプロジェクトはデフォルトでH2 Database Engineを使用する設定となっている。

- 使用するRDBMSを変更する場合は :ref:`customize-db` を参照。
- ER図からのDDL生成・実行、Entityクラスの自動生成にはgsp-dba-maven-pluginの初期設定および実行が必要。詳細は :ref:`gsp-maven-plugin` を参照。

## 補足（web.xml）

JNDI経由で接続を取得する場合、`web.xml`に`<resource-ref>`要素の定義が必要。`web.xml`は環境別に分けず共用する設定となっている。

本番環境のみJNDI経由で接続する場合、`<resource-ref>`要素はローカル開発環境では不要な定義となるが、アプリケーション内でその定義を使用するコードを記述しない限り参照されないため、ローカル環境での動作に問題は発生しない。

## 補足

H2のデータ確認方法やブランクプロジェクトに組み込まれているツールについては [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。
