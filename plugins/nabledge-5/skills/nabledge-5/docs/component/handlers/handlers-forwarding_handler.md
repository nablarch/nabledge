# 内部フォーワードハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/forwarding_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/ForwardingHandler.html)

## ハンドラクラス名

後続ハンドラのレスポンスが内部フォーワード（`forward://`）を示す場合、指定パスで後続ハンドラを再実行するハンドラ。遷移先の画面が単純な画面表示ではなく、チェックボックスやドロップダウンリストなどの選択肢をサーバサイドで取得する場合に使用する（詳細: [on_error-forward](handlers-on_error.md)）。

**クラス名**: `nablarch.fw.web.handler.ForwardingHandler`

<details>
<summary>keywords</summary>

ForwardingHandler, nablarch.fw.web.handler.ForwardingHandler, 内部フォーワードハンドラ, 後続ハンドラの再実行, 内部フォーワード

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, モジュール依存関係

</details>

## 制約

[session_store_handler](handlers-SessionStoreHandler.md) より後ろに配置すること。理由: [session_store_handler-error_forward_path](handlers-SessionStoreHandler.md) を参照。

<details>
<summary>keywords</summary>

制約, 配置順序, session_store_handler, ハンドラ配置

</details>

## 内部フォーワードを示すレスポンスを返却する

レスポンスのコンテンツパスを `forward://` から開始することで内部フォーワードを指示する。

```java
public HttpResponse sample(HttpRequest request, ExecutionContext context) {
  // 同一業務アクションのinitializeに内部フォーワード
  return new HttpResponse("forward://initialize");
}
```

> **補足**: ステータスコードはフォーワード時とフォーワード後を比較し、大きい値をレスポンス時のステータスコードとする。
> - フォーワード時 **200** / フォーワード後 **500** → クライアントに **500** を返却
> - フォーワード時 **400** / フォーワード後 **200** → クライアントに **400** を返却

<details>
<summary>keywords</summary>

forward://, HttpResponse, 内部フォーワードレスポンス, ステータスコード, フォーワード時のステータスコード

</details>

## 内部フォーワードに指定するパスのルール

相対パスと絶対パスの両方が指定可能。

- **相対パス**: 現在のリクエストURIを起点としたパス
- **絶対パス**: サーブレットコンテキスト名を起点としたパス。`/` から開始する。

現在のリクエストURIが `action/users/save` の場合、以下は同一フォーワード先を示す:

```java
// 相対パス
new HttpResponse("forward://initialize");

// 絶対パス
new HttpResponse("forward:///action/users/initialize");
```

<details>
<summary>keywords</summary>

相対パス, 絶対パス, forward:// パス指定, フォーワードパス, サーブレットコンテキスト

</details>

## 内部リクエストIDについて

内部フォーワード時、フォーワード先のリクエストIDを内部リクエストIDとしてスレッドコンテキストに保持する。

<details>
<summary>keywords</summary>

内部リクエストID, スレッドコンテキスト, リクエストID, internal_request_id

</details>
