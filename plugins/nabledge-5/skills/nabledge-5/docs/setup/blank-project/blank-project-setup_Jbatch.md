# JSR352に準拠したバッチプロジェクトの初期セットアップ

**公式ドキュメント**: [JSR352に準拠したバッチプロジェクトの初期セットアップ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Jbatch.html)

## ブランクプロジェクト作成とmvnコマンドの実行

## ブランクプロジェクト概要

生成されるプロジェクト構成:
- プロジェクト種別: Mavenプロジェクト（単一プロジェクト構成）
- 使用DB: H2 Database Engine（アプリケーションに組み込み）
- 含まれるもの: JSR352バッチ用基本設定、batchlet/chunk/ETL疎通確認用サンプルアプリ、Mavenと連動するツールの初期設定

> **補足（ETL）**: ETLを実行するクラスはNablarch内に存在するため、プロジェクトには設定ファイル、及びETLが使用するDTOクラス、entityクラスのみ存在する。

## ブランクプロジェクト生成コマンド

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-ee-archetype -DarchetypeVersion={nablarch_version}
```

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用するアーキタイプのバージョン（Nablarch 5u25以降を指定すること） |

> **補足**: Nablarch 5u24以前のバージョンでブランクプロジェクトを生成する場合は、`archetype:generate` を `org.apache.maven.plugins:maven-archetype-plugin:2.4:generate` に変更して実行すること。例: `mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-batch-ee-archetype -DarchetypeVersion=5u24`

## プロジェクト情報の入力

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名） | `com.example` |
| artifactId | アーティファクトID | `myapp-batch-ee` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ（通常はグループIDと同じ） | `com.example` |

> **重要**: groupIdおよびpackageはJavaのパッケージ名にマッピングされる。入力値には英小文字、数字、ドットのみ使用可。ハイフンは使用不可。

プロジェクト情報の入力が終わると、`Y: :` と表示される。
- 入力した内容をもとにひな形を生成する場合は「Y」を入力する。
- プロジェクト情報の入力をやり直したい場合は「N」を入力する。

<details>
<summary>keywords</summary>

JSR352バッチプロジェクト生成, ブランクプロジェクト作成, Mavenアーキタイプ, nablarch-batch-ee-archetype, archetype:generate, archetypeVersion, Nablarch 5u24以前のバージョン対応, groupId, artifactId, H2 Database Engine, 確認プロンプト, ETL脚注

</details>

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
(中略)
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
(以下略)
```

<details>
<summary>keywords</summary>

SampleBatchletTest, 自動テスト, ユニットテスト, 疎通確認, mvn test, データベース接続, Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, BUILD SUCCESS

</details>

## 起動テスト

生成されたプロジェクトに含まれるバッチアプリケーション:

| ジョブID | 内容 |
|---|---|
| sample-batchlet | batchlet方式で実装されたサンプルアプリケーション |
| sample-chunk | chunk方式で実装されたサンプルアプリケーション |
| sample-etl | NablarchのETL機能を使用したサンプルアプリケーション |

## ビルド

```text
cd myapp-batch-ee
mvn package
```

## batchlet方式の起動

SAMPLE_USERテーブルのデータを全件削除する処理が実装されている。

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main -Dexec.args="'sample-batchlet'"
```

実行に成功すると、`./progress.log` にログが出力される。

> **補足**: このbatchletはSAMPLE_USERテーブルのデータを全件削除する。削除したデータを復元するにはETL機能（sample-etl）を実行すること。

## ETL機能を使用するアプリケーションの起動

SAMPLE_USERテーブルにデータを投入する処理が実装されている。

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main -Dexec.args="'sample-etl'"
```

起動に成功すると、`./progress.log` にログが出力される。

## chunk方式の起動

SAMPLE_USERテーブルからデータを取り出し、編集してCSVファイルに出力する処理が実装されている。

```bash
mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main -Dexec.args="'sample-chunk'"
```

起動に成功すると、`./progress.log` にログが出力される。また、`testdata/output/outputdata.csv` に以下のデータが出力される。

```text
ユーザID,氏名
1,名部楽 一郎
2,名部楽 二郎
3,名部楽 三郎
4,名部楽 四朗
5,名部楽 五郎
6,名部楽 六郎
7,名部楽 七郎
8,名部楽 八郎
9,名部楽 九郎
10,名部楽 十郎
```

> **補足**: outputdata.csvはUTF-8で出力される。Excelで開くと文字化けするため、テキストエディタで開くこと。

## 疎通確認になぜか失敗する場合

原因は分からないが疎通確認に失敗する場合、どこかで手順を誤っている可能性がある。原因が分からない場合は、ブランクプロジェクト作成の手順からやり直してみること。

<details>
<summary>keywords</summary>

起動テスト, sample-batchlet, sample-chunk, sample-etl, nablarch.fw.batch.ee.Main, batchlet方式, chunk方式, ETL機能, SAMPLE_USERテーブル, outputdata.csv, mvn exec:java, 疎通確認失敗, トラブルシューティング, progress.log

</details>

## 補足

H2データの確認方法およびブランクプロジェクト組み込みツールの詳細は [../firstStep_appendix/firststep_complement](blank-project-firststep_complement.md) を参照。

<details>
<summary>keywords</summary>

H2データ確認, ブランクプロジェクト組み込みツール, firstStep_appendix

</details>
