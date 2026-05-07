# 確認画面の実装

更新確認画面は、以下のステップで実装する。

* 登録確認画面の実装

  * Actionクラスの実装
* 精査処理呼び出し実装

  * Actionクラスの作成

## 登録確認画面の実装

### Actionクラスの実装

1. リクエスト単体テストコードの追加

  登録画面初期表示の実装- [Actionクラスの作成](../../guide/web-application/web-application-06-initial-view.md#actionクラスの実装) で作成した以下のテストクラスに対して登録確認画面表示リクエストのテスト実行メソッドを追加する。

  | ソース格納フォルダ | テストクラス名 | メソッド名 |
  |---|---|---|
  | test/java/nablarch/sample/ss11AC | W11AC02ActionRequestTest | testRW11AC0202() |

  ```java
  // ～前略～
  
  @Test
  public void testRW11AC0202() {
      execute("testRW11AC0202");
  }
  
  // ～後略～
  ```
2. リクエスト単体テストデータシートの作成

  登録画面初期表示の実装- [Actionクラスの作成](../../guide/web-application/web-application-06-initial-view.md#actionクラスの実装) で作成したリクエスト単体テストデータシート(Excelファイル)に確認画面表示リクエスト用のシートを追加する。（ [リクエスト単体テストデータシートの書き方](../../development-tools/testing-framework/testing-framework-02-requestunittest-index.md#テストケース一覧) ）

  | ブック名 | シート名 |
  |---|---|
  | W11AC02ActionRequestTest.xlsx | testRW11AC0202 |

  ![action_test_confirm.png](../../../knowledge/assets/web-application-07-confirm-view/action_test_confirm.png)
3. リクエスト単体テスト実施

  リクエスト単体テストを実施し、テストが失敗することを確認する。（Actionクラスにメソッドを追加していない為）
4. Actionクラスの修正

  登録画面初期表示の実装- [Actionクラスの作成](../../guide/web-application/web-application-06-initial-view.md#actionクラスの実装) で作成したActionクラスに確認画面表示のメソッドを追加する。

  | Actionクラス名 | メソッド名 |
  |---|---|
  | W11AC02Action | "do" ＋ RW11AC0202（確認画面表示のリクエストID） |

  ```java
  // ～前略～
  
  /**
   * 登録画面の入力項目に対して精査を行う。
   * <p/>
   * 精査がOKの場合に登録確認画面に登録内容(登録画面で入力された値)を表示する。<br />
   * 精査がNGの場合は、登録画面に遷移し、エラーメッセージを表示する。
   *
   * @param req HTTPリクエスト
   * @param ctx 実行時コンテキスト
   * @return HTTPレスポンス
   */
  public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
  
      return new HttpResponse("/ss11AC/W11AC0202.jsp");
  }
  
  // ～後略～
  ```
5. リクエスト単体テスト実施

  リクエスト単体テストを実行し、HTMLが出力されること、HTTPステータスコード：200が返却されることを確認する。

  出力されたHTMLをWebブラウザで開き、以下を確認する。

  * 確認画面であること
  * レイアウトが崩れていないこと
  * 漢字氏名とカナ氏名に、リクエストパラメータで送った文字列が表示されていること。
    （例のとおりに作成した場合、それぞれ50文字のランダムな文字列が表示される。）
6. JSP静的チェックツールの実行

  [JSP静的解析ツール](../../development-tools/java-static-analysis/java-static-analysis-01-JspStaticAnalysis.md#jsp静的解析ツール) を実行し、該当ファイルに静的チェックエラーがないことを確認する。

## 精査処理呼び出し実装

### Actionクラスの作成

1. リクエスト単体データシートの修正

  Actionクラスに精査処理を実装するために、リクエスト単体テストに精査確認用データを追加する。

  リクエスト単体テストでは、Formクラスの適切な精査処理が呼び出されることを確認すればよいので、
  そのために必要なデータを準備すればよい。（ [リクエスト単体テストデータシートの書き方](../../development-tools/testing-framework/testing-framework-02-requestunittest-index.md#テストケース一覧) ）

  ![action_test_confirm_validate.png](../../../knowledge/assets/web-application-07-confirm-view/action_test_confirm_validate.png)
2. リクエスト単体テストの実行

  リクエスト単体テストを実施し、テストが失敗することを確認する。（Actionクラスに精査処理を実装していないため。）
3. 精査処理の呼び出し実装

  登録確認画面の実装- [Actionクラスの実装](../../guide/web-application/web-application-07-confirm-view.md#actionクラスの実装) で作成したActionクラスに対して、
  [Formクラスの実装](../../guide/web-application/web-application-05-create-form.md#formクラスの実装) で作成した精査処理の呼び出し、精査エラー時の遷移先指定を実装する。

  ```java
  /**
   * 登録画面の入力項目に対して精査を行う。
   * <p/>
   * 精査がOKの場合に登録確認画面に登録内容(登録画面で入力された値)を表示する。<br />
   * 精査がNGの場合は、登録画面に遷移し、エラーメッセージを表示する。
   *
   * @param req HTTPリクエスト
   * @param ctx 実行時コンテキスト
   * @return HTTPレスポンス
   */
  // 【説明】精査エラー時の遷移先の指定
  @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0201.jsp")
  public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
  
      // 【説明】精査処理の呼び出し実装
      W11AC02Form.validate(req, "register");
  
      return new HttpResponse("/ss11AC/W11AC0202.jsp");
  }
  ```
4. リクエスト単体実施

  リクエスト単体テストを実施し、以下のようになることを確認する。

  精査OKの場合に登録確認画面が出力される。
  ⇒実行結果が成功であり、登録確認画面のHTMLが出力されること。

  精査NGの場合に登録画面が出力される。
  ⇒実行結果が成功であり、登録画面のHTMLが出力され、エラーメッセージも出力されていること。
