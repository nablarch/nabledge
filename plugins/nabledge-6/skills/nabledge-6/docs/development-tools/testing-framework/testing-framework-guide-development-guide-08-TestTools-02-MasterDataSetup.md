# マスタデータ投入ツール

**公式ドキュメント**: [マスタデータ投入ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/02_MasterDataSetup/index.html)

## マスタデータ投入ツール

> **補足**: :ref:`blank_project` を使用してプロジェクトを構築した場合、データベース関連ツールとして :ref:`gsp-dba-maven-plugin <gsp-maven-plugin>` が設定される。このため、マスタデータの投入は本ツールではなく :ref:`gsp-dba-maven-plugin <gsp-maven-plugin>` の使用を推奨する。

> **重要**: 本ツールはマルチスレッド機能に対応していない。マルチスレッド機能のテストは、テスティングフレームワークを使用しないテスト（結合テストなど）で行うこと。

<details>
<summary>keywords</summary>

マスタデータ投入, gsp-dba-maven-plugin, blank_project, マルチスレッド非対応, データベース初期データ投入

</details>
