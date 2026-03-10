# HTTPエラー制御ハンドラ

## ハンドラクラス名

後続のハンドラで発生した例外に対するログ出力やレスポンスへの変換を行うハンドラ。以下の処理を行う：

1. 例外の種類に応じたログ出力
2. 例外の種類に応じたエラー用HttpResponseの生成と返却
3. デフォルトページの設定

**クラス名**: `nablarch.fw.web.handler.HttpErrorHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

- :ref:`http_response_handler` より後ろに配置すること: 本ハンドラで生成した `HttpResponse` をHTTPレスポンスハンドラが処理するため。
- :ref:`http_access_log_handler` より後ろに配置すること: 本ハンドラで生成したエラー用 `HttpResponse` を元にログ出力を行うため。

## 例外の種類に応じた処理とレスポンスの生成

| 例外/エラー | ログレベル | レスポンス |
|---|---|---|
| `NoMoreHandlerException` | INFO | 404 |
| `HttpErrorResponse` | なし | `HttpErrorResponse#getResponse()` |
| `Error` | 設定による | `Error#getStatusCode()` |
| `StackOverflowError` | FATAL | 500 |
| `ThreadDeath` と `VirtualMachineError`（StackOverflowError以外） | — | — |
| 上記以外の例外・エラー | FATAL | 500 |

- `NoMoreHandlerException`: 処理すべきaction classが存在しなかった証跡として記録。レスポンス404。
- `HttpErrorResponse`: 業務例外（バリデーション等）のためログ出力なし。
- `StackOverflowError`: データや実装バグに起因する可能性があるため障害扱い。レスポンス500。
- `ThreadDeath`・`VirtualMachineError`（StackOverflowError以外）: 本ハンドラでは何もせず上位ハンドラに処理を任せる（エラーを再送出）。
- 上記以外: 予期しない例外・エラーのため障害扱い。レスポンス500。

**HttpErrorResponseの原因例外が `ApplicationException` の場合の追加処理:**
1. `ApplicationException` のメッセージ情報を `ErrorMessages` に変換する。
2. `ErrorMessages` をリクエストスコープに設定する（デフォルトキー名: `errors`）。キー名はコンポーネント設定ファイルで変更可能。

```xml
<component name="webConfig" class="nablarch.common.web.WebConfig">
  <!-- キーをmessagesに変更 -->
  <property name="errorMessageRequestAttributeName" value="messages" />
</component>
```

**Result.Errorのログ出力設定:**
`writeFailureLogPattern` プロパティに正規表現を設定し、`Error#getStatusCode()` とマッチした場合に `FATAL` レベルのログを出力する。

## デフォルトページの設定

後続ハンドラや本ハンドラのエラー処理で生成した `HttpResponse` にデフォルトページを適用する機能。`HttpResponse` が設定されていなかった場合、`defaultPage` / `defaultPages` で設定されたデフォルトページを適用する。

```xml
<component class="nablarch.fw.web.handler.HttpErrorHandler">
  <property name="defaultPages">
    <map>
      <entry key="4.." value="/USER_ERROR.jsp" />
      <entry key="404" value="/NOT_FOUND.jsp" />
      <entry key="5.." value="/ERROR.jsp" />
      <entry key="503" value="/NOT_IN_SERVICE.jsp" />
    </map>
  </property>
</component>
```

> **重要**: この機能を使用した場合、`web.xml` へのエラーページ設定（`error-page` 要素）と重複してJSPの設定が必要となる。`web.xml` へ設定しなかった場合、エラーの発生場所によってはウェブサーバのデフォルトのエラーページが表示される。デフォルトエラーページの設定は本機能ではなく `web.xml` へ行うことを推奨する。
