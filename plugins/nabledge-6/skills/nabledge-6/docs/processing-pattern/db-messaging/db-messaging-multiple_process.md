# マルチプロセス化

**公式ドキュメント**: [マルチプロセス化](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/feature_details/multiple_process.html)

## マルチプロセス化

> **警告**: 同一のデータベースをキューとしたメッセージングを何も対応せずに複数起動した場合、同一データを処理し2重取り込みの障害が発生する。

マルチプロセスでDBキューメッセージングを起動したい場合（例: 冗長化構成の複数のサーバ上で同一のデータベースをキューとしたメッセージングを起動するケースなど）、アプリケーション側で複数起動できるように対応する必要がある。

実装手順:

1. 処理対象テーブルに悲観ロック用カラム(`PROCESS_ID`)を追加する。

   | カラム名 | 説明 |
   |---|---|
   | ID | 主キー |
   | STATUS | 未処理データかどうかを判断するためのステータスカラム |
   | PROCESS_ID | 各プロセスがレコードを悲観ロックするために使用するカラム |

2. 他のプロセスからロックされていない未処理データを悲観ロックするSQLを作成する。`PROCESS_ID`がnullかつ`STATUS`が未処理のレコードに自身のプロセスIDをセットする:

   ```sql
   UPDATE SAMPLE_TABLE
   SET PROCESS_ID = :processId
   WHERE STATUS = '0'
    AND PROCESS_ID IS NULL
   ```

3. 悲観ロック済みレコード（`STATUS`が未処理かつ`PROCESS_ID`が自身のプロセスID）を抽出するSQLを作成する:

   ```sql
   SELECT
     *
   FROM
     SAMPLE_TABLE
   WHERE
     STATUS = '0'
     AND PROCESS_ID = :processId
   ```

4. Actionに悲観ロック処理と抽出処理を実装する。`DatabaseRecordReader`のリスナー（`DatabaseRecordListener`）に悲観ロックSQLを登録し、`SimpleDbTransactionManager`で別トランザクションとして実行する。

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

> **重要**: 悲観ロックSQL（`beforeReadRecords`内）は別トランザクションで実行する必要がある。

<details>
<summary>keywords</summary>

DatabaseRecordReader, DatabaseRecordListener, SimpleDbTransactionManager, SimpleDbTransactionExecutor, DatabaseTableQueueReader, SystemRepository, beforeReadRecords, AppDbConnection, DataReader, SqlRow, ExecutionContext, マルチプロセス化, 悲観ロック, DBキューメッセージング複数起動, 2重取り込み防止, PROCESS_ID, 冗長化構成

</details>
