# データベースをインプットとするバッチ処理の場合で、精査が不要な場合でもEntityは作成する必要はありますか？

## データベースINSERT/UPDATE時のEntity使用方針

精査が不要な場合でも、基本的にはEntityを生成してデータベースへのINSERT/UPDATE処理を行うこと。

Entityを使用する理由は2つある:
1. 保守性や生産性の面で、1項目ずつ値を設定するよりもEntityを使用したデータベース更新（INSERTやUPDATE）のほうがメリットが大きい。
2. 1項目ずつ値を設定した場合、Nablarchのデータベースアクセス機能が提供する共通項目の設定機能が使用できなくなる。

**非推奨（Entityなし）**:
```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {
    SqlPStatement statement = getSqlPStatement("INSERT_SQL");
    statement.setString(1, inputData.getString("id"));
    statement.setString(2, inputData.getString("name"));
    statement.setString(3, inputData.getString("kana_name"));
    statement.setString(4, inputData.getString("tel"));
    statement.executeUpdate();
    return new Success();
}
```

**推奨（Entity使用）**:
```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {
    ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SQL");
    statement.executeUpdateByObject(new SampleEntity(inputData));
    return new Success();
}
```

<details>
<summary>keywords</summary>

SqlRow, SqlPStatement, ParameterizedSqlPStatement, SampleEntity, executeUpdateByObject, ExecutionContext, Result, Success, バッチ処理, Entity使用, データベース更新, 共通項目設定, INSERT, UPDATE, 保守性, 生産性

</details>
