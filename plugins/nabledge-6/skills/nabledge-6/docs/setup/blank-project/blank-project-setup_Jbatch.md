# Jakarta Batchに準拠したバッチプロジェクトの初期セットアップ

## 生成するプロジェクトの概要

本手順で生成するプロジェクトの概要:

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Database Engine（アプリケーションに組み込み） |
| 生成するプロジェクトに含まれるもの | Jakarta Batchに準拠したバッチアプリケーション用の基本的な設定、batchlet方式による疎通確認用バッチアプリケーション、chunk方式による疎通確認用バッチアプリケーション、Mavenと連動して動作するツールの初期設定（:ref:`about_maven_parent_module`参照） |

## mvnコマンドの実行

まず、ブランクプロジェクトを作成したいディレクトリ（任意のディレクトリ可）にカレントディレクトリを変更する。

その後、[Maven Archetype Plugin](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html)を使用して以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-ee-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョン。Nablarch 6u2以降を指定すること |

プロジェクト情報の入力:

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-batch-ee` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。英小文字、数字、ドットのみ使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると `Y: :` と表示される。

- ひな形を生成する場合は「Y」を入力する
- プロジェクト情報の入力をやり直す場合は「N」を入力する

## 自動テスト

アーキタイプから生成したプロジェクトに含まれるユニットテスト:

| ユニットテストのクラス | テスト内容 |
|---|---|
| SampleBatchletTest | データベース接続を伴うクラスのJUnitテスト |

```text
cd myapp-batch-ee
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

## 起動テスト

生成したプロジェクトに含まれるバッチアプリケーション:

| ジョブID | 内容 |
|---|---|
| sample-chunk | chunk方式で実装されたサンプルアプリケーション |
| sample-batchlet | batchlet方式で実装されたサンプルアプリケーション |

**ビルド**:

```text
cd myapp-batch-ee
mvn package
```

**chunk方式の起動**:

SAMPLE_USERテーブルからデータを取り出し、編集してCSVファイルに出力する処理が実装されている。

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main -Dexec.args="'sample-chunk'"
```

起動成功時、`./progress.log`にログが出力され、`testdata/output/outputdata.csv`にデータが出力される。

> **補足**: testdata/output/outputdata.csvはUTF-8で出力される。Excelで開くと文字化けするため、テキストエディタで開くこと。

**batchlet方式の起動**:

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main -Dexec.args="'sample-batchlet'"
```

起動成功時、`./progress.log`にログが出力される。

> **補足**: このbatchletはSAMPLE_USERテーブルのデータを全件削除する。削除したデータを復元するには「SAMPLE.mv.db.org」を「SAMPLE.mv.db」にコピーすること（:ref:`firstStepBatchEEProjectStructure`参照）。

## 疎通確認になぜか失敗する場合

原因は分からないが疎通確認に失敗する場合、どこかで手順を誤っている可能性がある。

原因が分からない場合は、:ref:`firstStepGenerateBatchEEBlankProject`（ブランクプロジェクト作成）からやり直すこと。

## データベースに関する設定を行う

ブランクプロジェクトの初期状態はH2 Database Engineを使用。使用するRDBMSを変更する場合は:ref:`customize-db`を参照。

ER図からのDDL生成・実行やEntityクラスの自動生成を行うには、gsp-dba-maven-pluginの初期設定および実行が必要。詳細は:ref:`gsp-maven-plugin`を参照。

## 補足

H2のデータ確認方法やブランクプロジェクトに組み込まれているツールの詳細は[../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md)を参照。
