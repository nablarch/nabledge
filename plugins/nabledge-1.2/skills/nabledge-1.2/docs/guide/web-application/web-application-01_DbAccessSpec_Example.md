# データベースアクセス実装例集

## 本ページの構成

本ページで説明するデータベースアクセス実装例の一覧:

- [basic_implementation](#s1)
- [simple_search](#s2)（[retrieve-variable-label](#s3)、[range_search](#s3)、[how_to_use_sql_result_set](#s3)）
- :ref:`executeQuery-label`
- [insert_update_delete](#)（[update_single_data](#)、:ref:`executeBatch-label`）
- [access_to_binary_data](#)（[searching_binary_data](#)、[insert_binary_data](#)、[insert_file_data_as_binary_data](#)、[generate_binary_file](#)）
- [db-object-save-samole](#)（[update_single_data_by_object](#)、[update_multiple_data_by_object](#)）
- [map-save-label](#)（[update_single_data_by_map](#)、[update_multiple_data_by_map](#)）
- [object-select-label](#)（[using_simple_search](#)、[using_simple_search_having_like_conditions](#)、[variable-condition-sql-label](#)、[changing_dynamically_in](#)、[changing_dynamically_order_by](#)、[serching_for_mass_data](#)）
- [map-search-label](#)

大量データを取得する場合は、簡易検索機能ではなく `executeQuery` を使用すること。`executeQuery` を使用した場合もデータベースからの検索結果を簡易的に扱えるオブジェクト（`ResultSetIterator`）が返却されるため、JDBCの機能を直接使用せずにデータ取得できる。

> **補足**: 大量データとは、SELECT文の結果として取得されるデータ件数（検索対象テーブルの件数ではない）が大量であることをさす。`retrieve()` の結果 `SqlResultSet` が大量の場合、または `retrieve(1, 10000000)` のように取得最大件数を大量に指定した場合が該当する。取得開始位置が大きくても最大件数が少なければ（例: `retrieve(10000000, 20)` は最大20件のため）該当しない。

**SQLファイル** (`nablarch/sample/ss11AC/CM311AC1Component.sql`):
```sql
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

**Java実装**:
```java
public class CM311AC1Component extends DbAccessSupport {
    public ResultSetIterator getAllUser() {
        SqlPStatement statement = getSqlPStatement("GET_ALL_USER");
        statement.setString(1, "00001");
        return statement.executeQuery();
    }
}

// ResultSetIterator は Iterable を実装しているため for-each が使用可能
for (SqlRow row : rs) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
}
```

> **注意**: SQLファイルの記述ルールや SQL_ID の指定方法の詳細は、[retrieve-variable-label](#s3) を参照すること。

> **警告**: `ResultSetIterator#iterator` の呼び出しは複数回行うことができない。以下はNGパターン:
```java
// NG1: iteratorメソッドを2回呼び出し
ResultSetIterator rs = statement.executeQuery();
rs.iterator();
rs.iterator();

// NG2: 2回目のfor文で2回目のiterator呼び出しが発生
ResultSetIterator rs = statement.executeQuery();
for (SqlRow row : rs) { /* 処理 */ }
for (SqlRow row : rs) { /* 処理 */ }  // NG
```

## バイナリデータへのアクセス

SQLファイル: `nablarch/sample/ss11AC/CM311AC1Component.sql`

```sql
-- SQL_ID:GET_PASSWORD (パスワード取得用)
GET_PASSWORD =
SELECT PWD FROM USER_MST WHERE USER_ID = ?

-- SQL_ID:UPDATE_PASSWORD (パスワード更新用)
UPDATE_PASSWORD =
UPDATE USER_MST SET PWD = ? WHERE USER_ID = ?

-- SQL_ID:UPDATE_PDF (PDF更新用)
UPDATE_PDF =
UPDATE PDF_LIST SET PDF_DATA = ? WHERE USER_ID = ?

-- SQL_ID:GET_PDF (PDF取得用)
GET_PDF =
SELECT PDF_DATA FROM PDF_LIST WHERE USER_ID = ?
```

## バイナリデータの検索方法

**クラス**: `DbAccessSupport`, `SqlPStatement`, `SqlResultSet`, `SqlRow`

バイナリデータは `SqlRow#getBytes(columnName)` で取得する。

```java
SqlPStatement select = getSqlPStatement("GET_PASSWORD");
select.setString(1, userId);
SqlResultSet rs = select.retrieve();
SqlRow row = rs.get(0);
// バイナリデータはSqlRow#getBytesで取得する
return row.getBytes("pwd");
```

> **警告**: getBytesメソッドでバイナリデータを一括取得しているが、ファイルデータのようにデータ量が大きい場合には、[generate_binary_file](#) の実装例に従うこと。

## 1件のデータを更新する場合

**クラス**: `ParameterizedSqlPStatement`

```java
Map<String, Object> sales = new HashMap<String, Object>();
sales.put("CST_ID", "00001");
sales.put("KINGAKU", "200");

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("UPDATE_SALES");
int updCnt = statement.executeUpdateByMap(sales);
```

## 複数件を更新する場合

複数件一括更新の注意点は :ref:`JDBC標準機能<executeBatch-label>` と同じ。

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

IN句の条件が動的に変わる場合は、`ParameterizedSqlPStatement` を使用する。

**フィールドのデータ型制約**: IN句に対応するフィールドのデータ型は、配列または `java.util.Collection` とすること。

```java
public class W11BB03SearchForm {
    private String loginId;
    private List kengenKbn; // 配列またはjava.util.Collection
}

ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST3", user);
SqlResultSet rs = select.retrieve(user);
```

kengenKbnが `["01", "02"]` の場合のSQL（要素数2でIN句の項目数が2として構築）。このSQL文は可変条件と組み合わせているため、`(0 = 1 OR (...))` のラッパーが付いた形で構築される。可変条件を使用しなかった場合、構築されるSQL文は `USER_MTR.KENGEN_KBN IN (?, ?)` となる。

```sql
SELECT USER_MTR.LOGIN_ID, USER_MTR.USER_KANJI_NAME, USER_MTR.USER_KANA_NAME,
       USER_MTR.GROUP_ID, USER_GROUP.GROUP_NAME
  FROM USER_MTR, USER_GROUP
 WHERE (0 = 0 OR (USER_MTR.LOGIN_ID = ?))
   AND (0 = 1 OR (USER_MTR.KENGEN_KBN IN (?, ?)))
   AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
 ORDER BY LOGIN_ID
```

> **注意**: IN句の条件に設定できる値には上限がある。各アプリケーションでは上限値を超えないよう精査すること。上限値はDBベンダーによって異なる（例：Oracleは1000）。

> **注意**: IN句の条件を可変条件と組み合わせることも可能。可変条件との組み合わせでは、配列(Collection)がnullまたはサイズ0の場合は条件から除外され、サイズが1以上の場合は条件に含まれる。

可変条件との組み合わせ例:
```java
"WHERE $if(kengenKbn) {KENGEN_KBN IN (:kengenKbn[])}"
```

配列(Collection)の各要素を可変条件の組み立て条件には使用できない（`$if(kengenKbn[0])` のような定義は不可）。

> **警告**: IN句を動的に生成する実装はWebアプリケーションでのみ使用すること。バッチ処理では固定条件のSQLを使用すること（動的IN句はSQL構築コストによる性能劣化の原因となる）。

> **警告**: IN句を動的に生成する場合、条件オブジェクトにMapインタフェースの実装クラスは指定できない。Mapのvalue値は静的な型情報を持たないため、実行時に配列(Collection)であることが保証できず、予期せぬ不具合の原因となる可能性があるため機能制限している。

<details>
<summary>keywords</summary>

データベースアクセス実装例, 基本的な実装, 簡易検索機能, バイナリデータアクセス, オブジェクト保存, マップ保存, ResultSetIterator, SqlPStatement, DbAccessSupport, executeQuery, 大量データ検索, SqlRow, ResultSetIterator複数回呼び出し禁止, SqlResultSet, getBytes, バイナリデータ検索, BLOB取得, CM311AC1Component, ParameterizedSqlPStatement, executeUpdateByMap, addBatchMap, executeBatch, getBatchSize, Map更新, バッチ更新, 一括更新, IN句 動的生成, java.util.Collection, kengenKbn, 可変条件との組み合わせ, IN句上限値, Webアプリケーション限定

</details>

## 基本的な実装

**クラス**: `nablarch.core.db.support.DbAccessSupport`

データベースアクセスクラスは `DbAccessSupport` を継承して作成する。

```java
import nablarch.core.db.support.DbAccessSupport;
public class CM311AC1Component extends DbAccessSupport {
}
```

> **注意**: 継承モデルを使用しない場合（別のスーパークラスを継承するため `DbAccessSupport` を継承できない場合）は、`new DbAccessSupport(getClass())` でインスタンス化して使用する。

> **警告**: 継承モデルを使用しない場合にデフォルトコンストラクタを使用すると、SQLファイルを特定できず実行時エラーとなる。

### 1件のデータを更新する場合

**SQLファイル** (`nablarch/sample/ss11AC/CM311AC1Component.sql`):
```sql
REGISTER_USER =
INSERT INTO
    USER_MST
    (USER_ID, USER_NAME, USER_NAME_KANA, TEL, MAIL_ADDRESS)
VALUES
    (?, ?, ?, ?, ?)

UPDATE_USER_NAME =
UPDATE
    USER_MST
SET
    USER_NAME = ?
WHERE
    USER_ID = ?
```

**Java実装**:
```java
public class CM311AC1Component extends DbAccessSupport {
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

    public void updateUserName(String userId, String userName) {
        SqlPStatement updateStatement = getSqlPStatement("UPDATE_USER_NAME");
        updateStatement.setString(1, userName);
        updateStatement.setString(2, userId);
        int updCnt = updateStatement.executeUpdate();
        if (updCnt != 1) {
            // 更新対象が存在しない場合は対象なしエラーを表示する
        }
    }
}
```

> **注意**: SQLファイルの記述ルールや SQL_ID の指定方法の詳細は、[retrieve-variable-label](#s3) を参照すること。

### 複数件を一括で更新する場合

同一テーブルへの insert/update/delete を繰り返し行う場合は、`executeBatch` によるバッチ更新を使用すること。ラウンドトリップ回数を削減でき、性能改善が期待できる。

> **警告**: 大量データを一括更新する場合は適宜 `executeBatch` を呼び出すこと。実行しないとメモリ不足（OutOfMemoryError）やGC頻発による性能劣化の原因となる。

**SQLファイル** (`nablarch/sample/ss11AC/CM311AC1Component.sql`):
```sql
REGSITER_ALL_USER =
INSERT INTO
    USER
    (ID, NAME)
VALUES
    (?, ?)
```

**Java実装**:
```java
public class CM311AC1Component extends DbAccessSupport {
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
}
```

> **注意**: SQLファイルの記述ルールや SQL_ID の指定方法の詳細は、[retrieve-variable-label](#s3) を参照すること。

## バイナリデータの登録方法

バイナリデータは `SqlPStatement#setBytes(int, byte[])` で設定する。

```java
SqlPStatement statement = getSqlPStatement("UPDATE_PASSWORD");
statement.setBytes(1, pwd);
statement.setString(2, "00001");
int updNo = statement.executeUpdate();
```

> **警告**: `setBytes` はデータベースベンダーによってはサポートされない場合がある。どのsetメソッドを使用するかはデータベースベンダーのJDBCマニュアルを参照すること。

## ファイルの内容をバイナリデータとして登録する方法

ファイルのストリームを `setBinaryStream(int, InputStream, int)` でバインド変数に設定する。

```java
SqlPStatement statement = getSqlPStatement("UPDATE_PDF");
File file = new File("hoge.pdf");
FileInputStream fis = new FileInputStream(file);
try {
    // setBinaryStream(int, InputStream, int)でファイルのストリームをバインド変数に設定
    statement.setBinaryStream(1, fis, (int) file.length());
    statement.setString(2, "00001");
    statement.executeUpdate();
} finally {
    fis.close();
}
```

> **警告**: java.ioパッケージを使用したこの実装はリソース開放漏れが発生する可能性があり、アプリケーションプログラマが実装することは推奨しない。必要な場合にはアーキテクトがコンポーネントを作成して対処すること。

## バイナリデータをファイルとして出力する方法

DBからBlobとしてデータを取得し、`Blob#getBinaryStream()` でストリームを取得してファイルに書き出す。

```java
SqlPStatement select = getSqlPStatement("GET_PDF");
select.setString(1, "00001");
SqlResultSet rs = select.retrieve();
// データベースからBlobとしてデータを取得する
Blob fileData = (Blob) rs.get(0).get("PDF_DATA");

InputStream pdfData = null;
FileOutputStream output = null;
try {
    // Blobデータからストリームを取得し、バイナリデータを読み込む
    pdfData = fileData.getBinaryStream();
    // 出力ファイルを開く
    output = new FileOutputStream("hoge.pdf");
    byte[] b = new byte[1024];
    int size = 0;
    while ((size = pdfData.read(b)) != -1) {
        output.write(b, 0, size);
        output.flush();
    }
} finally {
    try {
        if (pdfData != null) pdfData.close();
    } finally {
        if (output != null) output.close();
    }
}
```

> **警告**: java.ioパッケージを使用したこの実装はリソース開放漏れが発生する可能性があり、アプリケーションプログラマが実装することは推奨しない。必要な場合にはアーキテクトがコンポーネントを作成して対処すること。

オブジェクトのフィールドの値を使用してデータを検索する実装例で使用するSQLファイル。

**ファイル**: `nablarch/sample/ss11BB/CM211BB1Component.sql`

バインド変数の記法:
- 通常: `:フィールド名` (例: `:userName`)
- 前方一致: `:フィールド名%` (例: `:userName%`)
- 後方一致: `:%フィールド名` (例: `:%userName`)
- 部分一致: `:%フィールド名%` (例: `:%userName%`)
- IN句（動的）: `:フィールド名[]` (例: `:kengenKbn[]`)
- 動的ORDER BY: `$sort(フィールド名) {(値 カラム名) ...}`

LIKE条件のSQL文にescape句の記述は不要（Nablarchが自動付加する）。

```sql
-- SQL_ID:GET (完全一致)
GET =
SELECT USER_ID, USER_NAME FROM USER_MTR
WHERE USER_NAME = :userName ORDER BY USER_ID

-- SQL_ID:GET_LIST1 (前方一致)
GET_LIST1 =
SELECT USER_ID, USER_NAME FROM USER_MTR
WHERE USER_NAME LIKE :userName% ORDER BY USER_ID

-- SQL_ID:GET_LIST2 ($ifによる可変条件)
GET_LIST2 =
SELECT USER_MTR.LOGIN_ID, USER_MTR.USER_KANJI_NAME, USER_MTR.USER_KANA_NAME,
       USER_MTR.GROUP_ID, USER_GROUP.GROUP_NAME
FROM USER_MTR, USER_GROUP
WHERE $if (loginId) {USER_MTR.LOGIN_ID = :loginId}
  AND $if (userKanjiName) {USER_MTR.USER_KANJI_NAME LIKE :userKanjiName%}
  AND $if (userKanaName) {USER_MTR.USER_KANA_NAME LIKE :userKanaName%}
  AND $if (groupId) {USER_MTR.GROUP_ID = :groupId}
  AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID ORDER BY LOGIN_ID

-- SQL_ID:GET_LIST3 (動的IN句)
GET_LIST3 =
SELECT USER_MTR.LOGIN_ID, USER_MTR.USER_KANJI_NAME, USER_MTR.USER_KANA_NAME,
       USER_MTR.GROUP_ID, USER_GROUP.GROUP_NAME
FROM USER_MTR, USER_GROUP
WHERE $if (loginId) {USER_MTR.LOGIN_ID = :loginId}
  AND $if (kengenKbn) {USER_MTR.KENGEN_KBN IN (:kengenKbn[])}
  AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID ORDER BY LOGIN_ID

-- SQL_ID:GET_LIST4 (動的ORDER BY)
GET_LIST4 =
SELECT USER_ID, USER_NAME FROM USER_MTR
WHERE USER_NAME = :userName
$sort(sortId) {
    (1 USER_ID)
    (2 USER_ID DESC)
    (3 USER_NAME)
    (4 USER_NAME DESC)
}

-- SQL_ID:GET_ALL (全データ取得)
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

ORDER BY句を動的に変更する場合は、`ParameterizedSqlPStatement` を使用する。

SQL文の `$sort(フィールド名)` で指定したフィールド名に合わせてプロパティを用意し、そのプロパティの値によりORDER BY句を動的に変更する。

```java
public class W11BB03SearchForm {
    private String userName;
    private String sortId; // $sort(フィールド名)に対応するプロパティ。この値でORDER BY句を動的変更
}

ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST4", user);
SqlResultSet rs = select.retrieve(user);
```

sortIdが `"3"` の場合のSQL（sortIdの値に対応するケースでORDER BY句が構築）:

```sql
SELECT USER_ID, USER_NAME
  FROM USER_MTR
 WHERE USER_NAME = ?
 ORDER BY USER_NAME
```

> **警告**: ORDER BY句を動的に変更する実装はWebアプリケーションでのみ使用すること。バッチ処理では、不要な並び替えを行わず、必要最小限の並び替えのみ使用すること。また、バッチ処理で並び替えを使用する場合は、インプットデータであるファイルやデータベースのレイアウトが明確であるため、必ずORDER BY句が固定となるSQLを使用すること（動的ORDER BY句はSQL構築コストによる性能劣化の原因となる）。

<details>
<summary>keywords</summary>

DbAccessSupport, データベースアクセスクラス継承, インスタンス化, 継承モデル, SqlPStatement, executeUpdate, executeBatch, addBatch, getBatchSize, INSERT実装, UPDATE実装, バッチ更新, OutOfMemoryError, 更新処理, insert, update, delete, setBytes, setBinaryStream, Blob, getBinaryStream, FileInputStream, FileOutputStream, バイナリデータ登録, ファイルデータ登録, バイナリデータファイル出力, ParameterizedSqlPStatement, バインド変数記法, LIKE条件SQL, IN句, $if, $sort, 可変条件SQL, 動的ORDER BY, CM211BB1Component, 前方一致, 部分一致, GET_ALL, USER_MST, ORDER BY句 動的変更, sortId, SqlResultSet, Webアプリケーション限定, バッチ処理 最小限の並び替え

</details>

## 簡易検索機能

**クラス**: `SqlResultSet`

検索処理では基本的に簡易検索機能を使用する。結果は `SqlResultSet` に格納されて返却される。

`SqlResultSet` の特長：
- リソース解放（close処理）の実装不要
- 取得レコード数が把握可能

![SqlResultSetのイメージ](../../../knowledge/guide/web-application/assets/web-application-01_DbAccessSpec_Example/DbAccessSpec_SampleSqlResultSet.jpg)

> **警告**: 大量データを簡易検索機能で取得するとOutOfMemoryErrorが発生する可能性がある。大量データを取得する場合は :ref:`executeQuery-label` を使用すること。

大量データとは、SELECT文の結果として取得されるデータ件数（検索対象のテーブルの総件数ではなく、実際に取得される件数）が大量な場合を指す。

```java
// 大量データの取得に該当する例
statement.retrieve();             // 結果のSqlResultSetのサイズが多い場合は大量データ
statement.retrieve(1, 10000000); // 取得最大件数に1千万件を指定しているため大量データ

// 大量データに該当しない例
statement.retrieve(10000000, 20); // 取得開始位置は1千万だが、取得最大件数は20件のためSqlResultSetのサイズは最大20件となり大量データではない
```

## オブジェクトのフィールドの値の登録機能（オブジェクト(Form)編）

画面処理で精査済みリクエストパラメータの値をJavaBeansで保持している場合、本機能を使用することで実装ステップ数を削減できる。

SQLファイル: `nablarch/sample/ss11AE/CM211AE1Component.sql`

バインド変数には `?` ではなく `:フィールド名`（オブジェクトのフィールド名）または `:キー名`（Mapのキー名）を使用すること。

```sql
-- SQL_ID:REGISTER_SALES
REGISTER_SALES =
INSERT INTO SALES
  (CST_ID, KINGAKU, INS_DATE_TIME, INS_USER_ID, UPD_DATE_TIME, UPD_USER_ID, EXECUTION_ID, REQUEST_ID)
VALUES
  (:cstId, :kingaku, :insDateTime, :insUserId, :updDateTime, :updUserId, :executionId, :requestId)

-- SQL_ID:UPDATE_SALES
UPDATE_SALES =
UPDATE SALES SET KINGAKU = :KINGAKU WHERE CST_ID = :CST_ID
```

## 1件のデータを更新する場合

**クラス**: `ParameterizedSqlPStatement`, `DbAccessSupport`
**アノテーション**: `@CurrentDateTime`, `@UserId`, `@RequestId`

`getParameterizedSqlStatement("SQL_ID")` でParameterizedSqlPStatementを取得し、`executeUpdateByObject(form)` でオブジェクトのフィールドの値を登録する。

> **注意**: 下記実装例はINSERT文となっているが、UPDATE文やDELETE文でも同じように実装することができる。

```java
// Formクラス例
public class W11AE01Form {
    private String cstId;
    private long kingaku;
    @CurrentDateTime(format="yyyyMMddHHmmss")
    private String insDateTime;
    @UserId
    private String insUserId;
    @CurrentDateTime(format="yyyyMMddHHmmss")
    private String updDateTime;
    @UserId
    private String updUserId;
    @RequestId
    private String requestId;
    // 各フィールドのアクセスメソッド省略
}

// 呼び出し側
W11AE01Form form = new W11AE01Form();
form.setCstId("0001");
form.setKingaku(100);
component.registerSales(form);

// コンポーネント側
ParameterizedSqlPStatement insert = getParameterizedSqlStatement("REGISTER_SALES");
insert.executeUpdateByObject(form);
```

[SQLファイル](#) のSQL_ID:GETを使用。

```java
public class W11BB01Form {
    private String userId;
    private String userName;
    // アクセスメソッドは省略
}

public void doRW11BB0101() {
    // Formを生成し、検索条件を設定する。
    W11BB01Form form = new W11BB01Form();
    form.setUserName("ユーザ");
    CM211BB1Component component = new CM211BB1Component();
    component.get(form);
}

public class CM211BB1Component {
    public SqlResultSet get(W11BB01Form form) {
        ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET");
        return select.retrieve(form);
    }
}
```

大量データ検索では `executeQueryByObject` を使用し、`ResultSetIterator` で結果を取得する。

```java
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_ALL");

// executeQueryByObjectを呼び出すとResultSetIteratorが返却される
ResultSetIterator rs = statement.executeQueryByObject(user);

for (SqlRow row : rs) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
}
```

<details>
<summary>keywords</summary>

SqlResultSet, retrieve, 大量データ, OutOfMemoryError, executeQuery, ParameterizedSqlPStatement, DbAccessSupport, executeUpdateByObject, @CurrentDateTime, @UserId, @RequestId, オブジェクト登録, Form登録, バインド変数フィールド名, CM211AE1Component, W11AE01Form, 簡易検索, Form検索, W11BB01Form, CM211BB1Component, executeQueryByObject, ResultSetIterator, SqlRow, 大量データ検索

</details>

## 条件に紐付くデータの全件検索処理

**API**: `SqlPStatement#retrieve()`

`getSqlPStatement` でSQL_IDを指定してStatementを取得し、`retrieve()` で条件に紐付くデータを全件取得する。

### SQLファイル記述ルール

- **SQL_IDとSQL文のグループは空行で区切る**。SQL文内に空行を入れてはならず、異なるSQL文との間には必ず空行を入れること。
- **コメント行は空行とはならない**。コメント行を2つのSQL文の間に置いても、空行の代わりにはならない。
- SQL文の最初の「`=`」までがSQL_ID（SQLファイル内でSQL文を一意に特定するID）。
- コメントは「`--`」で開始（以降はコメントとして扱い読み込まない）。
- SQL文の途中で改行可能。スペースやtabによる桁揃えも可。

SQLファイル（`nablarch/sample/ss11AC/CM311AC1Component.sql`）：
```sql
GET_USER_INFO =
SELECT
    USER_ID, USER_NAME, USER_NAME_KANA, TEL, MAIL_ADDRESS
FROM
    USER_MST
WHERE
    USER_ID = ?
ORDER BY
    USER_ID
```

Java実装：
```java
// SQL_IDを指定してStatementを取得する
SqlPStatement statement = getSqlPStatement("GET_USER_INFO");

// バインド変数に条件を設定する（インデックスは1から開始）
statement.setString(1, "00001");

// retrieve()で全件取得
SqlResultSet resultSet = statement.retrieve();
```

## 複数件を更新する場合

複数件を一括で更新する場合の注意点は :ref:`JDBC標準機能<executeBatch-label>` と同じ。

`addBatchObject(form)` でオブジェクトをバッチに追加し、最大件数に達したら `executeBatch()` を実行する。

```java
// 1回のexecuteBatchで更新する最大の件数
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

[SQLファイル](#) のSQL_ID:GET_LIST1を使用。

LIKE条件の項目であってもescape処理は不要（Nablarchが自動付加する）。

```java
W11BB01Form form = new W11BB01Form();
form.setUserName("ユーザ");  // escape処理不要

ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST1");
SqlResultSet rs = select.retrieve(form);
```

実際に実行されるSQL:
- アプリ定義: `WHERE USER_NAME LIKE :userName%`
- DB実行: `WHERE USER_NAME LIKE ? ESCAPE '\'` (escape句が自動付加)
- バインド値: `1(:userName) = [ユーザ%]`

> **警告**: 後方一致・部分一致検索はインデックスが使用されずテーブルフルスキャンとなり、極端な性能劣化が発生する。顧客要件で回避不可能な場合のみ、顧客と合意の上で使用すること。

Mapのサブクラスを使用したオブジェクトのフィールド値による検索機能。Mapについての実装は、`map-save-label` および `object-select-label` を参照すること。

<details>
<summary>keywords</summary>

getSqlPStatement, SqlPStatement, retrieve, SQL_ID, SQLファイル記述ルール, コメント行, 空行, ParameterizedSqlPStatement, addBatchObject, executeBatch, getBatchSize, 複数件更新, バッチ更新, W11AE02Form, SqlResultSet, LIKE検索, escape自動付加, 前方一致, 後方一致, 部分一致, テーブルフルスキャン, W11BB01Form, Map, Mapサブクラス, データベース検索, オブジェクト検索

</details>

## 範囲指定での検索処理

**API**: `SqlPStatement#retrieve(int startPos, int max)`

`getSqlPStatement` でStatementを取得し、`retrieve(startPos, max)` に開始位置と取得最大件数を指定して対象範囲のデータを取得する。

SQLファイル（`nablarch/sample/ss11AC/CM311AC1Component.sql`）：
```sql
GET_USER_LIST =
SELECT
    USER_ID, USER_NAME, USER_NAME_KANA, TEL, MAIL_ADDRESS
FROM
    USER_MST
ORDER BY
    USER_ID
```

Java実装：
```java
SqlPStatement statement = getSqlPStatement("GET_USER_LIST");
return statement.retrieve(startPos, 20);  // 開始位置と取得最大件数を指定
```

SQLファイルの記述ルールやSQL_IDの指定方法の詳細は [retrieve-variable-label](#s3) を参照すること。

[SQLファイル](#) のSQL_ID:GET_LIST2を使用。全条件が任意項目の検索画面（ログインID・漢字氏名・カナ氏名・グループID）での実装例。

```java
public class W11BB02Form {
    private String loginId;
    private String userKanjiName;
    private String userKanaName;
    private String groupId;
}

// SQL文と条件オブジェクトを指定してStatementを生成
ParameterizedSqlPStatement select = getParameterizedSqlStatement("GET_LIST2", user);
SqlResultSet rs = select.retrieve(user);
```

カナ氏名のみ入力がある場合の実行SQL（未入力項目は `0 = 0` で評価されない）:

```sql
WHERE (0 = 0 OR (USER_MTR.LOGIN_ID = ?))              -- ログインID: 未入力のため0=0が評価される
  AND (0 = 0 OR (USER_MTR.USER_KANJI_NAME LIKE ? ESCAPE '\'))  -- 漢字氏名: 未入力
  AND (0 = 1 OR (USER_MTR.USER_KANA_NAME  LIKE ? ESCAPE '\'))  -- カナ氏名: 入力ありのため条件が評価される
  AND (0 = 0 OR (USER_MTR.GROUP_ID = ?))              -- グループID: 未入力
  AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID ORDER BY LOGIN_ID
```

> **警告**: 可変条件をもつSQL文はWebアプリケーションでのみ使用すること。バッチ処理ではインプットのレイアウトが明確なため固定条件のSQLを使用すること（可変条件ではインデックスが最適に使用されず性能劣化の原因となる）。

> **警告**: `$if`の制限事項:
> - `$if`のネストは不可: `$if(userName) {... $if(UserId) {...}}` は使用不可
> - OR条件と組み合わせ不可: 未入力時に `0 = 0 OR` が付加されるため、OR条件全体がtrueになり全レコードが一致してしまう。OR条件を使う場合は可変条件形式を使わず通常のSQL文として記述すること（未入力の場合は「カラム名 = null」となり評価されない）。

OR条件を使う場合の代替実装:

```sql
SELECT USER_MTR.LOGIN_ID, USER_MTR.USER_KANJI_NAME, USER_MTR.USER_KANA_NAME,
       USER_MTR.GROUP_ID, USER_GROUP.GROUP_NAME
FROM USER_MTR, USER_GROUP
WHERE (USER_MTR.LOGIN_ID         =    :loginId
    OR USER_MTR.USER_KANJI_NAME LIKE :userKanjiName%
    OR USER_MTR.USER_KANA_NAME  LIKE :userKanaName%
    OR USER_MTR.GROUP_ID         =    :groupId)
  AND USER_GROUP.GROUP_ID = USER_MTR.GROUP_ID
ORDER BY LOGIN_ID
```

<details>
<summary>keywords</summary>

getSqlPStatement, SqlPStatement, retrieve(int, int), 範囲指定, 開始位置, 取得件数, ParameterizedSqlPStatement, SqlResultSet, $if, 可変条件, 動的SQL, W11BB02Form, getParameterizedSqlStatement, $ifネスト不可, OR条件制限

</details>

## 取得したSqlResultSetの使用方法

**クラス**: `SqlResultSet`, `SqlRow`

`SqlResultSet` には、レコードを表す `SqlRow` オブジェクトが格納される。

```java
SqlResultSet resultSet = statement.retrieve();
for (SqlRow row : resultSet) {
    String userId = row.getString("USER_ID");
    String userName = row.getString("USER_NAME");
    String userNameKana = row.getString("USER_NAME_KANA");
}
```

`SqlRow` からカラム値を取り出す際は、カラム名またはJavaBeansのプロパティ命名規約に準じた名称のどちらでも指定可能。例：`USER_ID` カラムは `USER_ID` でも `userId` でも取得できる。

この機能により、JSPでDB検索結果行（`SqlRow`）とJavaオブジェクトを透過的に扱える（変数が `SqlResultSet` でもJavaオブジェクトのリストでも同様に動作）：

```jsp
<c:forEach var="row" items="${searchResult}">
    <%-- 次の行は <td><n:write name="row['USER_ID']" /></td> と等価 --%>
    <td><n:write name="row.userId" /></td>
    <td><n:write name="row.userName" /></td>
    <td><n:write name="row.kanaName" /></td>
</c:forEach>
```

<details>
<summary>keywords</summary>

SqlResultSet, SqlRow, getString, カラム名, camelCase, JSP, n:write

</details>
