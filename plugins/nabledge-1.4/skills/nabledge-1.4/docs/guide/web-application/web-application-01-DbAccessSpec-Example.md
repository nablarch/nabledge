# データベースアクセス実装例集

## 本ページの構成

本ページでは以下の実装例を説明する。

* [基本的な実装](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#basic-implementation)
* [簡易検索機能](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#simple-search)

  * [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label)
  * [範囲指定での検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#range-search)
  * [取得したSqlResultSetの使用方法](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#how-to-use-sql-result-set)
* [大量データの検索機能](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#executequery-label)
* [更新(insert、update、delete)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#insert-update-delete)

  * [1件のデータを更新する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#update-single-data)
  * [複数件を一括で更新する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#executebatch-label)
* [バイナリデータへのアクセス](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#access-to-binary-data)

  * [バイナリデータの検索方法](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#searching-binary-data)
  * [バイナリデータの登録方法](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#insert-binary-data)
  * [ファイルの内容をバイナリデータとして登録する方法](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#insert-file-data-as-binary-data)
  * [バイナリデータをファイルとして出力する方法](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#generate-binary-file)
* [オブジェクトのフィールドの値の登録機能(オブジェクト(Form)編)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#db-object-save-samole)

  * [1件のデータを更新する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#update-single-data-by-object)
  * [複数件を更新する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#update-multiple-data-by-object)
* [オブジェクトのフィールドの値の登録機能(Mapのサブクラス編)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#map-save-label)

  * [1件のデータを更新する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#update-single-data-by-map)
  * [複数件を更新する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#update-multiple-data-by-map)
* [オブジェクトのフィールドの値の検索機能(オブジェクト(Form)編)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#object-select-label)

  * [簡易検索機能を使用する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#using-simple-search)
  * [like条件をもつ簡易検索の場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#using-simple-search-having-like-conditions)
  * [可変条件のSQLの場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#variable-condition-sql-label)
  * [IN句の条件が動的に変わる場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#changing-dynamically-in)
  * [ORDER BY句を動的に変更する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#changing-dynamically-order-by)
  * [大量データを検索する場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#serching-for-mass-data)
* [オブジェクトのフィールドの値の検索機能(Mapのサブクラス編)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#map-search-label)

## 基本的な実装

データベースアクセスを行うクラスは、本フレームワークにて提供されるDbAccessSupportクラスを継承して作成する。
本実装例集は、DbAccessSupportを継承していることが前提となっている。

* 実装例

  ```java
  package nablarch.sample.ss11AC;
  
  import nablarch.core.db.support.DbAccessSupport;
  
  /**
   * ユーザ登録に関する業務共通コンポーネントクラス<br/>
   *
   * @author Tsuyoshi Kawasaki
   * @since 1.0
   */
  // 【説明】DbAccessSupportクラスを継承して、データベースアクセスクラスを作成する。
  public class CM311AC1Component extends DbAccessSupport {
  }
  ```

> **Note:**
> 継承モデルを使用しない場合(別のスーパークラスを継承する必要があり、DbAccessSupportを継承出来ない場合)は、
> 下記例のようにDbAccessSupportをインスタンス化して使用すること。

> ```java
> // 【説明】
> // 自身のクラスオブジェクトをコンストラクタに指定して
> // DbAccessSupportを取得する。
> DbAccessSupport support = new DbAccessSupport(getClass());
> ```

> > **Warning:**
> > 継承モデルを使用しない場合で、デフォルトコンストラクタ(引数なしコンストラクタ)を使用した場合、
> > SQL実行クラスに対応するSQLファイルを特定することができず、実行時エラーとなるため注意すること。

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

## 簡易検索機能

検索処理では、基本的に簡易検索機能を使用する。
簡易検索機能を使用すると、検索結果が *SqlResultSet* オブジェクトに格納されて返却される。

> **SqlResultSetとは:**
> *SqlResultSet* は、 *java.sql.ResultSet* と比較して簡易的に扱えるオブジェクトとなっている。
> 主に、以下の利点がある。

> * >   リソース解放(close処理)を実装する必要がない
> * >   取得レコード数がわかる

> **簡易検索結果のイメージ**

> ![DbAccessSpec_SampleSqlResultSet.jpg](../../../knowledge/assets/web-application-01-DbAccessSpec-Example/DbAccessSpec_SampleSqlResultSet.jpg)

> **Warning:**
> 大量データ [1] を簡易検索機能で取得すると、大量にメモリを消費しOutOfMemoryErrorが発生する可能性がある。
> このため大量データを取得する場合は、簡易検索機能ではなく [大量データの検索機能](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#executequery-label) を使用してデータ取得を行うこと。

大量データの取得とは、SELECT文の結果として取得されるデータ件数(検索対象のテーブルの件数ではない)が大量であることをさす。

> **例:**
> ```java
> // 大量データの取得に該当する例
> statement.retrieve();                // この結果返却されるSqlResultSetのサイズが多い場合は、大量データとなる。
> statement.retrieve(1, 10000000);     // 取得件数に1千万件を指定しているため、SqlResultSetのサイズが最大で1千万件となるため、大量データとなる。
> 
> // 大量データに該当しない例
> statement.retrieve(10000000, 20);    // 取得開始位置は1千万であるが、取得最大件数に20件を指定しているため(SqlResultSetのサイズは最大で20件のため)、大量データの取得とはならない。
> ```

### 条件に紐付くデータの全件検索処理

*SqlPStatement#retrieve()* を呼び出して、条件に紐付くデータを全件取得する。

* SQLファイルの内容

ファイル名:nablarch/sample/ss11AC/CM311AC1Component.sql

```sql
-- 【説明】SQLファイル内へのSQL文の記述ルール
-- a) SQL_IDとSQL文の1グループは、空行で区切られて記述されている。
--
--    1つのSQL文の中に空行はいれてはならない。
--    また、異なるSQL文との間には必ず空行を入れなくてはならない。
--    コメント行は、空行とはならない。
--
-- b) 1つのSQL文の最初の「=」までがSQL_IDとなる。
--
--    SQL_IDとは、SQLファイル内でSQL文を一意に特定するためのIDである。
--    SQL_IDには、任意の値を設定することが可能となっている。
--
-- c) コメントは、「--」で開始されている必要がある。
--
--    「--」以降の値は、コメントとして扱い読み込まない。
--
-- d) SQL文の途中で改行を行っても良い。また、可読性を考慮してスペースやtabなどで桁揃えを行っても良い。

--------------------------
-- ユーザ情報を取得用
-- SQL_ID:GET_USER_INFO
--------------------------
GET_USER_INFO =
SELECT
    USER_ID,
    USER_NAME,
    USER_NAME_KANA,
    TEL,
    MAIL_ADDRESS
FROM
    USER_MST
WHERE
    USER_ID = ?
ORDER BY
    USER_ID
```

* Javaの実装

```java
package nablarch.sample.ss11AC;

public class CM311AC1Component extends DbAccessSupport {

    public SqlResultSet getUserInfo(String userId) {

        // 【説明】SQL_IDを指定してStatementを取得する。
        // 上記SQLファイル(nablarch/sample/ss11AC/CM311AC1Component.sql)のSQL_ID:GET_USER_INFOのSQLを元にStatementが生成される。
        SqlPStatement statement = getSqlPStatement("GET_USER_INFO");

        // 【説明】JDBC標準機能と同じように、バインド変数に条件を設定する
        // 【説明】インデックスは、0からではなく1から開始する（java.sql.PreparedStatementと同様）。
        statement.setString(1, "00001");

        // 【説明】簡易検索機能のretrieveメソッドを使用して検索を行う
        SqlResultSet resultSet = statement.retrieve();
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

### 範囲指定での検索処理

*SqlPStatement#retrieve(int, int)* を呼び出して、対象範囲のデータを取得する。

* SQLファイルの内容

ファイル名:nablarch/sample/ss11AC/CM311AC1Component.sql

```sql
--------------------------
-- ユーザ一覧を取得用
-- SQL_ID:GET_USER_LIST
--------------------------
GET_USER_LIST =
SELECT
    USER_ID,
    USER_NAME,
    USER_NAME_KANA,
    TEL,
    MAIL_ADDRESS
FROM
    USER_MST
ORDER BY
    USER_ID
```

* Javaの実装

```java
package nablarch.sample.ss11AC;

public class CM311AC1Component extends DbAccessSupport {

    public SqlResultSet getUserInfo(int startPos, String userId) {

        // 【説明】SQL_IDを指定してStatementオブジェクトを取得する。
        SqlPStatement statement = getSqlPStatement("GET_USER_LIST");

        // 【説明】retrieveメソッドに開始位置と取得件数を指定して実行する。
        return statement.retrieve(startPos, 20);

    }
}
```

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

### 取得したSqlResultSetの使用方法

```java
SqlResultSet resultSet = statement.retrieve();

// 【説明】取得したSqlResultSetをループして全件処理を行う
for (SqlRow row : resultSet) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
    String userNameKana = row.getString("USER_NAME_KANA");
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

*SqlResultSet* には、レコードを表す *SqlRow* クラスが格納されており、ここからカラムの値を取り出すことができる。
SqlRowから値を取り出す際には、カラム名やJavaBeansのプロパティ命名規約に準じた名称を指定する。
例えば、 `USER_ID` というカラム名であれば、 `USER_ID` だけでなく、 `userId` という指定でも値が取得できる。

この機能を使用することにより、JSPでDB検索結果行( *SqlRow* )とJavaオブジェクトを透過的に扱うことができる。

```jsp
<table>
    <tr>
        <th>ユーザID</th>
        <th>ユーザ氏名</th>
        <th>ユーザカナ氏名</th>
    </tr>
    <c:forEach var="row" items="${searchResult}">
       <tr>
           <%-- 【説明】 次の行は <td><n:write name="row['USER_ID']" /></td> と等価 --%>
           <td><n:write name="row.userId" /></td>
           <td><n:write name="row.userName" /></td>
           <td><n:write name="row.kanaName" /></td>
       </tr>
   </c:forEach>
</table>
```

上記の例では、変数 *searchResult* の中身が、DB検索結果( *SqlResultSet* )であっても、
Javaオブジェクトを格納したリストであっても同じように動作する。

## 大量データの検索機能

大量データを取得 [2] する場合は、簡易検索機能ではなく本機能を使用してデータの検索処理を行う。

大量データ取得用メソッド( *executeQuery* )を使用した場合であっても、簡易検索と同じようにデータベースからの検索結果を簡易的に扱えるオブジェクトを返却する。
このため、アプリケーションではJDBCで提供される機能を使用することなく、データの取得を行うことができる。

詳細は、下記の実装例を参照すること。

大量データの取得とは、SELECT文の結果として取得されるデータ件数(検索対象のテーブルの件数ではない)が大量であることをさす。

> **例:**
> ```java
> // 大量データの取得に該当する例
> statement.retrieve();                // この結果返却されるSqlResultSetのサイズが多い場合は、大量データとなる。
> statement.retrieve(1, 10000000);     // 取得件数に1千万件を指定しているため、SqlResultSetのサイズが最大で1千万件となるため、大量データとなる。
> 
> // 大量データに該当しない例
> statement.retrieve(10000000, 20);    // 取得開始位置は1千万であるが、取得最大件数に20件を指定しているため(SqlResultSetのサイズは最大で20件のため)、大量データの取得とはならない。
> ```

* SQLファイルの内容

  ファイル名:nablarch/sample/ss11AC/CM311AC1Component.sql

  ```sql
  --------------------------
  -- ユーザ一覧を取得用
  -- SQL_ID:GET_ALL_USER
  --------------------------
  GET_ALL_USER =
  SELECT
      USER_ID,
      USER_NAME,
      USER_NAME_KANA,
      TEL,
      MAIL_ADDRESS
  FROM
      USER_MST
  ORDER BY
      USER_ID
  ```
* Javaの実装

```java
package nablarch.sample.ss11AC;

public class CM311AC1Component extends DbAccessSupport {

    public ResultSetIterator getAllUser() {

        // 【説明】SQL_IDを指定してStatementオブジェクトを取得する。
        SqlPStatement statement = getSqlPStatement("GET_ALL_USER");

        statement.setString(1, "00001");

        // 【説明】executeQueryを呼びだすと、ResultSetIteratorが返却される
        return statement.executeQuery();

    }
}

// 【説明】ResultSetIteratorの使用例
//  ResultSetIteratorは、Iterableを実装しているため、簡易for文(for-each)を使用することが可能
for (SqlRow row : rs) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

> **Warning:**
> ResultSetIterator#iteratorの呼び出しは、複数回行うことができないため注意すること。

> 【NGとなる実装パターン】

> ```java
> // 【説明】iteratorメソッドを2回呼び出しているためNG
> ResultSetIterator rs = statement.executeQuery();
> rs.iterator();
> rs.iterator();
> 
> // 【説明】2回目のfor文で、2回目のiterator呼び出しが行われるため、NG
> ResultSetIterator rs = statement.executeQuery();
> for (SqlRow row : rs) {
>     // 【説明】処理
> }
> 
> for (SqlRow row : rs) {
>     // 【説明】処理
> }
> ```

> ( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

## 更新(insert、update、delete)

### 1件のデータを更新する場合

* SQLファイルの内容

ファイル名:nablarch/sample/ss11AC/CM311AC1Component.sql

```sql
--------------------------
-- ユーザ一登録用
-- SQL_ID:REGISTER_USER
--------------------------
REGISTER_USER =
INSERT INTO
    USER_MST
    (
    USER_ID,
    USER_NAME,
    USER_NAME_KANA,
    TEL,
    MAIL_ADDRESS
    )
VALUES
    (
    ?,
    ?,
    ?,
    ?,
    ?
    )

--------------------------
-- ユーザ一更新用
-- SQL_ID:UPDATE_USER_NAME
--------------------------
UPDATE_USER_NAME =
UPDATE
    USER_MST
SET
    USER_NAME = ?
WHERE
    USER_ID = ?
```

* Java実装

```java
package nablarch.sample.ss11AC;

public class CM311AC1Component extends DbAccessSupport {

    // 【説明】登録処理の例
    public void registerUser(String userId, String userName, String userNameKana,
            String tel, String mailAddress) {

        // 【説明】SQL_IDを指定してStatementオブジェクトを取得する。
        SqlPStatement statement = getSqlPStatement("REGISTER_USER");

        statement.setString(1, userId);
        statement.setString(2, userName);
        statement.setString(3, userNameKana);
        statement.setString(4, tel);
        statement.setString(5, mailAddress);
        statement.executeUpdate();
    }

    // 【説明】更新処理の例
    public void updateUserName(String userId, String userName) {

        SqlPStatement updateStatement = getSqlPStatement("UPDATE_USER_NAME");
        updateStatement.setString(1, userName);
        updateStatement.setString(2, userId);

        int updCnt = updateStatement.executeUpdate();

        if (updCnt != 1) {
            // 更新対象が存在しない場合は、対象なしエラーを表示する
        }
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

### 複数件を一括で更新する場合

JDBCで提供されるバッチ実行機能( *executeBatch* )と同等の機能を使用した一括更新の実装例。

同一テーブルへの更新(insert、update、delete)を繰り返し行う場合には、バッチ更新機能を使用すること。
この機能を使用すると、データベースサーバとのラウンドトリップ回数を削減でき、性能改善が期待できる。

> **Warning:**
> 下記実装例にあるように、大量のデータを一括で更新する場合には、適宜executeBatchを呼び出すこと。
> この処理を行わないと、メモリ不足が原因でOutOfMemoryErrorが発生したり、gcが頻発し逆に性能劣化の原因となることがある。

* SQLファイルの内容

ファイル名:nablarch/sample/ss11AC/CM311AC1Component.sql

```sql
--------------------------
-- ユーザ一括登録用
-- SQL_ID:REGSITER_ALL_USER
--------------------------
REGSITER_ALL_USER =
INSERT INTO
    USER
    (
    ID,
    NAME
    )
VALUES
    (
    ?,
    ?
    )
```

* Java実装

```java
package nablarch.sample.ss11AC;

public class CM311AC1Component extends DbAccessSupport {

    // 1回のexecuteBatchで更新する最大の件数
    private static final int BATCH_EXECUTE_MAX_CNT = 1000;

    // 【説明】本実装例では、更新対象のデータを作成する処理は省略している
    public void registerAllUser(List<Map<String, ?>> users) {

        // 【説明】SQL_IDを指定してStatementオブジェクトを取得する。
        SqlPStatement batch = getSqlPStatement("REGSITER_ALL_USER");

        // バッチ更新による一括登録
        for (Map<String, ?> user : users) {
            batch.setObject(1, user.get("ID"));
            batch.setObject(2, user.get("NAME"));
            batch.addBatch();

            // 1000件単位で実行
            if (batch.getBatchSize() == BATCH_EXECUTE_MAX_CNT) {
                batch.executeBatch();
            }
        }

        // 残りのデータがある場合には、実行
        if (batch.getBatchSize() != 0) {
            batch.executeBatch();
        }

    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

## バイナリデータへのアクセス

データベースのデータタイプがバイナリ型(BLOBやbyte)の場合の参照、更新方法の実装例

* SQLファイルの内容

本章で使用するSQL文は、全て下記SQLファイルに記述している。

ファイル名:nablarch/sample/ss11AC/CM311AC1Component.sql

```sql
--------------------------
-- パスワード取得用
-- SQL_ID:GET_PASSWORD
--------------------------
GET_PASSWORD =
SELECT
    PWD
FROM
    USER_MST
WHERE
    USER_ID = ?

--------------------------
-- パスワード更新用
-- SQL_ID:UPDATE_PASSWORD
--------------------------
UPDATE_PASSWORD =
UPDATE
    USER_MST
SET
    PWD = ?
WHERE
    USER_ID = ?

--------------------------
-- PDF更新用
-- SQL_ID:UPDATE_PDF
--------------------------
UPDATE_PDF =
UPDATE
    PDF_LIST
SET
    PDF_DATA = ?
WHERE
    USER_ID = ?

--------------------------
-- PDF取得用
-- SQL_ID:GET_PDF
--------------------------
GET_PDF =
SELECT
    PDF_DATA
FROM
    PDF_LIST
WHERE
    USER_ID = ?
```

### バイナリデータの検索方法

* Java実装

```java
package nablarch.sample.ss11AC;

public class CM311AC1Component extends DbAccessSupport {

    public byte[] getPassword(String userId) {

        // 【説明】SQL_IDを指定してStatementオブジェクトを取得する。
        SqlPStatement select = getSqlPStatement("GET_PASSWORD");

        select.setString(1, userId);
        SqlResultSet rs = select.retrieve();

        SqlRow row = rs.get(0);

        // 【説明】バイナリデータは、SqlRow#getBytesで取得する。
        return row.getBytes("pwd");
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

> **Warning:**
> 本実装例は、getBytesメソッドでバイナリデータを一括で取得しているが、ファイルデータのようにデータ量が大きい場合には、 [バイナリデータをファイルとして出力する方法](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#generate-binary-file) の実装例にしたがうこと。

### バイナリデータの登録方法

```java
SqlPStatement statement = getSqlPStatement("UPDATE_PASSWORD");

statement.setBytes(1, pwd);
statement.setString(2, "00001");
int updNo = statement.executeUpdate();
```

> **Warning:**
> 本実装例は、setBytesを使用してバイナリデータの設定しているが、データベースベンダーによってはsetBytesをサポートしない場合がある。
> どのsetメソッドを使用すればよいかは、データベースベンダーのJDBCマニュアルを参照すること。

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

### ファイルの内容をバイナリデータとして登録する方法

```java
SqlPStatement statement = getSqlPStatement("UPDATE_PDF");

File file = new File("hoge.pdf");
FileInputStream fis = new FileInputStream(file);

try {
    // 【説明】setBinaryStream(int, InputStream, int)を使用してファイルのストリームをバインド変数に設定
    statement.setBinaryStream(1, fis, (int) file.length());
    statement.setString(2, "00001");
    statement.executeUpdate();
} finally {
    fis.close();
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

> **Warning:**
> 上記実装例は、 *java.io* パッケージを使用した実装となっている。
> この実装は、リソースの開放漏れなどが発生する可能性があり、アプリケーションプログラマが実装することは推奨しない。

> 必要な場合には、アーキテクトがコンポーネントを作成するなどして対処すること。

### バイナリデータをファイルとして出力する方法

```java
SqlPStatement select = getSqlPStatement("GET_PDF");

select.setString(1, "00001");
SqlResultSet rs = select.retrieve();

// 【説明】データベースからBlobとしてデータを取得する。
Blob fileData = (Blob) rs.get(0).get("PDF_DATA");

InputStream pdfData = null;
FileOutputStream output = null;
try {
    // 【説明】Blobデータからストリームを取得し、バイナリデータを読み込む
    pdfData = fileData.getBinaryStream();

    // 【説明】出力ファイルを開く
    output = new FileOutputStream("hoge.pdf");

    byte[] b = new byte[1024];
    int size = 0;
    while ((size = pdfData.read(b)) != -1) {
        output.write(b, 0, size);
        output.flush();
    }
} finally {
    try {
        if (pdfData != null) {
            pdfData.close();
        }
    } finally {
        if (output != null) {
            output.close();
        }
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Warning:**
> 上記実装例は、 *java.io* パッケージを使用した実装となっている。
> この実装は、リソースの開放漏れなどが発生する可能性があり、アプリケーションプログラマが実装することは推奨しない。

> 必要な場合には、アーキテクトがコンポーネントを作成するなどして対処すること。

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

## オブジェクトのフィールドの値の登録機能(オブジェクト(Form)編)

オブジェクトのフィールドの値を登録する際の実装例

画面処理の場合で、精査済みリクエストパラメータの値をJavaBeansで保持している場合には、本機能を使用することにより実装ステップ数を軽減することができる。

* SQLファイルの内容

本章で使用するSQL文は、全て下記SQLファイルに記述している。

ファイル名:nablarch/sample/ss11AE/CM211AE1Component.sql

```sql
--------------------------
-- 売上登録
-- SQL_ID:REGISTER_SALES
--------------------------
--【説明】指定するSQL文のバインド変数部分には、「?」を設定するのではなく、
-- 「:」＋「オブジェクトのフィールド名」とすること。
REGISTER_SALES =
INSERT INTO
    SALES
    (
    CST_ID,
    KINGAKU,
    INS_DATE_TIME,
    INS_USER_ID,
    UPD_DATE_TIME,
    UPD_USER_ID,
    EXECUTION_ID,
    REQUEST_ID
    )
VALUES
    (
    :cstId,
    :kingaku,
    :insDateTime,
    :insUserId,
    :updDateTime,
    :updUserId,
    :executionId,
    :requestId
    )

--------------------------
-- 売上更新
-- SQL_ID:UPDATE_SALES
--------------------------
--【説明】指定するSQL文のバインド変数部分には、「?」を設定するのではなく、
-- 「:」＋「Mapのキー名」とすること。
UPDATE_SALES =
UPDATE
    SALES
SET
    KINGAKU = :KINGAKU
WHERE
    CST_ID = :CST_ID
```

### 1件のデータを更新する場合

下記実装例はinsert文となっているが、update文やdelete文でも同じように実装することができる。

```java
// オブジェクト実装
public class W11AE01Form {
    // 顧客ID
    private String cstId;

    // 金額
    private long kingaku;

    // 登録日時
    @CurrentDateTime(format="yyyyMMddHHmmss")
    private String insDateTime;

    // 登録ユーザID
    @UserId
    private String insUserId;

    // 更新日時
    @CurrentDateTime(format="yyyyMMddHHmmss")
    private String updDateTime;

    // 更新ユーザID
    @UserId
    private String updUserId;

    // リクエストID
    @RequestId
    private String requestId;

    // 【説明】本来はここに各フィールド項目のアクセスメソッドを定義する。

}

public void doRW11AE0101() {
    // 【説明】オブジェクトを生成し、自動設定項目以外を設定する。
    W11AE01Form form = new W11AE01Form();
    form.setCstId("0001");
    form.setKingaku(100);

    CM211AE1Component component = new CM211AE1Component();
    component.registerSales(form);
}

package nablarch.sample.ss11AE;

public class CM211AE1Component extends DbAccessSupport {

    public void registerSales(W11AE01Form form) {

        // 【説明】SQL_IDを指定して、Statementオブジェクトを取得する。
        ParameterizedSqlPStatement insert = getParameterizedSqlStatement("REGISTER_SALES");

        // 【説明】executeUpdateByObjectを呼び出してオブジェクトのフィールドの値を登録する。
        insert.executeUpdateByObject(form);
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

### 複数件を更新する場合

複数件を一括で更新する場合の注意点は、 [JDBC標準機能](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#executebatch-label) と同じである。

```java
// 1回のexecuteBatchで更新する最大の件数
private static final int BATCH_EXECUTE_MAX_CNT = 1000;

// 【説明】本実装例では、更新対象のデータを作成する処理は省略している

ParameterizedSqlPStatement insert = getParameterizedSqlStatement("REGISTER_SALES");

for (W11AE02Form form : forms) {
    statement.addBatchObject(form);
    if (insert.getBatchSize() == BATCH_EXECUTE_MAX_CNT) {
        insert.executeBatch();
    }
}
if (insert.getBatchSize() != 0) {
    insert.executeBatch();
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

## オブジェクトのフィールドの値の登録機能(Mapのサブクラス編)

### 1件のデータを更新する場合

```java
// 登録対象のMapを生成する。
Map<String, Object> sales = new HashMap<String, Object>();
sales.put("CST_ID", "00001");
sales.put("KINGAKU", "200");

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("UPDATE_SALES");
int updCnt = statement.executeUpdateByMap(sales);
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

### 複数件を更新する場合

複数件を一括で更新する場合の注意点は、 [JDBC標準機能](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#executebatch-label) と同じである。

```java
// 1回のexecuteBatchで更新する最大の件数
private static final int BATCH_EXECUTE_MAX_CNT = 1000;

// 【説明】本実装例では、更新対象のデータを作成する処理は省略している

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("UPDATE_SALES");

for (Map<String, ?> sales : salesList) {
    statement.addBatchMap(sales);
    if (statement.getBatchSize() == BATCH_EXECUTE_MAX_CNT) {
        statement.executeBatch();
    }
}
if (statement.getBatchSize() != 0) {
    statement.executeBatch();
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

## オブジェクトのフィールドの値の検索機能(オブジェクト(Form)編)

オブジェクトのフィールドの値を使用してデータを検索する際の実装例。

* SQLファイルの内容

本章で使用するSQL文は、全て下記SQLファイルに記述している。

ファイル名:nablarch/sample/ss11BB/CM211BB1Component.sql

```sql
--------------------------
-- 取得用
-- SQL_ID:GET
--------------------------
--【説明】指定するSQL文のバインド変数部分には、「?」を設定するのではなく、
-- 「:」＋「オブジェクトのフィールド名」とすること。
GET =
SELECT
    USER_ID,
    USER_NAME
FROM
    USER_MTR
WHERE
    USER_NAME = :userName
ORDER BY
    USER_ID

--------------------------
-- 一覧取得用１
-- SQL_ID:GET_LIST1
--------------------------
-- 【説明】
-- 指定するSQL文のバインド変数部分には、「?」を設定するのではなく、「:」＋「オブジェクトのフィールド名」とすること
-- 前方一致の場合は、バインド変数名の末尾に「%」を付加する。    例：「:userName%」
-- 後方一致の場合は、バインド変数名の先頭に「%」を付加する。    例：「:%userName」
-- 部分一致の場合は、バインド変数名の前後に「%」を付加する。    例：「:%userName%」
GET_LIST1 =
SELECT
    USER_ID,
    USER_NAME
FROM
    USER_MTR
WHERE
    USER_NAME LIKE :userName%      -- 【説明】SQL文には、escape句を記述する必要はない。
ORDER BY
    USER_ID

--------------------------
-- 一覧取得用2
-- SQL_ID:GET_LIST2
--------------------------
GET_LIST2 =
SELECT
    USER_MTR.LOGIN_ID,
    USER_MTR.USER_KANJI_NAME,
    USER_MTR.USER_KANA_NAME,
    USER_MTR.GROUP_ID,
    USER_GROUP.GROUP_NAME
FROM
    USER_MTR,
    USER_GROUP
WHERE
    $if (loginId)           {USER_MTR.LOGIN_ID        =    :loginId}
    AND $if (userKanjiName) {USER_MTR.USER_KANJI_NAME LIKE :userKanjiName%}
    AND $if (userKanaName)  {USER_MTR.USER_KANA_NAME  LIKE :userKanaName%}
    AND $if (groupId)       {USER_MTR.GROUP_ID        =    :groupId}
    AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
ORDER BY
    LOGIN_ID

--------------------------
-- 一覧取得用3
-- SQL_ID:GET_LIST3
--------------------------
-- 【説明】
--  動的にIN句を生成する場合には、バインド変数名の末尾に角括弧([])を付加すること。
-- 本SQLの場合は、バインド変数名が「kengenKbn」なので「kengenKbn[]」となる。
GET_LIST3 =
SELECT
    USER_MTR.LOGIN_ID,
    USER_MTR.USER_KANJI_NAME,
    USER_MTR.USER_KANA_NAME,
    USER_MTR.GROUP_ID,
    USER_GROUP.GROUP_NAME
FROM
    USER_MTR,
    USER_GROUP
WHERE
    $if (loginId)        {USER_MTR.LOGIN_ID   = :loginId}
    AND $if (kengenKbn)  {USER_MTR.KENGEN_KBN IN (:kengenKbn[])}
    AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
ORDER BY
    LOGIN_ID

--------------------------
-- 一覧取得用4
-- SQL_ID:GET_LIST4
--------------------------
--【説明】
-- 動的にORDER BY句を変更する場合には、$sort(フィールド名) {(ケース1) (ケース2) ・・・ (ケースn)}を指定する。
GET_LIST4 =
SELECT
    USER_ID,
    USER_NAME
FROM
    USER_MTR
WHERE
    USER_NAME = :userName
$sort(sortId) {
    (1 USER_ID)
    (2 USER_ID DESC)
    (3 USER_NAME)
    (4 USER_NAME DESC)
}

--------------------------
-- 全データ取得
-- SQL_ID:GET_ALL
--------------------------
GET_ALL =
SELECT USER_ID,
    USER_NAME,
    USER_NAME_KANA,
    TEL,
    MAIL_ADDRESS
FROM
    USER_MST
WHERE
    USER_ID = :userId
ORDER BY
    USER_ID
```

### 簡易検索機能を使用する場合

オブジェクトのフィールドの値を条件として、 [簡易検索機能](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#simple-search) を使用する際の実装例

※SQL文の記述方法は、 [SQLファイル](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#object-form-retrieve-label) のSQL_ID:GETを参照すること。

```java
// オブジェクトの実装
public class W11BB01Form {
    // ユーザID
    private String userId;

    // ユーザ名
    private String userName;

    // 【説明】本来はここに各フィールドのアクセスメソッドを定義する。

}

public void doRW11BB0101() {
    // Formを生成し、検索条件を設定する。
    W11BB01Form form = new W11BB01Form();
    form.setUserName("ユーザ");

    CM211BB1Component component = new CM211BB1Component();
    component.get(form);
}

package nablarch.sample.ss11BB;

public class CM211BB1Component {

    public SqlResultSet get(W11BB01Form form) {

        // 【説明】SQL_IDを指定してStatementオブジェクトを取得する。
        ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET");

        return select.retrieve(form);
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

### like条件をもつ簡易検索の場合

検索条件にLIKE条件(部分一致検索)をもつSQL文の実装例を以下に示す。

※SQL文の記述方法は、 [SQLファイル](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#object-form-retrieve-label) のSQL_ID:GET_LIST1を参照すること。

```java
// オブジェクトの実装
public class W11BB01Form {
    // ユーザID
    private String userId;

    // ユーザ名
    private String userName;

    // 【説明】本来はここに各フィールドのアクセスメソッドを定義する。

}

// Formを生成し、検索条件を設定する。
W11BB01Form form = new W11BB01Form();
form.setUserName("ユーザ");       // 【説明】like条件の項目であっても、escape処理を行う必要はない。

ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST1");
SqlResultSet rs = select.retrieve(form);
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

> **Note:**
> 上記実装で、実際に実行されるSQL文

> アプリケーションで定義したSQL文
> SELECT USER_ID,       USER_NAME  FROM USER_MTR WHERE USER_NAME LIKE :userName% ORDER BY USER_ID
> データベースに対して実行されるSQL文(バインド変数名が置き換えられ、escape句が自動で付加される。
> SELECT USER_ID,       USER_NAME  FROM USER_MTR WHERE USER_NAME LIKE ? ESCAPE '\' ORDER BY USER_ID
> バインド変数にセットされる値
> 1(:userName)     =   [ユーザ%]

> **Warning:**
> 後方、部分一致検索は、顧客要件で回避不可能である場合に、顧客と下記デメリットを合意した上で使用すること。

> デメリットの内容:

> ```
> 後方、部分一致検索では、インデックスが使用されずにテーブルフルスキャンとなるため、極端な性能劣化が発生する。
> ```

### 可変条件のSQLの場合

下記の検索画面で、全ての条件が任意項目の場合を例に実装例を説明する。(前提として、どれか１つは入力されていないとSQL文は実行されないこととする。)

※SQL文の記述方法は、 [SQLファイル](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#object-form-retrieve-label) のSQL_ID:GET_LIST2を参照すること。

![DbAccessSpec_variable_condition.jpg](../../../knowledge/assets/web-application-01-DbAccessSpec-Example/DbAccessSpec_variable_condition.jpg)

```java
// オブジェクトの実装
public class W11BB02Form {
    /** ログインID */
    private String loginId;
    /** 漢字氏名 */
    private String userKanjiName;
    /** カナ氏名 */
    private String userKanaName;
    /** グループID */
    private String groupId;

}

// 【説明】SQL文と条件が設定されたオブジェクトを指定して、ParameterizedSqlPStatementを生成する。
ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST2", user);

// 【説明】条件が設定されたオブジェクトを引数にSQL文を実行する。
SqlResultSet rs = select.retrieve(user);
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

上記コードを実行した場合で、カナ氏名のみ入力がある場合の実行されるSQL文は下記の形式となる。

```sql
SELECT USER_MTR.LOGIN_ID
       USER_MTR.USER_KANJI_NAME,
       USER_MTR.USER_KANA_NAME,
       USER_MTR.GROUP_ID,
       USER_GROUP.GROUP_NAME
  FROM USER_MTR,
       USER_GROUP
 WHERE (0 = 0 OR (USER_MTR.LOGIN_ID        =    ?))             -- ログインIDは、未入力のため(0 = 0)が評価され、「user_mtr.login_id        =    ?」は評価されない。
   AND (0 = 0 OR (USER_MTR.USER_KANJI_NAME LIKE ? ESCAPE '\'))  -- 漢字氏名は、未入力のため(0 = 0)が評価され、「user_mtr.user_kanji_name like ? escape '\'」は評価されない。
   AND (0 = 1 OR (USER_MTR.USER_KANA_NAME  LIKE ? ESCAPE '\'))  -- カナ氏名は、入力ありのため(0 = 1)は評価されず、「user_mtr.user_kana_name  like ? escape '\'」が評価される。
   AND (0 = 0 OR (USER_MTR.GROUP_ID        =    ?))             -- グループIDは、未入力のため(0 = 0)が評価され、「user_mtr.group_id        =    ?」は評価されない。
   AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
 ORDER BY LOGIN_ID
```

> **Warning:**
> 可変条件をもつSQL文の使用は、Webアプリケーションでのみ使用すること。

> バッチ処理では、インプットデータであるファイルやデータベースのレイアウトが明確であるため、必ず条件が固定となるSQLを使用すること。
> バッチ処理で可変条件となるSQL文を使用した場合、条件のカラムに作成されているインデックスが最適に使用されず、性能劣化の原因となることがある。

> **Warning:**
> 可変条件の書式には一部制限がある。
> 以下が制限事項となる。実装時には、以下の制限に該当しないよう注意すること。

> * >   $ifを入れ子にする。
>   下記のように$ifをネストさせることはできない。
>   $if(userName) {USER_NAME = :userName $if(UserId) {USER_ID = :userId}}
> * >   or条件を使用する。
>   本機能では、未入力の場合条件に「0 = 0 or」を付加して本来評価すべき条件式を評価しない方式を採用している。
>   例えば下記条件式があった場合、本来はuser_idを評価すべきであるが、user_nameが未入力であるため「(0 = 0 or (user_name = ?))」の結果が
>   trueとなりuser_idを評価せずに全レコードが条件に一致するレコードとなる。

>   WHERE ((0 = 0 or (user_name = ?))
>   OR (0 = 1 or (user_id = ?)))

>   このため、or条件を使用する場合には可変条件形式のSQL文を使用せずに通常のSQL文として組み立てを行うこと。(下記実装コードのように実装を行うこと。)
>   これにより、未入力の場合は「カラム名 = null」となり評価されないため、入力された項目のみを評価することが実現可能となる。

>   ```sql
>   SELECT
>       USER_MTR.LOGIN_ID,
>       USER_MTR.USER_KANJI_NAME,
>       USER_MTR.USER_KANA_NAME,
>       USER_MTR.GROUP_ID,
>       USER_GROUP.GROUP_NAME
>   FROM
>       USER_MTR,
>       USER_GROUP
>   WHERE
>       (USER_MTR.LOGIN_ID        =    :loginId
>       OR USER_MTR.USER_KANJI_NAME LIKE :userKanjiName%
>       OR USER_MTR.USER_KANA_NAME  LIKE :userKanaName%
>       OR USER_MTR.GROUP_ID        =    :groupId)
>       AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
>   ORDER BY
>       LOGIN_ID
>   ```

### IN句の条件が動的に変わる場合

検索画面では、区分値などでユーザが選択した区分のみを条件に含める場合がある。
このような場合には、IN句の条件を動的に生成する必要があるため、本機能を使用してSQL文の実行を行う。

※SQL文の記述方法は、 [SQLファイル](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#object-form-retrieve-label) のSQL_ID:GET_LIST3を参照すること。

```java
// オブジェクトの実装
public class W11BB03SearchForm {
    /** ログインID */
    private String loginId;
    /** 権限区分 */
    // 【説明】
    // IN句に対応するフィールドのデータ型は、配列またはjava.util.Collectionとすること。
    private List kengenKbn;
}

// 【説明】SQL文と条件が設定されたオブジェクトを指定して、ParameterizedSqlPStatementを生成する。
ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST3", user);

// 【説明】条件が設定されたオブジェクトを引数にSQL文を実行する。
SqlResultSet rs = select.retrieve(user);
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

上記のコードを実行した場合で、kengenKbnの値が["01", "02"]の場合は、実行されるSQL文は下記となる。

```sql
-- 【説明】
-- kengenKbnの要素数は、["01", "02"]で2となるためIN句の項目数が2としてSQL文が構築される。
-- 本SQL文は、可変条件と組み合わせているため、下記のSQL文が構築される。
-- 可変条件を使用しなかった場合、構築されるSQL文は「USER_MTR.KENGEN_KBN IN (?, ?)」となる。
SELECT USER_MTR.LOGIN_ID,
       USER_MTR.USER_KANJI_NAME,
       USER_MTR.USER_KANA_NAME,
       USER_MTR.GROUP_ID,
       USER_GROUP.GROUP_NAME
  FROM USER_MTR,
       USER_GROUP
 WHERE (0 = 0 OR (USER_MTR.LOGIN_ID = ?))
   AND (0 = 1 OR (USER_MTR.KENGEN_KBN IN (?, ?)))
   AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
 ORDER BY LOGIN_ID
```

> **Note:**
> IN句の条件に設定できる値には、上限が設けられている。
> 各アプリケーションでは、この上限値を超えることのないように精査などを行うこと。

> ※上限値は、データベースベンダーによって異なる値となっている。(例えばOracleデータベースであれば、1000となっている。)

> **Note:**
> IN句の条件を [可変条件のSQLの場合](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#variable-condition-sql-label) と組み合わせることも可能である。
> 可変条件と組み合わせた場合、条件に含めるか否かの条件は、配列(Collection)がnullであるかと、サイズが0であるかとなる。

> 以下に例を示す。

> ```java
> // 下記条件に対して、サイズ0またはnullの配列(Collection)を設定した場合、生成される条件文は
> // 「WHERE (0 = 0 OR (KENGEN_KBN IN (?)))」となり条件から除外される。
> // サイズが1以上の配列(Collection)を設定した場合は、生成される条件文は、
> // 「WHERE (0 = 1 OR (KENGEN_KBN IN (?)))」となり条件に含まれる。
> "WHERE $if(kengenKbn) {KENGEN_KBN IN (:kengenKbn[])}"
> ```

> ※配列(Collection)の各要素を、可変条件の組み立て条件には使用することはできない。つまり、下記のようなSQL文は定義できないということである。

> ```java
> WHERE $if(kengenKbn[0]) {kengenKbn = :kengenKbn[0]}
> ```

> **Warning:**
> IN句を動的に生成するような実装は、Webアプリケーションでのみ使用すること。
> バッチ処理では、インプットデータであるファイルやデータベースのレイアウトが明確であるため、必ず条件が固定となるSQLを使用すること。
> バッチ処理でIN句が動的となるSQL文を使用した場合、SQL文の構築コストがかかり性能劣化の原因となる。

> **Warning:**
> IN句を動的に生成する場合、条件オブジェクトにはMapインタフェースの実装クラスを指定することは出来ないので注意すること。
> これは、Mapの値(value値)は、静的な型情報をもっておらず、実行時に型情報が決定するからである。
> 実行時に型情報が決まるということは、必ず配列(Collection)が値として格納されていることが保証できず、
> 予期せぬ不具合の原因となる可能性があるため、本フレームワークとしては敢えて機能を制限している。

### ORDER BY句を動的に変更する場合

検索画面では、検索結果リストの列見出しによる並び替えを行う場合がある。
このような場合には、ORDER BY句を動的に変更する必要があるため、本機能を使用してSQL文の実行を行う。

※SQL文の記述方法は、 [SQLファイル](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#object-form-retrieve-label) のSQL_ID:GET_LIST4を参照すること。

```java
// オブジェクトの実装
public class W11BB03SearchForm {

    // ユーザ名
    private String userName;

    // 【説明】
    //  SQL文の$sort(フィールド名)で指定したフィールド名に合わせて、プロパティを用意する。
    //  このプロパティの値により、SQL文で指定したORDER BY句を動的に変更する。
    private String sortId;

    // 【説明】本来はここに各フィールドのアクセスメソッドを定義する。

}

// 【説明】SQL文と条件が設定されたオブジェクトを指定して、ParameterizedSqlPStatementを生成する。
ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST4", user);

// 【説明】条件が設定されたオブジェクトを引数にSQL文を実行する。
SqlResultSet rs = select.retrieve(user);
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

上記のコードを実行した場合で、sortIdの値が"3"の場合は、実行されるSQL文は下記となる。

```sql
-- 【説明】
-- sortIdの値が"3"のため、SQL文のケース「(3 USER_NAME)」が使用され、ORDER BY句が構築される。
SELECT
    USER_ID,
    USER_NAME
FROM
    USER_MTR
WHERE
    USER_NAME = ?
ORDER BY USER_NAME
```

> **Warning:**
> ORDER BY句を動的に変更するような実装は、Webアプリケーションでのみ使用すること。

> バッチ処理では、不要な並び替えを行わず、必要最小限の並び替えのみ使用すること。
> また、バッチ処理で並び替えを使用する場合は、インプットデータであるファイルやデータベースのレイアウトが明確であるため、
> 必ずORDER BY句が固定となるSQLを使用すること。

> バッチ処理でORDER BY句が動的となるSQL文を使用した場合、SQL文の構築コストがかかり性能劣化の原因となる。

### 大量データを検索する場合

簡易検索ではなく、大量データ検索機能を使用する必要性については、 [大量データの検索機能](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#executequery-label) を参照すること。

```java
// 【説明】オブジェクトの宣言、生成については省略

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_ALL");

// executeQueryを呼びだすと、ResultSetIteratorが返却される。
ResultSetIterator rs = statement.executeQueryByObject(user);

for (SqlRow row : rs) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");

    // 【説明】本来は、ここで業務処理の実装(呼び出し)が行われる。
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [条件に紐付くデータの全件検索処理](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#retrieve-variable-label) を参照すること。

## オブジェクトのフィールドの値の検索機能(Mapのサブクラス編)

Mapについての実装は、 [オブジェクトのフィールドの値の登録機能(Mapのサブクラス編)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#map-save-label) 及び [オブジェクトのフィールドの値の検索機能(オブジェクト(Form)編)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#object-select-label) を参照すること。
