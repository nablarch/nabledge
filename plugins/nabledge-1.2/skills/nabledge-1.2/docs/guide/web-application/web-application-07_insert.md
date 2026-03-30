# 登録処理

## 本項で説明する内容

作成するファイル：

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [CM311AC1Component.java](../../../knowledge/guide/web-application/assets/web-application-07_insert/CM311AC1Component.java) | Component | ユーザ情報登録確認画面の情報をDBに登録する。使用SQLファイル: [CM311AC1Component.sql](../../../knowledge/guide/web-application/assets/web-application-07_insert/CM311AC1Component.sql) |
| [W11AC02Action.java](../../../knowledge/guide/web-application/assets/web-application-07_insert/W11AC02Action.java) | Action | Componentのメソッドを呼び出し、リクエストスコープに結果を格納、セッションをクリアしJSPに遷移する。 |
| [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-07_insert/W11AC0201.jsp) / [W11AC0202.jsp](../../../knowledge/guide/web-application/assets/web-application-07_insert/W11AC0202.jsp) | View | 入力内容と登録ボタン/戻るボタンを表示する。W11AC0202.jspがW11AC0201.jspを取り込む。 |

<details>
<summary>keywords</summary>

登録処理, 二重サブミット防止, DB挿入処理, CM311AC1Component, W11AC02Action, W11AC0201.jsp, W11AC0202.jsp, Component, Action, View

</details>

## 作成手順

登録処理の作成手順。二重サブミット防止にはJavaScript方式とトークン方式の2種類がある。Actionの作成（:ref:`07_actionClassCreate`）とJSPの作成（[07_jsp](#s5)）で二重サブミット防止の具体的な実装例を示す。

ステレオタイプについては :ref:`stereoType` を参照。

<details>
<summary>keywords</summary>

作成手順, ステレオタイプ, 二重サブミット防止, JavaScript方式, トークン方式

</details>

## JavaScriptを使用した二重サブミットの防止

ユーザがボタンをダブルクリックまたはサーバのレスポンス待ちに繰り返しクリックした場合に、リクエストを2回以上サーバ側に送信するのを防止する機能。DBの登録・更新処理を行う際に二重サブミットが発生すると登録・更新が2度実行されるため防止が必要。

`n:submit`タグの`allowDoubleSubmission`属性に`false`を指定することで実装する。具体的な実装例は [07_jsp](#s5) を参照。

<details>
<summary>keywords</summary>

二重サブミット防止, allowDoubleSubmission, n:submit, JavaScript方式

</details>

## トークンを使用した二重サブミットの防止

サーバ側(セッション)とクライアント側(hiddenタグ)に一意なトークンを保持し、サーバ側で突合することで二重サブミットを防止する機能。JSP(トークン設定)とAction(トークンチェック)の両方に実装が必要。

**JSP側:** 二重サブミットを防止したい`n:form`タグの`useToken`属性に`true`を設定する。ただし [./06_sharingInputAndConfirmationJsp](web-application-06_sharingInputAndConfirmationJsp.md) を使用している場合は、確認画面では`useToken`属性を設定しなくても自動的にトークンが設定される。

**Action側:** トークンをチェックしたいメソッドに`@OnDoubleSubmission`アノテーションを付与する。具体例は :ref:`07_actionClassCreate` を参照。

> **注意**: 入力画面と確認画面の共通化状況によるuseToken設定の要否：

| 入力画面と確認画面の共通化 | formタグのuseToken属性の設定 | メソッドへのアノテーションの付与 |
|---|---|---|
| 共有化している | 設定不要（自動的にトークンが設定される） | 必要 |
| 共有化していない | trueを設定する | 必要 |

例: パスワード変更画面のようにDBの更新は発生するが確認画面がない場合は、入力画面の`n:form`の`useToken`属性に`true`を設定し、submitされたときのActionメソッドに`@OnDoubleSubmission`アノテーションを付与する。

<details>
<summary>keywords</summary>

二重サブミット防止, トークン, useToken, OnDoubleSubmission, @OnDoubleSubmission, n:form, セッション, hiddenタグ

</details>

## まとめ

アプリケーションフレームワークが提供する二重サブミット防止機能のまとめ：

![二重サブミット防止機能の概要](../../../knowledge/guide/web-application/assets/web-application-07_insert/doubleSubmit.png)

- **JavaScript方式**: `n:submit`の`allowDoubleSubmission=false`でボタン連打を防止
- **トークン方式**: `n:form`の`useToken=true` + `@OnDoubleSubmission`アノテーションでサーバ側でトークン突合

<details>
<summary>keywords</summary>

二重サブミット防止, allowDoubleSubmission, useToken, OnDoubleSubmission, JavaScript方式, トークン方式

</details>

## 自動設定項目の指定(Entityの編集)

ログインユーザIDとタイムスタンプは、Entityの対応するメンバ変数にアノテーションを付与することで、値を手動設定しなくてもデータベースへ登録できる。

| アノテーション | 説明 |
|---|---|
| `@UserId` | ログインユーザIDを自動設定したいメンバ変数に付与する。 |
| `@CurrentDateTime` | タイムスタンプを自動設定したいメンバ変数に付与する。 |

SystemAccountEntityの記述例：

```java
// 登録者ユーザID
@UserId  // ログインユーザIDを設定するメンバ変数には @UserId アノテーションを付与する
private String insertUserId;

// 登録日時
@CurrentDateTime  // タイムスタンプを設定するメンバ変数には @CurrentDateTime アノテーションを付与する
private Timestamp insertDate;

// 更新者ユーザID
@UserId
private String updatedUserId;

// 更新日時
@CurrentDateTime
private Timestamp updatedDate;
```

<details>
<summary>keywords</summary>

@UserId, @CurrentDateTime, 自動設定, ログインユーザID, タイムスタンプ, SystemAccountEntity, insertUserId, insertDate, updatedUserId, updatedDate, Entity編集

</details>

## ビジネスロジック(Component)の作成

CM311AC1ComponentクラスにDbAccessSupportを継承させ、DB挿入メソッドを実装する。

**通常の挿入処理フロー:**

a) DBに登録する値を設定したEntityのインスタンスを生成する。  
b) データベースコネクションを取得する。  
c) `getParameterizedSqlStatement(SQL_ID)` でParameterizedSqlPStatementを作成する。  
d) `ParameterizedSqlPStatement#executeUpdateByObject(entity)` で挿入を実行する。

**バッチ挿入処理フロー:**

a) Entityのインスタンスを生成する。  
b) データベースコネクションを取得する。  
c) ParameterizedSqlPStatementを作成する。  
d) `ParameterizedSqlPStatement#addBatchObject(entity)` を挿入対象エンティティ分だけ繰り返し実行する。  
e) `ParameterizedSqlPStatement#executeBatch()` で一括実行する。

> **警告:** 大量のデータを一括処理する場合は、適宜`ParameterizedSqlPStatement#executeBatch`を実行すること。この処理を行わないと、メモリ不足、gc頻発による性能劣化の原因となることがある。実施間隔は方式設計書を確認すること。

> **注意:** 本処理を外出ししているのは、複数の取引から利用されることを想定しているためである。他の取引での使用を想定しないのであれば、ビジネスロジックは基本的にAction内に実装する。

**SQL (CM311AC1Component.sql):**

```sql
-- システムアカウント挿入用SQL
INSERT_SYSTEM_ACCOUNT=
INSERT INTO
  SYSTEM_ACCOUNT
  (
  USER_ID, LOGIN_ID, PASSWORD, USER_ID_LOCKED,
  PASSWORD_EXPIRATION_DATE, FAILED_COUNT,
  EFFECTIVE_DATE_FROM, EFFECTIVE_DATE_TO,
  INSERT_USER_ID,   -- 自動設定されるのは値なので、項目の指定は必要
  INSERT_DATE,
  UPDATED_USER_ID,
  UPDATED_DATE
  )
VALUES  -- VALUESに挿入する値を持つEntityのフィールド名を ":フィールド名" として記述
    (
    :userId, :loginId, :password, :userIdLocked,
    :passwordExpirationDate, :failedCount,
    :effectiveDateFrom, :effectiveDateTo,
    :insertUserId, :insertDate, :updatedUserId, :updatedDate
    )

-- システムアカウント権限挿入用SQL
INSERT_SYSTEM_ACCOUNT_AUTHORITY=
INSERT INTO
  SYSTEM_ACCOUNT_AUTHORITY
  (USER_ID, PERMISSION_UNIT_ID, INSERT_USER_ID, INSERT_DATE, UPDATED_USER_ID, UPDATED_DATE)
VALUES
    (:userId, :permissionUnitId, :insertUserId, :insertDate, :updatedUserId, :updatedDate)
```

**Java (CM311AC1Component.java):**

```java
class CM311AC1Component extends DbAccessSupport {

    void registerUser(SystemAccountEntity systemAccount, String plainPassword,
            UsersEntity users, UgroupSystemAccountEntity ugroupSystemAccount) {
        // システムアカウントの登録
        registerSystemAccount(systemAccount);

        // システムアカウント権限の登録
        if (!StringUtil.isNullOrEmpty(systemAccount.getPermissionUnit())) {
            CM311AC1Component function = new CM311AC1Component();
            function.registerSystemAccountAuthority(systemAccount);
        }
    }

    private void registerSystemAccount(SystemAccountEntity systemAccount) {
        // Prepare Parameterizedステートメントの作成。SQL_IDにはCM311AC1Component.sqlで定義したIDを指定する
        ParameterizedSqlPStatement statement =
            getParameterizedSqlStatement("INSERT_SYSTEM_ACCOUNT");

        try {
            // 挿入の実行。Entityのインスタンスを渡すことで項目ごとに値を指定せずに登録できる
            statement.executeUpdateByObject(systemAccount);
        } catch (DuplicateStatementException de) {
            throw new ApplicationException(
                MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
        }
    }

    void registerSystemAccountAuthority(SystemAccountEntity systemAccount) {
        SystemAccountAuthorityEntity systemAccountAuthority = new SystemAccountAuthorityEntity();
        systemAccountAuthority.setUserId(systemAccount.getUserId());

        ParameterizedSqlPStatement statement =
            getParameterizedSqlStatement("INSERT_SYSTEM_ACCOUNT_AUTHORITY");

        for (String permissionUnit : systemAccount.getPermissionUnit()) {
            // バッチ挿入: addBatchObjectでエンティティを登録し、最後にexecuteBatchで一括実行する
            systemAccountAuthority.setPermissionUnitId(permissionUnit);
            statement.addBatchObject(systemAccountAuthority);
        }
        statement.executeBatch();
    }
}
```

<details>
<summary>keywords</summary>

CM311AC1Component, DbAccessSupport, ParameterizedSqlPStatement, getParameterizedSqlStatement, executeUpdateByObject, addBatchObject, executeBatch, DuplicateStatementException, ApplicationException, SystemAccountAuthorityEntity, StringUtil, MessageUtil, バッチ挿入, INSERT_SYSTEM_ACCOUNT, INSERT_SYSTEM_ACCOUNT_AUTHORITY, DB挿入処理, Component作成

</details>

## Actionの作成

W11AC02Actionクラスに登録確定メソッドを追加する。

**重要な制約:** 入力データはカスタムタグによりクライアント側(hiddenタグ)に保持しているため、確認画面から遷移した場合でも入力データは改竄される恐れがある。そのため、本メソッドにおいて**毎回`validate(req)`でバリデーションを行う**必要がある。

トークンのチェックで二重サブミットと判定した場合は`RW11AC0201`にフォワードする。

```java
@OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
// 二重サブミットと判定した場合の画面遷移を指定するアノテーション。
// このメソッドが呼ばれる前にトークンをチェックし二重サブミットかを判定する。
@OnDoubleSubmission(
    path = "forward://RW11AC0201"  // 二重サブミットと判定した場合の遷移先リソースパス
)
public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {

    // 入力データを取得する場合は、毎回バリデーションを行う
    W11AC02Form form = validate(req);

    // ...

    CM311AC1Component component = new CM311AC1Component();

    // ...

    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

<details>
<summary>keywords</summary>

@OnDoubleSubmission, @OnError, ApplicationException, HttpResponse, HttpRequest, ExecutionContext, W11AC02Form, doRW11AC0204, W11AC02Action, validate, バリデーション, hiddenタグ, 改竄, forward://RW11AC0201, Action作成

</details>

## JSPの作成

`:ref:`double_submit_use_JavaScript`` と `:ref:`double_submit_use_Token`` を参照し、W11AC0201.jspを作成する。

**重要:** サンプルアプリケーションでは、入力画面と確認画面のJSPを共通化する機能（[./06_sharingInputAndConfirmationJsp](web-application-06_sharingInputAndConfirmationJsp.md)）を使用しているため、`useToken`属性を指定しなくてよい。共通化機能を使用している場合は自動的にトークンが設定されるためである。

W11AC0201.jspには`allowDoubleSubmission`（JavaScript方式）と`useToken`（トークン方式）の両方の設定が含まれる。

<details>
<summary>keywords</summary>

W11AC0201.jsp, allowDoubleSubmission, useToken, JSP作成, 入力画面, 確認画面, 共通化, 06_sharingInputAndConfirmationJsp

</details>
