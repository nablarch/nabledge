# 入力画面と確認画面の共通化

## 本項で説明する内容

NablarchはJSPを共通化する機能を提供する（入力画面と確認画面が1対1に対応する場合）。

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-06_sharingInputAndConfirmationJsp/W11AC0201.jsp) / [W11AC0202.jsp](../../../knowledge/guide/web-application/assets/web-application-06_sharingInputAndConfirmationJsp/W11AC0202.jsp) | View | ユーザ情報登録画面に入力した内容および、登録画面に戻るボタンと登録処理を行うボタンを表示する。W11AC0202.jspの内部でW11AC0201.jspを取り込んでいる。 |

<details>
<summary>keywords</summary>

JSP共通化, 入力画面と確認画面の共通化, W11AC0201.jsp, W11AC0202.jsp, JSPファイル共通化機能

</details>

## 作成手順

## 概要

- 入力画面JSP（W11AC0201.jsp）に全ての情報を記載し、確認画面JSP（W11AC0202.jsp）には `n:confirmationPage` タグのみ記載する。
- 入力画面と確認画面で表示内容が異なる箇所は、入力画面JSP内に分岐処理（`n:forInputPage` / `n:forConfirmationPage`）を埋め込む。

## 入力画面の作成

a. 両画面共通の内容を記述する
b. 入力画面のみ表示する内容: `n:forInputPage` タグで囲む
c. 確認画面のみ表示する内容: `n:forConfirmationPage` タグで囲む

> **注意**: `n:text`、`n:password`、`n:select`タグは入力画面ではinput/selectタグとして出力されるが、確認画面として描画される場合はタグではなく文字列として表示される。

> **注意**: `n:forInputPage`タグで囲まれた箇所は入力画面でのみ評価され、`n:forConfirmationPage`タグで囲まれた箇所は確認画面でのみ評価される。

## 確認画面の作成

`n:confirmationPage` タグを使用し、`path` 属性に共通化する入力画面JSPへのパスを指定する。

> **注意**: W11AC0202.jspのソースコードをそのままファイルに保管しようとすると、文字コードに関するエラーが出る。必ず、【説明】で始まるコメント行を削除してからファイルを保管すること。

<details>
<summary>keywords</summary>

n:forInputPage, n:forConfirmationPage, n:confirmationPage, n:text, n:password, n:select, 入力画面JSP作成, 確認画面JSP作成, path属性, 文字コードエラー, コメント行削除

</details>

## 共通化の指針

- 入力画面と確認画面がほぼ同一内容のシンプルな登録処理では、JSP共通化によりJSP記述量を削減でき、生産性向上が見込まれるため本機能を使用すべきである。
- 複雑な業務で入力画面と確認画面の差異が大きい場合は、1画面に場合分け記述を詰め込むことになり、煩雑で保守性の低いコードになる恐れがある。この場合は無理に共通化せず、別々のJSPファイルを作成すべきである。

<details>
<summary>keywords</summary>

JSP共通化の判断基準, シンプルな登録処理, 保守性, 複雑な業務, 別々のJSPファイル

</details>
