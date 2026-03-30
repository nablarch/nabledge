# 内部フォーワードハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ForwardingHandler`

HTTPレスポンスのコンテンツパスが `forward://` で始まる場合、指定リクエストパスで後続ハンドラを再実行する（内部フォーワード）。

内部フォーワード後の動作:
- [リクエストオブジェクト](../../about/about-nablarch/about-nablarch-concept.md) のリクエストパスはフォーワード先パスに書き換えられる
- スレッドコンテキスト中のリクエストIDはフォーワード後も同じ値を保持
- フォーワード先のリクエストIDは [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) から参照できる

> **重要**: [ServiceAvailabilityCheckHandler](handlers-ServiceAvailabilityCheckHandler.md)、[PermissionCheckHandler](handlers-PermissionCheckHandler.md) の開閉局チェック・認可チェックはフォーワード後のリクエストIDで実施する必要があるため、本ハンドラはこれらのハンドラの上位に配置すること。

<details>
<summary>keywords</summary>

ForwardingHandler, nablarch.fw.handler.ForwardingHandler, ServiceAvailabilityCheckHandler, PermissionCheckHandler, 内部フォーワード, forward://, 内部リクエストID, リクエストパス書き換え

</details>

## ハンドラ処理フロー

**[往路処理]**
1. ハンドラキュー構成のシャローコピーを作成する
2. 後続ハンドラに処理を委譲し、HTTPレスポンスオブジェクトを取得する

**[復路処理]**
3. HTTPレスポンスオブジェクトのコンテンツパス文字列を取得する
   - `forward://` で始まらない場合: そのまま処理結果をリターン
   - `forward://` で始まる場合: 以下の内部フォーワード処理を実行:
     1. フォーワード先パスを `HttpRequest` のリクエストパスに設定
     2. フォーワード先パスから取得したリクエストIDを [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) に設定
     3. ハンドラキューを往路で作成したコピーに差し替えて後続ハンドラを再実行し、HTTPレスポンスオブジェクトを取得
     4. 初回レスポンスのステータスコードが再実行結果より大きい場合、再実行結果レスポンスにその値を設定
     5. 再実行結果レスポンスをリターン

**[例外処理]**
- 後続ハンドラ処理中のエラーはそのまま再送出

**`forward://` 書式**:
- `forward://(フォーワード先リクエストパス)`
- 相対パス指定: 現在のリクエストURIを起点とするパス
- 絶対パス指定: サーブレットコンテキスト名を起点とするパス

```bash
# 現在のリクエストURIが "/app/user/success.html" の場合
forward://registerForm.html            # 相対パス指定
forward:///app/user/registerForm.html  # 絶対パス指定
```

<details>
<summary>keywords</summary>

ForwardingHandler, 内部フォーワード, forward://, HttpRequest, ハンドラキュー, ステータスコード, 往路処理, 復路処理

</details>

## 設定項目・拡張ポイント

設定項目なし。そのまま使用可能。

```xml
<!-- 内部フォーワード制御ハンドラ -->
<component class="nablarch.fw.web.handler.ForwardingHandler" />
```

<details>
<summary>keywords</summary>

ForwardingHandler, nablarch.fw.web.handler.ForwardingHandler, 設定項目なし, XML設定, component

</details>
