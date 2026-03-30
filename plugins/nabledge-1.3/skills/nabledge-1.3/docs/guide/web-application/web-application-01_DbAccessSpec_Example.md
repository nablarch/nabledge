# データベースアクセス実装例集

## 本ページの構成

本ページで説明する実装例の目次:

* [basic_implementation](#s1)
* [simple_search](#s2)
  * [retrieve-variable-label](#s3)
  * [range_search](#s3)
  * [how_to_use_sql_result_set](#s3)
* :ref:`executeQuery-label`
* [insert_update_delete](#)
  * [update_single_data](#)
  * :ref:`executeBatch-label`
* [access_to_binary_data](#)
  * [searching_binary_data](#)
  * [insert_binary_data](#)
  * [insert_file_data_as_binary_data](#)
  * [generate_binary_file](#)
* [db-object-save-samole](#)
  * [update_single_data_by_object](#s6)
  * [update_multiple_data_by_object](#s6)
* [map-save-label](#s6)
  * [update_single_data_by_map](#)
  * [update_multiple_data_by_map](#)
* [object-select-label](#)
  * [using_simple_search](#)
  * [using_simple_search_having_like_conditions](#)
  * [variable-condition-sql-label](#)
  * [changing_dynamically_in](#)
  * [changing_dynamically_order_by](#)
  * [serching_for_mass_data](#)
* [map-search-label](#)

大量データを取得する場合は、簡易検索機能ではなく `executeQuery` を使用する。`executeQuery` は `ResultSetIterator` を返却し、JDBCの機能を直接使用せずにデータ取得が可能。

> **注意**: 大量データの取得とは、SELECT文の結果として取得されるデータ件数（検索対象のテーブルの件数ではない）が大量であることをさす。
>
> **大量データの取得に該当する例**:
> ```java
> statement.retrieve();            // SqlResultSetのサイズが多い場合は、大量データとなる。
> statement.retrieve(1, 10000000); // SqlResultSetのサイズが最大で1千万件となるため、大量データとなる。
> ```
>
> **大量データに該当しない例**:
> ```java
> statement.retrieve(10000000, 20); // 取得最大件数に20件を指定しているため（SqlResultSetのサイズは最大で20件のため）、大量データの取得とはならない。
> ```

**SQLファイル例** (SQL_ID: GET_ALL_USER):

```sql
GET_ALL_USER =
SELECT USER_ID, USER_NAME, USER_NAME_KANA, TEL, MAIL_ADDRESS
FROM USER_MST
ORDER BY USER_ID
```

**Java実装例** (`DbAccessSupport` を継承したクラス):

```java
public ResultSetIterator getAllUser() {
    SqlPStatement statement = getSqlPStatement("GET_ALL_USER");
    statement.setString(1, "00001");
    return statement.executeQuery();
}

// ResultSetIteratorはIterableを実装しているためfor-each使用可
for (SqlRow row : rs) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
}
```

SQLファイルの記述ルールやSQL_IDの指定方法: [retrieve-variable-label](#s3)

DBのバイナリ型（BLOBやbyte）カラムの参照・更新実装例。

**SQLファイル** (`nablarch/sample/ss11AC/CM311AC1Component.sql`)

```sql
-- GET_PASSWORD: SELECT PWD FROM USER_MST WHERE USER_ID = ?
-- UPDATE_PASSWORD: UPDATE USER_MST SET PWD = ? WHERE USER_ID = ?
-- UPDATE_PDF: UPDATE PDF_LIST SET PDF_DATA = ? WHERE USER_ID = ?
-- GET_PDF: SELECT PDF_DATA FROM PDF_LIST WHERE USER_ID = ?
```

## 1件のデータを更新する場合

`executeUpdateByMap(Map)` でMapを使って1件更新する。

```java
Map<String, Object> sales = new HashMap<String, Object>();
sales.put("CST_ID", "00001");
sales.put("KINGAKU", "200");

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("UPDATE_SALES");
int updCnt = statement.executeUpdateByMap(sales);
```

> **注意**: SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [retrieve-variable-label](#s3) を参照すること。

## 複数件を更新する場合

複数件を一括で更新する場合の注意点は、 :ref:`JDBC標準機能<executeBatch-label>` と同じである。

```java
private static final int BATCH_EXECUTE_MAX_CNT = 1000;

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

> **注意**: SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [retrieve-variable-label](#s3) を参照すること。

IN句の条件を動的に生成するには `ParameterizedSqlPStatement` を使用する（SQL_ID: GET_LIST3）。

IN句に対応するフィールドのデータ型は **配列または `java.util.Collection`** とすること。

```java
public class W11BB03SearchForm {
    private String loginId;
    private List kengenKbn; // IN句用フィールドはList/配列
}

ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST3", user);
SqlResultSet rs = select.retrieve(user);
```

kengenKbnが `["01", "02"]` の場合、生成されるSQL:

```sql
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

kengenKbnの要素数（ここでは2）に応じてIN句の項目数が構築される。

> **注意**: IN句の条件に設定できる値には上限がある（例: Oracleは1000）。各アプリケーションでこの上限を超えないよう精査すること。

> **注意**: IN句の条件を [variable-condition-sql-label](#) と組み合わせ可能。可変条件と組み合わせた場合、配列(Collection)がnullまたはサイズ0なら条件から除外、サイズ1以上なら条件に含まれる。
>
> ```java
> // サイズ0またはnull → 条件除外: WHERE (0 = 0 OR (KENGEN_KBN IN (?)))
> // サイズ1以上 → 条件に含む: WHERE (0 = 1 OR (KENGEN_KBN IN (?)))
> "WHERE $if(kengenKbn) {KENGEN_KBN IN (:kengenKbn[])}"
> ```
>
> 配列(Collection)の各要素を可変条件の組み立て条件には使用不可。以下のような定義はできない。
>
> ```java
> WHERE $if(kengenKbn[0]) {kengenKbn = :kengenKbn[0]}
> ```

> **警告**: IN句の動的生成は **Webアプリケーションでのみ** 使用すること。バッチ処理ではインプットデータのレイアウトが明確なため、必ず条件が固定となるSQLを使用すること（SQL文の構築コストによる性能劣化のため）。

> **警告**: IN句を動的に生成する場合、条件オブジェクトに `Map` インタフェースの実装クラスは指定不可。Mapのvalue値は静的型情報を持たず実行時に型情報が決定するため、配列(Collection)が値として格納されていることを保証できない。本フレームワークとして意図的に機能を制限している。

<details>
<summary>keywords</summary>

データベースアクセス実装例, 簡易検索, 範囲指定検索, バイナリデータアクセス, オブジェクト保存, マップ保存, executeQuery, DbAccessSupport, SqlPStatement, ResultSetIterator, SqlResultSet, SqlRow, 大量データ検索, getSqlPStatement, CM311AC1Component, GET_PASSWORD, UPDATE_PASSWORD, UPDATE_PDF, GET_PDF, バイナリデータ, BLOB, byte, USER_MST, PDF_LIST, ParameterizedSqlPStatement, executeUpdateByMap, addBatchMap, executeBatch, MapによるDB更新, バッチ更新, BATCH_EXECUTE_MAX_CNT, HashMap, getBatchSize, IN句 動的生成, kengenKbn, List, Collection, retrieve, 可変条件, IN句 上限, IN句 Webアプリケーション, $if, 動的IN句

</details>

## 基本的な実装

**クラス**: `nablarch.core.db.support.DbAccessSupport`

データベースアクセスを行うクラスは `DbAccessSupport` を継承して作成する。

```java
public class CM311AC1Component extends DbAccessSupport {
}
```

> **注意**: 継承モデルを使用しない場合（別のスーパークラスを継承する必要があり、`DbAccessSupport` を継承できない場合）は、`DbAccessSupport` をインスタンス化して使用する。自身のクラスオブジェクトをコンストラクタに指定する。

```java
DbAccessSupport support = new DbAccessSupport(getClass());
```

> **警告**: 継承モデルを使用しない場合にデフォルトコンストラクタ（引数なしコンストラクタ）を使用すると、SQL実行クラスに対応するSQLファイルを特定できず実行時エラーとなる。

> **警告**: `ResultSetIterator#iterator` の呼び出しは複数回行うことができない。

**NGとなる実装パターン**:

```java
// iteratorメソッドを2回呼び出しているためNG
ResultSetIterator rs = statement.executeQuery();
rs.iterator();
rs.iterator();

// 2回目のfor文で2回目のiterator呼び出しが行われるためNG
ResultSetIterator rs = statement.executeQuery();
for (SqlRow row : rs) { /* 処理 */ }
for (SqlRow row : rs) { /* 処理 */ }  // NG
```

バイナリデータは `SqlRow#getBytes` で取得する。

```java
public byte[] getPassword(String userId) {
    SqlPStatement select = getSqlPStatement("GET_PASSWORD");
    select.setString(1, userId);
    SqlResultSet rs = select.retrieve();
    return rs.get(0).getBytes("pwd");
}
```

> **警告**: データ量が大きい場合（ファイルデータ等）は `getBytes` での一括取得を避け、バイナリデータをファイルとして出力する方法の実装例に従うこと。

**SQLファイル**: `nablarch/sample/ss11BB/CM211BB1Component.sql`

バインド変数の記法ルール:
- バインド変数は `?` ではなく `:`＋フィールド名を使用
- 前方一致: `:フィールド名%`
- 後方一致: `:%フィールド名`
- 部分一致: `:%フィールド名%`
- LIKE句にescape句の記述不要（フレームワークが自動付加）
- 動的IN句: `:フィールド名[]`（末尾に`[]`を付加）
- 動的ORDER BY: `$sort(フィールド名) {(ケース COLUMN) ...}`
- 可変条件: `$if (フィールド名) {条件式}`

```sql
-- SQL_ID:GET（通常検索）
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

-- SQL_ID:GET_LIST1（前方一致）
GET_LIST1 =
SELECT
    USER_ID,
    USER_NAME
FROM
    USER_MTR
WHERE
    USER_NAME LIKE :userName%
ORDER BY
    USER_ID

-- SQL_ID:GET_LIST2（可変条件）
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

-- SQL_ID:GET_LIST3（動的IN句）
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

-- SQL_ID:GET_LIST4（動的ORDER BY）
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

-- SQL_ID:GET_ALL（全データ取得）
-- 注意: テーブル名はUSER_MST（他のSQLのUSER_MTRとは異なる）
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

ORDER BY句を動的に変更するには `ParameterizedSqlPStatement` を使用する（SQL_ID: GET_LIST4）。

SQL文の `$sort(フィールド名)` で指定したフィールド名に合わせてプロパティを用意し、そのプロパティ値によりORDER BY句を動的に変更する。

```java
public class W11BB03SearchForm {
    private String userName;
    private String sortId; // $sort(sortId) に対応するプロパティ
}

ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST4", user);
SqlResultSet rs = select.retrieve(user);
```

sortIdが `"3"` の場合、生成されるSQL:

```sql
SELECT
    USER_ID,
    USER_NAME
FROM
    USER_MTR
WHERE
    USER_NAME = ?
ORDER BY USER_NAME
```

sortIdの値に対応するケース（例: `(3 USER_NAME)`）が使用され、ORDER BY句が構築される。

> **警告**: ORDER BY句の動的変更は **Webアプリケーションでのみ** 使用すること。バッチ処理では、不要な並び替えを行わず、必要最小限の並び替えのみ使用すること。また、バッチ処理で並び替えを使用する場合は、インプットデータのレイアウトが明確なため、必ずORDER BY句が固定となるSQLを使用すること（SQL文の構築コストによる性能劣化のため）。

<details>
<summary>keywords</summary>

DbAccessSupport, データベースアクセス, 継承モデル, CM311AC1Component, インスタンス化, ResultSetIterator, iterator, 複数回呼び出し禁止, for-each, NG実装パターン, SqlRow, SqlPStatement, SqlResultSet, getBytes, バイナリデータ検索, ParameterizedSqlPStatement, バインド変数, LIKE検索, 動的IN句, 動的ORDER BY, $if, $sort, 前方一致, 後方一致, 部分一致, 可変条件SQL, ORDER BY 動的変更, sortId, ORDER BY Webアプリケーション, バッチ処理 並び替え最小限, 不要な並び替え

</details>

## 簡易検索機能

**クラス**: `SqlResultSet`, `SqlPStatement`, `SqlRow`

簡易検索機能を使用すると、検索結果が `SqlResultSet` オブジェクトに格納されて返却される。

`SqlResultSet` は `java.sql.ResultSet` と比較して簡易的に扱えるオブジェクトで、主に以下の利点がある:
- リソース解放(close処理)を実装する必要がない
- 取得レコード数がわかる

> **警告**: 大量データを簡易検索機能で取得すると大量にメモリを消費しOutOfMemoryErrorが発生する可能性がある。大量データを取得する場合は簡易検索機能ではなく :ref:`executeQuery-label` を使用すること。
>
> **大量データとは**: SELECT文の結果として取得されるデータ件数（検索対象のテーブルの件数ではない）が大量であることを指す。取得開始位置が大きくても取得最大件数が少なければ大量データには該当しない。
>
> ```java
> // 大量データに該当する例
> statement.retrieve();             // SqlResultSetのサイズが多い場合
> statement.retrieve(1, 10000000); // 取得件数に1千万件を指定
>
> // 大量データに該当しない例
> statement.retrieve(10000000, 20); // 取得開始位置は1千万だが取得最大件数は20件のため大量データとならない
> ```

## 条件に紐付くデータの全件検索処理

`SqlPStatement#retrieve()` を使用して全件取得する。

SQLファイル記述ルール:
- SQL_IDとSQL文の1グループは空行で区切る。SQL文の中に空行を入れてはならない。コメント行は空行とはならない
- SQL文の最初の `=` までがSQL_ID（SQLファイル内でSQL文を一意に特定するID）。SQL_IDには任意の値を設定することが可能
- コメントは `--` で開始。`--` 以降の値はコメントとして扱い読み込まない
- SQL文の途中で改行を行っても良い。また、可読性を考慮してスペースやtabなどで桁揃えを行っても良い
- バインド変数のインデックスは1から開始（`java.sql.PreparedStatement` と同様）

SQLファイル例（`nablarch/sample/ss11AC/CM311AC1Component.sql`）:

```sql
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

```java
SqlPStatement statement = getSqlPStatement("GET_USER_INFO");
statement.setString(1, "00001");
SqlResultSet resultSet = statement.retrieve();
```

## 範囲指定での検索処理

`SqlPStatement#retrieve(int, int)` を使用して開始位置と取得件数を指定して検索する。

```sql
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

```java
SqlPStatement statement = getSqlPStatement("GET_USER_LIST");
return statement.retrieve(startPos, 20);
```

## 取得したSqlResultSetの使用方法

`SqlResultSet` には `SqlRow` クラスが格納されており、カラムの値を取り出せる。カラム名はSQL名（`USER_ID`）またはJavaBeansプロパティ命名規約の名称（`userId`）のどちらでも指定可能。

```java
SqlResultSet resultSet = statement.retrieve();
for (SqlRow row : resultSet) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
    String userNameKana = row.getString("USER_NAME_KANA");
}
```

JSPでは `SqlResultSet` とJavaオブジェクトのリストを透過的に扱える:

```jsp
<c:forEach var="row" items="${searchResult}">
    <td><n:write name="row.userId" /></td>
    <td><n:write name="row.userName" /></td>
    <td><n:write name="row.kanaName" /></td>
</c:forEach>
```

**SQLファイル例**:

```sql
REGISTER_USER =
INSERT INTO USER_MST (USER_ID, USER_NAME, USER_NAME_KANA, TEL, MAIL_ADDRESS)
VALUES (?, ?, ?, ?, ?)

UPDATE_USER_NAME =
UPDATE USER_MST SET USER_NAME = ? WHERE USER_ID = ?
```

**Java実装例**:

```java
// 登録処理
public void registerUser(String userId, String userName, String userNameKana,
        String tel, String mailAddress) {
    SqlPStatement statement = getSqlPStatement("REGISTER_USER");
    statement.setString(1, userId);
    statement.setString(2, userName);
    statement.setString(3, userNameKana);
    statement.setString(4, tel);
    statement.setString(5, mailAddress);
    statement.executeUpdate();
}

// 更新処理
public void updateUserName(String userId, String userName) {
    SqlPStatement updateStatement = getSqlPStatement("UPDATE_USER_NAME");
    updateStatement.setString(1, userName);
    updateStatement.setString(2, userId);
    int updCnt = updateStatement.executeUpdate();
    if (updCnt != 1) {
        // 更新対象が存在しない場合は対象なしエラーを表示する
    }
}
```

SQLファイルの記述ルールやSQL_IDの指定方法: [retrieve-variable-label](#s3)

バイナリデータは `SqlPStatement#setBytes` で設定する。

```java
SqlPStatement statement = getSqlPStatement("UPDATE_PASSWORD");
statement.setBytes(1, pwd);
statement.setString(2, "00001");
statement.executeUpdate();
```

> **警告**: `setBytes` はDBベンダーによってはサポートしない場合がある。使用するsetメソッドはDBベンダーのJDBCマニュアルを参照すること。

Formオブジェクトのフィールド値を条件に [simple_search](#s2) を使用する場合の実装例。SQL記法は [SQLファイル](#) のSQL_ID:GET参照。

```java
public class W11BB01Form {
    private String userId;
    private String userName;
    // アクセスメソッドを定義する
}

// Form生成・条件設定
W11BB01Form form = new W11BB01Form();
form.setUserName("ユーザ");

// SQL実行
ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET");
return select.retrieve(form);
```

コンポーネントクラスによる実装例:

```java
package nablarch.sample.ss11BB;

public class CM211BB1Component {

    public SqlResultSet get(W11BB01Form form) {
        ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET");
        return select.retrieve(form);
    }
}
```

> **注意**: SQLファイルの記述ルールや、SQL_IDの指定方法の詳細は、 [retrieve-variable-label](#s3) を参照すること。

大量データ検索には `executeQueryByObject` を使用し、`ResultSetIterator` で逐次処理する（詳細は :ref:`executeQuery-label` 参照）。

```java
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_ALL");

// executeQueryByObjectはResultSetIteratorを返す
ResultSetIterator rs = statement.executeQueryByObject(user);

for (SqlRow row : rs) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
    // 業務処理
}
```

<details>
<summary>keywords</summary>

SqlResultSet, SqlPStatement, SqlRow, retrieve, 簡易検索, 大量データ, OutOfMemoryError, 範囲指定検索, 全件検索, GET_USER_INFO, GET_USER_LIST, DbAccessSupport, executeUpdate, getSqlPStatement, REGISTER_USER, UPDATE_USER_NAME, 1件更新, INSERT, UPDATE, setBytes, バイナリデータ登録, JDBCマニュアル, ParameterizedSqlPStatement, Formオブジェクト, W11BB01Form, CM211BB1Component, ResultSetIterator, executeQueryByObject, getString, 大量データ検索

</details>

## 複数件を一括で更新する場合

同一テーブルへの更新(insert、update、delete)を繰り返し行う場合には、バッチ更新機能(`executeBatch`)を使用する。データベースサーバとのラウンドトリップ回数を削減でき、性能改善が期待できる。

> **警告**: 大量データを一括更新する場合には、適宜 `executeBatch` を呼び出すこと。これを行わないと `OutOfMemoryError` が発生したり、GCが頻発して性能劣化の原因となる。

**SQLファイル例** (SQL_ID: REGSITER_ALL_USER):

```sql
REGSITER_ALL_USER =
INSERT INTO USER (ID, NAME) VALUES (?, ?)
```

**Java実装例**:

```java
private static final int BATCH_EXECUTE_MAX_CNT = 1000;

public void registerAllUser(List<Map<String, ?>> users) {
    SqlPStatement batch = getSqlPStatement("REGSITER_ALL_USER");
    for (Map<String, ?> user : users) {
        batch.setObject(1, user.get("ID"));
        batch.setObject(2, user.get("NAME"));
        batch.addBatch();
        if (batch.getBatchSize() == BATCH_EXECUTE_MAX_CNT) {
            batch.executeBatch();
        }
    }
    if (batch.getBatchSize() != 0) {
        batch.executeBatch();
    }
}
```

SQLファイルの記述ルールやSQL_IDの指定方法: [retrieve-variable-label](#s3)

`setBinaryStream(int, InputStream, int)` でファイルのストリームをバインド変数に設定する。

```java
SqlPStatement statement = getSqlPStatement("UPDATE_PDF");
File file = new File("hoge.pdf");
FileInputStream fis = new FileInputStream(file);
try {
    statement.setBinaryStream(1, fis, (int) file.length());
    statement.setString(2, "00001");
    statement.executeUpdate();
} finally {
    fis.close();
}
```

> **警告**: `java.io` パッケージを使用したこの実装はリソース開放漏れが発生する可能性あり。アプリケーションプログラマが実装することは推奨しない。必要な場合はアーキテクトがコンポーネントを作成すること。

LIKE条件の検索でもescape処理不要（フレームワークが自動付加する）。SQL記法は [SQLファイル](#) のSQL_ID:GET_LIST1参照。

```java
W11BB01Form form = new W11BB01Form();
form.setUserName("ユーザ");  // LIKE条件でもescape処理不要

ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST1");
SqlResultSet rs = select.retrieve(form);
```

実行されるSQL:
- 定義: `WHERE USER_NAME LIKE :userName%`
- 実行時: `WHERE USER_NAME LIKE ? ESCAPE '\\'`（escape句が自動付加）
- バインド変数値: `[ユーザ%]`

> **警告**: 後方・部分一致検索は、インデックスが使用されずテーブルフルスキャンとなるため、極端な性能劣化が発生する。顧客要件で回避不可能な場合のみ、顧客との合意の上で使用すること。

なし

<details>
<summary>keywords</summary>

SqlPStatement, addBatch, executeBatch, getBatchSize, BATCH_EXECUTE_MAX_CNT, バッチ更新, 一括更新, OutOfMemoryError, setBinaryStream, FileInputStream, InputStream, ファイルデータ登録, バイナリストリーム, ParameterizedSqlPStatement, LIKE条件, escape自動付加, 部分一致検索, 前方一致検索, テーブルフルスキャン, W11BB01Form, SqlResultSet, map-search-label, Map, Mapサブクラス, オブジェクト検索, map-save-label, object-select-label

</details>

## バイナリデータをファイルとして出力する方法

DBから `Blob` としてデータを取得し、`getBinaryStream()` でストリームを読み込んでファイルに出力する。

```java
SqlPStatement select = getSqlPStatement("GET_PDF");
select.setString(1, "00001");
SqlResultSet rs = select.retrieve();
Blob fileData = (Blob) rs.get(0).get("PDF_DATA");
InputStream pdfData = null;
FileOutputStream output = null;
try {
    pdfData = fileData.getBinaryStream();
    output = new FileOutputStream("hoge.pdf");
    byte[] b = new byte[1024];
    int size = 0;
    while ((size = pdfData.read(b)) != -1) {
        output.write(b, 0, size);
        output.flush();
    }
} finally {
    try { if (pdfData != null) pdfData.close(); }
    finally { if (output != null) output.close(); }
}
```

> **警告**: `java.io` パッケージを使用したこの実装はリソース開放漏れが発生する可能性あり。アプリケーションプログラマが実装することは推奨しない。必要な場合はアーキテクトがコンポーネントを作成すること。

可変条件SQL(`$if`)使用時の注意事項。SQL記法は [SQLファイル](#) のSQL_ID:GET_LIST2参照。

```java
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
```

```java
// SQL文と条件オブジェクトを指定してStatementを生成
ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST2", user);
SqlResultSet rs = select.retrieve(user);
```

未入力フィールドは `(0 = 0 OR 条件式)` として評価されない。カナ氏名のみ入力の場合の実行SQL:

```sql
WHERE (0 = 0 OR (USER_MTR.LOGIN_ID        =    ?))            -- 未入力のため評価されない
  AND (0 = 0 OR (USER_MTR.USER_KANJI_NAME LIKE ? ESCAPE '\')) -- 未入力のため評価されない
  AND (0 = 1 OR (USER_MTR.USER_KANA_NAME  LIKE ? ESCAPE '\')) -- 入力ありのため評価される
  AND (0 = 0 OR (USER_MTR.GROUP_ID        =    ?))            -- 未入力のため評価されない
  AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
ORDER BY LOGIN_ID
```

> **警告**: 可変条件SQLはWebアプリケーションでのみ使用すること。バッチ処理では条件固定のSQLを使用すること（可変条件SQLはインデックスが最適に使用されず性能劣化の原因となる）。

> **警告**: `$if` の制限事項:
> - `$if` のネストは不可: `$if(userName) {... $if(userId) {...}}` は使用不可
> - or条件との組み合わせは不可: 未入力フィールドが `(0 = 0 OR ...)` になるため、OR条件使用時は全レコードがマッチする。or条件を使う場合は通常のSQLとして実装すること（未入力の場合 `カラム名 = null` となり評価されない）

or条件使用時の正しい実装例:

```sql
WHERE (USER_MTR.LOGIN_ID        =    :loginId
    OR USER_MTR.USER_KANJI_NAME LIKE :userKanjiName%
    OR USER_MTR.USER_KANA_NAME  LIKE :userKanaName%
    OR USER_MTR.GROUP_ID        =    :groupId)
    AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
ORDER BY LOGIN_ID
```

<details>
<summary>keywords</summary>

SqlPStatement, SqlResultSet, Blob, getBinaryStream, FileOutputStream, InputStream, BLOBデータ出力, PDF_DATA, $if, 可変条件SQL, ParameterizedSqlPStatement, 動的WHERE条件, バッチ処理制限, $ifネスト不可, OR条件制限, getParameterizedSqlStatement, W11BB02Form, loginId, userKanjiName, userKanaName, groupId

</details>

## オブジェクトのフィールドの値の登録機能(オブジェクト(Form)編)

画面処理で精査済みリクエストパラメータをJavaBeansに保持している場合、本機能でフィールド値を一括登録でき実装ステップ数を軽減できる。

**SQLファイル** (`nablarch/sample/ss11AE/CM211AE1Component.sql`)

SQL文のバインド変数部分は `?` ではなく `:` + オブジェクトのフィールド名（またはMapのキー名）を使用する。

```sql
-- REGISTER_SALES (INSERT)
INSERT INTO SALES (CST_ID, KINGAKU, INS_DATE_TIME, INS_USER_ID, ...)
VALUES (:cstId, :kingaku, :insDateTime, :insUserId, ...)

-- UPDATE_SALES
UPDATE SALES SET KINGAKU = :KINGAKU WHERE CST_ID = :CST_ID
```

## 1件のデータを更新する場合

`ParameterizedSqlPStatement#executeUpdateByObject(form)` でオブジェクトのフィールド値を登録する。INSERT文だけでなくUPDATE/DELETE文でも同様に使用できる。

```java
ParameterizedSqlPStatement insert = getParameterizedSqlStatement("REGISTER_SALES");
insert.executeUpdateByObject(form);
```

フォームクラスの自動設定アノテーション:
- **アノテーション**: `@CurrentDateTime(format="yyyyMMddHHmmss")`, `@UserId`, `@RequestId`

## 複数件を更新する場合

`addBatchObject(form)` でバッチに追加し、`executeBatch()` で実行する。注意点は :ref:`JDBC標準機能<executeBatch-label>` と同じ。

```java
private static final int BATCH_EXECUTE_MAX_CNT = 1000;
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

<details>
<summary>keywords</summary>

ParameterizedSqlPStatement, DbAccessSupport, executeUpdateByObject, addBatchObject, executeBatch, @CurrentDateTime, @UserId, @RequestId, W11AE01Form, W11AE02Form, CM211AE1Component, getBatchSize, オブジェクトフィールド登録, バッチ更新, JavaBeans登録

</details>
