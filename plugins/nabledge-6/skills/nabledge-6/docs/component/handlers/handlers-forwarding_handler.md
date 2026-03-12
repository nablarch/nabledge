# 内部フォーワードハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/forwarding_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/ForwardingHandler.html)

## ハンドラクラス名

後続ハンドラからのレスポンスが内部フォーワードを示している場合に、指定されたリクエストパスで後続ハンドラを再実行する。内部フォーワードは、遷移先の画面でチェックボックスやドロップダウンリストなどの選択肢をサーバサイドで取得する場合に使用する（例: 入力チェックエラー時に、単純な再表示ではなく選択肢を再取得して入力画面を再表示する場合）。

**クラス名**: `nablarch.fw.web.handler.ForwardingHandler`

<details>
<summary>keywords</summary>

ForwardingHandler, nablarch.fw.web.handler.ForwardingHandler, 内部フォーワードハンドラ, 後続ハンドラ再実行, 選択肢サーバサイド取得

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

- [session_store_handler](handlers-SessionStoreHandler.md) より後ろに配置すること（理由: [session_store_handler-error_forward_path](handlers-SessionStoreHandler.md) を参照）

<details>
<summary>keywords</summary>

配置順序制約, session_store_handler, セッションストアハンドラ, ハンドラ配置順

</details>

## 内部フォーワードを示すレスポンスを返却する

内部フォーワードを示すレスポンスは、コンテンツパスを `forward://` から開始する。

```java
public HttpResponse sample(HttpRequest request, ExecutionContext context) {
  // 同一業務アクションのinitializeに内部フォーワード
  return new HttpResponse("forward://initialize");
}
```

> **補足**: ステータスコードはフォーワード時とフォーワード後を比較し、大きい値をレスポンス時のステータスコードとする。例: フォーワード時200・フォーワード後500 → クライアントには500を返却。フォーワード時400・フォーワード後200 → クライアントには400を返却。

<details>
<summary>keywords</summary>

forward://, HttpResponse, 内部フォーワードレスポンス, ステータスコード比較, コンテンツパス

</details>

## 内部フォーワードに指定するパスのルール

内部フォーワードのパスには相対パスと絶対パスが指定可能。

- **相対パス**: 現在のリクエストURIを起点としたパス
- **絶対パス**: サーブレットコンテキスト名を起点としたパス。`/` から開始する

現在のリクエストURIが `action/users/save` の場合の例（両者は同一のフォーワード先を示す）:

```java
// 相対パス
new HttpResponse("forward://initialize");

// 絶対パス
new HttpResponse("forward:///action/users/initialize");
```

<details>
<summary>keywords</summary>

相対パス, 絶対パス, フォーワードパス指定, サーブレットコンテキスト, パス指定ルール

</details>

## 内部リクエストIDについて

内部フォーワード時、フォーワード先のリクエストIDを内部リクエストIDとしてスレッドコンテキストに保持する。

<details>
<summary>keywords</summary>

内部リクエストID, スレッドコンテキスト, フォーワード先リクエストID, internal_request_id

</details>
