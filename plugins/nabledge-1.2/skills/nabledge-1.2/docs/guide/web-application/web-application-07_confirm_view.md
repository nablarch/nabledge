# 確認画面の実装

## 確認画面の実装

## 確認画面の実装

### 1) 更新確認画面の実装

#### 1)-1 Actionクラスの実装

**a) リクエスト単体テストコードの追加**

`W11ACXXActionRequestTest` クラスに確認画面表示リクエストのテスト実行メソッドを追加する。

```java
@Test
public void testRW11ACXX02() {
    execute("testRW11ACXX02");
}
```

**b) リクエスト単体テストデータシートの作成**

`W11ACXXActionRequestTest.xls`（既存ブック）に確認画面表示リクエスト用シートを追加する。
- **シート名**: `testRW11ACXX02`

**c) リクエスト単体テスト実施（初回：失敗確認）**

Actionクラスにメソッドをまだ追加していないため、テストが**失敗**することを確認する。

**d) Actionクラスの修正（初期実装）**

`W11ACXXAction` クラスに確認画面表示のメソッドを追加する。
- **メソッド名**: `doRW11ACXX02`（"do" + リクエストID `RW11ACXX02`）

まず、JSPを返却するのみの最小実装を行う：

```java
public HttpResponse doRW11ACXX02(HttpRequest req, ExecutionContext ctx) {
    // 最初は単純にJSPを返却する処理のみ実装
    return new HttpResponse("/ss11AC/W11ACXX02.jsp");
}
```

**e) リクエスト単体テスト実施（再実施：到達確認）**

再度テストを実施し、Actionクラスまで処理が到達していることをコンソールログで確認する。

ログ中の `@@@@ DISPATCHING CLASS @@@@` の次行に `**** BEFORE ACTION ****` が出力されていれば、Actionまで処理が到達している。

JSPファイルが未作成の場合は `ERROR: PWC6117: File "..." not found` が出力されるが、この時点では問題ない。

#### 1)-2 JSPの実装

確認画面のJSP（`W11ACXX02.jsp`）は、Nablarchの入力画面と確認画面の共通化機能を利用するため、`<n:confirmationPage>` タグのみ記述する。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<n:confirmationPage path="./W11ACXX01.jsp" />
```

> **注意**: `【説明】` で始まるコメント行が含まれる場合は、ファイル保存前に必ず削除すること（文字コードエラーが発生する）。

入力画面JSP（`W11ACXX01.jsp`）に確認画面用のタイトル・ボタンを追加する：
- 入力画面用要素は `<n:forInputPage>` タグで囲む
- 確認画面用要素は `<n:forConfirmationPage>` タグで囲む

#### 1)-3 JSPの表示確認

1)-2 の修正により、更新確認画面が表示されることを確認する。

この時点ではリクエスト単体でデータシートにセットしたリクエスト内容がそのまま表示される。

> **補足**: 本来であれば精査処理を行い、精査OKの場合に確認画面が表示される。この時点では精査なしで表示を確認している。

#### 1)-3 JSP静的チェックツールの実行

JSP静的チェックツール（`jsp_static_analysis_tool`）を実行し、該当ファイルに静的チェックエラーがないことを確認する。

### 2) 精査処理呼び出し実装

#### 2)-1 Actionクラスの作成

**a) リクエスト単体データシートの修正**

精査呼び出しの確認用データを追加する。精査呼び出しの確認は**全ての項目が精査エラーとなるようなデータ**で実施する。

**b) 精査処理の呼び出し実装**

`W11ACXXAction` の `doRW11ACXX02` メソッドに、精査処理の呼び出しと精査エラー時の遷移先指定を実装する。

```java
@OnError(type = ApplicationException.class, path = "/ss11AC/W11ACXX01.jsp")
public HttpResponse doRW11ACXX02(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11ACXXForm> formCtx =
        ValidationUtil.validateAndConvertRequest("W11ACXX",
                W11ACXXForm.class, req, "simpleUpdate");
    if (!formCtx.isValid()) {
        throw new ApplicationException(formCtx.getMessages());
    }
    return new HttpResponse("/ss11AC/W11ACXX02.jsp");
}
```

**c) リクエスト単体テスト実施（最終確認）**

テストを実施し、以下を確認する：

- **精査OKの場合**: 実行結果が成功であり、更新確認画面のHTMLが出力されること。
- **精査NGの場合**: 実行結果が成功であり、更新画面のHTMLが出力され、エラーメッセージも出力されていること。

<details>
<summary>keywords</summary>

W11ACXXAction, W11ACXXForm, W11ACXXActionRequestTest, ValidationContext, ValidationUtil, ApplicationException, @OnError, validateAndConvertRequest, HttpRequest, HttpResponse, ExecutionContext, 確認画面実装, 入力画面と確認画面の共通化, 精査処理呼び出し, バリデーションエラー遷移先指定, n:confirmationPage, n:forInputPage, n:forConfirmationPage, JSP静的チェック, リクエスト単体テスト

</details>
