# 入力値で精査エラーが発生した場合に戻り先画面の情報はどのように取得したらよいですか？

## 精査エラー時の戻り先画面データ取得

## 精査エラー時の戻り先画面データ取得

精査エラー時に、画面表示データを取得してリクエストスコープに設定する。確認画面や完了画面への遷移時に精査エラーが発生した場合、入力画面に戻る際にリストボックス等のDB取得データをリクエストスコープへ再設定する必要がある。

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
        // 精査エラーの場合には、初期表示データを取得してリクエストスコープに設定する。
        setViewDataToRequestScope();
        throw new ApplicationException(context.getMessages());
    }
    return new HttpResponse("確認画面.jsp");
}

/**
 * 初期表示データを取得し、リクエストスコープに設定する。
 */
private void setViewDataToRequestScope() {
    // データベースから画面表示データを取得する。
    // 取得したデータをリクエストスコープに設定する。
}
```

<details>
<summary>keywords</summary>

@OnError, ApplicationException, HttpRequest, ExecutionContext, HttpResponse, setViewDataToRequestScope, 精査エラー, リクエストスコープ, 入力画面への戻り, 画面表示データ取得, バリデーションエラー時のデータ設定

</details>
