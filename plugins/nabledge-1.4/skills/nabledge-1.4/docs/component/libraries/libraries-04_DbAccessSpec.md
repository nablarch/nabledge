# データベースアクセス(検索、更新、登録、削除)機能

## 概要

データベースアクセス機能は、以下2種類の接続方法を提供する。

**接続方式**:
- **JNDI接続**: Webアプリケーションサーバに登録したデータベース接続を使用する方式。Webアプリケーションの場合に推奨。
- **DataSource接続**: `javax.sql.DataSource`の実装クラスを使用する方式。バッチアプリケーションなどWebアプリケーションサーバのDataSourceを使用できない場合に使用。

上記以外の接続方法を使用したい場合には、データベース接続を取得する部品（例：`java.sql.DriverManager`から取得する部品）を追加することにより実現可能である。

> **注意**: 自動テストなどWebアプリケーションサーバが不要な場合、DataSource接続を使用することでWebアプリケーションサーバを起動しなくてもテスト実行が可能。接続方式の切り替えは設定ファイルで行えるため、アプリケーションコードに影響を与えない。

Webアプリケーションでは、:ref:`NablarchServletContextListener` によりデータベース接続が初期化される。

## データベース接続のプール機能について

本機能ではDB接続のプール機能を提供しない。使用する場合は以下の方法で有効化すること。

- **JNDI接続の場合**: WebアプリケーションサーバのDB接続プール機能を有効にする。
- **DataSource接続の場合**: プール機能を有するDataSource実装クラスを使用する。

> **注意**: Oracleの場合、`oracle.jdbc.pool.OracleDataSource` または `oracle.ucp.jdbc.PoolDataSourceImpl` を使用してプール用プロパティを設定することでプール機能を利用できる。

> **警告**: データベースベンダーによってはプール機能を有するDataSourceが提供されていない場合がある。各データベースベンダーのJDBCマニュアルを参照すること。

## SQLインジェクション対策について

PreparedStatementのバインド変数化だけでは対策として不十分（アプリケーションプログラマによる脆弱な実装を防げない）。

本機能のSQL文外部化機能を使用することで、業務ロジックからSQL文への直接アクセスを遮断し、SQL文と入力値の文字列連結を完全に防止できる。これがSQLインジェクション対策として最も有効な手段。業務ロジックで使用する値はSQL文ではなくSQL IDのみ。

> **警告**: 以下のような入力値を文字列連結してSQL文を構築する実装はSQLインジェクションの脆弱性があるため実装してはならない。

SQLインジェクション脆弱性のある実装例（禁止）:
```java
public List getUserName(String userId) {
    // 入力値を連結しているため、SQLインジェクションの脆弱性を含んだ実装となる。
    String sql = 
         "SELECT "
           + "USER_NAME"
       + "FROM "
           + "USER_MTR "
       + "WHERE "
           + "ID = " + userId;

    AppDbConnection connection = DbConnectionContext.getConnection();
    connection.prepareStatement(sql);
    // 以下省略
}
```

SQL文外部化使用時（安全な実装）:
```java
private final String sqlResource = this.getClass().getName() + "#";

public List getUserName(String userId) {
    // ステートメントを生成する際にSQL文ではなくSQLを識別するためのIDを指定する。
    // このため、SQL文を直接編集（文字連結）することができないので、SQLインジェクション対策となる。
    AppDbConnection connection = DbConnectionContext.getConnection();
    connection.prepareStatementBySqlId(sqlResource + "SQL_ID");
    // 以下省略
}
```

<details>
<summary>keywords</summary>

JNDI接続, DataSource接続, データベース接続方式, NablarchServletContextListener, データベース接続初期化, javax.sql.DataSource, プール機能, データベース接続, oracle.jdbc.pool.OracleDataSource, oracle.ucp.jdbc.PoolDataSourceImpl, SQLインジェクション対策, SQL文外部化, prepareStatementBySqlId, PreparedStatement, バインド変数, AppDbConnection, DbConnectionContext

</details>

## JDBCのAPIを踏襲した機能

JDBCのAPIを踏襲（ラップ）しているため、JDBCプログラミング経験者はスムーズに開発できる。

JDBCのAPIを拡張している機能は、以下の特徴を参照すること。
- 件数指定でデータを取得（簡易検索機能）できる機能
- Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能
- LIKE検索を簡易的に実装出来る機能
- 条件が可変のSQL文を組み立てる機能

## 要求

### 実装済み

以下の機能は実装済み：

- データベースへの接続
- SQL文の実行
- SQL文の実行ログの出力
- 各種リソース（Connection、Statement、ResultSet）の解放
- バイナリ（LOBやBYTE型）型の検索・更新
- プリフェッチ（`SQLStatement#setFetchSize`）
- バッチ更新（`SQLStatement#addBatch`）
- 重複エラー等のアプリケーションによるハンドリング
- 共通項目（最終更新者、最終更新日時など）への値の自動設定
- 条件が可変の場合のSQL文生成（IN句の項目数が可変の場合を含む）
- LIKE検索時のエスケープ処理
- SQL文の外部ファイル定義（Javaコードとの分離）
- データベースアクセス時のトランザクションタイムアウトチェック

### 未実装

以下の機能は**未実装**（使用不可）：

- PL/SQLの実行
- 1トランザクション内でのSQL文の実行回数チェック
- テーブル更新順序のチェック
- テーブル更新順序に違反した場合の振る舞い（警告または例外）の指定
- SQL文の実行ログを指定機能（リクエストID）のみ出力
- データベース接続パスワードの暗号化管理

<details>
<summary>keywords</summary>

JDBC, データベースアクセス, 実装済み, 未実装, サポート機能, 非サポート機能, LOB, BYTE型, バイナリ, プリフェッチ, SQLStatement, setFetchSize, バッチ更新, addBatch, 重複エラー, 共通項目, IN句, LIKEエスケープ, SQL外部化, トランザクションタイムアウト, PL/SQL, DBパスワード暗号化

</details>

## 頻繁に使用するデータベースリソースの自動解放機能

以下のリソースはアプリケーションで解放処理を実装する必要はない。

- `java.sql.Connection`
- `java.sql.Statement`
- `java.sql.ResultSet`（Statementを解放することで自動解放される）

> **重要**: BLOB型から取得した`InputStream`や、バイナリファイル登録時のファイルリソース等は自動解放対象外。各アプリケーションで解放処理を実装すること。

## クラス図

本機能の全体構造図。

![DBアクセス機能 全体クラス図](../../../knowledge/component/libraries/assets/libraries-04_DbAccessSpec/DbAccessSpec_AllClassDesign.jpg)

<details>
<summary>keywords</summary>

java.sql.Connection, java.sql.Statement, java.sql.ResultSet, データベースリソース自動解放, リソース解放, クラス図, 全体構造, 全体クラス設計, DBアクセス機能

</details>

## SQL文の実行ログ(以降SQLログ)の出力する機能

SQLログはロガー名「SQL」（SQLロガー）でログ出力される。SQLログを出力する場合は、このSQLロガーをログ出力対象に含める必要がある。

**ログレベルと出力内容**:
- **DEBUGレベル**: 実行されたSQL、SELECT文の取得件数、実行時間、SQL ID（外部ファイル化した場合）
- **TRACEレベル**: バインド変数に設定した値

> **警告**: 性能劣化（ディスクI/O起因）やディスクリソースの圧迫（ログサイズ増加起因）の原因となるため、SQLログは本番環境では出力すべきでない。

ロガー名でのログ出力制御の設定方法は、[./01_Log](libraries-01_Log.md) を参照。SQLログの詳細については、:ref:`SQLログの出力<SqlLog>` を参照。

各機能単位の構造は以下のサブモジュールで構成される：

- 04/04_Connection
- 04/04_Statement
- 04/04_ObjectSave
- 04/04_TransactionTimeout
- 04/04_QueryCache

<details>
<summary>keywords</summary>

SQLログ, SQLロガー, ログ出力レベル, 本番環境SQLログ無効化, 04_Connection, 04_Statement, 04_ObjectSave, 04_TransactionTimeout, 04_QueryCache, 機能構造, サブモジュール

</details>

## 件数指定でデータを取得(簡易検索機能)できる機能

開始位置と取得件数を指定してデータを取得できる。ページ切り替え機能をもつ画面で、アプリケーションで表示データをフィルタリングする必要がなくなる。

<details>
<summary>keywords</summary>

ページング, 件数指定, 簡易検索, 開始位置指定

</details>

## Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能

オブジェクト自体を指定してデータベースへフィールドの値を登録できる（1項目ずつ指定不要）。

**対応するデータ**:
- 任意のオブジェクト（主にFormオブジェクト）のフィールドの値
- Map実装クラスのvalue

ログインユーザIDとタイムスタンプは、オブジェクトに設定されていなくても`executeUpdateByObject`内で自動設定される。処理後にはこれらの値を参照できる。

> **注意**: 自動設定項目は各開発プロジェクトで追加・変更可能（例：アノテーション不要でカラム名（フィールド名）で判断して値を設定することも可能）。

**使用例**:
```java
UserEntity entity = new UserEntity();
entity.setName("名前");
entity.setAddress("住所");
// ログインユーザID、タイムスタンプは自動設定されるため事前設定不要
statement.executeUpdateByObject(entity);
```

詳細は、[オブジェクトのフィールドの値のデータベースへの登録例](libraries-04_ObjectSave.md) を参照。

<details>
<summary>keywords</summary>

executeUpdateByObject, オブジェクト登録, ログインユーザID自動設定, タイムスタンプ自動設定, FormオブジェクトDB登録

</details>

## LIKE検索を簡易的に実装出来る機能

部分一致検索（LIKE）を簡易的に実装できる機能。

- LIKE条件に設定する文字列のエスケープ処理は実装不要（フレームワークが自動処理するためエスケープ漏れが発生しない）
- Javaコードで「%」を付加する必要はない（SQL文に記述するため、SQLレビューで仕様確認が可能）
- escape句はフレームワークで自動挿入されるため、SQL文への記述不要

**使用例**:
```java
ParameterizedSqlPStatement st = dbConnection.prepareParameterizedSqlStatement(
    "SELECT USER_ID, USER_NAME FROM USER_MTR WHERE USER_NAME LIKE :userName%");
st.retrieve(entity); // エスケープ処理は実装不要
```

<details>
<summary>keywords</summary>

LIKE検索, エスケープ処理自動, 部分一致検索, ParameterizedSqlPStatement

</details>

## 条件が可変のSQL文を組み立てる機能

可変条件（画面で入力された場合のみ検索条件に含める）のSQL文を自動生成できる機能。

- Javaコードで入力判定を行い、SQL文を組み立てる必要がない
- オブジェクトのフィールドの値を条件に設定できる

`$if(フィールド名) {SQL条件式}` の構文を使用。`prepareParameterizedSqlStatement`の呼び出し時に検索条件オブジェクトを指定することでSQL文の組み立てが行われる。

**使用例**:
```java
ParameterizedSqlPStatement sqlPStatement = dbConnection.prepareParameterizedSqlStatement(
    "SELECT USER_ID, USER_NAME, USER_KANA_NAME FROM USER_MST "
    + "WHERE $if(userName) {user_name LIKE :userName%} "
    + "AND $if(userKanaName) {user_kana_name LIKE :userKanaName%}", entity);
SqlResultSet resultSet = sqlPStatement.retrieve(entity);
```

<details>
<summary>keywords</summary>

動的SQL, 可変条件, $if構文, prepareParameterizedSqlStatement, ParameterizedSqlPStatement, SqlResultSet

</details>

## データベーストランザクションのタイムアウト機能

データベースアクセス時にトランザクションの有効期限内かをチェックする機能。

処理遅延（データベースのロック解放待ち、SQL文の応答待ち等）によりトランザクションの有効期限を過ぎた場合、トランザクションタイムアウトが発生したことを示す例外を送出する。これにより遅延した処理が強制終了され、遅延処理が大量に残存することを防止できる。

Web画面処理に適用した場合、Webアプリケーションサーバ上のDB接続プールやリクエスト要求を処理するスレッドの枯渇を防止できる。

> **注意**: DB接続プール等が枯渇すると、クライアントからの処理要求がプールの解放待ちとなり、後続リクエストが全て待機状態となる。

<details>
<summary>keywords</summary>

トランザクションタイムアウト, 処理遅延, DB接続プール枯渇防止, ロック解放待ち

</details>

## SQLクエリ結果のキャッシュ

SQL IDとパラメータが等価な参照系クエリに対して、キャッシュした結果を返却できる（DBアクセスが発生しない）。

本機能を適用できるクエリには制限がある。詳細は、[./04/04_QueryCache](libraries-04_QueryCache.md) を参照。

<details>
<summary>keywords</summary>

SQLキャッシュ, クエリキャッシュ, QueryCache, 参照系クエリ

</details>
