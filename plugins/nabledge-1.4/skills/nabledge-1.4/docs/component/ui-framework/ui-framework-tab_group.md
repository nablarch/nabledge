# タブウィジェット

## <tab:group>

[tab_group](ui-framework-tab_group.md) はUI標準 UI部品 タブの内容に準拠したタブ表示用UI部品。2種類のバリエーション:
- `<tab:content>`: クライアントサイドでのタブ切り替えタイプ
- `<tab:link>`: サーバにリクエストを送信するタイプ

**`<tab:group>` 属性** [◎ 必須, ○ 任意, × 無効]

| 属性名 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|
| name | 文字列 | ◎ | × | タブグループ名。ページ内で一意となる値を指定する |

**コードサンプル（サーバ動作）**

```jsp
<tab:group name="tab">
  <tab:content title="ユーザ基本情報" selected="true" value="tab_baseinfo">
    <field:text title="ログインID" domain="ログインID" required="true" maxlength="20"
                hint="半角英数記号20文字以内" name="formdata.loginId" sample="test01">
    </field:text>
  </tab:content>
  <tab:link title="パスワード変更" uri="/action/ss99ZZ/W99ZZ61Action/RW99ZZ6104">
  </tab:link>
</tab:group>
```

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/tab/*.tag | [tab_group](ui-framework-tab_group.md) |
| /js/jsp/taglib/nablarch.js | タブウィジェットが使用するn:submitLinkのエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | タブに関するスタイル定義を含む基本HTMLの要素スタイル定義 |

<details>
<summary>keywords</summary>

tab:group, タブウィジェット, タブグループ, name属性, タブ切り替え, tab:content, tab:link

</details>

## <tab:content>

**`<tab:content>` 属性** [◎ 必須, ○ 任意, × 無効]

| 属性名 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|
| title | 文字列 | ◎ | ◎ | タブに表示する見出し |
| value | 文字列 | ◎ | × | タブの識別名。tabグループ内で一意となる値を指定する |
| selected | 真偽値 | ○ | ○ | タブの初期選択状態。tabグループ内で初期選択状態とするcontentに'true'を設定する |
| cssClass | 文字列 | ○ | ○ | HTMLのclass属性値 |

<details>
<summary>keywords</summary>

tab:content, title, value, selected, cssClass, クライアントサイドタブ切り替え, タブ初期選択

</details>

## <tab:link>

> **注意**: ローカル動作時、`<tab:link>`タブクリック時はdummyUriで指定されたJSPファイルに遷移する。

**`<tab:link>` 属性** [◎ 必須, ○ 任意, × 無効]

| 属性名 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|
| id | 文字列 | ○ | ○ | htmlのid属性 |
| title | 文字列 | ◎ | ◎ | タブに表示する見出し |
| uri | 文字列 | ◎ | × | 遷移先のuri |
| cssClass | 文字列 | ○ | ○ | HTMLのclass属性値 |
| allowDoubleSubmission | 真偽値 | ○ | × | 二重サブミットを許容するか否か。デフォルト: true（許容する） |
| dummyUri | 文字列 | × | ○ | ローカル動作時の遷移先 |

<details>
<summary>keywords</summary>

tab:link, allowDoubleSubmission, dummyUri, uri, サーバリクエストタブ, ローカル動作, 二重サブミット

</details>
