# 設計書ビュー表示機能

**公式ドキュメント**: [設計書ビュー表示機能](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/showing_specsheet_view.html)

## 概要

設計工程で作成した業務画面JSPから、画面設計書を表示する機能。ブラウザ上で設計書フォーマットに沿って設計情報を確認できる。

<details>
<summary>keywords</summary>

設計書ビュー表示機能, 業務画面JSP, 画面設計書表示

</details>

## 使用方法

1. 業務画面JSPをローカル表示する
2. 右クリックでコンテキストメニューを開く
3. 「設計書ビューを開く」を選択すると、ブラウザ上で設計書フォーマットに沿って設計情報が表示される

> **補足**: 画面項目一覧に表示されるのは、業務画面JSPに直接記述した項目のみ。`<jsp:include>`などを経由して描画する項目はJSPのプレビューには表示されるが、画面項目一覧には表示されない。

> **重要**: Excelに貼り付ける場合はFirefoxブラウザを使用すること。ドキュメントモードが互換表示になる問題のため、InternetExplorerでは表示できない。

<details>
<summary>keywords</summary>

設計書ビューを開く, コンテキストメニュー, 画面項目一覧, JSPプレビュー, Firefox, InternetExplorer, jsp:include

</details>

## 関連ファイル

| パス | 内容 |
|---|---|
| /specsheet_template/SpecSheetTmeplate.htm | 表示される設計書のテンプレートファイル（htm形式） |
| /specsheet_template/SpecSheetTmeplate.files/* | テンプレートファイルをhtm形式で表示するためのリソース |
| /specsheet_template/SpecSheetTmeplate.xlsx | 設計書テンプレートファイル。フォーマット変更時はこのファイルを修正しhtm形式で保存する |
| /js/devtool/resource/コード値定義.js | コード設計書の内容を保持するデータファイル |
| /js/devtool/resource/DB項目定義.js | テーブル設計書の内容を保持するデータファイル |
| /js/devtool/resource/外部インターフェース設計.js | 外部インターフェース設計書の内容を保持するデータファイル |
| /js/devtool/resource/ドメイン定義.js | ドメイン定義書の同名シートの内容を保持するデータファイル |
| /js/devtool/resource/メッセージ定義.js | メッセージ設計書の内容を保持するデータファイル |
| /js/devtool/resource/タグ定義.js | 各タグのメタ情報を記述するファイル。各タグが入力項目か否かの判定などに参照する。プロジェクトでプラグインを追加した場合はメタ情報を記述する必要がある。記載内容については[../internals/configuration_files](testing-framework-configuration_files.md)を参照。 |
| /js/devtool/SpecSheetItems.js | 各定義情報の出力、属性値の変換用のメソッドを定義する |

> **補足**: 関連ファイルのうち、ツールを使用して設計書から自動生成するものは、設計書が修正された場合に再生成して最新化する必要がある。

<details>
<summary>keywords</summary>

SpecSheetTmeplate.htm, SpecSheetTmeplate.files/*, SpecSheetTmeplate.xlsx, タグ定義.js, SpecSheetItems.js, コード値定義.js, DB項目定義.js, 外部インターフェース設計.js, ドメイン定義.js, メッセージ定義.js, テンプレートファイル, 自動生成ファイル再生成

</details>
