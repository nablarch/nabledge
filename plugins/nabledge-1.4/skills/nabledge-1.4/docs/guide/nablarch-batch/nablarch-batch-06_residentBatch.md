# 常駐バッチ

## 常駐バッチの実装上の相違点

常駐バッチと都度起動バッチの主な相違点は以下の2点。

**入力データ取得方法**

常駐バッチでは、DBテーブルをキューのように扱える`DatabaseTableQueueReader`を使用して入力データを取得する必要がある。

```java
public DataReader<SqlRow> createReader(ExecutionContext ctx) {
    DatabaseRecordReader reader = new DatabaseRecordReader();
    SqlPStatement statement = getSqlPStatement("GET_BATCH_INPUT_DATA");
    reader.setStatement(statement);
    // DatabaseRecordReader、待機時間(ms)、主キーを指定してDatabaseTableQueueReaderを生成
    return new DatabaseTableQueueReader(reader, 1000, "user_info_id");
}
```

**実行タイミング**

| 形態 | 実行タイミング例 | 説明 |
|---|---|---|
| 都度起動バッチ | 月次 | 毎月月末にジョブスケジューラから起動される。入力データ処理が終了するとバッチプロセスは終了する |
| 常駐バッチ | 1秒毎 | データが存在しない場合のみ指定時間待機し、入力データ再取得を繰り返すためプロセスは終了しない |

<details>
<summary>keywords</summary>

DatabaseTableQueueReader, DatabaseRecordReader, SqlPStatement, 常駐バッチ, データベーステーブルキューリーダ, 常駐プロセス, createReader, ExecutionContext, DataReader, SqlRow

</details>
