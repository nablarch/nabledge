# 業務画面JSPローカル表示機能

**公式ドキュメント**: [業務画面JSPローカル表示機能](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/inbrowser_jsp_rendering.html)

## 

なし

<details>
<summary>keywords</summary>

業務画面JSPローカル表示機能, ローカルレンダリング概要

</details>

## 概要

業務画面JSPローカル表示機能は、ローカルディスク上の業務画面JSPファイルを通常のブラウザで直接開けるようにする仕組み。開発用アプリケーションサーバが用意されていない設計工程の初期においても画面のプレビューや動作デモが実施可能。JSPの内容に応じた画面項目一覧の表示もできる。

ローカルデモ用JSPレンダリング処理に必要な3つの資源:

1. ローカルデモ対象の業務画面JSPファイル
2. UI共通部品群（UI部品ウィジェット/業務画面テンプレート/JavaScript UI部品）
3. ローカルデモ用JSPレンダリングエンジン

上記のうち1・2は実際の開発で使用しているものをそのまま利用可能。デモ専用の成果物を新たに作成する必要はない。

![3つの資源の関係図](../../../knowledge/development-tools/testing-framework/assets/testing-framework-inbrowser_jsp_rendering/rendering_function.png)

<details>
<summary>keywords</summary>

ローカル表示機能, 業務画面JSP, UI共通部品, 画面プレビュー, アプリケーションサーバ不要, JSPレンダリングエンジン

</details>

## ローカルJSPレンダリング機能の有効化

業務画面JSPファイルの冒頭に以下のコードを記述することでローカルJSPレンダリング機能が有効になる。

```jsp
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- <%/* --><script src="js/devtool.js"></script><meta charset="utf-8"><body><!-- */%> -->
```

<details>
<summary>keywords</summary>

有効化, devtool.js, JSP冒頭記述, ローカルレンダリング有効化

</details>

## 業務画面JSPを記述する際の制約事項

以下の制約はブラウザで直接開くJSPに対するものであり、[jsp_widgets](testing-framework-jsp_widgets.md) や [jsp_page_templates](testing-framework-jsp_page_templates.md) には影響しない。

1. **明示的な閉じタグが必須**: 業務画面JSP内の全JSPタグに明示的な閉じタグが必要。省略するとそれ以降のタグがレンダリングされなくなる。
   - 正しい例: `<n:set name="var" value="val"></n:set>`
   - 誤った例: `<n:set name="var" value="val" />`（自己終了タグは使用不可）

2. **disabled属性値の無視（IE8限定）**: IE8ではdisabled属性が設定されていると属性値に関わらず常に`disabled="disabled"`として扱われる。`disabled="false"`のように記述しても意図通りに動作しない。disabled属性を削除すること。

3. **イベント関連の動作が不安定**: eventタグの使用や`nablarch/ui/event.js`で定義されたイベントへのリスナー登録は、ブラウザによって動作が異なる、またはリスナーがコールバックされない問題がある。これらの確認はアプリケーションサーバにデプロイして行うこと。

<details>
<summary>keywords</summary>

閉じタグ必須, disabled属性, IE8制限, イベント動作不安定, JSP記述制約

</details>

## ローカル表示の仕組み

ローカル表示は以下の2つの部分で構成される。

1. **業務画面JSPパーサー** (`/js/jsp.js`): 業務画面JSPファイル内のJSPをパースし、タグライブラリごとにスタブJSを呼び出す
2. **タグライブラリスタブJS** (`/js/jsp/taglib/*.js`): タグライブラリごとにローカル表示時の挙動を実装

[jsp_page_templates](testing-framework-jsp_page_templates.md) や [jsp_widgets](testing-framework-jsp_widgets.md) を使用して作成した業務画面JSPであれば、標準で以下のタグライブラリのスタブJSが実装済みであり問題なくローカル表示が可能。

| 名前空間 | 内容 |
|---|---|
| `jsp:` | JSPタグライブラリJSスタブ |
| `c:` | JSTL coreタグライブラリJSスタブ |
| `fn:` | JSTL FunctionsタグライブラリJSスタブ |
| `n:` | NablarchタグライブラリJSスタブ |

> **注意**: 新規の [jsp_widgets](testing-framework-jsp_widgets.md) を追加したり外部のタグライブラリを使用したりする場合は、プロジェクト側でタグライブラリスタブJSを追加する必要がある。

<details>
<summary>keywords</summary>

ローカル表示の仕組み, JSPパーサー, タグライブラリスタブ, jsp.js, スタブJS, 名前空間, JSTL, NablarchタグライブラリJSスタブ

</details>

## 構成ファイル一覧

動作環境の記号: ○=使用する、△=直接は使用しないがミニファイ済みファイルの一部として使用、×=使用しない

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| ミニファイ済みスクリプト | ○ | × | `/js/devtool.js` | ローカルレンダリングに必要な資源をミニファイしたもの |
| 初期ロードスクリプト | △ | × | `/js/devtool-loader.js` | ローカルレンダリングに必要なスクリプト群の初期ロード。JSPレンダリング完了まで画面を隠す初期処理も実施 |
| ミニファイ対象資源一覧 | × | × | `/js/build/devtool_conf.js` | タグファイルやインクルードファイルなどの資源一覧。ミニファイ処理の事前処理として自動作成 |
| ローカルデモUI | △ | × | `/js/devtool/*.js` | 画面項目定義の表示機能とそれを操作するUI |
| 設計書画面テンプレート | △ | × | `/specsheet_template/SpecSheetTemplate.htm` | 画面詳細設計書のExcelシートをWebページとして保存したもの。設計書ビュー表示に使用 |
| タグ定義 | △ | × | `/js/devtool/resource/タグ定義.js` | JSPウィジェットのローカル表示・設計書ビュー表示に必要な補足情報の設定ファイル。JSPウィジェット追加時は定義の追加が必要。記述書式の詳細は [./configuration_files](testing-framework-configuration_files.md) を参照 |
| JSPローカルレンダラ | △ | × | `/js/jsp.js` | JSPのローカルレンダリングを行うメインスクリプト（jQueryプラグイン形態） |
| コンテキスト変数設定 | △ | × | `/js/jsp/context.js` | ローカルレンダリング時に参照するセッション・リクエスト・ページのコンテキスト変数のダミー定義 |
| EL式簡易パーサ | △ | × | `/js/jsp/el.js` | EL式の簡易パーサ |
| タグライブラリスタブ | △ | × | `/js/jsp/taglib/nablarch.js` 他11ファイル | 各タグライブラリのスタブ動作実装。`/js/jsp.js`から呼ばれる。名前空間ごとに別スクリプト |

タグライブラリスタブの全ファイル: `nablarch.js`, `jstl.js`, `jsp.js`, `html.js`, `field.js`, `button.js`, `link.js`, `template.js`, `table.js`, `column.js`, `tab.js`, `event.js`

<details>
<summary>keywords</summary>

構造, 構成ファイル, ローカルレンダリング構造, 構成ファイル一覧, devtool.js, devtool-loader.js, jsp.js, タグライブラリスタブ, context.js, el.js, タグ定義.js

</details>
