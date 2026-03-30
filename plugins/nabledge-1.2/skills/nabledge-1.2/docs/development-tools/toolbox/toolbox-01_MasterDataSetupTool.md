# マスタデータ投入ツール

## 概要

データベースにマスタデータを投入する機能を提供する。

<details>
<summary>keywords</summary>

マスタデータ投入ツール, データベース投入, マスタデータ

</details>

## 特徴

- 自動テストのテストデータと同じ形式で記述できる。
- Nablarch Application Frameworkのコンポーネント設定ファイルを使用するため、別途設定ファイルを用意する必要がない。
- バックアップ用スキーマへのデータ投入を同時に実行できる。

> バックアップ用スキーマとは、[../../06_TestFWGuide/04_MasterDataRestore](../testing-framework/testing-framework-04_MasterDataRestore.md) で使用するスキーマのこと。自動テスト用スキーマと同じマスタデータを投入する必要があり、本ツールを使用することで2つのスキーマに同時にデータ投入できる。

<details>
<summary>keywords</summary>

バックアップ用スキーマ, テストデータ形式, コンポーネント設定ファイル, マスタデータ投入ツール, 自動テスト連携

</details>

## 使用方法

## 前提条件

[02_ConfigMasterDataSetupTool](toolbox-02_ConfigMasterDataSetupTool.md) の [master_data_setup_prerequisite](toolbox-02_ConfigMasterDataSetupTool.md) 参照。

## データ作成方法

投入したいデータをMASTER_DATA.xlsに記載する。記載方法は自動テストと同じ（[how_to_write_setup_table](../testing-framework/testing-framework-02_DbAccessTest.md) 参照）。

## 実行方法

Antビューから実行したいターゲットをダブルクリックする。

> **注意**: Antビューの設定については [how_to_setup_ant_view_in_eclipse](toolbox-02_ConfigMasterDataSetupTool.md) 参照。

| ターゲット名 | 説明 |
|---|---|
| データ投入(main) | mainプロジェクトの設定ファイルを使用してDBに投入。取引単体テスト等、APサーバ上でアプリケーションを動作させる際のスキーマにデータが投入される。 |
| データ投入(test) | testプロジェクトの設定ファイルを使用してDBに投入。自動テスト用スキーマおよびマスタデータバックアップスキーマに同時にデータ投入される。 |
| マスタデータ投入 | 上記2つのターゲットをまとめて実行する。 |

<details>
<summary>keywords</summary>

MASTER_DATA.xls, Antビュー, データ投入ターゲット, バックアップスキーマ, マスタデータ投入手順, データ投入(main), データ投入(test)

</details>
