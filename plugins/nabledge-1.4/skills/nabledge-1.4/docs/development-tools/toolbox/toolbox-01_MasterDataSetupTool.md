# マスタデータ投入ツール

## 前提条件

[02_ConfigMasterDataSetupTool](toolbox-02_ConfigMasterDataSetupTool.md) の [master_data_setup_prerequisite](toolbox-02_ConfigMasterDataSetupTool.md) 参照。

<details>
<summary>keywords</summary>

マスタデータ投入ツール前提条件, 設定ファイル, 事前準備

</details>

## データ作成方法

投入データを `MASTER_DATA.xls` に記載する。記載形式は自動テストのテストデータと同じ。記載方法は [how_to_write_setup_table](../testing-framework/testing-framework-02_DbAccessTest.md) 参照。

<details>
<summary>keywords</summary>

MASTER_DATA.xls, マスタデータ投入, テストデータ形式, データ記載方法, 自動テスト同形式

</details>

## 実行方法

AntビューからターゲットをダブルクリックしてDB投入を実行する。Antビューの設定は [how_to_setup_ant_view_in_eclipse](toolbox-02_ConfigMasterDataSetupTool.md) 参照。

| ターゲット名 | 説明 |
|---|---|
| データ投入(main) | mainプロジェクトの設定ファイルを使用してDB投入。APサーバ上でアプリを動作させる際のスキーマにデータが投入される。 |
| データ投入(test) | testプロジェクトの設定ファイルを使用してDB投入。自動テスト用スキーマおよびマスタデータバックアップスキーマに同時にデータが投入される。 |
| マスタデータ投入 | 上記2つのターゲットをまとめて実行する。 |

バックアップ用スキーマ（ [../../06_TestFWGuide/04_MasterDataRestore](../testing-framework/testing-framework-04_MasterDataRestore.md) で使用）には自動テスト用スキーマと同じマスタデータを投入する必要がある。データ投入(test)ターゲットを使用することで2つのスキーマへ同時にデータ投入できる。

<details>
<summary>keywords</summary>

Antビュー, データ投入(main), データ投入(test), マスタデータ投入ターゲット, バックアップスキーマ, 自動テスト用スキーマ, 同時投入

</details>

## ツールの特徴（設定ファイル不要）

マスタデータ投入ツールはNablarch Application Frameworkのコンポーネント設定ファイルを使用するため、別途設定ファイルを用意する必要がない。

<details>
<summary>keywords</summary>

コンポーネント設定ファイル, 別途設定ファイル不要, Nablarch Application Framework設定再利用, 追加設定不要

</details>
