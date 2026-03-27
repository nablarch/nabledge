# 入力画面と確認画面の共通化

## 本項で説明する内容

Nablarch Application Frameworkは、入力画面と確認画面が1対1に対応するような画面を作成する場合に、JSPを共通化する機能を提供する。

<details>
<summary>keywords</summary>

JSP共通化, 入力画面と確認画面の共通化, Nablarch Application Framework

</details>

## 作成手順

入力画面と確認画面を共通化する場合の構成概要:

- 入力画面のJSPに全ての情報を記載する
- 確認画面のJSPには、入力画面とJSPを共通化する旨のカスタムタグ（`n:confirmationPage`）を記載するだけでよい
- 入力画面と確認画面とで表示内容が異なる箇所は、入力画面のJSPに分岐処理を埋め込み、入力画面用と確認画面用の表示処理を記述する

編集ファイル:

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| W11AC0201.jsp | View | ユーザ情報登録画面に入力した内容、登録画面に戻るボタン、登録処理ボタンを表示。W11AC0202.jspから取り込まれる。 |
| W11AC0202.jsp | | |

<details>
<summary>keywords</summary>

View作成, JSP作成概要, W11AC0201.jsp, W11AC0202.jsp, 入力画面JSP, 確認画面JSP

</details>

## 画面イメージ

![W11AC0202 確認画面イメージ](../../../knowledge/guide/web-application/assets/web-application-06_sharingInputAndConfirmationJsp/W11AC0202.png)

<details>
<summary>keywords</summary>

確認画面イメージ, W11AC0202画面

</details>

## 入力画面の作成方法

入力画面JSP（W11AC0201.jsp）の作成方法:

- a) 両方の画面に共通する内容を記述する
- b) 入力画面でのみ表示する内容は `n:forInputPage` タグで囲む
- c) 確認画面でのみ表示する内容は `n:forConfirmationPage` タグで囲む

> **注意**: `n:text`、`n:password`、`n:select` タグは、入力画面ではinput/selectタグとして出力されるが、確認画面として描画される場合はタグではなく文字列として表示される。詳細は [入力項目の確認画面用の出力](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FormTag.html#output-for-confirmation-page) を参照。サンプル提供のタグファイルを使用した場合、「nタグ」を直接使用するのではなく「fieldタグ」内で「nタグ」が出力される。

> **注意**: `n:forInputPage` タグで囲まれた箇所は入力画面でのみ評価され、`n:forConfirmationPage` タグで囲まれた箇所は確認画面でのみ評価される。詳細は [入力画面と確認画面の表示切り替え](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FacilitateTag.html#id13) を参照。

サンプルコード: W11AC0201.jsp

<details>
<summary>keywords</summary>

n:forInputPage, n:forConfirmationPage, n:text, n:password, n:select, 入力画面JSP作成, 表示切り替え

</details>

## 確認画面の作成方法

確認画面JSP（W11AC0202.jsp）の作成方法:

- a) `n:confirmationPage` タグを使用し、`path` 属性に共通化する入力画面へのパスを指定する

サンプルコード: W11AC0202.jsp

> **注意**: ソースコードをそのままファイルに保管しようとすると文字コードに関するエラーが出る。必ず【説明】で始まるコメント行を削除してからファイルを保管すること。

<details>
<summary>keywords</summary>

n:confirmationPage, path属性, 確認画面JSP作成, W11AC0202.jsp, 文字コード

</details>

## 共通化の指針

JSP共通化を採用するかどうかの判断基準:

- **共通化すべきケース**: 入力画面と確認画面がほぼ同一内容のシンプルな登録処理。JSP記述量を減らせるため生産性向上が見込まれる。
- **共通化すべきでないケース**: 入力画面と確認画面の差異が大きい複雑な業務。場合分けの記述を1画面に詰め込むと煩雑で保守性の低いコードになるため、別々のJSPファイルを作成すること。

<details>
<summary>keywords</summary>

JSP共通化の判断基準, シンプルな登録処理, 保守性, 入力画面と確認画面の差異

</details>

## 次に読むもの

- [画面共通化のカスタムタグ使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FacilitateTag.html#webview-inputconfirmationcommon)

<details>
<summary>keywords</summary>

画面共通化カスタムタグ, 参考リンク, FacilitateTag

</details>
