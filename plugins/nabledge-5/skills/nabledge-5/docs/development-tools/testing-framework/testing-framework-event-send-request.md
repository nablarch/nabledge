# XHRリクエスト送信イベントアクション

[XHRリクエスト送信イベントアクション](../../development-tools/testing-framework/testing-framework-event-send-request.md) は、 [ページ内イベント定義](../../development-tools/testing-framework/testing-framework-event-listen.md) 及び [サブウィンドウ内イベント定義](../../development-tools/testing-framework/testing-framework-event-listen-subwindow.md)
が監視するイベントが発生した際に、指定したURLに対するXHR(Ajax)リクエストを送信する
イベントアクションである。

本アクションでは、Nablarch本体の機構(ウィンドウスコープ、Nablarch サブミット等) と連動し
<n:button> <n:subimitLink> を使用した場合と同じPOSTリクエストを送信できる。
また <n:param> を用いたリクエストパラメータの付与も可能となっている。

> **Tip:**
> 本アクションでは、XHRレスポンスがXMLもしくはHTML形式であることを前提としている。
> JSONなどの形式には対応していない。

> **Tip:**
> 本アクションはローカル表示では動作しない。

## コードサンプル

以下のソースコードは、商品コードを入力すると
その商品名をXHRリクエストで検索して表示する例である。

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

> **Tip:**
> XHRリクエスト完了後の処理は、上の例のように、
> jQueryのajax関連グローバルイベントを監視する [ページ内イベント定義](../../development-tools/testing-framework/testing-framework-event-listen.md)
> を作成し、その中にイベントアクションを配置することで実装する。

> ajaxイベントの詳細については下記のリンク先を参照すること。

> [https://api.jquery.com/Ajax_Events/](https://api.jquery.com/Ajax_Events/)

## 仕様

このアクションを実行するイベントは [ページ内イベント定義](../../development-tools/testing-framework/testing-framework-event-listen.md)
(もしくは [サブウィンドウ内イベント定義](../../development-tools/testing-framework/testing-framework-event-listen-subwindow.md) ) を用いて定義する必要がある。

このアクションが実行されると、まず、イベントの発生元要素が condition 属性の
セレクタにマッチするかをチェックし、マッチしなかった場合はなにもしない。

マッチした場合、このタグを包含する **form** 要素に対してサブミット処理を実行する。
このサブミット処理は <n:submitLink> タグによる処理と同等である。

また、 <n:param> 等のタグについても、本タグの内側に記述することで
<n:submitLink> と同様に使用できる。

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 実行する処理の簡単な説明 | 文字列 | × | × | 設計書表示用 |
| name | サブミット名 | 文字列 | ◎ | × |  |
| uri | リクエスト送信先URI | 文字列 | ◎ | × |  |
| target | レスポンスの内容から取得する 要素を指定するセレクタ式 | 文字列 | ◎ | × |  |
| condition | 本アクションを実行する事前条件。 イベント発生元要素が満たすべき セレクタ式の形式で指定する。 | 文字列 | ○ | × |  |
| paramNameAlias | リクエストを送信する際に リクエストパラメータを置換する ルールを定義する。 | 文字列 | ○ | × | 置換ルールの書式は以下のとおり。   置換文字列1/置換後文字列1\|置換文字列2/置換後文字列2 ... |

## 内部構造・改修時の留意点

本ウィジェットは以下のファイルによって実装されている。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/send_request.tag | このウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/AjaxAction.js | XHR処理を実装するイベントアクション |
