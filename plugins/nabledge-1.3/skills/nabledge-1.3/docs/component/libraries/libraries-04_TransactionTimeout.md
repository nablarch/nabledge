# トランザクションタイムアウト機能

## 処理シーケンス

**処理フロー:**

1. **トランザクション開始**: タイムアウト秒数と現在日時からトランザクション有効期限を算出する。
2. **SQL実行前チェック (2-1)**: SQL実行前に現在日時が有効期限を超過していればトランザクションタイムアウト例外を送出する。
3. **クエリタイムアウト設定 (2-2)**: 有効期限までの残り秒数を`java.sql.Statement#setQueryTimeout`でクエリタイムアウトとして設定する。ロック解放待ちやパフォーマンス不良のSQLでも有効期限超過時に強制中止するために設定する。
4. **SQL実行成功後チェック (2-3-1)**: クエリタイムアウトは設定秒数を超過しても例外が発生せずSQL実行が正常終了する場合があるため、成功後も有効期限超過チェックを行い、超過していればタイムアウト例外を送出する。
5. **SQL実行失敗時チェック (2-3-2)**: 例外のエラーコード（`SQLException#getErrorCode`）が設定ファイルの対象コードと一致し、かつ有効期限超過の場合にタイムアウト例外を送出する。有効期限内であれば通常のSQL例外として扱う。
6. **トランザクション終了**: タイムアウトエラー発生時は必ずロールバック。

> **注意**: トランザクション終了時はタイムアウトチェックを行わない。有効期限超過でもクライアントへの応答時間は変わらないため、正常終了を優先する。

> **注意**: `transactionTimeoutErrorCodeList`には、クエリタイムアウト発生時の例外コードを必ず含めること。例外コードはデータベースベンダーのマニュアルを参照すること。

<details>
<summary>keywords</summary>

java.sql.Statement, setQueryTimeout, トランザクションタイムアウト, クエリタイムアウト, 処理シーケンス, トランザクション有効期限, ロールバック, SQLException

</details>

## トランザクションタイムアウトを使用するための設定

**クラス**: `nablarch.core.db.transaction.JdbcTransactionFactory`

```xml
<component class="nablarch.core.db.transaction.JdbcTransactionFactory">
  <property name="isolationLevel" value="READ_COMMITTED" />
  <property name="transactionTimeoutSec" value="15" />
  <property name="transactionTimeoutErrorCodeList" value="1013,30006" />
</component>
```

| プロパティ名 | 説明 |
|---|---|
| transactionTimeoutSec | タイムアウト秒数。省略または0以下の場合、タイムアウト機能は有効化されない。 |
| transactionTimeoutErrorCodeList | タイムアウト対象のベンダー依存例外コード（`SQLException#getErrorCode`の値）。複数指定可能。最低限クエリタイムアウト時の例外コードを設定すること。ロック解放待ちの例外コードも追加可能。 |

<details>
<summary>keywords</summary>

JdbcTransactionFactory, nablarch.core.db.transaction.JdbcTransactionFactory, transactionTimeoutSec, transactionTimeoutErrorCodeList, トランザクションタイムアウト設定, タイムアウト有効化

</details>

## 注意点

**クエリタイムアウト時の動作について**

クエリタイムアウトの動作はデータベースベンダーのJDBC実装に依存する。必ず各ベンダーのマニュアルを確認すること。

> **警告**: クエリタイムアウト時にDB側のSQL実行処理が確実に取り消されるか確認すること。取り消されない場合、データ不整合の原因になるためトランザクションタイムアウト機能を使用しないこと。

**アプリケーションロジックでの処理遅延について**

タイムアウトチェックはデータベースアクセス時のみ行われる。DBアクセスを伴わない処理や無限ループが発生した場合はタイムアウトエラーにならない。

<details>
<summary>keywords</summary>

クエリタイムアウト, データ不整合, JDBC実装, 無限ループ, 注意点, トランザクションタイムアウト制限, DBアクセス

</details>
