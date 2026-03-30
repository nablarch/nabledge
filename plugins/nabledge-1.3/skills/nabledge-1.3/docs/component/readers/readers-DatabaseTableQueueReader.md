# データベーステーブルキューリーダ

## データベーステーブルキューリーダ

**クラス名**: `nablarch.fw.reader.DatabaseTableQueueReader`

**読み込むデータ型**: `nablarch.core.db.statement.SqlRow`

データベースに対してクエリを発行し、その結果セットの中から1レコードずつ読み込んで返す。クエリで取得したレコードを全て処理した場合には、指定した待機時間（ミリ秒）後に再度クエリを発行してレコードを読み込む。マルチスレッド環境では処理中レコードをヒープ上で管理し、他スレッドで処理中のレコードが取得された場合はスキップすることで同一レコードの重複処理を防止する。処理後にヒープから削除するため、ヒープを圧迫しない。

> **注意**: 本リーダは [../architectural_pattern/batch_resident](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident.md) 上でのみ使用すること。他の実行制御基盤での動作は保証されない。特に [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) 上で使用するとプロセスを停止できなくなるため使用禁止。

**コンストラクタ引数**:

| 設定項目 | 型 |
|---|---|
| データベースからレコードを読み込む [DatabaseRecordReader](readers-DatabaseRecordReader.md) | DatabaseRecordReader |
| データが存在しない場合の待機時間（ミリ秒） | int |
| 主キーのカラム名リスト（処理中レコードの識別に使用） | String... (可変長引数) |

**使用例**（待機時間1000ms、主キー `ID`）:

```java
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_DELETE_USER_LIST");

DatabaseRecordReader reader = new DatabaseRecordReader();
reader.setStatement(statement);

return new DatabaseTableQueueReader(reader, 1000, "ID");
```

<details>
<summary>keywords</summary>

DatabaseTableQueueReader, DatabaseRecordReader, ParameterizedSqlPStatement, nablarch.fw.reader.DatabaseTableQueueReader, nablarch.core.db.statement.SqlRow, SqlRow, データベーステーブルキューリーダ, 常駐バッチ, マルチスレッド重複防止, 待機時間, レコードスキップ

</details>
