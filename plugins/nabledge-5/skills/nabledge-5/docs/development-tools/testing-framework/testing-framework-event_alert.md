# アラートダイアログ表示イベントアクション

**公式ドキュメント**: [アラートダイアログ表示イベントアクション](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_alert.html)

## 概要

[event_alert](testing-framework-event_alert.md) は [event_listen](testing-framework-event_listen.md) で定義したイベントが発生した際に、アラートダイアログを表示させるイベントアクション。

- ダイアログ表示時: イベントのプロパゲーションおよびデフォルトアクションを抑止する
- **change** イベントが発生元の場合: 変更内容をもとの入力内容に戻す
- ダイアログはブラウザのネイティブ部品を使用するため、CSSによる見た目の制御やタイトル・ボタンに表示される文字列の変更は不可

<details>
<summary>keywords</summary>

event:alert, event:listen, アラートダイアログ, イベントプロパゲーション抑止, changeイベント入力値リセット, ブラウザネイティブダイアログ

</details>

## コードサンプル

特定のチェックボックスにチェックが入っていない場合にダイアログを表示する例:

```jsp
<event:listen event='button.submit click'>
  <event:alert
    title="契約内容確認チェック"
    message="ご契約内容を確認の上 「契約内容に同意する」をチェックしてください。"
    condition="input.confirmation:checked">
  </event:alert>
</event:listen>
```

<details>
<summary>keywords</summary>

event:alert, event:listen, condition, チェックボックス条件ダイアログ表示, JSPコード例

</details>

## 仕様（属性値一覧）

属性値の必須/任意は「サーバ」「ローカル」列で示す（◎ 必須、○ 任意、× 無効）。

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 処理内容の簡単な説明 | 文字列 | × | × | 設計書表示用 |
| message | ダイアログに表示する文言 | 文字列 | ◎ | ◎ | |
| condition | ダイアログを表示させる条件を表すセレクタ式 | 文字列 | ○ | ○ | 省略した場合は必ず表示される |
| target | condition属性で指定した条件判定の対象となる要素を表すセレクタ式 | 文字列 | ○ | ○ | 省略した場合はイベントが発生した要素 |
| stop | ダイアログ表示後にイベントのプロパゲーションおよびデフォルトアクションを抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: `true` |
| revert | ダイアログ表示後に各入力値の状態をイベント発生前の状態に戻すかどうか | 真偽値 | ○ | ○ | changeイベント発生時のみ有効。デフォルト: `true` |

<details>
<summary>keywords</summary>

title, message, condition, target, stop, revert, アラートダイアログ属性, セレクタ式, 必須属性, デフォルト値

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/event/alert.tag` | このイベントアクションの実体となるタグファイル |
| `/WEB-INF/tags/widget/event/dialog.tag` | [event_alert](testing-framework-event_alert.md) と [event_confirm](testing-framework-event_confirm.md) とで共通の内容を実装するタグファイル |
| `/js/nablarch/ui/event/ShowDialogAction.js` | ダイアログ表示機能を実装するJS部品 |

<details>
<summary>keywords</summary>

alert.tag, dialog.tag, ShowDialogAction.js, イベントアクション実装部品, event:confirm

</details>
