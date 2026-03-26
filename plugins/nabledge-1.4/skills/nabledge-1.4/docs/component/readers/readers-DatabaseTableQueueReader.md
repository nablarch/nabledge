# データベーステーブルキューリーダ

## データベーステーブルキューリーダ

データベースに対してクエリを発行し、その結果セットの中から1レコードずつ読み込んで返す。クエリで取得したレコードを全て処理した場合には、一定時間待機後（任意の値を指定可能）に再度クエリを発行しレコードを読み込む。

**クラス名**: `nablarch.fw.reader.DatabaseTableQueueReader`

**読み込むデータの型**: `nablarch.core.db.statement.SqlRow`

> **注意**: 本リーダは [../architectural_pattern/batch_resident](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident.md) 上で使用するものである。他の実行制御基盤上で使用した場合の動作は保証できないため注意すること。特に [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) 上で使用した場合、プロセスを停止できなくなるため使用してはならない。

マルチスレッド環境では処理中レコードをヒープ上で管理し、他スレッドが同一レコードを取得した場合はスキップして重複処理を防止する。処理後はヒープから削除されるためヒープを圧迫しない。

**コンストラクタパラメータ**:

| 設定項目 | データ型 |
|---|---|
| データベースからレコードを読み込む [DatabaseRecordReader](readers-DatabaseRecordReader.md) | DatabaseRecordReader |
| データが存在しない場合の待機時間(ミリ秒) | int |
| 主キーのカラム名リスト(処理中のレコードを識別する際に使用する) | String... (可変長引数) |

**使用例** (待機時間1000ms、主キー `ID`):

```java
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_DELETE_USER_LIST");

DatabaseRecordReader reader = new DatabaseRecordReader();
reader.setStatement(statement);

return new DatabaseTableQueueReader(reader, 1000, "ID");
```

<details>
<summary>keywords</summary>

DatabaseTableQueueReader, DatabaseRecordReader, SqlRow, ParameterizedSqlPStatement, nablarch.fw.reader.DatabaseTableQueueReader, nablarch.core.db.statement.SqlRow, データベーステーブルキュー, 常駐バッチ, マルチスレッド重複処理防止, 待機時間

</details>
