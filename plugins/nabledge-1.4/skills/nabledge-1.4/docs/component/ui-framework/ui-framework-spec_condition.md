# 画面表示パターン定義ウィジェット

## コードサンプル

`spec:condition`は同じ業務画面内で発生しうる複数の表示状態を設計情報として記述する部品。以下の条件で画面状態を定義できる:

1. 表示する画面レイアウト（[spec_layout](ui-framework-spec_layout.md) 参照）
2. 入力画面/確認画面の切り替え
3. `<c:if>` による条件分岐の切り替え

> **注意**: この部品はJSPのサーバ表示には一切影響しないため、実装工程以降も削除不要。

**例1) layout属性**: 表示するレイアウトの組み合わせを定義

```jsp
<spec:condition
  name="初期表示"
  layout="検索条件入力欄">
</spec:condition>
<spec:condition
  name="検索処理実行後"
  layout="検索条件入力欄|ユーザ情報検索結果">
</spec:condition>

<spec:layout name="検索条件入力欄">
 //検索条件入力欄の内容
</spec:layout>
<spec:layout name="ユーザ情報検索結果">
 //検索結果テーブルの内容
</spec:layout>
```

**例2) isConfirmationPage属性**: 入力画面と確認画面をそれぞれ表示状態として定義

```jsp
<spec:condition name="登録画面"></spec:condition>
<spec:condition name="確認画面" isConfirmationPage="true"></spec:condition>
```

**例3) when属性**: `<c:if>`の条件分岐にあわせて表示状態を定義

```jsp
<spec:condition
  name="確認画面：一般グループ選択時"
  isConfirmationPage="true"
  when="一般グループ選択時">
</spec:condition>
<spec:condition
  name="確認画面：お客様グループ選択時"
  isConfirmationPage='true'
  when="お客様グループ選択時">
</spec:condition>

<c:if><spec:desc>一般グループ選択時</spec:desc>
  <button:submit
    label="メッセージ送信"
    uri="/action/ss11AC/W11AC02Action/RW11AC0205"
    allowDoubleSubmission="false"
    dummyUri="./W11AC0203.jsp">
  </button:submit>
</c:if>
```

<details>
<summary>keywords</summary>

spec:condition, 画面表示パターン定義, 表示状態定義, layout属性, isConfirmationPage属性, when属性, 画面レイアウト切り替え, 入力画面確認画面切り替え, c:if条件分岐

</details>

## 仕様

**ローカル動作時の挙動**: 設計書ビューの「画面レイアウト」欄に、本タグで定義した各画面状態のプレビューへのリンクを出力する。リンクをクリックするとプレビュー画面がリロードされ、その画面状態のプレビューを確認できる。JSPプレビュー表示の内容には影響しない。

**属性値一覧** [**◎** 必須属性 **○** 任意属性 **×** 無効（指定しても効果なし）]

| プロパティ名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| name | 画面状態名 | 文字列 | × | ◎ | |
| layout | 表示対象レイアウト | 文字列 | × | ○ | 表示するレイアウト名を'|'区切りで指定。デフォルトは全レイアウト表示 |
| when | `<c:if>`条件切り替え | 文字列 | × | ○ | trueとして評価する`<c:if>`直下の`<spec:desc>`内容を'|'区切りで指定。デフォルトは`<spec:desc>`直上の親要素の`<c:if>`を全てtrueとして評価 |
| isConfirmationPage | 確認画面表示モード | 真偽値 | × | ○ | 確認画面モードで表示する場合はtrue。デフォルトはfalse |
| comment | 備考 | 文字列 | × | ○ | |

<details>
<summary>keywords</summary>

name, layout, when, isConfirmationPage, comment, 属性値一覧, 設計書ビュー, ローカル動作, 画面状態プレビュー

</details>

## 内部構造・改修時の留意点

サーバ表示用タグファイル（condition.tag）はJSPコンパイルを通すためだけのダミーファイルであり、属性定義のみで中身はほぼない。

設計書ビューはテンプレートファイル `SpecSheetTemplate.xlsx` と、各項目の表示内容を制御する `SpecSheetInterpreter.js` で構成される。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/condition.tag | [spec_layout](ui-framework-spec_layout.md) のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（上記ファイルをHTML形式で保存したもの） |

<details>
<summary>keywords</summary>

condition.tag, SpecSheetTemplate.xlsx, SpecSheetInterpreter.js, SpecSheetView.js, spec.js, 内部構造, 設計書ビュー構成

</details>
