# JavaScript UI部品

**公式ドキュメント**: [JavaScript UI部品](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/js_framework.html)

## 概要

[js_framework](testing-framework-js_framework.md) はカレンダー表示やページ内タブページなど、通常HTMLでは実現できないUI機能のJavaScript部品群。以下の方針で独自実装されている:

- Nablarchフレームワークの動作を前提とし、エラー時入力データ復帰・非活性項目・変更不可項目などサーバ処理との連携整合性を重視
- JavaScript直接記述なしでカスタマイズ可能
- UI標準準拠の挙動・統一デザイン

> **注意**: [js_framework](testing-framework-js_framework.md) は基本的に [jsp_widgets](testing-framework-jsp_widgets.md) 内で使用することを前提としており、一般の業務画面実装者がAPIを直接使用することは想定していない。

## ウィジェットの実装例

**モジュール定義**: グローバル関数 `define([依存モジュール配列], function(modules){})` で定義。依存パスは `(コンテキストルート)/js/` からの相対パス。`./` で始まるパスはソースファイルからの相対パス。`text!` プレフィックスを指定したパスはJavaScriptとして評価せず、ファイル内容を文字列として読み込む。

**プロトタイプ定義**: `Object.merge(new Widget(), {...})` でWidgetコンストラクタのプロトタイプを継承する。`constructor` プロパティは `instanceof` 演算子を正常動作させるために必要。

**マーカCSS / widgetType**: `(プロジェクト名)_(ウィジェット名)` 形式（例: `sample_ModalDialog`）。`widgetType` はマーカCSSと同じ値を設定する。

**コンストラクタ設計**:

> **重要**: コンストラクタ内でノードプロパティの初期化は `Widget.call(this, element)` の呼び出しよりも前に行う必要がある。

JavaScriptでは親クラスのコンストラクタは自動では呼ばれないので、`Widget.call(this, element)` を明示的に呼び出す必要がある。また、ノードの内容は後でカスタマイズしやすいように、テンプレートファイルを使用すること。

**イベント定義** (`WidgetClass.event` オブジェクト、4つの書式):
1. `"(イベント名)" : handler` — マーカCSSノード(`this.$node`)上のイベント
2. `"(セレクタ式) (イベント名)" : handler` — event delegation（発生元がセレクタに合致する場合のみ処理）
3. `"(コンテキストノード) (イベント名)" : handler` — `$`で始まるプロパティ名か `"document"` を指定
4. `"(コンテキストノード) (セレクタ式) (イベント名)" : handler` — 3と2の組み合わせ

イベントハンドラに文字列を指定するとウィジェットの同名メソッドを呼び出す。関数を指定するとウィジェットを`bind()`したものが呼び出される。

**イベントハンドラの引数と戻り値**: イベントハンドラとして登録した場合、第一引数にはイベントオブジェクト(`jQuery.Event`)が渡される。イベントオブジェクトの`target`属性には、イベントの発生元のDOMノードオブジェクトが設定されている。明示的に`false`をリターンすることで、イベントのプロパゲーションとデフォルトアクションの実行を抑止することができる。

カスタムイベント `"beforeSubmit.nablarch"` は `"nablarch/ui/event"` の中で定義されており、グローバル関数 `nablarch_submit()` によってサブミットが行われる直前に呼ばれる。

`$.fn.widgets(WidgetClass)` でマーカCSSが指定されたノードにウィジェットを初期化する。

```javascript
define(
  ["jquery", "nablarch/ui/Widget", "text!./ModalDialog.template", "nablarch/ui/event", "sugar"],
  function($, Widget, template) { "use strict";
    function define() {
      $(function() { $(".sample_ModalDialog.-content").widgets(ModalDialog); });
      return ModalDialog;
    }
    ModalDialog.prototype = Object.merge(new Widget(), {
      constructor: ModalDialog,
      $dialog: null, contentId: null, isActive: null,
      show: ModalDialog_show, hide: ModalDialog_hide
    });
    ModalDialog.event = {
      "click": "show",
      "$dialog button.close click": "hide",
      // "beforeSubmit.nablarch" は nablarch/ui/event で定義、nablarch_submit() 呼び出し直前に発火
      "document beforeSubmit": function() { return !isActive }
    };
    ModalDialog.widgetType = "sample_ModalDialog";
    function ModalDialog(element, option) {
      // ノードプロパティの初期化をWidget.call()より先に行う
      // ※ ノードの内容はテンプレートファイルを使用すること
      this.contentId = option.content;
      this.isActive = false;
      this.$dialog = $(template).css({display:"none", position:"absolute", "z-index":"5"}).appendTo(document);
      // JavaScriptでは親クラスのコンストラクタは自動では呼ばれないため明示的に呼び出す
      Widget.call(this, element);
      this.$dialog.find("div.content").append("#" + contentId);
    }
    // イベントハンドラ: 第一引数にjQuery.Eventが渡される。event.targetにはイベント発生元のDOMノードが設定される。
    // falseをリターンするとイベントのプロパゲーションとデフォルトアクションの実行を抑止する。
    function ModalDialog_show(event) { this.isActive = true; this.$dialog.slideDown("fast"); return false; }
    function ModalDialog_hide(event) { this.isActive = false; this.$dialog.slideUp("fast"); return false; }
    return define();
  }
);
```

<details>
<summary>keywords</summary>

JavaScript UI部品, マーカCSS, js_framework, jsp_widgets, UI部品設計方針, カレンダー表示, タブページ, ModalDialog, Widget, Widget.call, Object.merge, define, widgetType, $.fn.widgets, nablarch_submit, ウィジェット実装, モーダルダイアログ, イベント定義, プロトタイプ継承, jQuery.Event, target属性, イベントプロパゲーション

</details>

## 使用例

マーカCSS（`nablarch_DatePicker` など）の指定のみでUI部品を使用可能。JavaScriptの直接記述は不要。

```jsp
<div class="field">
  <label>適用開始日：</label>
  <input id="effectiveDate" type="text" value="" />
  <button class="nablarch_DatePicker
                -format yyyy/MM/dd
                -locale ja
                -input  effectiveDate">
    <i class="fa fa-calendar"></i>
  </button>
</div>
```

`<button>` 要素のclass属性にUI部品識別子（マーカCSS: `nablarch_DatePicker`）と動作オプション（`-format yyyy/MM/dd -locale ja -input effectiveDate`）を記述する。

<details>
<summary>keywords</summary>

DatePicker, nablarch_DatePicker, マーカCSS, カレンダー入力, JavaScript直接記述不要, オプション指定

</details>

## 依存ライブラリ

| ライブラリ名 | 用途 | ライセンス |
|---|---|---|
| require.js | JavaScriptの分割モジュール管理（AMD） | MIT |
| sugar.js | ECMAScript5互換関数を含むユーティリティAPI群 | ライセンスフリー |
| jQuery | DOM関連API簡易化・ブラウザ互換レイヤ | MIT |

<details>
<summary>keywords</summary>

require.js, sugar.js, jQuery, AMD, 依存ライブラリ, ECMAScript5互換

</details>

## 初期処理

初期処理は業務画面JSPから参照する `/js/nablarch.js`（または `/js/nablarch-minify.js`）で実行される。2段階で処理される:

1. スクリプトロード完了時の処理
2. ドキュメントロード（DOM構造確定）時の処理

> **補足**: 本番環境では全JavaScriptを事前ミニファイして単一JSとしてロードする。開発環境では各スクリプトを個別に動的ロード(XHR)する。

<details>
<summary>keywords</summary>

nablarch.js, nablarch-minify.js, 初期処理, 開発環境, 本番環境, ミニファイ, 動的ロード

</details>

## スクリプトロード時の挙動

[js_framework](testing-framework-js_framework.md) はAMD（Asynchronous Module Definition）形式で実装されており、`require.js` により動的ロードまたは事前ミニファイされる。

ロードは `/js/nablarch.js` 内の処理で開始される:

```javascript
require(["nablarch/ui"], function(ui) {
  $(function() {
    ui.Widget.init();
  });
});
```

`/js/nablarch/ui.js` が全UI部品を以下のように依存モジュールとして定義する:

```javascript
define([
    "nablarch/ui/Widget"
  , "nablarch/ui/event"
  , "nablarch/ui/ListBuilder"
  , "nablarch/ui/DatePicker"
  , "nablarch/ui/AutoSum"
  , "nablarch/ui/Collapsible"
  , "nablarch/ui/TreeList"
  , "nablarch/ui/readonly"
  , "nablarch/ui/Placeholder"
  , "nablarch/ui/Tab"
  ], function(Widget) { "use strict";
    return {
      Widget: Widget
    };
  });
```

各UI部品側でマーカCSSの宣言と `Widget.register()` 呼び出しを行う（例: `/js/nablarch/ui/DatePicker.js`）:

```javascript
DatePicker.widgetType = "nablarch_DatePicker"; // マーカCSS
Widget.register(DatePicker);
```

全てのUI部品の初期化と登録が完了すると、最初の `/js/nablarch.js` に制御が戻り `Widget.init()` をドキュメントロード後に呼び出す。

<details>
<summary>keywords</summary>

AMD, require.js, Widget.register, Widget.init, nablarch/ui.js, マーカCSS宣言, AMDモジュール, DatePicker.js, Collapsible, TreeList, readonly, Placeholder

</details>

## ドキュメントロード時の挙動

`Widget.init()` がドキュメントロード後に呼び出され、各UI部品に以下の初期処理を実行する:

1. マーカCSSにマッチするドキュメント上の各要素にUI部品インスタンスを作成する（要素のNodeインスタンスとマーカCSS付随オプションをパースしたオブジェクトをコンストラクタ引数に渡す）
2. 生成インスタンスを要素の `data-` プロパティとして設定し、GCの対象とならないようにする

同じ要素への複数回初期化は `data-` プロパティチェックにより防止される。

<details>
<summary>keywords</summary>

Widget.init, UI部品インスタンス生成, data-プロパティ, ドキュメントロード, 初期化処理, マーカCSSマッチ

</details>

## UI部品の再初期化

画面ロード後にマーカCSSを含むDOMノードを動的追加した場合、初期化処理は自動実行されないため、`Widget.init()` を明示的に呼び出す必要がある。

既に初期化済みの要素には影響を与えないため、複数回呼び出しても問題ない。

<details>
<summary>keywords</summary>

Widget.init, 動的追加, 再初期化, マーカCSS, DOMノード動的追加

</details>

## ファイル構成

○=使用する、△=直接は使用しないがミニファイファイルの一部として使用、×=使用しない

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| 初期ロードスクリプト | ○ | △ | /js/nablarch.js | AMDロードパス設定・UIモジュール初期化ルーチン実行 |
| ミニファイ済みスクリプト | × | ○ | /js/nablarch-minify.js | 初期ロードスクリプトの依存ライブラリを全結合・ミニファイ。本番環境ではこのスクリプトとrequire.jsのみ使用 |
| AMDスクリプトローダ | △ | ○ | /js/require.js | AMD形式JavaScriptのローダ |
| テキストリソースローダ | ○ | △ | /js/text.js | require.js拡張プラグイン。JS以外のテキストリソースをXHR経由で動的ロード |
| jQueryライブラリ | ○ | △ | /js/jquery.js | DOM操作API・イベント管理APIのブラウザ間互換レイヤ |
| sugar.js | ○ | △ | /js/sugar.js | ECMAScript5互換関数・ユーティリティAPI群 |
| 簡易BigDecimal | ○ | △ | /js/nablarch/util/BigDecimal.js | JavaScriptによる簡易BigDecimal実装 |
| 簡易SimpleDateFormat | ○ | △ | /js/nablarch/util/SimpleDateFormat.js | Java SDK SimpleDateFormatの日付処理サブセット実装 |
| 日付ライブラリ | ○ | △ | /js/nablarch/util/DateUtil.js | JavaScript Date型と日付文字列の相互変換ライブラリ |
| UI部品共通プロトタイプ | ○ | △ | /js/nablarch/ui/Widget.js | UI部品共通機能（HTMLノードへのバインド・イベント定義・画面ロード時処理起動） |
| 自動集計 | ○ | △ | /js/nablarch/ui/AutoSum.js | 入出力項目の自動集計UI部品 |
| 日付入力部品 | ○ | △ | /js/nablarch/ui/DatePicker.js | カレンダーを用いた日付入力UI部品 |
| カレンダーテンプレート | △ | △ | /js/nablarch/ui/DatePicker.template | 日付入力部品カレンダー部分のHTMLテキストファイル |
| リストビルダー部品 | ○ | △ | /js/nablarch/ui/ListBuilder.js | 2つのセレクトボックスを用いた複数選択UI部品 |
| リストビルダーテンプレート | △ | △ | /js/nablarch/ui/ListBuilder.template | リストビルダー制御ボタン部分のHTMLテキストファイル |
| タブ切り替え部品 | ○ | △ | /js/nablarch/ui/Tab.js | ページ内タブ切り替えUI部品 |
| Nablarchサブミット連動 | ○ | △ | /js/nablarch/ui/event.js | Nablarchサブミット制御管理機構連動・画面サブミット前後のカスタムイベント定義 |

<details>
<summary>keywords</summary>

nablarch.js, nablarch-minify.js, require.js, text.js, jquery.js, Widget.js, DatePicker.js, DatePicker.template, ListBuilder.js, ListBuilder.template, Tab.js, AutoSum.js, event.js, BigDecimal.js, SimpleDateFormat.js, DateUtil.js

</details>

## 新規 JavaScript UI部品の作成方法

UI部品カタログ収録の既存部品以外のUI部品を作成する場合、標準的なUI部品は以下の3ファイルで構成される:

1. モジュール定義ファイル（.js）
2. テンプレートファイル（.template）
3. スタイル定義（.less）

<details>
<summary>keywords</summary>

UI部品作成, カスタムUI部品, ウィジェット作成, 3ファイル構成

</details>

## 作成するファイル

**1. モジュール定義ファイル（.js）**
ウィジェットの処理を記述したJavaScriptファイル。配置場所:
```
(コンテキストルート)/js/(PJ名)/ui/(ウィジェット名).js
```

**2. テンプレートファイル（.template）**
ウィジェット内のUIを定義するHTMLファイル。モジュール定義ファイルと同じ場所に配置:
```
(コンテキストルート)/js/(PJ名)/ui/(ウィジェット名).template
```

**3. スタイル定義（.less）**
ウィジェットのスタイルを定義するCSS(LESS)ファイル。配置場所:
```
(コンテキストルート)/css/ui/(ウィジェット名).less
```

<details>
<summary>keywords</summary>

モジュール定義ファイル, テンプレートファイル, スタイル定義, .js, .template, .less, ウィジェットファイル構成, コンテキストルート

</details>
