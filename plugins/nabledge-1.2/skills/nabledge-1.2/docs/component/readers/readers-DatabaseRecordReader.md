# データベースレコードリーダ

## データベースレコードリーダ

**クラス名**: `nablarch.fw.reader.DatabaseRecordReader`

**読み込むデータの型**: `nablarch.core.db.statement.SqlRow`

初回読み込み時にデータベースへクエリを発行し、結果セットから1レコードずつ返す。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| SQLステートメント | statement | SqlPStatement | 排他利用。いずれか必須 |
| 引数付きSQLステートメント | statement | ParameterizedSqlPStatement, Object | |

引数付きプリペアステートメント使用例:

```java
Map<String, Object> condition = new HashMap() {{
    put("param1", "value1");
    put("param2", "value2");
}};
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_DELETE_USER_LIST");
DatabaseRecordReader reader = new DatabaseRecordReader()
                                 .setStatement(statement, condition);
```

<details>
<summary>keywords</summary>

DatabaseRecordReader, nablarch.fw.reader.DatabaseRecordReader, SqlRow, nablarch.core.db.statement.SqlRow, SqlPStatement, ParameterizedSqlPStatement, statement, データベースレコードリーダ, バッチデータ読み込み, DBクエリ結果セット

</details>
