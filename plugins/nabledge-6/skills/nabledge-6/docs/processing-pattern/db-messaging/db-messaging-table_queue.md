# テーブルキューを監視し未処理データを取り込むアプリケーションの作成

## アクションクラスを作成する

`BatchAction` を継承したアクションクラスを作成する。

テーブルをキューとして扱う場合、入力データはテーブルの検索結果となるため、型パラメータには `SqlRow` を指定する。

```java
public class ProjectCreationServiceAction extends BatchAction<SqlRow> {
}
```

## テーブルを監視するためのリーダを生成する

`createReader` をオーバーライドし、`DatabaseTableQueueReader` を生成して返す（:ref:`db_messaging_architecture-reader` 参照）。

**`DatabaseTableQueueReader` に指定する項目**:
- DBから検索するリーダ（`DatabaseRecordReader`）
- 未処理データが存在しない場合の待機時間（ミリ秒）
- 主キーのカラム名リスト

**`DatabaseRecordReader` に指定する項目**:
- 未処理データを検索する `SqlPStatement`
- 未処理データの悲観ロックを行う `DatabaseRecordListener` 実装（詳細は :ref:`db_messaging-multiple_process` 参照）

**SQLファイルで定義するSQL**:
- 他プロセスの処理対象にならないよう悲観ロックするSQL（`status = '0'` かつ `process_id is null` のレコードに自プロセスの `process_id` を設定）
- 自プロセス対象の未処理データを取得するSQL（`status = '0'` かつ `process_id` が自プロセスIDのレコードを取得）

SQLファイルへのSQL記述ルールは :ref:`database-use_sql_file` 参照。

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
-- 未処理データを悲観ロックするSQL
UPDATE_PROCESS_ID=
update ins_project_receive_message
set process_id = :processId
where status = '0' and process_id is null

-- 自プロセス対象の未処理データを取得するSQL
FIND_RECEIVED_PROJECTS=
select received_message_sequence
from ins_project_receive_message
where status = '0' and process_id = :processId
```

## 未処理データを元に業務処理を実行する

`handle` メソッドに業務処理を実装する。

- 正常処理時は `Result.Success` を返す
- 処理失敗時は例外を送出する（例外を送出しない場合は常に `Result.Success` を返せばよい）

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

## 処理済みデータのステータスを更新する

`transactionSuccess` に正常処理後のステータス更新を、`transactionFailure` に異常処理後のステータス更新を実装する。

- `transactionSuccess`: 例外が送出されなかった場合にNablarchからコールバックされる
- `transactionFailure`: 処理中に例外・エラーが送出されたレコードの場合にNablarchからコールバックされる

`updateStatus` ヘルパーメソッドは `getParameterizedSqlStatement("UPDATE_STATUS").executeUpdateByObject(...)` でステータスを更新する。ステータス値は `StatusUpdateDto` 内部クラスが保持し、正常終了時は `"1"`、異常終了時は `"2"` を設定する。

```java
@Override
protected void transactionSuccess(final SqlRow inputData, final ExecutionContext context) {
    // ステータスを正常に更新する
    updateStatus(inputData, StatusUpdateDto::createNormalEnd);
}

@Override
protected void transactionFailure(final SqlRow inputData, final ExecutionContext context) {
    // ステータスを異常(失敗)に更新する
    updateStatus(inputData, StatusUpdateDto::createAbnormalEnd);
}

private void updateStatus(
    final SqlRow inputData, final Function<String, StatusUpdateDto> function) {
    getParameterizedSqlStatement("UPDATE_STATUS")
        .executeUpdateByObject(
            function.apply(inputData.getString("RECEIVED_MESSAGE_SEQUENCE")));
}

public static final class StatusUpdateDto {
    // プロパティ及びアクセッサ、Javadocは省略

    private static StatusUpdateDto createNormalEnd(String id) {
        return new StatusUpdateDto(id, "1");
    }

    private static StatusUpdateDto createAbnormalEnd(String id) {
        return new StatusUpdateDto(id, "2");
    }
}
```

```sql
-- ステータスを更新するSQL
UPDATE_STATUS =
update ins_project_receive_message
set status = :newStatus
where received_message_sequence = :id
```

SQLファイルへのSQL記述ルールは :ref:`database-use_sql_file` 参照。
