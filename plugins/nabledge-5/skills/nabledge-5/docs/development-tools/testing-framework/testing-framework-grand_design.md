# 設計指針

**公式ドキュメント**: [設計指針](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/introduction/grand_design.html)

## 業務画面JSPの記述

業務画面JSPには画面の見た目に関する情報を含めず、画面項目定義書と同じ抽象度のカスタムタグで記述する。

**UI標準**: 各カスタムタグがどのように画面上に表示されるかを規定する標準。

- [../internals/jsp_page_templates](testing-framework-jsp_page_templates.md): 画面の全体構成および画面間で共通のヘッダ・サイドメニューなどの領域を描画するUI部品
- [../internals/jsp_widgets](testing-framework-jsp_widgets.md): 各業務画面中で使用するボタン、検索結果テーブル、テキスト入力などを描画するUI部品

業務画面JSPでは画面表示に関する実装は全て [../internals/jsp_page_templates](testing-framework-jsp_page_templates.md) と [../internals/jsp_widgets](testing-framework-jsp_widgets.md) を通じて行う。これにより各画面の開発者がUI標準を意識しなくてもUI標準に準拠した画面表示となることが保証される。

> **注意**: 業務画面JSPに直接記述したHTMLはそのまま画面上に描画される。 [../internals/jsp_widgets](testing-framework-jsp_widgets.md) として提供されていない画面要素がある場合は、一旦HTMLとして記述し仕様が固まった後で共通化することが可能。

業務画面JSP記述例:

```jsp
<t:page_template
    title="ユーザ情報登録"
    confirmationPageTitle="ユーザ情報登録確認">
  <jsp:attribute name="contentHtml">
  <n:form>
    <field:block title="ユーザ基本情報">
      <field:text title="ログインID"
                  required="true"
                  maxlength="20"
                  hint="半角英数記号20文字以内"
                  sample="test01">
      </field:text>
      <field:password title="パスワード"
                      required="true"
                      maxlength="20"
                      sample="password">
      </field:password>
      <field:password title="パスワード（確認用）"
                      required="true"
                      maxlength="20"
                      sample="password">
      </field:password>
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

1. **ブラウザで直接開くことが可能**: サーバ環境なしにブラウザで直接確認可能。詳細は [../internals/inbrowser_jsp_rendering](testing-framework-inbrowser_jsp_rendering.md) を参照。
2. **画面項目一覧をExcel設計書に貼り込み可能**: ローカル表示時に入出力項目をシステム機能設計書/画面項目一覧の書式で表示し、コピー&ペーストで設計書に貼り込み可能。
3. **マルチブラウザ・マルチデバイス対応**: UI標準がマルチブラウザ・マルチデバイスをサポートし、各デバイスの表示差分は [../internals/jsp_page_templates](testing-framework-jsp_page_templates.md) と [../internals/jsp_widgets](testing-framework-jsp_widgets.md) が吸収するため、各業務画面での個別対応は不要。
4. **開発工程以降も流用可能**: 設計工程で作成したJSPファイルは、name属性追加などの最小限の修正で開発工程以降もそのまま流用可能。

<details>
<summary>keywords</summary>

業務画面JSP, カスタムタグ, UI標準, jsp_page_templates, jsp_widgets, ブラウザ直接表示, マルチブラウザ対応, 画面項目一覧Excel出力, 開発工程流用, field:hint, field:password, t:page_template, field:block, field:text, button:back, button:check, button:block, n:form

</details>

## UI標準と共通部品

[../internals/jsp_page_templates](testing-framework-jsp_page_templates.md) および [../internals/jsp_widgets](testing-framework-jsp_widgets.md) の修正には高い技術と知識が必要。PJごとの要求に沿ってUI標準のカスタマイズを行う場合、その内容に沿って共通部品を修正する担当者の存在はPJを進める上で必須。

<details>
<summary>keywords</summary>

UI標準カスタマイズ, 共通部品修正, jsp_page_templates, jsp_widgets, PJ担当者必須

</details>
