# HTTPアクセスログ（RESTfulウェブサービス用）の出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/jaxrs_access_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessLogFormatter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessJsonLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/MessageBodyLogTargetMatcher.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsBodyLogTargetMatcher.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/LogContentMaskingFilter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsBodyMaskingFilter.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogFormatter.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html)

## HTTPアクセスログ（RESTfulウェブサービス用）の出力方針

HTTPアクセスログは、フレームワークが提供するハンドラ（[jaxrs_access_log_handler](../handlers/handlers-jaxrs_access_log_handler.md)）を使用して出力する。リクエストパラメータを含めたリクエスト情報を出力することで、個別アプリケーションの証跡ログの要件を満たせる場合は、HTTPアクセスログと証跡ログを兼用することも想定している。

HTTPアクセスログはアプリケーションログ（ロガー名: `HTTP_ACCESS`、ログレベル: `INFO`）に出力する。

| ログレベル | ロガー名 |
|---|---|
| INFO | HTTP_ACCESS |

**log.properties 設定例**:
```properties
writerNames=appLog

writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.appLog.encoding=UTF-8
writer.appLog.maxFileSize=10000
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=ACC,ROO

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

loggers.ACC.nameRegex=HTTP_ACCESS
loggers.ACC.level=INFO
loggers.ACC.writerNames=appLog
```

**app-log.properties 設定例**:
```properties
jaxRsAccessLogFormatter.beginFormat=@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]\
                                      \n\turl         = [$url$$query$]\
                                      \n\tmethod      = [$method$]\
                                      \n\tport        = [$port$]\
                                      \n\tclient_ip   = [$clientIpAddress$]\
                                      \n\tclient_host = [$clientHost$]
jaxRsAccessLogFormatter.endFormat=@@@@ END @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$] url = [$url$$query$] method = [$method$] status_code = [$statusCode$]\
                                    \n\tstart_time     = [$startTime$]\
                                    \n\tend_time       = [$endTime$]\
                                    \n\texecution_time = [$executionTime$]\
                                    \n\tmax_memory     = [$maxMemory$]\
                                    \n\tfree_memory    = [$freeMemory$]
```

<details>
<summary>keywords</summary>

HTTP_ACCESS, HTTPアクセスログ出力方針, ログレベル設定, log.properties, app-log.properties, JaxRsAccessLogFormatter, BasicLogFormatter, 証跡ログ兼用

</details>

## HTTPアクセスログ（RESTfulウェブサービス用）の設定

設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| `jaxRsAccessLogFormatter.className` | | `nablarch.fw.jaxrs.JaxRsAccessLogFormatter` | `JaxRsAccessLogFormatter` 実装クラス。差し替える場合に指定する |
| `jaxRsAccessLogFormatter.beginFormat` | | （下記参照）| リクエスト処理開始時のログフォーマット |
| `jaxRsAccessLogFormatter.endFormat` | | （下記参照）| リクエスト処理終了時のログフォーマット |
| `jaxRsAccessLogFormatter.datePattern` | | `yyyy-MM-dd HH:mm:ss.SSS` | 開始・終了日時のパターン（SimpleDateFormat構文）|
| `jaxRsAccessLogFormatter.maskingPatterns` | | | マスク対象パラメータ名・変数名（正規表現、カンマ区切り、大文字小文字区別なし）。リクエストパラメータとセッションスコープ情報の両方に適用 |
| `jaxRsAccessLogFormatter.maskingChar` | | `*` | マスク文字 |
| `jaxRsAccessLogFormatter.bodyLogTargetMatcher` | | `nablarch.fw.jaxrs.JaxRsBodyLogTargetMatcher` | リクエスト/レスポンスボディ出力判定クラス（`MessageBodyLogTargetMatcher` 実装）|
| `jaxRsAccessLogFormatter.bodyMaskingFilter` | | `nablarch.fw.jaxrs.JaxRsBodyMaskingFilter` | リクエスト/レスポンスボディマスク処理クラス（`LogContentMaskingFilter` 実装）|
| `jaxRsAccessLogFormatter.bodyMaskingItemNames` | | | ボディのマスク対象項目名（カンマ区切り）|
| `jaxRsAccessLogFormatter.parametersSeparator` | | `\n\t\t` | リクエストパラメータのセパレータ |
| `jaxRsAccessLogFormatter.sessionScopeSeparator` | | `\n\t\t` | セッションスコープ情報のセパレータ |
| `jaxRsAccessLogFormatter.beginOutputEnabled` | | `true` | リクエスト処理開始時出力の有効/無効 |
| `jaxRsAccessLogFormatter.endOutputEnabled` | | `true` | リクエスト処理終了時出力の有効/無効 |

> **重要**: デフォルトの `JaxRsBodyMaskingFilter` はJSON形式のみサポートしている。

**beginFormat プレースホルダ**:

| プレースホルダ | 説明 |
|---|---|
| `$requestId$` | リクエストID |
| `$userId$` | ユーザID |
| `$url$` | URL |
| `$query$` | クエリ文字列 |
| `$port$` | ポート番号 |
| `$method$` | HTTPメソッド |
| `$sessionId$` | HTTPセッションID |
| `$sessionStoreId$` | セッションストアID |
| `$parameters$` | リクエストパラメータ（リクエストボディは含まない）|
| `$sessionScope$` | セッションスコープ情報 |
| `$clientIpAddress$` | クライアント端末IPアドレス |
| `$clientHost$` | クライアント端末ホスト |
| `$clientUserAgent$` | HTTPヘッダのUser-Agent |
| `$requestBody$` | リクエストボディ |

> **補足**: `$parameters$` にはリクエストボディは含まれない。リクエストボディを出力する場合は `$requestBody$` を使用する。

> **重要**: リクエストIDとユーザIDの取得元は `ThreadContext` のため、ハンドラ構成に [thread_context_handler](../handlers/handlers-thread_context_handler.md) が含まれている必要がある。ユーザIDについては [thread_context_handler-user_id_attribute_setting](../handlers/handlers-thread_context_handler.md) を参照してセッションに値を設定すること。

**beginFormat デフォルト**:
```bash
@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]
    \n\turl         = [$url$]
    \n\tmethod      = [$method$]
    \n\tport        = [$port$]
    \n\tclient_ip   = [$clientIpAddress$]
    \n\tclient_host = [$clientHost$]
```

**endFormat プレースホルダ**:

| プレースホルダ | 説明 |
|---|---|
| `$statusCode$` | ステータスコード |
| `$startTime$` | 開始日時 |
| `$endTime$` | 終了日時 |
| `$executionTime$` | 実行時間 |
| `$maxMemory$` | 最大メモリ量 |
| `$freeMemory$` | 空きメモリ量（開始時）|
| `$sessionStoreId$` | セッションストアID |
| `$responseBody$` | レスポンスボディ |

**endFormat デフォルト**:
```bash
@@@@ END @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$] url = [$url$] status_code = [$statusCode$]
    \n\tstart_time     = [$startTime$]
    \n\tend_time       = [$endTime$]
    \n\texecution_time = [$executionTime$]
    \n\tmax_memory     = [$maxMemory$]
    \n\tfree_memory    = [$freeMemory$]
```

**設定例**:
```properties
jaxRsAccessLogFormatter.className=nablarch.fw.jaxrs.JaxRsAccessLogFormatter
jaxRsAccessLogFormatter.beginFormat=> sid = [$sessionId$] @@@@ BEGIN @@@@\n\turl = [$url$]\n\tmethod = [$method$]
jaxRsAccessLogFormatter.endFormat=< sid = [$sessionId$] @@@@ END @@@@ url = [$url$] status_code = [$statusCode$]
jaxRsAccessLogFormatter.datePattern="yyyy-MM-dd HH:mm:ss.SSS"
jaxRsAccessLogFormatter.maskingChar=#
jaxRsAccessLogFormatter.maskingPatterns=password,mobilePhoneNumber
jaxRsAccessLogFormatter.bodyLogTargetMatcher=nablarch.fw.jaxrs.JaxRsBodyLogTargetMatcher
jaxRsAccessLogFormatter.bodyMaskingFilter=nablarch.fw.jaxrs.JaxRsBodyMaskingFilter
jaxRsAccessLogFormatter.bodyMaskingItemNames=password,mobilePhoneNumber
jaxRsAccessLogFormatter.parametersSeparator=,
jaxRsAccessLogFormatter.sessionScopeSeparator=,
jaxRsAccessLogFormatter.beginOutputEnabled=true
jaxRsAccessLogFormatter.endOutputEnabled=true
```

<details>
<summary>keywords</summary>

JaxRsAccessLogFormatter, MessageBodyLogTargetMatcher, JaxRsBodyLogTargetMatcher, LogContentMaskingFilter, JaxRsBodyMaskingFilter, ThreadContext, jaxRsAccessLogFormatter.beginFormat, jaxRsAccessLogFormatter.endFormat, jaxRsAccessLogFormatter.datePattern, jaxRsAccessLogFormatter.maskingPatterns, jaxRsAccessLogFormatter.maskingChar, jaxRsAccessLogFormatter.bodyLogTargetMatcher, jaxRsAccessLogFormatter.bodyMaskingFilter, jaxRsAccessLogFormatter.bodyMaskingItemNames, jaxRsAccessLogFormatter.parametersSeparator, jaxRsAccessLogFormatter.sessionScopeSeparator, jaxRsAccessLogFormatter.beginOutputEnabled, jaxRsAccessLogFormatter.endOutputEnabled, HTTPアクセスログ設定, マスキング設定, リクエストボディログ

</details>

## JSON形式の構造化ログとして出力する

[log-json_log_setting](libraries-log.md) でJSON形式出力する場合、デフォルトの `JaxRsAccessLogFormatter` ではHTTPアクセスログ各項目がmessageの値に文字列として出力される。各項目もJSONの値として出力するには `JaxRsAccessJsonLogFormatter` を使用する。設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| `httpAccessLogFormatter.className` | ○ | | JSON形式の場合 `nablarch.fw.jaxrs.JaxRsAccessJsonLogFormatter` を指定 |
| `jaxRsAccessLogFormatter.beginTargets` | | （下記デフォルト参照）| リクエスト処理開始時の出力項目（カンマ区切り）|
| `jaxRsAccessLogFormatter.endTargets` | | （下記デフォルト参照）| リクエスト処理終了時の出力項目（カンマ区切り）|
| `jaxRsAccessLogFormatter.datePattern` | | `yyyy-MM-dd HH:mm:ss.SSS` | 日時パターン（SimpleDateFormat構文）|
| `jaxRsAccessLogFormatter.maskingPatterns` | | | マスク対象パラメータ名・変数名（正規表現、カンマ区切り、大文字小文字区別なし、部分一致）|
| `jaxRsAccessLogFormatter.maskingChar` | | `*` | マスク文字 |
| `jaxRsAccessLogFormatter.beginOutputEnabled` | | `true` | 開始時出力有効/無効 |
| `jaxRsAccessLogFormatter.endOutputEnabled` | | `true` | 終了時出力有効/無効 |
| `jaxRsAccessLogFormatter.beginLabel` | | `"HTTP ACCESS BEGIN"` | 開始時ログのlabel値 |
| `jaxRsAccessLogFormatter.endLabel` | | `"HTTP ACCESS END"` | 終了時ログのlabel値 |
| `jaxRsAccessLogFormatter.structuredMessagePrefix` | | `"$JSON$"` | JSONデータ識別マーカー文字列。変更する場合はLogWriterの `structuredMessagePrefix` にも同じ値を設定すること（[log-basic_setting](libraries-log.md) 参照）|

**beginTargets 指定可能項目**（デフォルト: `label`, `requestId`, `userId`, `sessionId`, `url`, `port`, `method`, `clientIpAddress`, `clientHost`）:
`label`, `requestId`, `userId`, `sessionId`, `sessionStoreId`, `url`, `port`, `method`, `queryString`, `parameters`, `sessionScope`, `clientIpAddress`, `clientHost`, `clientUserAgent`, `requestBody`

**endTargets 指定可能項目**（デフォルト: `label`, `requestId`, `userId`, `sessionId`, `url`, `statusCode`, `startTime`, `endTime`, `executionTime`, `maxMemory`, `freeMemory`）:
`label`, `requestId`, `userId`, `sessionId`, `sessionStoreId`, `url`, `statusCode`, `startTime`, `endTime`, `executionTime`, `maxMemory`, `freeMemory`, `responseBody`

**設定例**:
```properties
httpAccessLogFormatter.className=nablarch.fw.jaxrs.JaxRsAccessJsonLogFormatter
httpAccessLogFormatter.structuredMessagePrefix=$JSON$
httpAccessLogFormatter.beginTargets=sessionId,url,method
httpAccessLogFormatter.endTargets=sessionId,url,statusCode
httpAccessLogFormatter.beginLabel=HTTP ACCESS BEGIN
httpAccessLogFormatter.endLabel=HTTP ACCESS END
```

<details>
<summary>keywords</summary>

JaxRsAccessJsonLogFormatter, JsonLogFormatter, jaxRsAccessLogFormatter.beginTargets, jaxRsAccessLogFormatter.endTargets, jaxRsAccessLogFormatter.structuredMessagePrefix, jaxRsAccessLogFormatter.beginLabel, jaxRsAccessLogFormatter.endLabel, jaxRsAccessLogFormatter.beginOutputEnabled, jaxRsAccessLogFormatter.endOutputEnabled, jaxRsAccessLogFormatter.datePattern, httpAccessLogFormatter.className, httpAccessLogFormatter.beginTargets, httpAccessLogFormatter.endTargets, httpAccessLogFormatter.structuredMessagePrefix, JSON形式ログ出力

</details>

## セッションストアIDについて

セッションストアIDを出力に含めた場合、 :ref:`session_store` が発行するセッションを識別するIDが出力される。この値は [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の往路で記録されたものが使用される。

> **重要**: セッションストアIDをログに出力する場合、 [jaxrs_access_log_handler](../handlers/handlers-jaxrs_access_log_handler.md) は [session_store_handler](../handlers/handlers-SessionStoreHandler.md) より後に配置しなければならない。

セッションストアIDはリクエスト処理開始時の状態で固定されるため、以下の仕様となる:
- セッションストアIDが発行されていないリクエストでは、途中でIDが発行されても同一リクエスト内で出力されるセッションストアIDはすべて空になる
- 途中でセッションを破棄（ `SessionUtil.invalidate` ）したりIDを変更（ `SessionUtil.changeId` ）しても、ログに出力される値はリクエスト処理開始時のものから変化しない

<details>
<summary>keywords</summary>

セッションストアID, SessionUtil, session_store_handler, jaxrs_access_log_handler, session_store

</details>
