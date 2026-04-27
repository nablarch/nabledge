# 入力値で精査エラーが発生した場合に戻り先画面の情報はどのように取得したらよいですか？

> **question:**
> 確認画面や、完了画面に遷移する際に精査エラーが発生した場合、基本的に入力画面に遷移しエラーメッセージの表示をすると思います。
> この時に、入力画面ではリストボックスの値などをデータベースから取得して表示しなければならないケースがあります。
> このような場合、戻り先画面（入力画面）に表示する情報は、どのように実装したらいいのでしょうか？

> **answer:**
> 精査エラー時に、画面表示データを取得してリクエストスコープに設定するようにしてください。

> 以下に例を示します。

> ```java
> /**
>  * 入力画面を表示
>  */
> public HttpResponse do1(HttpRequest req, ExecutionContext ctx) {
>     // データベースから初期表示用のデータを取得して、リクエストスコープに設定する。
>     setViewDataToRequestScope();
> 
>     return new HttpResponse("入力画面.jsp");
> }
> 
> /**
>  * 確認画面を表示
>  */
> @OnError(type = ApplicationException.class, path = "入力画面.jsp")
> public HttpResponse do2(HttpRequest req, ExecutionContext ctx) {
>     // 精査処理を行う。
>     if (!context.isValid()) {
>         // 精査エラーの場合には、初期表示データを取得してリクエストスコープに設定する。
>         setViewDataToRequestScope();
>         throw new ApplicationException(context.getMessages());
>     }
>     return new HttpResponse("確認画面.jsp");
> }
> 
> /**
>  * 初期表示データを取得し、リクエストスコープに設定する。
>  */
> private void setViewDataToRequestScope() {
>     // データベースから画面表示データを取得する。
>     // 取得したデータをリクエストスコープに設定する。
> }
> ```
