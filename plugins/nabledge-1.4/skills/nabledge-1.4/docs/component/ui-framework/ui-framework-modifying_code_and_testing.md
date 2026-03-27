# UI標準のカスタマイズとUI開発基盤への反映

## UI標準のカスタマイズ

## UI標準のカスタマイズ

UI開発基盤が提供する機能は、NablarchのUI標準に準拠するように実装されている。UI標準はプロジェクトのUI標準策定のためのたたき台となるものであり、UI部品に関する修正は必ず **UI標準** の修正に対して行われるべきものである。

UI標準を修正する際は、以下のフローを必ず経る必要がある:

**(顧客要望)** → **(UI標準修正)** → **(顧客承認)** → **(UI開発基盤の修正)**

このプロセスを経ることで、PJに関わる顧客を含めた全ての担当者に対して以下の重要な事実を強く認識させることができる:

**1. UI標準を修正すると、全画面に影響が発生する**
機能や画面単位での個別調整は認められない。

**2. UI標準の修正にはコストが発生する**
デフォルトのUI標準に従った場合、その実装コストは **無料** である。

<details>
<summary>keywords</summary>

UI標準カスタマイズ, 顧客要望フロー, UI標準修正プロセス, 全画面影響, 個別調整不可, UI標準修正コスト, 無料

</details>

## 修正要件の確認

## 修正要件の確認

UI部品の修正は原則として **UI標準** の変更に対して実施する。修正作業前にUI標準の変更内容を確認すること。

> **警告**: UI標準に反映されない修正をアドホックに行うことは、プロジェクトの破綻につながるリスク要因であるから真に慎むこと。

> **注意**: 変更内容がUI標準の変更履歴として記載されていることを確認すること。修正内容のコミットログにこの変更履歴番号を入力することでトレーサビリティを確保できる。

<details>
<summary>keywords</summary>

UI標準修正, 修正要件確認, UI部品修正フロー, トレーサビリティ, 変更履歴番号

</details>

## 修正箇所の特定

## 修正箇所の特定

UI標準の変更をUI開発基盤の実装に反映するための修正箇所を特定する2つの方法:

1. **「UI標準修正事例一覧」から類似事例を探す**: [../reference_ui_standard/index](ui-framework-reference_ui_standard.md) でUI標準の典型的な変更要望の修正内容と影響範囲を確認する。類似案件があればその内容を参考にして修正を実施する。

2. **「UIプラグイン一覧」から対象プラグインを探す**: 類似案件が存在しない場合は [../reference_ui_plugin/index](ui-framework-reference_ui_plugin.md) を参照し、修正対象機能がどのプラグインで実装されているかを確認して修正対象を絞り込む。

<details>
<summary>keywords</summary>

修正箇所特定, UI標準修正事例一覧, UIプラグイン一覧, 修正対象プラグイン

</details>

## プラグインの追加

## プラグインの追加

既存のプラグインを修正する場合でも新たに追加する場合でも、既存のプラグインを別名でコピーし、そのコピーに対して修正を行う（新規追加する場合は類似プラグインをコピー元とする）。

> **注意**: Nablarch提供のプラグインを直接修正すると、Nablarch UI開発基盤の更新時にNablarchの修正内容とプロジェクトの修正内容が混ざり、マージ作業が困難になる。必ずプロジェクトのプラグインとしてコピーしてから修正すること。

プロジェクト側で修正したプラグインにはプロジェクト名に相当するプレフィックスを付加すること（例: `xxx_project-css-color-default`）。

**手順1**: 修正対象プラグイン（例: `nablarch-css-color-default`）を別名（例: `xxx_project-css-color-default`）でコピーして `node_modules/` 下に追加する。

**手順2**: 追加したプラグインの `package.json` を以下3点で修正する。
1. `name` キーに手順1で設定したプラグイン名を設定
2. `description` キーにプラグインの概要を記述
3. `_from` キーにコピー元のプラグイン名@バージョンを記載

```json
{
  "name": "xxx_project-css-color-default",
  "version": "1.0.0",
  "description": "xxxプロジェクト用カラースキーム",
  "_from": "nablarch-css-color-default@1.0.0",
  "dependencies": {}
}
```

**手順3**: 手順2完了時点で、カスタマイズするプラグイン群をリポジトリにコミットする。[./update_bundle_plugin](ui-framework-update_bundle_plugin.md) 時のマージ作業でPJの修正前の状態を元にPJの変更とNablarchの変更を取り込むために必要。

**手順4**: プロジェクト直下の `pjconf.json` の `plugins` 配列にプロジェクト用パターンを最後尾に追記する。

```javascript
, { "pattern": "xxx_project-.*"}  // この行を最後に追加
```

> **注意**: 複数のプラグインが同一リソースを含む場合、配列の下側に記述したプラグインが優先される（後勝ち）。プロジェクト側プラグインを最優先にするため、エントリーの一番最後に追加すること。

**手順5**: 追加したプラグインの内容を必要に応じて修正する。今回追加した `xxx_project-css-color-default` のフォルダ構成は以下のとおり:

```
xxx_project-css-color-default/
  ├── package.json
  └── ui_public/
      └── css/
          └── color/
              └── default-color-scheme.less  # 修正対象ファイル
```

画面配色の設定は `ui_public/css/color/default-color-scheme.less` にあるので、これを適宜修正する。以下は変数の定義例:

```less
// Nablarchブランドカラーを基調とした配色設定
@baseColor  : rgb(255, 255, 255); // 白
@mainColor1 : rgb(235, 92,  21);  // オレンジ
@mainColor2 : rgb(76,  42,  26);  // こげ茶
@subColor   : rgb(170, 10,  10);  // 赤
```

<details>
<summary>keywords</summary>

プラグイン追加, プラグインコピー, package.json, pjconf.json, プロジェクトプレフィックス, 後勝ち, プラグインカスタマイズ, default-color-scheme.less, @baseColor, @mainColor1, @mainColor2, @subColor, ui_public/css/color

</details>

## ビルドと修正確認

## ビルドと修正確認

[./initial_setup](ui-framework-initial_setup.md) の [executing_ui_build](ui-framework-initial_setup.md) の手順を参照すること。

<details>
<summary>keywords</summary>

UIビルド, 修正確認, executing_ui_build

</details>

## リポジトリへの反映

## リポジトリへの反映

画面設計担当者や業務画面の開発者はビルド後のファイルを元に作業を行うため、ビルドした結果をリポジトリに反映すること。

<details>
<summary>keywords</summary>

リポジトリ反映, ビルド結果, UI開発基盤更新

</details>
