# 全体構造

## 本番環境での外部ライブラリへの依存

本番環境で使用する外部ライブラリ:

| ライブラリ名 | 類別 | 用途 | ライセンス |
|---|---|---|---|
| require.js | JavaScript | JavaScriptの分割モジュール管理 | MIT |
| sugar.js | JavaScript | ECMAScript5互換関数を含むユーティリティAPI群の提供 | ライセンスフリー |
| jQuery | JavaScript | DOM関連APIの簡易化およびブラウザ互換レイヤの提供 | MIT |
| font-awesome | css/webフォント | 各種アイコン画像の提供 | MIT, SIL OFL 1.1 |

> **重要**: これらのライブラリを業務画面JSPから直接利用することは想定していない。

<details>
<summary>keywords</summary>

require.js, sugar.js, jQuery, font-awesome, 外部ライブラリ依存, 本番環境, JavaScriptライブラリ, ライセンス

</details>

## サーバ動作時の構成

サーバ動作時のモジュール依存関係:

![サーバ動作時のアーキテクチャ構成図](../../../knowledge/component/ui-framework/assets/ui-framework-architecture_overview/architecture_overview_server.png)

> **注意**: `css_framework` はこの図には記述していない。

| モジュール | 依存対象 | 詳細 |
|---|---|---|
| 業務画面JSP | UI部品ウィジェット、業務画面テンプレート、タグライブラリ | 共通領域は[jsp_page_templates](ui-framework-jsp_page_templates.md)で描画。業務画面領域のUI要素は[jsp_widgets](ui-framework-jsp_widgets.md)を使用。 |
| [jsp_page_templates](ui-framework-jsp_page_templates.md) | UI部品ウィジェット、タグライブラリ | 基本的に業務画面JSPと同等。HTMLヘッドタグ記述のために`<n:script>` `<n:nocache>`などのタグライブラリを使用。 |
| [jsp_widgets](ui-framework-jsp_widgets.md) | JavaScript UI部品、タグライブラリ | HTMLのみで実現できないUIには**JavaScript UI部品**に依存。[js_framework](ui-framework-js_framework.md)との紐付けは**マーカーCSS**で行うため、[jsp_widgets](ui-framework-jsp_widgets.md)が直接JavaScriptを使用することは無い。 |
| [js_framework](ui-framework-js_framework.md) | サードパーティJS | 標準JavaScript(ECMA)、DOM APIおよびサードパーティJSライブラリを利用。 |

業務画面JSPから直接使用するタグライブラリは以下のものに限る:
- 変数管理・フロー制御: `<n:write>` / `<n:set>` / `<c:if>` / `<n:forInputPage>` など
- ページ遷移制御: `<n:form>` / `<n:param>` など

JavaScriptを業務画面JSPに直接記述することはせず、[jsp_widgets](ui-framework-jsp_widgets.md)を通じて利用する。

<details>
<summary>keywords</summary>

マーカーCSS, タグライブラリ, サーバ動作, モジュール依存関係, n:write, n:set, c:if, n:forInputPage, n:form, n:param, n:script, n:nocache, jsp_page_templates, jsp_widgets, js_framework, JSPレンダリング

</details>

## ローカル動作時の構成

ローカルデモ動作は`tutorial_project/ui_demo/ローカル画面確認.bat`で起動されるHTTPサーバで業務画面JSPを表示し、JavaScript上でJSPタグをレンダリングして表示する仕組み。

![ローカル動作時のアーキテクチャ構成図](../../../knowledge/component/ui-framework/assets/ui-framework-architecture_overview/architecture_overview_local.png)

サーバ動作とローカル動作の比較:

- 共通コンポーネント: 業務画面JSP、[jsp_page_templates](ui-framework-jsp_page_templates.md)、[jsp_widgets](ui-framework-jsp_widgets.md)、[js_framework](ui-framework-js_framework.md)、サードパーティJSライブラリ
- 相違点: JSPの解釈（HTMLへの変換）を担う部分
  - サーバ動作: **タグライブラリ**およびアプリケーションサーバ上の**JSPレンダリングエンジン**が処理
  - ローカル動作: [inbrowser_jsp_rendering](ui-framework-inbrowser_jsp_rendering.md)と**タグライブラリ スタブJS**が代替

**タグライブラリ スタブJS**は[inbrowser_jsp_rendering](ui-framework-inbrowser_jsp_rendering.md)機能の一部であり、JSPタグライブラリの挙動についてブラウザ上でエミュレーションを行う。サポートするタグライブラリの一覧およびエミュレーション処理の内容は[../reference_jsp_widgets/index](ui-framework-reference_jsp_widgets.md)を参照。

<details>
<summary>keywords</summary>

inbrowser_jsp_rendering, タグライブラリ スタブJS, ローカルデモ, ブラウザレンダリング, ローカル動作, JSP解釈, エミュレーション

</details>
