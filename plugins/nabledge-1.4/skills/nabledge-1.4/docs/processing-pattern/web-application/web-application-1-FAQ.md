# 入力値で精査エラーが発生した場合に戻り先画面の情報はどのように取得したらよいですか？

## 精査エラー時の戻り先画面データ取得方法

精査エラー時に、画面表示データを取得してリクエストスコープに設定する。初期表示時と精査エラー発生時の両方で、DBからデータを取得するメソッドを呼び出す実装が必要。

```java
/**
 * 入力画面を表示
 */
public HttpResponse do1(HttpRequest req, ExecutionContext ctx) {
    // 初期表示用データをDBから取得してリクエストスコープに設定する
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

/**
 * 初期表示データを取得し、リクエストスコープに設定する
 */
private void setViewDataToRequestScope() {
    // データベースから画面表示データを取得してリクエストスコープに設定する
}
```

<details>
<summary>keywords</summary>

@OnError, ApplicationException, 精査エラー, バリデーションエラー, 入力画面, リクエストスコープ, 画面表示データ取得, リストボックス, 初期表示データ, HttpResponse, HttpRequest, ExecutionContext

</details>
