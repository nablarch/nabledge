# マスタデータ投入ツール

**公式ドキュメント**: [マスタデータ投入ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/02_MasterDataSetup/01_MasterDataSetupTool.html)

## 概要・特徴

DBにマスタデータを投入するツール。

特徴:
- 自動テストのテストデータと同じ形式で記述できる
- Nablarch Application Frameworkのコンポーネント設定ファイルを使用するので、別途設定ファイルが不要
- バックアップ用スキーマ（自動テストフレームワークの [../../06_TestFWGuide/04_MasterDataRestore](testing-framework-04_MasterDataRestore.md) で使用するスキーマ）へのデータ投入が同時に実行できる。バックアップ用スキーマには自動テスト用スキーマと同じマスタデータを投入する必要があり、本ツールを使用することで2つのスキーマに同時にデータ投入できる。

> **重要**: 本ツールはマルチスレッド機能に対応していない。マルチスレッド機能のテストは、テスティングフレームワークを使用しないテスト（結合テストなど）で行うこと。

前提条件: [02_ConfigMasterDataSetupTool](testing-framework-02_ConfigMasterDataSetupTool.md) の [master_data_setup_prerequisite](testing-framework-02_ConfigMasterDataSetupTool.md) 参照。

<details>
<summary>keywords</summary>

マスタデータ投入ツール, ツール概要, バックアップ用スキーマ, マルチスレッド非対応, コンポーネント設定ファイル, マスタデータ投入, 自動テストデータ形式, 特徴

</details>

## データ作成方法

投入したいデータをMASTER_DATA.xlsxに記載する。記載方法は自動テストと同じ形式。

データ記載方法: [how_to_write_setup_table](testing-framework-02_DbAccessTest.md) 参照。

<details>
<summary>keywords</summary>

MASTER_DATA.xlsx, マスタデータ記載方法, テストデータ形式, how_to_write_setup_table, データ作成

</details>

## 実行方法

AntビューからターゲットをダブルクリックしてDBに投入する。

> **補足**: Antビューの設定は [how_to_setup_ant_view_in_eclipse](testing-framework-02_ConfigMasterDataSetupTool.md) 参照。

| ターゲット名 | 説明 |
|---|---|
| データ投入(main) | mainプロジェクトの設定ファイルを使用してDBに投入。取引単体テスト等、APサーバ上でアプリケーションを動作させる際のスキーマにデータが投入される。 |
| データ投入(test) | testプロジェクトの設定ファイルを使用してDBに投入。自動テストで使用するスキーマおよびマスタデータバックアップスキーマに同時にデータ投入される。 |
| マスタデータ投入 | 上記2つのターゲットをまとめて実行する。 |

<details>
<summary>keywords</summary>

Antビュー, データ投入(main), データ投入(test), マスタデータ投入ターゲット, 実行ターゲット, how_to_setup_ant_view_in_eclipse

</details>
