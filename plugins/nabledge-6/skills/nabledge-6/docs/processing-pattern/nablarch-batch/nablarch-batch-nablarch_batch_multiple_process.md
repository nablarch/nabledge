# 常駐バッチアプリケーションのマルチプロセス化

**公式ドキュメント**: [常駐バッチアプリケーションのマルチプロセス化](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details/nablarch_batch_multiple_process.html)

## 常駐バッチアプリケーションのマルチプロセス化

基本的な設定は :ref:`db_messaging-multiple_process` と同様。

Actionの実装はデータベースをキューとしたメッセージングとは異なる。`DatabaseRecordReader`を使用する場合の実装ポイント:

- `processId`は`UUID.randomUUID().toString()`で生成
- `createReader`で自身が悲観ロックした未処理データを抽出する`DatabaseRecordReader`を作成
- `DatabaseRecordListener.beforeReadRecords()`コールバックに悲観ロックSQLを登録する
- 悲観ロック処理は別トランザクション（`SimpleDbTransactionExecutor`）で実行する必要がある

> **補足**: 自作Readerの場合も同様に、悲観ロック後に処理対象データを抽出するよう実装すること。

```java
private final String processId = UUID.randomUUID().toString();

@Override
public DatabaseRecordReader createReader(ExecutionContext context) {
    final Map<String, String> param = new HashMap<>();
    param.put("processId", processId);

    final DatabaseRecordReader reader = new DatabaseRecordReader();
    final ParameterizedSqlPStatement statement =
        DbConnectionContext.getConnection()
                           .prepareParameterizedSqlStatementBySqlId(
                               FileCreateRequest.class.getName() + "#GET_MISHORI_FILE_INFO");
    reader.setStatement(statement, param);

    databaseRecordReader.setListener(new DatabaseRecordListener() {
      @Override
      public void beforeReadRecords() {
        new SimpleDbTransactionExecutor<Void>(SystemRepository.get("myTran")) {
          @Override
          public Void execute(final AppDbConnection connection) {
            final ParameterizedSqlPStatement statement = connection
                .prepareParameterizedSqlStatementBySqlId(
                    FileCreateRequest.class.getName() + "#MARK_UNPROCESSED_DATA");
            statement.executeUpdateByMap(param);
            return null;
          }
        }.doTransaction();
      }
    });

    return reader;
}
```

<details>
<summary>keywords</summary>

DatabaseRecordReader, DatabaseRecordListener, SimpleDbTransactionExecutor, ParameterizedSqlPStatement, DbConnectionContext, ExecutionContext, AppDbConnection, FileCreateRequest, SystemRepository, UUID, マルチプロセス化, 悲観ロック, 常駐バッチ, processId UUID

</details>
