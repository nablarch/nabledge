# マルチプロセス化

**公式ドキュメント**: [マルチプロセス化](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/feature_details/multiple_process.html)

## マルチプロセス化の実装手順

マルチプロセス化の実装手順（同一DBキューのメッセージングを複数プロセスで起動する場合）:

> **警告**: 対応なしで同一データベースをキューとしたメッセージングを複数起動すると、複数プロセスが同一データを処理し2重取り込みが発生する。

1. **悲観ロック用カラムを処理対象テーブルに追加する**

   通常のステータスカラムのみでは複数プロセスが同一データを取得してしまうため、`PROCESS_ID` カラムを追加する。

   | カラム名 | 説明 |
   |---|---|
   | ID | 主キー |
   | STATUS | 未処理データかどうかを判断するためのステータスカラム |
   | PROCESS_ID | 各プロセスがレコードを悲観ロックするために使用するカラム |

2. **処理対象レコードを悲観ロックするSQLを作成する**

   `PROCESS_ID` が null（他プロセスにロックされていない）かつ未処理のレコードを自プロセスIDで更新する。

   ```sql
   UPDATE SAMPLE_TABLE
   SET PROCESS_ID = :processId
   WHERE STATUS = '0'
    AND PROCESS_ID IS NULL
   ```

3. **悲観ロックしたレコードを抽出するSQLを作成する**

   条件は未処理かつ `PROCESS_ID` が自身のプロセスIDであること。

   ```sql
   SELECT
     *
   FROM
     SAMPLE_TABLE
   WHERE
     STATUS = '0'
     AND PROCESS_ID = :processId
   ```

4. **Actionを実装する**

   `DatabaseRecordReader` に悲観ロックSQL（`DatabaseRecordListener.beforeReadRecords()` で実行）とレコード抽出SQLを設定する。

   > **重要**: 悲観ロック処理（UPDATE）は別トランザクションで実行する必要がある。`SystemRepository.get("redundancyTransaction")` でトランザクションマネージャを取得し、`SimpleDbTransactionExecutor` の `execute` メソッドの引数 `AppDbConnection` を通じてSQLを実行する。

   ```java
   private static final String PROCESS_ID = UUID.randomUUID().toString();

   @Override
   public DataReader<SqlRow> createReader(ExecutionContext context) {
       final Map<String, String> param = new HashMap<>();
       param.put("processId", PROCESS_ID);

       final DatabaseRecordReader reader = new DatabaseRecordReader();
       reader.setStatement(getParameterizedSqlStatement("FIND_RECEIVED_PROJECTS"), param);

       databaseRecordReader.setListener(new DatabaseRecordListener() {
           @Override
           public void beforeReadRecords() {
               final SimpleDbTransactionManager transactionManager = SystemRepository.get("redundancyTransaction");
               new SimpleDbTransactionExecutor<Void>(transactionManager) {
                   @Override
                   public Void execute(final AppDbConnection appDbConnection) {
                       appDbConnection
                               .prepareParameterizedSqlStatementBySqlId(SQL_ID_PREFIX + "UPDATE_PROCESS_ID")
                               .executeUpdateByMap(PROCESS_MAP);
                       return null;
                   }
               }.doTransaction();
           }
       });

       return new DatabaseTableQueueReader(reader, 1000, "RECEIVED_MESSAGE_SEQUENCE");
   }
   ```

<details>
<summary>keywords</summary>

マルチプロセス化, 2重取り込み防止, 悲観ロック, PROCESS_ID, DatabaseRecordReader, DatabaseRecordListener, DatabaseTableQueueReader, SimpleDbTransactionManager, SimpleDbTransactionExecutor, AppDbConnection, SystemRepository, DataReader, SqlRow, ExecutionContext

</details>
