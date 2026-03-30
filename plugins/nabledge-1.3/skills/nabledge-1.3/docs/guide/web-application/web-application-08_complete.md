# 完了画面の実装

## 登録完了画面の表示

## 登録完了画面の表示

**アノテーション**: `@OnDoubleSubmission`, `@OnError`

`@OnDoubleSubmission` を指定することで二重サブミットを防ぐ。`@OnError` でエラー時（`ApplicationException`）のフォワード先を指定する。

```java
@OnError(type = ApplicationException.class, path = "forward:///action/ss11AC/W11AC02Action/RW11AC0201")
@OnDoubleSubmission(path = "forward:///action/ss11AC/W11AC02Action/RW11AC0201")
public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

JSPの作成は既存ファイルをコピーして行う:

| コピー元 | コピー先 |
|---|---|
| main/web/W11AC0203.jsp | main/web/ss11AC/W11AC0203.jsp |

JSP作成後は [jsp_static_analysis_tool](../../development-tools/java-static-analysis/java-static-analysis-01_JspStaticAnalysis.md) を実行してエラーがないことを確認する。

<details>
<summary>keywords</summary>

W11AC02Action, HttpResponse, HttpRequest, ExecutionContext, @OnDoubleSubmission, @OnError, ApplicationException, doRW11AC0204, 完了画面表示, 二重サブミット防止, Actionクラス実装

</details>

## DB更新処理実装

## DB更新処理実装

**クラス**: `W11AC02Action`, `IdGeneratorUtil`, `UsersEntity`

**アノテーション**: `@OnDoubleSubmission`, `@OnError`

> **注意**: 今回はチュートリアルであることと、非常に簡易なSQLでありリクエスト単体テストで十分にテスト可能であることから、Componentクラスは作成していない。

ActionメソッドでのDB登録処理手順:
1. リクエストパラメータのバリデーションとForm生成: `validateAndConvertForResister(req)`
2. ユーザIDを自動採番してEntityに設定: `IdGeneratorUtil.generateUserId()`
3. SQL実行: `getParameterizedSqlStatement("REGISTER_USERS").executeUpdateByObject(users)`

```java
@OnError(type = ApplicationException.class, path = "forward:///action/ss11AC/W11AC02Action/RW11AC0201")
@OnDoubleSubmission(path = "forward:///action/ss11AC/W11AC02Action/RW11AC0201")
public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {
    W11AC02Form form = validateAndConvertForResister(req);
    UsersEntity users = form.getUser();
    users.setUserId(IdGeneratorUtil.generateUserId());
    getParameterizedSqlStatement("REGISTER_USERS").executeUpdateByObject(users);
    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

ユーザテーブル登録SQL（格納ディレクトリ: `main/java/nablarch/sample/ss11AC` / SQLファイル: `W11AC01Action.sql`）:

```sql
REGISTER_USERS=
INSERT INTO
    USERS (
        USER_ID, KANJI_NAME, KANA_NAME,
        INSERT_USER_ID, INSERT_DATE,
        UPDATED_USER_ID, UPDATED_DATE
    )
    VALUES (
        :userId, :kanjiName, :kanaName,
        :insertUserId, :insertDate,
        :updatedUserId, :updatedDate
    )
```

> **注意**: 更新対象カラムには漢字氏名・カナ氏名のほか、登録ユーザID(INSERT_USER_ID)、登録日付(INSERT_DATE)、更新ユーザID(REGISTER_USER_ID)、更新日付(UPDATE_DATE)も含まれる。登録ユーザID・更新ユーザIDは事前準備データのUSER_ID欄に記載したユーザIDで更新される。日付はコンポーネント設定ファイルの固定システム日付で更新される。

<details>
<summary>keywords</summary>

W11AC02Action, W11AC02Form, IdGeneratorUtil, UsersEntity, HttpRequest, HttpResponse, ExecutionContext, @OnDoubleSubmission, @OnError, ApplicationException, getParameterizedSqlStatement, executeUpdateByObject, validateAndConvertForResister, REGISTER_USERS, INSERT_USER_ID, INSERT_DATE, ユーザ登録, DB更新, SQL実行, 自動採番

</details>
