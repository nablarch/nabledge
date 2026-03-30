# マスタデータ投入ツール インストールガイド

## 前提事項

## 前提事項

- Eclipseがインストール済みであること
- テーブルが作成済みであること
- バックアップ用スキーマにテーブルが作成済みであること

バックアップ用スキーマおよびそのテーブルの作成については、[../../06_TestFWGuide/04_MasterDataRestore](../testing-framework/testing-framework-04_MasterDataRestore.md) の :ref:`master_data_backup_settings` を参照。

<details>
<summary>keywords</summary>

マスタデータ投入ツール, インストール前提条件, Eclipse, バックアップスキーマ, テーブル作成

</details>

## 提供方法

## 提供方法

本ツールはNablarchのサンプルアプリケーションに同梱して提供する。

| ファイル名 | 説明 |
|---|---|
| master_data-build.properties | 環境設定用プロパティファイル |
| master_data-build.xml | Antビルドファイル |
| master_data-log.properties | ログ出力プロパティファイル |
| MASTER_DATA.xls | マスタデータファイル |

### プロパティファイルの書き換え

マスタデータ自動復旧機能が使用する、バックアップスキーマ名を `masterdata.test.backup-schema` に設定する。

```bash
masterdata.test.backup-schema=nablarch_test_master
```

その他の設定値はディレクトリ構造が変わらない限り修正不要。

### 配置

`<mainプロジェクト>/tool/db/data` 直下に配置する。

<details>
<summary>keywords</summary>

master_data-build.xml, master_data-build.properties, master_data-log.properties, MASTER_DATA.xls, masterdata.test.backup-schema, プロパティ設定, ツール配置

</details>

## Eclipseとの連携設定

## Eclipseとの連携設定

1. ツールバーからウィンドウ(Window)→設定(Show View)を選択し、Antビューを開く。
   ![Antビューを開く](../../../knowledge/development-tools/toolbox/assets/toolbox-02_ConfigMasterDataSetupTool/open_ant_view.png)

2. ＋印のアイコンを押下し、ビルドスクリプトを選択する。
   ![ビルドファイル登録](../../../knowledge/development-tools/toolbox/assets/toolbox-02_ConfigMasterDataSetupTool/register_build_file.png)

3. Antビルドファイル(master_data-build.xml)を選択する。
   ![ビルドファイル選択](../../../knowledge/development-tools/toolbox/assets/toolbox-02_ConfigMasterDataSetupTool/select_build_file.png)

4. Antビューに登録したビルドファイルが表示されることを確認する。
   ![Antビュー確認](../../../knowledge/development-tools/toolbox/assets/toolbox-02_ConfigMasterDataSetupTool/build_file_in_view.png)

<details>
<summary>keywords</summary>

Antビュー, ビルドファイル登録, Eclipse連携, master_data-build.xml, Ant設定

</details>
