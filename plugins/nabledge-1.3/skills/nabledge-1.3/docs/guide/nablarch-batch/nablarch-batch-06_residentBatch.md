# 常駐バッチ

## 常駐バッチ

常駐バッチの実装方法は都度起動バッチと基本的に同じ。以下の2点が異なる。

**入力データを取得するためのデータリーダ生成方法が異なる**

常駐バッチではデータベースのテーブルをキューとして扱える`DatabaseTableQueueReader`を使用して入力データを取得する必要がある。

```java
public DataReader<SqlRow> createReader(ExecutionContext ctx) {
    DatabaseRecordReader reader = new DatabaseRecordReader();
    SqlPStatement statement = getSqlPStatement("GET_BATCH_INPUT_DATA");
    reader.setStatement(statement);
    // 待機時間(ms)と主キーを指定してDatabaseTableQueueReaderを生成
    return new DatabaseTableQueueReader(reader, 1000, "user_info_id");
}
```

**実行タイミングが異なる**

| 形態 | 実行タイミング例 | 説明 |
|---|---|---|
| 都度起動バッチ | 月次 | ジョブスケジューラから起動。入力データ処理完了後にプロセス終了。 |
| 常駐バッチ | 1秒毎 | データなしの場合のみ待機。入力データの再取得を繰り返すためプロセスは終了しない。 |

<details>
<summary>keywords</summary>

DatabaseTableQueueReader, DatabaseRecordReader, SqlPStatement, DataReader, ExecutionContext, SqlRow, 常駐バッチ, データベーステーブルキューリーダ, 入力データ取得, createReader, 常駐バッチ実装方法, getSqlPStatement, GET_BATCH_INPUT_DATA

</details>
