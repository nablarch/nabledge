# セッション変数保存ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/SessionStoreHandler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionStoreHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionManager.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/HttpSessionManagedExpiration.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/DbManagedExpiration.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/store/UserSessionSchema.html)

## 概要

後続のハンドラやライブラリで追加・更新・削除されたセッション変数を、セッションストアに保存するハンドラ。セッションストア機能の詳細は :ref:`session_store` を参照。

> **重要**: 同一セッションの処理が複数のスレッドで実行された場合（例えば、タブブラウザで複数タブから同時にリクエストがあった場合）、使用しているストアによっては後勝ちとなる。このため、使用するストアの特性をよく理解し、要件にあったストアを選択する必要がある。ストアの詳細は [session_store-future_of_store](../libraries/libraries-session_store.md) を参照。

<details>
<summary>keywords</summary>

セッション変数保存ハンドラ, セッションストア, 後勝ち, マルチスレッド, タブブラウザ, 複数スレッド, ストア選択

</details>

## ハンドラクラス名

**クラス名**: `nablarch.common.web.session.SessionStoreHandler`

<details>
<summary>keywords</summary>

SessionStoreHandler, nablarch.common.web.session.SessionStoreHandler, セッション変数保存ハンドラ, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

DBストア・有効期間のDB保存を使用する場合のみ:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-dbstore</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, nablarch-fw-web-dbstore, com.nablarch.framework, モジュール依存関係, DBストア

</details>

## 制約

- [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること。サーブレットフォワード時にフォワード先でセッションストアの値にアクセスできるようにするため。
- HIDDENストア使用時は [multipart_handler](handlers-multipart_handler.md) より後ろに配置すること。リクエストパラメータにアクセスできるようにするため。
- [forwarding_handler](handlers-forwarding_handler.md) より前に配置すること。[forwarding_handler](handlers-forwarding_handler.md) を本ハンドラよりも前に設定した場合、内部フォワード時にHIDDENストアを使用すると最新のセッション変数を取得できない問題が発生するため。

<details>
<summary>keywords</summary>

http_response_handler, multipart_handler, forwarding_handler, HIDDENストア, ハンドラ配置順, 制約

</details>

## セッションストアを使用するための設定

`SessionManager` を本ハンドラの `sessionManager` プロパティに設定する必要がある。設定内容: アプリで使用するセッションストア（複数指定可）とデフォルトで使用するセッションストア名。

```xml
<component class="nablarch.common.web.session.SessionStoreHandler">
  <property name="sessionManager" ref="sessionManager"/>
</component>

<!-- "sessionManager"というコンポーネント名で設定する -->
<component name="sessionManager" class="nablarch.common.web.session.SessionManager">
  <!-- プロパティの設定は省略 -->
</component>
```

`SessionManager` に設定するプロパティの詳細は [session_store-use_config](../libraries/libraries-session_store.md) を参照。

<details>
<summary>keywords</summary>

SessionManager, nablarch.common.web.session.SessionManager, sessionManager, セッションストア設定, セッションマネージャ

</details>

## セッション変数を直列化してセッションストアに保存する

セッション変数をセッションストアに保存する際、直列化の仕組みを選択できる。選択可能な直列化の仕組みの詳細は [session_store-serialize](../libraries/libraries-session_store.md) を参照。

<details>
<summary>keywords</summary>

session_store-serialize, 直列化, セッション変数シリアライズ, セッション変数保存

</details>

## セッションストアの改竄をチェックする

セッションストアからセッション変数を読み込む際、改竄チェックを行う。

- HIDDENストアの改竄を検知した場合: ステータスコード400の `HttpErrorResponse` を送出
- それ以外のストアの改竄を検知した場合: セッションストアの復号処理時に発生した例外をそのまま送出

<details>
<summary>keywords</summary>

HttpErrorResponse, nablarch.fw.web.HttpErrorResponse, 改竄チェック, セッションストア改竄, ステータスコード400

</details>

## 改竄エラー時の遷移先を設定する

セッションストアの改竄を検知した場合に表示するエラーページは `web.xml` に設定する必要がある。

理由: 本ハンドラは [session_store_handler-constraint](#s3) に記載の通り [forwarding_handler](handlers-forwarding_handler.md) より前に配置する必要がある。[forwarding_handler](handlers-forwarding_handler.md) は [http_error_handler](handlers-HttpErrorHandler.md) よりも手前に設定する必要があるため、本ハンドラで発生した例外に対しては :ref:`HttpErrorHandler_DefaultPage` の設定値が適用できず、`web.xml` への設定が必要となる。

<details>
<summary>keywords</summary>

web.xml, 改竄エラー, HttpErrorHandler_DefaultPage, forwarding_handler, エラーページ設定

</details>

## セッションIDを保持するクッキーの名前や属性を変更する

セッションIDを保持するクッキーのデフォルト設定と変更可能なプロパティ:

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| cookieName | NABLARCH_SID | クッキー名 |
| cookiePath | ホスト配下のすべてのパス | 送信可能なパスを明示的に指定したい場合に設定 |
| cookieDomain | 指定しない | 送信可能なドメインを明示的に指定したい場合に設定 |
| cookieSecure | false | HTTPS環境で使用する場合は `true` に設定すること |
| MaxAge | 指定しない | セッションクッキー（ブラウザを閉じれば破棄される）として扱うため指定しない |
| HttpOnly | 常に使用 | 設定ファイル等からは変更できない |

> **重要**: セッションストアの有効期間はデフォルトではHTTPセッションに保存される。複数のストア間で異なる有効期間を設定した場合は、最も期間の長い値が使用される。有効期間の保存先をデータベースに変更する場合は :ref:`db_managed_expiration` を参照。

```xml
<component class="nablarch.common.web.session.SessionStoreHandler">
  <property name="cookieName" value="NABLARCH_SID" />
  <property name="cookiePath" value="/" />
  <property name="cookieDomain" value="" />
  <property name="cookieSecure" value="false" />
  <property name="sessionManager" ref="sessionManager"/>
</component>

<component name="sessionManager" class="nablarch.common.web.session.SessionManager">
  <property name="availableStores">
    <list>
      <component class="nablarch.common.web.session.store.DbStore">
        <property name="expires" value="1800" />
      </component>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

cookieName, cookiePath, cookieDomain, cookieSecure, NABLARCH_SID, HttpOnly, セッションクッキー, クッキー属性, DbStore

</details>

## 有効期間をデータベースに保存する

デフォルトでは `HttpSessionManagedExpiration` が使用されるため、セッションの有効期間はHTTPセッションに保存される。本ハンドラの `expiration` プロパティを `DbManagedExpiration` に設定することでデータベースに保存できる。

> **重要**: 有効期間をデータベースに保存する場合、SESSION_OBJECTカラムをNull許容で定義すること。ログアウト時などにセッションオブジェクトがNullのレコードが登録されるため。5u15以前のアーキタイプから作成したプロジェクトではデフォルトで必須属性として定義されているため、ALTER文の発行またはテーブルの再作成が必要。

- 有効期間は初期化（[repository-initialize_object](../libraries/libraries-repository.md)）が必要。
- テーブル名・カラム名を変更する場合は `DbManagedExpiration.userSessionSchema` に `UserSessionSchema` を設定し、DBストアのテーブル・カラムも同じものに変更すること。
- DBストアで使用するテーブルは [session_store-use_config](../libraries/libraries-session_store.md) に記載のDBストア使用時のテーブルを使用する。

```xml
<component name="sessionStoreHandler" class="nablarch.common.web.session.SessionStoreHandler">
  <property name="expiration" ref="expiration" />
</component>

<component name="expiration" class="nablarch.common.web.session.DbManagedExpiration">
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="expirationTransaction"/>
    </component>
  </property>
  <!-- テーブル定義を変更する場合のみ以下設定が必要 -->
  <property name="userSessionSchema" ref="userSessionSchema" />
</component>

<!-- テーブル定義を変更する場合はあわせてDBストアの定義も変更する -->
<component name="dbStore" class="nablarch.common.web.session.store.DbStore">
  <property name="userSessionSchema" ref="userSessionSchema" />
</component>

<!-- テーブル定義を変更する場合のみ以下設定が必要 -->
<component name="userSessionSchema" class="nablarch.common.web.session.store.UserSessionSchema">
  <property name="tableName" value="USER_SESSION_DB" />
  <property name="sessionIdName" value="SESSION_ID_COL" />
  <property name="sessionObjectName" value="SESSION_OBJECT_COL" />
  <property name="expirationDatetimeName" value="EXPIRATION_DATETIME_COL" />
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="expiration"/>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

HttpSessionManagedExpiration, DbManagedExpiration, nablarch.common.web.session.DbManagedExpiration, expiration, UserSessionSchema, SESSION_OBJECT, 有効期間データベース保存, SimpleDbTransactionManager, BasicApplicationInitializer, DbStore

</details>
