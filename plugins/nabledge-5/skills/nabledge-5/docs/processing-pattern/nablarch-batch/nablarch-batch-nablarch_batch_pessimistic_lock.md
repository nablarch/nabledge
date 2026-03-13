# Nablarchバッチアプリケーションの悲観的ロック

**公式ドキュメント**: [Nablarchバッチアプリケーションの悲観的ロック](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details/nablarch_batch_pessimistic_lock.html)

## Nablarchバッチアプリケーションの悲観的ロック

## 実装ポイント

この実装パターンを参考にすることで、ロック時間が短縮され他プロセスへの影響を抑えることができる。

- データリーダでは処理対象レコードの**主キーのみ**取得する
- `handle` メソッド内で悲観的ロックを行う
- [universal_dao](../../component/libraries/libraries-universal_dao.md) を使用した悲観的ロックは :ref:`universal_dao_jpa_pessimistic_lock` を参照

**クラス**: `SampleAction`, `BatchAction`, `DatabaseRecordReader`, `SqlPStatement`, `DbConnectionContext`, `UniversalDao`

```java
public class SampleAction extends BatchAction<SqlRow> {

    @Override
    public DataReader<SqlRow> createReader(final ExecutionContext ctx) {
        final DatabaseRecordReader reader = new DatabaseRecordReader();
        final SqlPStatement statement = DbConnectionContext.getConnection()
                .prepareParameterizedSqlStatementBySqlId(
                        Project.class.getName() + "#GET_ID");
        // 検索条件の取得処理は省略
        reader.setStatement(statement, condition);
        return reader;
    }

    @Override
    public Result handle(final SqlRow inputData, final ExecutionContext ctx) {
        final Project project =
                UniversalDao.findBySqlFile(Project.class, "FIND_BY_ID_WITH_LOCK", inputData);
        // 業務処理のため省略
        UniversalDao.update(project);
        return new Success();
    }
}
```

<details>
<summary>keywords</summary>

悲観的ロック, バッチ処理, 排他制御, データリーダ, 主キー取得, SampleAction, BatchAction, DatabaseRecordReader, SqlPStatement, DbConnectionContext, UniversalDao, SqlRow, Project, ExecutionContext, Result, Success, DataReader

</details>
