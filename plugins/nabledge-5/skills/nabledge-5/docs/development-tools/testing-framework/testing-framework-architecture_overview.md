# 全体構造

**公式ドキュメント**: [全体構造](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/architecture_overview.html)

## コンポーネント概要

業務機能JSPから使用する5つのコンポーネントの概要:

- **jsp_page_templates**: 業務画面の内容のうち、業務機能領域を除く各共通領域の描画やHTMLヘッダ等の各種宣言について、**UI標準**に準拠した形で実装するJSPタグファイルおよびインクルードファイル群。

- **jsp_widgets**: ボタンや検索結果テーブル、各種入力フィールドといった業務画面内に配置するUI部品について、**UI標準**に準拠した形で実装するJSPタグファイル群。

- **css_framework**: `jsp_page_templates` および `jsp_widgets` などの共通部品に対し**UI標準**に沿った統一的な外観を与える共通スタイル定義。また、デバイスサイズに応じた動的な表示調整を行う。

- **js_framework**: **UI標準**の内容のうち、カレンダー日付入力部品のような、通常のHTMLの範疇では実現できないUI機能を実装するために、`jsp_widgets` が使用するJavaScript部品群。

- **inbrowser_jsp_rendering**: 業務画面のJSPソースファイルをJavaScriptでレンダリングすることにより、`jsp_page_templates` および `jsp_widgets` を用いて作成したローカルディスク上のJSPファイルを通常のブラウザで直接開けるようにする仕組み。これにより設計中の画面のイメージや動作デモを簡単に確認することができる。

<details>
<summary>keywords</summary>

jsp_page_templates, jsp_widgets, css_framework, js_framework, inbrowser_jsp_rendering, コンポーネント概要, UI標準, デバイスサイズ, ローカルプレビュー, 業務機能JSP

</details>

## 本番環境での外部ライブラリへの依存

本番環境で使用する外部ライブラリ一覧:

| ライブラリ名 | 類別 | 用途 | ライセンス |
|---|---|---|---|
| require.js | JavaScript | JavaScriptの分割モジュール管理 | MIT |
| sugar.js | JavaScript | ECMAScript5互換関数を含むユーティリティAPI群の提供 | ライセンスフリー |
| jQuery | JavaScript | DOM関連APIの簡易化およびブラウザ互換レイヤの提供 | MIT |
| font-awesome | css/webフォント | 各種アイコン画像の提供 | MIT, SIL OFL 1.1 |

> **注意**: これらのライブラリを業務画面JSPから直接使用することは想定していない。

<details>
<summary>keywords</summary>

外部ライブラリ, require.js, sugar.js, jQuery, font-awesome, 本番環境依存ライブラリ, ライセンス, 業務画面JSP直接使用禁止

</details>

## サーバ動作時の構成

サーバ動作時の各モジュールの依存関係:

| モジュール | 依存対象 | 詳細 |
|---|---|---|
| 業務画面JSP | UI部品ウィジェット、業務画面テンプレート、タグライブラリ | 共通領域は `jsp_page_templates` を使用。業務領域のUI要素は `jsp_widgets` を使用。直接使用するタグライブラリは変数管理・フロー制御（`<n:write>`, `<n:set>`, `<c:if>`, `<n:forInputPage>` 等）とページ遷移制御（`<n:form>`, `<n:param>` 等）のみ。JavaScriptは業務画面JSPに直接記述せず `jsp_widgets` を通じて使用する。 |
| `jsp_page_templates` | UI部品ウィジェット、タグライブラリ | 基本的に業務画面JSPと同等の扱い。HTMLヘッドタグ記述のため `<n:script>`, `<n:nocache>` 等のタグライブラリを使用する。 |
| `jsp_widgets` | JavaScript UI部品、タグライブラリ | タグライブラリおよびHTMLで記述。HTMLのみで実現できないUIについてはJavaScript UI部品に依存する。`jsp_widgets` が出力するHTMLと `js_framework` との紐付けはマーカーCSSで行うため、`jsp_widgets` が直接JavaScriptを使用することはない。 |
| `js_framework` | サードパーティJS | 標準JavaScript（ECMA）、DOM API、サードパーティJSライブラリを使用する。 |

<details>
<summary>keywords</summary>

サーバ動作, モジュール依存関係, マーカーCSS, 業務画面JSP, タグライブラリ, jsp_widgets, jsp_page_templates, js_framework, JavaScriptUI部品

</details>

## ローカル動作時の構成

ローカルデモ動作では `web_project/ui_demo/ローカル画面確認.bat` で起動するHTTPサーバで業務画面JSPを表示し、JavaScript上でJSPタグをレンダリングして表示する。

ローカル動作とサーバ動作で共通のコンポーネント:
- 業務画面JSP
- `jsp_page_templates`
- `jsp_widgets`
- `js_framework`
- サードパーティJSライブラリ

**相違点（JSPの解釈処理）**:
- サーバ動作: **タグライブラリ** + アプリケーションサーバ上の **JSPレンダリングエンジン** がJSPを解釈
- ローカル動作: `inbrowser_jsp_rendering` + **タグライブラリ スタブJS** が代替

**タグライブラリ スタブJS** は `inbrowser_jsp_rendering` 機能の一部であり、JSPタグライブラリの挙動についてブラウザ上で一定のエミュレーションを行う。サポートするタグライブラリの一覧およびエミュレーション処理の内容については `../reference_jsp_widgets/index` を参照。

<details>
<summary>keywords</summary>

ローカルデモ動作, タグライブラリスタブJS, inbrowser_jsp_rendering, JSPレンダリング, ブラウザエミュレーション, ローカル画面確認, JSP解釈

</details>
