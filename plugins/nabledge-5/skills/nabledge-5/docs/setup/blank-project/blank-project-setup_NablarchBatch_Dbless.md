# Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ

**公式ドキュメント**: [Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_NablarchBatch_Dbless.html)

## Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ

Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップでは以下を行う。

1. Nablarchバッチ（DB接続無し）プロジェクトの生成
2. Nablarchバッチ（DB接続無し）プロジェクトの動作確認

<details>
<summary>keywords</summary>

Nablarchバッチ初期セットアップ, DB接続無しバッチプロジェクト, ブランクプロジェクト生成, 動作確認手順

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 生成するプロジェクトに含まれるもの | Nablarchバッチアプリケーション用の基本的な設定、疎通確認用の都度起動バッチアプリケーション、Mavenと連動して動作するツールの初期設定（[about_maven_parent_module](blank-project-MavenModuleStructures.md) 参照） |

<details>
<summary>keywords</summary>

Mavenプロジェクト, 単一プロジェクト構成, ブランクプロジェクト概要, 都度起動バッチ, about_maven_parent_module

</details>

## ブランクプロジェクト作成

[Maven Archetype Plugin](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用してブランクプロジェクトを生成する。

ブランクプロジェクトを作成したいディレクトリ（任意のディレクトリ可）にカレントディレクトリを変更してから、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-dbless-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する。（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前でブランクプロジェクトを生成する場合は、`archetype:generate`を`org.apache.maven.plugins:maven-archetype-plugin:2.4:generate`に変更すること。
>
> ```bat
> mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-dbless-archetype -DarchetypeVersion=5u24
> ```

プロジェクト情報入力項目:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-batch-dbless` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaパッケージ名にマッピングされる。英小文字、数字、ドットのみ使用可。ハイフンは使用不可。

プロジェクト情報の入力が終わると、`Y: :` と表示される。

- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

mvn archetype:generate, nablarch-batch-dbless-archetype, archetypeVersion, groupId, artifactId, Maven Archetype Plugin, Nablarch 5u24, ブランクプロジェクト作成

</details>

## 疎通確認(都度起動バッチ)

**自動テスト（都度起動バッチ）**

| ユニットテストのクラス | テスト内容 |
|---|---|
| SampleBatchActionRequestTest | Nablarchのテスティングフレームワークを使用して、バッチを起動可能であるかを確認する。 |

```text
cd myapp-batch-dbless
mvn test
```

実行に成功すると、以下のようなログがコンソールに出力される。

```text
(中略)
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
(以下略)
```

**起動テスト（都度起動バッチ）**

| バッチのクラス | 内容 |
|---|---|
| SampleAction | バッチアプリケーション実装する際に一般的に使用するNablarchの機能の動作確認 |

ビルド:

まだ、生成したプロジェクトにカレントディレクトリを移動していない場合は移動する。

```text
cd myapp-batch-dbless
```

以下のコマンドを実行することで、バッチアプリケーションのビルドを行う。

```text
mvn package
```

都度起動バッチ起動:

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-diConfig' 'classpath:batch-boot.xml' '-requestPath' 'SampleBatch' '-userId' 'batch_user'"
```

起動に成功すると、以下のようなログがコンソールに出力される。

```text
2020-04-28 08:56:23.353 -INFO- com.example.SampleBatch [202004280856233530002] boot_proc = [] proc_sys = [batch] req_id = [SampleBatch] usr_id = [batch_user] 疎通確認を開始します。
2020-04-28 08:56:23.383 -INFO- com.example.SampleBatch [202004280856233530002] boot_proc = [] proc_sys = [batch] req_id = [SampleBatch] usr_id = [batch_user] 疎通確認が完了しました。
2020-04-28 08:56:23.396 -INFO- nablarch.fw.handler.MultiThreadExecutionHandler [202004280856233470001] boot_proc = [] proc_sys = [batch] req_id = [SampleBatch] usr_id = [batch_user] 
Thread Status: normal end.
Thread Result:[200 Success] The request has succeeded.
2020-04-28 08:56:23.413 -INFO- nablarch.fw.launcher.Main [null] boot_proc = [] proc_sys = [batch] req_id = [null] usr_id = [null] @@@@ END @@@@ exit code = [0] execute time(ms) = [559]
```

<details>
<summary>keywords</summary>

SampleBatchActionRequestTest, SampleAction, mvn test, mvn package, 疎通確認, 都度起動バッチ, nablarch.fw.launcher.Main

</details>

## 補足

ブランクプロジェクトに組み込まれているツールについては、[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照すること。

<details>
<summary>keywords</summary>

firststep_complement, 組み込みツール, 補足情報

</details>
