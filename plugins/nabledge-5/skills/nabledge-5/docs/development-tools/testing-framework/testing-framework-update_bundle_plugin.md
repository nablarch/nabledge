# Nablarch 標準プラグインの更新

**公式ドキュメント**: [Nablarch 標準プラグインの更新](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/development_environment/update_bundle_plugin.html)

## UI開発基盤の更新方針

この作業は**UI開発基盤の担当者が実施すればよく、各担当者が個別に実施する必要はない**。

UI開発基盤をPJで取り込んだ後も、Nablarchでは標準プラグインの不具合修正や機能追加を継続的に行う。Nablarch側で行った変更がPJ側でも必要と判断した場合は、ここで述べる手順に沿って取り込むことができる。

機能の修正や追加は**プラグイン単位**で行うことができるため、取り込みに要する作業工数やPJの既存機能に対する影響を極小化できる。

> **補足**: PJ側の拡張や既存機能への影響に関して、Nablarch側では把握できないため、取り込み後の動作確認等はPJ側で担保する必要がある。

<details>
<summary>keywords</summary>

標準プラグイン更新方針, プラグイン単位更新, 作業工数極小化, PJ動作確認, 不具合修正取込, 機能追加取込, UI開発基盤担当者, 更新作業担当

</details>

## 作業時のディレクトリ構成

最新バージョンのNablarch標準プラグインのバンドルを取得し、[./initial_setup](testing-framework-initial_setup.md) の **UI開発基盤の取得と展開** で述べたディレクトリ構造と同じ構造になるように配置する。

<details>
<summary>keywords</summary>

ディレクトリ構成, プラグインバンドル取得, UI開発基盤配置, initial_setup, 更新前準備

</details>

## 1. プラグインのセットアップ

`nablarch_plugins_bundle/bin/setup.bat` を実行する。詳細は [プラグインのセットアップ](testing-framework-initial_setup.md) 参照。

<details>
<summary>keywords</summary>

プラグインセットアップ, setup.bat, UI開発基盤初期設定

</details>

## 2. 現在のプラグインのバージョンの確認

標準プラグインバンドル配下の `bin/update.bat` をPJのディレクトリ構造に合わせて修正し実行すると、PJのプラグインとリリース済み標準プラグインのバージョン差異を `ui_plugins/updated_plugin.json` に出力できる。

下記構成の場合、`PROJECT`="../../xxx_project"、`UI_PLUGIN`="ui_plugins" と設定する。

```bash
プロジェクトルート/
    ├── nablarch_plugins_bundle/
    │       ├── bin/update.bat
    │       └── package.json
    └── xxx_project/           # PROJECT
             └── ui_plugins/   # UI_PLUGIN
                    ├── node_modules/
                    ├── pjconf.json
                    └── package.json
```

`updated_plugin.json` 出力例:

```javascript
{
   "nablarch-css-core" : "1.0.0"               // nablarch-css-coreが更新されていた場合
 , "web_project-dev-ui_test-support" : "1.0.1" // 後述する_fromで指定したプラグインが更新されていた場合
 , "web_project-dev-ui_test-support" : "1.0.0"
}
```

> **補足**: 標準プラグインの**新規取込**の場合、`updated_plugin.json` には出力されないため、対象プラグインをPJのUI開発基盤に直接コピーすること。

PJでコピーして作成したプラグインの `package.json` に `_from` を設定すると、`update.bat` 実行時に差異一覧に出力される。標準プラグインには `_from` が設定済みのため、コピー時に削除しなければよい。

`_from` 指定例:

```javascript
{ "name" : "web_project-dev-ui_test-support"
, "version" : "1.0.0"
, "_from" : "nablarch-dev-ui_test-support@1.0.0"
}
```

<details>
<summary>keywords</summary>

update.bat, updated_plugin.json, プラグインバージョン差異確認, _from属性, 新規取込, バージョン確認

</details>

## 3. プラグインのマージ

取り込むと判断したプラグインの修正内容をマージする手順:

1. 作業ディレクトリにUI開発基盤導入時のリビジョンをチェックアウトする。
2. 標準プラグインとカスタマイズしたプラグイン（初期状態）を上書きする。カスタマイズしたプラグインは競合が発生する可能性があるため、以下の手順で競合を解消する。
   1. 新規（標準モジュールをコピー・リネームした状態）追加リビジョンにアップデートする。
   2. `_from` 属性に設定されている標準モジュールの内容で上書きする。
   3. PJ側が修正したリビジョンにアップデートする（競合しない場合はNablarch側の修正を確認、競合した場合は競合を解決）。
3. trunkのリビジョンまでアップデートしたら、UI部品のビルドを行い、各部品のテストをする。
4. リポジトリにコミットする。

**競合解消の具体例**: 下記の場合（`xxx_project-css-color-default` が rev:10 で追加、`xxx_project-css-common` が rev:15 で追加）、rev:10 と rev:15 の2回競合を解消する。

1. `nablarch-css-color-default` を上書きする。
2. リビジョン10にアップデートする。
3. `xxx_project-css-color-default` の `_from` に設定されている `nablarch-css-color-default` の修正内容を上書きする。
4. リビジョン15にアップデートする。
5. `xxx_project-css-common` の `_from` に設定されている `nablarch-css-common` の修正内容を上書きする。
6. PJ側の修正したリビジョンまでアップデートする。

> **補足**: 標準プラグインを新規に取り込んだ際にカスタマイズが必要になった場合は、一旦 `ui_plugins/pjconf.json` から対象プラグインを外し、カスタマイズは行わないこと。標準プラグインの取り込みが完了してから [modifying_code_and_testing](testing-framework-modifying_code_and_testing.md) を参照してカスタマイズすること。

<details>
<summary>keywords</summary>

プラグインマージ, プラグイン競合解消, pjconf.json, リビジョン更新, プラグイン更新取込, 競合解消例

</details>
