# XHRリクエスト送信イベントアクション

## 概要・コードサンプル・仕様

[event_send_request](ui-framework-event_send_request.md) は、[event_listen](ui-framework-event_listen.md) および [event_listen_subwindow](ui-framework-event_listen_subwindow.md) が監視するイベント発生時に、指定URLへXHR(Ajax)リクエストを送信するイベントアクション。Nablarch本体の機構（ウィンドウスコープ、Nablarchサブミット等）と連動し、`<n:button>` `<n:submitLink>` と同じPOSTリクエストを送信できる。`<n:param>` によるリクエストパラメータの付与も可能。

> **注意**: XHRレスポンスはXMLまたはHTML形式のみ対応。JSONなどの形式には対応していない。

> **注意**: ローカル表示では動作しない。

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

> **補足**: XHRリクエスト完了後の処理は、jQueryのajax関連グローバルイベントを監視する [event_listen](ui-framework-event_listen.md) を作成し、その中にイベントアクションを配置して実装する。ajaxイベント詳細: [Ajax Events](http://api.jquery.com/Ajax_Events/)

## 仕様

このアクションを実行するイベントは [event_listen](ui-framework-event_listen.md)（または [event_listen_subwindow](ui-framework-event_listen_subwindow.md)）で定義する必要がある。

動作フロー:
1. イベント発生元要素が `condition` 属性のセレクタにマッチするかをチェック
2. マッチしない場合: 何もしない
3. マッチした場合: このタグを包含する **form** 要素に対してサブミット処理を実行（`<n:submitLink>` タグの処理と同等）

`<n:param>` 等のタグも本タグの内側に記述することで `<n:submitLink>` と同様に利用できる。

### 属性値一覧

◎ 必須属性、○ 任意属性、× 無効（指定しても効果なし）

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 実行する処理の簡単な説明 | 文字列 | × | × | 設計書表示用 |
| name | サブミット名 | 文字列 | ◎ | × | |
| uri | リクエスト送信先URI | 文字列 | ◎ | × | |
| target | レスポンスの内容から取得する要素を指定するセレクタ式 | 文字列 | ◎ | × | |
| condition | 本アクションを実行する事前条件。イベント発生元要素が満たすべきセレクタ式 | 文字列 | ○ | × | |
| paramNameAlias | リクエスト送信時にリクエストパラメータの置換を行うルールを定義する | 文字列 | ○ | × | 書式: `置換文字列1/置換後文字列1\|置換文字列2/置換後文字列2 ...` |

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/send_request.tag | このウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/AjaxAction.js | XHR処理を実装するイベントアクション |

<details>
<summary>keywords</summary>

XHRリクエスト送信, Ajaxリクエスト, イベントアクション, event:send_request, event:listen, event:listen_subwindow, AjaxAction.js, send_request.tag, condition属性, paramNameAlias, n:param, n:submitLink, n:button, name属性, uri属性, target属性

</details>
