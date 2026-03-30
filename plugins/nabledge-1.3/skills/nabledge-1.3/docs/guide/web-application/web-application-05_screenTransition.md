# 画面遷移処理

## 本項で説明する内容

## 作成ファイル

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-05_screenTransition/W11AC0201.jsp) | View | ユーザ情報登録画面に入力した内容及び、登録画面に戻るボタンと、登録処理を行うボタンを表示する。W11AC0202.jsp内でW11AC0201.jspを取り込んでいる。|
| [W11AC0202.jsp](../../../knowledge/guide/web-application/assets/web-application-05_screenTransition/W11AC0202.jsp) | | |

ステレオタイプについては :ref:`stereoType` を参照。

<details>
<summary>keywords</summary>

W11AC0201.jsp, W11AC0202.jsp, 画面遷移処理, ViewJSPファイル, ステレオタイプ

</details>

## 作成手順

## View(JSP)の作成

画面遷移の実装にはアプリケーションフレームワーク提供のカスタムタグを使用する。

- `n:form` タグ: HTMLフォームの作成に使用する。`windowScopePrefixes` 属性で入力値の復元を制御する。
- `button:cancel` タグ: キャンセルボタンを出力する。`uri` 属性にサブミットするパスを指定する。
- `button:confirm` タグ: 確定ボタンを出力する。`uri` 属性にサブミットするパスを指定する。

> **注意**: `button:cancel` と `button:confirm` はアプリケーションフレームワークのコア機能ではなく、**サンプル提供されるタグファイル**である。

> **注意**: `button:cancel` のデフォルトラベルは「キャンセル」、`button:confirm` は「確定」。一部画面でラベルを変えたい場合は `label` 属性に表示文言を指定する。

## 登録画面へ戻る際の入力値の復元

キャンセルボタン押下で前の画面へ戻った際に入力値を復元するには、以下の2点を実装すること:

1. 入力項目（テキストエリア、ラジオボタンなど）の作成にはアプリケーションフレームワーク提供のカスタムタグを使用する。
2. `n:form` タグの `windowScopePrefixes` 属性に、入力項目のカスタムタグの `name` 属性で指定したプレフィックス :ref:`(参照)<04_JSPNameAttribute>` を指定する。

実装ファイル: [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-05_screenTransition/W11AC0201.jsp)

<details>
<summary>keywords</summary>

n:form, button:cancel, button:confirm, windowScopePrefixes, uri属性, label属性, 入力値復元, キャンセルボタン, 確定ボタン, JSP画面遷移実装, サンプル提供タグファイル

</details>

## 次に読むもの

なし

<details>
<summary>keywords</summary>

カスタムタグ, WebView, 画面遷移参照

</details>
