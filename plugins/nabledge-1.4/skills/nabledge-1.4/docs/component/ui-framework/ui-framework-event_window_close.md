# ウィンドウクローズイベントアクション

## コードサンプル

> **補足**: [event_window_close](ui-framework-event_window_close.md) は他のイベントのアクション・イベントハンドラを処理した後に動作するため、[../internals/jsp_page_templates](ui-framework-jsp_page_templates.md) の属性を利用してbody直下などに定義することが望ましい。

**リンクをクリックした場合に画面を閉じる例**:

```jsp
<event:listen event="a.windowClose click">
  <event:window_close></event:window_close>
</event:listen>

<n:a href="#" cssClass="windowClose">閉じる</n:a>
```

<details>
<summary>keywords</summary>

ウィンドウクローズ, イベントアクション, event:window_close, event:listen, 画面を閉じる, body直下に定義

</details>

## 仕様

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 処理内容の簡単な説明 | 文字列 | × | × | 設計書表示用 |

<details>
<summary>keywords</summary>

属性値一覧, title属性, 設計書表示用

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/window_close.tag | このイベントアクションの実体となるタグファイル |
| /js/nablarch/ui/event/WindowCloseAction.js | 画面のクローズ機能を実装するJavaScript部品 |

<details>
<summary>keywords</summary>

WindowCloseAction, window_close.tag, JavaScript部品, 内部構造, 部品一覧

</details>
