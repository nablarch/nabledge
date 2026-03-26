# 設計指針

## 業務画面JSPの記述

業務画面JSPでは、画面項目定義書と同じ抽象度のカスタムタグを記述する。各カスタムタグの画面表示方法は**UI標準**で規定され、実装は [../internals/jsp_page_templates](ui-framework-jsp_page_templates.md) と [../internals/jsp_widgets](ui-framework-jsp_widgets.md) が担う。

- [../internals/jsp_page_templates](ui-framework-jsp_page_templates.md): 画面全体構成・ヘッダー・サイドメニュー等の共通領域を描画
- [../internals/jsp_widgets](ui-framework-jsp_widgets.md): ボタン・検索結果テーブル・テキスト入力等の業務画面内UI部品を描画

業務画面JSPの画面表示実装は全て上記2部品を通じて行う。これによりUI標準への準拠が自動的に保証される。

> **注意**: 業務画面JSPに直接記述したHTMLはそのまま描画される。[../internals/jsp_widgets](ui-framework-jsp_widgets.md) として未提供の要素は一旦HTMLで記述し、仕様確定後に共通化できる。

業務画面JSP記述例:

```jsp
<t:page_template
    title="ユーザ情報登録"
    confirmationPageTitle="ユーザ情報登録確認">
  <jsp:attribute name="contentHtml">
  <n:form>
    <field:block title="ユーザ基本情報">
      <field:text title="ログインID" required="true" maxlength="20" hint="半角英数記号20文字以内" sample="test01"></field:text>
      <field:password title="パスワード" required="true" maxlength="20" sample="password"></field:password>
      <field:password title="パスワード（確認用）" required="true" maxlength="20" sample="password"></field:password>
      <field:hint>半角英数記号20文字以内</field:hint>
    </field:block>
    <button:block>
      <button:back label="一覧照会画面へ" size="4"></button:back>
      <button:check uri="/action/ss11AC/W11AC02Action/RW11AC0202"></button:check>
    </button:block>
  </n:form>
  </jsp:attribute>
</t:page_template>
```

業務画面JSPの特性:

1. **ブラウザで直接開くことが可能**: HTMLと同様にブラウザで直接確認できる（詳細: [../internals/inbrowser_jsp_rendering](ui-framework-inbrowser_jsp_rendering.md)）
2. **画面項目一覧の表示とExcel貼り付け**: ローカル表示時に入出力項目をシステム機能設計書/画面項目一覧形式で表示し、コピー&ペーストで設計書へ貼り付け可能
3. **マルチブラウザ・マルチデバイス対応**: UI標準でサポート済み。各デバイスの表示差異は [../internals/jsp_page_templates](ui-framework-jsp_page_templates.md) と [../internals/jsp_widgets](ui-framework-jsp_widgets.md) 側で吸収するため業務画面での対応不要
4. **開発工程以降も流用可能**: 設計工程作成のJSPを最小修正（入力項目のname属性追加等）で開発工程以降も流用可能

<details>
<summary>keywords</summary>

業務画面JSP, UI標準, カスタムタグ, jsp_page_templates, jsp_widgets, ブラウザ直接表示, マルチデバイス対応, inbrowser_jsp_rendering, 画面項目一覧

</details>

## UI標準と共通部品

[../internals/jsp_page_templates](ui-framework-jsp_page_templates.md) および [../internals/jsp_widgets](ui-framework-jsp_widgets.md) の修正には高い技術と知識が必要。PJごとのUI標準カスタマイズを行う場合、その内容に沿った共通部品修正を担当できる人材がPJ遂行上必須となる。

<details>
<summary>keywords</summary>

UI標準カスタマイズ, jsp_page_templates, jsp_widgets, 共通部品修正

</details>
