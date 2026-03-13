# サブウィンドウ内イベント定義

**公式ドキュメント**: [サブウィンドウ内イベント定義](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_listen_subwindow.html)

## サブウィンドウ内イベント定義

`event:listen_subwindow` ウィジェットは、サブウィンドウ内で発生したイベントに対してあらかじめ登録したJavaScript処理を実行する。仕様の多くは [event_listen](testing-framework-event_listen.md) と共通であり、以下はその差分のみを記載する。

**コードサンプル:**

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
</event:listen_subwindow>
```

**属性値一覧** (◎ 必須属性 ○ 任意属性 × 無効)

| 名称 | 型 | サーバ | ローカル | 説明 | 備考 |
|---|---|---|---|---|---|
| event | 文字列 | ◎ | ◎ | 監視対象イベントの定義式 | |
| watchTarget | 文字列 | ◎ | ◎ | 監視対象とするサブウィンドウ内の要素を指定するセレクタ式 | |
| windowName | 文字列 | ○ | ○ | 監視対象ウィンドウ名 | デフォルト: "subwindow" |
| openTrigger | 文字列 | ○ | ○ | 監視対象ウィンドウを開くボタン・リンクを指定するセレクタ式。指定した場合、合致するボタン・リンクから開かれたサブウィンドウのみが監視対象となる | |
| title | 文字列 | × | × | 監視するイベントの簡単な説明 | 設計書表示用 |
| operation | 文字列 | × | × | 監視イベントが発生する画面操作の説明 | 設計書表示用 |
| comment | 文字列 | × | × | このイベントに対する補足説明 | 設計書表示用 |

**部品一覧:**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/event/listen_subwindow.tag` | このウィジェットの実体となるタグファイル |
| `/js/nablarch/ui/event/SubwindowListener.js` | イベント監視機能を実装するJS部品 |

<details>
<summary>keywords</summary>

event:listen_subwindow, SubwindowListener, サブウィンドウイベント監視, openTrigger, watchTarget, windowName, event属性, listen_subwindow.tag, title, operation, comment

</details>
