# UI標準のカスタマイズとUI開発基盤への反映

**公式ドキュメント**: [UI標準のカスタマイズとUI開発基盤への反映](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/development_environment/modifying_code_and_testing.html)

## 修正要件の確認

UI部品に関する修正は必ずUI標準の修正に対して行われるべきであり、以下のフローを経ること:

**(顧客要望) → (UI標準修正) → (顧客承認) → (UI開発基盤の修正)**

- UI標準を修正すると**全画面に影響が発生する**。機能や画面単位での個別調整は認められない。
- UI標準の修正にはコストが発生する。デフォルトのUI標準に従った場合の実装コストは**無料**。

> **重要**: UI標準に反映されない修正をアドホックに行うことは、プロジェクトの破綻につながるリスク要因。

> **補足**: 変更内容がUI標準の変更履歴として記載されていることを確認すること。コミットログに変更履歴番号を入力することでトレーサビリティーを確保できる。

<details>
<summary>keywords</summary>

UI標準のカスタマイズ, UI開発基盤の修正フロー, 全画面影響, アドホック修正禁止, トレーサビリティー, 変更履歴番号

</details>

## 修正箇所の特定

修正箇所を特定するための2つの方法:

1. **「UI標準修正事例一覧」から類似事例を探す**: [../reference_ui_standard/index](testing-framework-ui-dev-doc-reference-ui-standard.md) を参照。類似案件があればその内容を参考にして修正を実施する。
2. **「UIプラグイン一覧」から対象機能のプラグインを探す**: [../reference_ui_standard/index](testing-framework-ui-dev-doc-reference-ui-standard.md) に類似案件がない場合は [../reference_ui_plugin/index](testing-framework-ui-dev-doc-reference-ui-plugin.md) を参照し、修正対象機能を実装するプラグインを特定して修正対象を絞り込む。

<details>
<summary>keywords</summary>

UIプラグイン特定, UI標準修正事例一覧, UIプラグイン一覧, 修正箇所特定方法

</details>

## プラグインの追加

既存のプラグインを修正する場合でも新たに追加する場合でも、既存のプラグインを別名でコピーしてから修正する（新規追加の場合は類似プラグインをコピー元とする）。

> **補足**: Nablarch提供のプラグインを直接修正すると、Nablarch UI開発基盤の更新時にNablarchの修正とプロジェクトの修正が混ざり、マージ作業が困難になる。

**設定ポイント**:

- プロジェクト側で修正・追加したプラグインにはプロジェクト名に相当するプレフィックスを付加すること（例: `xxx_project-css-color-default`）。
- 追加プラグインの `package.json` を修正: `name`（プラグイン名）、`description`（概要）、`_from`（コピー元プラグイン名@バージョン）を設定する。
- **マージ作業のために、package.json修正完了後にコミットすること**（[./update_bundle_plugin](testing-framework-update_bundle_plugin.md) 時のマージ作業でPJの修正前状態が必要なため）。
- `pjconf.json` の `plugins` 配列に、プロジェクトのプラグインパターン（例: `{ "pattern": "xxx_project-.*" }`）を**最後**に追加する。
- 複数プラグインが同一リソースを含む場合は下側エントリが優先される（後勝ち）。プロジェクト側プラグインは最後に追加することで最優先となる。
- :ref:`lessImport_less` に追加プラグインのlessファイルを追加すること。コピー元のimport定義は**必ず削除**すること（コピー元を読み込むと不要なスタイルが設定されてしまうため）。

<details>
<summary>keywords</summary>

プラグインコピー, プロジェクトプレフィックス, pjconf.json, package.json, 後勝ち, lessImport, マージ作業

</details>

## ビルドと修正確認

プラグイン修正後のビルド実行および修正内容の確認については、[./initial_setup](testing-framework-initial_setup.md) の [executing_ui_build](testing-framework-initial_setup.md) を参照すること。手順は初期セットアップ時と同一。

<details>
<summary>keywords</summary>

UIビルド実行, ビルド手順, 修正確認

</details>

## リポジトリへの反映

ビルドした結果をリポジトリに反映すること。画面設計担当者や業務画面の開発者はビルド後のファイルを元に作業するため、ビルド後はリポジトリへの反映が必要。

<details>
<summary>keywords</summary>

ビルド結果反映, リポジトリ反映, 画面設計担当者, 業務画面開発者

</details>
