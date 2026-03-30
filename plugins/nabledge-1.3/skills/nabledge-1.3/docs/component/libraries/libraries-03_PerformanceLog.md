# パフォーマンスログの出力

## パフォーマンスログの出力方針

パフォーマンスログは開発時の使用を想定しているためDEBUGレベルで出力する。

| ログレベル | ロガー名 |
|---|---|
| DEBUG | PERFORMANCE |

log.propertiesの設定例:

```properties
loggers.PER.nameRegex=PERFORMANCE
loggers.PER.level=DEBUG
loggers.PER.writerNames=<出力先のログライタ>
```

<details>
<summary>keywords</summary>

パフォーマンスログ, DEBUGレベル, PERFORMANCE, log.properties, ロガー名設定, パフォーマンスログ設定

</details>

## パフォーマンスログの出力項目

:ref:`Log_BasicLogFormatter` の共通項目は省略する。共通項目と組み合わせたフォーマットは :ref:`AppLog_Format` を参照。

| 項目名 | 説明 |
|---|---|
| ポイント | 測定対象を識別するID |
| 処理結果 | 処理結果を表す文字列 |
| 開始日時 | 処理の開始日時 |
| 終了日時 | 処理の終了日時 |
| 実行時間 | 処理の実行時間（終了日時－開始日時） |
| 最大メモリ量 | 処理の開始時点のヒープサイズ |
| 開始時の空きメモリ量 | 処理の開始時点の空きヒープサイズ |
| 開始時の使用メモリ量 | 処理の開始時点の使用ヒープサイズ |
| 終了時の空きメモリ量 | 処理の開始時点の空きヒープサイズ |
| 終了時の使用メモリ量 | 処理の開始時点の使用ヒープサイズ |

<details>
<summary>keywords</summary>

パフォーマンスログ出力項目, ポイント, 処理結果, 実行時間, メモリ使用量, 開始日時, 終了日時

</details>

## パフォーマンスログの出力方法

**クラス**: `nablarch.core.log.app.PerformanceLogUtil`, `nablarch.core.log.app.PerformanceLogFormatter`

| クラス名 | 概要 |
|---|---|
| `nablarch.core.log.app.PerformanceLogUtil` | パフォーマンスログを出力するクラス |
| `nablarch.core.log.app.PerformanceLogFormatter` | パフォーマンスログの個別項目をフォーマットするクラス |

`PerformanceLogUtil`のstartメソッドで計測開始、endメソッドで計測終了・出力を行う。endメソッド呼び出し時にstartメソッドで取得した日時とメモリ使用量を合わせて出力する。

```java
// startメソッドでは、測定対象を識別するポイントを指定する。
String point = "UserSearchAction#doUSERS00101";
PerformanceLogUtil.start(point);

// 検索実行
UserSearchService searchService = new UserSearchService();
SqlResultSet searchResult = searchService.selectByCondition(condition);

// endメソッドでは、ポイント、処理結果を表す文字列、ログ出力のオプション情報を指定できる。
PerformanceLogUtil.end(point, String.valueOf(searchResult.size()));
```

> **警告**: PerformanceLogUtilは実行時ID＋ポイント名で一意識別するため、再帰呼び出し中では使用不可。

app-log.propertiesの設定例:

```properties
performanceLogFormatter.className=nablarch.core.log.app.PerformanceLogFormatter
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd HH:mm:ss.SSS
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| performanceLogFormatter.className | | PerformanceLogFormatterのクラス名。差し替える場合に指定する |
| performanceLogFormatter.format | | パフォーマンスログの個別項目のフォーマット |
| performanceLogFormatter.datePattern | yyyy-MM-dd HH:mm:ss.SSS | 開始・終了日時の日時パターン（java.text.SimpleDateFormat構文） |
| performanceLogFormatter.targetPoints | | 出力対象ポイント名。複数はカンマ区切り。誤設定による無駄な出力を防ぐためこの設定に基づき出力する |

フォーマットに指定可能なプレースホルダ:

| プレースホルダ | 説明 |
|---|---|
| $point$ | 測定対象を識別するID |
| $result$ | 処理結果を表す文字列 |
| $startTime$ | 処理の開始日時 |
| $endTime$ | 処理の終了日時 |
| $executionTime$ | 処理の実行時間（終了日時－開始日時） |
| $maxMemory$ | 処理の開始時点のヒープサイズ |
| $startFreeMemory$ | 処理の開始時点の空きヒープサイズ |
| $startUsedMemory$ | 処理の開始時点の使用ヒープサイズ |
| $endFreeMemory$ | 処理の開始時点の空きヒープサイズ |
| $endUsedMemory$ | 処理の開始時点の使用ヒープサイズ |

デフォルトフォーマット:

```
\n\tpoint = [$point$] result = [$result$]
\n\tstart_time = [$startTime$] end_time = [$endTime$]
\n\texecution_time = [$executionTime$]
\n\tmax_memory = [$maxMemory$]
\n\tstart_free_memory = [$startFreeMemory$] start_used_memory = [$startUsedMemory$]
\n\tend_free_memory = [$endFreeMemory$] end_used_memory = [$endUsedMemory$]
```

<details>
<summary>keywords</summary>

PerformanceLogUtil, PerformanceLogFormatter, nablarch.core.log.app.PerformanceLogUtil, nablarch.core.log.app.PerformanceLogFormatter, performanceLogFormatter.className, performanceLogFormatter.targetPoints, performanceLogFormatter.format, performanceLogFormatter.datePattern, $point$, $result$, $startTime$, $endTime$, $executionTime$, $maxMemory$, $startFreeMemory$, $startUsedMemory$, $endFreeMemory$, $endUsedMemory$, パフォーマンスログ出力方法, 再帰呼び出し

</details>

## パフォーマンスログの出力例

log.propertiesの設定例:

```properties
writerNames=appFile

# ログの出力先
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=./app.log
writer.appFile.encoding=UTF-8
writer.appFile.maxFileSize=10000
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=$date$ -$logLevel$- R[$requestId$] U[$userId$] E[$executionId$] $message$

availableLoggersNamesOrder=PER

# PER
loggers.PER.nameRegex=PERFORMANCE
loggers.PER.level=DEBUG
loggers.PER.writerNames=appFile
```

app-log.propertiesの設定例:

```properties
# PerformanceLogFormatterの設定(個別項目のフォーマット)
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

出力結果:

```
2011-02-15 18:25:50.577 -DEBUG- R[USERS00101] U[0000000001] E[APUSRMGR0001201102151825504990004] point:UserSearchAction#doUSERS00101 result:17 exe_time:16ms
```

<details>
<summary>keywords</summary>

パフォーマンスログ出力例, FileLogWriter, writerNames, availableLoggersNamesOrder, writer.appFile, BasicLogFormatter

</details>
