# 属性値の動的切替

## コードサンプル

[event_toggle_property](ui-framework-event_toggle_property.md) は、チェックボックス・ラジオボタン・プルダウン要素の内容に応じて特定の要素の真偽値型DOM属性値（`readonly`/`disabled`/`checked`/`selected`）を動的に切替えるイベントアクション。

イベントは [event_listen](ui-framework-event_listen.md) （または [event_listen_subwindow](ui-framework-event_listen_subwindow.md) ）で定義する。

**使用例**: `allCheck` CSSクラスを持つチェックボックスクリック時に、フォーム内の他の全チェックボックスをON/OFFする

```jsp
<n:form>
  <event:listen
    event="input[type='checkbox'].allCheck click">
    <event:toggle_property
      title="全てチェック/クリア"
      type="checked"
      toggleTarget="input[type='checkbox']:not('.allCheck')"
      condition=".allCheck">
    </event:toggle_property>
  </event:listen>
  ...
</n:form>
```

<details>
<summary>keywords</summary>

event:toggle_property, event:listen, チェックボックス全選択, 属性値動的切替, JSPタグ, allCheck

</details>

## 仕様

切替え対象属性は真偽値型のDOM属性値（`readonly`/`disabled`/`checked`/`selected`）に限る。

**属性値一覧** （◎ 必須属性 / ○ 任意属性 / × 無効）

| 属性名 | 内容 | 型 | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| type | 切替え対象属性 | 文字列 | ◎ | ◎ | `disabled` / `readonly` / `checkbox` / `selected` のいずれかを指定 |
| title | 実行する処理の簡単な説明 | 文字列 | × | × | 設計書表示用 |
| target | 属性を切替える対象要素を指定するセレクタ式 | 文字列 | ◎ | ◎ | |
| condition | 属性値をtrueに設定する条件を、イベント発生元要素が満たすべきセレクタ式で指定 | 文字列 | ◎ | ◎ | |
| reverse | 要素を指定するセレクタ式 | 文字列 | ○ | ○ | |

<details>
<summary>keywords</summary>

type, title, target, condition, reverse, disabled, readonly, checked, selected, CSSセレクタ, 属性値切替条件, toggle_property属性

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/event/toggle_property.tag` | このウィジェットの実体となるタグファイル |
| `/js/nablarch/ui/event/TogglePropertyAction.js` | 属性値の切替え機能を実装するイベントアクション |

<details>
<summary>keywords</summary>

TogglePropertyAction, toggle_property.tag, TogglePropertyAction.js, 実装ファイル, イベントアクション実装

</details>
