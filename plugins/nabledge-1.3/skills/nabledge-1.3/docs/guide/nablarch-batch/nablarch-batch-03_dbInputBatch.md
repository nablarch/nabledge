# データベースを入力とするバッチ

## 初期化処理

`initialize`メソッドで削除条件の日付を算出し、`ExecutionContext`のセッションスコープ変数に格納する。後続の`createReader`・`handle`メソッドでセッションから取得して使用する。

```java
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    String today = SystemTimeUtil.getDateString();
    String deleteDate = DateUtil.addMonth(today, RETENTION_PERIOD);
    writeLog("MB11AA0101", DateUtil.formatDate(deleteDate, "yyyy/MM/dd"));
    context.setSessionScopedVar(DATE_DATE_SESSION_KEY, deleteDate);
}
```

ログ出力については「ログ出力」セクションを参照。

<details>
<summary>keywords</summary>

ExecutionContext, SystemTimeUtil, DateUtil, setSessionScopedVar, initialize, CommandLine, 初期化処理, 削除条件日付算出, セッションスコープ設定

</details>

## リーダ作成

`createReader`メソッドで`DatabaseRecordReader`を生成する。セッションから削除条件日付を取得し、`SystemAccountEntity`を条件オブジェクトとして使用する。取得した`SqlResultSet`を`DatabaseRecordReader`に与えることでリーダを作成できる。`ParameterizedSqlPStatement`をリーダに設定する。

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

ログ出力については「ログ出力」セクションを参照。

<details>
<summary>keywords</summary>

DatabaseRecordReader, ParameterizedSqlPStatement, DataReader, SqlRow, SqlResultSet, SystemAccountEntity, createReader, getParameterizedSqlStatement, countByParameterizedSql, リーダ作成, データベース入力バッチ

</details>

## １件ごとの処理

`handle`メソッドで削除対象ユーザ1件の処理を行う。処理概要:

1. 排他制御（悲観的ロック）: `ExclusiveControlUtil.updateVersion()`を使用
2. ユーザ詳細情報をDBから取得。取得できなかった場合はエラー（`TransactionAbnormalEnd`を送出）
3. 各テーブル（SYSTEM_ACCOUNT、SYSTEM_ACCOUNT_AUTHORITY、UGROUP_SYSTEM_ACCOUNT、USERS）からユーザ情報を物理削除
4. テンポラリテーブルおよび削除ユーザ情報メッセージ送信テーブルに登録

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

`BatchAction`は`DbAccessSupport`のサブクラスのため、データベースアクセス機能を備えている。

**`TransactionAbnormalEnd`のコンストラクタ引数:**

| 引数 | 説明 | 設定値 |
|---|---|---|
| exitCode | 終了コード（プロセス終了時に設定する値） | 100 |
| failureCode | 障害コード | NB11AA0101 |
| messageOptions | 障害コードからメッセージ取得時に使用するオプション情報 | 取得失敗したユーザのユーザID |

`TransactionAbnormalEnd`送出時のフレームワーク動作:
1. FATALレベルでの運用ログ出力
2. 後続の業務処理を停止
3. 指定された終了コードでプロセスを終了

**`SqlRow`からFormへの値設定方法:**

> **重要**: 引数なしコンストラクタでインスタンス生成後に明示的にセッターを呼び出す実装はしないこと。プロパティ数が増えると実装コードが大幅に増え、実装ミスによる不具合の原因となる。

- 精査が必要な場合: バリデーション機能を使用してプロパティへの値設定を行う
- 精査が不要な場合（既にDBに精査済み値が格納されている場合）: `Map`を引数に取るコンストラクタを使用してインスタンス生成時に`SqlRow`の値をプロパティに設定する（例: `new DeleteUserReportTempEntity(userInfo)`）

> **注意**: 編集が必要な項目（金額や日付の計算など）は、`Map`コンストラクタでインスタンス生成後、明示的にセッターで値を設定する。

```java
DeleteUserReportTempEntity entity = new DeleteUserReportTempEntity(userInfo);
entity.setSampleItem(DateUtil.addDay(userInfo.getString("SampleItem"), 100));
```

<details>
<summary>keywords</summary>

ExclusiveControlUtil, ExclusiveCtrlSystemAccountContext, TransactionAbnormalEnd, BatchAction, DbAccessSupport, SqlRow, DeleteUserReportTempEntity, CM311AC1Component, DeleteUserSendMessage, Success, 排他制御, 悲観的ロック, SqlRowからFormへの変換, エラー終了コード, handle

</details>

## エラー発生時の処理

特別な処理は必要ないため、実装しない。

<details>
<summary>keywords</summary>

エラー発生時処理, バッチエラー処理

</details>

## 終了処理

特別な処理は必要ないため、実装しない。

<details>
<summary>keywords</summary>

終了処理, バッチ終了処理

</details>

## ログ出力

スーパークラスの`writeLog`メソッドを使用してログ出力を行う。

```java
protected void writeLog(String msgId, Object... msgOption);
```

- 第1引数: メッセージID（必須）
- 第2引数: メッセージへの埋め込みオブジェクト（任意）

このメソッドを使用する場合、使用するメッセージがメッセージテーブルに登録されている必要がある。

<details>
<summary>keywords</summary>

writeLog, ログ出力, メッセージID, メッセージテーブル

</details>
