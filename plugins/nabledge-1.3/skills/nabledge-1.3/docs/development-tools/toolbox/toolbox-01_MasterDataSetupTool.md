# マスタデータ投入ツール

## 概要

データベースにマスタデータを投入する機能を提供する。

<details>
<summary>keywords</summary>

マスタデータ投入, データベース投入, マスタデータ

</details>

## 特徴

- 自動テストのテストデータと同じ形式で記述可能
- Nablarch Application Frameworkのコンポーネント設定ファイルをそのまま使用可能（別途設定ファイル不要）
- バックアップ用スキーマへの同時データ投入が可能

バックアップ用スキーマとは、[../../06_TestFWGuide/04_MasterDataRestore](../testing-framework/testing-framework-04_MasterDataRestore.md) で使用するスキーマ。自動テスト用スキーマと同じマスタデータを投入する必要があり、本ツールで2つのスキーマへ同時投入できる。

<details>
<summary>keywords</summary>

マスタデータ投入, バックアップ用スキーマ, テストデータ形式, コンポーネント設定ファイル, 同時データ投入

</details>

## 使用方法

### 前提条件

[02_ConfigMasterDataSetupTool](toolbox-02_ConfigMasterDataSetupTool.md) の [master_data_setup_prerequisite](toolbox-02_ConfigMasterDataSetupTool.md) 参照。

### データ作成方法

投入データを `MASTER_DATA.xls` に記載する。記載方法は [how_to_write_setup_table](../testing-framework/testing-framework-02_DbAccessTest.md) 参照。

### 実行方法

Antビューから、実行したいターゲットをダブルクリックする。

| ターゲット名 | 説明 |
|---|---|
| データ投入(main) | mainプロジェクトの設定ファイルを使用してデータベース投入。取引単体テスト等、APサーバ上でアプリケーションを動作させる際のスキーマにデータが投入される |
| データ投入(test) | testプロジェクトの設定ファイルを使用してデータベース投入。自動テスト用スキーマおよびマスタデータバックアップスキーマに同時データ投入する |
| マスタデータ投入 | 上記2つのターゲットをまとめて実行する |

<details>
<summary>keywords</summary>

MASTER_DATA.xls, Antビュー, データ投入ターゲット, マスタデータ投入, バックアップスキーマ, 実行方法, 前提条件

</details>
