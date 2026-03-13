# XHRリクエスト送信イベントアクション

**公式ドキュメント**: [XHRリクエスト送信イベントアクション](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_send_request.html)

## 概要

[event_listen](testing-framework-event_listen.md) 及び [event_listen_subwindow](testing-framework-event_listen_subwindow.md) が監視するイベント発生時に、指定URLへのXHR(Ajax)リクエストを送信するイベントアクション。Nablarch本体の機構（ウィンドウスコープ、Nablarchサブミット等）と連動し、`<n:button>` `<n:submitLink>` を使用した場合と同等のPOSTリクエストを送信できる。`<n:param>` によるリクエストパラメータ付与も可能。

> **補足**: XHRレスポンスはXMLもしくはHTML形式のみ対応。JSONなどの形式には対応していない。

> **補足**: ローカル表示では動作しない。

<details>
<summary>keywords</summary>

event:send_request, XHRリクエスト送信, Ajaxリクエスト, イベントアクション, event_listen連携, POSTリクエスト, n:param

</details>

## コードサンプル

```jsp
<event:listen
  title     = "商品コード入力欄からフォーカスアウトする。"
  event     = "input.productCode blur">
  <event:send_request
    title     = "入力欄に値が設定されていた場合は、それに合致するコードを検索するAjaxリクエストを送信し、検索結果テーブルを取得する。"
    name      = "product_ajaxRequest"
    uri       = "./product/list"
    target    = "table"
    condition = "input.productCode:is-not-blank">
  </event:send_request>
</event:listen>

<event:listen
  title = "Ajaxリクエスト成功"
  event = "ajaxSuccess">
  <event:write_to
    title       = "入力した商品コードに合致するレコードがDB上に存在すれば商品名を表示する"
    target      = "span.productName"
    condition   = ":has(tr td)"
    format      = "商品名: {td.productName}">
  </event:write_to>
</event:listen>
```

> **補足**: XHRリクエスト完了後の処理は、jQueryのajax関連グローバルイベントを監視する [event_listen](testing-framework-event_listen.md) を作成し、その中にイベントアクションを配置することで実装する。ajaxイベントの詳細: [https://api.jquery.com/Ajax_Events/](https://api.jquery.com/Ajax_Events/)

<details>
<summary>keywords</summary>

JSPコード例, event:listen, event:write_to, Ajaxイベント, XHRリクエスト完了後処理, ajaxSuccess

</details>

## 仕様

- このアクションを実行するイベントは [event_listen](testing-framework-event_listen.md) (もしくは [event_listen_subwindow](testing-framework-event_listen_subwindow.md)) を用いて定義する必要がある。
- `condition` 属性のセレクタにイベント発生元要素がマッチしない場合はなにもしない。
- マッチした場合、このタグを包含する **form** 要素に対してサブミット処理を実行する（`<n:submitLink>` タグによる処理と同等）。
- `<n:param>` 等のタグを本タグの内側に記述することで、`<n:submitLink>` と同様に使用できる。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 実行する処理の説明 | 文字列 | × | × | 設計書表示用 |
| name | サブミット名 | 文字列 | ◎ | × | |
| uri | リクエスト送信先URI | 文字列 | ◎ | × | |
| target | レスポンスから取得する要素のセレクタ式 | 文字列 | ◎ | × | |
| condition | 本アクションを実行する事前条件（イベント発生元要素が満たすべきセレクタ式） | 文字列 | ○ | × | |
| paramNameAlias | リクエスト送信時のパラメータ置換ルール | 文字列 | ○ | × | 書式: `置換文字列1/置換後文字列1\|置換文字列2/置換後文字列2 ...` |

<details>
<summary>keywords</summary>

属性値一覧, name, uri, target, condition, paramNameAlias, サブミット処理, セレクタ式, form要素

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/send_request.tag | このウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/AjaxAction.js | XHR処理を実装するイベントアクション |

<details>
<summary>keywords</summary>

AjaxAction.js, send_request.tag, 実装ファイル, 内部構造

</details>
