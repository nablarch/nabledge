# 内部フォーワードハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ForwardingHandler`

後続ハンドラの処理結果HTTPレスポンスのコンテンツパスが **forward://** で始まる場合、指定リクエストパスで後続ハンドラを再実行する（内部フォーワード）。遷移先画面が単純な画面表示ではなく、業務アクション処理を伴う場合に使用する。

- 内部フォーワード後、[リクエストオブジェクト](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) 中のリクエストパスはフォーワード先パスに書き換えられる
- スレッドコンテキスト中のリクエストIDはフォーワード後も変わらない
- フォーワード先のリクエストIDは [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) から参照できる

**関連ハンドラの配置制約**:

| ハンドラ | 制約 |
|---|---|
| [ServiceAvailabilityCheckHandler](handlers-ServiceAvailabilityCheckHandler.md)、[PermissionCheckHandler](handlers-PermissionCheckHandler.md) | 開閉局チェック・認可チェックをフォーワード後のリクエストIDで実施する必要があるため、本ハンドラはこれらのハンドラより上位に配置すること |

<details>
<summary>keywords</summary>

ForwardingHandler, nablarch.fw.handler.ForwardingHandler, 内部フォーワード, forward://, ServiceAvailabilityCheckHandler, PermissionCheckHandler, ハンドラ配置制約

</details>

## ハンドラ処理フロー

**[往路処理]**

1. ハンドラキュー構成のシャローコピーを作成する
2. 後続ハンドラに処理を委譲し、HTTPレスポンスオブジェクトを取得する

**[復路処理]**

3. HTTPレスポンスオブジェクトからコンテンツパス文字列を取得する

   - **3a（forward:// で始まらない場合）**: 何もせず手順2の処理結果をリターンして終了
   - **3b（forward:// で始まる場合）**: 内部フォーワード処理を実行

     書式: `forward://(フォーワード先リクエストパス)`
     - 相対パス指定: 現在のリクエストURIを起点とするパス
     - 絶対パス指定: サーブレットコンテキスト名を起点とするパス

     ```bash
     # 現在のリクエストURIが "/app/user/success.html" の場合、以下は等価
     forward://registerForm.html            # 相対パス指定
     forward:///app/user/registerForm.html  # 絶対パス指定
     ```

     処理手順:
     1. フォーワード先リクエストパスを `HttpRequest` オブジェクトのリクエストパスに設定する
     2. フォーワード先リクエストパスから取得したリクエストIDをスレッドコンテキスト上の [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) に設定する
     3. 実行コンテキストのハンドラキューを手順1のコピーに差し替えて後続ハンドラを再実行し、HTTPレスポンスオブジェクトを取得する
     4. 初回レスポンスのステータスコードと手順2で得たレスポンスのステータスコードを比較し、前者が大きければ手順2のレスポンスにその値を設定する
     5. 手順2で得たレスポンスをリターンして終了する

**[例外処理]**

- **2a**: 後続ハンドラ処理中にエラーが発生した場合は、そのまま再送出して終了する

<details>
<summary>keywords</summary>

内部フォーワード処理フロー, forward://, HttpRequest, 内部リクエストID, ハンドラキュー, シャローコピー, ステータスコード

</details>

## 設定項目・拡張ポイント

設定項目なし。そのまま使用できる。

```xml
<component class="nablarch.fw.web.handler.ForwardingHandler" />
```

<details>
<summary>keywords</summary>

ForwardingHandler設定, nablarch.fw.web.handler.ForwardingHandler, XML設定

</details>
