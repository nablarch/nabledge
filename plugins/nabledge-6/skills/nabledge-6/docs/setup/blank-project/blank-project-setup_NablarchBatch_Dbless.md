# Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ

## Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ

Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップでは以下を行う。

1. Nablarchバッチ（DB接続無し）プロジェクトの生成
2. Nablarchバッチ（DB接続無し）プロジェクトの動作確認

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 含まれるもの | Nablarchバッチアプリケーション用の基本的な設定、疎通確認用の都度起動バッチアプリケーション、Mavenと連動して動作するツールの初期設定（:ref:`about_maven_parent_module` 参照） |

他のプロジェクトとの関係、及びディレクトリ構成は [../MavenModuleStructures/index](blank-project-MavenModuleStructures.md) を参照。

## ブランクプロジェクト作成

[Maven Archetype Plugin(外部サイト、英語)](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用してブランクプロジェクトを生成する。

まず、ブランクプロジェクトを作成したいディレクトリ（任意のディレクトリで可）にカレントディレクトリを変更する。

その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-dbless-archetype -DarchetypeVersion={nablarch_version}
```

バージョン変更時は以下のパラメータを変更すること:

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する（Nablarch 6u2以降を指定すること） |

プロジェクト情報の入力項目:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-batch-dbless` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。入力値には英小文字、数字、ドットを使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :` と表示される。

- 入力した内容をもとにひな形を生成する場合には「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合には「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

## 疎通確認(都度起動バッチ)

### 自動テスト（都度起動バッチ）

| ユニットテストクラス | テスト内容 |
|---|---|
| SampleBatchActionRequestTest | Nablarchのテスティングフレームワークを使用して、バッチを起動可能であるかを確認する |

```text
cd myapp-batch-dbless
mvn test
```

実行に成功すると、以下のようなログがコンソールに出力される。

```text
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

### 起動テスト（都度起動バッチ）

| バッチクラス | 内容 |
|---|---|
| SampleAction | バッチアプリケーション実装する際に一般的に使用するNablarchの機能の動作確認 |

バッチアプリケーションのビルド:

```text
cd myapp-batch-dbless
mvn package
```

都度起動バッチアプリケーションの起動:

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-diConfig' 'classpath:batch-boot.xml' '-requestPath' 'SampleBatch' '-userId' 'batch_user'"
```

起動に成功すると、以下のようなログがコンソールに出力される。

```text
2020-04-28 08:56:23.353 -INFO- com.example.SampleBatch [...] 疎通確認を開始します。
2020-04-28 08:56:23.383 -INFO- com.example.SampleBatch [...] 疎通確認が完了しました。
2020-04-28 08:56:23.396 -INFO- nablarch.fw.handler.MultiThreadExecutionHandler [...] 
Thread Status: normal end.
Thread Result:[200 Success] The request has succeeded.
2020-04-28 08:56:23.413 -INFO- nablarch.fw.launcher.Main [...] @@@@ END @@@@ exit code = [0]
```

## 補足

ブランクプロジェクトに組み込まれているツールについては [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照すること。
