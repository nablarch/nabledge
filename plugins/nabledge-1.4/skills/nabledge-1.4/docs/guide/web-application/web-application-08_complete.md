# 完了画面の実装

## 登録完了画面の表示

完了画面表示のActionメソッド実装パターン。

**クラス**: `W11AC02Action`、**メソッド名**: `doRW11AC0204`（"do" + リクエストID `RW11AC0204`）

```java
public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

テストクラス: `W11AC02ActionRequestTest`、テストメソッド: `testRW11AC0204`

Actionクラス実装後、`jsp_static_analysis_tool`（JSP静的チェックツール）を実行し、該当ファイルに静的チェックエラーがないことを確認する。

<details>
<summary>keywords</summary>

W11AC02Action, HttpResponse, doRW11AC0204, W11AC02ActionRequestTest, 完了画面表示, Actionメソッド実装, jsp_static_analysis_tool, JSP静的チェック

</details>

## 精査処理呼び出し実装

Actionクラスに精査処理の呼び出しと精査エラー時の遷移先指定を追加する。

**アノテーション**: `@OnError`

```java
@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0201.jsp")
public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {
    W11AC02Form.validate(req, "register");
    return new HttpResponse("/ss11AC/W11AC0202.jsp");
}
```

- 精査OK → 登録確認画面（`W11AC0202.jsp`）に遷移
- 精査NG（`ApplicationException`）→ 登録画面（`W11AC0201.jsp`）に遷移し、エラーメッセージ表示

<details>
<summary>keywords</summary>

@OnError, ApplicationException, W11AC02Form, validate, 精査処理呼び出し, バリデーション, 精査エラー遷移

</details>

## DB更新処理実装

USERSテーブルへのINSERT処理をActionクラスに実装する。

**SQLファイル** (`W11AC02Action.sql`):

```sql
REGISTER_USERS=
INSERT INTO USERS (
    USER_ID, KANJI_NAME, KANA_NAME,
    INSERT_USER_ID, INSERT_DATE, UPDATED_USER_ID, UPDATED_DATE
) VALUES (
    :userId, :kanjiName, :kanaName,
    :insertUserId, :insertDate, :updatedUserId, :updatedDate
)
```

実装手順:
1. フォーム精査・生成: `W11AC02Form form = W11AC02Form.validate(req, "register")`
2. エンティティ生成: `UsersEntity user = new UsersEntity(form.toMap())`
3. ユーザID自動採番: `user.setUserId(IdGeneratorUtil.generateUserId())`
4. SQL実行: `getParameterizedSqlStatement("REGISTER_USERS").executeUpdateByObject(user)`

```java
@OnError(type = ApplicationException.class, path = "forward:///action/ss11AC/W11AC02Action/RW11AC0201")
@OnDoubleSubmission(path = "forward:///action/ss11AC/W11AC02Action/RW11AC0201")
public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {
    W11AC02Form form = W11AC02Form.validate(req, "register");
    UsersEntity user = new UsersEntity(form.toMap());
    user.setUserId(IdGeneratorUtil.generateUserId());
    getParameterizedSqlStatement("REGISTER_USERS").executeUpdateByObject(user);
    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

> **補足**: `@OnDoubleSubmission` を指定することで二重サブミットを防ぐことができる。

> **注意**: リクエスト単体テストの更新結果期待値では、漢字氏名・カナ氏名に加え、INSERT_USER_ID（事前準備データのUSER_ID）、REGISTER_USER_ID（同）、INSERT_DATE・UPDATE_DATE（コンポーネント設定ファイルに記載した固定システム日付）も更新対象として検証する。

<details>
<summary>keywords</summary>

@OnError, ApplicationException, W11AC02Form, @OnDoubleSubmission, UsersEntity, IdGeneratorUtil, getParameterizedSqlStatement, executeUpdateByObject, DB更新, INSERT処理, 二重サブミット防止, ユーザID自動採番

</details>
