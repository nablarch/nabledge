# 入力フォームブロック

## コードサンプル

## コードサンプル

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

field:block, field:text, field:password, 入力フォームブロック, JSP実装例, コードサンプル

</details>

## 仕様

## 仕様

`field:block` は入力フォームの論理的なまとまりを定義し見出しを表示するウィジェットで、HTMLの `<fieldset>` タグに相当する。

`title` 属性に設定されたタイトルの見出しを表示し、ボディ部に記述されたフォームの内容をそのまま出力する。

- 見出しを非表示にするには `showTitle="false"` を指定する
- `collapsible="true"` を指定するとフォーム内容を開閉可能にできる（`showTitle="true"` でなければ無効）
- サーバ動作・ローカル動作で挙動は同一

**属性値一覧**

| プロパティ名 | 内容 | 型 | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | ブロックの見出し文字列 | 文字列 | ○ | ○ | |
| id | htmlのid属性 | 文字列 | ○ | ○ | |
| showTitle | ブロックの見出し文字列を表示するかどうか | 真偽値 | ○ | ○ | デフォルトはtrue |
| collapsible | ブロックを開閉可能とするか | 真偽値 | ○ | ○ | デフォルトはfalse。showTitle="true" でなければ無効 |
| name | ブロックの開閉状態を保持するフォームの入力要素名 | 文字列 | ○ | ○ | collapsible="true" の場合は必須（falseの場合は無効）。同一form内に `n:plainHidden` で書き出すことで状態が保持される |
| value | ブロックが開かれていた場合にサーバ側に送信する値 | 文字列 | ○ | ○ | collapsible="true" の場合は必須（falseの場合は無効） |
| collapsed | 初期表示時にブロックを閉じるかどうか | 真偽値 | ○ | ○ | デフォルトはfalse。collapsible="true" でなければ無効 |

`name` 属性を使って開閉状態を保持する場合は、`field:block` と同一form内に同一name属性を指定した `n:plainHidden` を配置する:

```jsp
<n:form>
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

field:block, fieldset, title, id, showTitle, collapsible, name, value, collapsed, 入力フォームブロック, 見出し表示, 開閉機能, n:plainHidden, 属性値一覧

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/block.tag | field:block の実体となるタグファイル |

<details>
<summary>keywords</summary>

block.tag, タグファイル, 内部構造, 部品一覧, field:block

</details>
