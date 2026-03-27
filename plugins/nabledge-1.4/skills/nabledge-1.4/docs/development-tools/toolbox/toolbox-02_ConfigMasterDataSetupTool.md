# マスタデータ投入ツール インストールガイド

## インストール手順（前提事項・提供方法・設定・配置）

本ツールはNablarchのサンプルアプリケーションに同梱して提供する。

**前提条件**: Eclipseインストール済み、テーブル作成済み、バックアップ用スキーマのテーブル作成済み（[../../06_TestFWGuide/04_MasterDataRestore](../testing-framework/testing-framework-04_MasterDataRestore.md) の :ref:`master_data_backup_settings` 参照）

**ツール構成**:

| ファイル名 | 説明 |
|---|---|
| master_data-build.properties | 環境設定用プロパティファイル |
| master_data-build.xml | Antビルドファイル |
| master_data-log.properties | ログ出力プロパティファイル |
| MASTER_DATA.xls | マスタデータファイル |

配置先: `<mainプロジェクト>/tool/db/data` 直下（サンプルアプリケーションと同様）

`master_data-build.properties` の `masterdata.test.backup-schema` にバックアップスキーマ名を設定する。ディレクトリ構造が変わらない限り他の設定値の変更は不要。

```bash
masterdata.test.backup-schema=nablarch_test_master
```

<details>
<summary>keywords</summary>

masterdata.test.backup-schema, master_data-build.properties, master_data-build.xml, master_data-log.properties, MASTER_DATA.xls, マスタデータ投入ツール, バックアップスキーマ, インストール, 前提条件, 配置, サンプルアプリケーション, 提供方法

</details>

## Antビュー起動

EclipseからAntビューを使用してマスタデータ投入ツールを起動できる。ツールバーから ウィンドウ(Window) → 設定(Show View) を選択し、Antビューを開く。

<details>
<summary>keywords</summary>

Antビュー, Eclipse連携, Show View, 設定, ツール起動, ウィンドウメニュー

</details>

## ビルドファイル登録

1. Antビューの＋アイコンを押下してビルドスクリプトを選択する。
2. `master_data-build.xml`（Antビルドファイル）を選択する。
3. Antビューに登録したビルドファイルが表示されることを確認する。

<details>
<summary>keywords</summary>

master_data-build.xml, Antビルドファイル, ビルドファイル登録, Eclipse, Antビュー

</details>
