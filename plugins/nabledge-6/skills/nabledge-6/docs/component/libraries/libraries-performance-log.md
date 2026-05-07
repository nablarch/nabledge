# パフォーマンスログの出力

**目次**

* パフォーマンスログの出力方針
* 使用方法

  * パフォーマンスログを出力する
  * パフォーマンスログの設定
  * JSON形式の構造化ログとして出力する

パフォーマンスログは、任意の処理範囲に対する実行時間とメモリ使用量を出力し、
開発時のパフォーマンスチューニングに使用する。
アプリケーションでは、ソースコード上でフレームワークが提供するAPIを呼び出し、計測対象の処理範囲を指定して出力する。

## パフォーマンスログの出力方針

パフォーマンスログは、ヒープサイズの取得などでパフォーマンスに影響を与える可能性がある。
そのため、開発時の使用を想定しているためDEBUGレベルで出力する。

パフォーマンスログの出力方針

| ログレベル | ロガー名 |
|---|---|
| DEBUG | PERFORMANCE |

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

availableLoggersNamesOrder=PER,ROO

# アプリケーションログの設定
loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

# パフォーマンスログの設定
loggers.PER.nameRegex=PERFORMANCE
loggers.PER.level=DEBUG
loggers.PER.writerNames=appLog
```

app-log.propertiesの設定例

```properties
# PerformanceLogFormatter
#performanceLogFormatter.className=
#performanceLogFormatter.targetPoints=
#performanceLogFormatter.datePattern=
performanceLogFormatter.format=\n\tpoint = [$point$] result = [$result$]\
                               \n\tstart_time = [$startTime$] end_time = [$endTime$]\
                               \n\texecution_time = [$executionTime$]\
                               \n\tmax_memory = [$maxMemory$]\
                               \n\tstart_free_memory = [$startFreeMemory$] start_used_memory = [$startUsedMemory$]\
                               \n\tend_free_memory = [$endFreeMemory$] end_used_memory = [$endUsedMemory$]
```

## 使用方法

### パフォーマンスログを出力する

パフォーマンスログは、 PerformanceLogUtil を使用して出力する。
PerformanceLogUtil は、
処理の開始時に呼び出す PerformanceLogUtil#start と
終了時に呼び出す PerformanceLogUtil#end
を提供する。
PerformanceLogUtil は、
PerformanceLogUtil#end
が呼ばれた時点で、 PerformanceLogUtil#start
で取得した日時とメモリ使用量を合わせて出力する。

PerformanceLogUtil の使用例を下記に示す。

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

> **Important:**
> PerformanceLogUtil は、
> 測定対象を [実行時ID](../../component/libraries/libraries-log.md#ログのフォーマットを指定する) ＋ポイント名で一意に識別している。
> このため、再帰呼び出しの中で PerformanceLogUtil
> を使用すると計測を実施出来ないため注意すること。

### パフォーマンスログの設定

パフォーマンスログの設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#各種ログの設定) で説明したプロパティファイルに行う。

記述ルール

performanceLogFormatter.className

PerformanceLogFormatter を実装したクラス。
差し替える場合に指定する。

performanceLogFormatter.format

パフォーマンスログの個別項目のフォーマット。

フォーマットに指定可能なプレースホルダ

$point$

$result$

$startTime$

$endTime$

$executionTime$

$maxMemory$

$startFreeMemory$

$startUsedMemory$

$endFreeMemory$

$endUsedMemory$

デフォルトのフォーマット

```bash
\n\tpoint = [$point$] result = [$result$]
\n\tstart_time = [$startTime$] end_time = [$endTime$]
\n\texecution_time = [$executionTime$]
\n\tmax_memory = [$maxMemory$]
\n\tstart_free_memory = [$startFreeMemory$] start_used_memory = [$startUsedMemory$]
\n\tend_free_memory = [$endFreeMemory$] end_used_memory = [$endUsedMemory$]
```

performanceLogFormatter.datePattern

開始日時と終了日時に使用する日時パターン。
パターンには、 SimpleDateFormat が規程している構文を指定する。
デフォルトは”yyyy-MM-dd HH:mm:ss.SSS”。

performanceLogFormatter.targetPoints

出力対象とするポイント名。
複数指定する場合はカンマ区切り。
パフォーマンスログは、誤設定による無駄な出力を防ぐため、この設定に基づき出力する。

記述例

```properties
performanceLogFormatter.className=nablarch.core.log.app.PerformanceLogFormatter
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd HH:mm:ss.SSS
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

### JSON形式の構造化ログとして出力する

[JSON形式の構造化ログとして出力する](../../component/libraries/libraries-log.md#json形式の構造化ログとして出力する) 設定によりログをJSON形式で出力できるが、
PerformanceLogFormatter では
パフォーマンスログの各項目はmessageの値に文字列として出力される。
パフォーマンスログの各項目もJSONの値として出力するには、
PerformanceJsonLogFormatter を使用する。
設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#各種ログの設定) で説明したプロパティファイルに行う。

記述ルール

PerformanceJsonLogFormatter を用いる際に
指定するプロパティは以下の通り。

performanceLogFormatter.className `必須`

JSON形式でログを出力する場合、
PerformanceJsonLogFormatter を指定する。

performanceLogFormatter.targets

パフォーマンスログの出力項目。カンマ区切りで指定する。

指定可能な出力項目

point

result

startTime

endTime

executionTime

maxMemory

startFreeMemory

startUsedMemory

endFreeMemory

endUsedMemory

デフォルトは全ての出力項目が対象となる。

performanceLogFormatter.datePattern

開始日時と終了日時に使用する日時パターン。
パターンには、 SimpleDateFormat が規程している構文を指定する。
デフォルトは”yyyy-MM-dd HH:mm:ss.SSS”。

performanceLogFormatter.targetPoints

出力対象とするポイント名。
複数指定する場合はカンマ区切り。
パフォーマンスログは、誤設定による無駄な出力を防ぐため、この設定に基づき出力する。

performanceLogFormatter.structuredMessagePrefix

フォーマット後のメッセージ文字列が JSON 形式に整形されていることを識別できるようにするために、メッセージの先頭に付与するマーカー文字列。
メッセージの先頭にあるマーカー文字列が JsonLogFormatter に設定しているマーカー文字列と一致する場合、 JsonLogFormatter はメッセージを JSON データとして処理する。
デフォルトは `"$JSON$"` となる。
変更する場合は、LogWriterの `structuredMessagePrefix` プロパティを使用して JsonLogFormatter にも同じ値を設定すること（LogWriterのプロパティについては [ログ出力の設定](../../component/libraries/libraries-log.md#ログ出力の設定) を参照）。

記述例

```properties
performanceLogFormatter.className=nablarch.core.log.app.PerformanceJsonLogFormatter
performanceLogFormatter.structuredMessagePrefix=$JSON$
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
performanceLogFormatter.targets=point,result,executionTime
```
