# データベースを使用した二重サブミット防止

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/db_double_submit.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/DbTokenManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/DbTokenSchema.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/HttpSessionTokenManager.html)

## 機能概要

アプリケーションサーバをスケールアウトする際、HTTPセッションのトークン管理ではスティッキーセッションやセッションレプリケーションが必要となる。サーバ側のトークンをデータベースに保管することで、特別な設定なしに複数のアプリケーションサーバ間でトークンを共有できる。

> **補足**: ブラウザが閉じられた場合などにテーブル上にトークンが残ることがある。期限切れのトークンは定期的に削除する必要がある。

> **重要**: HTTPセッションを使用した :ref:`二重サブミット防止 <tag-double_submission>` はCSRF対策に使用できたが、本機能はユーザを識別せずにトークンをDBに格納しているためCSRF対策に使用できない。本機能を使用する場合は、CSRF対策に :ref:`csrf_token_verification_handler` を使用すること。

<details>
<summary>keywords</summary>

二重サブミット防止, DBトークン管理, スケールアウト, CSRF対策, tag-double_submission, csrf_token_verification_handler

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

nablarch-fw-web-doublesubmit-jdbc, データベース二重サブミット防止, Mavenモジュール

</details>

## 使用方法

データベース上にトークンを保存するためのテーブルが必要。

`DOUBLE_SUBMISSION` テーブル:

| カラム名 | データ型 |
|---|---|
| TOKEN (PK) | `java.lang.String` |
| CREATED_AT | `java.sql.Timestamp` |

テーブル名およびカラム名は変更可能。変更する場合は `DbTokenManager.dbTokenSchema` に `DbTokenSchema` のコンポーネントを定義する。

`tokenManager` という名前でコンポーネント定義を追加する（:ref:`初期化<repository-initialize_object>` が必要）。これによりトークンがデータベースで管理される。

```xml
<component name="tokenManager" class="nablarch.common.web.token.DbTokenManager">
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="tokenTransaction"/>
    </component>
  </property>
  <!-- テーブル名、カラム名を変更する場合のみ以下設定が必要 -->
  <property name="dbTokenSchema">
    <component class="nablarch.common.web.token.DbTokenSchema">
      <property name="tableName" value="DB_TOKEN"/>
      <property name="tokenName" value="VALUE_COL"/>
      <property name="createdAtName" value="CREATED_AT_COL"/>
    </component>
  </property>
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="tokenManager"/>
    </list>
  </property>
</component>
```

`tokenGenerator` という名前でコンポーネント定義を追加する。これによりトークンにUUIDが使用され、推測および衝突の可能性を考慮しなくてよくなる。

```xml
<component name="tokenGenerator" class="nablarch.common.web.token.UUIDV4TokenGenerator" />
```

> **重要**: :ref:`テスティングフレームワークのトークン発行<how_to_set_token_in_request_unit_test>` はトークンのDB保存に対応していない。自動テスト実行時には `HttpSessionTokenManager` に差し替えてテストする必要がある。
>
> ```xml
> <!-- トークンをHTTPセッションに保存する -->
> <component name="tokenManager" class="nablarch.common.web.token.HttpSessionTokenManager"/>
> ```

<details>
<summary>keywords</summary>

DbTokenManager, DbTokenSchema, SimpleDbTransactionManager, UUIDV4TokenGenerator, HttpSessionTokenManager, BasicApplicationInitializer, tokenManager, tokenGenerator, DOUBLE_SUBMISSIONテーブル, dbManager, dbTokenSchema, tableName, tokenName, createdAtName, TOKEN, CREATED_AT

</details>
