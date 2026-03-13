# 入力フォームブロック

**公式ドキュメント**: [入力フォームブロック](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_block.html)

## コードサンプル

**実装例 (JSP)**

```jsp
<field:block
  title="ユーザ基本情報"
  id="user">

  <field:text title="ログインID"
              domain="ログインID"
              required="true"
              maxlength="20"
              hint="半角英数記号20文字以内"
              name="W11AC02.systemAccount.loginId"
              sample="test01">
  </field:text>
  <field:password title="パスワード"
                  domain="パスワード"
                  required="true"
                  maxlength="20"
                  name="W11AC02.newPassword"
                  sample="password">
  </field:password>
</field:block>
```

<details>
<summary>keywords</summary>

field:block, field:text, field:password, 入力フォームブロック実装例, JSPウィジェット

</details>

## 仕様

`field:block` は入力フォームの論理的なまとまりを定義し、見出しを表示するウィジェット（HTML の `<fieldset>` タグに相当する）。`title` 属性に設定された見出しを表示し、ボディ部に記述されたフォーム内容をそのまま出力する。見出しを非表示にするには `showTitle="false"` を指定する。`collapsible` 属性を指定するとフォーム内容を開閉可能にできる。サーバ動作・ローカル動作で挙動は同一。

**属性値一覧** (○: 任意属性)

| 名称 | 内容 | タイプ | デフォルト値 | 備考 |
|---|---|---|---|---|
| title | ブロックの見出し文字列 | 文字列 | | |
| id | htmlのid属性 | 文字列 | | |
| showTitle | ブロックの見出しを表示するか | 真偽値 | true | |
| collapsible | ブロックを開閉可能とするか | 真偽値 | false | showTitle="true" でなければ無効 |
| name | ブロックの開閉状態を保持するフォームの入力要素名 | 文字列 | | collapsible="true" の場合は必須 (false の場合は無効)。同一 form 内に n:plainHidden で同名の name 属性を出力することで状態が保持される |
| value | ブロックが開かれていた場合にサーバ側に送信する値 | 文字列 | | collapsible="true" の場合は必須 (false の場合は無効) |
| collapsed | 初期表示時にブロックを閉じるか | 真偽値 | false | collapsible="true" でなければ無効 |

**collapsible 使用時の name 属性設定例:**

```jsp
<n:form>

  <%-- field:block と同一 form 内に field:block の name 属性と同一の name 属性を指定した n:plainHidden を出力する --%>

  <n:plainHidden name="block_status" />
  <field:block
    title="ユーザ基本情報"
    collapsible="true"
    name="block_status"
    value="basic_info"
    collapsed="true">
  </field:block>

</n:form>
```

<details>
<summary>keywords</summary>

field:block, title, showTitle, collapsible, name, value, collapsed, n:plainHidden, 見出し表示制御, 開閉可能フォームブロック, 入力フォームブロック属性一覧, fieldset, HTMLタグ相当

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/block.tag | [field_block](testing-framework-field_block.md) の実体となるタグファイル |

<details>
<summary>keywords</summary>

block.tag, field:blockタグファイル, /WEB-INF/tags/widget/field/block.tag, ウィジェット実装ファイル

</details>
