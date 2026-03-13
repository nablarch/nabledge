# 初期セットアップ手順　補足事項

**公式ドキュメント**: [初期セットアップ手順　補足事項](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/firstStep_appendix/firststep_complement.html)

## 初期セットアップ手順　補足事項

初期セットアップ手順の補足事項。H2データの確認方法と、アーキタイプから生成したプロジェクトに組み込まれているツールについて記載する。

<details>
<summary>keywords</summary>

初期セットアップ補足, H2データベース確認, 組み込みツール, ブランクプロジェクト

</details>

## H2のデータの確認方法

トラブルシューティング等でH2に格納されているデータを確認する手順。

1. 確認したいプロジェクトに含まれる `h2/bin/h2.bat` を実行する。

> **補足**: データを確認したいプロジェクトに含まれるh2.batを起動すること。

2. ブラウザが起動したら以下の通りに入力し、[Test Connection]ボタンをクリックする。

| 項目 | 値 | 補足 |
|---|---|---|
| JDBC URL | `jdbc:h2:../db/SAMPLE` | h2.batからの相対パスでデータファイルの位置を指定する |
| User Name | `SAMPLE` | |
| Password | `SAMPLE` | |

> **重要**: URLはh2.batからの相対パスを指定する必要があるため、env.propertiesからコピーするとパスがずれる。

3. 画面下部に「Test successful」と表示されていることを確認する。
4. Password欄を再入力し、[Connect]ボタンをクリックする。

> **重要**: [Connect]ボタンクリック時に指定したURLにH2のデータファイルが存在しない場合、H2のデータファイルが新規生成される。トラブルを避けるために、手順2で必ず[Test Connection]をクリックしてデータファイルの存在を確認すること。

5. 右側のペインの上部にSQLを入力する。
6. [Run]ボタン（緑色）をクリックしてSQLを実行する。
7. disconnectボタン（赤色アイコン）をクリックして切断する。

> **重要**: アーキタイプから生成したプロジェクトはH2の組み込みモードを使用しており、1プロセスからのみ接続を受け付ける。**切断を忘れると、アプリケーションからH2に接続できなくなる。**

<details>
<summary>keywords</summary>

H2コンソール起動, H2データベース接続確認, H2組み込みモード, JDBC URL, 接続切断注意, h2.bat

</details>

## アーキタイプから生成したプロジェクトに組み込まれているツール

アーキタイプから生成したプロジェクトに組み込まれているツール一覧。

| ツール | Mavenのフェーズ | 補足 |
|---|---|---|
| :doc:`/development_tools/toolbox/JspStaticAnalysis/index` | verify | |
| カバレッジ取得 | test | jacoco.execが生成されるところまで設定済み。jacoco.execはSonarQube及びJenkinsのプラグインで使用可能。 |
| [gsp-dba-maven-plugin(外部サイト)](https://github.com/coastland/gsp-dba-maven-plugin/tree/4.x.x-main) | — | 起動は `mvn -P gsp gsp-dba:<ゴール名>` で行う。例: `mvn -P gsp gsp-dba:generate-ddl`。`mvn -P gsp generate-resources` と実行することで「generate-ddl」「execute-ddl」「generate-entity」「load-data」「export-schema」を順に実行できる。 |

> **重要**: ツールの設定を変更する際は、[about_maven_parent_module](blank-project-MavenModuleStructures.md) のpom.xmlを必ず理解した上で行うこと。pom.xmlを理解することで、多くの設定項目について**容易**に設定変更が可能になる。

<details>
<summary>keywords</summary>

JspStaticAnalysis, カバレッジ取得, jacoco, gsp-dba-maven-plugin, Mavenフェーズ, 組み込みツール一覧

</details>
