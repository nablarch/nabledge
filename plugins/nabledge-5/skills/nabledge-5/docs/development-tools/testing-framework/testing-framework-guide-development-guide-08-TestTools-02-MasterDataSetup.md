# マスタデータ投入ツール

**公式ドキュメント**: [マスタデータ投入ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/02_MasterDataSetup/index.html)

## マスタデータ投入ツール 概要・注意事項

> **補足**: [blank_project](../../setup/blank-project/blank-project-blank_project.md) を使用してプロジェクトを構築した場合、データベース関連ツールとして [gsp-dba-maven-plugin](../../setup/blank-project/blank-project-addin_gsp.md) が設定される。マスタデータの投入は本ツールではなく [gsp-dba-maven-plugin](../../setup/blank-project/blank-project-addin_gsp.md) の使用を推奨する。

> **重要**: 本ツールはマルチスレッド機能に対応していない。マルチスレッド機能のテストはテスティングフレームワークを使用しないテスト（結合テストなど）で行うこと。

<details>
<summary>keywords</summary>

マスタデータ投入, gsp-dba-maven-plugin, blank_project, マルチスレッド非対応, MasterDataSetupTool, ConfigMasterDataSetupTool

</details>
