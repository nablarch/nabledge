# 確認画面の実装

## 登録確認画面の実装

## Actionクラスの実装

確認画面表示のメソッドを既存Actionクラスに追加する。

**クラス**: `W11AC02Action`  
**アノテーション**: `@OnError`

| Actionクラス名 | メソッド名 |
|---|---|
| W11AC02Action | doRW11AC0202（リクエストID: RW11AC0202） |

```java
// 精査エラー時の遷移先の指定
@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0201.jsp")
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11AC0202.jsp");
}
```

精査エラー（`ApplicationException`）発生時は`@OnError`の`path`に指定した登録画面（W11AC0201.jsp）へ遷移する。

## JSPの実装

確認画面JSPは入力画面と確認画面の共通化機能を利用するため修正不要。外部設計で実装済みのJSPファイルを所定のディレクトリに移動する。

| コピー元 | コピー先 |
|---|---|
| main/web/W11AC0202.jsp | main/web/ss11AC/W11AC0202.jsp |

<details>
<summary>keywords</summary>

W11AC02Action, doRW11AC0202, @OnError, ApplicationException, HttpResponse, HttpRequest, ExecutionContext, 登録確認画面, 確認画面JSP, 入力画面と確認画面の共通化

</details>

## 精査処理呼び出し実装

## 精査処理の呼び出し実装

`doRW11AC0202`メソッドに精査処理の呼び出しを追加する。

**クラス**: `ValidationUtil`, `ValidationContext`  
**アノテーション**: `@OnError`

```java
@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0201.jsp")
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    validateAndConvertForResister(req);
    return new HttpResponse("/ss11AC/W11AC0202.jsp");
}

private static W11AC02Form validateAndConvertForResister(HttpRequest req) {
    ValidationContext<W11AC02Form> formCtx = ValidationUtil.validateAndConvertRequest("W11AC02", W11AC02Form.class, req, "register");
    formCtx.abortIfInvalid();
    return formCtx.createObject();
}
```

- `ValidationUtil.validateAndConvertRequest(prefix, formClass, req, validateFor)`: HTTPリクエストパラメータを指定のFormクラスに変換し、`validateFor`（ここでは`"register"`）グループの精査を実施する
- `formCtx.abortIfInvalid()`: 精査エラー項目がある場合に`ApplicationException`を送出する
- 精査OK → 確認画面（W11AC0202.jsp）へ遷移
- 精査NG → `ApplicationException`が送出され`@OnError`により登録画面（W11AC0201.jsp）へ遷移

<details>
<summary>keywords</summary>

ValidationUtil, ValidationContext, W11AC02Form, validateAndConvertRequest, abortIfInvalid, @OnError, validateAndConvertForResister, HttpRequest, HttpResponse, ExecutionContext, 精査処理, バリデーション, ApplicationException

</details>
