# ウィンドウクローズイベントアクション

**公式ドキュメント**: [ウィンドウクローズイベントアクション](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_window_close.html)

## コードサンプル

[event_window_close](testing-framework-event_window_close.md) は [event_listen](testing-framework-event_listen.md) で定義したイベントが発生した際に画面を閉じるイベントアクション。他のイベントのアクション・イベントハンドラを処理した後に動作させるため、[../internals/jsp_page_templates](testing-framework-jsp_page_templates.md) の属性を使用してbody直下などに定義することが推奨される。

**リンクをクリックした場合に画面を閉じる例:**

```jsp
<event:listen event="a.windowClose click">
  <event:window_close></event:window_close>
</event:listen>

<n:a href="#" cssClass="windowClose">閉じる</n:a>
```

<details>
<summary>keywords</summary>

ウィンドウクローズ, 画面を閉じる, event:window_close, event:listen, イベントアクション

</details>

## 仕様（属性値一覧）

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効（指定しても効果なし）]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 処理内容の簡単な説明 | 文字列 | × | × | 設計書表示用 |

<details>
<summary>keywords</summary>

title属性, 属性値一覧, event:window_close属性

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/window_close.tag | このイベントアクションの実体となるタグファイル |
| /js/nablarch/ui/event/WindowCloseAction.js | 画面のクローズ機能を実装するJavaScript部品 |

<details>
<summary>keywords</summary>

WindowCloseAction.js, window_close.tag, 内部構造, タグファイル, JavaScript部品

</details>
