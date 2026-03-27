# データベースレコードリーダ

## データベースレコードリーダ

**クラス名**: `nablarch.fw.reader.DatabaseRecordReader`

**読み込むデータの型**: `nablarch.core.db.statement.SqlRow`

初回読み込み時にDBへクエリを発行し、結果セットから1レコードずつ返す。

| 設定項目 | プロパティ名 | 型 | 備考 |
|---|---|---|---|
| SQLステートメント | statement | SqlPStatement | 排他利用。いずれか必須 |
| 引数付きSQLステートメント | statement | ParameterizedSqlPStatement, Object | 排他利用。いずれか必須 |

**使用例（引数付きプリペアドステートメント）**:

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

DatabaseRecordReader, nablarch.fw.reader.DatabaseRecordReader, SqlRow, nablarch.core.db.statement.SqlRow, SqlPStatement, ParameterizedSqlPStatement, statement, データベースレコード読み込み, バッチデータリーダ, DBクエリ実行

</details>
