# 属性値の動的切替

**公式ドキュメント**: [属性値の動的切替](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_toggle_property.html)

## コードサンプル

チェックボックス・ラジオボタン・プルダウン要素の内容に応じて、特定の要素の属性値を動的に切替えるイベントアクション。

イベントは [event_listen](testing-framework-event_listen.md) (または [event_listen_subwindow](testing-framework-event_listen_subwindow.md)) で定義する。

`allCheck` CSSクラスのチェックボックスクリックで、フォーム内の全チェックボックスをON/OFF切替するコード例:

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
</n:form>
```

<details>
<summary>keywords</summary>

event:toggle_property, event:listen, event_listen, チェックボックス制御, ラジオボタン制御, プルダウン制御, 属性値動的切替, イベントアクション, JSPウィジェット, 全チェック/クリア, toggleTarget

</details>

## 仕様

切替え対象属性はboolean型のDOM属性値（readonly/disabled/checked/selected）のみ。

**属性値一覧** (◎ 必須 / ○ 任意 / × 無効)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| type | 切替え対象属性 | 文字列 | ◎ | ◎ | disabled / readonly / checkbox / selected のいずれか |
| title | 実行する処理の簡単な説明 | 文字列 | × | × | 設計書表示用 |
| target | 属性を切替える対象要素のセレクタ式 | 文字列 | ◎ | ◎ | |
| condition | 属性値をtrueに設定する条件（イベント発生元要素が満たすべきセレクタ式） | 文字列 | ◎ | ◎ | |
| reverse | 要素を指定するセレクタ式 | 文字列 | ○ | ○ | |

<details>
<summary>keywords</summary>

type, target, condition, reverse, title, 属性値切替, セレクタ式, DOM属性, disabled, readonly, checkbox, selected

</details>

## 内部構造・改修時の留意点

本ウィジェットの実装ファイル一覧:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/toggle_property.tag | ウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/TogglePropertyAction.js | 属性値の切替え機能を実装するイベントアクション |

<details>
<summary>keywords</summary>

TogglePropertyAction.js, toggle_property.tag, 実装ファイル, イベントアクション実装

</details>
