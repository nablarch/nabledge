# マスタデータ投入ツール

**公式ドキュメント**: [マスタデータ投入ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/02_MasterDataSetup/01_MasterDataSetupTool.html)

## 前提条件

マスタデータ投入ツールの特徴:
- 自動テストのテストデータと同じ形式で記述できる
- Nablarchコンポーネント設定ファイルをそのまま使用するため、別途設定ファイルは不要
- バックアップ用スキーマ（[../../06_TestFWGuide/04_MasterDataRestore](testing-framework-04_MasterDataRestore.md) で使用するスキーマ）へのデータ投入を同時実行可能。バックアップ用スキーマには自動テスト用スキーマと同じマスタデータを投入する必要があり、本ツールで2つのスキーマに同時投入できる。

> **重要**: 本ツールはマルチスレッド機能に対応していない。マルチスレッド機能のテストは、テスティングフレームワークを使用しないテスト（結合テストなど）で行うこと。

設定の前提条件については [02_ConfigMasterDataSetupTool](testing-framework-02_ConfigMasterDataSetupTool.md) の [master_data_setup_prerequisite](testing-framework-02_ConfigMasterDataSetupTool.md) を参照。

<details>
<summary>keywords</summary>

マスタデータ投入ツール特徴, バックアップ用スキーマ, マルチスレッド制限, 設定ファイル不要, マスタデータリストア

</details>

## データ作成方法

投入したいデータをMASTER_DATA.xlsxに記載する。記載方法は自動テストと同じ形式。データの記載方法については [how_to_write_setup_table](testing-framework-02_DbAccessTest.md) を参照。

<details>
<summary>keywords</summary>

MASTER_DATA.xlsx, マスタデータ記述形式, 自動テストと同じ形式, テストデータ記述

</details>

## 実行方法

AntビューからターゲットをダブルクリックしてAntを実行する。Antビューの設定は [how_to_setup_ant_view_in_eclipse](testing-framework-02_ConfigMasterDataSetupTool.md) を参照。

| ターゲット名 | 説明 |
|---|---|
| データ投入(main) | mainプロジェクトの設定ファイルを使用。APサーバ上でアプリケーションを動作させる際のスキーマにデータ投入 |
| データ投入(test) | testプロジェクトの設定ファイルを使用。自動テスト用スキーマとマスタデータバックアップスキーマに同時にデータ投入 |
| マスタデータ投入 | 上記2つのターゲットをまとめて実行 |

<details>
<summary>keywords</summary>

データ投入(main), データ投入(test), マスタデータ投入, Antビュー, ターゲット実行, バックアップスキーマ同時投入

</details>
