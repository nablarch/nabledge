# 登録処理

## 

なし

<details>
<summary>keywords</summary>

登録処理, DB挿入処理, 二重サブミット防止

</details>

## 本項で説明する内容

## 作成ファイル

| ファイル名 | ステレオタイプ | 処理内容 |
|---|---|---|
| [CM311AC1Component.java](../../../knowledge/guide/web-application/assets/web-application-07_insert/CM311AC1Component.java) | Component | ユーザ情報登録確認画面の情報をDBに登録する。使用SQL: [CM311AC1Component.sql](../../../knowledge/guide/web-application/assets/web-application-07_insert/CM311AC1Component.sql) |
| [W11AC02Action.java](../../../knowledge/guide/web-application/assets/web-application-07_insert/W11AC02Action.java) | Action | CM311AC1Componentのメソッドを呼び出し、結果をリクエストスコープに格納、セッションをクリアしJSPに遷移する |
| [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-07_insert/W11AC0201.jsp), [W11AC0202.jsp](../../../knowledge/guide/web-application/assets/web-application-07_insert/W11AC0202.jsp) | View | ユーザ情報登録画面の入力内容と登録・戻るボタンを表示する。W11AC0202.jspでW11AC0201.jspを取り込む |

ステレオタイプについては :ref:`stereoType` を参照。

<details>
<summary>keywords</summary>

CM311AC1Component, W11AC02Action, W11AC0201, W11AC0202, Component, Action, View, ステレオタイプ, 登録処理作成ファイル

</details>

## 

なし

<details>
<summary>keywords</summary>

作成手順, 二重サブミット防止, 登録処理手順

</details>

## 作成手順

## 自動設定項目の指定（Entityの編集）

ログインユーザIDとタイムスタンプは、Entityのメンバ変数に以下のアノテーションを付与することで値を設定しなくてもDBへ登録できる。

| アノテーション | 説明 |
|---|---|
| `@UserId` | ログインユーザIDを自動設定するメンバ変数に付与する |
| `@CurrentDateTime` | タイムスタンプを自動設定するメンバ変数に付与する |

```java
@UserId
private String insertUserId;

@CurrentDateTime
private Timestamp insertDate;

@UserId
private String updatedUserId;

@CurrentDateTime
private Timestamp updatedDate;
```

> **注意**: 自動設定されるのは値のみ。SQL文の項目指定（INSERT INTO列リストおよびVALUES句）は明示的に記述すること。

## ビジネスロジック（Component）の作成

**クラス**: `DbAccessSupport` を継承する。

**通常の挿入処理**:

1. 登録する値を設定したEntityインスタンスを生成
2. `ParameterizedSqlPStatement` を作成（[03_field](web-application-03_listSearch.md) 参照）
3. `ParameterizedSqlPStatement#executeUpdateByObject` でEntityを渡して挿入実行

**バッチ挿入**（特定のエンティティへの繰り返し挿入）:

1. Entityインスタンス生成
2. `ParameterizedSqlPStatement` 作成
3. `ParameterizedSqlPStatement#addBatchObject` でエンティティ登録（挿入対象分繰り返し）
4. `ParameterizedSqlPStatement#executeBatch` で一括実行

> **警告**: 大量データの一括処理では適宜 `executeBatch` を実行すること。未実施の場合、メモリ不足・gc頻発による性能劣化の原因となる。実施間隔は方式設計書で確認すること。

> **注意**: 複数取引から利用することを想定して処理を外出しする場合はFormを引数としない。他取引での使用を想定しない場合はビジネスロジックはAction内に実装する。

SQLファイル定義例（CM311AC1Component.sql）:

```sql
-- システムアカウント挿入用SQL
INSERT_SYSTEM_ACCOUNT=
INSERT INTO SYSTEM_ACCOUNT (
  USER_ID, LOGIN_ID, PASSWORD, USER_ID_LOCKED, PASSWORD_EXPIRATION_DATE,
  FAILED_COUNT, EFFECTIVE_DATE_FROM, EFFECTIVE_DATE_TO,
  INSERT_USER_ID, INSERT_DATE, UPDATED_USER_ID, UPDATED_DATE
) VALUES (
  :userId, :loginId, :password, :userIdLocked, :passwordExpirationDate,
  :failedCount, :effectiveDateFrom, :effectiveDateTo,
  :insertUserId, :insertDate, :updatedUserId, :updatedDate
)

-- システムアカウント権限挿入用SQL
INSERT_SYSTEM_ACCOUNT_AUTHORITY=
INSERT INTO SYSTEM_ACCOUNT_AUTHORITY (
  USER_ID, PERMISSION_UNIT_ID,
  INSERT_USER_ID, INSERT_DATE, UPDATED_USER_ID, UPDATED_DATE
) VALUES (
  :userId, :permissionUnitId,
  :insertUserId, :insertDate, :updatedUserId, :updatedDate
)
```

Javaコード例（CM311AC1Component.java）:

```java
class CM311AC1Component extends DbAccessSupport {

    private void registerSystemAccount(SystemAccountEntity systemAccount) {
        ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SYSTEM_ACCOUNT");
        try {
            statement.executeUpdateByObject(systemAccount);
        } catch (DuplicateStatementException de) {
            throw new ApplicationException(
                MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
        }
    }

    void registerSystemAccountAuthority(SystemAccountEntity systemAccount) {
        SystemAccountAuthorityEntity systemAccountAuthority = new SystemAccountAuthorityEntity();
        systemAccountAuthority.setUserId(systemAccount.getUserId());
        ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SYSTEM_ACCOUNT_AUTHORITY");
        for (String permissionUnit : systemAccount.getPermissionUnit()) {
            systemAccountAuthority.setPermissionUnitId(permissionUnit);
            statement.addBatchObject(systemAccountAuthority);
        }
        statement.executeBatch();
    }
}
```

## Actionの作成（:ref:`07_actionClassCreate`）

確認画面からの遷移でも入力データはカスタムタグでhiddenタグ（クライアント側）に保持されているため改竄の恐れがある。このため、確認画面から遷移した場合でも必ず再バリデーションを実行すること。

**アノテーション**: `@OnDoubleSubmission`, `@OnError`

```java
@OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
@OnDoubleSubmission(
    path = "forward://RW11AC0201"
)
public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {
    W11AC02Form form = validate(req);  // 入力データ取得時は毎回バリデーションを行う
    // ...
    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

## JSPの作成（[07_jsp](#s7)）

:ref:`double_submit_use_JavaScript` と :ref:`double_submit_use_Token` を参照してW11AC0201.jspを作成する。サンプルアプリケーションでは入力画面と確認画面のJSPを共通化する機能を使用しているため、useToken属性の指定は不要。

<details>
<summary>keywords</summary>

@UserId, @CurrentDateTime, DbAccessSupport, ParameterizedSqlPStatement, executeUpdateByObject, addBatchObject, executeBatch, バッチ挿入, DuplicateStatementException, @OnDoubleSubmission, @OnError, 自動設定項目, 登録処理実装, Actionクラス, JSP作成, SystemAccountEntity, SystemAccountAuthorityEntity, ApplicationException, W11AC02Form, HttpResponse, HttpRequest, ExecutionContext

</details>

## JavaScriptを使用した二重サブミットの防止

ユーザのダブルクリックやボタン連打でリクエストが複数送信されるのを防ぐ機能。DBの登録・更新処理で二重サブミットが発生すると処理が2度実行されるため防止が必要。

サンプル提供のbuttonタグの `allowDoubleSubmission` 属性に `false` を指定することで防止できる。具体例は [07_jsp](#s7) 参照。

<details>
<summary>keywords</summary>

二重サブミット防止, allowDoubleSubmission, buttonタグ, JavaScript二重サブミット, ダブルクリック防止

</details>

## トークンを使用した二重サブミットの防止

サーバ側で発行した一意なトークンをセッション（サーバ側）とhiddenタグ（クライアント側）に保持し、サーバ側で突合することで二重サブミットを検知する機能。

## JSP

二重サブミットを防止したいn:formタグの `useToken` 属性に `true` を設定する。ただし、 [./06_sharingInputAndConfirmationJsp](web-application-06_sharingInputAndConfirmationJsp.md) を使用している場合は、確認画面でuseToken=trueを設定しなくてもトークンが自動設定される。具体例は [07_jsp](#s7) 参照。

## Action

**アノテーション**: `@OnDoubleSubmission`

トークンをチェックしたいメソッドに付与する。具体例は :ref:`07_actionClassCreate` 参照。

> **注意**: useToken属性とアノテーション付与の組み合わせ：
>
> | 入力画面と確認画面の共通化 | useToken属性の設定 | アノテーション付与 |
> |---|---|---|
> | 共有化している | 設定不要（自動的にトークンが設定される） | 必要 |
> | 共有化していない | trueを設定する | 必要 |
>
> 例：確認画面がなくDBの更新があるページ（パスワード変更画面等）では、入力画面のn:formタグにuseToken=trueを設定し、submitのActionメソッドに@OnDoubleSubmissionを付与する。

<details>
<summary>keywords</summary>

トークン, 二重サブミット防止, useToken, OnDoubleSubmission, n:formタグ, セッション, hiddenタグ

</details>

## まとめ

![アプリケーションフレームワークが提供する二重サブミット防止機能のまとめ](../../../knowledge/guide/web-application/assets/web-application-07_insert/doubleSubmit.png)

<details>
<summary>keywords</summary>

二重サブミット防止まとめ, allowDoubleSubmission, useToken, OnDoubleSubmission, 二重サブミット防止機能

</details>

## 

なし

<details>
<summary>keywords</summary>

登録処理, 二重サブミット防止

</details>
