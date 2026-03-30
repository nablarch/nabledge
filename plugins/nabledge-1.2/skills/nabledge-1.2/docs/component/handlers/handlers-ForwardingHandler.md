# 内部フォーワードハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ForwardingHandler`

HTTPレスポンスのコンテンツパスが `forward://` で始まる場合、指定されたリクエストパスで後続ハンドラの処理を再実行する（内部フォーワード）。遷移先画面が業務アクション処理を伴う場合などに用いる。

- フォーワード後: [リクエストオブジェクト](../../about/about-nablarch/about-nablarch-concept.md) 中のリクエストパスはフォーワード先に書き換えられる
- スレッドコンテキストのリクエストIDはフォーワード後も同じ値のまま変わらない
- フォーワード先のリクエストIDは [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) から参照可能

> **重要**: [ServiceAvailabilityCheckHandler](handlers-ServiceAvailabilityCheckHandler.md)、[PermissionCheckHandler](handlers-PermissionCheckHandler.md) の開閉局チェック・認可チェックはフォーワード後のリクエストIDで実施する必要があるため、本ハンドラはこれらの上位に配置すること。

<details>
<summary>keywords</summary>

ForwardingHandler, nablarch.fw.handler.ForwardingHandler, 内部フォーワード, forward://, ServiceAvailabilityCheckHandler, PermissionCheckHandler, 内部リクエストID, コンテンツパス

</details>

## ハンドラ処理フロー

**[往路処理]**

1. ハンドラキュー構成のシャローコピーを作成する
2. 後続ハンドラに処理を委譲し、HTTPレスポンスオブジェクトを取得する

**[復路処理]**

3. HTTPレスポンスオブジェクトのコンテンツパスを取得する
   - `forward://` で始まらない場合: 処理結果をそのままリターンして終了
   - `forward://` で始まる場合（内部フォーワード処理）:
     - 書式: `forward://(フォーワード先リクエストパス)`
       - 相対パス指定: 現在のリクエストURIを起点とするパス
       - 絶対パス指定: サーブレットコンテキスト名を起点とするパス
     ```bash
     # 現在のリクエストURIが "/app/user/success.html" の場合、以下は等価
     forward://registerForm.html            # 相対パス指定
     forward:///app/user/registerForm.html  # 絶対パス指定
     ```
     - 処理手順:
       1. フォーワード先リクエストパスを `HttpRequest` オブジェクトのリクエストパスに設定
       2. フォーワード先リクエストIDをスレッドコンテキスト上の [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) に設定
       3. ハンドラキューの内容を往路で作成したコピーに差し替えたうえで後続ハンドラを再実行し、HTTPレスポンスオブジェクトを取得
       4. 初回レスポンスのステータスコードが再実行レスポンスのステータスコードより大きい場合、再実行レスポンスにその値を設定
       5. 再実行レスポンスをリターンして終了

**[例外処理]**

後続ハンドラ処理中のエラーはそのまま再送出して終了する。

<details>
<summary>keywords</summary>

ForwardingHandler, 内部フォーワード処理, forward://, コンテンツパス, ハンドラキュー, HttpRequest, ステータスコード, 往路処理, 復路処理, 内部リクエストID

</details>

## 設定項目・拡張ポイント

設定項目はなく、そのまま使用可能。

```xml
<component class="nablarch.fw.web.handler.ForwardingHandler" />
```

<details>
<summary>keywords</summary>

ForwardingHandler, nablarch.fw.web.handler.ForwardingHandler, 設定項目なし, コンポーネント設定

</details>
