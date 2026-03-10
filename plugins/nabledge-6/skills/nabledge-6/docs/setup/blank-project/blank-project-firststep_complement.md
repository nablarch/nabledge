# 初期セットアップ手順　補足事項

**公式ドキュメント**: [初期セットアップ手順　補足事項](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/firstStep_appendix/firststep_complement.html)

## 初期セットアップ手順　補足事項

このページは、初期セットアップ手順の補足事項として、H2データベースの確認方法とアーキタイプから生成したプロジェクトに組み込まれているツールについて説明する。

<details>
<summary>keywords</summary>

初期セットアップ補足, H2データベース確認, ブランクプロジェクト補足

</details>

## H2のデータの確認方法

H2コンソールの起動手順:

1. データを確認したいプロジェクトの `h2/bin/h2.bat` を実行する。

> **補足**: データを確認したいプロジェクトに含まれるh2.batを起動すること。

2. ブラウザが起動したら、以下の値を入力して[Test Connection]をクリックする。

| 項目 | 値 |
|---|---|
| JDBC URL | `jdbc:h2:../db/SAMPLE` |
| User Name | `SAMPLE` |
| Password | `SAMPLE` |

> **重要**: URLは上記の通り入力すること。h2.batからの相対パスを指定する必要があるため、env.propertiesからコピーするとパスがずれる。

3. 「Test successful」と表示されていることを確認する。

4. Password欄を再び入力し、[Connect]をクリックする。

> **重要**: [Connect]クリック時に指定したURLにH2のデータファイルが存在しない場合、データファイルが新規生成される。トラブルを避けるために、必ず手順2の[Test Connection]でデータファイルの存在を確認すること。

5. 右側のペインの上部にSQLを入力する。

6. [Run]ボタン（緑色）をクリックしてSQLを実行する。

7. 左上のdisconnectボタン（赤色アイコン）をクリックして切断する。

> **重要**: アーキタイプから生成したプロジェクトはH2の組み込みモードを使用しており、1プロセスからのみ接続を受け付ける。**切断を忘れると、アプリケーションからH2に接続できなくなる。**

<details>
<summary>keywords</summary>

H2コンソール起動, H2データベース確認, JDBC接続, 組み込みモード接続制限, h2.bat, jdbc:h2:../db/SAMPLE, env.properties

</details>

## アーキタイプから生成したプロジェクトに組み込まれているツール

| ツール | Mavenフェーズ | 補足 |
|---|---|---|
| JspStaticAnalysis | verify | |
| カバレッジ取得 | test | jacoco.execが生成されるところまで設定済み。SonarQube及びJenkinsのプラグインで使用可能。 |
| [gsp-dba-maven-plugin](https://github.com/coastland/gsp-dba-maven-plugin) | － | 起動: `mvn -P gsp gsp-dba:<ゴール名>`（例: `mvn -P gsp gsp-dba:generate-ddl`）。`mvn -P gsp generate-resources` で generate-ddl・execute-ddl・generate-entity・load-data・export-schema を順に実行可能。 |

> **重要**: ツールの設定を変更する際は、親モジュールのpom.xmlを必ず理解した上で行うこと。pom.xmlを理解することで、多くの設定項目について**容易**に設定変更が可能になる。

<details>
<summary>keywords</summary>

JspStaticAnalysis, カバレッジ取得, gsp-dba-maven-plugin, jacoco, Mavenプラグイン, 組み込みツール, generate-ddl, execute-ddl, generate-entity, load-data, export-schema, SonarQube, Jenkins

</details>
