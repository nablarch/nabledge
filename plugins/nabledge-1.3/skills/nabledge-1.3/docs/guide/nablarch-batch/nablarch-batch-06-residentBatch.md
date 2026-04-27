# 常駐バッチ

常駐バッチの場合でも、アプリケーション実装方法は都度実行バッチと基本的には同じである。

以下に、都度起動バッチと異なる実装点について解説する。

**入力データを取得するためのデータリーダ生成方法が異なる**

常駐バッチの場合には、データベースのテーブルをキューのように扱える
`データベーステーブルキューリーダ` を使用して入力データを取得する必要がある。

以下に `データベーステーブルキューリーダ` の使用例を示す。

```java
public DataReader<SqlRow> createReader(ExecutionContext ctx) {

    // 入力データをデータベースから取得するためのDatabaseRecordReaderを生成する。
    DatabaseRecordReader reader = new DatabaseRecordReader();
    SqlPStatement statement = getSqlPStatement("GET_BATCH_INPUT_DATA");
    reader.setStatement(statement);

    // 生成したDatabaseRecordReader及び、データが存在しない場合の待機時間(ms)と
    // 主キーを指定してDatabaseTableQueueReaderを生成する。
    return new DatabaseTableQueueReader(reader, 1000, "user_info_id");
}
```

**実行タイミングが異なる**

都度起動バッチはジョブスケジューラなどから決まったタイミングで実行されることを想定しているが、
常駐バッチでは起動されるとプロセスは終了せずに入力データを定期的に取得し処理を行う。

以下に例を示す。

| 形態 | 実行タイミング例 | 説明 |
|---|---|---|
| 都度起動バッチ | 月次 | 毎月月末にジョブスケジューラから起動される  入力データに対する処理が終了すると、 バッチプロセスは終了する。 |
| 常駐バッチ | 1秒毎 | データが存在しなかった場合のみ、左記の時間分 待機する。  待機後に入力データの再取得繰り返すため、 バッチプロセスは終了しない。 |
