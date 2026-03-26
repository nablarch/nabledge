# 確認ダイアログ表示イベントアクション

## 概要

[event_confirm](ui-framework-event_confirm.md) は [event_listen](ui-framework-event_listen.md) で定義したイベント発生時に確認ダイアログを表示するイベントアクション。

- **「キャンセル」選択時**: イベントのプロパゲーションおよびデフォルトアクションを抑止。発生元イベントが **change** の場合、変更内容をもとの入力内容に戻す。
- **「OK」選択時**: イベントプロパゲーションを継続し、他のイベントハンドラでキャンセルされなければデフォルトアクションを実行。

> **注意**: ダイアログはブラウザのネイティブ部品を使用するため、表示はクライアント環境・ブラウザに依存し、CSSによる見た目の制御やタイトル文字列の変更はできない。

<details>
<summary>keywords</summary>

確認ダイアログ, イベントアクション, イベントプロパゲーション, キャンセル時の動作, OK時の動作, event_confirm, changeイベント, ブラウザネイティブ部品

</details>

## コードサンプル

プルダウンで特定の項目を選択した場合に確認ダイアログを表示する例:

```jsp
<event:listen event="select.amount change">
  <event:confirm
    message="この商品の注文をキャンセルしますがよろしいですか？"
    condition=":is-blank">
  </event:confirm>
</event:listen>
```

<details>
<summary>keywords</summary>

コードサンプル, event:confirm, event:listen, JSP, セレクタ式, condition, プルダウン確認ダイアログ

</details>

## 仕様（属性値一覧）

属性値の種別: ◎ 必須属性、○ 任意属性、× 無効（指定しても効果なし）

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 処理内容の簡単な説明 | 文字列 | × | × | 設計書表示用 |
| message | ダイアログに表示する文言 | 文字列 | ◎ | ◎ | |
| condition | ダイアログを表示させる条件を表すセレクタ式 | 文字列 | ○ | ○ | 省略した場合は必ず表示される |
| target | condition属性で指定した条件判定の対象となる要素を表すセレクタ式 | 文字列 | ○ | ○ | 省略した場合はイベントが発生した要素 |
| stop | ダイアログキャンセル時にイベントのプロパゲーションおよびデフォルトアクションを抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは'true' |
| revert | ダイアログキャンセル時に各入力値の状態をイベント発生前の状態に戻すかどうか | 真偽値 | ○ | ○ | changeイベント発生時のみ意味をもつ。デフォルトは'true' |

<details>
<summary>keywords</summary>

属性値一覧, title, message, condition, target, stop, revert, 必須属性, 任意属性, セレクタ式

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/confirm.tag | このイベントアクションの実体となるタグファイル |
| /WEB-INF/tags/widget/event/dialog.tag | [event_alert](ui-framework-event_alert.md) と [event_confirm](ui-framework-event_confirm.md) とで共通の内容を実装するタグファイル |
| /js/nablarch/ui/event/ShowDialogAction.js | ダイアログ表示機能を実装するJS部品 |

<details>
<summary>keywords</summary>

部品一覧, confirm.tag, dialog.tag, ShowDialogAction.js, 内部構造, タグファイル

</details>
