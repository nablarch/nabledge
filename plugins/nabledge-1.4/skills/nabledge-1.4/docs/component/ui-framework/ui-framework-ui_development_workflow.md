# UI開発ワークフロー

**公式ドキュメント**: [UI開発ワークフロー]()

## UI開発ワークフロー

Nablarchの画面開発ワークフローでは、画面項目定義書と同レベルの抽象度のカスタムタグをJSPに記述し、デモ用モックをそのままサーバ上で稼動するJSPとして利用できる。

JSPソースコードから見た目の情報が排除され、全て共通部品側に移動する。これにより:
1. 各画面担当者は業務機能に関わる本質的部分だけに集中でき、作業負荷を軽減できる。
2. 画面設計とデザインのワークフローを完全に並列進行できる。終盤のUI変更要望にも最小工数で対応可能。

この仕組みの中核は [../internals/jsp_widgets](ui-framework-jsp_widgets.md) と [../internals/jsp_page_templates](ui-framework-jsp_page_templates.md) であり、UI標準に準拠した挙動・表示があらかじめ実装されている。

![UI開発ワークフロー](../../../knowledge/component/ui-framework/assets/ui-framework-ui_development_workflow/workflow.png)

> **重要**: UI標準に変更が生じた場合、共通部品側への反映が必要（図②）。この更新が滞ると、顧客要求がデモ画面や設計書に反映されず設計工程に支障をきたす。

共通部品の改修担当者には、クライアントサイド技術の高度な知識・実装技術に加え、Nablarchを含むサーバサイド技術への十分な理解が必要。

<details>
<summary>keywords</summary>

UI開発ワークフロー, カスタムタグ, JSP共通部品, 画面設計並列化, UI標準準拠, jsp_widgets, jsp_page_templates, デモモック再利用

</details>
