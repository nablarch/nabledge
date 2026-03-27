# アラートダイアログ表示イベントアクション

## コードサンプル

## コードサンプル

[event_listen](ui-framework-event_listen.md) で定義したイベント発生時にアラートダイアログを表示するイベントアクション。

動作の特性:
- ダイアログ表示時、イベントのプロパゲーションおよびデフォルトアクションの発生を抑止する
- 発生元イベントが **change** イベントの場合、変更内容をもとの入力内容に戻す
- ダイアログはブラウザのネイティブ部品を使用するため、CSSによる見た目の制御やタイトル・ボタンに表示される文字列の変更はできない

コード例（特定のチェックボックスにチェックが入っていない場合にダイアログを表示）:

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

アラートダイアログ, イベントアクション, event:alert, event:listen, changeイベント, ブラウザネイティブダイアログ, プロパゲーション抑止

</details>

## 仕様（属性値一覧）

## 仕様（属性値一覧）

凡例: ◎ 必須属性 / ○ 任意属性 / × 無効（指定しても効果なし）

| 属性名 | タイプ | サーバ | ローカル | 説明 | 備考 |
|---|---|---|---|---|---|
| title | 文字列 | × | × | 処理内容の簡単な説明 | 設計書表示用 |
| message | 文字列 | ◎ | ◎ | ダイアログに表示する文言 | |
| condition | 文字列 | ○ | ○ | ダイアログを表示させる条件を表すセレクタ式 | 省略した場合は必ず表示される |
| target | 文字列 | ○ | ○ | condition属性で指定した条件判定の対象となる要素を表すセレクタ式 | 省略した場合はイベントが発生した要素 |
| stop | 真偽値 | ○ | ○ | ダイアログ表示後にイベントのプロパゲーションおよびデフォルトアクションを抑制するかどうか | デフォルトは `true` |
| revert | 真偽値 | ○ | ○ | ダイアログ表示後に各入力値の状態をイベント発生前の状態に戻すかどうか | changeイベント発生時のみ意味をもつ。デフォルトは `true` |

<details>
<summary>keywords</summary>

title, message, condition, target, stop, revert, 属性一覧, セレクタ式, 必須属性, デフォルト値

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/alert.tag | このイベントアクションの実体となるタグファイル |
| /WEB-INF/tags/widget/event/dialog.tag | [event_alert](ui-framework-event_alert.md) と [event_confirm](ui-framework-event_confirm.md) とで共通の内容を実装するタグファイル |
| /js/nablarch/ui/event/ShowDialogAction.js | ダイアログ表示機能を実装するJS部品 |

<details>
<summary>keywords</summary>

alert.tag, dialog.tag, ShowDialogAction.js, タグファイル, JS部品, 部品一覧

</details>
