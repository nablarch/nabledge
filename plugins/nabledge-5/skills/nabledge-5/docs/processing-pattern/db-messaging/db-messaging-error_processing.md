# データベースをキューとしたメッセージングのエラー処理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/feature_details/error_processing.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchActionBase.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html)

## エラーとなったデータを除外し処理を継続する

エラーとなったデータの除外は、例外発生時のコールバックメソッド `transactionFailure` で行う。

> **重要**: エラーデータを除外しなかった場合、エラーとなったデータが再び処理対象として抽出され、再度例外が発生する。（基本的に、同じデータを同じ状態で処理した場合、同じ結果となるため。）結果として、エラーデータを繰り返し処理し、それ以外のデータが処理できずに障害（例えば、遅延障害）の原因となる。

```java
@Override
protected void transactionFailure(SqlRow inputData, ExecutionContext context) {
  // inputDataがエラーとなった際の入力データなので、
  // この情報を使用して該当レコードを処理対象外(例えば、処理失敗のステータスなど)に更新する。
}
```

<details>
<summary>keywords</summary>

transactionFailure, BatchActionBase, SqlRow, ExecutionContext, エラーデータ除外, 処理継続, トランザクション失敗コールバック

</details>

## プロセスを異常終了させる

プロセスを異常終了させる場合は、`ProcessAbnormalEnd` を送出する。

> **重要**: プロセスを異常終了させると、テーブルキューの監視処理が終了するため、テーブルに未処理のデータが滞留し、データの取り込み遅延などが発生する。安易にプロセスを異常終了させるのではなく、[エラーとなったデータを除外](#s1) して処理を継続させることを推奨する。

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

<details>
<summary>keywords</summary>

ProcessAbnormalEnd, プロセス異常終了, テーブルキュー監視, 異常終了抑制, 処理中断, Result, Result.Success

</details>
