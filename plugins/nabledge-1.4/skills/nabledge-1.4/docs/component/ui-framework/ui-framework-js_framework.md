# JavaScript UI部品

## 概要

[js_framework](ui-framework-js_framework.md) は、カレンダー表示やページ内タブなど通常のHTMLでは実現できないUI機能を実装するJavaScript部品群。以下の指針に基づき独自実装されている。

- Nablarchフレームワークの動作を前提とし、エラー時の入力データ復帰や非活性項目・変更不可項目などサーバ処理との連携の整合性を重視
- 可能な限りJavaScriptを直接記述しなくてもカスタマイズできる
- UI標準に準じた挙動、統一的なデザインを実現

## ウィジェットの実装例

モーダルダイアログウィジェットの実装サンプルに基づく実装ルール。

### モジュール依存関係の定義

- モジュールパスは `(コンテキストルート)/js/` からの相対パスを指定する
- `./` で始まるパスはソースファイルからの相対パスとみなされる
- パスの先頭に `text!` を指定した場合、そのファイルはJavaScriptとして評価されず、ファイル内容を文字列として読み込む

### モジュール定義を行う関数パターン

モジュールの初期化を行う関数を冒頭に定義し、この関数の最後で呼び出す。コードを冒頭に記述することで、モジュールの内容を把握しやすくなる。

### マーカーCSSとウィジェット識別子の命名規則

- マーカーCSSの命名: `(プロジェクト名)_(ウィジェット名)`
- `widgetType` はマーカーCSSと同じ `(PJ名)_(ウィジェット名)` とする

### プロトタイプ定義

- プロトタイプに `constructor: WidgetClass` を明示的に指定すること。`instanceof` 演算子を正常に動作させるために必要。

### イベント定義の4つの書式

```
1. "(イベント名)" : handler          // this.$node 上のイベント
2. "(セレクタ式) (イベント名)" : handler  // event delegation
3. "(コンテキストノード) (イベント名)" : handler
4. "(コンテキストノード) (セレクタ式) (イベント名)" : handler
```

- コンテキストノードには `$` で始まるプロパティ名または `"document"` を指定する
- ハンドラに文字列を指定した場合、そのウィジェットの同名メソッドを呼び出す
- ハンドラに関数を指定した場合、そのウィジェットを `bind()` したものが呼び出される

> **重要**: `"document beforeSubmit"` イベントで使用されるカスタムイベントの実際の名称は `beforeSubmit.nablarch` である。このイベントは `nablarch/ui/event` の中で定義されており、グローバル関数 `nablarch_submit()` によってサブミットが行われる直前に呼ばれる。

### コンストラクタ実装上の注意

> **重要**: ノードプロパティの初期化は `Widget.call(this, element)` より前に行う必要がある。

- JavaScriptでは親クラスのコンストラクタは自動では呼ばれないため、明示的に `Widget.call(this, element)` を呼び出すこと
- ノードの内容は後でカスタマイズしやすいように、テンプレートファイルを使用すること

### イベントハンドラの戻り値

- `false` を明示的にリターンすることで、イベントのプロパゲーションとデフォルトアクションを抑止できる

### 実装例（ModalDialog）

```javascript
define([
  "jquery"
, "nablarch/ui/Widget"
, "text!./ModalDialog.template"
, "nablarch/ui/event"
, "sugar"
],
function($, Widget, template) { "use strict";
  // モジュールの初期化を行う関数を冒頭に定義し、最後で呼び出す
  function define() {
    $(function() {
      $(".sample_ModalDialog.-content").widgets(ModalDialog);
    });
    return ModalDialog;
  }

  ModalDialog.prototype = Object.merge(new Widget(), {
    constructor : ModalDialog   // instanceof 演算子を正常に動作させるために必要
  , $dialog   : null
  , contentId : null
  , isActive  : null
  , show : ModalDialog_show
  , hide : ModalDialog_hide
  });

  ModalDialog.event = {
    "click" : "show"
  , "$dialog button.close click" : "hide"
  // document beforeSubmit は beforeSubmit.nablarch イベント(nablarch/ui/event で定義)
  // グローバル関数 nablarch_submit() がサブミット直前に発火する
  , "document beforeSubmit" : function() { return !isActive }
  };

  ModalDialog.widgetType = "sample_ModalDialog";

  function ModalDialog(element, option) {
    // ノードプロパティの初期化（Widget.call より先に行うこと）
    this.contentId = option.content;
    this.isActive  = false;
    // テンプレートファイルを使用してノード内容を初期化（後でカスタマイズしやすくするため）
    this.$dialog   = $(template).css({
                       display   : "none"
                     , position  : "absolute"
                     , "z-index" : "5"
                     }).appendTo(document);
    // 親クラスコンストラクタの明示的呼び出し
    Widget.call(this, element);
    this.$dialog.find("div.content").append("#" + contentId);
  }

  function ModalDialog_show(event) {
    this.isActive = true;
    this.$dialog.slideDown("fast");
    return false;
  }

  function ModalDialog_hide(event) {
    this.isActive = false;
    this.$dialog.slideUp("fast");
    return false;
  }

  return define();
});
```

<details>
<summary>keywords</summary>

JavaScript UI部品, js_framework, マーカCSS, UI部品群, カレンダー表示, タブページ, ModalDialog, Widget, widgets(), モーダルダイアログ実装, ウィジェット定義, イベントハンドラ登録, コンストラクタ初期化順序, define(), widgetType, beforeSubmit.nablarch, nablarch_submit, instanceof, テンプレートファイル

</details>

## 使用例

UI部品の使用は、HTML要素のclass属性に**マーカCSS**（識別子）とオプションを指定するだけでよく、JavaScriptを直接記述する必要はない。

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

`<button>` 要素のclass属性にマーカCSS（`nablarch_DatePicker`）の後に各種オプション（`-format yyyy/MM/dd -locale ja -input effectiveDate`）を指定する。

> **注意**: [js_framework](ui-framework-js_framework.md) は基本的に [jsp_widgets](ui-framework-jsp_widgets.md) 内で使用することを想定しており、一般の業務画面実装者がこれらのAPIを直接使用することは想定していない。

<details>
<summary>keywords</summary>

マーカCSS, DatePicker, nablarch_DatePicker, カレンダー入力部品, JSP, 業務画面実装者, jsp_widgets

</details>

## 依存ライブラリ

| ライブラリ名 | 用途 | ライセンス |
|---|---|---|
| require.js | JavaScriptの分割モジュール管理 | MIT |
| sugar.js | ECMAScript5互換関数を含むユーティリティAPI群の提供 | ライセンスフリー |
| jQuery | DOM関連APIの簡易化およびブラウザ互換レイヤの提供 | MIT |

<details>
<summary>keywords</summary>

require.js, sugar.js, jQuery, AMD, 外部ライブラリ, 依存ライブラリ

</details>

## 初期処理

[js_framework](ui-framework-js_framework.md) の初期処理は各業務画面のJSPから参照している `/js/nablarch.js` もしくはミニファイ済みの `/js/nablarch-minify.js` によって行われる。

> **注意**: 本番環境では全JavaScriptを事前にミニファイし単一ファイルとしてロードするが、開発環境では各スクリプトを個別に動的ロード（XHR）する。

初期処理は2段階で実行される：
1. スクリプトロード完了時の処理
2. 業務画面JSPのDOM構造が確定した時点（ドキュメントロード）の処理

<details>
<summary>keywords</summary>

nablarch.js, nablarch-minify.js, 初期処理, ミニファイ, スクリプトロード, ドキュメントロード

</details>

## スクリプトロード時の挙動

[js_framework](ui-framework-js_framework.md) はAMD（Asynchronous Module Definition）形式で実装されており、AMDモジュール管理ライブラリの **require.js** により動的ロードまたは事前ミニファイされる。

`/js/nablarch.js` 内の以下の処理でロードが開始され、ドキュメントロード後に `Widget.init()` が呼び出される：

```javascript
require(["nablarch/ui"], function(ui) {
  $(function() {
    ui.Widget.init();
  });
});
```

`/js/nablarch/ui.js` がプロジェクトで使用する全UI部品を依存モジュールとして定義する：

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
  return { Widget: Widget };
});
```

各UI部品ではマーカCSSの宣言と `Widget.register()` の呼び出しで登録する（`DatePicker.js` の例）：

```javascript
DatePicker.widgetType = "nablarch_DatePicker"; // マーカCSS
Widget.register(DatePicker); // UI部品の登録
```

全UI部品の初期化と登録完了後、`/js/nablarch.js` に制御が戻り、`Widget.init()` をドキュメントロード後に呼び出すイベントハンドラを登録する。

<details>
<summary>keywords</summary>

AMD, require.js, Widget.init, Widget.register, nablarch/ui.js, モジュールロード, AMDモジュール管理, Collapsible, TreeList, Placeholder

</details>

## ドキュメントロード時の挙動

ドキュメントロード後に呼び出される `Widget.init()` は各UI部品に対して以下を実行する：

1. マーカCSSにマッチするドキュメント上の各要素に対してUI部品のインスタンスを作成する。要素のNodeインスタンスおよびマーカCSSに付随するオプションをパースしたオブジェクトがコンストラクタ引数として渡される。
2. 生成したインスタンスを当該要素の `data-` プロパティとして設定し、UI部品のインスタンスがGCの対象とならないようにする。初期化前に `data-` プロパティをチェックするため、同じ要素に複数回初期化が行われることはない。

<details>
<summary>keywords</summary>

Widget.init, マーカCSS, インスタンス生成, data-プロパティ, UI部品初期化, ドキュメントロード

</details>

## UI部品の再初期化

> **重要**: JavaScriptのテンプレート処理などで画面ロード完了後にマーカCSSを含むドキュメントノードを動的に追加した場合、初期化処理は自動実行されない。明示的に `Widget.init()` を呼び出す必要がある。

既に初期化されている要素に対しては何もしないため、複数回実行しても既存のUI部品に影響を与えない。

<details>
<summary>keywords</summary>

Widget.init, 動的追加, 再初期化, テンプレート処理, マーカCSS, UI部品再初期化

</details>

## ファイル構成

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| 初期ロードスクリプト | ○ | △ | /js/nablarch.js | AMDロードパスを設定し、PJで使用するUIモジュールの初期化ルーチンを実行する。また、スクリプトロード直後でしか実行できない処理をあわせて行う（iPadでの画面ロードサイズに関する問題の対処スクリプトの適用など） |
| ミニファイ済みスクリプト | × | ○ | /js/nablarch-minify.js | 初期ロードスクリプトの依存ライブラリを全て結合しミニファイしたスクリプト。本番環境ではこのスクリプトとrequire.jsのみを使用する |
| AMDスクリプトローダ | △ | ○ | /js/require.js | AMD形式で記述されたJavaScript部品のローダ |
| テキストリソースローダ | ○ | △ | /js/text.js | require.jsの拡張プラグイン。JavaScript以外のテキストリソースをXHR経由で動的にロードする |
| jQueryライブラリ | ○ | △ | /js/jquery.js | DOM操作API/イベント管理APIのブラウザ間互換レイヤーを提供する |
| sugar.js | ○ | △ | /js/sugar.js | ECMAScript5互換関数およびその他のユーティリティ系API群の提供 |
| 簡易BigDecimal | ○ | △ | /js/nablarch/util/BigDecimal.js | JavaScriptによる簡易BigDecimal実装 |
| 簡易SimpleDateFormat | ○ | △ | /js/nablarch/util/SimpleDateFormat.js | Java SDK SimpleDateFormatの仕様のうち日付に関する処理のサブセットを実装 |
| 日付ライブラリ | ○ | △ | /js/nablarch/util/DateUtil.js | JavaScriptネイティブ日付型（Date）と日付文字列との相互変換ライブラリ |
| UI部品共通プロトタイプ | ○ | △ | /js/nablarch/ui/Widget.js | UI部品の実装に必要な共通機能（HTMLノードへのバインド/イベント定義/画面ロード時処理の起動）を実装する共通プロトタイプ |
| 自動集計 | ○ | △ | /js/nablarch/ui/AutoSum.js | 入出力項目の自動集計を行うUI部品 |
| 日付入力部品 | ○ | △ | /js/nablarch/ui/DatePicker.js | カレンダーを用いた日付入力を実装するUI部品 |
| カレンダーテンプレート | △ | △ | /js/nablarch/ui/DatePicker.template | 日付入力部品のカレンダー部分に表示するHTMLを記述するテキストファイル |
| リストビルダー部品 | ○ | △ | /js/nablarch/ui/ListBuilder.js | 2つのセレクトボックスを用いた複数選択用のUI |
| リストビルダーテンプレート | △ | △ | /js/nablarch/ui/ListBuilder.template | リストビルダーの制御ボタン部分に表示するHTMLを記述するテキストファイル |
| タブ切り替え部品 | ○ | △ | /js/nablarch/ui/Tab.js | JavaScriptによるページ内タブ切り替えUIを実装する部品 |
| Nablarchサブミット連動 | ○ | △ | /js/nablarch/ui/event.js | Nablarchのサブミット制御管理機構に連動して画面サブミットの前後に発火するカスタムイベントを定義する |

凡例: サーバ=実働環境にデプロイして使用するかどうか、ローカル=ローカル動作時に使用するかどうか、○=使用する、△=直接は使用しないがミニファイしたファイルの一部として使用、×=使用しない

<details>
<summary>keywords</summary>

nablarch.js, nablarch-minify.js, require.js, Widget.js, DatePicker.js, AutoSum.js, ListBuilder.js, Tab.js, event.js, BigDecimal.js, SimpleDateFormat.js, DateUtil.js, ファイル構成

</details>

## 新規 JavaScript UI部品の作成方法

UIカタログに収録されている既存のもの以外のUI部品を独自に作成できる。標準的なUI部品は3種類のファイルで構成される。

<details>
<summary>keywords</summary>

カスタムUI部品, UI部品作成, ウィジェット, 独自UI部品

</details>

## 作成するファイル

標準的なUI部品は以下の3つのファイルで構成される。

**1. モジュール定義ファイル（.js）**

ウィジェットの処理を記述したJavaScriptファイル。配置場所：

```
(コンテキストルート)/js/(PJ名)/ui/(ウィジェット名).js
```

**2. テンプレートファイル（.template）**

ウィジェット内のUIを定義するHTMLファイル。モジュール定義ファイルと同じ場所に配置：

```
(コンテキストルート)/js/(PJ名)/ui/(ウィジェット名).template
```

**3. スタイル定義（.less）**

ウィジェットのスタイルを定義するCSS（LESS）ファイル。配置場所：

```
(コンテキストルート)/css/ui/(ウィジェット名).less
```

<details>
<summary>keywords</summary>

モジュール定義ファイル, テンプレートファイル, スタイル定義, .less, .template, ウィジェット作成, UI部品ファイル構成

</details>
