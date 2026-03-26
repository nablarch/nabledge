# パフォーマンスログの出力

## パフォーマンスログの出力方針・出力項目

## パフォーマンスログの出力方針・出力項目

任意の処理範囲の実行時間とメモリ使用量を出力する。`PerformanceLogUtil` のAPIを呼び出して計測対象の処理範囲を指定する。

### 出力方針

パフォーマンスログはDEBUGレベルで出力する。

| ログレベル | ロガー名 |
|---|---|
| DEBUG | PERFORMANCE |

**log.propertiesの設定例**:
```bash
loggers.PER.nameRegex=PERFORMANCE
loggers.PER.level=DEBUG
loggers.PER.writerNames=<出力先のログライタ>
```

### 出力項目

共通項目については :ref:`Log_BasicLogFormatter` を参照。共通項目と個別項目を組み合わせたフォーマットは :ref:`AppLog_Format` を参照。

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

パフォーマンスログ, 実行時間計測, メモリ使用量計測, PERFORMANCE, ロガー名, DEBUGレベル, ポイント, 処理結果, 開始日時, 終了日時, 実行時間, 最大メモリ量, 開始時の空きメモリ量, 開始時の使用メモリ量, 終了時の空きメモリ量, 終了時の使用メモリ量

</details>

## パフォーマンスログの出力方法

## パフォーマンスログの出力方法

**クラス**:
- `nablarch.core.log.app.PerformanceLogUtil`: パフォーマンスログを出力するクラス
- `nablarch.core.log.app.PerformanceLogFormatter`: パフォーマンスログの個別項目をフォーマットするクラス

`PerformanceLogUtil` の使用方法:
- `start(point)`: 処理開始時に呼び出す。ポイント（測定対象を識別するID）を指定する
- `end(point, result[, options])`: 処理終了時に呼び出す。ポイント、処理結果を表す文字列、ログ出力のオプション情報（省略可）を指定できる。endメソッドが呼ばれた時点で、startメソッドで取得した日時とメモリ使用量を合わせて出力する

```java
String point = "UserSearchAction#doUSERS00101";
PerformanceLogUtil.start(point);

UserSearchService searchService = new UserSearchService();
SqlResultSet searchResult = searchService.selectByCondition(condition);

// ログ出力のオプション情報は省略可能
PerformanceLogUtil.end(point, String.valueOf(searchResult.size()));
```

> **警告**: PerformanceLogUtilは測定対象を実行時ID＋ポイント名で一意に識別するため、再帰呼び出しの中では計測できない。

プロパティファイル(app-log.properties)を読み込み、PerformanceLogFormatterオブジェクトを生成して個別項目のフォーマット処理を委譲する。プロパティファイルのパス指定や実行時の変更方法は :ref:`AppLog_Config` を参照。

**app-log.propertiesの設定例**:
```bash
performanceLogFormatter.className=nablarch.core.log.app.PerformanceLogFormatter
performanceLogFormatter.targetPoints=UserSearchAction#doUSERS00101
performanceLogFormatter.datePattern=yyyy-MM-dd HH:mm:ss.SSS
performanceLogFormatter.format=point:$point$ result:$result$ exe_time:$executionTime$ms
```

**プロパティ一覧**:

| プロパティ名 | 説明 |
|---|---|
| performanceLogFormatter.className | PerformanceLogFormatterのクラス名。差し替える場合に指定する |
| performanceLogFormatter.format | 個別項目のフォーマット |
| performanceLogFormatter.datePattern | 開始日時・終了日時の日時パターン。デフォルト: `yyyy-MM-dd HH:mm:ss.SSS` |
| performanceLogFormatter.targetPoints | 出力対象とするポイント名。複数指定はカンマ区切り。誤設定による無駄な出力を防ぐためこの設定に基づき出力する |

**フォーマットのプレースホルダ一覧**:

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

**デフォルトフォーマット**:
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

PerformanceLogUtil, PerformanceLogFormatter, nablarch.core.log.app.PerformanceLogUtil, nablarch.core.log.app.PerformanceLogFormatter, start, end, performanceLogFormatter.className, performanceLogFormatter.format, performanceLogFormatter.datePattern, performanceLogFormatter.targetPoints, $point$, $result$, $executionTime$, $startTime$, $endTime$, $maxMemory$, $startFreeMemory$, $startUsedMemory$, $endFreeMemory$, $endUsedMemory$

</details>

## パフォーマンスログの出力例

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

上記設定から出力した結果（PerformanceLogUtilの使用例で示した検索処理の出力）:
```
2011-02-15 18:25:50.577 -DEBUG- R[USERS00101] U[0000000001] E[APUSRMGR0001201102151825504990004] point:UserSearchAction#doUSERS00101 result:17 exe_time:16ms
```

<details>
<summary>keywords</summary>

パフォーマンスログ, 出力例, PerformanceLogUtil, performanceLogFormatter.targetPoints, performanceLogFormatter.format

</details>
