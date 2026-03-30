# 入力値で精査エラーが発生した場合に戻り先画面の情報はどのように取得したらよいですか？

## 精査エラー時の戻り先画面データ取得方法

精査エラー（`ApplicationException`）発生時は、画面表示データをDBから取得してリクエストスコープに設定してから入力画面に戻す。初期表示時と精査エラー時の両方で同じヘルパーメソッド（`setViewDataToRequestScope()`）を呼び出すことで処理を共通化する。

**アノテーション**: `@OnError`

```java
/**
 * 入力画面を表示
 */
public HttpResponse do1(HttpRequest req, ExecutionContext ctx) {
    // データベースから初期表示用のデータを取得して、リクエストスコープに設定する。
    setViewDataToRequestScope();
    return new HttpResponse("入力画面.jsp");
}

/**
 * 確認画面を表示
 */
@OnError(type = ApplicationException.class, path = "入力画面.jsp")
public HttpResponse do2(HttpRequest req, ExecutionContext ctx) {
    if (!context.isValid()) {
        // 精査エラーの場合、初期表示データを取得してリクエストスコープに設定する
        setViewDataToRequestScope();
        throw new ApplicationException(context.getMessages());
    }
    return new HttpResponse("確認画面.jsp");
}

private void setViewDataToRequestScope() {
    // DBから画面表示データを取得してリクエストスコープに設定する
}
```

<details>
<summary>keywords</summary>

@OnError, ApplicationException, 精査エラー, リクエストスコープ, 画面表示データ取得, 入力画面への戻り, HttpResponse, HttpRequest, ExecutionContext

</details>
