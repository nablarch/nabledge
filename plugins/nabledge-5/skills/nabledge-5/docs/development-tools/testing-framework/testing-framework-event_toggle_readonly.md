# readonly 項目切替えイベントアクション

**公式ドキュメント**: [readonly 項目切替えイベントアクション](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_toggle_readonly.html)

## コードサンプル

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
</n:form>
```

<details>
<summary>keywords</summary>

event:toggle_readonly, event:listen, readonly切替えJSPコード例, ラジオボタン選択状態によるreadonly一括切替え

</details>

## 仕様

チェックボックス・ラジオボタン・プルダウン要素の選択状態に応じて、特定の要素の `readonly` 属性値を動的に切り替えるイベントアクションである。

イベントは [event_listen](testing-framework-event_listen.md)（または [event_listen_subwindow](testing-framework-event_listen_subwindow.md)）を用いて定義する必要がある。

アクション実行時の動作：
1. イベント発生元要素が `condition` 属性のセレクタにマッチするかチェック
2. マッチした場合：同じ `<event:listen>` タグ内で `target` 属性のセレクタにマッチする全要素の `readonly` 属性を設定。設定値はイベント発生元要素の選択状態に一致（`reverse` 属性が `true` の場合は逆の値）
3. マッチしなかった場合：読取専用を解除（`reverse` 属性が `true` の場合は読取専用にする）

**属性一覧** [◎ 必須 ○ 任意 × 無効]

| 属性名 | 型 | サーバ | ローカル | デフォルト | 説明 |
|---|---|---|---|---|---|
| title | 文字列 | × | × | | 設計書表示用の説明 |
| target | 文字列 | ◎ | ◎ | | 属性を切替える対象要素を指定するセレクタ式 |
| condition | 文字列 | ◎ | ◎ | | 本アクションを実行する事前条件。イベント発生元要素が満たすべきセレクタ式 |
| reverse | 真偽値 | ○ | ○ | false | イベント発生元要素の選択状態を反転した値をreadonly属性に設定する |

> **補足**: `condition` 属性はローカルレンダリングではvalue属性が使用できないので動作しない

<details>
<summary>keywords</summary>

condition属性, target属性, reverse属性, readonly属性切替え動作, イベントアクション仕様, event_listen, event_listen_subwindow, ローカルレンダリング制約, チェックボックス, ラジオボタン, プルダウン, 選択状態

</details>

## 内部構造・改修時の留意点

本ウィジェットの実装ファイル：

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/toggle_readonly.tag | ウィジェットのタグファイル |
| /js/nablarch/ui/event/TogglePropertyAction.js | 属性値の切替え機能を実装するイベントアクション |

<details>
<summary>keywords</summary>

toggle_readonly.tag, TogglePropertyAction.js, 実装ファイル一覧

</details>
