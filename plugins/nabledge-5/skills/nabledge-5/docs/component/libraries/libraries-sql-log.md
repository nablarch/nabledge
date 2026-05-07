# SQLログの出力

**目次**

* SQLログの出力方針
* 使用方法

  * SQLログの設定
  * JSON形式の構造化ログとして出力する

SQLログは、パフォーマンスチューニングに使用するために、SQL文の実行時間やSQL文を出力する。
アプリケーションでは、ログ出力を設定することにより出力する。

## SQLログの出力方針

SQLログは、ログのサイズが大きくなりディスクフルになったり、パフォーマンスに影響を与える可能性がある。
そのため、SQLログは開発時の使用を想定し、DEBUGレベル以下で出力する。

SQLログの出力方針

| ログレベル | ロガー名 | 出力内容 |
|---|---|---|
| DEBUG | SQL | SQL文、実行時間、件数(検索件数や更新件数など)、トランザクションの処理結果(コミット又はロールバック) |
| TRACE | SQL | SQLパラメータ(バインド変数の値) |

上記出力方針に対するログ出力の設定例を下記に示す。

log.propertiesの設定例

```properties
writerNames=appLog

# アプリケーションログの出力先
writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.appLog.encoding=UTF-8
writer.appLog.maxFileSize=10000
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=SQL,ROO

# アプリケーションログの設定
loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

# SQLログの設定
loggers.SQL.nameRegex=SQL
loggers.SQL.level=TRACE
loggers.SQL.writerNames=appLog
```

app-log.propertiesの設定例

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

## 使用方法

### SQLログの設定

SQLログの設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#log-app-log-setting) で説明したプロパティファイルに行う。

記述ルール

sqlLogFormatter.className

SqlLogFormatter を実装したクラス。
差し替える場合に指定する。

sqlLogFormatter.startRetrieveFormat

SqlPStatement#retrieve
の開始時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$sql$

$startPosition$

$size$

$queryTimeout$

$fetchSize$

$additionalInfo$

デフォルトのフォーマット

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tstart_position = [$startPosition$] size = [$size$]
    \n\tquery_timeout = [$queryTimeout$] fetch_size = [$fetchSize$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

sqlLogFormatter.endRetrieveFormat

SqlPStatement#retrieve
の終了時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$executeTime$

$retrieveTime$

$count$

デフォルトのフォーマット

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$] retrieve_time(ms) = [$retrieveTime$] count = [$count$]
```

sqlLogFormatter.startExecuteFormat

SqlPStatement#execute
の開始時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$sql$

$additionalInfo$

デフォルトのフォーマット

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

sqlLogFormatter.endExecuteFormat

SqlPStatement#execute
の終了時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$executeTime$

デフォルトのフォーマット

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

sqlLogFormatter.startExecuteQueryFormat

SqlPStatement#executeQuery
の開始時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$sql$

$additionalInfo$

デフォルトのフォーマット

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

sqlLogFormatter.endExecuteQueryFormat

SqlPStatement#executeQuery
の終了時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$executeTime$

デフォルトのフォーマット

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$]
```

sqlLogFormatter.startExecuteUpdateFormat

SqlPStatement#executeUpdate
の開始時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$sql$

$additionalInfo$

デフォルトのフォーマット

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

sqlLogFormatter.endExecuteUpdateFormat

SqlPStatement#executeUpdate
の終了時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$executeTime$

$updateCount$

デフォルトのフォーマット

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$] update_count = [$updateCount$]
```

sqlLogFormatter.startExecuteBatchFormat

SqlStatement#executeBatch
の開始時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$sql$

$additionalInfo$

デフォルトのフォーマット

```bash
$methodName$
    \n\tSQL = [$sql$]
    \n\tadditional_info:
    \n\t$additionalInfo$
```

sqlLogFormatter.endExecuteBatchFormat

SqlStatement#executeBatch
の終了時に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$methodName$

$executeTime$

$batchCount$

デフォルトのフォーマット

```bash
$methodName$
    \n\texecute_time(ms) = [$executeTime$] batch_count = [$updateCount$]
```

記述例

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

### JSON形式の構造化ログとして出力する

[JSON形式の構造化ログとして出力する](../../component/libraries/libraries-log.md#log-json-log-setting) 設定によりログをJSON形式で出力できるが、
SqlLogFormatter では
SQLログの各項目はmessageの値に文字列として出力される。
SQLログの各項目もJSONの値として出力するには、
SqlJsonLogFormatter を使用する。
設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#log-app-log-setting) で説明したプロパティファイルに行う。

記述ルール

SqlJsonLogFormatter を用いる際に
指定するプロパティは以下の通り。

sqlLogFormatter.className `必須`

JSON形式でログを出力する場合、
SqlJsonLogFormatter を指定する。

sqlLogFormatter.startRetrieveTargets

SqlPStatement#retrieve
の開始時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

sql

startPosition

size

queryTimeout

fetchSize

additionalInfo

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.endRetrieveTargets

SqlPStatement#retrieve
の終了時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

executeTime

retrieveTime

count

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.startExecuteTargets

SqlPStatement#execute
の開始時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

sql

additionalInfo

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.endExecuteTargets

SqlPStatement#execute
の終了時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

executeTime

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.startExecuteQueryTargets

SqlPStatement#executeQuery
の開始時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

sql

additionalInfo

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.endExecuteQueryTargets

SqlPStatement#executeQuery
の終了時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

executeTime

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.startExecuteUpdateTargets

SqlPStatement#executeUpdate
の開始時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

sql

additionalInfo

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.endExecuteUpdateTargets

SqlPStatement#executeUpdate
の終了時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

executeTime

updateCount

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.startExecuteBatchTargets

SqlStatement#executeBatch
の開始時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

sql

additionalInfo

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.endExecuteBatchTargets

SqlStatement#executeBatch
の終了時のログ出力項目。カンマ区切りで指定する。

指定可能な出力項目

methodName

executeTime

batchCount

デフォルトは全ての出力項目が対象となる。

sqlLogFormatter.structuredMessagePrefix

フォーマット後のメッセージ文字列が JSON 形式に整形されていることを識別できるようにするために、メッセージの先頭に付与するマーカー文字列。
メッセージの先頭にあるマーカー文字列が JsonLogFormatter に設定しているマーカー文字列と一致する場合、 JsonLogFormatter はメッセージを JSON データとして処理する。
デフォルトは `"$JSON$"` となる。
変更する場合は、LogWriterの `structuredMessagePrefix` プロパティを使用して JsonLogFormatter にも同じ値を設定すること（LogWriterのプロパティについては [ログ出力の設定](../../component/libraries/libraries-log.md#log-basic-setting) を参照）。

記述例

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
