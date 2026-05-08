# データベーステーブルキューリーダ

このデータリーダでは、データベースに対してクエリを発行し、その結果セットの中から1レコードずつ読み込んで返す。
クエリで取得したレコードを全て処理した場合には、一定時間待機後（任意の値を指定可能）に再度クエリを発行しレコードを読み込む。

マルチスレッド環境では、データベースに対してクエリを再実行した場合、他のスレッドで処理中のデータが取得される可能性がある。
本リーダでは処理中のレコードをヒープ上で管理し、他のスレッドで処理中のレコードが取得された場合には、
そのレコードをスキップし次のレコードを読み込む事で、同一レコードを複数回処理することを防止している。

**ヒープ上で管理する処理中のレコードは、処理後に削除するためヒープを圧迫することはない。**

> **Attention:**
> 本リーダは、 [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) 上で使用するものである。

> **他の実行制御基盤上で使用した場合の動作は保証できないため注意すること。
> 特に** [常駐バッチ実行制御基盤（スレッド同期型）](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident-thread-sync.md) **上で使用した場合、
> プロセスを停止できなくなるため使用してはならない**

**クラス名**

nablarch.fw.reader.DatabaseTableQueueReader

**読み込むデータの型**

nablarch.core.db.statement.SqlRow

**設定項目一覧**

以下の値をコンストラクタにて指定する。

| 設定項目 | データ型 |
|---|---|
| データベースからレコードを読み込む [データベースレコードリーダ](../../component/readers/readers-DatabaseRecordReader.md) | DatabaseRecordReader |
| データが存在しない場合の待機時間(ミリ秒) | int |
| 主キーのカラム名リスト(処理中のレコードを識別する際に使用する。 ) | String... (可変長引数) |

**使用例**

データが存在しない場合の待機時間が1000ミリ秒(1秒)で、主キーのカラム名が `ID` の場合のリーダ生成例

```java
// プリペアドステートメントを取得(SQLIDを指定)
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_DELETE_USER_LIST");

// データベースレコードリーダを生成
DatabaseRecordReader reader = new DatabaseRecordReader();
reader.setStatement(statement);

return new DatabaseTableQueueReader(reader, 1000, "ID");
```
