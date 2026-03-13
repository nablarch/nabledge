# Nablarchバッチプロジェクトの初期セットアップ

**公式ドキュメント**: [Nablarchバッチプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_NablarchBatch.html)

## Nablarchバッチプロジェクトの初期セットアップ

Nablarchバッチプロジェクトの生成と動作確認（都度起動バッチ、テーブルをキューとして使ったメッセージング）の手順。

<details>
<summary>keywords</summary>

Nablarchバッチプロジェクト, 初期セットアップ, バッチプロジェクト生成, 動作確認

</details>

## 生成するプロジェクトの概要

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 含まれるもの | 基本設定、都度起動バッチ（疎通確認用）、テーブルをキューとして使ったメッセージング（疎通確認用）、メール送信バッチ設定、Mavenツール初期設定 |

> **補足**: メール送信バッチは [常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md) として動作しSMTPサーバにメールを送信する。初期環境構築時には不要。必要になったタイミングで [メール送信](../../component/libraries/libraries-mail.md) を参照すること。設定ファイルのサンプルは `src/main/resources/mail-sender-boot.xml`。

<details>
<summary>keywords</summary>

Mavenプロジェクト, H2 Database Engine, メール送信バッチ, mail-sender-boot.xml, 単一プロジェクト構成, テーブルをキューとして使ったメッセージング

</details>

## ブランクプロジェクト作成

## mvnコマンド

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョン（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前のバージョンでは `archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更すること。例: `mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-archetype -DarchetypeVersion=5u24`

## プロジェクト情報の入力

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-batch` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字、数字、ドットのみ使用可。ハイフンは使用不可。

プロジェクト情報の入力が終わると、`Y: :` と表示される。「Y」を入力するとひな形が生成され、「N」を入力するとプロジェクト情報の入力をやり直せる。コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

<details>
<summary>keywords</summary>

nablarch-batch-archetype, archetypeVersion, com.nablarch.archetype, mvn archetype:generate, groupId, artifactId, maven-archetype-plugin, Nablarch 5u24, ブランクプロジェクト作成

</details>

## 疎通確認(都度起動バッチ)

## 自動テスト（都度起動バッチ）

| ユニットテストのクラス | テスト内容 |
|---|---|
| SampleBatchActionRequestTest | Nablarchのテスティングフレームワークを使用してバッチを起動可能か確認 |

```text
cd myapp-batch
mvn test
```

## 起動テスト（都度起動バッチ）

| バッチのクラス | 内容 |
|---|---|
| SampleAction | バッチアプリケーション実装時に一般的に使用するNablarchの機能の動作確認 |

ビルド:
```text
mvn package
```

起動:
```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-diConfig' 'classpath:batch-boot.xml' '-requestPath' 'SampleBatch' '-userId' 'batch_user'"
```

<details>
<summary>keywords</summary>

SampleBatchActionRequestTest, SampleAction, 都度起動バッチ, batch-boot.xml, nablarch.fw.launcher.Main, 疎通確認, mvn test, mvn package, SampleBatch

</details>

## 疎通確認(テーブルをキューとして使ったメッセージング)

| バッチのクラス | 内容 |
|---|---|
| SampleResiAction | テーブルをキューとして使ったメッセージングの基本処理（処理対象テーブルから値を取得し処理済みフラグを立てる） |

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-diConfig' 'classpath:resident-batch-boot.xml' '-requestPath' 'SampleResiBatch' '-userId' 'batch_user'"
```

> **補足**: 都度起動バッチとの相違点: `-diConfig`で指定するxmlファイルと`-requestPath`で指定するリクエストパスが異なる。

> **重要**: 正しい終了方法はBATCH_REQUESTテーブルのPROCESS_HALT_FLGに1を設定すること。ctrl+cは本手順上の簡易的な停止方法であり正しい終了方法ではない。

テーブルをキューとして使ったメッセージングを終了後に再起動する場合は [../firstStep_appendix/ResiBatchReboot](blank-project-ResiBatchReboot.md) を参照。

<details>
<summary>keywords</summary>

SampleResiAction, PROCESS_HALT_FLG, BATCH_REQUESTテーブル, resident-batch-boot.xml, SampleResiBatch, テーブルをキューとして使ったメッセージング, 常駐バッチ終了方法, DatabaseTableQueueReader

</details>

## 疎通確認になぜか失敗する場合

原因は分からないが疎通確認に失敗する場合、どこかで手順を誤っている可能性がある。原因が分からない場合は、:ref:`firstStepGenerateBatchBlankProject` からやり直してみること。

<details>
<summary>keywords</summary>

疎通確認失敗, 手順誤り, やり直し, firstStepGenerateBatchBlankProject

</details>

## 補足

H2データ確認方法およびブランクプロジェクト組み込みツールについては [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。

<details>
<summary>keywords</summary>

H2データ確認, ブランクプロジェクト補足, firststep_complement, 組み込みツール

</details>
