# 入力画面と確認画面の共通化

## 本項で説明する内容

Nablarch Application Frameworkは、入力画面と確認画面が1対1に対応する場合にJSPを共通化する機能を提供する。

編集対象ファイル:
- `W11AC0201.jsp` (View): ユーザ情報登録画面に入力した内容・戻るボタン・登録ボタンを表示。W11AC0202.jspに取り込まれる。
- `W11AC0202.jsp` (View): 確認画面。入力画面JSPを取り込む。

<details>
<summary>keywords</summary>

JSP共通化, 入力画面と確認画面の共通化, W11AC0201.jsp, W11AC0202.jsp, n:confirmationPage, n:forInputPage, n:forConfirmationPage

</details>

## 概要

入力画面と確認画面を共通化する場合、入力画面のJSPに全ての情報を記載する。確認画面のJSPには、入力画面とJSPを共通化する旨のカスタムタグを記載するだけでよい。

入力画面と確認画面で表示内容が異なる箇所については、入力画面のJSPに分岐処理を埋め込んで、入力画面用の表示処理と確認画面用の表示処理を記述する。

<details>
<summary>keywords</summary>

JSP共通化の仕組み, 入力画面JSP, 確認画面JSP, 分岐処理, n:forInputPage, n:forConfirmationPage

</details>

## 入力画面の作成方法

入力画面JSP (`W11AC0201.jsp`) の作成手順:
1. 両方の画面に含まれる内容を記述する
2. 入力画面でのみ表示する内容は `n:forInputPage` タグで囲む
3. 確認画面でのみ表示する内容は `n:forConfirmationPage` タグで囲む

> **注意**: `n:text`、`n:password`、`n:select` タグは、入力画面ではinput/selectタグとして出力されるが、確認画面では文字列として表示される。詳細: [入力項目の確認画面用の出力](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FormTag.html#output-for-confirmation-page)。サンプル提供のタグファイルを使用した場合、「nタグ」を直接使用するのではなく「fieldタグ」内で「nタグ」が出力される。

> **注意**: `n:forInputPage` タグで囲まれた箇所は入力画面でのみ評価され、`n:forConfirmationPage` タグで囲まれた箇所は確認画面でのみ評価される。詳細: [入力画面と確認画面の表示切り替え](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FacilitateTag.html#id13)

<details>
<summary>keywords</summary>

n:forInputPage, n:forConfirmationPage, n:text, n:password, n:select, 入力画面JSP, W11AC0201.jsp, fieldタグ, 確認画面用の出力

</details>

## 確認画面の作成方法

確認画面JSP (`W11AC0202.jsp`) の作成手順:
- `n:confirmationPage` タグを使用し、`path` 属性に共通化する入力画面へのパスを指定する

> **注意**: サンプルコードをそのまま保存しようとすると文字コードエラーが発生する。「説明」で始まるコメント行を削除してからファイルを保存すること。

<details>
<summary>keywords</summary>

n:confirmationPage, path属性, 確認画面JSP, W11AC0202.jsp

</details>

## 共通化の指針

**共通化を使用すべき場合**: 入力画面と確認画面がほぼ同一のシンプルな登録処理。JSP記述量が削減でき、生産性向上が見込まれる。

**共通化を避けるべき場合**: 入力画面と確認画面の差異が大きい複雑な業務。入力画面と確認画面の場合分けを1画面に詰め込むと煩雑で保守性の低いコードになる。このような場合は別々のJSPファイルを作成すること。

<details>
<summary>keywords</summary>

JSP共通化の指針, 確認画面共通化, 保守性, 入力画面と確認画面, シンプルな登録処理

</details>

## 次に読むもの

[画面共通化のカスタムタグ使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FacilitateTag.html#webview-inputconfirmationcommon)

<details>
<summary>keywords</summary>

カスタムタグ, 画面共通化, n:confirmationPage, FacilitateTag

</details>
