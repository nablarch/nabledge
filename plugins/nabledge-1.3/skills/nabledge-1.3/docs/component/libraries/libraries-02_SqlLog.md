# SQLログの出力

## 

SQLログはパフォーマンスチューニング用。SQL文の実行時間とSQL文を出力する。開発時の使用を想定しているためDEBUGレベル以下で出力する。

**ロガー名**: `SQL`

| ログレベル | 出力内容 |
|---|---|
| DEBUG | SQL文、実行時間、件数（検索件数・更新件数など）、トランザクションの処理結果（コミット/ロールバック） |
| TRACE | SQLパラメータ（バインド変数の値） |

**log.properties設定例**:
```bash
loggers.SQL.nameRegex=SQL
loggers.SQL.level=TRACE
loggers.SQL.writerNames=<出力先のログライタ>
```

共通項目については :ref:`Log_BasicLogFormatter` を参照。共通項目と個別項目を組み合わせたフォーマットは :ref:`AppLog_Format` を参照。

**プレースホルダ一覧**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトのフォーマット**:

```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SQLログ, SqlLog, ログレベル設定, パフォーマンスチューニング, DEBUG, TRACE, SQL出力方針, loggers.SQL, SQLログ出力方針, SqlPStatement, executeQuery, 検索開始時, SQLログフォーマット, プレースホルダ, $methodName$, $sql$, $additionalInfo$

</details>

## SQLログの出力

**クラス**: `nablarch.core.db.statement.SqlLogUtil`, `nablarch.core.db.statement.SqlLogFormatter`

- `nablarch.core.db.statement.SqlLogUtil`: SQLログのフォーマットを助けるクラス
- `nablarch.core.db.statement.SqlLogFormatter`: SQLログの個別項目をフォーマットするクラス

BasicSqlPStatementはSQL文・実行時間・件数のフォーマットにSqlLogUtilを使用する。トランザクション処理結果とSQLパラメータの出力はSqlLogUtilを使用せず直接Loggerを使用する。

log.propertiesでロガー名に`SQL`を指定することでSQLログが出力される。

**ログ出力例**:
```bash
2011-02-08 23:07:25.182 -DEBUG- ... nablarch.core.db.statement.BasicSqlPStatement#retrieve
    SQL = [SELECT BIZ_DATE FROM BUSINESS_DATE WHERE SEGMENT = ?]
    start_position = [1] size = [0]
    query_timeout = [0] fetch_size = [500]
    additional_info:
2011-02-08 23:07:25.182 -TRACE- ... nablarch.core.db.statement.BasicSqlPStatement#Parameters
    01 = [00]
2011-02-08 23:07:25.182 -DEBUG- ... nablarch.core.db.statement.BasicSqlPStatement#retrieve
    execute_time(ms) = [0] retrieve_time(ms) = [0] count = [1]
```

**app-log.propertiesの設定例**:
```bash
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
| sqlLogFormatter.className | SqlLogFormatterのクラス名。差し替える場合に指定 |
| sqlLogFormatter.startRetrieveFormat | SqlPStatement#retrieveメソッドの検索開始時フォーマット |
| sqlLogFormatter.endRetrieveFormat | SqlPStatement#retrieveメソッドの検索終了時フォーマット |
| sqlLogFormatter.startExecuteFormat | SqlPStatement#executeメソッドの実行開始時フォーマット |
| sqlLogFormatter.endExecuteFormat | SqlPStatement#executeメソッドの実行終了時フォーマット |
| sqlLogFormatter.startExecuteQueryFormat | SqlPStatement#executeQueryメソッドの検索開始時フォーマット |
| sqlLogFormatter.endExecuteQueryFormat | SqlPStatement#executeQueryメソッドの検索終了時フォーマット |
| sqlLogFormatter.startExecuteUpdateFormat | SqlPStatement#executeUpdateメソッドの更新開始時フォーマット |
| sqlLogFormatter.endExecuteUpdateFormat | SqlPStatement#executeUpdateメソッドの更新終了時フォーマット |
| sqlLogFormatter.startExecuteBatchFormat | SqlPStatement#executeBatchメソッドの更新開始時フォーマット |
| sqlLogFormatter.endExecuteBatchFormat | SqlPStatement#executeBatchメソッドの更新終了時フォーマット |

プロパティファイルのパス指定や実行時の変更方法は :ref:`AppLog_Config` を参照。

**プレースホルダ一覧**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |

**デフォルトのフォーマット**:

```
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlLogUtil, SqlLogFormatter, BasicSqlPStatement, sqlLogFormatter.className, sqlLogFormatter.startRetrieveFormat, sqlLogFormatter.endRetrieveFormat, sqlLogFormatter.startExecuteFormat, sqlLogFormatter.endExecuteFormat, sqlLogFormatter.startExecuteQueryFormat, sqlLogFormatter.endExecuteQueryFormat, sqlLogFormatter.startExecuteUpdateFormat, sqlLogFormatter.endExecuteUpdateFormat, sqlLogFormatter.startExecuteBatchFormat, sqlLogFormatter.endExecuteBatchFormat, SQLログ設定, app-log.properties, AppLog_Config, SqlPStatement, executeQuery, 検索終了時, SQLログフォーマット, プレースホルダ, $executeTime$, execute_time

</details>

## SqlPStatement#retrieveメソッドの検索開始時

SqlPStatement#retrieveメソッドの検索開始時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 取得開始位置 | 検索結果のデータ取得を開始する行数 |
| 取得最大件数 | 検索結果に含める最大行数 |
| タイムアウト時間 | 検索のタイムアウト時間 |
| フェッチする行数 | データ取得時のフェッチ件数 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

**プレースホルダ一覧**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトのフォーマット**:

```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, retrieve, 検索開始, 取得開始位置, 取得最大件数, タイムアウト時間, フェッチする行数, 付加情報, 出力項目, executeUpdate, 更新開始時, SQLログフォーマット, プレースホルダ, $methodName$, $sql$, $additionalInfo$

</details>

## SqlPStatement#retrieveメソッドの検索終了時

SqlPStatement#retrieveメソッドの検索終了時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| データ取得時間 | 検索後のデータ取得に要した時間 |
| 検索件数 | 検索結果の件数 |

**プレースホルダ一覧**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| 更新件数 | $updateCount$ |

**デフォルトのフォーマット**:

```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] update_count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement, retrieve, 検索終了, 実行時間, データ取得時間, 検索件数, 出力項目, executeUpdate, 更新終了時, SQLログフォーマット, プレースホルダ, $executeTime$, $updateCount$, update_count

</details>

## SqlPStatement#executeメソッドの実行開始時

SqlPStatement#executeメソッドの実行開始時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

**プレースホルダ一覧**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトのフォーマット**:

```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, execute, 実行開始, SQL文, 付加情報, 出力項目, executeBatch, 更新開始時, SQLログフォーマット, プレースホルダ, $methodName$, $sql$, $additionalInfo$

</details>

## SqlPStatement#executeメソッドの実行終了時

SqlPStatement#executeメソッドの実行終了時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |

**プレースホルダ一覧**

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| バッチ件数 | $batchCount$ |

**デフォルトのフォーマット**:

```
$methodName$
    $\n\texecute_time(ms) = [$executeTime$] batch_count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement, execute, 実行終了, 実行時間, 出力項目, executeBatch, 更新終了時, SQLログフォーマット, プレースホルダ, $executeTime$, $batchCount$, batch_count

</details>

## SqlPStatement#executeQueryメソッドの検索開始時

SqlPStatement#executeQueryメソッドの検索開始時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

**log.propertiesの設定例**:

```
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

**app-log.propertiesの設定例** (sqlLogFormatterの個別項目フォーマット):

```
# SqlLogFormatterの設定(個別項目のフォーマット)
sqlLogFormatter.startRetrieveFormat=$methodName$\n\tSQL:$sql$\n\tstart:$startPosition$ size:$size$\n\tadditional_info:\n\t$additionalInfo$
sqlLogFormatter.endRetrieveFormat=$methodName$\n\texe:$executeTime$ms ret:$retrieveTime$ms count:$count$
```

`startRetrieveFormat` で使用できる追加プレースホルダ: `$startPosition$`（検索開始位置）、`$size$`（取得件数）

`endRetrieveFormat` で使用できる追加プレースホルダ: `$retrieveTime$`（データ取得時間）、`$count$`（取得件数）

**出力例**:

```
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

SqlPStatement, executeQuery, 検索開始, SQL文, 付加情報, 出力項目, SQLログ出力例, log.properties, app-log.properties, sqlLogFormatter, startRetrieveFormat, endRetrieveFormat, $startPosition$, $size$, $retrieveTime$, $count$, FileLogWriter, BasicLogFormatter, nameRegex, writerNames, BasicSqlPStatement, JdbcTransaction

</details>

## SqlPStatement#executeQueryメソッドの検索終了時

SqlPStatement#executeQueryメソッドの検索終了時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 検索の実行時間 |

<details>
<summary>keywords</summary>

SqlPStatement, executeQuery, 検索終了, 実行時間, 出力項目

</details>

## SqlPStatement#executeUpdateメソッドの更新開始時

SqlPStatement#executeUpdateメソッドの更新開始時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

<details>
<summary>keywords</summary>

SqlPStatement, executeUpdate, 更新開始, SQL文, 付加情報, 出力項目

</details>

## SqlPStatement#executeUpdateメソッドの更新終了時

SqlPStatement#executeUpdateメソッドの更新終了時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| 更新件数 | 更新件数 |

<details>
<summary>keywords</summary>

SqlPStatement, executeUpdate, 更新終了, 実行時間, 更新件数, 出力項目

</details>

## SqlPStatement#executeBatchメソッドの更新開始時

SqlPStatement#executeBatchメソッドの更新開始時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| SQL文 | SQL文 |
| 付加情報 | BasicSqlPStatementの設定で指定された付加情報 |

<details>
<summary>keywords</summary>

SqlPStatement, executeBatch, 更新開始, SQL文, 付加情報, 出力項目

</details>

## SqlPStatement#executeBatchメソッドの更新終了時

SqlPStatement#executeBatchメソッドの更新終了時の出力項目:

| 項目名 | 説明 |
|---|---|
| メソッド名 | クラス名#メソッド名形式 |
| 実行時間 | 実行時間 |
| バッチ件数 | バッチ件数 |

<details>
<summary>keywords</summary>

SqlPStatement, executeBatch, 更新終了, 実行時間, バッチ件数, 出力項目

</details>

## SqlPStatement#retrieveメソッドの検索開始時

SqlPStatement#retrieveメソッドの検索開始時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 取得開始位置 | $startPosition$ |
| 取得最大件数 | $size$ |
| タイムアウト時間 | $queryTimeout$ |
| フェッチする行数 | $fetchSize$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:
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

SqlPStatement, retrieve, 検索開始, $methodName$, $sql$, $startPosition$, $size$, $queryTimeout$, $fetchSize$, $additionalInfo$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#retrieveメソッドの検索終了時

SqlPStatement#retrieveメソッドの検索終了時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| データ取得時間 | $retrieveTime$ |
| 検索件数 | $count$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] retrieve_time(ms) = [$retrieveTime$] count = [$count$]
```

<details>
<summary>keywords</summary>

SqlPStatement, retrieve, 検索終了, $methodName$, $executeTime$, $retrieveTime$, $count$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeメソッドの実行開始時

SqlPStatement#executeメソッドの実行開始時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, execute, 実行開始, $methodName$, $sql$, $additionalInfo$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeメソッドの実行終了時

SqlPStatement#executeメソッドの実行終了時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlPStatement, execute, 実行終了, $methodName$, $executeTime$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeQueryメソッドの検索開始時

SqlPStatement#executeQueryメソッドの検索開始時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, executeQuery, 検索開始, $methodName$, $sql$, $additionalInfo$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeQueryメソッドの検索終了時

SqlPStatement#executeQueryメソッドの検索終了時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

<details>
<summary>keywords</summary>

SqlPStatement, executeQuery, 検索終了, $methodName$, $executeTime$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeUpdateメソッドの更新開始時

SqlPStatement#executeUpdateメソッドの更新開始時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, executeUpdate, 更新開始, $methodName$, $sql$, $additionalInfo$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeUpdateメソッドの更新終了時

SqlPStatement#executeUpdateメソッドの更新終了時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| 更新件数 | $updateCount$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement, executeUpdate, 更新終了, $methodName$, $executeTime$, $updateCount$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeBatchメソッドの更新開始時

SqlPStatement#executeBatchメソッドの更新開始時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| SQL文 | $sql$ |
| 付加情報 | $additionalInfo$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

<details>
<summary>keywords</summary>

SqlPStatement, executeBatch, 更新開始, $methodName$, $sql$, $additionalInfo$, プレースホルダ, デフォルトフォーマット

</details>

## SqlPStatement#executeBatchメソッドの更新終了時

SqlPStatement#executeBatchメソッドの更新終了時のプレースホルダ一覧とデフォルトフォーマット:

| 項目名 | プレースホルダ |
|---|---|
| メソッド名 | $methodName$ |
| 実行時間 | $executeTime$ |
| バッチ件数 | $updateCount$ |

**デフォルトフォーマット**:
```
$methodName$
    \n\texecute_time(ms) = [$executeTime$] count = [$updateCount$]
```

<details>
<summary>keywords</summary>

SqlPStatement, executeBatch, 更新終了, $methodName$, $executeTime$, $updateCount$, プレースホルダ, デフォルトフォーマット

</details>
