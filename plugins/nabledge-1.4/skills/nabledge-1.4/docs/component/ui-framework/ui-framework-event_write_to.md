# 項目内容変更イベントアクション

## コードサンプル

[event_write_to](ui-framework-event_write_to.md) は [event_listen](ui-framework-event_listen.md) 及び [event_listen_subwindow](ui-framework-event_listen_subwindow.md) が監視するイベントが発生した際に、特定の要素の内容（表示文字列もしくは入力値）を動的に書き換えるイベントアクション。

```jsp
<event:listen
  title = "Ajaxリクエスト成功時の処理"
  event = "ajaxSuccess">
  <event:write_to
    title     = "レスポンスボディのテーブル中のユーザIDの値を入力欄に設定する。"
    target    = "input.user_id"
    condition = ":has(tr td)"
    format    = "{td.user_id:first}">
  </event:write_to>
</event:listen>
```

<details>
<summary>keywords</summary>

event:write_to, event:listen, AjaxレスポンスのDOM書き換え, 項目内容変更, イベントアクション

</details>

## 仕様

このアクションを実行するイベントは [event_listen](ui-framework-event_listen.md)（もしくは [event_listen_subwindow](ui-framework-event_listen_subwindow.md)）を用いて定義する必要がある。

動作仕様:
1. イベント発生元要素が `condition` 属性のセレクタにマッチするかチェックし、マッチしなかった場合は何もしない。
2. マッチした場合、同じ `<event:listen>` タグ内の `target` 属性セレクタにマッチする全要素の内容を `format` 属性の値に書き換える。
3. 対象要素が入力項目（input/select/textarea）の場合はvalue属性に設定し、それ以外はテキストノードを書き換える。

**属性値一覧** [◎ 必須 ○ 任意 × 無効]

| 属性名 | 内容 | サーバ | ローカル | 備考 |
|---|---|---|---|---|
| title | 処理の簡単な説明 | × | × | 設計書表示用 |
| target | 値を書き換える要素のセレクタ式 | ◎ | ◎ | |
| format | target要素に設定する値のフォーマット式 | ○ | ○ | `{}` 内にセレクタを指定することで要素内容を埋め込み可（例: `ユーザID: {span.prefix}-{span.code}`）。省略時は値の設定自体が行われない。 |
| condition | アクション実行の事前条件。イベント発生元要素が満たすべきセレクタ式 | ○ | ○ | |
| addClass | target要素に追加するclass属性値 | ○ | ○ | 空白区切りで複数指定可 |
| removeClass | target要素から除去するclass属性値 | ○ | ○ | 空白区切りで複数指定可 |

<details>
<summary>keywords</summary>

title, target, format, condition, addClass, removeClass, セレクタ式, イベントアクション属性, value属性設定, テキストノード書き換え

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/write_to.tag | このウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/WriteAction.js | 本機能を実装するイベントアクション |

<details>
<summary>keywords</summary>

WriteAction.js, write_to.tag, 実装ファイル一覧

</details>
