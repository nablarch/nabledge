# トランザクションタイムアウト機能

## トランザクションタイムアウト機能

トランザクションを開始してから設定秒数を超過した場合、トランザクションタイムアウト例外を送出しアプリケーションを強制中止する。タイムアウト例外はデータベースアクセス時に発生する（DBアクセス時にチェックを行うため）。

## 設定

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
| transactionTimeoutSec | タイムアウト秒数。省略または0以下の場合、機能は有効化されない。 |
| transactionTimeoutErrorCodeList | タイムアウト対象とするベンダー依存の例外コード（`SQLException#getErrorCode`の値、複数指定可）。最低限クエリタイムアウト時の例外コードを設定すること。ロック解放待ちタイムアウトもタイムアウト対象にしたい場合は追加で指定する。 |

<details>
<summary>keywords</summary>

JdbcTransactionFactory, transactionTimeoutSec, transactionTimeoutErrorCodeList, トランザクションタイムアウト, タイムアウト設定, タイムアウト無効化

</details>

## 各処理の概要

トランザクションタイムアウトの処理シーケンス:

1. **トランザクション開始**: タイムアウト秒数と現在日時からトランザクション有効期限を算出する。
2. **SQL実行**:
   1. **事前チェック（2-1）**: SQL実行前に有効期限チェック。有効期限超過の場合、タイムアウトエラーを送出。
   2. **クエリタイムアウト設定（2-2）**: 現在日時から有効期限までの残り秒数を`java.sql.Statement#setQueryTimeout`で設定する。ロック解放待ちや低パフォーマンスSQLであっても有効期限超過でSQL実行を強制中止するために設定する。
   3. **事後チェック（2-3）**:
      - SQL成功時: 有効期限超過の可能性があるためタイムアウトチェックを実施。超過の場合はタイムアウトエラーを送出（クエリタイムアウトは厳密に設定秒数で打ち切られないため、SQL成功後も超過している場合がある）。
      - SQL失敗時: 発生した例外がタイムアウト対象例外コード（`SQLException#getErrorCode`の値、設定ファイルで指定）かをチェック。タイムアウト対象かつ有効期限超過の場合にタイムアウト例外を送出。
3. **トランザクション終了**: タイムアウトエラー発生時は必ずロールバックされる。

> **注意**: トランザクション終了時にはタイムアウトチェックを行わない（終了時に有効期限を過ぎていても応答時間は変わらないため、正常終了を優先する）。

> **注意**: 有効期限内であればタイムアウト対象例外が発生してもタイムアウトエラーとしない。通常のSQL実行例外として送出される。

<details>
<summary>keywords</summary>

トランザクションタイムアウト処理シーケンス, クエリタイムアウト, setQueryTimeout, 有効期限チェック, タイムアウト判定, SQLException, getErrorCode

</details>

## クエリタイムアウト時の動作について

> **警告**: クエリタイムアウトの動作はDBベンダーのJDBC実装に依存するため、必ず各ベンダー提供のマニュアルを確認すること。特に、クエリタイムアウト時にDBのSQL実行処理が確実に取り消されるかどうかを確認すること。SQL実行が取り消されない場合、データ不整合などの原因になる可能性があるため、その場合はトランザクションタイムアウト機能を使用しないこと。

<details>
<summary>keywords</summary>

クエリタイムアウト, JDBC実装, データ不整合, ベンダー依存, タイムアウト注意事項

</details>

## アプリケーションロジックでの処理遅延について

タイムアウトチェックはDBアクセス時のみ行う。DBアクセスを伴わない処理やアプリケーションロジックでの無限ループが発生した場合は、トランザクションタイムアウトエラーとならない点に注意すること。

<details>
<summary>keywords</summary>

DBアクセスなし, 無限ループ, タイムアウト非対象, 処理遅延, タイムアウト制限

</details>
