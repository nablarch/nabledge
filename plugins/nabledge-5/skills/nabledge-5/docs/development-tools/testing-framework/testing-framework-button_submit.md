# ボタンウィジェット

**公式ドキュメント**: [ボタンウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/button_submit.html)

## 共通属性

## ボタンウィジェット概要

利用可能なボタンバリエーション（必要に応じて使い分けること）:

- 戻るボタン `<button:back>`
- キャンセルボタン `<button:cancel>`
- 確認ボタン `<button:check>`
- 確定ボタン `<button:confirm>`
- 削除ボタン `<button:delete>`
- 検索ボタン `<button:search>`
- 更新ボタン `<button:update>`
- 汎用ボタン `<button:submit>`
- ダウンロードボタン `<button:download>`
- ポップアップボタン `<button:popup>`
- 閉じるボタン `<button:close>`

**ローカル動作**: ボタンクリック時、`dummyUri`で指定されたJSPファイルに遷移する。

**コードサンプル（ローカル動作）**:
```jsp
<%-- 戻るボタン --%>
<button:back uri="" dummyUri="./W11AC0101.jsp" label="検索画面へ"></button:back>

<%-- 汎用ボタン --%>
<button:submit uri="" dummyUri="./W11AB0101.jsp" label="ログイン"></button:submit>

<%-- ポップアップボタン --%>
<button:popup uri="" popupWindowName="W99ZZ6101" label="ポップアップ"></button:popup>
```

**コードサンプル（サーバ動作）**:
```jsp
<%-- 戻るボタン --%>
<button:back uri="/action/ss11AC/W11AC01Action/RW11AC0101" label="検索画面へ"></button:back>

<%-- 汎用ボタン --%>
<button:submit uri="/action/ss11AA/W11AA01Action/RW11AA0102" label="ログイン"></button:submit>

<%-- ポップアップボタン --%>
<button:popup uri="/action/ss99ZZ/W99ZZ61Action/RW99ZZ6102" popupWindowName="W99ZZ6101" label="ポップアップ"></button:popup>
```

## 共通属性

◎=必須 ○=任意 ×=無効

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | HTMLのid属性 | 文字列 | ○ | ○ | |
| label | ボタンの文言 | 文字列 | ◎ | ◎ | デフォルト値あり（下記参照） |
| uri | 遷移先のURI | 文字列 | ◎ | × | `<button:close>`は指定不可 |
| disabled | 入力値送信抑制 | 真偽値 | ○ | ○ | デフォルト: `false` |
| size | 表示サイズ（Grid数） | 数値 | ○ | ○ | デフォルト: `3`（`<button:download>`のみ`5`） |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| dummyUri | ローカル動作時の遷移先 | 文字列 | × | ○ | `<button:close>`は指定不可 |
| comment | ボタン押下時のイベント概要 | 文字列 | × | × | 画面項目定義のイベント一覧で、画面イベント概要に表示される |

**labelのデフォルト値**: `label`未指定時に以下のデフォルト値が使用される。任意の値を使う場合は明示的に`label`を指定すること。

- 戻るボタン → 「戻る」
- キャンセルボタン → 「キャンセル」
- 確認ボタン → 「確認」
- 確定ボタン → 「確定」
- 削除ボタン → 「削除」
- 検索ボタン → 「検索」
- 更新ボタン → 「更新」
- 閉じるボタン → 「閉じる」

<details>
<summary>keywords</summary>

button:back, button:cancel, button:check, button:confirm, button:delete, button:search, button:update, button:submit, button:download, button:popup, button:close, label, uri, disabled, size, cssClass, dummyUri, comment, ボタンウィジェット, 共通属性, ローカル動作, labelデフォルト値

</details>

## 共通属性(ポップアップを除く)

## 共通属性（ポップアップを除く）

◎=必須 ○=任意 ×=無効

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| allowDoubleSubmission | 二重サブミットを許容するか否か | 真偽値 | ○ | × | デフォルト: `true`（`<button:confirm>`のみデフォルト`false`） |

<details>
<summary>keywords</summary>

allowDoubleSubmission, 二重サブミット防止, button:confirm, ポップアップ除く共通属性

</details>

## ポップアップ・汎用ボタンのみの属性

## ポップアップ・汎用ボタンのみの属性

◎=必須 ○=任意 ×=無効

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| icon | ボタンに表示するアイコン | 文字列 | ○ | ○ | iconのあるボタンとの高さは必要に応じて調整すること |

対象: `<button:popup>`、`<button:submit>`（汎用ボタン）

<details>
<summary>keywords</summary>

icon, ポップアップボタン, 汎用ボタン, アイコン表示, button:popup, button:submit

</details>

## ポップアップボタンのみの属性

## ポップアップボタンのみの属性

◎=必須 ○=任意 ×=無効

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| popupWindowName | ウィンドウ名 | 文字列 | ○ | ○ | デフォルト: `subwindow` |
| popupOption | ウィンドウを開く際のオプション | 文字列 | ○ | ○ | |

**popupWindowNameの動作**: 明示的にウィンドウ名を指定しない場合、1つの画面から開かれるポップアップウィンドウは1つに固定される（複数回開いても既存ウィンドウを再利用）。複数のサブウィンドウを開く場合は、それぞれ個別のウィンドウ名を設定すること。

<details>
<summary>keywords</summary>

popupWindowName, popupOption, ポップアップウィンドウ, サブウィンドウ, 複数ポップアップ, button:popup

</details>

## 特定ボタン固有の属性

## 特定ボタン固有の属性

◎=必須 ○=任意 ×=無効

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| lockTarget | 排他制御対象となるテーブル名 | 文字列 | × | × | 画面項目定義のイベント一覧の排他制御対象に表示 |

**lockTarget指定可能なボタン**:
- 確認ボタン (`<button:check>`)
- 確定ボタン (`<button:confirm>`)
- 更新ボタン (`<button:update>`)
- 削除ボタン (`<button:delete>`)
- 汎用ボタン (`<button:submit>`)
- 検索ボタン (`<button:search>`)
- ダウンロードボタン (`<button:download>`)
- ポップアップボタン (`<button:popup>`)

## 内部構造（部品一覧）

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/button/*.tag` | ボタンウィジェット本体 |
| `/js/jsp/taglib/nablarch.js` | ボタンウィジェットが使用するタグのエミュレーション（`n:button`、`n:popupButton`、`n:downloadButton`） |
| `/css/style/base.less` | 基本HTMLスタイル定義（ボタンのスタイル定義を含む） |

<details>
<summary>keywords</summary>

lockTarget, 排他制御, ボタンウィジェット部品, nablarch.js, button:confirm, button:delete, button:check, button:update, button:search, button:download, button:popup, button:submit

</details>
