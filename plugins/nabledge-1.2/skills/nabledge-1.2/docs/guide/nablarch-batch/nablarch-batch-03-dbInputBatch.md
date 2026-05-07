# データベースを入力とするバッチ

[ユーザ情報削除バッチ](../../guide/nablarch-batch/nablarch-batch-01-userDeleteBatchSpec.md)
を例に、データベースを入力とするバッチ処理の実装方法を説明する。

![userDeleteBatch.jpg](../../../knowledge/assets/nablarch-batch-03-dbInputBatch/userDeleteBatch.jpg)

## 初期化処理

初期化処理では、削除条件の日付を算出する。
算出した初期化を本処理でも使用できるよう、ExecutionContextに設定している。

```java
/**
 * {@inheritDoc}
 * 事前処理として、削除条件となる日付（システム日付の2年前）を算出し、セッションに保持する。
 */
@Override
protected void initialize(CommandLine command, ExecutionContext context) {

    // 削除条件の日付を算出しログ出力
    String today = SystemTimeUtil.getDateString();
    String deleteDate = DateUtil.addMonth(today, RETENTION_PERIOD);
    writeLog("MB11AA0101", DateUtil.formatDate(deleteDate, "yyyy/MM/dd"));

    // 削除条件をセッションに格納
    context.setSessionScopedVar(DATE_DATE_SESSION_KEY, deleteDate);

}
```

writeLogメソッドについては、 [ログ出力](../../guide/nablarch-batch/nablarch-batch-03-dbInputBatch.md#ログ出力) を参照。

## リーダ作成

削除対象のユーザ一覧を読み込むリーダを生成する。
削除対象となるユーザの一覧をSQLを発行して取得する。

取得した `SqlResultSet` を `DatabaseRecordReader` に与えることで、
リーダを作成することができる。

```java
/**
 * {@inheritDoc}
 * 削除対象のユーザ一覧を読み込む{@link DataReader}を生成する。
 */
@Override
public DataReader<SqlRow> createReader(ExecutionContext ctx) {

    // 初期化処理で算出した削除条件日付をセッションから取得する
    SystemAccountEntity condition = new SystemAccountEntity();
    condition.setEffectiveDateTo(ctx.<String>getSessionScopedVar(
            DATE_DATE_SESSION_KEY));

    // ログ出力用にレコード件数を取得
    int count = countByParameterizedSql("GET_DELETE_USER_LIST", condition);
    // 処理対象件数をログ出力
    writeLog("M000000001", count);

    // リーダを生成
    DatabaseRecordReader reader = new DatabaseRecordReader();
    ParameterizedSqlPStatement statement = getParameterizedSqlStatement(
            "GET_DELETE_USER_LIST");
    reader.setStatement(statement, condition);
    return reader;
}
```

writeLogメソッドについては、 [ログ出力](../../guide/nablarch-batch/nablarch-batch-03-dbInputBatch.md#ログ出力) を参照。

## １件ごとの処理

削除対象ユーザ1件ごとの処理を行う。
この処理は、削除対象ユーザの件数分だけ繰り返し起動される。

処理概要は以下の通り。

* 削除対象ユーザの排他制御を行う（悲観的ロック）。
* 削除対象ユーザの詳細情報をデータベースより取得する。

* 排他制御を行っており必ずデータが取得できるはずなので、取得できなかった場合はエラーとみなす。

* 削除対象ユーザの情報を各テーブルから削除する。
* 削除したユーザの情報をテンポラリテーブル、削除ユーザ情報メッセージ送信テーブルに登録する。

```java
/**
 * {@inheritDoc}
 * <p/>
 * 削除対象のユーザIDに関連する下記テーブルを物理削除する。
 * <ul>
 * <li>システムアカウント:SYSTEM_ACCOUNT</li>
 * <li>システムアカウント権限:SYSTEM_ACCOUNT_AUTHORITY</li>
 * <li>グループシステムアカウント:UGROUP_SYSTEM_ACCOUNT</li>
 * <li>ユーザ情報:USERS</li>
 * </ul>
 */
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {

    // 排他制御
    ExclusiveControlUtil.updateVersion(
            new ExclusiveCtrlSystemAccountContext(
                    inputData.getString("userId")));

    // 削除対象のユーザ情報を取得する。
    SqlRow userInfo = getUserInfo(inputData.getString("userId"),
            ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));

    if (userInfo == null) {
        // ユーザデータが取得出来なかった場合は、エラーとする。
        throw new TransactionAbnormalEnd(100, "NB11AA0101",
                inputData.getString("userId"));
    }

    // ユーザ情報を削除
    CM311AC1Component component = new CM311AC1Component();
    component.deleteUser(userInfo.getString("userId"));

    // テンポラリに削除したユーザ情報を登録
    insertDeleteUserReportTemp(new DeleteUserReportTempEntity(userInfo));

    // 削除したユーザ情報を外部システムに送信するために、
    // 削除ユーザ情報メッセージ送信テーブルにデータを登録
    insertSendMessage(new DeleteUserSendMessage(userInfo));

    return new Success();
}
```

`BatchAction` クラスは、 `DbAccessSupport` クラスのサブクラスなので、
データベースアクセスの機能も備えている。
本クラスでは、以下のメソッドでスーパクラスの機能を用いてデータベースアクセスを行っている。

1. 削除対象のユーザ情報を取得するメソッド (getUserInfoメソッド)
2. 削除したユーザ情報をテンポラリテーブルに登録するメソッド (insertDeleteUserReportTempメソッド)

> **SqlRowからFormのプロパティへ値を設定する方法:**
> * >   入力データに対する精査が必要な場合

>   バリデーション機能を使用して、精査時にプロパティへの値設定を行う。
> * >   入力データに対する精査が必要ない場合(既に精査済みの値がデータベースに格納されており、精査が不用な場合)

>   FormのMapを引数に取るコンストラクタを使用して、インスタンス生成時にSqlRowが保持する値をプロパティに設定する。
>   上記実装例の場合、 *new DeleteUserReportTempEntity(userInfo)* がSqlRwoを元にFormを生成しプロパティへの値設定を行なっているコードとなる。

>   ※引数なしのコンストラクタを使用してインスタンス生成後に、明示的にセッターを呼び出すような実装はしないこと。
>   この様な実装は、プロパティ数が増えると実装コードが大幅に増え、生産性への影響や実装ミスによる不具合の原因となるためである。

> > **Note:**
> > 編集が必要な項目（例えば、金額や日付を計算して求めるような項目）などは、明示的にセッターを使用して値を設定する必要がある。
> > この様な場合は、SqlRow元にインスタンス生成を行ない、その後に値の編集及びセッターを使用して値の設定を行えば良い。

> > 以下に実装例を示す。

> > ```java
> > // SqlRowからEntityを生成
> > DeleteUserReportTempEntity entity = new DeleteUserReportTempEntity(userInfo)
> > // 編集が必要な項目は、明示的にセッターを呼び出す。
> > entity.setSampleItem(DateUtil.addDay(userInfo.getString("SampleItem"), 100));
> > ```

削除対象ユーザ詳細情報の取得に失敗した場合にエラーとするため、
 `TransactionAbnormalEnd` エラーを送出している。コンストラクタ引数は以下のとおり。

| 引数 | 説明 | 設定値 |
|---|---|---|
| exitCode | 終了コード(プロセスを終了する際に設定する値) | 100 |
| failureCode | 障害コード | NB11AA0101 |
| messageOptions | 障害コードからメッセージを取得する際に使用するオプション情報 | 取得失敗したユーザのユーザID |

本エラーを送出すると、フレームワークにて以下の処理が行われる。

1. FATALレベルでの運用ログ出力
2. 後続の業務処理を停止
3. 指定された終了コードでプロセスを終了

## エラー発生時の処理

特別な処理は必要ないため、実装しない。

## 終了処理

特別な処理は必要ないため、実装しない。

## ログ出力

レコードを件数などをログ出力している箇所があるが、
これはスーパクラスで用意された以下のメソッドを呼び出している。

```java
protected void writeLog(String msgId, Object... msgOption);
```

第１引数にメッセージID(必須)を、第２引数にメッセージへの埋め込み用オブジェクト(任意)を指定する。
この機能を使用してログ出力する場合は、使用するメッセージがメッセージテーブルに登録されている必要がある。
