# データベースアクセス(検索、更新、登録、削除)機能

## 概要

データベース接続方法として以下の2種類を提供する。

**a) JNDI接続**（Webアプリケーションサーバに登録したデータベース接続を使用する方式）
- Webアプリケーションの場合は本接続方式を推奨。

**b) DataSource接続**（javax.sql.DataSourceの実装クラスを使用する方式）
- バッチアプリケーションなどWebアプリケーションサーバに登録したDataSourceを使用できない場合に使用。

> **注意**: 接続方式の切り替えは設定ファイルで行うため、アプリケーションコードに影響を与えない。自動テストなどWebアプリケーションサーバを必要としない場合もDataSource接続方式でサーバなしでテスト実行が可能。

上記以外の接続方法を使用したい場合には、データベース接続を取得するカスタムコンポーネント（例: `java.sql.DriverManager` から取得する部品）を追加することにより実現可能である。

Webアプリケーションでは :ref:`NablarchServletContextListener` により初期化が行われる。

## データベース接続のプール機能について

本機能ではDB接続プール機能を提供しない。プール機能を使用する場合は以下の方法で有効化する。

**プール機能の有効化方法**

a) JNDI接続の場合: WebアプリケーションサーバのDB接続プール機能を有効にする。登録方法・プール設定はWebアプリケーションサーバのマニュアルを参照。

b) DataSource接続の場合: プール機能を有するDataSource実装クラスを使用する。

> **注意**: Oracleの場合、`oracle.jdbc.pool.OracleDataSource` または `oracle.ucp.jdbc.PoolDataSourceImpl` を使用してプール用プロパティを設定することでプール機能を利用できる。

> **警告**: DBベンダーによってはプール機能を有するDataSourceが提供されていない可能性がある。各DBベンダーのJDBCマニュアルを参照すること。

## SQLインジェクション対策について

一般的なSQLインジェクション対策として、PreparedStatementを使用して入力値[^0]をバインド変数化する方法が知られている。ただし、この対策は各アプリケーションプログラマにルールを徹底させるものであり、対策としては不十分である。例えば、SQLインジェクションの脆弱性を含んだ実装を業務ロジック内で行われた場合、問題を検出することが非常に困難である。

この問題への対策として、本機能ではSQL文を外部ファイルに記述する機能を提供する。SQL文の外部化機能を使用した場合、業務ロジックではSQL文を参照できないため、SQL文と入力値[^0]の文字列連結を完全に防止できる。これがSQLインジェクション対策として最も有効な手段となる。業務ロジックでSQL実行時に使用する値はSQL文ではなく、SQL文を一意に識別するためのIDとなる。

**正しい実装例（SQL外部ファイル化）**:

```java
private final String sqlResource = this.getClass().getName() + "#";

public List getUserName(String userId) {
    // SQL文ではなくSQLを識別するためのIDを指定する
    AppDbConnection connection = DbConnectionContext.getConnection();
    connection.prepareStatementBySqlId(sqlResource + "SQL_ID");
    // 以下省略
}
```

詳細は [sql-gaibuka-label](libraries-04_Statement.md) を参照。

> **警告**: 入力値をSQL文に文字列連結する実装はSQLインジェクションの脆弱性があるため行ってはいけない（以下は脆弱な実装例）。

```java
public List getUserName(String userId) {
    // 入力値を連結しているため、SQLインジェクションの脆弱性を含んだ実装となる。
    String sql =
         "SELECT " + "USER_NAME"
       + "FROM " + "USER_MTR "
       + "WHERE " + "ID = " + userId;
    AppDbConnection connection = DbConnectionContext.getConnection();
    connection.prepareStatement(sql);
}
```

[^0]: 入力値とは、ユーザ入力値や外部システムからの連携データの事である。

<details>
<summary>keywords</summary>

JNDI接続, DataSource接続, データベース接続, NablarchServletContextListener, 接続方式切り替え, Webアプリケーション接続推奨, バッチアプリケーション接続, カスタムコンポーネント, DriverManager, 接続方法拡張, データベース接続プール機能, プール機能有効化, OracleDataSource, oracle.jdbc.pool.OracleDataSource, oracle.ucp.jdbc.PoolDataSourceImpl, SQLインジェクション対策, SQL外部ファイル化, prepareStatementBySqlId, AppDbConnection, DbConnectionContext, PreparedStatement

</details>

## JDBCのAPIを踏襲した機能

本機能はJDBCのAPIをラップしており、JDBCプログラミング経験者はスムーズに開発できる。

JDBCのAPIを拡張している機能:
- [db-feature-4-label](#)
- [db-feature-5-label](#)
- [db-feature-6-label](#)
- [db-feature-7-label](#)

## 実装済み

- データベースへの接続
- SQL文の実行
- SQL文の実行ログ出力
- 各種リソース（Connection、Statement、ResultSet）の解放
- バイナリ（LOBやBYTE型）型の検索・更新
- プリフェッチ（`SQLStatement#setFetchSize`）
- バッチ更新（`SQLStatement#addBatch`）
- 重複エラー等のアプリケーションハンドリング
- 共通項目（最終更新者、最終更新日時など）への値の自動設定
- 条件が可変の場合のSQL文生成（IN句の項目数が可変の場合を含む）
- LIKE検索時のエスケープ処理
- SQL文の外部ファイル定義（Javaコードとの分離）
- データベースアクセス時のトランザクションタイムアウトチェック

## 未実装

- PL/SQLの実行
- 1トランザクション内でのSQL文の実行回数チェック
- テーブル更新順序チェック
- テーブル更新順序違反時の振る舞い（警告または例外）の指定
- SQL文の実行ログを指定機能（リクエストID）のみ出力
- データベース接続パスワードの暗号化管理

<details>
<summary>keywords</summary>

JDBC, JDBCラッパー, データベースアクセス基本機能, 実装済み機能一覧, 未実装機能一覧, SQLStatement, setFetchSize, addBatch, バッチ更新, LIKE検索エスケープ, トランザクションタイムアウト, 共通項目自動設定, IN句可変, PL/SQL

</details>

## 頻繁に使用するデータベースリソースの自動解放機能

以下のデータベースリソースはアプリケーションでの解放処理が不要（本機能で自動解放される）:
- `java.sql.Connection`
- `java.sql.Statement`
- `java.sql.ResultSet`（Statementを解放することにより自動解放）

> **注意**: BLOB型から取得したInputStreamやバイナリファイルをデータベースに登録する際のファイルリソース等は自動解放対象外。各アプリケーションで実装すること。

## クラス図

![DBアクセス機能全体構造クラス図](../../../knowledge/component/libraries/assets/libraries-04_DbAccessSpec/DbAccessSpec_AllClassDesign.jpg)

<details>
<summary>keywords</summary>

java.sql.Connection, java.sql.Statement, java.sql.ResultSet, リソース自動解放, データベースリソース解放, クラス図, 全体構造図, DBアクセス機能全体設計

</details>

## SQL文の実行ログの出力する機能

SQLログはロガー名 `SQL`（SQLロガー）を使用する。SQLログを出力する場合はSQLロガーをログ出力対象に含める必要がある。

ログ出力制御の設定方法は [./01_Log](libraries-01_Log.md) を参照。SQLログの詳細は :ref:`SQLログの出力<SqlLog>` を参照。

**出力ログレベルと内容**:
- **DEBUGレベル**: 実行されたSQL、SELECT文の取得件数、実行時間、SQL ID（外部ファイル化した場合）
- **TRACEレベル**: バインド変数に設定した値

SQLログを抑制したい場合はSQLカテゴリの対象ログレベルを出力対象外に設定する。

> **警告**: SQLログは本番環境では出力すべきでない。ディスクI/Oに起因する性能劣化やログサイズ増加によるディスクリソース圧迫の原因となる。

本機能の各機能単位の詳細は以下の4つのサブ機能ドキュメントに分けて定義される。

- 04/04_Connection
- 04/04_Statement
- 04/04_ObjectSave
- 04/04_TransactionTimeout

<details>
<summary>keywords</summary>

SQLログ, SQLロガー, DEBUGレベル, TRACEレベル, バインド変数ログ, SQLログ本番無効化, SqlLog, 04_Connection, 04_Statement, 04_ObjectSave, 04_TransactionTimeout, サブ機能構成, Connection機能, Statement機能, ObjectSave機能, TransactionTimeout機能, 機能単位ドキュメント

</details>

## 件数指定でデータを取得(簡易検索機能)できる機能

開始位置と取得件数を指定してデータを取得できる。ページ切り替え機能をもつ画面を作成する際に、アプリケーションで表示データをフィルタリングする実装が不要になる。

<details>
<summary>keywords</summary>

件数指定取得, 開始位置指定, ページネーション, 簡易検索, ページング

</details>

## Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能

フィールドの値を1項目ずつ指定するのではなく、オブジェクト自体を指定してデータベースへ登録できる。

**対応するデータ**:
- 任意のオブジェクト（主に [../../determining_stereotypes](../../about/about-nablarch/about-nablarch-determining_stereotypes.md) のFormオブジェクト）のフィールドの値
- Map実装クラスのvalue

ログインユーザIDとタイムスタンプはオブジェクトに設定されていなくても自動でデータベースへ登録される。処理後に参照可能。

> **注意**: 自動設定項目は各開発プロジェクトで追加・変更可能（例: アノテーションを使わずカラム名で判断して値を設定することも可能）。

**実装例（オブジェクトを指定する場合）**:

```java
UserEntity entity = new UserEntity();
entity.setName("名前");
entity.setAddress("住所");
// ログインユーザID、タイムスタンプはexecuteUpdateByObject内で自動設定
statement.executeUpdateByObject(entity);
```

詳細は [オブジェクトのフィールドの値のデータベースへの登録例](libraries-04_ObjectSave.md) を参照。

<details>
<summary>keywords</summary>

executeUpdateByObject, オブジェクト登録, ログインユーザID自動設定, タイムスタンプ自動設定, 自動設定項目, ParameterizedSqlPStatement, Formオブジェクト登録

</details>

## LIKE検索を簡易的に実装出来る機能

部分一致検索（LIKE）を簡易的に実装できる。

**メリット**:
- LIKE条件に設定する文字列のエスケープ処理が不要（フレームワークが自動挿入するためエスケープ漏れなし）
- Javaコードで「%」を付加する必要がない（SQL文に `LIKE :userName%` と記述）
- [db-feature-5-label](#) と同様にオブジェクトのフィールドの値を条件に設定できる

**実装例（本機能使用時）**:

```java
UserEntity entity = new UserEntity();
entity.setUserName("ユーザ");

ParameterizedSqlPStatement st = dbConnection.prepareParameterizedSqlStatement(
        "SELECT USER_ID, USER_NAME FROM USER_MTR "
      + "WHERE USER_NAME LIKE :userName%");
// エスケープ処理は不要
st.retrieve(entity);
```

<details>
<summary>keywords</summary>

LIKE検索, 部分一致検索, エスケープ処理自動化, ParameterizedSqlPStatement, LIKE条件, prepareParameterizedSqlStatement

</details>

## 条件が可変のSQL文を組み立てる機能

Web機能で多く見られる可変条件（画面で入力された場合のみ検索条件に含める）のSQL文を自動生成できる。

**メリット**:
- Javaで入力判定を行いSQL文を組み立てる必要がない（生産性向上）
- [db-feature-5-label](#) と同様にオブジェクトのフィールドの値を条件に設定できる

**実装例（本機能使用時）**:

```java
Entity entity = new Entity();
entity.setUserName(null);
entity.setUserKanaName("ユーザメイ");

// prepareParameterizedSqlStatementの呼び出し時に検索条件オブジェクトを指定するとSQL文が自動組み立て
ParameterizedSqlPStatement sqlPStatement = dbConnection.prepareParameterizedSqlStatement(
          "SELECT USER_ID, USER_NAME, USER_KANA_NAME FROM USER_MST "
        + "WHERE $if(userName) {user_name LIKE :userName%} "
        + "AND $if(userKanaName) {user_kana_name LIKE :userKanaName%} ", entity);

SqlResultSet resultSet = sqlPStatement.retrieve(entity);
```

<details>
<summary>keywords</summary>

可変条件SQL, 動的SQL, $if構文, prepareParameterizedSqlStatement, ParameterizedSqlPStatement, SqlResultSet

</details>

## データベーストランザクションのタイムアウト機能

データベースアクセス時にトランザクションの有効期限（タイムアウト未発生）をチェックする機能。

処理遅延（データベースのロック解放待ちやSQL文の応答待ち等）によりトランザクション有効期限を過ぎた場合、トランザクションタイムアウトが発生したことを示す例外が送出され、業務処理が強制終了される。これにより遅延した処理が大量に残存することを防止できる。

Web画面処理への適用により、データベース接続プールやリクエスト処理スレッドの枯渇を防止できる（接続プール等が枯渇すると後続リクエストが全て待機状態となるため）。

<details>
<summary>keywords</summary>

トランザクションタイムアウト, 処理遅延対策, 接続プール枯渇防止, タイムアウト例外, スレッド枯渇防止

</details>
