# データベースを使用した二重サブミット防止

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/db_double_submit.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/DbTokenManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/DbTokenSchema.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/HttpSessionTokenManager.html)

## 機能概要

サーバ側のトークンをデータベースに保管できる。アプリケーションサーバをスケールアウトする際、スティッキーセッションやセッションレプリケーションを設定しなくても複数サーバ間でトークンを共有できる。

> **補足**: ブラウザが閉じられた場合などにテーブル上にトークンが残ってしまうことがある。期限切れのトークンは定期的に削除する必要がある。

> **重要**: HTTPセッションを使用した :ref:`二重サブミット防止 <tag-double_submission>` はCSRF対策に使用できたが、本機能はユーザを識別せずにトークンをDBに格納しているためCSRF対策に使用できない。本機能を使用する場合は、CSRF対策に [csrf_token_verification_handler](../handlers/handlers-csrf_token_verification_handler.md) を使用すること。

<details>
<summary>keywords</summary>

DbTokenManager, DbTokenSchema, 二重サブミット防止, DBトークン管理, スケールアウト対応, CSRF対策不可, トークン期限切れ削除, csrf_token_verification_handler

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-doublesubmit-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web-doublesubmit-jdbc, 二重サブミット防止モジュール, Mavenモジュール

</details>

## 使用方法

データベース上にトークンを保存するためのテーブルが必要。

`DOUBLE_SUBMISSION` テーブル定義:

| カラム名 | データ型 |
|---|---|
| TOKEN (PK) | `java.lang.String` |
| CREATED_AT | `java.sql.Timestamp` |

テーブル名・カラム名は変更可能。変更する場合は `DbTokenManager.dbTokenSchema` に `DbTokenSchema` のコンポーネントを定義する。

以下2種類のコンポーネント定義を追加する。

**tokenManager** (`nablarch.common.web.token.DbTokenManager`) - [初期化](libraries-repository.md) が必要:

```xml
<component name="tokenManager" class="nablarch.common.web.token.DbTokenManager">
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="tokenTransaction"/>
    </component>
  </property>
  <!-- テーブル名・カラム名を変更する場合のみ以下設定が必要 -->
  <property name="dbTokenSchema">
    <component class="nablarch.common.web.token.DbTokenSchema">
      <property name="tableName" value="DB_TOKEN"/>
      <property name="tokenName" value="VALUE_COL"/>
      <property name="createdAtName" value="CREATED_AT_COL"/>
    </component>
  </property>
</component>

<!-- 初期化設定 -->
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="tokenManager"/>
    </list>
  </property>
</component>
```

**tokenGenerator** (`nablarch.common.web.token.UUIDV4TokenGenerator`) - トークンにUUIDを使用（推測・衝突の考慮不要）:

```xml
<component name="tokenGenerator" class="nablarch.common.web.token.UUIDV4TokenGenerator" />
```

> **重要**: [テスティングフレームワークのトークン発行](../../development-tools/testing-framework/testing-framework-02_RequestUnitTest.md) はトークンのDB保存に対応していない。自動テスト実行時には `HttpSessionTokenManager` に差し替えてテストすること。
> ```xml
> <component name="tokenManager" class="nablarch.common.web.token.HttpSessionTokenManager"/>
> ```

<details>
<summary>keywords</summary>

DbTokenManager, DbTokenSchema, HttpSessionTokenManager, UUIDV4TokenGenerator, DOUBLE_SUBMISSION, tokenManager, tokenGenerator, トークンDB保存設定, テスト時HttpSessionTokenManagerに差し替え, SimpleDbTransactionManager, BasicApplicationInitializer

</details>
