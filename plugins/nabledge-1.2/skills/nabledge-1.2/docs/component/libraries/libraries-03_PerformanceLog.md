# パフォーマンスログの出力

## パフォーマンスログの出力方針

パフォーマンスログは開発時の使用を想定しているため、DEBUGレベルで出力する。

| ログレベル | ロガー名 |
|---|---|
| DEBUG | PERFORMANCE |

**log.propertiesの設定例**:
```bash
# PERFORMANCE
loggers.PER.nameRegex=PERFORMANCE
loggers.PER.level=DEBUG
loggers.PER.writerNames=<出力先のログライタ>
```

<details>
<summary>keywords</summary>

パフォーマンスログ, DEBUGレベル, PERFORMANCE, ログレベル設定, log.properties

</details>

## パフォーマンスログの出力項目

| 項目名 | 説明 |
|---|---|
| ポイント | 測定対象を識別するID |
| 処理結果 | 処理結果を表す文字列 |
| 開始日時 | 処理の開始日時 |
| 終了日時 | 処理の終了日時 |
| 実行時間 | 処理の実行時間（終了日時－開始日時）|
| 最大メモリ量 | 処理の開始時点のヒープサイズ |
| 開始時の空きメモリ量 | 処理の開始時点の空きヒープサイズ |
| 開始時の使用メモリ量 | 処理の開始時点の使用ヒープサイズ |
| 終了時の空きメモリ量 | 処理の開始時点の空きヒープサイズ |
| 終了時の使用メモリ量 | 処理の開始時点の使用ヒープサイズ |

<details>
<summary>keywords</summary>

パフォーマンスログ出力項目, 実行時間, メモリ使用量, ポイント, 処理結果

</details>

## パフォーマンスログの出力方法

**クラス**: `nablarch.core.log.app.PerformanceLogUtil`, `nablarch.core.log.app.PerformanceLogFormatter`

`PerformanceLogUtil` を使用してパフォーマンスログを出力する。`start(point)` で計測開始、`end(point, result)` で計測終了とログ出力を行う。

```java
String point = "UserSearchAction#doUSERS00101";
PerformanceLogUtil.start(point);

UserSearchService searchService = new UserSearchService();
SqlResultSet searchResult = searchService.selectByCondition(condition);

// endメソッドでは、ポイント、処理結果を表す文字列、ログ出力のオプション情報を指定できる。
// 以下ではログ出力のオプション情報は指定していない。
PerformanceLogUtil.end(point, String.valueOf(searchResult.size()));
```

> **警告**: `PerformanceLogUtil` は測定対象を実行時ID＋ポイント名で一意に識別する。再帰呼び出し内での使用は計測できない。

`PerformanceLogUtil` はプロパティファイル（`app-log.properties`）を読み込み、`PerformanceLogFormatter` に個別項目のフォーマット処理を委譲する。

**app-log.propertiesの設定例**:
```bash
performanceLogFormatter.className=nablarch.core.log.app.PerformanceLogFormatter
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd HH:mm:ss.SSS
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

| プロパティ名 | 説明 |
|---|---|
| `performanceLogFormatter.className` | PerformanceLogFormatterのクラス名。差し替え時に指定する |
| `performanceLogFormatter.format` | パフォーマンスログの個別項目のフォーマット |
| `performanceLogFormatter.datePattern` | 開始・終了日時の日時パターン（java.text.SimpleDateFormat構文）。デフォルト: `yyyy-MM-dd HH:mm:ss.SSS` |
| `performanceLogFormatter.targetPoints` | 出力対象とするポイント名（複数はカンマ区切り）。誤設定による無駄な出力を防ぐためこの設定で出力を制御する |

フォーマットに使用可能なプレースホルダ:

| プレースホルダ | 説明 |
|---|---|
| `$point$` | 測定対象を識別するID |
| `$result$` | 処理結果を表す文字列 |
| `$startTime$` | 処理の開始日時 |
| `$endTime$` | 処理の終了日時 |
| `$executionTime$` | 処理の実行時間（終了日時－開始日時）|
| `$maxMemory$` | 処理の開始時点のヒープサイズ |
| `$startFreeMemory$` | 処理の開始時点の空きヒープサイズ |
| `$startUsedMemory$` | 処理の開始時点の使用ヒープサイズ |
| `$endFreeMemory$` | 処理の開始時点の空きヒープサイズ |
| `$endUsedMemory$` | 処理の開始時点の使用ヒープサイズ |

デフォルトのフォーマット:
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

PerformanceLogUtil, PerformanceLogFormatter, nablarch.core.log.app.PerformanceLogUtil, nablarch.core.log.app.PerformanceLogFormatter, performanceLogFormatter.className, performanceLogFormatter.format, performanceLogFormatter.datePattern, performanceLogFormatter.targetPoints, $point$, $result$, $startTime$, $endTime$, $executionTime$, $maxMemory$, $startFreeMemory$, $startUsedMemory$, $endFreeMemory$, $endUsedMemory$, パフォーマンス計測, startメソッド, endメソッド, app-log.properties, 再帰呼び出し

</details>

## パフォーマンスログの出力例

**log.propertiesの設定例**:
```bash
writerNames=appFile
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=./app.log
writer.appFile.encoding=UTF-8
writer.appFile.maxFileSize=10000
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=$date$ -$logLevel$- R[$requestId$] U[$userId$] E[$executionId$] $message$
availableLoggersNamesOrder=PER
loggers.PER.nameRegex=PERFORMANCE
loggers.PER.level=DEBUG
loggers.PER.writerNames=appFile
```

**app-log.propertiesの設定例**:
```bash
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

上記設定から出力した結果（`PerformanceLogUtil` の使用例で示した検索処理）:
```
2011-02-15 18:25:50.577 -DEBUG- R[USERS00101] U[0000000001] E[APUSRMGR0001201102151825504990004] point:UserSearchAction#doUSERS00101 result:17 exe_time:16ms
```

<details>
<summary>keywords</summary>

パフォーマンスログ出力例, log.properties, app-log.properties, FileLogWriter, BasicLogFormatter, PerformanceLogFormatter, 実際のログ出力

</details>
