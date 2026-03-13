# 常駐バッチアプリケーションのマルチプロセス化

**公式ドキュメント**: [常駐バッチアプリケーションのマルチプロセス化](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details/nablarch_batch_multiple_process.html)

## 常駐バッチアプリケーションのマルチプロセス化

基本的な構成は [データベースをキューとしたメッセージングのマルチプロセス化](../db-messaging/db-messaging-multiple_process.md) と同様だが、Actionの実装が異なる。

自作Readerを使用する場合は、悲観ロック後に処理対象データを抽出するようにするとよい。

`DatabaseRecordReader` を使用したActionの実装例（プロセスIDにはUUIDを使用）:

```java
private final String processId = UUID.randomUUID().toString();

@Override
public DatabaseRecordReader createReader(ExecutionContext context) {
    final Map<String, String> param = new HashMap<>();
    param.put("processId", processId);

    // 自身が悲観ロックした未処理データを抽出するDatabaseRecordReaderを作成する
    final DatabaseRecordReader reader = new DatabaseRecordReader();
    final ParameterizedSqlPStatement statement =
        DbConnectionContext.getConnection()
                           .prepareParameterizedSqlStatementBySqlId(
                               FileCreateRequest.class.getName() + "#GET_MISHORI_FILE_INFO");
    reader.setStatement(statement, param);

    // beforeReadRecords()コールバックに悲観ロックSQLを登録する
    // なお、この処理は別トランザクションで実行する必要がある。
    databaseRecordReader.setListener(new DatabaseRecordListener() {
      @Override
      public void beforeReadRecords() {
        new SimpleDbTransactionExecutor<Void>(SystemRepository.get("myTran")) {
          @Override
          public Void execute(final AppDbConnection connection) {
            final ParameterizedSqlPStatement statement = connection.
                prepareParameterizedSqlStatementBySqlId(
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

DatabaseRecordReader, DatabaseRecordListener, ParameterizedSqlPStatement, SimpleDbTransactionExecutor, DbConnectionContext, AppDbConnection, ExecutionContext, SystemRepository, マルチプロセス化, 悲観ロック, 常駐バッチ, beforeReadRecords

</details>
