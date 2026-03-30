# マスタデータのセットアップ

## マスタデータのセットアップ

認可チェック機能に必要なデータをMASTER_DATA.xlsに追加し、マスタデータセットアップツールを使用してローカル環境のDBへ反映する。

**マスタデータとは**以下のようなデータを指す:
- 「コードテーブル」や「メッセージテーブル」のようなプロジェクトで共通的に使用できるデータ
- 認可チェック機能に必要なデータ
- 採番機能に必要なデータ
- 個別アプリケーション毎のメッセージ
- 個別アプリケーション毎のコード値

上記データのほとんどは、プロジェクトの共通データとして提供されているため、プログラマが個別に追加する必要はない。ただし「認可チェック機能に必要なデータ」については、実装時に追加する運用のほうが容易な場合があるため、プログラマが修正する運用のプロジェクトもある。開発時にマスタデータの編集が必要であるか否かは、プロジェクトのアーキテクトに確認すること。

**MASTER_DATA.xlsの配置フォルダ**: `/Nablarch_sample/tool/db/data` 配下

[MASTER_DATA.xls](../../../knowledge/guide/web-application/assets/web-application-03_datasetup/MASTER_DATA.xls)

MASTER_DATA.xls内で緑色のセルが認可チェック機能に必要な追加データ。

マスタデータセットアップツールの使用方法: [master_data_setup_tool](../../development-tools/toolbox/toolbox-01_MasterDataSetupTool.md)

> **注意**: マスタデータの管理方法はプロジェクト毎に異なるため、実プロジェクトでの取り扱いはプロジェクトの規定に従うこと。

<details>
<summary>keywords</summary>

マスタデータセットアップ, 認可チェック, MASTER_DATA.xls, master_data_setup_tool, マスタデータセットアップツール

</details>
