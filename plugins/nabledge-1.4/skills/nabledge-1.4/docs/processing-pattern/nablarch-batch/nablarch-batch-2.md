# データベースをインプットとするバッチ処理の場合で、精査が不要な場合でもEntityは作成する必要はありますか？

## 精査不要なバッチ処理でのEntity使用方針

精査が不要な場合でも、基本的にはEntityを生成してデータベースへのINSERTやUPDATE処理を行うこと。1項目ずつ値を設定する実装よりもEntityを使用したDB更新のほうが保守性・生産性の面でメリットが大きい。

> **重要**: 1項目ずつ値を設定した場合、Nablarchのデータベースアクセス機能が提供する共通項目の設定機能が使用不可になる。

**非推奨の実装例（Entityを使わない場合）**:
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

**推奨の実装例（Entityを使う場合）**:
```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {
    ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SQL");
    statement.executeUpdateByObject(new SampleEntity(inputData));
    return new Success();
}
```

関連情報: [6](nablarch-batch-6.md)

<details>
<summary>keywords</summary>

SqlPStatement, ParameterizedSqlPStatement, SqlRow, ExecutionContext, executeUpdateByObject, Entity使用, データベース更新, INSERT, UPDATE, 共通項目設定, バッチ処理, Result, Success, SampleEntity

</details>
