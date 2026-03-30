# データベースを入力とするバッチ

## 初期化処理

`initialize` メソッドで削除条件の日付を算出し、`ExecutionContext` に格納する。

```java
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    String today = SystemTimeUtil.getDateString();
    String deleteDate = DateUtil.addMonth(today, RETENTION_PERIOD);
    writeLog("MB11AA0101", DateUtil.formatDate(deleteDate, "yyyy/MM/dd"));
    context.setSessionScopedVar(DATE_DATE_SESSION_KEY, deleteDate);
}
```

ログ出力: :ref:`log_output_in_batch_action` 参照。

<details>
<summary>keywords</summary>

ExecutionContext, SystemTimeUtil, DateUtil, initialize, 初期化処理, 削除条件算出

</details>

## リーダ作成

取得した `SqlResultSet` を `DatabaseRecordReader` に設定することでリーダを作成する。

```java
@Override
public DataReader<SqlRow> createReader(ExecutionContext ctx) {
    SystemAccountEntity condition = new SystemAccountEntity();
    condition.setEffectiveDateTo(ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));
    int count = countByParameterizedSql("GET_DELETE_USER_LIST", condition);
    writeLog("M000000001", count);
    DatabaseRecordReader reader = new DatabaseRecordReader();
    ParameterizedSqlPStatement statement = getParameterizedSqlStatement("GET_DELETE_USER_LIST");
    reader.setStatement(statement, condition);
    return reader;
}
```

ログ出力: :ref:`log_output_in_batch_action` 参照。

<details>
<summary>keywords</summary>

DatabaseRecordReader, SqlResultSet, ParameterizedSqlPStatement, DataReader, SystemAccountEntity, createReader, リーダ作成, データベース入力バッチ

</details>

## １件ごとの処理

処理フロー:
1. 排他制御（悲観的ロック）: `ExclusiveControlUtil.updateVersion()` で実施
2. 削除対象ユーザの詳細情報をDBから取得（排他制御済みのためデータが必ず存在するはず）
3. データ取得失敗時は `TransactionAbnormalEnd` をスローしてエラー終了
4. 各テーブルからユーザ情報を削除
5. テンポラリテーブルおよび削除ユーザ情報メッセージ送信テーブルにデータを登録

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {
    ExclusiveControlUtil.updateVersion(
            new ExclusiveCtrlSystemAccountContext(inputData.getString("userId")));
    SqlRow userInfo = getUserInfo(inputData.getString("userId"),
            ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));
    if (userInfo == null) {
        throw new TransactionAbnormalEnd(100, "NB11AA0101", inputData.getString("userId"));
    }
    CM311AC1Component component = new CM311AC1Component();
    component.deleteUser(userInfo.getString("userId"));
    insertDeleteUserReportTemp(new DeleteUserReportTempEntity(userInfo));
    insertSendMessage(new DeleteUserSendMessage(userInfo));
    return new Success();
}
```

**クラス**: `BatchAction`, `DbAccessSupport`

`BatchAction` は `DbAccessSupport` のサブクラスのため、データベースアクセス機能を備える。

> **注意**: **SqlRowからFormのプロパティへ値を設定する方法**
>
> - **精査が必要な場合**: バリデーション機能を使用してプロパティへの値設定を行う。
> - **精査が不要な場合**: FormのMapを引数に取るコンストラクタでインスタンス生成時にSqlRowの値をプロパティに設定する（例: `new DeleteUserReportTempEntity(userInfo)`）。引数なしコンストラクタでインスタンス生成後に明示的にセッターを呼び出す実装はしないこと（プロパティ数増加でコード量が大幅増加し、実装ミスの原因となる）。
> - 編集が必要な項目（金額・日付計算等）は明示的にセッターを使用して値を設定する。この場合は、SqlRowを元にインスタンス生成を行い、その後に値の編集およびセッターで値を設定する。
>
>   ```java
>   // SqlRowからEntityを生成
>   DeleteUserReportTempEntity entity = new DeleteUserReportTempEntity(userInfo)
>   // 編集が必要な項目は、明示的にセッターを呼び出す。
>   entity.setSampleItem(DateUtil.addDay(userInfo.getString("SampleItem"), 100));
>   ```

**TransactionAbnormalEnd** のコンストラクタ引数:

| 引数 | 説明 | 設定値 |
|---|---|---|
| exitCode | 終了コード（プロセス終了時に設定する値） | 100 |
| failureCode | 障害コード | NB11AA0101 |
| messageOptions | 障害コードからメッセージ取得時のオプション情報 | 取得失敗したユーザのユーザID |

`TransactionAbnormalEnd` をスローした場合のフレームワーク処理:
1. FATALレベルでの運用ログ出力
2. 後続の業務処理を停止
3. 指定された終了コードでプロセスを終了

<details>
<summary>keywords</summary>

SqlRow, ExclusiveControlUtil, ExclusiveCtrlSystemAccountContext, CM311AC1Component, DeleteUserReportTempEntity, DeleteUserSendMessage, TransactionAbnormalEnd, BatchAction, DbAccessSupport, Success, handle, 排他制御, 悲観的ロック, SqlRow値設定

</details>

## エラー発生時の処理

エラー発生時の処理は不要。特別な実装は行わない。

<details>
<summary>keywords</summary>

エラー発生時の処理, BatchAction エラーハンドリング, バッチエラー処理

</details>

## 終了処理

終了処理は不要。特別な実装は行わない。

<details>
<summary>keywords</summary>

終了処理, バッチ終了処理, BatchAction 後処理

</details>

## ログ出力

スーパークラスで用意された `writeLog` メソッドを使用してログ出力を行う。

```java
protected void writeLog(String msgId, Object... msgOption);
```

- 第1引数: メッセージID（必須）
- 第2引数: メッセージへの埋め込み用オブジェクト（任意）

> **注意**: `writeLog` を使用する場合、使用するメッセージがメッセージテーブルに登録されている必要がある。

<details>
<summary>keywords</summary>

writeLog, ログ出力, メッセージID, BatchAction ログ, msgOption

</details>
