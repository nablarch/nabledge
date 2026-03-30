# データベースレコードリーダ

## データベースレコードリーダ

**クラス名**: `nablarch.fw.reader.DatabaseRecordReader`

**読み込むデータ型**: `nablarch.core.db.statement.SqlRow`

初回読み込み時にDBにクエリを発行し、結果セットから1レコードずつ返す。

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| statement | SqlPStatement | ○ | SQLステートメント。排他利用。いずれか必須 |
| statement | ParameterizedSqlPStatement, Object | ○ | 引数付きSQLステートメント。排他利用。いずれか必須 |

引数付きプリペアドステートメント使用例:

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

DatabaseRecordReader, nablarch.fw.reader.DatabaseRecordReader, SqlRow, nablarch.core.db.statement.SqlRow, ParameterizedSqlPStatement, SqlPStatement, statement, データベースレコードリーダ, データリーダ

</details>
