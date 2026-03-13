# SQLログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/sql_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlLogFormatter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlJsonLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlPStatement.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlStatement.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html)

## SQLログの出力方針

SQLログはパフォーマンスチューニング用途。ディスクフル・パフォーマンス影響の可能性があるため、開発時使用を想定しDEBUGレベル以下で出力する。

| ログレベル | ロガー名 | 出力内容 |
|---|---|---|
| DEBUG | SQL | SQL文、実行時間、件数(検索件数や更新件数など)、トランザクションの処理結果(コミット又はロールバック) |
| TRACE | SQL | SQLパラメータ(バインド変数の値) |

**log.properties設定例**:
```properties
writerNames=appLog

writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.appLog.encoding=UTF-8
writer.appLog.maxFileSize=10000
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=SQL,ROO

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

loggers.SQL.nameRegex=SQL
loggers.SQL.level=TRACE
loggers.SQL.writerNames=appLog
```

**app-log.properties設定例（SqlLogFormatter）**:
```properties
# SqlLogFormatter
#sqlLogFormatter.className=
# SqlPStatement#retrieveのフォーマット
sqlLogFormatter.startRetrieveFormat=$methodName$\
    \n\tSQL = [$sql$]\
    \n\tstart_position = [$startPosition$] size = [$size$]\
    \n\tquery_timeout = [$queryTimeout$] fetch_size = [$fetchSize$]\
    \n\tadditional_info:\
    \n\t$additionalInfo$
sqlLogFormatter.endRetrieveFormat=$methodName$\
    \n\texecute_time(ms) = [$executeTime$] retrieve_time(ms) = [$retrieveTime$] count = [$count$]
# SqlPStatement#executeのフォーマット
sqlLogFormatter.startExecuteFormat=$methodName$\
    \n\tSQL = [$sql$]\
    \n\tadditional_info:\
    \n\t$additionalInfo$
sqlLogFormatter.endExecuteFormat=$methodName$\
    \n\texecute_time(ms) = [$executeTime$]
# SqlPStatement#executeQueryのフォーマット
sqlLogFormatter.startExecuteQueryFormat=$methodName$\
    \n\tSQL = [$sql$]\
    \n\tadditional_info:\
    \n\t$additionalInfo$
sqlLogFormatter.endExecuteQueryFormat=$methodName$\
    \n\texecute_time(ms) = [$executeTime$]
# SqlPStatement#executeUpdateのフォーマット
sqlLogFormatter.startExecuteUpdateFormat=$methodName$\
    \n\tSQL = [$sql$]\
    \n\tadditional_info:\
    \n\t$additionalInfo$
sqlLogFormatter.endExecuteUpdateFormat=$methodName$\
    \n\texecute_time(ms) = [$executeTime$] update_count = [$updateCount$]
# SqlStatement#executeBatchのフォーマット
sqlLogFormatter.startExecuteBatchFormat=$methodName$\
    \n\tSQL = [$sql$]\
    \n\tadditional_info:\
    \n\t$additionalInfo$
sqlLogFormatter.endExecuteBatchFormat=$methodName$\
    \n\texecute_time(ms) = [$executeTime$] batch_count = [$updateCount$]
```

## SQLログの設定

設定は [log-app_log_setting](libraries-log.md) のプロパティファイルに行う。

**クラス**: `nablarch.core.db.statement.SqlLogFormatter`

`sqlLogFormatter.className`: `SqlLogFormatter` を実装したクラス。差し替え時に指定。

各操作の開始・終了時のログフォーマットをプロパティで設定する。フォーマット文字列にはプレースホルダを使用できる。

| プロパティ名 | 対象操作 | タイミング | 指定可能プレースホルダ | デフォルトフォーマット |
|---|---|---|---|---|
| sqlLogFormatter.startRetrieveFormat | `SqlPStatement#retrieve` | 開始 | `$methodName$`, `$sql$`, `$startPosition$`, `$size$`, `$queryTimeout$`, `$fetchSize$`, `$additionalInfo$` | `$methodName$\n\tSQL = [$sql$]\n\tstart_position = [$startPosition$] size = [$size$]\n\tquery_timeout = [$queryTimeout$] fetch_size = [$fetchSize$]\n\tadditional_info:\n\t$additionalInfo$` |
| sqlLogFormatter.endRetrieveFormat | `SqlPStatement#retrieve` | 終了 | `$methodName$`, `$executeTime$`, `$retrieveTime$`, `$count$` | `$methodName$\n\texecute_time(ms) = [$executeTime$] retrieve_time(ms) = [$retrieveTime$] count = [$count$]` |
| sqlLogFormatter.startExecuteFormat | `SqlPStatement#execute` | 開始 | `$methodName$`, `$sql$`, `$additionalInfo$` | `$methodName$\n\tSQL = [$sql$]\n\tadditional_info:\n\t$additionalInfo$` |
| sqlLogFormatter.endExecuteFormat | `SqlPStatement#execute` | 終了 | `$methodName$`, `$executeTime$` | `$methodName$\n\texecute_time(ms) = [$executeTime$]` |
| sqlLogFormatter.startExecuteQueryFormat | `SqlPStatement#executeQuery` | 開始 | `$methodName$`, `$sql$`, `$additionalInfo$` | `$methodName$\n\tSQL = [$sql$]\n\tadditional_info:\n\t$additionalInfo$` |
| sqlLogFormatter.endExecuteQueryFormat | `SqlPStatement#executeQuery` | 終了 | `$methodName$`, `$executeTime$` | `$methodName$\n\texecute_time(ms) = [$executeTime$]` |
| sqlLogFormatter.startExecuteUpdateFormat | `SqlPStatement#executeUpdate` | 開始 | `$methodName$`, `$sql$`, `$additionalInfo$` | `$methodName$\n\tSQL = [$sql$]\n\tadditional_info:\n\t$additionalInfo$` |
| sqlLogFormatter.endExecuteUpdateFormat | `SqlPStatement#executeUpdate` | 終了 | `$methodName$`, `$executeTime$`, `$updateCount$` | `$methodName$\n\texecute_time(ms) = [$executeTime$] update_count = [$updateCount$]` |
| sqlLogFormatter.startExecuteBatchFormat | `SqlStatement#executeBatch` | 開始 | `$methodName$`, `$sql$`, `$additionalInfo$` | `$methodName$\n\tSQL = [$sql$]\n\tadditional_info:\n\t$additionalInfo$` |
| sqlLogFormatter.endExecuteBatchFormat | `SqlStatement#executeBatch` | 終了 | `$methodName$`, `$executeTime$`, `$batchCount$` | `$methodName$\n\texecute_time(ms) = [$executeTime$] batch_count = [$updateCount$]` |

設定例:

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

<details>
<summary>keywords</summary>

SQLログ, SqlLogFormatter, log.properties, app-log.properties, SQLログ出力設定, DEBUGレベル, TRACEレベル, SQLパラメータ, nablarch.core.log.basic.FileLogWriter, nablarch.core.log.basic.BasicLogFormatter, SqlPStatement, SqlStatement, nablarch.core.db.statement.SqlLogFormatter, sqlLogFormatter.className, sqlLogFormatter.startRetrieveFormat, sqlLogFormatter.endRetrieveFormat, sqlLogFormatter.startExecuteFormat, sqlLogFormatter.endExecuteFormat, sqlLogFormatter.startExecuteQueryFormat, sqlLogFormatter.endExecuteQueryFormat, sqlLogFormatter.startExecuteUpdateFormat, sqlLogFormatter.endExecuteUpdateFormat, sqlLogFormatter.startExecuteBatchFormat, sqlLogFormatter.endExecuteBatchFormat, SQLログ設定, ログフォーマット設定, プレースホルダ設定

</details>

## JSON形式の構造化ログとして出力する

## JSON形式の構造化ログとして出力する

[log-json_log_setting](libraries-log.md) によりJSON形式で出力できるが、`SqlLogFormatter` ではSQLログ各項目はmessageの値に文字列として出力される。各項目もJSONの値として出力するには `SqlJsonLogFormatter` を使用する。設定は [log-app_log_setting](libraries-log.md) のプロパティファイルに行う。

**クラス**: `nablarch.core.db.statement.SqlJsonLogFormatter`

| プロパティ名 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| sqlLogFormatter.className | ○ | | `nablarch.core.db.statement.SqlJsonLogFormatter` を指定 |
| sqlLogFormatter.startRetrieveTargets | | 全項目 | `SqlPStatement#retrieve` 開始時の出力項目（カンマ区切り）。指定可能: `methodName`, `sql`, `startPosition`, `size`, `queryTimeout`, `fetchSize`, `additionalInfo` |
| sqlLogFormatter.endRetrieveTargets | | 全項目 | `SqlPStatement#retrieve` 終了時の出力項目。指定可能: `methodName`, `executeTime`, `retrieveTime`, `count` |
| sqlLogFormatter.startExecuteTargets | | 全項目 | `SqlPStatement#execute` 開始時の出力項目。指定可能: `methodName`, `sql`, `additionalInfo` |
| sqlLogFormatter.endExecuteTargets | | 全項目 | `SqlPStatement#execute` 終了時の出力項目。指定可能: `methodName`, `executeTime` |
| sqlLogFormatter.startExecuteQueryTargets | | 全項目 | `SqlPStatement#executeQuery` 開始時の出力項目。指定可能: `methodName`, `sql`, `additionalInfo` |
| sqlLogFormatter.endExecuteQueryTargets | | 全項目 | `SqlPStatement#executeQuery` 終了時の出力項目。指定可能: `methodName`, `executeTime` |
| sqlLogFormatter.startExecuteUpdateTargets | | 全項目 | `SqlPStatement#executeUpdate` 開始時の出力項目。指定可能: `methodName`, `sql`, `additionalInfo` |
| sqlLogFormatter.endExecuteUpdateTargets | | 全項目 | `SqlPStatement#executeUpdate` 終了時の出力項目。指定可能: `methodName`, `executeTime`, `updateCount` |
| sqlLogFormatter.startExecuteBatchTargets | | 全項目 | `SqlStatement#executeBatch` 開始時の出力項目。指定可能: `methodName`, `sql`, `additionalInfo` |
| sqlLogFormatter.endExecuteBatchTargets | | 全項目 | `SqlStatement#executeBatch` 終了時の出力項目。指定可能: `methodName`, `executeTime`, `batchCount` |
| sqlLogFormatter.structuredMessagePrefix | | `$JSON$` | JSONメッセージを識別するマーカー文字列。`JsonLogFormatter` に設定した `structuredMessagePrefix` と同じ値を設定すること（[log-basic_setting](libraries-log.md) 参照）。 |

設定例:

```properties
sqlLogFormatter.className=nablarch.core.db.statement.SqlJsonLogFormatter
sqlLogFormatter.structuredMessagePrefix=$JSON$
sqlLogFormatter.startRetrieveTargets=methodName,sql,startPosition,size,additionalInfo
sqlLogFormatter.endRetrieveTargets=methodName,executeTime,retrieveTime,count
sqlLogFormatter.startExecuteTargets=methodName,sql,additionalInfo
sqlLogFormatter.endExecuteTargets=methodName,executeTime
sqlLogFormatter.startExecuteQueryTargets=methodName,sql,additionalInfo
sqlLogFormatter.endExecuteQueryTargets=methodName,executeTime
sqlLogFormatter.startExecuteUpdateTargets=methodName,sql,additionalInfo
sqlLogFormatter.endExecuteUpdateTargets=methodName,executeTime,updateCount
sqlLogFormatter.startExecuteBatchTargets=methodName,sql,additionalInfo
sqlLogFormatter.endExecuteBatchTargets=methodName,executeTime,batchCount
```

<details>
<summary>keywords</summary>

SqlJsonLogFormatter, nablarch.core.db.statement.SqlJsonLogFormatter, JsonLogFormatter, nablarch.core.log.basic.JsonLogFormatter, sqlLogFormatter.className, sqlLogFormatter.startRetrieveTargets, sqlLogFormatter.endRetrieveTargets, sqlLogFormatter.startExecuteTargets, sqlLogFormatter.endExecuteTargets, sqlLogFormatter.startExecuteQueryTargets, sqlLogFormatter.endExecuteQueryTargets, sqlLogFormatter.startExecuteUpdateTargets, sqlLogFormatter.endExecuteUpdateTargets, sqlLogFormatter.startExecuteBatchTargets, sqlLogFormatter.endExecuteBatchTargets, sqlLogFormatter.structuredMessagePrefix, JSON構造化ログ

</details>
