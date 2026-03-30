# マスタデータ投入ツール インストールガイド

## 前提事項

## 前提事項

- Eclipseがインストール済みであること
- テーブルが作成済みであること
- バックアップ用スキーマにテーブルが作成済みであること

<details>
<summary>keywords</summary>

前提事項, インストール前提, Eclipse, バックアップスキーマ, マスタデータ投入ツール

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

マスタデータ自動復旧機能が使用するバックアップスキーマ名（`masterdata.test.backup-schema`）を設定する:

```bash
masterdata.test.backup-schema=nablarch_test_master
```

その他の設定値はディレクトリ構造が変わらない限り修正不要。

### 配置

`<mainプロジェクト>/tool/db/data` 直下に配置する。

<details>
<summary>keywords</summary>

master_data-build.xml, master_data-build.properties, master_data-log.properties, MASTER_DATA.xls, masterdata.test.backup-schema, ファイル構成, バックアップスキーマ名設定, 配置パス, 提供方法

</details>

## Eclipseとの連携設定

## Eclipseとの連携設定

EclipseのAntビューにビルドファイルを登録することで、Eclipseから本ツールを起動できる。

### Antビュー起動

ツールバーから ウィンドウ(Window) → 設定(Show View) を選択してAntビューを開く。

### ビルドファイル登録

1. ＋印のアイコンを押下し、ビルドスクリプトを選択する。
2. Antビルドファイル(`master_data-build.xml`)を選択する。
3. Antビューに登録したビルドファイルが表示されることを確認する。

<details>
<summary>keywords</summary>

Antビュー, Eclipse連携, ビルドファイル登録, master_data-build.xml, Eclipse設定, Antビュー起動

</details>
