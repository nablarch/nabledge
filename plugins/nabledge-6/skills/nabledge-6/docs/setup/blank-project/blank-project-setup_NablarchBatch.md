# Nablarchバッチプロジェクトの初期セットアップ

**公式ドキュメント**: [Nablarchバッチプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_NablarchBatch.html)

## Nablarchバッチプロジェクトの初期セットアップ

Nablarchバッチプロジェクトの初期セットアップでは以下を行う。

- Nablarchバッチプロジェクトの生成
- Nablarchバッチプロジェクトの動作確認

<details>
<summary>keywords</summary>

バッチプロジェクト初期セットアップ, プロジェクト生成, 動作確認

</details>

## 生成するプロジェクトの概要

生成されるプロジェクトの概要:

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 含まれるもの | Nablarchバッチアプリケーション用の基本的な設定、疎通確認用の都度起動バッチアプリケーション、テーブルをキューとして使ったメッセージング、メール送信バッチの設定、Mavenと連動して動作するツールの初期設定 |

メール送信バッチは[常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md)として動作し、SMTPサーバにメールを送信する。コンポーネント設定ファイルのサンプルは`src/main/resources/mail-sender-boot.xml`にある。初期環境構築時には不要だが、使用時は[メール送信](../../component/libraries/libraries-mail.md)の解説を参照すること。

他プロジェクトとの関係・ディレクトリ構成は[../MavenModuleStructures/index](blank-project-MavenModuleStructures.md)を参照。

<details>
<summary>keywords</summary>

Mavenプロジェクト, H2 Database Engine, メール送信バッチ, 常駐バッチ, mail-sender-boot.xml

</details>

## ブランクプロジェクト作成

[Maven Archetype Plugin(外部サイト、英語)](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html)を使用してブランクプロジェクトを生成する。

```bash
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-archetype -DarchetypeVersion={nablarch_version}
```

バージョン設定:

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する（Nablarch 6u2以降を指定すること） |

プロジェクト情報の入力項目:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-batch` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされるため、英小文字・数字・ドットのみ使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、`Y: :`と表示される。入力した内容をもとにひな形を生成する場合には「Y」を入力する。プロジェクト情報の入力をやり直したい場合には「N」を入力する。コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

ブランクプロジェクト作成, Maven Archetype, nablarch-batch-archetype, mvn archetype:generate, groupId, archetypeVersion

</details>

## 疎通確認(都度起動バッチ)

**自動テスト（都度起動バッチ）**

生成プロジェクトに含まれるユニットテスト:

| ユニットテストのクラス | テスト内容 |
|---|---|
| SampleBatchActionRequestTest | Nablarchのテスティングフレームワークを使用してバッチを起動可能かを確認する |

```text
cd myapp-batch
mvn test
```

実行に成功すると、以下のようなログがコンソールに出力される:

```text
[INFO] Results:
[INFO]
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

**起動テスト（都度起動バッチ）**

生成プロジェクトに含まれる都度起動バッチ:

| バッチのクラス | 内容 |
|---|---|
| SampleAction | バッチアプリケーション実装に一般的に使用するNablarchの機能の動作確認 |

ビルド:

```text
cd myapp-batch
mvn package
```

起動コマンド:

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-diConfig' 'classpath:batch-boot.xml' '-requestPath' 'SampleBatch' '-userId' 'batch_user'"
```

起動に成功すると、以下のようなログがコンソールに出力される:

```text
2020-04-28 08:56:23.353 -INFO- com.example.SampleBatch [...] 疎通確認を開始します。
2020-04-28 08:56:23.379 -INFO- com.example.SampleBatch [...] 取得したコード名称：ロック
2020-04-28 08:56:23.383 -INFO- com.example.SampleBatch [...] 疎通確認が完了しました。
2020-04-28 08:56:23.396 -INFO- nablarch.fw.handler.MultiThreadExecutionHandler [...] 
Thread Status: normal end.
Thread Result:[200 Success] The request has succeeded.
2020-04-28 08:56:23.407 -INFO- nablarch.core.log.app.BasicCommitLogger [...] TOTAL COMMIT COUNT = [1]
2020-04-28 08:56:23.413 -INFO- nablarch.fw.launcher.Main [...] @@@@ END @@@@ exit code = [0] execute time(ms) = [559]
```

<details>
<summary>keywords</summary>

都度起動バッチ, 疎通確認, SampleBatchActionRequestTest, SampleAction, SampleBatch, batch-boot.xml, mvn test, MultiThreadExecutionHandler, BasicCommitLogger

</details>

## 疎通確認(テーブルをキューとして使ったメッセージング)

生成プロジェクトに含まれるアプリケーション:

| バッチのクラス | 内容 |
|---|---|
| SampleResiAction | テーブルをキューとして使ったメッセージングの基本処理（処理対象テーブルから値を取得し、処理済みフラグを立てる） |

ビルドは:ref:`firstStepBatchBuild`を参照。

起動コマンド:

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-diConfig' 'classpath:resident-batch-boot.xml' '-requestPath' 'SampleResiBatch' '-userId' 'batch_user'"
```

> **補足**: 都度起動バッチとの相違点は `-diConfig` で指定するxmlファイルと `-requestPath` で指定するリクエストパス。

起動に成功すると、以下のようなログがコンソールに出力される:

```text
2020-04-28 08:58:15.350 -INFO- nablarch.fw.reader.DatabaseTableQueueReader [...] read database record. key info: {USER_INFO_ID=00000000000000000001}
2020-04-28 08:58:15.356 -INFO- com.example.SampleResiBatch [...] handleが呼ばれました。
2020-04-28 08:58:15.363 -INFO- com.example.SampleResiBatch [...] USER_INFO_ID:00000000000000000001
2020-04-28 08:58:15.367 -INFO- com.example.SampleResiBatch [...] LOGIN_ID:TAROU
2020-04-28 08:58:15.371 -INFO- com.example.SampleResiBatch [...] KANA_NAME:たろう
2020-04-28 08:58:15.379 -INFO- com.example.SampleResiBatch [...] KANJI_NAME:太郎
```

終了はCtrl+Cで強制終了する。

> **重要**: Nablarchが想定している正しい終了方法は、BATCH_REQUESTテーブルのPROCESS_HALT_FLGに1を設定する方法。本手順ではCtrl+Cを使用している。

一端終了後に再起動する場合は[../firstStep_appendix/ResiBatchReboot](blank-project-ResiBatchReboot.md)を参照。

<details>
<summary>keywords</summary>

テーブルをキューとして使ったメッセージング, SampleResiAction, SampleResiBatch, resident-batch-boot.xml, BATCH_REQUEST, PROCESS_HALT_FLG, 常駐バッチ, DatabaseTableQueueReader

</details>

## 疎通確認になぜか失敗する場合

原因は分からないが疎通確認に失敗する場合、どこかで手順を誤っている可能性がある。原因が分からない場合は、ブランクプロジェクト作成（:ref:`firstStepGenerateBatchBlankProject`）からやり直してみること。

<details>
<summary>keywords</summary>

疎通確認失敗, 手順やり直し, トラブルシューティング

</details>

## データベースに関する設定を行う

ブランクプロジェクトの初期状態ではH2 Database Engineを使用するよう設定されている。使用するRDBMSを変更する場合は[customize-db](blank-project-CustomizeDB.md)を参照。

ER図からのDDL生成・実行、Entityクラスの自動生成を行う場合はgsp-dba-maven-pluginの初期設定が必要。詳細は[gsp-maven-plugin](blank-project-addin_gsp.md)を参照。

<details>
<summary>keywords</summary>

データベース設定, H2 Database Engine, RDBMS変更, gsp-dba-maven-plugin, DDL生成

</details>

## 補足

H2のデータ確認方法やブランクプロジェクトに組み込まれているツールについては[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md)を参照。

<details>
<summary>keywords</summary>

H2データ確認, ブランクプロジェクトツール, firststep_complement

</details>
