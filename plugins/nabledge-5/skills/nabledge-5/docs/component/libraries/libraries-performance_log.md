# パフォーマンスログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/performance_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/PerformanceLogUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/PerformanceLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/PerformanceJsonLogFormatter.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html)

## パフォーマンスログの出力方針

パフォーマンスログはヒープサイズの取得などでパフォーマンスに影響を与える可能性があるため、開発時の使用を想定しているためDEBUGレベルで出力する。

ログレベルはDEBUG、ロガー名はPERFORMANCEで出力する。

| ログレベル | ロガー名 |
|---|---|
| DEBUG | PERFORMANCE |

**log.properties設定例**:
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

**app-log.properties設定例**:
```properties
performanceLogFormatter.format=\n\tpoint = [$point$] result = [$result$]\
                               \n\tstart_time = [$startTime$] end_time = [$endTime$]\
                               \n\texecution_time = [$executionTime$]\
                               \n\tmax_memory = [$maxMemory$]\
                               \n\tstart_free_memory = [$startFreeMemory$] start_used_memory = [$startUsedMemory$]\
                               \n\tend_free_memory = [$endFreeMemory$] end_used_memory = [$endUsedMemory$]
```

<details>
<summary>keywords</summary>

PerformanceLogFormatter, パフォーマンスログ設定, DEBUGレベル出力, ロガー名PERFORMANCE, log.properties, app-log.properties, performanceLogFormatter.format

</details>

## パフォーマンスログを出力する

`PerformanceLogUtil` を使用してパフォーマンスログを出力する。処理開始時に `PerformanceLogUtil#start` を呼び出し、処理終了時に `PerformanceLogUtil#end` を呼び出す。`end` 呼び出し時に、`start` で取得した日時とメモリ使用量を合わせて出力する。

```java
// startメソッドでは、測定対象を識別するポイントを指定する。
// このポイント名が設定ファイルに定義されていないとログは出力されない。
String point = "UserSearchAction#doUSERS00101";
PerformanceLogUtil.start(point);

UserSearchService searchService = new UserSearchService();
SqlResultSet searchResult = searchService.selectByCondition(condition);

// endメソッドでは、ポイント、処理結果を表す文字列、ログ出力のオプション情報を指定できる。
PerformanceLogUtil.end(point, String.valueOf(searchResult.size()));
```

> **重要**: `PerformanceLogUtil` は測定対象を実行時ID＋ポイント名で一意に識別するため、再帰呼び出しの中では使用できない。

<details>
<summary>keywords</summary>

PerformanceLogUtil, PerformanceLogUtil#start, PerformanceLogUtil#end, 実行時間計測, メモリ使用量計測, 再帰呼び出し制限, 測定対象ポイント

</details>

## パフォーマンスログの設定

パフォーマンスログの設定は、 `log-app_log_setting` で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| performanceLogFormatter.className | | | `PerformanceLogFormatter` を実装したクラス。差し替える場合に指定する |
| performanceLogFormatter.format | | デフォルトフォーマット参照 | パフォーマンスログの個別項目のフォーマット |
| performanceLogFormatter.datePattern | | yyyy-MM-dd HH:mm:ss.SSS | 開始・終了日時のパターン（`SimpleDateFormat` 構文） |
| performanceLogFormatter.targetPoints | | | 出力対象のポイント名。カンマ区切りで複数指定可。未設定のポイントはログが出力されない |

`performanceLogFormatter.format` に指定可能なプレースホルダ:

| プレースホルダ | 説明 |
|---|---|
| $point$ | 測定対象を識別するID |
| $result$ | 処理結果を表す文字列 |
| $startTime$ | 処理の開始日時 |
| $endTime$ | 処理の終了日時 |
| $executionTime$ | 処理の実行時間（終了日時 - 開始日時） |
| $maxMemory$ | 処理の開始時点のヒープサイズ |
| $startFreeMemory$ | 処理の開始時点の空きヒープサイズ |
| $startUsedMemory$ | 処理の開始時点の使用ヒープサイズ |
| $endFreeMemory$ | 処理の終了時点の空きヒープサイズ |
| $endUsedMemory$ | 処理の終了時点の使用ヒープサイズ |

デフォルトのフォーマット:
```
\n\tpoint = [$point$] result = [$result$]
\n\tstart_time = [$startTime$] end_time = [$endTime$]
\n\texecution_time = [$executionTime$]
\n\tmax_memory = [$maxMemory$]
\n\tstart_free_memory = [$startFreeMemory$] start_used_memory = [$startUsedMemory$]
\n\tend_free_memory = [$endFreeMemory$] end_used_memory = [$endUsedMemory$]
```

記述例:
```properties
performanceLogFormatter.className=nablarch.core.log.app.PerformanceLogFormatter
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd HH:mm:ss.SSS
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

<details>
<summary>keywords</summary>

performanceLogFormatter.className, performanceLogFormatter.format, performanceLogFormatter.datePattern, performanceLogFormatter.targetPoints, PerformanceLogFormatter, プレースホルダ, $point$, $executionTime$, $maxMemory$

</details>

## JSON形式の構造化ログとして出力する

`log-json_log_setting` 設定によりJSON形式でログを出力する場合、`PerformanceLogFormatter` ではパフォーマンスログの各項目はmessageの値に文字列として出力される。各項目もJSONの値として出力するには `PerformanceJsonLogFormatter` を使用する。設定は `log-app_log_setting` で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| performanceLogFormatter.className | ○ | | JSON形式で出力する場合、`nablarch.core.log.app.PerformanceJsonLogFormatter` を指定する |
| performanceLogFormatter.targets | | 全項目 | 出力項目。カンマ区切りで指定（point, result, startTime, endTime, executionTime, maxMemory, startFreeMemory, startUsedMemory, endFreeMemory, endUsedMemory） |
| performanceLogFormatter.datePattern | | yyyy-MM-dd HH:mm:ss.SSS | 開始・終了日時のパターン（`SimpleDateFormat` 構文） |
| performanceLogFormatter.targetPoints | | | 出力対象のポイント名。カンマ区切りで複数指定可 |
| performanceLogFormatter.structuredMessagePrefix | | $JSON$ | JSON形式であることを識別するマーカー文字列。変更する場合は、LogWriterの `structuredMessagePrefix` プロパティを使用して `JsonLogFormatter` にも同じ値を設定すること |

記述例:
```properties
performanceLogFormatter.className=nablarch.core.log.app.PerformanceJsonLogFormatter
performanceLogFormatter.structuredMessagePrefix=$JSON$
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
performanceLogFormatter.targets=point,result,executionTime
```

<details>
<summary>keywords</summary>

PerformanceJsonLogFormatter, JsonLogFormatter, performanceLogFormatter.className, performanceLogFormatter.targets, performanceLogFormatter.structuredMessagePrefix, performanceLogFormatter.targetPoints, performanceLogFormatter.datePattern, JSON構造化ログ, $JSON$

</details>
