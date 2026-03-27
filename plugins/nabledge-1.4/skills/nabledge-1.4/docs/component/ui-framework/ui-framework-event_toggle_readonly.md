# readonly 項目切替えイベントアクション

## コードサンプル

## コードサンプル

ラジオボタンの選択状態に応じて入力項目グループのreadonly属性を一括切り替えする例:

```jsp
<n:form>
  <event:listen
    event="input[type='radio'].editProfile click">
    <event:toggle_readonly
      condition="[value='edit']"
      reverse="true"
      toggleTarget="div.profile :input:not('.editProfile')">
    </event:toggle_readonly>
  </event:listen>
  ...
</n:form>
```

<details>
<summary>keywords</summary>

readonly属性切替え, イベントアクション, コードサンプル, JSP, event:toggle_readonly, event:listen

</details>

## 仕様

## 仕様

`event_toggle_readonly` は、チェックボックス・ラジオボタン・プルダウン要素の選択状態に応じて、特定の要素の `readonly` 属性値を動的に切り替えるイベントアクションである。

- このアクションを実行するイベントは [event_listen](ui-framework-event_listen.md)（もしくは [event_listen_subwindow](ui-framework-event_listen_subwindow.md)）を用いて定義する必要がある。
- アクション実行時、まずイベント発生元要素が `condition` 属性のセレクタにマッチするかをチェックする。
- **マッチした場合**: 同じ `<event:listen>` タグ内に存在し、`target` 属性のセレクタにマッチする全要素の `readonly` 属性を、イベント発生元要素の選択状態に一致する値に設定する。`reverse` 属性が `true` の場合はその逆の値を設定する。
- **マッチしなかった場合**: 読取専用を解除する（`reverse` 属性が `true` の場合は読取専用にする）。

**属性値一覧**

| プロパティ名 | 型 | 必須(サーバ) | 必須(ローカル) | デフォルト値 | 説明 |
|---|---|---|---|---|---|
| title | 文字列 | × | × | | 実行する処理の簡単な説明（設計書表示用） |
| target | 文字列 | ◎ | ◎ | | 属性を切替える対象要素を指定するセレクタ式 |
| condition | 文字列 | ◎ | ◎ | | 本アクションを実行する事前条件。イベント発生元要素が満たすべきセレクタ式の形式で指定する |
| reverse | 真偽値 | ○ | ○ | false | イベント発生元要素の選択状態を反転した値をreadonly属性に設定する |

> **注意**: `condition` 属性において、ローカルレンダリングでは `value` 属性が利用できないので動作しない。

<details>
<summary>keywords</summary>

チェックボックス, ラジオボタン, プルダウン, トリガー要素, title, target, condition, reverse, readonly属性設定, event:toggle_readonly仕様, event:listen, TogglePropertyAction, セレクタマッチ, ローカルレンダリング制約

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

本ウィジェットは以下のファイルによって実装されている。

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/toggle_readonly.tag | このウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/TogglePropertyAction.js | 属性値の切替え機能を実装するイベントアクション |

<details>
<summary>keywords</summary>

toggle_readonly.tag, TogglePropertyAction.js, 実装ファイル, ウィジェット構成

</details>
