# リンクウィジェット

## 共通属性

[link_submit](ui-framework-link_submit.md) はUI標準 UI部品 リンクの内容に準拠したリンクを出力する。

バリエーション:
- 汎用リンク `<link:submit>`
- ポップアップリンク `<link:popup>`

**ローカル動作時の挙動**: リンクをクリック時、dummyUriで指定されたJSPファイルに遷移する。

コードサンプル（ローカル動作）:
```jsp
<%-- 汎用リンクの場合 --%>
<link:submit
    uri=""
    label="ユーザ情報一覧照会"
    dummyUri="./W11AC0101.jsp">
</link:submit>

<%-- ポップアップリンクの場合 --%>
<link:popup
    uri=""
    label="ポップアップリンク"
    dummyUri="./index.jsp">
</link:popup>
```

コードサンプル（サーバ動作）:
```jsp
<%-- 汎用リンクの場合 --%>
<link:submit
    uri="/action/ss11AC/W11AC01Action/RW11AC0101"
    label="ユーザ情報一覧照会">
</link:submit>

<%-- ポップアップリンクの場合 --%>
<link:popup
    uri="/action/ss99ZZ/W99ZZ61Action/RW99ZZ6102"
    popupWindowName="W99ZZ6101"
    label="ポップアップリンク">
</link:popup>
```

共通属性 [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]:

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ | |
| label | リンクの文言 | 文字列 | ◎ | ◎ | |
| uri | リンク先のuri | 文字列 | ◎ | × | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| dummyUri | ローカル動作時の遷移先 | 文字列 | × | ○ | |
| comment | リンククリック時のイベント概要 | 文字列 | × | × | 設計書の表示時に、画面イベント一覧の「画面イベント概要」に表示される |

<details>
<summary>keywords</summary>

link:submit, link:popup, リンクウィジェット, 共通属性, id, comment, label, uri, dummyUri, cssClass, ローカル動作, コードサンプル

</details>

## 汎用リンクのみの属性

汎用リンク（`<link:submit>`）のみの属性 [◎ 必須属性 ○ 任意属性 × 無効]:

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| allowDoubleSubmission | 二重サブミットを許容するか否か | 真偽値 | ○ | × | デフォルトは `true`（許容する） |

<details>
<summary>keywords</summary>

link:submit, 汎用リンク, allowDoubleSubmission, 二重サブミット

</details>

## ポップアップリンクのみの属性

ポップアップリンク（`<link:popup>`）のみの属性 [◎ 必須属性 ○ 任意属性 × 無効]:

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| popupWindowName | ウィンドウ名 | 文字列 | ○ | ○ | デフォルトは `subwindow` |
| popupOption | ウィンドウを開く際のオプション | 文字列 | ○ | ○ | |

> **注意**: popupWindowNameを明示的に指定しない場合、1つの画面から開かれるポップアップウィンドウは1つに固定される。複数回ポップアップを開いた場合、以前のウィンドウが開いたままであれば新たなウィンドウは開かず既存ウィンドウの内容のみ更新される。複数のサブウィンドウを開きたい場合は、それぞれ個別のウィンドウ名を設定すること。

<details>
<summary>keywords</summary>

link:popup, ポップアップリンク, popupWindowName, popupOption, サブウィンドウ, ウィンドウ名

</details>
