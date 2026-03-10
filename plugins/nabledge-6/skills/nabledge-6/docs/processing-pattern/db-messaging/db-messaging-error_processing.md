# データベースをキューとしたメッセージングのエラー処理

## エラーとなったデータを除外し処理を継続する

エラーデータの除外は、例外発生時のコールバックメソッド `transactionFailure` で行う。

> **重要**: エラーデータを除外しなかった場合、エラーとなったデータが再び処理対象として抽出され、再度例外が発生する。(基本的に、同じデータを同じ状態で処理した場合、同じ結果となるため。)結果として、エラーデータを繰り返し処理し、それ以外のデータが処理できずに障害（例えば遅延障害）の原因となる。

```java
@Override
protected void transactionFailure(SqlRow inputData, ExecutionContext context) {
  // inputDataがエラーとなった際の入力データなので、
  // この情報を使用して該当レコードを処理対象外（例えば処理失敗のステータスなど）に更新する。
}
```

## プロセスを異常終了させる

プロセスを異常終了させたい場合は、`ProcessAbnormalEnd` を送出する。

> **重要**: プロセスを異常終了させると、テーブルキューの監視処理が終了するため、テーブルに未処理のデータが滞留し、データの取り込み遅延などが発生する。安易にプロセスを異常終了させるのではなく、:ref:`エラーとなったデータを除外 <db_messaging-exclude_error_data>` して処理を継続させることを推奨する。

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {

  if (isAbnormalEnd(inputData)) {
    // 異常終了すべき状態の場合は、ProcessAbnormalEndを送出する。
    throw new ProcessAbnormalEnd(100, "sample_process_failure");
  }

  return new Result.Success();
}
```
