# パフォーマンスログの出力

## パフォーマンスログの出力方針

パフォーマンスログはヒープサイズの取得等でパフォーマンスに影響を与える可能性があるため、DEBUGレベルで出力する。

| ログレベル | ロガー名 |
|---|---|
| DEBUG | PERFORMANCE |

**log.propertiesの設定例**:
```properties
writerNames=appLog

writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.appLog.encoding=UTF-8
writer.appLog.maxFileSize=10000
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=PER,ROO

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

loggers.PER.nameRegex=PERFORMANCE
loggers.PER.level=DEBUG
loggers.PER.writerNames=appLog
```

**app-log.propertiesの設定例**:
```properties
performanceLogFormatter.format=\n\tpoint = [$point$] result = [$result$]\
                               \n\tstart_time = [$startTime$] end_time = [$endTime$]\
                               \n\texecution_time = [$executionTime$]\
                               \n\tmax_memory = [$maxMemory$]\
                               \n\tstart_free_memory = [$startFreeMemory$] start_used_memory = [$startUsedMemory$]\
                               \n\tend_free_memory = [$endFreeMemory$] end_used_memory = [$endUsedMemory$]
```

## パフォーマンスログを出力する

`PerformanceLogUtil` を使用して出力する。処理開始時に `PerformanceLogUtil#start`、終了時に `PerformanceLogUtil#end` を呼び出す。`end` が呼ばれた時点で `start` 取得時の日時とメモリ使用量を合わせて出力する。

`end` メソッドには、ポイント名・処理結果を表す文字列に加えて、ログ出力のオプション情報（`Object...` 可変長引数）を第3引数として指定できる。オプション情報を省略した呼び出しも可能。

```java
// startメソッドでは、測定対象を識別するポイントを指定する。
// 誤設定による無駄な出力を防ぐため、
// このポイント名が設定ファイルに定義されていないとログは出力されない。
String point = "UserSearchAction#doUSERS00101";
PerformanceLogUtil.start(point);

// 検索実行
UserSearchService searchService = new UserSearchService();
SqlResultSet searchResult = searchService.selectByCondition(condition);

// endメソッドでは、ポイント、処理結果を表す文字列、ログ出力のオプション情報を指定できる。
// 以下ではログ出力のオプション情報は指定していない。
PerformanceLogUtil.end(point, String.valueOf(searchResult.size()));
```

> **重要**: `PerformanceLogUtil` は測定対象を :ref:`実行時ID <log-execution_id>` ＋ポイント名で一意に識別する。再帰呼び出しの中で使用すると計測できないため注意すること。

## パフォーマンスログの設定

設定は :ref:`log-app_log_setting` で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| performanceLogFormatter.className | | | `PerformanceLogFormatter` を実装したクラス。差し替える場合に指定する。 |
| performanceLogFormatter.format | | (下記デフォルト参照) | パフォーマンスログのフォーマット。プレースホルダで各項目を指定する。 |
| performanceLogFormatter.datePattern | | yyyy-MM-dd HH:mm:ss.SSS | 開始・終了日時のパターン（SimpleDateFormat構文）。 |
| performanceLogFormatter.targetPoints | | | 出力対象ポイント名（カンマ区切り）。この設定に基づいてログ出力が制御され、設定されていないポイント名ではログが出力されない。 |

`performanceLogFormatter.format` のプレースホルダ:

| プレースホルダ | 内容 |
|---|---|
| $point$ | 測定対象を識別するID |
| $result$ | 処理結果を表す文字列 |
| $startTime$ | 処理の開始日時 |
| $endTime$ | 処理の終了日時 |
| $executionTime$ | 処理の実行時間（終了日時 - 開始日時） |
| $maxMemory$ | 処理開始時点のヒープサイズ |
| $startFreeMemory$ | 処理開始時点の空きヒープサイズ |
| $startUsedMemory$ | 処理開始時点の使用ヒープサイズ |
| $endFreeMemory$ | 処理終了時点の空きヒープサイズ |
| $endUsedMemory$ | 処理終了時点の使用ヒープサイズ |

デフォルトフォーマット:
```
\n\tpoint = [$point$] result = [$result$]
\n\tstart_time = [$startTime$] end_time = [$endTime$]
\n\texecution_time = [$executionTime$]
\n\tmax_memory = [$maxMemory$]
\n\tstart_free_memory = [$startFreeMemory$] start_used_memory = [$startUsedMemory$]
\n\tend_free_memory = [$endFreeMemory$] end_used_memory = [$endUsedMemory$]
```

設定例:
```properties
performanceLogFormatter.className=nablarch.core.log.app.PerformanceLogFormatter
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd HH:mm:ss.SSS
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

## JSON形式の構造化ログとして出力する

:ref:`log-json_log_setting` 設定でJSON形式出力を有効にした場合、`PerformanceLogFormatter` ではパフォーマンスログの各項目はmessageの値に文字列として出力される。各項目をJSONの値として出力するには `PerformanceJsonLogFormatter` を使用する。設定は :ref:`log-app_log_setting` のプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| performanceLogFormatter.className | ○ | | `PerformanceJsonLogFormatter` を指定する。 |
| performanceLogFormatter.targets | | 全項目 | 出力項目（カンマ区切り）: point, result, startTime, endTime, executionTime, maxMemory, startFreeMemory, startUsedMemory, endFreeMemory, endUsedMemory |
| performanceLogFormatter.datePattern | | yyyy-MM-dd HH:mm:ss.SSS | 開始・終了日時のパターン（SimpleDateFormat構文）。 |
| performanceLogFormatter.targetPoints | | | 出力対象ポイント名（カンマ区切り）。 |
| performanceLogFormatter.structuredMessagePrefix | | $JSON$ | `JsonLogFormatter` がメッセージをJSONデータとして処理するためのマーカー文字列。変更する場合は :ref:`log-basic_setting` のLogWriterの `structuredMessagePrefix` にも同じ値を設定すること。 |

設定例:
```properties
performanceLogFormatter.className=nablarch.core.log.app.PerformanceJsonLogFormatter
performanceLogFormatter.structuredMessagePrefix=$JSON$
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
performanceLogFormatter.targets=point,result,executionTime
```
