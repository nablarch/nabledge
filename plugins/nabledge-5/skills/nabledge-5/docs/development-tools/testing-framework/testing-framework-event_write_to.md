# 項目内容変更イベントアクション

**公式ドキュメント**: [項目内容変更イベントアクション](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_write_to.html)

## コードサンプル

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

event:write_to, event:listen, ajaxSuccess, Ajaxリクエスト, 項目書き換え, JSPウィジェット, イベントアクション

</details>

## 仕様

このアクションを実行するイベントは [event_listen](testing-framework-event_listen.md) または [event_listen_subwindow](testing-framework-event_listen_subwindow.md) を使って定義する必要がある。

アクション実行時の動作:
1. イベント発生元要素が `condition` 属性のセレクタにマッチするかチェック。マッチしない場合は何もしない
2. マッチした場合、同じ `<event:listen>` タグ内で `target` セレクタにマッチする全要素の内容を `format` の値に書き換える
3. 対象要素が input/select/textarea の場合はvalue属性に設定し、それ以外の要素はテキストノードを書き換える

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 属性名 | タイプ | サーバ | ローカル | 説明・備考 |
|---|---|---|---|---|
| title | 文字列 | × | × | 設計書表示用（実行に影響なし） |
| target | 文字列 | ◎ | ◎ | 値を書き換える要素を指定するセレクタ式 |
| format | 文字列 | ○ | ○ | targetで指定した要素に設定するフォーマット式。省略時は値の設定が行われない。`{}`内にセレクタを指定することで要素の内容を埋め込める（例: `ユーザID: {span.prefix}-{span.code}`） |
| condition | 文字列 | ○ | ○ | 本アクションを実行する事前条件。イベント発生元要素が満たすべきセレクタ式 |
| addClass | 文字列 | ○ | ○ | targetで指定した要素に追加するclass属性値。空白区切りで複数指定可 |
| removeClass | 文字列 | ○ | ○ | targetで指定した要素から除去するclass属性値。空白区切りで複数指定可 |

<details>
<summary>keywords</summary>

target, format, condition, addClass, removeClass, セレクタ式, フォーマット式, イベントアクション, 条件付き書き換え, value属性設定, テキストノード書き換え

</details>

## 内部構造・改修時の留意点

本ウィジェットの実装ファイル:

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/event/write_to.tag` | ウィジェットの実体となるタグファイル |
| `/js/nablarch/ui/event/WriteAction.js` | 本機能を実装するイベントアクション |

<details>
<summary>keywords</summary>

WriteAction.js, write_to.tag, 改修, 実装ファイル, イベントアクション実装

</details>
