# ボタンウィジェット

## 共通属性

[button_submit](ui-framework-button_submit.md) はUI標準 UI部品 ボタンの内容に準拠したボタンを出力する。

**バリエーション**:
- 戻るボタン(`<button:back>`)
- キャンセルボタン(`<button:cancel>`)
- 確認ボタン(`<button:check>`)
- 確定ボタン(`<button:confirm>`)
- 削除ボタン(`<button:delete>`)
- 検索ボタン(`<button:search>`)
- 更新ボタン(`<button:update>`)
- 汎用ボタン(`<button:submit>`)
- ダウンロードボタン(`<button:download>`)
- ポップアップボタン(`<button:popup>`)
- 閉じるボタン(`<button:close>`)

**コードサンプル（ローカル動作）**:
```jsp
<button:back uri="" dummyUri="./W11AC0101.jsp" label="検索画面へ"></button:back>
<button:submit uri="" dummyUri="./W11AB0101.jsp" label="ログイン"></button:submit>
<button:popup uri="" popupWindowName="W99ZZ6101" label="ポップアップ"></button:popup>
```

**コードサンプル（サーバ動作）**:
```jsp
<button:back uri="/action/ss11AC/W11AC01Action/RW11AC0101" label="検索画面へ"></button:back>
<button:submit uri="/action/ss11AA/W11AA01Action/RW11AA0102" label="ログイン"></button:submit>
<button:popup uri="/action/ss99ZZ/W99ZZ61Action/RW99ZZ6102" popupWindowName="W99ZZ6101" label="ポップアップ"></button:popup>
```

ローカル動作時はボタンクリックで`dummyUri`指定のJSPファイルに遷移する。

**共通属性** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ | |
| label | ボタンの文言 | 文字列 | ◎ | ◎ | |
| uri | 遷移先のuri | 文字列 | ◎ | × | `<button:close>`は指定不可 |
| disabled | 入力値の送信抑制 | 真偽値 | ○ | ○ | デフォルト: `false` |
| size | ボタンの表示サイズ（Grid数） | 数値 | ○ | ○ | デフォルト: `3`（`<button:download>`のみ`5`） |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| dummyUri | ローカル動作時の遷移先 | 文字列 | × | ○ | `<button:close>`は指定不可 |
| comment | ボタン押下時のイベント概要 | 文字列 | × | × | 画面項目定義のイベント一覧の画面イベント概要に表示（実行時効果なし） |

`label`未指定時のデフォルトラベル: 戻るボタン→「戻る」、キャンセルボタン→「キャンセル」、確認ボタン→「確認」、確定ボタン→「確定」、削除ボタン→「削除」、検索ボタン→「検索」、更新ボタン→「更新」、閉じるボタン→「閉じる」。任意の値にしたい場合は`label`を明示的に指定すること。

<details>
<summary>keywords</summary>

ボタンウィジェット, 共通属性, button:back, button:submit, button:popup, button:close, button:download, button:check, button:confirm, button:cancel, button:delete, button:search, button:update, dummyUri, uri, label, disabled, size, cssClass, comment, id, ローカル動作

</details>

## 共通属性(ポップアップを除く)

**共通属性(ポップアップを除く)** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| allowDoubleSubmission | 二重サブミットを許容するか否か | 真偽値 | ○ | × | デフォルト: `true`（許容する）。`<button:confirm>`のみデフォルト`false`（許容しない） |

<details>
<summary>keywords</summary>

allowDoubleSubmission, 二重サブミット防止, 二重サブミット許容, button:confirm, ポップアップ以外共通属性

</details>

## ポップアップ・汎用ボタンのみの属性

**ポップアップ・汎用ボタンのみの属性** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| icon | ボタンに表示するアイコン | 文字列 | ○ | ○ | iconのあるボタンとの高さは必要に応じて調整すること |

<details>
<summary>keywords</summary>

icon, アイコン表示, ポップアップボタン, 汎用ボタン, button:popup, button:submit

</details>

## ポップアップボタンのみの属性

**ポップアップボタンのみの属性** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| popupWindowName | ウィンドウ名 | 文字列 | ○ | ○ | デフォルト: `subwindow` |
| popupOption | ウィンドウを開く際のオプション | 文字列 | ○ | ○ | |

`popupWindowName`を明示しない場合、1つの画面から開けるポップアップは1つに固定される（複数回開いた場合、既存ウィンドウの内容のみ更新）。複数のサブウィンドウを開く場合はそれぞれ個別のウィンドウ名を設定すること。

<details>
<summary>keywords</summary>

popupWindowName, popupOption, ポップアップウィンドウ, サブウィンドウ, 複数ポップアップ, button:popup

</details>

## 特定ボタン固有の属性

**特定ボタン固有の属性** [× 無効(指定しても効果なし)]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| lockTarget | 排他制御対象となるテーブル名を指定する | 文字列 | × | × | 画面項目定義のイベント一覧で排他制御対象に表示される（実行時効果なし） |

`lockTarget`属性が指定可能なボタンタグ: 確認ボタン、確定ボタン、更新ボタン、削除ボタン、汎用ボタン、検索ボタン、ダウンロードボタン、ポップアップボタン

<details>
<summary>keywords</summary>

lockTarget, 排他制御, テーブル名指定, button:confirm, button:delete, button:update, button:search, button:submit, button:download, button:popup, 特定ボタン固有

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/button/*.tag` | [button_submit](ui-framework-button_submit.md) |
| `/js/jsp/taglib/nablarch.js` | ボタンウィジェットが使用する以下タグのエミュレーション機能を実装するタグライブラリスタブJS: `n:button`、`n:popupButton`、`n:downloadButton` |
| `/css/style/base.less` | 基本HTML要素のスタイル定義。ボタンに関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

内部構造, 改修, タグファイル, /WEB-INF/tags/widget/button, nablarch.js, タグライブラリスタブ, n:button, n:popupButton, n:downloadButton, base.less, ボタンスタイル定義

</details>
