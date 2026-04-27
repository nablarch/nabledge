# データベースを使用した二重サブミット防止

**目次**

* 機能概要
* モジュール一覧
* 使用方法

[二重サブミット防止](../../component/libraries/libraries-tag.md#tag-double-submission) では、サーバ側のトークンはHTTPセッションに保存される。
このため、アプリケーションサーバをスケールアウトする際には、スティッキーセッションやセッションレプリケーション等を
使用する必要がある。

サーバ側のトークンをデータベースに保管する実装を使用することで、特にアプリケーションサーバの設定をしなくても、
複数のアプリケーションサーバ間でトークンを共有できる。

> **Tip:**
> ブラウザが閉じられた場合などにテーブル上にトークンが残ってしまうことがある。
> そのため、期限切れのトークンは定期的に削除する必要がある。

> **Important:**
> HTTPセッションを使用した [二重サブミット防止](../../component/libraries/libraries-tag.md#tag-double-submission) はCSRF対策に使用できたが、
> 本機能はユーザを識別せずにトークンをDBに格納しているためCSRF対策に使用できない。
> 本機能を使用する場合は、CSRF対策に [CSRFトークン検証ハンドラ](../../component/handlers/handlers-csrf-token-verification-handler.md#csrf-token-verification-handler) を使用すること。

## 機能概要

サーバ側のトークンをデータベースに保管できる

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-doublesubmit-jdbc</artifactId>
</dependency>
```

## 使用方法

データベース上にトークンを保存するためのテーブルが必要となる。

作成するテーブルの定義を以下に示す。

DOUBLE_SUBMISSION テーブル
| カラム名 | データ型 |
|---|---|
| TOKEN(PK) | java.lang.String |
| CREATED_AT | java.sql.Timestamp |

テーブル名およびカラム名は変更可能である。
変更する場合は、 DbTokenManager.dbTokenSchema に
DbTokenSchema のコンポーネントを定義する。

2種類のコンポーネント定義を追加する。

`tokenManager` という名前でコンポーネント定義を追加する。
これにより、トークンがデータベースで管理されるようになる。
`tokenManager` は [初期化](../../component/libraries/libraries-repository.md#repository-initialize-object) が必要。

```xml
<component name="tokenManager" class="nablarch.common.web.token.DbTokenManager">
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="tokenTransaction"/>
    </component>
  </property>
  <!-- 上記のテーブル定義からテーブル名、カラム名を変更する場合のみ以下設定が必要 -->
  <property name="dbTokenSchema">
    <component class="nablarch.common.web.token.DbTokenSchema">
      <property name="tableName" value="DB_TOKEN"/>
      <property name="tokenName" value="VALUE_COL"/>
      <property name="createdAtName" value="CREATED_AT_COL"/>
    </component>
  </property>
</component>

<!-- 初期化が必要なため、以下を設定 -->
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="tokenManager"/>
    </list>
  </property>
</component>
```

`tokenGenerator` という名前でコンポーネント定義を追加する。
これによりトークンにUUIDが使用され、推測および衝突の可能性を考慮しなくてよくなる。

```xml
<component name="tokenGenerator"
           class="nablarch.common.web.token.UUIDV4TokenGenerator" />
```

> **Important:**
> [テスティングフレームワークのトークン発行](../../development-tools/testing-framework/testing-framework-02-RequestUnitTest.md#how-to-set-token-in-request-unit-test) はトークンのDB保存に対応していない。
> そのため、自動テスト実行時には HttpSessionTokenManager に差し替えてテストする必要がある。

> ```xml
> <!-- トークンをHTTPセッションに保存する -->
> <component name="tokenManager" class="nablarch.common.web.token.HttpSessionTokenManager"/>
> ```
