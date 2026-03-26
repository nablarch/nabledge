# SQLログの出力

## 

SQLログは開発時の使用を想定しているため、DEBUGレベル以下で出力する。ロガー名：`SQL`

| ログレベル | 出力内容 |
|---|---|
| DEBUG | SQL文、実行時間、件数（検索件数や更新件数など）、トランザクションの処理結果（コミット又はロールバック） |
| TRACE | SQLパラメータ（バインド変数の値） |

**log.propertiesの設定**:
```
loggers.SQL.nameRegex=SQL
loggers.SQL.level=TRACE
loggers.SQL.writerNames=<出力先のログライタ>
```

## SqlPStatement#executeQueryメソッドの検索開始時

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SQLログ, SQLログレベル, DEBUGログ, TRACEログ, SQLパラメータ出力, ロガー設定, log.properties, 出力方針, SqlPStatement, executeQuery, 検索開始, $methodName$, $sql$, $additionalInfo$, SQLログフォーマット, プレースホルダ

</details>

## SQLログの出力

SQLログの出力に使用するクラス：

**クラス**: `nablarch.core.db.statement.SqlLogUtil`, `nablarch.core.db.statement.SqlLogFormatter`

- `BasicSqlPStatement`はSQL文・実行時間・件数のフォーマットに`SqlLogUtil`を使用する。
- トランザクションの処理結果とSQLパラメータの出力では`SqlLogUtil`を使わず直接`Logger`を使用して出力する。

ログ出力設定でロガー名に`SQL`を指定することで出力される。`SqlLogUtil`はapp-log.propertiesを読み込み`SqlLogFormatter`オブジェクトを生成して個別項目のフォーマット処理を委譲する（設定参照: :ref:`AppLog_Config`）。

**ログの出力例**（デフォルトフォーマット使用時）：
```
2011-02-08 23:07:25.182 -DEBUG- R[LOGIN00102] U[9999999999] E[AP01201102082307249470003] nablarch.core.db.statement.BasicSqlPStatement#retrieve
    SQL = [SELECT BIZ_DATE FROM BUSINESS_DATE WHERE SEGMENT = ?]
    start_position = [1] size = [0]
    query_timeout = [0] fetch_size = [500]
    additional_info:
2011-02-08 23:07:25.182 -TRACE- R[LOGIN00102] U[9999999999] E[AP01201102082307249470003] nablarch.core.db.statement.BasicSqlPStatement#Parameters
    01 = [00]
2011-02-08 23:07:25.182 -DEBUG- R[LOGIN00102] U[9999999999] E[AP01201102082307249470003] nablarch.core.db.statement.BasicSqlPStatement#retrieve
    execute_time(ms) = [0] retrieve_time(ms) = [0] count = [1]
```

**app-log.propertiesの設定**:
```
sqlLogFormatter.className=nablarch.core.db.statement.SqlLogFormatter
sqlLogFormatter.startRetrieveFormat=$methodName$\n\tSQL:$sql$\n\tstart:$startPosition$ size:$size$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endRetrieveFormat=$methodName$\n\texe:$executeTime$ms ret:$retrieveTime$ms count:$count$
sqlLogFormatter.startExecuteFormat=$methodName$\n\tSQL:$sql$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endExecuteFormat=$methodName$\n\texe:$executeTime$ms
sqlLogFormatter.startExecuteQueryFormat=$methodName$\n\tSQL:$sql$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endExecuteQueryFormat=$methodName$\n\texe:$executeTime$ms
sqlLogFormatter.startExecuteUpdateFormat=$methodName$\n\tSQL:$sql$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endExecuteUpdateFormat=$methodName$\n\texe:$executeTime$ms count:$updateCount$
sqlLogFormatter.startExecuteBatchFormat=$methodName$\n\tSQL:$sql$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endExecuteBatchFormat=$methodName$\n\texe:$executeTime$ms count:$updateCount$
```

| プロパティ名 | 設定値 |
|---|---|
| sqlLogFormatter.className | SqlLogFormatterのクラス名。差し替える場合に指定 |
| sqlLogFormatter.startRetrieveFormat | SqlPStatement#retrieve 検索開始時フォーマット |
| sqlLogFormatter.endRetrieveFormat | SqlPStatement#retrieve 検索終了時フォーマット |
| sqlLogFormatter.startExecuteFormat | SqlPStatement#execute 実行開始時フォーマット |
| sqlLogFormatter.endExecuteFormat | SqlPStatement#execute 実行終了時フォーマット |
| sqlLogFormatter.startExecuteQueryFormat | SqlPStatement#executeQuery 検索開始時フォーマット |
| sqlLogFormatter.endExecuteQueryFormat | SqlPStatement#executeQuery 検索終了時フォーマット |
| sqlLogFormatter.startExecuteUpdateFormat | SqlPStatement#executeUpdate 更新開始時フォーマット |
| sqlLogFormatter.endExecuteUpdateFormat | SqlPStatement#executeUpdate 更新終了時フォーマット |
| sqlLogFormatter.startExecuteBatchFormat | SqlPStatement#executeBatch 更新開始時フォーマット |
| sqlLogFormatter.endExecuteBatchFormat | SqlPStatement#executeBatch 更新終了時フォーマット |

## SqlPStatement#executeQueryメソッドの検索終了時

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |

**デフォルトフォーマット**:

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlLogUtil, SqlLogFormatter, BasicSqlPStatement, nablarch.core.db.statement.SqlLogUtil, nablarch.core.db.statement.SqlLogFormatter, sqlLogFormatter.className, app-log.properties, SQLログ出力方法, sqlLogFormatter.startRetrieveFormat, sqlLogFormatter.endRetrieveFormat, sqlLogFormatter.startExecuteFormat, sqlLogFormatter.endExecuteFormat, sqlLogFormatter.startExecuteQueryFormat, sqlLogFormatter.endExecuteQueryFormat, sqlLogFormatter.startExecuteUpdateFormat, sqlLogFormatter.endExecuteUpdateFormat, sqlLogFormatter.startExecuteBatchFormat, sqlLogFormatter.endExecuteBatchFormat, SqlPStatement, executeQuery, 検索終了, $methodName$, $executeTime$, 実行時間, SQLログフォーマット, プレースホルダ

</details>

## SqlPStatement#retrieveメソッドの検索開始時

`SqlPStatement#retrieve` メソッドの検索開始時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 取得開始位置 | 検索結果のデータ取得を開始する行数 |
| 取得最大件数 | 検索結果に含める最大行数 |
| タイムアウト時間 | 検索のタイムアウト時間 |
| フェッチする行数 | データ取得時のフェッチ件数 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

## SqlPStatement#executeUpdateメソッドの更新開始時

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, retrieve 検索開始時, 取得開始位置, 取得最大件数, フェッチ件数, タイムアウト時間, 付加情報, SQLログ出力項目, executeUpdate, 更新開始, $methodName$, $sql$, $additionalInfo$, SQLログフォーマット, プレースホルダ

</details>

## SqlPStatement#retrieveメソッドの検索終了時

`SqlPStatement#retrieve` メソッドの検索終了時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| データ取得時間 | 検索後のデータ取得に要した時間 |
| 検索件数 | 検索結果の件数 |

## SqlPStatement#executeUpdateメソッドの更新終了時

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| 更新件数 | $updateCount$ |

**デフォルトフォーマット**:

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$] update_count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement, retrieve 検索終了時, 実行時間, データ取得時間, 検索件数, SQLログ出力項目, executeUpdate, 更新終了, $methodName$, $executeTime$, $updateCount$, 更新件数, SQLログフォーマット, プレースホルダ

</details>

## SqlPStatement#executeメソッドの実行開始時

`SqlPStatement#execute` メソッドの実行開始時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

## SqlPStatement#executeBatchメソッドの更新開始時

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, execute 実行開始時, SQL文, 付加情報, SQLログ出力項目, executeBatch, 更新開始, $methodName$, $sql$, $additionalInfo$, SQLログフォーマット, プレースホルダ

</details>

## SqlPStatement#executeメソッドの実行終了時

`SqlPStatement#execute` メソッドの実行終了時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |

## SqlPStatement#executeBatchメソッドの更新終了時

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| バッチ件数 | $batchCount$ |

**デフォルトフォーマット**:

```bash
$methodName$
    $\n\texecute_time(ms) = [$executeTime$] batch_count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement, execute 実行終了時, 実行時間, SQLログ出力項目, executeBatch, 更新終了, $methodName$, $executeTime$, $batchCount$, $updateCount$, バッチ件数, SQLログフォーマット, プレースホルダ

</details>

## SqlPStatement#executeQueryメソッドの検索開始時

`SqlPStatement#executeQuery` メソッドの検索開始時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

## SQLログの出力例

**log.propertiesの設定例**:

```bash
writerNames=appFile

# ログの出力先
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=./app.log
writer.appFile.encoding=UTF-8
writer.appFile.maxFileSize=10000
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=$date$ -$logLevel$- R[$requestId$] U[$userId$] E[$executionId$] $message$

availableLoggersNamesOrder=SQL

# SQL
loggers.SQL.nameRegex=SQL
loggers.SQL.level=TRACE
loggers.SQL.writerNames=appFile
```

**app-log.propertiesの設定例**:

```bash
# SqlLogFormatterの設定(個別項目のフォーマット)
sqlLogFormatter.startRetrieveFormat=$methodName$\n\tSQL:$sql$\n\tstart:$startPosition$ size:$size$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endRetrieveFormat=$methodName$\n\texe:$executeTime$ms ret:$retrieveTime$ms count:$count$
```

**出力結果例**:

```bash
2011-02-15 18:06:05.952 -DEBUG- R[LOGIN00102] U[9999999999] E[APUSRMGR0001201102151806058420002] nablarch.core.db.statement.BasicSqlPStatement#retrieve
    SQL:SELECT BIZ_DATE FROM BUSINESS_DATE WHERE SEGMENT = ?
    start:1 size:0
    additional_info:
2011-02-15 18:06:05.952 -TRACE- R[LOGIN00102] U[9999999999] E[APUSRMGR0001201102151806058420002] nablarch.core.db.statement.BasicSqlPStatement#Parameters
    01 = [00]
2011-02-15 18:06:05.952 -DEBUG- R[LOGIN00102] U[9999999999] E[APUSRMGR0001201102151806058420002] nablarch.core.db.statement.BasicSqlPStatement#retrieve
    exe:0ms ret:0ms count:1
2011-02-15 18:06:05.952 -DEBUG- R[LOGIN00102] U[9999999999] E[APUSRMGR0001201102151806058420002] nablarch.core.db.transaction.JdbcTransaction#commit()
```

<details>
<summary>keywords</summary>

SqlPStatement, executeQuery 検索開始時, SQL文, 付加情報, SQLログ出力項目, SQLログ, 出力例, log.properties, app-log.properties, FileLogWriter, BasicLogFormatter, availableLoggersNamesOrder, loggers.SQL, TRACE, sqlLogFormatter.startRetrieveFormat, sqlLogFormatter.endRetrieveFormat, 設定例

</details>

## SqlPStatement#executeQueryメソッドの検索終了時

`SqlPStatement#executeQuery` メソッドの検索終了時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 検索の実行時間 |

<details>
<summary>keywords</summary>

SqlPStatement, executeQuery 検索終了時, 実行時間, SQLログ出力項目

</details>

## SqlPStatement#executeUpdateメソッドの更新開始時

`SqlPStatement#executeUpdate` メソッドの更新開始時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

<details>
<summary>keywords</summary>

SqlPStatement, executeUpdate 更新開始時, SQL文, 付加情報, SQLログ出力項目

</details>

## SqlPStatement#executeUpdateメソッドの更新終了時

`SqlPStatement#executeUpdate` メソッドの更新終了時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| 更新件数 | 更新件数 |

<details>
<summary>keywords</summary>

SqlPStatement, executeUpdate 更新終了時, 実行時間, 更新件数, SQLログ出力項目

</details>

## SqlPStatement#executeBatchメソッドの更新開始時

`SqlPStatement#executeBatch` メソッドの更新開始時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

<details>
<summary>keywords</summary>

SqlPStatement, executeBatch 更新開始時, SQL文, 付加情報, SQLログ出力項目

</details>

## SqlPStatement#executeBatchメソッドの更新終了時

`SqlPStatement#executeBatch` メソッドの更新終了時の出力項目：

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| バッチ件数 | バッチ件数 |

<details>
<summary>keywords</summary>

SqlPStatement, executeBatch 更新終了時, 実行時間, バッチ件数, SQLログ出力項目

</details>

## SqlPStatement#retrieveメソッドの検索開始時

`SqlPStatement#retrieve` 検索開始時のフォーマットプレースホルダ：

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 取得開始位置 | $startPosition$ |
| 取得最大件数 | $size$ |
| タイムアウト時間 | $queryTimeout$ |
| フェッチする行数 | $fetchSize$ |
| 付加情報 | $additionalInfo$ |

デフォルトフォーマット：
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tstart_position = [$startPosition$] size = [$size$]
    \n\tquery_timeout = [$queryTimeout$] fetch_size = [$fetchSize$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, retrieve フォーマット, $methodName$, $sql$, $startPosition$, $size$, $queryTimeout$, $fetchSize$, $additionalInfo$, プレースホルダ, startRetrieveFormat

</details>

## SqlPStatement#retrieveメソッドの検索終了時

`SqlPStatement#retrieve` 検索終了時のフォーマットプレースホルダ：

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| データ取得時間 | $retrieveTime$ |
| 検索件数 | $count$ |

デフォルトフォーマット：
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] retrieve_time(ms) = [$retrieveTime$] count = [$count$]
```

<details>
<summary>keywords</summary>

SqlPStatement, retrieve フォーマット, $methodName$, $executeTime$, $retrieveTime$, $count$, プレースホルダ, endRetrieveFormat

</details>

## SqlPStatement#executeメソッドの実行開始時

`SqlPStatement#execute` 実行開始時のフォーマットプレースホルダ：

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

デフォルトフォーマット：
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, execute フォーマット, $methodName$, $sql$, $additionalInfo$, プレースホルダ, startExecuteFormat

</details>

## SqlPStatement#executeメソッドの実行終了時

`SqlPStatement#execute` 実行終了時のフォーマットプレースホルダ：

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |

デフォルトフォーマット：
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlPStatement, execute フォーマット, $methodName$, $executeTime$, プレースホルダ, endExecuteFormat

</details>
