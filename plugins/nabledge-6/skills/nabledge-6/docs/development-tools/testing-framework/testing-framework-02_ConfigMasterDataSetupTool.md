# マスタデータ投入ツール インストールガイド

## 前提事項

マスタデータ投入ツールを使用するには以下の前提条件を満たしている必要がある。

- 以下のツールがインストール済みであること
  - Eclipse
  - Maven
- Nablarchのアーキタイプから生成されたプロジェクトであること
- テーブルが作成済みであること
- バックアップ用スキーマにテーブルが作成済みであること

> **注意**: バックアップ用スキーマおよびそのテーブルの作成については、マスタデータ自動復旧機能ガイドの `:ref:master_data_backup_settings` を参照。

## 提供方法・セットアップ手順

本ツールは `nablarch-testing-XXX.jar` にて提供される。

ツール使用前に、プロジェクトのユニットテストと同じDB設定を使用できるようにするため、プロジェクトのコンパイルとツール実行に必要なjarファイルのダウンロードを行う。以下のコマンドを実行する。

```text
mvn compile
mvn dependency:copy-dependencies -DoutputDirectory=lib
```

続いて `master-data-setup-tool.zip` をダウンロードし、プロジェクトのディレクトリ（pom.xmlが存在するディレクトリ）にディレクトリ付きで展開する。

## プロパティファイルの書き換え

`master-data-setup-tool.zip` に含まれる設定ファイル:

| ファイル名 | 説明 |
|---|---|
| tool/db/data/master_data-build.properties | 環境設定用プロパティファイル |
| tool/db/data/master_data-build.xml | Antビルドファイル |
| tool/db/data/master_data-log.properties | ログ出力プロパティファイル |
| tool/db/data/master_data-app-log.properties | ログ出力プロパティファイル |
| tool/db/data/MASTER_DATA.xlsx | マスタデータファイル |

本ツールを実行する前に以下のコマンドを実行する。

```text
mvn compile
mvn dependency:copy-dependencies -DoutputDirectory=lib
```

`master_data-build.properties` にマスタデータ自動復旧機能が使用するバックアップスキーマ名を設定する:

```bash
# テスト用マスタデータバックアップスキーマ名
masterdata.test.backup-schema=nablarch_test_master
```

その他の設定値はディレクトリ構造が変わらない限り修正不要。

## Antビュー起動

Eclipse ツールバーから ウィンドウ(Window)→設定(Show View) を選択し、Antビューを開く。

![Antビューを開く操作画面](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_ConfigMasterDataSetupTool/open_ant_view.png)

## ビルドファイル登録

1. Antビューで＋印のアイコンを押下し、ビルドスクリプトを選択する。
2. Antビルドファイル（`master_data-build.xml`）を選択する。
3. Antビューに登録したビルドファイルが表示されていることを確認する。

![ビルドファイル登録操作](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_ConfigMasterDataSetupTool/register_build_file.png)

![ビルドファイル選択画面](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_ConfigMasterDataSetupTool/select_build_file.png)

![登録済みビルドファイルの確認](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_ConfigMasterDataSetupTool/build_file_in_view.png)
