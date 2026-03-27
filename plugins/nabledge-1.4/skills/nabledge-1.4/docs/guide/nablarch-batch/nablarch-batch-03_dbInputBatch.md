# データベースを入力とするバッチ

## 初期化処理

`initialize` メソッドで削除条件の日付を算出し、後続処理でも使用できるよう `ExecutionContext` に格納する。

```java
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    String today = SystemTimeUtil.getDateString();
    String deleteDate = DateUtil.addMonth(today, RETENTION_PERIOD);
    writeLog("MB11AA0101", DateUtil.formatDate(deleteDate, "yyyy/MM/dd"));
    context.setSessionScopedVar(DATE_DATE_SESSION_KEY, deleteDate);
}
```

`writeLog` メソッドについては :ref:`log_output_in_batch_action` を参照。

<details>
<summary>keywords</summary>

initialize, CommandLine, ExecutionContext, setSessionScopedVar, SystemTimeUtil, DateUtil, 初期化処理, 削除条件算出, セッション格納

</details>

## リーダ作成

取得した `SqlResultSet` を `DatabaseRecordReader` に与えることでリーダを作成する。`ParameterizedSqlPStatement` を `reader.setStatement(statement, condition)` で設定する。

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

`writeLog` メソッドについては :ref:`log_output_in_batch_action` を参照。

<details>
<summary>keywords</summary>

createReader, DatabaseRecordReader, DataReader, SqlRow, SystemAccountEntity, ParameterizedSqlPStatement, getParameterizedSqlStatement, countByParameterizedSql, SqlResultSet, リーダ作成, データベース入力バッチ

</details>

## １件ごとの処理

削除対象ユーザ1件ごとに `handle(SqlRow inputData, ExecutionContext ctx)` が呼び出される。`BatchAction` は `DbAccessSupport` のサブクラスのため、DBアクセス機能を持つ。

処理手順:
1. `ExclusiveControlUtil.updateVersion` で排他制御（悲観的ロック）
2. DBから削除対象ユーザの詳細情報を取得
3. 取得できなかった場合は `TransactionAbnormalEnd` をスロー
4. 各テーブル（SYSTEM_ACCOUNT, SYSTEM_ACCOUNT_AUTHORITY, UGROUP_SYSTEM_ACCOUNT, USERS）から物理削除
5. 削除ユーザ情報をテンポラリテーブルおよびメッセージ送信テーブルに登録

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {
    ExclusiveControlUtil.updateVersion(
            new ExclusiveCtrlSystemAccountContext(inputData.getString("userId")));
    SqlRow userInfo = getUserInfo(inputData.getString("userId"),
            ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));
    if (userInfo == null) {
        throw new TransactionAbnormalEnd(100, "NB11AA0101",
                inputData.getString("userId"));
    }
    CM311AC1Component component = new CM311AC1Component();
    component.deleteUser(userInfo.getString("userId"));
    insertDeleteUserReportTemp(new DeleteUserReportTempEntity(userInfo));
    insertSendMessage(new DeleteUserSendMessage(userInfo));
    return new Success();
}
```

**SqlRow から Form へのマッピング方法:**

- 精査が必要な場合: バリデーション機能を使用してプロパティへの値設定を行う
- 精査が不要な場合（DBに精査済みの値が格納されている場合）: Form の Map コンストラクタ（例: `new DeleteUserReportTempEntity(userInfo)`）を使用してインスタンス生成時に値をセットする

> **注意**: 引数なしコンストラクタでインスタンス生成後にセッターを個別呼び出しする実装はしないこと。プロパティ数増加で実装コードが大幅に増え、実装ミスの原因となる。

> **注意**: 編集が必要な項目（金額・日付計算など）は明示的にセッターで設定する。SqlRow からインスタンス生成後にセッターで値を編集する。

```java
DeleteUserReportTempEntity entity = new DeleteUserReportTempEntity(userInfo);
entity.setSampleItem(DateUtil.addDay(userInfo.getString("SampleItem"), 100));
```

**`TransactionAbnormalEnd` コンストラクタ引数:**

| 引数 | 説明 | 設定値 |
|---|---|---|
| exitCode | 終了コード（プロセス終了時に設定する値） | 100 |
| failureCode | 障害コード | NB11AA0101 |
| messageOptions | 障害コードからメッセージ取得時のオプション情報 | 取得失敗したユーザのユーザID |

このエラーをスローするとフレームワークが以下を実行する:
1. FATALレベルでの運用ログ出力
2. 後続の業務処理を停止
3. 指定された終了コードでプロセスを終了

<details>
<summary>keywords</summary>

handle, SqlRow, ExclusiveControlUtil, ExclusiveCtrlSystemAccountContext, CM311AC1Component, DeleteUserSendMessage, TransactionAbnormalEnd, DbAccessSupport, BatchAction, DeleteUserReportTempEntity, Success, 排他制御, 悲観的ロック, SqlRowからFormへのマッピング, 異常終了

</details>

## エラー発生時の処理

特別な処理は不要のため実装しない。

<details>
<summary>keywords</summary>

エラー発生時の処理, バッチエラー処理

</details>

## 終了処理

特別な処理は不要のため実装しない。

<details>
<summary>keywords</summary>

終了処理, バッチ終了処理

</details>

## ログ出力

`BatchAction` スーパークラスが提供する `writeLog` メソッドでログ出力する。

```java
protected void writeLog(String msgId, Object... msgOption);
```

- 第1引数 `msgId`: メッセージID（必須）
- 第2引数 `msgOption`: メッセージへの埋め込み用オブジェクト（任意）

> **注意**: このメソッドを使用する場合、対象メッセージがメッセージテーブルに登録されている必要がある。

<details>
<summary>keywords</summary>

writeLog, ログ出力, バッチログ, メッセージテーブル

</details>
