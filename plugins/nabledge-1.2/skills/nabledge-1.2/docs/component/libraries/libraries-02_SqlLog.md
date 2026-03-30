# SQLログの出力

## 

SQLログはパフォーマンスチューニング用にSQL文の実行時間やSQL文を出力する。開発時使用を想定しDEBUGレベル以下で出力。

**ログレベルとロガー名**

| ログレベル | ロガー名 |
|---|---|
| DEBUG、TRACE | SQL |

**ログレベルと出力内容**

| ログレベル | 出力内容 |
|---|---|
| DEBUG | SQL文、実行時間、件数（検索件数や更新件数など）、トランザクションの処理結果（コミット又はロールバック） |
| TRACE | SQLパラメータ（バインド変数の値） |

log.propertiesの設定:
```properties
loggers.SQL.nameRegex=SQL
loggers.SQL.level=TRACE
loggers.SQL.writerNames=<出力先のログライタ>
```

SQLログの出力項目は :ref:`Log_BasicLogFormatter` の共通項目を除いた個別項目。共通項目と組み合わせたフォーマットは :ref:`AppLog_Format` を参照。

## SqlPStatement#executeQueryメソッドの検索開始時

プレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | `$methodName$` |
| SQL文 | `$sql$` |
| 付加情報 | `$additionalInfo$` |

デフォルトフォーマット:

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SQLログ, パフォーマンスチューニング, ログレベル, DEBUGレベル, Log_BasicLogFormatter, AppLog_Format, SQLログ出力方針, SqlPStatement, executeQuery, 検索開始時, $methodName$, $sql$, $additionalInfo$, SQLログ プレースホルダ, 検索ログフォーマット

</details>

## SQLログの出力

**クラス**: `nablarch.core.db.statement.SqlLogUtil`, `nablarch.core.db.statement.SqlLogFormatter`

`BasicSqlPStatement`はSQL文/実行時間/件数のフォーマットに`SqlLogUtil`を使用。トランザクション処理結果とSQLパラメータは`SqlLogUtil`を使わず直接`Logger`で出力。ロガー名に`SQL`を指定することでSQLログが出力される。

log.propertiesの設定例（完全）:
```properties
writerNames=appFile

# appFile
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

ログの出力例:
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

`SqlLogUtil`はapp-log.propertiesを読み込み`SqlLogFormatter`に委譲。設定パスの変更方法は :ref:`AppLog_Config` を参照。

app-log.propertiesの設定例:
```properties
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

| プロパティ名 | 説明 |
|---|---|
| sqlLogFormatter.className | SqlLogFormatterのクラス名（差し替え時に指定） |
| sqlLogFormatter.startRetrieveFormat | SqlPStatement#retrieveの検索開始時フォーマット |
| sqlLogFormatter.endRetrieveFormat | SqlPStatement#retrieveの検索終了時フォーマット |
| sqlLogFormatter.startExecuteFormat | SqlPStatement#executeの実行開始時フォーマット |
| sqlLogFormatter.endExecuteFormat | SqlPStatement#executeの実行終了時フォーマット |
| sqlLogFormatter.startExecuteQueryFormat | SqlPStatement#executeQueryの検索開始時フォーマット |
| sqlLogFormatter.endExecuteQueryFormat | SqlPStatement#executeQueryの検索終了時フォーマット |
| sqlLogFormatter.startExecuteUpdateFormat | SqlPStatement#executeUpdateの更新開始時フォーマット |
| sqlLogFormatter.endExecuteUpdateFormat | SqlPStatement#executeUpdateの更新終了時フォーマット |
| sqlLogFormatter.startExecuteBatchFormat | SqlPStatement#executeBatchの更新開始時フォーマット |
| sqlLogFormatter.endExecuteBatchFormat | SqlPStatement#executeBatchの更新終了時フォーマット |

## SqlPStatement#executeQueryメソッドの検索終了時

プレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | `$methodName$` |
| 実行時間 | `$executeTime$` |

デフォルトフォーマット:

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlLogUtil, SqlLogFormatter, nablarch.core.db.statement.SqlLogUtil, nablarch.core.db.statement.SqlLogFormatter, BasicSqlPStatement, availableLoggersNamesOrder, sqlLogFormatter.className, sqlLogFormatter.startRetrieveFormat, sqlLogFormatter.endRetrieveFormat, sqlLogFormatter.startExecuteFormat, sqlLogFormatter.endExecuteFormat, sqlLogFormatter.startExecuteQueryFormat, sqlLogFormatter.endExecuteQueryFormat, sqlLogFormatter.startExecuteUpdateFormat, sqlLogFormatter.endExecuteUpdateFormat, sqlLogFormatter.startExecuteBatchFormat, sqlLogFormatter.endExecuteBatchFormat, SQLログ設定, ログフォーマット, ログの出力例, app-log.properties, AppLog_Config, SqlPStatement, executeQuery, 検索終了時, $methodName$, $executeTime$, SQLログ 実行時間, 検索終了ログフォーマット

</details>

## SqlPStatement#retrieveメソッドの検索開始時

**SqlPStatement#retrieveメソッドの検索開始時の出力項目**

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

プレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | `$methodName$` |
| SQL文 | `$sql$` |
| 付加情報 | `$additionalInfo$` |

デフォルトフォーマット:

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement#retrieve, 検索開始時, 出力項目, 取得開始位置, 取得最大件数, タイムアウト時間, フェッチする行数, 付加情報, SqlPStatement, executeUpdate, 更新開始時, $methodName$, $sql$, $additionalInfo$, SQLログ 更新

</details>

## SqlPStatement#retrieveメソッドの検索終了時

**SqlPStatement#retrieveメソッドの検索終了時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| データ取得時間 | 検索後のデータ取得に要した時間 |
| 検索件数 | 検索結果の件数 |

## SqlPStatement#executeUpdateメソッドの更新終了時

プレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | `$methodName$` |
| 実行時間 | `$executeTime$` |
| 更新件数 | `$updateCount$` |

デフォルトフォーマット:

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$] update_count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement#retrieve, 検索終了時, 出力項目, データ取得時間, 検索件数, 実行時間, SqlPStatement, executeUpdate, 更新終了時, $methodName$, $executeTime$, $updateCount$, SQLログ 更新件数

</details>

## SqlPStatement#executeメソッドの実行開始時

**SqlPStatement#executeメソッドの実行開始時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

## SqlPStatement#executeBatchメソッドの更新開始時

プレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | `$methodName$` |
| SQL文 | `$sql$` |
| 付加情報 | `$additionalInfo$` |

デフォルトフォーマット:

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement#execute, 実行開始時, 出力項目, 付加情報, SqlPStatement, executeBatch, 更新開始時, $methodName$, $sql$, $additionalInfo$, SQLログ バッチ

</details>

## SqlPStatement#executeメソッドの実行終了時

**SqlPStatement#executeメソッドの実行終了時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |

## SqlPStatement#executeBatchメソッドの更新終了時

プレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | `$methodName$` |
| 実行時間 | `$executeTime$` |
| バッチ件数 | `$batchCount$` |

デフォルトフォーマット:

```bash
$methodName$
    $\n\texecute_time(ms) = [$executeTime$] batch_count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement#execute, 実行終了時, 出力項目, 実行時間, SqlPStatement, executeBatch, 更新終了時, $methodName$, $executeTime$, $batchCount$, SQLログ バッチ件数

</details>

## SqlPStatement#executeQueryメソッドの検索開始時

**SqlPStatement#executeQueryメソッドの検索開始時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

## SQLログの出力例

log.propertiesの設定例:

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

app-log.propertiesの設定例:

```bash
# SqlLogFormatterの設定(個別項目のフォーマット)
sqlLogFormatter.startRetrieveFormat=$methodName$\n\tSQL:$sql$\n\tstart:$startPosition$ size:$size$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endRetrieveFormat=$methodName$\n\texe:$executeTime$ms ret:$retrieveTime$ms count:$count$
```

出力例:

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

SqlPStatement#executeQuery, 検索開始時, 出力項目, 付加情報, SQLログ出力例, log.properties, app-log.properties, sqlLogFormatter, startRetrieveFormat, endRetrieveFormat, FileLogWriter, BasicLogFormatter, BasicSqlPStatement, JdbcTransaction

</details>

## SqlPStatement#executeQueryメソッドの検索終了時

**SqlPStatement#executeQueryメソッドの検索終了時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 検索の実行時間 |

<details>
<summary>keywords</summary>

SqlPStatement#executeQuery, 検索終了時, 出力項目, 実行時間

</details>

## SqlPStatement#executeUpdateメソッドの更新開始時

**SqlPStatement#executeUpdateメソッドの更新開始時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

<details>
<summary>keywords</summary>

SqlPStatement#executeUpdate, 更新開始時, 出力項目, 付加情報

</details>

## SqlPStatement#executeUpdateメソッドの更新終了時

**SqlPStatement#executeUpdateメソッドの更新終了時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| 更新件数 | 更新件数 |

<details>
<summary>keywords</summary>

SqlPStatement#executeUpdate, 更新終了時, 出力項目, 更新件数, 実行時間

</details>

## SqlPStatement#executeBatchメソッドの更新開始時

**SqlPStatement#executeBatchメソッドの更新開始時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

<details>
<summary>keywords</summary>

SqlPStatement#executeBatch, 更新開始時, 出力項目, 付加情報

</details>

## SqlPStatement#executeBatchメソッドの更新終了時

**SqlPStatement#executeBatchメソッドの更新終了時の出力項目**

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| バッチ件数 | バッチ件数 |

<details>
<summary>keywords</summary>

SqlPStatement#executeBatch, 更新終了時, 出力項目, バッチ件数, 実行時間

</details>

## SqlPStatement#retrieveメソッドの検索開始時

**SqlPStatement#retrieveメソッドの検索開始時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 取得開始位置 | $startPosition$ |
| 取得最大件数 | $size$ |
| タイムアウト時間 | $queryTimeout$ |
| フェッチする行数 | $fetchSize$ |
| 付加情報 | $additionalInfo$ |

デフォルトフォーマット:
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

SqlPStatement#retrieve, 検索開始時, プレースホルダ, $methodName$, $sql$, $startPosition$, $size$, $queryTimeout$, $fetchSize$, $additionalInfo$, フォーマット

</details>

## SqlPStatement#retrieveメソッドの検索終了時

**SqlPStatement#retrieveメソッドの検索終了時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| データ取得時間 | $retrieveTime$ |
| 検索件数 | $count$ |

デフォルトフォーマット:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] retrieve_time(ms) = [$retrieveTime$] count = [$count$]
```

<details>
<summary>keywords</summary>

SqlPStatement#retrieve, 検索終了時, プレースホルダ, $executeTime$, $retrieveTime$, $count$, フォーマット

</details>

## SqlPStatement#executeメソッドの実行開始時

**SqlPStatement#executeメソッドの実行開始時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

デフォルトフォーマット:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement#execute, 実行開始時, プレースホルダ, $methodName$, $sql$, $additionalInfo$, フォーマット

</details>

## SqlPStatement#executeメソッドの実行終了時

**SqlPStatement#executeメソッドの実行終了時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |

デフォルトフォーマット:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlPStatement#execute, 実行終了時, プレースホルダ, $methodName$, $executeTime$, フォーマット

</details>

## SqlPStatement#executeQueryメソッドの検索開始時

**SqlPStatement#executeQueryメソッドの検索開始時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

デフォルトフォーマット:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement#executeQuery, 検索開始時, プレースホルダ, $methodName$, $sql$, $additionalInfo$, フォーマット

</details>

## SqlPStatement#executeQueryメソッドの検索終了時

**SqlPStatement#executeQueryメソッドの検索終了時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |

デフォルトフォーマット:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlPStatement#executeQuery, 検索終了時, プレースホルダ, $methodName$, $executeTime$, フォーマット

</details>

## SqlPStatement#executeUpdateメソッドの更新開始時

**SqlPStatement#executeUpdateメソッドの更新開始時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

デフォルトフォーマット:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement#executeUpdate, 更新開始時, プレースホルダ, $methodName$, $sql$, $additionalInfo$, フォーマット

</details>

## SqlPStatement#executeUpdateメソッドの更新終了時

**SqlPStatement#executeUpdateメソッドの更新終了時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| 更新件数 | $updateCount$ |

デフォルトフォーマット:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement#executeUpdate, 更新終了時, プレースホルダ, $methodName$, $executeTime$, $updateCount$, フォーマット

</details>

## SqlPStatement#executeBatchメソッドの更新開始時

**SqlPStatement#executeBatchメソッドの更新開始時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

デフォルトフォーマット:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement#executeBatch, 更新開始時, プレースホルダ, $methodName$, $sql$, $additionalInfo$, フォーマット

</details>

## SqlPStatement#executeBatchメソッドの更新終了時

**SqlPStatement#executeBatchメソッドの更新終了時のフォーマット（プレースホルダ）**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| 更新件数 | $updateCount$ |

デフォルトフォーマット:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement#executeBatch, 更新終了時, プレースホルダ, $methodName$, $executeTime$, $updateCount$, フォーマット

</details>
