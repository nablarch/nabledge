# データベースアクセス(検索、更新、登録、削除)機能

## 概要

下記２種類の接続方法を使用してデータベース接続を行う機能を提供する。
下記以外の接続方法を使用したい場合には、データベース接続を取得する部品(例えば、java.sql.DriverManagerから取得する部品)を追加することにより実現可能である。

*デフォルトで提供するデータベース接続方法*

a) JNDI接続(Webアプリケーションサーバに登録したデータベース接続を使用する方式)

Webアプリケーションサーバに登録したデータベース接続を使用する場合の接続方法。
Webアプリケーションの場合には、本接続方式を使用することを推奨する。

b) DataSource接続(javax.sql.DataSourceの実装クラスを使用してデータベース接続を行う方式)

java.sql.DataSourceを使用する場合の接続方法。
バッチアプリケーションなどのようにWebアプリケーションサーバに登録したDataSourceを使用できない場合には、本接続方式を使用することになる。

> **Note:**
> 自動テストなどでWebアプリケーションサーバを必要としない場合には、本接続方式を使用することによりWebアプリケーションサーバを起動しなくてもテストの実行が可能となる。
> 接続方式の切り替えは、設定ファイルで行えるためアプリケーションコードに影響を与えることはない。

データベース接続は、本フレームワークの他の機能から初期化される。
Webアプリケーションでは、 [Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md#nablarchservletcontextlistener) により初期化が行われる。

アプリケーションプログラマは、本機能をSQL文の実行に使用する。
SQL文の実行方法については、 [SQL文実行部品の構造とその使用方法](../../component/libraries/libraries-04-Statement.md#db-sqlstatement-label) 以降に記述する。

## 特徴

### JDBCのAPIを踏襲した機能

本機能は基本的にJDBCのAPIを踏襲(ラップ)しているため、JDBCプログラミング経験者であればスムーズに開発を行うことができる。
JDBCのAPIを拡張している機能は、下記特徴を参照すること。

* [件数指定でデータを取得(簡易検索機能)できる機能](../../component/libraries/libraries-04-DbAccessSpec.md#db-feature-4-label)
* [Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能](../../component/libraries/libraries-04-DbAccessSpec.md#db-feature-5-label)
* [LIKE検索を簡易的に実装出来る機能](../../component/libraries/libraries-04-DbAccessSpec.md#db-feature-6-label)
* [条件が可変のSQL文を組み立てる機能](../../component/libraries/libraries-04-DbAccessSpec.md#db-feature-7-label)

### 頻繁に使用するデータベースリソースの自動解放機能

データベースアクセスで頻繁に使用する下記リソースの解放処理はアプリケーションで実装する必要はない。
ただし、下記に該当しないリソース(BLOB型から取得したInputStreamや、バイナリファイルをデータベースに登録する際のファイルリソース等)は、本機能でのリソース解放対象外となるため、各アプリケーションで実装すること。

**本機能で解放されるデータベースリソース**

* java.sql.Connection
* java.sql.Statement
* java.sql.ResultSet(Statementを解放することにより、自動で解放される。)

### SQL文の実行ログ(以降SQLログ)の出力する機能

SQLログはロガー名に文字列で「SQL」(SQLロガー)を指定してログ出力を行う。
SQLログをログ出力する場合は、このSQLロガーをログ出力対象に含める必要がある。

ロガー名でのログ出力制御の設定方法は、 [ログ出力](../../component/libraries/libraries-01-Log.md) を参照すること。
SQLログの詳細については、 [SQLログの出力](../../component/libraries/libraries-02-SqlLog.md#sqllog) を参照。

> **Note:**
> 出力される内容と、出力時に使用されるログレベル
> SQLログの出力を抑制したい場合には、SQLカテゴリの下記ログレベルを出力対象外に設定する。

> * >   DEBUGレベルで出力する内容

>   * >     実行されたSQL
>   * >     SELECT文の場合には、取得件数
>   * >     実行時間
>   * >     SQL文を外部ファイル化した場合のSQLを一意に特定するためのID
> * >   TRACEレベルで出力する内容

>   * >     バインド変数に設定した値

> **Warning:**
> 性能劣化(ディスクI/Oに起因する)やディスクリソースの圧迫(ログサイズの増加に起因する)の原因となるため、SQLログは本番環境では出力すべきでない。

### 件数指定でデータを取得(簡易検索機能)できる機能

開始位置、取得件数を指定してデータを取得することができる。
これにより、ページ切り替え機能をもつ画面を作成する際に、アプリケーションで表示データをフィルタリングする必要がなくなる。

### Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能

オブジェクトのフィールドの値を1項目ずつ指定するのではなく、オブジェクト自体を指定してデータベースへフィールドの値を登録することができる。
オブジェクトを指定してデータベースに登録できるデータは、下記の２種類である。

* 任意のオブジェクト(主に、 [業務コンポーネントの責務配置](../../about/about-nablarch/about-nablarch-determining-stereotypes.md) に定義されているFormオブジェクト)のフィールドの値
* Map実装クラスのvalue

この時に、ログインユーザIDとタイムスタンプは、オブジェクトに設定されていなくてもデータベースへ登録することが可能となっている。
また、処理後にはこれらの値を参照することができるため、画面表示時に使用すること可能である。

詳細は、 [オブジェクトのフィールドの値のデータベースへの登録例](../../component/libraries/libraries-04-ObjectSave.md#db-object-store-label) を参照。

> **Note:**
> 自動設定項目は、各開発プロジェクトで追加、変更が可能となっている。
> 例えば、アノテーションを使用せずにカラム名（フィールド名）で判断を行い値を設定するといったことも可能である。

> **Note:**
> フィールドの値を個別に設定する場合と、オブジェクトを設定する場合の実装の違い

> **フィールドの値を個別に設定する場合**

> ```java
> UserEntity entity = new UserEntity();
> entity.setName("名前");
> entity.setAddress("住所");
> 
> //********************************************************
> // フィールドの値を一項目ずつ指定する場合
> // テーブルの項目が増えると、ステップ数が増加する。
> // また、テーブルの項目が増えた場合に修正が発生する。
> //********************************************************
> statement.setString(1, entity.getName());
> statement.setString(2, entity.getAddress());
> 
> //********************************************************
> // ユーザID、タイムスタンプを設定する。
> //********************************************************
> // ユーザIDをコンテキストから取得して設定する。
> statement.setString(3, ThreadContext.getUserId());
> // システム日時を、日付取得部品から取得して設定する。
> // 日付取得部品は、リポジトリ機能から事前に取得しておく必要がある。
> statement.setString(4, systemTimeProvider.getDate());
> statement.executeUpdate();
> ```

> **オブジェクトを設定する場合**

> ```java
> UserEntity entity = new UserEntity();
> entity.setName("名前");
> entity.setAddress("住所");
> 
> //********************************************************
> // オブジェクトを指定する場合
> // 1項目ずつ値を設定する必要がないため、1ステップでSQL文の実行が可能
> // ログインユーザID、タイムスタンプは、executeUpdateByObject内で
> // 自動で設定されるため、事前に設定は不要。
> //********************************************************
> statement.executeUpdateByObject(entity);
> ```

### LIKE検索を簡易的に実装出来る機能

部分一致検索(LIKE)機能を簡易的に実装できる機能を提供する。
この機能には、下記のメリットがある。

* LIKE条件に設定する文字列のエスケープ処理を実装する必要がない。(実装する必要がないので、エスケープ漏れは発生しない。)
* Javaコードで条件に「%」を付加する必要がない。(「%」はSQL文に記述するため、SQL文のレビューで仕様との相違がないかの確認が出来る。)
* Javaの実装は、 [Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能](../../component/libraries/libraries-04-DbAccessSpec.md#db-feature-5-label) 機能と同様に、オブジェクトのフィールドの値を条件に設定できる。

> **Note:**
> 本機能を使用した場合と、従来のJDBC標準機能を使用した場合での実装の違い

> **本機能を使用した場合の実装**

> ```java
> UserEntity entity = new UserEntity();
> entity.setUserName("ユーザ");
> 
> // 「%」は、SQL文に記述を行うため、Javaコードがなくても実装の確認が行える。
> // また、escape句はフレームワークで自動挿入されるため、SQL文に記述を行う必要はない。
> 
> ParameterizedSqlPStatement st = dbConnection.prepareParameterizedSqlStatement(
>         "SELECT "
>           + "USER_ID, "
>           + "USER_NAME "
>       + "FROM "
>           + "USER_MTR "
>       + "WHERE "
>           + "USER_NAME LIKE :userName%");
> 
> // エスケープ処理は実装する必要がない。
> st.retrieve(entity);
> ```

> **本機能を使用せずに従来のJDBC標準機能の実装(上記の本機能を使用した場合と同じ結果となる実装)**

> ```java
> String userName = "ユーザ";
> 
> // likeが条件にある場合は、escape句を付ける必要がある。
> SqlPStatement st = dbConnection.prepareStatement(
>         "SELECT "
>           + "USER_ID, "
>           + "USER_NAME "
>       + "FROM "
>           + "USER_MTR "
>       + "WHERE "
>           + "USER_NAME LIKE ? ESCAPE '\\'");
> 
> // 条件はエスケープ処理を行い、「%」を付加する必要がある。
> st.setString(1, escape(userName) + "%");
> 
> st.retrieve();
> 
> // Oracle用escape処理の内容
> // 「%」、「％」「_」「＿」「\」をエスケープ文字(\)でエスケープ処理を行う。
> // エスケープ文字は、SQL文をエスケープ処理
> private static String escape(String str) {
>     return str.replaceAll("(%|％|_|＿|\\\\)", "\\\\$1");
> }
> ```

### 条件が可変のSQL文を組み立てる機能

Web機能で多く見られる可変条件(画面で入力された場合のみ、検索条件に含める機能)のSQL文を、自動で生成できる機能を提供する。
この機能には、下記のメリットがある。

* Javaで入力判定を行ない、SQL文を組み立てる必要がない。(生産性が向上する。)
* [Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能](../../component/libraries/libraries-04-DbAccessSpec.md#db-feature-5-label) 機能と同様に、オブジェクトのフィールドの値を条件に設定できる。

> **Note:**
> 本機能を使用した場合と、従来のJDBC標準機能を使用した場合での実装の違い

> **本機能を使用した場合の実装**

> ```java
> Entity entity = new Entity();
> entity.setUserName(null);
> entity.setUserKanaName("ユーザメイ");
> 
> // 可変となるSQL文の組み立て
> // prepareParameterizedSqlStatementを呼び出し時に、検索条件を持つオブジェクトを指定することで、SQL文の組み立てが行われる。
> ParameterizedSqlPStatement sqlPStatement = dbConnection.prepareParameterizedSqlStatement(
>           "SELECT "
>             + "USER_ID, "
>             + "USER_NAME, "
>             + "USER_KANA_NAME "
>         + "FROM "
>             + "USER_MST "
>         + "WHERE "
>             + "$if(userName)         {user_name      LIKE :userName%} "
>             + "AND $if(userKanaName) {user_kana_name LIKE :userKanaName%} ", entity);
> 
> // 検索条件を持つオブエジェクトを指定してSQL文の実行
> SqlResultSet resultSet = sqlPStatement.retrieve(entity);
> System.out.println("resultSet = " + resultSet);
> ```

> **本機能を使用せずに従来のJDBC標準機能の実装(この実装は、上記の本機能を使用した場合の実装と同義である)**
> SQL文の組み立てを各プログラムで行う必要があり可読性が非常に悪くなる。

> ```java
> String userName = null;
> String userKanaName = "ユーザメイ";
> 
> // 固定部分のSQL文
> StringBuffer sql = new StringBuffer(
>         "SELECT "
>           + "USER_ID, "
>           + "USER_NAME, "
>           + "USER_KANA_NAME "
>       + "FROM "
>           + "USER_MST ");
> 
> // 可変となるSQL文の組み立て
> // 入力のある項目のみ絞り込み条件に設定する。
> boolean first = true;
> if (userName != null && userName.length() != 0) {
>     sql.append(" WHERE USER_NAME LIKE ? ESCAPE '\\'");
>     first = false;
> }
> 
> if (userKanaName != null && userKanaName.length() != 0) {
>     sql.append(first ? " WHERE " : " AND ").append("USER_KANA_NAME LIKE ? ESCAPE '\\'");
>     first = false;
> }
> 
> // バインド変数に入力された値を設定する。
> // 入力されてた項目のみ値の設定をする。
> SqlPStatement statement = dbConnection.prepareStatement(sql.toString());
> int index = 0;
> if (userName != null && userName.length() != 0) {
>     statement.setObject(++index, userName);
> }
> if (userKanaName != null && userKanaName.length() != 0) {
>     statement.setObject(++index, userKanaName);
> }
> ```

### データベーストランザクションのタイムアウト機能

本機能は、データベースアクセスに該当トランザクションがトランザクションの有効期限内（トランザクションがタイムアウトしていないこと）のチェックを行う機能を提供する。
この機能は、以下のメリットがある。

この機能は、データベースアクセスで処理遅延(データベースのロック解放待ちやSQL文の応答待ちなど)が発生し、
トランザクションの有効期限を過ぎた場合に、トランザクションタイムアウトが発生したことを示す例外を送出する。
これにより、処理遅延の発生した業務処理は強制的に終了されるため、遅延した処理が大量に残存することを防止できる。

特に画面処理で本機能を適用した場合、Web Application Server上のデータベース接続プールやリクエスト要求を処理するスレッドが枯渇 [1] することを防ぐことが出来る。

データベース接続プールなどが枯渇すると、クライアントからの処理要求はプールの解放待ちとなり、処理遅延が発生した業務処理が終了するまで後続のリクエストは全て待機状態となる。

### SQLクエリ結果のキャッシュ

本機能は、SQLクエリ結果のキャッシュを行う。
SQL IDとパラメータが等価である参照系クエリに対して、キャッシュした結果を返却できる（DBアクセスが発生しない）。

本機能を適用できるクエリには制限がある。詳細は、 [SQLクエリ結果のキャッシュ](../../component/libraries/libraries-04-QueryCache.md) を参照。

## 注意点

### データベース接続のプール機能について

本機能では、データベース接続のプール機能は提供しない。
各プロジェクトでプール機能を使用したい場合には、下記のプール機能の有効化方法を参照し、プールの有効化作業を行うこと。

**プール機能の有効化方法**

a) JNDI接続を使用する場合

Webアプリケーションサーバに設定するデータベース接続のプール機能を有効にする。
データベース接続の登録方法、プールの設定方法は、Webアプリケーションサーバのマニュアルを参照すること。

b) DataSource接続を使用する場合

プール機能を有するDataSource実装クラスを使用する。

> **Note:**
> 例えばデータベースがOracleの場合、「oracle.jdbc.pool.OracleDataSource」や「oracle.ucp.jdbc.PoolDataSourceImpl」を使用して
> プール用のプロパティを設定することにより、プール機能を使用することができる。

> **Attention:**
> データベースベンダーによっては、プール機能を有するDataSourceが提供されていない可能性がある。詳細は各データベースベンダーのJDBCマニュアルを参照すること。

### SQLインジェクション対策について

一般的にSQLインジェクションに対する対策は、PreparedStatementを使用して入力値 [2] をバインド変数化することと言われている。
ただし、この対策は各アプリケーションプログラマにルールを徹底させるものであり、対策としては不十分である。
例えば、 [SQLインジェクションの脆弱性を含んだ実装](../../component/libraries/libraries-04-DbAccessSpec.md#sql-injection-logic) を業務ロジック内で行われた場合、問題を検出することが非常に困難である。

この問題への対策として、本機能ではSQL文を外部ファイルに記述する機能を提供する。
SQL文の外部化機能を使用した場合、業務ロジックではSQL文を参照することができないため、SQL文と入力値 [2] とを文字列連結することを完全に防止することができる。
これにより、アプリケーションプログラマが [SQLインジェクションの脆弱性を含んだ実装](../../component/libraries/libraries-04-DbAccessSpec.md#sql-injection-logic) を行うことを防ぐことができ、
SQLインジェクション対策として最も有効な手段となる。

※業務ロジックでSQL文実行時に使用する値は、SQL文ではなくSQL文を一意に識別するためのIDとなっている。

* SQL文を外部ファイルに記述した場合の例

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

詳細は、 [推奨するJavaの実装例(SQL文を外部ファイル化した場合)](../../component/libraries/libraries-04-Statement.md#sql-gaibuka-label) を参照すること。

* SQLインジェクションの脆弱性を含んだ実装の例

  > **Warning:**
> このような実装は、SQLインジェクションの可能性があるためすべきではない。

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

入力値とは、ユーザ入力値や外部システムからの連携データの事である。

## 要求

### 実装済み

* データベースへの接続ができる。
* SQL文の実行ができる。
* SQL文の実行ログの出力ができる。
* 各種リソース(Connection、Statement、ResultSet)の解放ができる。
* バイナリ(LOBやBYTE型)型の検索、更新ができる。
* プリフェッチ(SQLStatement#setFetchSize)ができる。
* バッチ更新(SQLStatement#addBatch)ができる。
* 重複エラー等をアプリケーションでハンドリングできる。
* 共通項目(最終更新者、最終更新日時など)に設定する値を、自動で設定できる。
* 条件が可変の場合のSQL文が生成できる。

  * IN句の項目数が可変の場合のSQL文が生成できる。
* LIKE検索時のエスケープ処理ができる。
* SQL文を外部ファイルなどに定義でき、Javaコードとは分離できる。
* データベースアクセス時にトランザクションタイムアウトチェックができる。

### 未実装

* PL/SQLの実行ができる。
* 1トランザクション内でのSQL文の実行回数がチェックできる。
* テーブル更新順序がチェックできる。
* テーブル更新順序に違反した場合の振る舞い(警告または例外)が指定できる。
* SQL文の実行ログを指定機能(リクエストID)のみ出力する事ができる。
* データベース接続パスワードを暗号化して管理できる。

## 全体構造

### クラス図

本機能の全体構造図。各クラスの責務については、以降の章で解説を行う。

![DbAccessSpec_AllClassDesign.jpg](../../../knowledge/assets/libraries-04-DbAccessSpec/DbAccessSpec_AllClassDesign.jpg)

## 各機能単位の構造

04/04_Connection
04/04_Statement
04/04_ObjectSave
04/04_TransactionTimeout
04/04_QueryCache
