# Appendix A: ウィンドウスコープ概要

## 動作イメージ

ウィンドウスコープは、リクエストを跨るデータを格納する領域。セッションスコープがサーバ上でデータを格納するのに対し、複数画面間をhiddenタグで持ちまわることで実現される。ブラウザで複数ウィンドウを立ち上げても並列動作が可能で、ヒストリバックによる遷移も可能。

hiddenで引き継がれる情報は特定ウィンドウ内のHTMLに記載されるため、他のウィンドウやタブに影響を与えずに複数リクエストをまたがったデータ共有を実現する。

> **注意**: ウィンドウスコープに格納された変数は、カスタムタグを使用することで自動的にhiddenタグに変換される。**アプリケーションプログラマがJSPにhiddenタグを書く必要はない**（具体的な実装方法は :ref:`window_scope_guide_links` 参照）。

![複数の入力画面でhiddenタグによりデータを引き継ぐシーケンス図](../../../knowledge/guide/web-application/assets/web-application-02_WindowScope/sequence.png)

<details>
<summary>keywords</summary>

ウィンドウスコープ, hiddenタグ, 複数画面間のデータ保持, カスタムタグ, JSP, ヒストリバック

</details>

## セッションスコープとの使い分け

**基本方針**: セッションスコープではなく**ウィンドウスコープを使用**する。

- **ウィンドウスコープを使用**: ウィンドウ間で共有する必要のないデータ（ほとんどの場合）
- **セッションスコープを使用**: ウィンドウ間でデータを共有する必要がある場合（例: ショッピングカート内の商品情報はユーザが複数ウィンドウを使用していてもユーザに対して1つにしなければならないケース）

<details>
<summary>keywords</summary>

ウィンドウスコープ, セッションスコープ, スコープ選択, ウィンドウ間データ共有, ショッピングカート

</details>

## 詳細情報

- 変数スコープの利用（ウィンドウスコープ、セッションスコープ等）: 画面オンライン処理用業務アクションハンドラ - [変数スコープの利用](../../../fw/reference/handler/HttpMethodBinding.html#web-scope)
- カスタムタグを使用したウィンドウスコープの使用方法: カスタムタグ実装例集 - :ref:`howto_window_scope`

<details>
<summary>keywords</summary>

変数スコープ, howto_window_scope, カスタムタグ実装例集, HttpMethodBinding, window_scope_guide_links

</details>
