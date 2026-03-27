# 画面レイアウト定義用ウィジェット

## 画面レイアウト定義用ウィジェット

業務画面内の各UI要素の論理的なグループ(レイアウト)を設計情報として記述するための部品。

> **注意**: この部品はJSPのサーバ表示の内容には一切影響しないため、実装工程以降も削除する必要はない。

**コードサンプル**

```jsp
<spec:layout name="検索条件入力欄">
<n:form windowScopePrefixes="11AC_W11AC01">
  <field:block title="検索条件" id="search_condition">
    <field:text title="ログインID" domain="USER_ID" maxlength="20" name="11AC_W11AC01.loginId" comment="コメントです。"></field:text>
    <field:text title="漢字氏名" domain="KANJI_NAME" maxlength="20" name="11AC_W11AC01.kanjiName"></field:text>
</n:form>
</spec:layout>
```

**ローカル動作時の挙動**: 通常はタグの内容をそのまま表示する。URLにクエリパラメータ `nablarch_spec_layout` が含まれる場合、レイアウト名がその値に含まれているものは非表示となる。

**設計書ビュー上の表示**:
1. 「画面レイアウト」欄に各レイアウトの表示・非表示を切り替えるリンクを表示する（[spec_condition](ui-framework-spec_condition.md) 参照）。
2. 「画面項目定義」欄にレイアウト内の各項目をグルーピングする見出しを表示する。

**属性値一覧** (◎ 必須属性、× 無効)

| 名称 | 内容 | タイプ | サーバ | ローカル |
|---|---|---|---|---|
| name | レイアウト名 | 文字列 | × | ◎ |

<details>
<summary>keywords</summary>

spec:layout, 画面レイアウト定義, ローカル動作, 設計書ビュー, nablarch_spec_layout, 画面項目定義, レイアウト非表示, name属性

</details>

## 内部構造・改修時の留意点

サーバ表示で動作するタグファイル(`layout.tag`)は、JSPコンパイルを通すためだけの、ほぼ中身のないダミーである（`<jsp:doBody>` のみを記述）。

設計書ビューはテンプレートファイルである `SpecSheetTemplate.xlsx` と、各項目の表示内容を制御する `SpecSheetInterpreter.js` によって構成される。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/layout.tag | spec:layout のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（上記ファイルをHTML形式で保存したもの） |

<details>
<summary>keywords</summary>

layout.tag, ダミー, jsp:doBody, SpecSheetTemplate.xlsx, SpecSheetInterpreter.js, 設計書ビュー, 内部構造, タグファイル

</details>
