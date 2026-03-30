# データベースをインプットとするバッチ処理の場合で、精査が不要な場合でもEntityは作成する必要はありますか？

## データベースをインプットとするバッチ処理でのEntity使用方針

精査が不要な場合でも、データベースへのINSERT/UPDATE処理は基本的にEntityを生成して行うこと。

**理由**:
- 1項目ずつ `setString` / `setObject` で値を設定するより保守性・生産性が高い
- 1項目ずつ値を設定した場合、Nablarchのデータベースアクセス機能が提供する共通項目の設定機能が使用できない

**推奨実装**（Entityを使用したINSERT）:

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {
    ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SQL");
    statement.executeUpdateByObject(new SampleEntity(inputData));
    return new Success();
}
```

**クラス**: `ParameterizedSqlPStatement`

<details>
<summary>keywords</summary>

ParameterizedSqlPStatement, SqlPStatement, SqlRow, ExecutionContext, Success, executeUpdateByObject, getParameterizedSqlStatement, Entity, バッチ処理, データベース更新, INSERT, UPDATE, 共通項目設定

</details>
