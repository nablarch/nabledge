# テーブルキューを監視し未処理データを取り込むアプリケーションの作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/getting_started/table_queue.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchAction.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlRow.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseTableQueueReader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordReader.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlPStatement.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordListener.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Success.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchActionBase.html)

## アクションクラスを作成する

`BatchAction` を継承したアクションクラスを作成する。

- テーブルをキューとして扱うため、入力データはテーブルの検索結果となる。`BatchAction` の型パラメータには `SqlRow` を指定する。

```java
public class ProjectCreationServiceAction extends BatchAction<SqlRow> {
    // 中身の作成方法は後述
}
```

<details>
<summary>keywords</summary>

BatchAction, SqlRow, アクションクラス作成, テーブルキュー, DBメッセージング

</details>

## テーブルを監視するためのリーダを生成する

`createReader` を実装し、`DatabaseTableQueueReader` を生成する。

**`DatabaseTableQueueReader` の指定項目**:
- データベースから検索するためのリーダ（`DatabaseRecordReader`）
- 未処理データが存在しない場合の待機時間（ミリ秒）
- 主キーのカラム名のリスト

**`DatabaseRecordReader` の指定項目**:
- 未処理データを検索するための `SqlPStatement`
- 悲観ロックを行う `DatabaseRecordListener` の実装クラス（詳細: [db_messaging-multiple_process](db-messaging-multiple_process.md)）

**SQLファイルで定義するSQL**:
- 他プロセスの処理対象となることを防ぐため、未処理データの `PROCESS_ID` に自プロセスIDを設定して悲観ロックするSQL
- `STATUS = '0'` かつ `PROCESS_ID` が自プロセスIDのレコードを取得するSQL

SQLの記述ルール: [database-use_sql_file](../../component/libraries/libraries-database.md)

```java
@Override
public DataReader<SqlRow> createReader(final ExecutionContext context) {
    final DatabaseRecordReader databaseRecordReader = new DatabaseRecordReader();
    databaseRecordReader.setStatement(
            getParameterizedSqlStatement("FIND_RECEIVED_PROJECTS"), PROCESS_MAP);
    databaseRecordReader.setListener(() -> {
        final SimpleDbTransactionManager transactionManager =
                SystemRepository.get("redundancyTransaction");
        new SimpleDbTransactionExecutor<Void>(transactionManager) {
            @Override
            public Void execute(final AppDbConnection appDbConnection) {
                appDbConnection
                        .prepareParameterizedSqlStatementBySqlId(
                                SQL_ID_PREFIX + "UPDATE_PROCESS_ID")
                        .executeUpdateByMap(PROCESS_MAP);
                return null;
            }
        }.doTransaction();
    });
    return new DatabaseTableQueueReader(
            databaseRecordReader, 1000, "RECEIVED_MESSAGE_SEQUENCE");
}
```

```sql
-- 未処理の受信データを悲観ロックするSQL
UPDATE_PROCESS_ID=
update ins_project_receive_message
set process_id = :processId
where status = '0' and process_id is null

-- 未処理の受信データを取得するSQL
FIND_RECEIVED_PROJECTS=
select received_message_sequence
from ins_project_receive_message
where status = '0' and process_id = :processId
```

<details>
<summary>keywords</summary>

DatabaseTableQueueReader, DatabaseRecordReader, DatabaseRecordListener, SqlPStatement, SimpleDbTransactionManager, SimpleDbTransactionExecutor, AppDbConnection, テーブル監視, 悲観ロック, 未処理データ検索, createReader

</details>

## 未処理データを元に業務処理を実行する

`handle` メソッドに業務処理を実装する。

- 処理が失敗した場合は例外を送出するため、正常処理時は常に `Result.Success` を返却する。

```java
@Override
public Result handle(final SqlRow inputData, final ExecutionContext context) {
    final Project project = UniversalDao.findBySqlFile(
        Project.class,
        SQL_ID + "GET_RECEIVED_PROJECT",
        inputData);
    if (!isValidProjectPeriod(project)) {
        throw new ApplicationException(
            MessageUtil.createMessage(MessageLevel.ERROR, "abnormal.project.period"));
    }
    UniversalDao.insert(project);
    return new Result.Success();
}
```

<details>
<summary>keywords</summary>

handle, Result.Success, ApplicationException, MessageUtil, MessageLevel, 業務処理実装, UniversalDao, 例外送出

</details>

## 処理済みデータのステータスを更新する

処理成否に応じてNablarchがコールバックするメソッドにステータス更新処理を実装する。

- 正常処理（例外なし完了）: `transactionSuccess` にステータス正常終了更新を実装する。Nablarchが例外なし完了時にコールバックする。
- 異常処理（例外/エラー発生）: `transactionFailure` にステータス異常終了更新を実装する。Nablarchが例外/エラー発生時にコールバックする。
- `updateStatus` プライベートメソッドは `transactionSuccess` / `transactionFailure` の両メソッドから呼び出され、`getParameterizedSqlStatement("UPDATE_STATUS").executeUpdateByObject(function.apply(inputData.getString("RECEIVED_MESSAGE_SEQUENCE")))` でステータスを更新する。

SQLの記述ルール: [database-use_sql_file](../../component/libraries/libraries-database.md)

```java
@Override
protected void transactionSuccess(final SqlRow inputData, final ExecutionContext context) {
    updateStatus(inputData, StatusUpdateDto::createNormalEnd);
}

@Override
protected void transactionFailure(final SqlRow inputData, final ExecutionContext context) {
    updateStatus(inputData, StatusUpdateDto::createAbnormalEnd);
}

private void updateStatus(
    final SqlRow inputData, final Function<String, StatusUpdateDto> function) {
    getParameterizedSqlStatement("UPDATE_STATUS")
        .executeUpdateByObject(
            function.apply(inputData.getString("RECEIVED_MESSAGE_SEQUENCE")));
}

public static final class StatusUpdateDto {
    private static StatusUpdateDto createNormalEnd(String id) {
        return new StatusUpdateDto(id, "1");
    }
    private static StatusUpdateDto createAbnormalEnd(String id) {
        return new StatusUpdateDto(id, "2");
    }
}
```

```sql
UPDATE_STATUS =
update ins_project_receive_message
set status = :newStatus
where received_message_sequence = :id
```

<details>
<summary>keywords</summary>

transactionSuccess, transactionFailure, BatchActionBase, StatusUpdateDto, ステータス更新, コールバック

</details>
