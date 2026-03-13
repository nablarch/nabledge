# タブウィジェット

**公式ドキュメント**: [タブウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/tab_group.html)

## <tab:group>

タブ表示用UI部品 [tab_group](testing-framework-tab_group.md) のバリエーション:
- クライアントサイドでのタブ切り替えタイプ: `<tab:content>`
- サーバにリクエストを送信するタイプ: `<tab:link>`

コードサンプル（サーバ動作）:

```jsp
<tab:group name="tab">
  <%-- クライアントサイドで切り替えを行うタブ --%>
  <tab:content
    title="ユーザ基本情報"
    selected="true"
    value="tab_baseinfo">
    <field:text title="ログインID"
                domain="ログインID"
                required="true"
                maxlength="20"
                hint="半角英数記号20文字以内"
                name="formdata.loginId"
                sample="test01">
    </field:text>
  </tab:content>
  <%-- サーバサイドにリクエストを送信するタブ --%>
  <tab:link
      title="パスワード変更"
      uri="/action/ss99ZZ/W99ZZ61Action/RW99ZZ6104">
  </tab:link>
</tab:group>
```

`<tab:group>` 属性（◎ 必須 ○ 任意 × 無効）:

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| name | タブグループ名 | 文字列 | ◎ | × | ページ内で一意 |

部品一覧:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/tab/*.tag | tab_group |
| /js/jsp/taglib/nablarch.js | n:submitLinkのエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | タブのスタイル定義を含む基本スタイル |

<details>
<summary>keywords</summary>

tab:group, タブウィジェット, タブグループ, name属性, タブ切り替え, 部品一覧, nablarch.js

</details>

## <tab:content>

`<tab:content>` 属性（◎ 必須 ○ 任意 × 無効）:

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | タブに表示する見出し | 文字列 | ◎ | ◎ | |
| value | タブの識別名 | 文字列 | ◎ | × | tabグループ内で一意 |
| selected | タブの初期選択状態 | 真偽値 | ○ | ○ | 初期選択にするcontentに'true'を設定 |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |

<details>
<summary>keywords</summary>

tab:content, クライアントサイドタブ切り替え, title, selected, value, タブ初期選択, cssClass

</details>

## <tab:link>

> **注意**: ローカル動作時、サーバサイドにリクエストを送信するタイプのタブはタブクリック時にdummyUriで指定されたJSPファイルに遷移する。

`<tab:link>` 属性（◎ 必須 ○ 任意 × 無効）:

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ | |
| title | タブに表示する見出し | 文字列 | ◎ | ◎ | |
| uri | 遷移先のuri | 文字列 | ◎ | × | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| allowDoubleSubmission | 二重サブミットを許容するか否か | 真偽値 | ○ | × | デフォルトは'true'（許容する） |
| dummyUri | ローカル動作時の遷移先 | 文字列 | × | ○ | |

<details>
<summary>keywords</summary>

tab:link, id, title, uri, cssClass, dummyUri, allowDoubleSubmission, サーバリクエスト送信タブ, ローカル動作, 二重サブミット

</details>
