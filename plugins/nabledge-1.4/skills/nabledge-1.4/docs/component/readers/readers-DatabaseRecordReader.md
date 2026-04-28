# データベースレコードリーダ

このデータリーダでは、初回読み込み時にデータベースに対してクエリを発行し、その結果セットの中から1レコードずつ読み込んで返す。

**クラス名**

nablarch.fw.reader.DatabaseRecordReader

**読み込むデータの型**

nablarch.core.db.statement.SqlRow

**設定項目一覧**

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| SQLステートメント | statement | SqlPStatement | 排他利用。いずれか必須 |
| 引数付きSQLステートメント | statement | ParameterizedSqlPStatement, Object |  |

**使用例**

引数付きプリペアステートメントを使用する場合。

```java
// 引数オブジェクト
Map<String, Object> condition = new HashMap() {{
    put("param1", "value1");
    put("param2", "value2");
}};

// プリペアドステートメントを取得(SQLIDを指定)
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_DELETE_USER_LIST");

// データリーダを作成
DatabaseRecordReader reader = new DatabaseRecordReader()
                                 .setStatement(statement, condition);
```
