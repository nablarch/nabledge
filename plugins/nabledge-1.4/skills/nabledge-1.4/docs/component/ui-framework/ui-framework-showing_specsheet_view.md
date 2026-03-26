# 設計書ビュー表示機能

## 概要

業務画面JSPをローカル表示することで、ブラウザ上で設計書フォーマットに沿った画面設計書を表示する機能。

<details>
<summary>keywords</summary>

設計書ビュー表示機能, 業務画面JSP, 画面設計書表示

</details>

## 使用方法

業務画面JSPをローカル表示し、右クリックのコンテキストメニューから「設計書ビューを開く」を選択すると、ブラウザ上で設計書フォーマットに沿って設計情報が表示される。

> **注意**: 画面項目一覧に表示される項目は、業務画面JSPに直接記述した項目のみ。`<jsp:include>` などを経由して描画する項目はJSPのプレビューには表示されるが、画面項目一覧には表示されない。これは、通常、共通化された表示項目は共通部品として個別に設計され、各画面の設計書から参照される形となるためである。

> **警告**: Excelに貼り付ける場合はFirefoxブラウザを使用すること。InternetExplorerはドキュメントモードが互換表示となる問題のため表示できない。

<details>
<summary>keywords</summary>

設計書ビューを開く, コンテキストメニュー, Firefoxブラウザ, InternetExplorer非対応, 画面項目一覧, jsp:include

</details>

## 関連ファイル

| パス | 内容 |
|---|---|
| `/specsheet_template/SpecSheetTmeplate.htm` | 設計書テンプレートファイル(htm形式) |
| `/specsheet_template/SpecSheetTmeplate.files/*` | htm形式表示用リソース |
| `/specsheet_template/SpecSheetTmeplate.xlsx` | 設計書テンプレートファイル。フォーマット変更時はこのファイルを修正しhtm形式で保存する |
| `/js/devtool/resource/コード値定義.js` | コード設計書の内容を保持するデータファイル。Nablarch Toolboxの画面項目定義データ自動生成ツールで生成 |
| `/js/devtool/resource/DB項目定義.js` | テーブル設計書の内容を保持するデータファイル。自動生成ツールで生成 |
| `/js/devtool/resource/外部インターフェース設計.js` | 外部インターフェース設計書の内容を保持するデータファイル。自動生成ツールで生成 |
| `/js/devtool/resource/ドメイン定義.js` | ドメイン定義書の同名のシートの内容を保持するデータファイル。自動生成ツールで生成 |
| `/js/devtool/resource/メッセージ定義.js` | メッセージ設計書の内容を保持するデータファイル。自動生成ツールで生成 |
| `/js/devtool/resource/タグ定義.js` | 各タグのメタ情報ファイル。入力項目か否かの判定に使用。プラグイン追加時には本ファイルへのメタ情報記述が必要。詳細は [../internals/configuration_files](ui-framework-configuration_files.md) 参照 |
| `/js/devtool/SpecSheetItems.js` | 定義情報の出力、属性値変換用メソッドを定義 |

> **注意**: 設計書から自動生成するファイルは、対応する設計書が修正された場合に再生成して最新化が必要。

<details>
<summary>keywords</summary>

SpecSheetTmeplate.htm, SpecSheetTmeplate.files, SpecSheetTmeplate.xlsx, コード値定義.js, DB項目定義.js, 外部インターフェース設計.js, ドメイン定義.js, メッセージ定義.js, タグ定義.js, SpecSheetItems.js, Nablarch Toolbox, 設計書自動生成

</details>
