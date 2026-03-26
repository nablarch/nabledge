# 確認画面の実装

## 登録確認画面の実装

## 登録確認画面の実装

ActionクラスのメソッドはRequestIDに`"do"`プレフィックスを付けて命名する（例: `doRW11AC0202`）。確認画面表示メソッドは`HttpResponse`を返し、確認画面JSPパスを指定する。

**クラス**: `W11AC02Action`  
**メソッド名**: `"do"` + RW11AC0202（確認画面表示のリクエストID）

```java
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11AC0202.jsp");
}
```

リクエスト単体テストのテストクラス・メソッド:

| ソース格納フォルダ | テストクラス名 | メソッド名 |
|---|---|---|
| test/java/nablarch/sample/ss11AC | W11AC02ActionRequestTest | testRW11AC0202() |

リクエスト単体テストデータシートのブック名・シート名:

| ブック名 | シート名 |
|---|---|
| W11AC02ActionRequestTest.xlsx | testRW11AC0202 |

リクエスト単体テストデータシート（確認画面表示リクエスト用）:
![テストデータシート（確認画面表示）](../../../knowledge/guide/web-application/assets/web-application-07_confirm_view/action_test_confirm.png)

**TDD手順**: Actionクラスにメソッドを追加する前にリクエスト単体テストを実施し、テストが失敗することを確認する。その後Actionクラスにメソッドを追加してテストを再実行する。

**リクエスト単体テスト実施後の確認事項**: 出力されたHTMLをWebブラウザで開き、以下を確認する。
- 確認画面であること
- レイアウトが崩れていないこと
- 漢字氏名とカナ氏名に、リクエストパラメータで送った文字列が表示されていること

**JSP静的チェックツールの実行**: `jsp_static_analysis_tool` を実行し、該当ファイルに静的チェックエラーがないことを確認する。

<details>
<summary>keywords</summary>

W11AC02Action, HttpResponse, HttpRequest, ExecutionContext, 登録確認画面, Actionクラス実装, 確認画面表示, リクエスト単体テスト, W11AC02ActionRequestTest, testRW11AC0202, W11AC02ActionRequestTest.xlsx, JSP静的チェックツール

</details>

## 精査処理呼び出し実装

## 精査処理呼び出し実装

`@OnError`アノテーションで精査エラー（`ApplicationException`）発生時の遷移先JSPを指定する。`Form.validate(req, "register")`で精査処理を呼び出す。精査OK時は確認画面JSPを返却し、精査NG時は`@OnError`の指定により登録画面JSPに遷移する。

**アノテーション**: `@OnError`

```java
// 精査エラー時の遷移先の指定
@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0201.jsp")
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    // 精査処理の呼び出し実装
    W11AC02Form.validate(req, "register");
    return new HttpResponse("/ss11AC/W11AC0202.jsp");
}
```

リクエスト単体テストデータシート（精査確認用データ）:
![テストデータシート（精査確認）](../../../knowledge/guide/web-application/assets/web-application-07_confirm_view/action_test_confirm_validate.png)

**TDD手順**: Actionクラスに精査処理を実装する前にリクエスト単体テストを実施し、テストが失敗することを確認する。その後精査処理を実装してテストを再実行する。

**リクエスト単体テスト実施後の確認事項**:
- 精査OKの場合: 実行結果が成功であり、登録確認画面のHTMLが出力されること
- 精査NGの場合: 実行結果が成功であり、登録画面のHTMLが出力され、エラーメッセージも出力されていること

<details>
<summary>keywords</summary>

@OnError, W11AC02Form, ApplicationException, 精査処理呼び出し, バリデーション, 確認画面, エラー遷移, 精査エラー遷移先指定

</details>
