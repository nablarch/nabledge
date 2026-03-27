# 業務画面テンプレートとUI部品を利用して業務画面JSPを作成する

## 画面のテンプレートを用意する

業務画面JSPに業務画面テンプレート・UI部品を利用するために必要な記述内容。

**DOCTYPE宣言**:
```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
```

> **重要**: ローカルJSPレンダリング機能を有効にするスクリプトタグは、本番稼働時には出力されないようにコメントアウトすること。

```jsp
<!-- <%/* --> <script src="js/devtool.js"></script><meta charset="utf-8"><body> <!-- */%> -->
```

**JSPディレクティブ**:
```jsp
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
```

**利用するtaglib**:

| タグライブラリ | prefix | tagdir/uri |
|---|---|---|
| 業務画面テンプレート | `t` | `/WEB-INF/tags/template` |
| fieldウィジェット（入力・表示項目） | `field` | `/WEB-INF/tags/widget/field` |
| buttonウィジェット（ボタン） | `button` | `/WEB-INF/tags/widget/button` |
| tableウィジェット（テーブル表示） | `table` | `/WEB-INF/tags/widget/table` |
| columnウィジェット（テーブル列） | `column` | `/WEB-INF/tags/widget/column` |
| tabウィジェット（タブ/リンク表示） | `link` | `/WEB-INF/tags/widget/tab` |
| linkウィジェット（リンク） | `link` | `/WEB-INF/tags/widget/link` |
| Nablarchタグライブラリ（`nablarch.jar`同梱） | `n` | `http://tis.co.jp/nablarch` |

タグの詳細は [widget_list](ui-framework-widget_list.md) 参照。

**業務画面テンプレートの利用**（`t:テンプレート名`）:
```jsp
<t:page_template
    title="画面タイトル"
    confirmationPageTitle="確認画面タイトル（入力・確認画面でJSPを共用しない場合は不要）">

  <jsp:attribute name="contentHtml">
      <%-- 業務領域 --%>
  </jsp:attribute>
</t:page_template>
```

<details>
<summary>keywords</summary>

業務画面テンプレート, taglib設定, page_template, JSPテンプレート, DOCTYPE宣言, devtool.js, fieldウィジェット, buttonウィジェット, tableウィジェット, columnウィジェット, tabウィジェット, linkウィジェット, Nablarchタグライブラリ

</details>

## 画面をブラウザで表示する

作成した業務画面JSPは、業務JSP作成用プロジェクトのサブシステムIDのディレクトリ配下に配置する（[project_structure](ui-framework-project_structure.md) 参照）。

ローカル画面確認.batを実行することで作成した画面に遷移し、レイアウト確認が可能。

> **注意**: IEを使用する場合は開発者ツールで以下の設定を確認すること。
> - **ブラウザーモード**: 使用しているIEのバージョンと同じ
> - **ドキュメントモード**: 標準
>
> 開発者ツールを開いた状態では画面表示が崩れる場合があるため、設定確認後はツールを閉じること。

<details>
<summary>keywords</summary>

ブラウザ表示, ローカル画面確認, IE設定, ドキュメントモード, サブシステムID配置

</details>

## UI部品（ウィジェット）を配置していく

ウィジェットは以下のようなタグ形式で業務画面JSPに記述する。具体的なウィジェットの利用方法や画面項目との対応については [example](#s7) 参照。

> **警告**: ウィジェットを**自己終了エレメント**として記述するとブラウザでのレイアウト確認が行えなくなる（自己終了エレメント以降のタグが表示されなくなる）。

**OK**（開始タグ＋終了タグで記述）:
```jsp
<field:label title="ログインID" sample="login-id"></field:label>
```

**NG**（自己終了エレメント）:
```jsp
<field:label title="ログインID" sample="login-id" />
```

<details>
<summary>keywords</summary>

ウィジェット配置, 自己終了エレメント, field:label, JSPウィジェット記述形式

</details>

## ウィジェットに定義されている属性について

**name属性**
- 基本的にPG・UT工程で定義するため、設計段階では空で定義しておく。
- ローカル表示でname属性の指定が必要なウィジェットが一部存在するため、各ウィジェットのガイドを参照すること。
- 設計時に物理名の設定が難しい場合は項目論理名を指定してよい。PG担当者が実装開始時に物理名へ変換する。

**sample属性**
- sample属性に値を設定するとブラウザ表示時にダミー値が表示される。
- プルダウン・チェックボックス・ラジオボタン・テーブルなどへ複数のダミー値を表示する場合は「`|`」区切りで記載。
- 「`[]`」で囲んだ値が初期選択状態となる。
- sample属性未指定の場合、`codeId`属性・`pattern`属性・`optionColumnName`属性の値をもとに「`js/devtool/resource/コード値定義.js`」から名称が取得される。

**key属性**
- `<column:label>` などのタグで表示するレコードセットのキー名を指定する属性。基本的にPG・UT工程で決定するため設計段階では指定不要。
- > **注意**: key属性未指定かつsample属性が未指定または空文字の場合、別の項目のsample属性値が表示される問題がある。そのようなケースではkey属性に適当な文字列を指定するか、sample属性にスペース文字を指定すること。

**domain属性**
- 画面項目定義を出力するために、項目のドメイン物理名を記載する。
- また、以下のウィジェットではドメイン毎に表示レイアウトを制御するために、HTMLのclass属性にドメイン物理名が出力される。
  - `field:label`
  - `column:label`
  - `column:link`
- デフォルトでは、「`Number`」ドメインが指定されたテーブル内の項目は右寄せで表示される。

**hint属性**
- 指定した文言が項目に対する備考として表示される。

ウィジェットの属性で必須となっている項目でも画面設計段階で決定できない場合は空で定義しておいてよい。

<details>
<summary>keywords</summary>

name属性, sample属性, key属性, domain属性, hint属性, ウィジェット属性, ダミー値表示, コード値定義, column:label, column:link, field:label

</details>

## 画面遷移について

`buttonウィジェット`の`dummyUri`属性: JSPを直接ブラウザで開いた場合にボタンクリックで`dummyUri`属性で指定されたJSPファイルに遷移する（紙芝居用）。

> **注意**: 遷移先リクエストIDを条件によって変化させるなど、実際の遷移を忠実に再現することはできない。不要であれば`dummyUri`属性の指定は不要。実際の遷移はPG・UT工程で実装される。

<details>
<summary>keywords</summary>

dummyUri, 画面遷移, buttonウィジェット, 紙芝居機能

</details>

## ウィジェットの作成について

「住所」「電話番号」「氏名」など典型的で複数画面で利用される項目については、`field:text`ウィジェットの組み合わせで作成したカスタムウィジェット（例: 内線番号ウィジェット）を各PJで作成することを推奨する。

作成方法の詳細はチュートリアルプロジェクトの内線番号ウィジェットの実装を参照。

<details>
<summary>keywords</summary>

カスタムウィジェット作成, field:text, 内線番号ウィジェット, 共通ウィジェット

</details>

## 入力画面と確認画面の共用

`fieldウィジェット`で表示する入力項目は入力画面・確認画面で自動的に切り替わる（入力画面: テキストボックス、確認画面: 表示のみ）。

**確認画面を入力画面と共用する場合の確認画面JSP**:
```jsp
<!DOCTYPE html>
<!-- <%/* --> <script src="js/devtool.js"></script><meta charset="utf-8"><body> <!-- */%> -->
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<n:confirmationPage path="./W11AC0201.jsp" />
```

**入力画面と確認画面で異なる項目を表示する場合**:
- 入力画面でのみ出力する項目は `<n:forInputPage>` で囲む。
- 確認画面でのみ出力する項目は `<n:forConfirmationPage>` で囲む。

<details>
<summary>keywords</summary>

入力画面, 確認画面, n:confirmationPage, n:forInputPage, n:forConfirmationPage, fieldウィジェット自動切替, 画面共用

</details>

## 業務画面JSPの例

業務画面JSPのサンプル:

- [入力画面](#): [W11AC0201.jsp](../../../knowledge/component/ui-framework/assets/ui-framework-create_with_widget/W11AC0201.jsp)
- [確認画面](#): [W11AC0202.jsp](../../../knowledge/component/ui-framework/assets/ui-framework-create_with_widget/W11AC0202.jsp)
- [検索・一覧画面](#): [W11AC0101.jsp](../../../knowledge/component/ui-framework/assets/ui-framework-create_with_widget/W11AC0101.jsp)
- [詳細画面](#): [W11AC0102.jsp](../../../knowledge/component/ui-framework/assets/ui-framework-create_with_widget/W11AC0102.jsp)

<details>
<summary>keywords</summary>

業務画面JSPサンプル, 入力画面サンプル, 確認画面サンプル, 検索一覧画面サンプル, 詳細画面サンプル

</details>
