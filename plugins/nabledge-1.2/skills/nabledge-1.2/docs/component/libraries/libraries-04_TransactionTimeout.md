# トランザクションタイムアウト機能

## 処理シーケンス

トランザクション開始時にタイムアウト秒数と現在日時からトランザクション有効期限を算出する。タイムアウト例外が発生するタイミングはデータベースへのアクセス時。

処理フロー:

1. **トランザクション開始**: タイムアウト秒数と現在日時からトランザクション有効期限を算出する。
2. **SQL実行前チェック**: SQL実行前に現在日時が有効期限を過ぎている場合、トランザクションタイムアウト例外を送出する。
3. **クエリタイムアウト設定**: 有効期限までの残り秒数を`java.sql.Statement#setQueryTimeout`でクエリタイムアウトに設定する。これにより、ロック解放待ちやパフォーマンス不良のSQLであっても有効期限超過時にSQL実行を強制中止できる。
4. **SQL実行後チェック**:
   - 成功時: クエリタイムアウトは設定秒数超過でも例外が発生しない場合があるため、SQL実行成功後もタイムアウトチェックを実施する。有効期限超過の場合はタイムアウト例外を送出する。
   - 失敗時: `SQLException#getErrorCode`の値が設定済みのタイムアウト対象例外コードに一致し、かつ有効期限を過ぎている場合にタイムアウト例外を送出する。有効期限内の場合は通常のSQL例外として送出する。
5. **トランザクション終了**: コミットまたはロールバック。タイムアウトエラー発生時は必ずロールバックされる。

> **注意**: トランザクション終了時はタイムアウトチェックを行わない。有効期限超過でも処理を正常終了させる。

<details>
<summary>keywords</summary>

トランザクションタイムアウト, 処理シーケンス, クエリタイムアウト, Statement#setQueryTimeout, SQLException, トランザクション有効期限, タイムアウトチェック

</details>

## トランザクションタイムアウトを使用するための設定

**クラス**: `nablarch.core.db.transaction.JdbcTransactionFactory`

トランザクションタイムアウトを有効化するには`JdbcTransactionFactory`に以下のプロパティを設定する。

```xml
<component class="nablarch.core.db.transaction.JdbcTransactionFactory">
  <property name="isolationLevel" value="READ_COMMITTED" />
  <property name="transactionTimeoutSec" value="15" />
  <property name="transactionTimeoutErrorCodeList" value="1013,30006" />
</component>
```

| プロパティ名 | 設定値 |
|---|---|
| transactionTimeoutSec | タイムアウト秒数。省略または0以下の場合、機能は有効化されない。 |
| transactionTimeoutErrorCodeList | タイムアウト対象のベンダー依存例外コード（`SQLException#getErrorCode`から取得できる値）。複数指定可能。最低限クエリタイムアウト時の例外コードを設定すること。ロック解放待ちのタイムアウトエラーもタイムアウト対象とする場合は、そのエラーコードも追加する。 |

<details>
<summary>keywords</summary>

JdbcTransactionFactory, transactionTimeoutSec, transactionTimeoutErrorCodeList, トランザクションタイムアウト設定, タイムアウト秒数, nablarch.core.db.transaction.JdbcTransactionFactory, SQLException#getErrorCode

</details>

## 注意点

**クエリタイムアウト時の動作**

> **警告**: クエリタイムアウトの動作はデータベースベンダーのJDBC実装に依存する。必ず各ベンダーのマニュアルで動作を確認すること。特に、クエリタイムアウト発生時にデータベース側のSQL実行が確実に取り消されるかを確認すること。SQL実行が取り消されない場合はデータ不整合の原因になるため、その場合はトランザクションタイムアウト機能を使用しないこと。

**アプリケーションロジックでの処理遅延**

トランザクションタイムアウト機能はデータベースアクセス時にのみ有効期限チェックを行う。データベースアクセスを伴わない処理や無限ループが発生した場合はタイムアウトエラーとならない。

<details>
<summary>keywords</summary>

クエリタイムアウト, JDBC実装依存, データ不整合, トランザクションタイムアウト注意点, アプリケーションロジック, 無限ループ

</details>
