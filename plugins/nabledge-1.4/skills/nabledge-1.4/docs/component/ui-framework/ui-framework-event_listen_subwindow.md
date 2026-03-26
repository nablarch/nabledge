# サブウィンドウ内イベント定義

## コードサンプル

**コードサンプル**: サブウィンドウ内テーブルの選択リンククリックイベントを監視し、選択行の値を親ウィンドウの対応項目へ出力する例。

```jsp
<event:listen_subwindow
  openTrigger = "#openSelectUserWindow"
  watchTarget = "table tr"
  event       = "a.select click">
  <event:write_to
    target = ".user_name"
    format = "{td.userName}">
  </event:write_to>
  <event:write_to
    target = ".user_id input"
    format = "{td.userId}">
  </event:write_to>
  ...
</event:listen_subwindow>
```

イベントアクション詳細は [event_write_to](ui-framework-event_write_to.md) を参照。

<details>
<summary>keywords</summary>

event:listen_subwindow, event:write_to, openTrigger, watchTarget, サブウィンドウイベント監視, JSPタグ使用例, 親ウィンドウへの値出力

</details>

## 仕様

> **注意**: 本ウィジェットの仕様の多くは [event_listen](ui-framework-event_listen.md) と共通。記述のない部分は [event_listen](ui-framework-event_listen.md) を参照すること。

**属性値一覧** (◎ 必須属性 / ○ 任意属性 / × 無効)

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| event | 監視対象イベントの定義式 | 文字列 | ◎ | ◎ | |
| watchTarget | 監視対象とするサブウィンドウ内の要素を指定するセレクタ式 | 文字列 | ◎ | ◎ | |
| windowName | 監視対象ウィンドウ名 | 文字列 | ○ | ○ | デフォルト: `"subwindow"` |
| openTrigger | 監視対象ウィンドウを開くボタン・リンクを指定するセレクタ式。指定した場合、合致する要素から開かれたサブウィンドウのみが監視対象となる | 文字列 | ○ | ○ | |
| title | 監視するイベントの簡単な説明 | 文字列 | × | × | 設計書表示用 |
| operation | 監視イベントが発生する画面操作の説明 | 文字列 | × | × | 設計書表示用 |
| comment | このイベントに対する補足説明 | 文字列 | × | × | 設計書表示用 |

<details>
<summary>keywords</summary>

event, watchTarget, windowName, openTrigger, title, operation, comment, サブウィンドウ属性一覧, イベント監視設定, event_listen

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/event/listen_subwindow.tag` | このウィジェットの実体となるタグファイル |
| `/js/nablarch/ui/event/SubwindowListener.js` | イベント監視機能を実装するJS部品 |

<details>
<summary>keywords</summary>

listen_subwindow.tag, SubwindowListener.js, タグファイル, JavaScriptコンポーネント, 内部構造

</details>
