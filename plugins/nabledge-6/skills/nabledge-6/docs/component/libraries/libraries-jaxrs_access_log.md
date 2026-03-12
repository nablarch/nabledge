# HTTPアクセスログ（RESTfulウェブサービス用）の出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/jaxrs_access_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessLogFormatter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessJsonLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/MessageBodyLogTargetMatcher.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsBodyLogTargetMatcher.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/LogContentMaskingFilter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsBodyMaskingFilter.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogFormatter.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html)

## HTTPアクセスログの出力方針

HTTPアクセスログはフレームワークが提供するハンドラを使用して出力する。アプリケーションではハンドラを設定することでHTTPアクセスログを出力できる。

**HTTPアクセスログの出力に必要なハンドラ:**

- `:ref:jaxrs_access_log_handler` — リクエスト処理開始時と終了時のログ出力を行う。HTTPアクセスログを出力するには、このハンドラをハンドラ構成に設定する必要がある。

> **設計上の注意**: リクエストパラメータを含めたリクエスト情報を出力することで、個別アプリケーションの証跡ログの要件を満たせる場合は、HTTPアクセスログと証跡ログを兼用することも想定している。

HTTPアクセスログはアプリケーションログに出力する。

| ログレベル | ロガー名 |
|---|---|
| INFO | HTTP_ACCESS |

**log.properties設定例:**
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

**app-log.properties設定例（beginFormat/endFormatのデフォルト値）:**
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

HTTPアクセスログ出力方針, ログレベル INFO, HTTP_ACCESS, log.properties, app-log.properties, JaxRsAccessLogFormatter, アプリケーションログ, jaxrs_access_log_handler, 証跡ログ, リクエストパラメータ

</details>

## HTTPアクセスログの設定

設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

**クラス**: `nablarch.fw.jaxrs.JaxRsAccessLogFormatter`

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| jaxRsAccessLogFormatter.className | — | `JaxRsAccessLogFormatter` を実装したクラス。差し替える場合に指定する |
| jaxRsAccessLogFormatter.beginFormat | `@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]\n\turl/method/port/client_ip/client_host` | リクエスト処理開始時のフォーマット |
| jaxRsAccessLogFormatter.endFormat | `@@@@ END @@@@ ... status_code/start_time/end_time/execution_time/max_memory/free_memory` | リクエスト処理終了時のフォーマット |
| jaxRsAccessLogFormatter.datePattern | `yyyy-MM-dd HH:mm:ss.SSS` | 開始日時・終了日時の日時パターン（`SimpleDateFormat` 構文） |
| jaxRsAccessLogFormatter.maskingPatterns | — | マスク対象パラメータ名・変数名（正規表現、カンマ区切り複数可、大文字小文字区別なし）。リクエストパラメータとセッションスコープ情報の両方に適用 |
| jaxRsAccessLogFormatter.maskingChar | `*` | マスクに使用する文字 |
| jaxRsAccessLogFormatter.bodyLogTargetMatcher | `nablarch.fw.jaxrs.JaxRsBodyLogTargetMatcher` | リクエスト・レスポンスボディを出力するか判定するクラス（`MessageBodyLogTargetMatcher` を実装） |
| jaxRsAccessLogFormatter.bodyMaskingFilter | `nablarch.fw.jaxrs.JaxRsBodyMaskingFilter` | リクエスト・レスポンスボディをマスク処理するクラス（`LogContentMaskingFilter` を実装） |
| jaxRsAccessLogFormatter.bodyMaskingItemNames | — | ボディマスク対象の項目名（カンマ区切り複数可） |
| jaxRsAccessLogFormatter.parametersSeparator | `\n\t\t` | リクエストパラメータのセパレータ |
| jaxRsAccessLogFormatter.sessionScopeSeparator | `\n\t\t` | セッションスコープ情報のセパレータ |
| jaxRsAccessLogFormatter.beginOutputEnabled | `true` | `false` を指定するとリクエスト処理開始時に出力しない |
| jaxRsAccessLogFormatter.endOutputEnabled | `true` | `false` を指定するとリクエスト処理終了時に出力しない |

**beginFormatに指定可能なプレースホルダ:**
`$requestId$`, `$userId$`, `$url$`, `$query$`, `$port$`, `$method$`, `$sessionId$`, `$sessionStoreId$`, `$parameters$`, `$sessionScope$`, `$clientIpAddress$`, `$clientHost$`, `$clientUserAgent$`, `$requestBody$`

**endFormatに指定可能なプレースホルダ:**
`$statusCode$`, `$startTime$`, `$endTime$`, `$executionTime$`, `$maxMemory$`, `$freeMemory$`, `$sessionStoreId$`, `$responseBody$`

> **補足**: `$parameters$` で出力されるリクエストパラメータにはリクエストボディが含まれない。リクエストボディを出力する場合は `$requestBody$` を使用する。

> **重要**: リクエストIDとユーザIDは `BasicLogFormatter` が出力する項目と重複するが、HTTPアクセスログのフォーマットの自由度を高めるために設けている。リクエストID、ユーザIDを出力する場合、取得元が `ThreadContext` なので、ハンドラ構成に [thread_context_handler](../handlers/handlers-thread_context_handler.md) が含まれている必要がある。ユーザIDについては [thread_context_handler-user_id_attribute_setting](../handlers/handlers-thread_context_handler.md) を参照してアプリケーションでセッションに値を設定する必要がある。

> **重要**: デフォルトの `JaxRsBodyMaskingFilter` はJSON形式のみサポートしている。

**記述例:**
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

JaxRsAccessLogFormatter, jaxRsAccessLogFormatter.className, jaxRsAccessLogFormatter.beginFormat, jaxRsAccessLogFormatter.endFormat, jaxRsAccessLogFormatter.datePattern, jaxRsAccessLogFormatter.maskingPatterns, jaxRsAccessLogFormatter.maskingChar, jaxRsAccessLogFormatter.bodyLogTargetMatcher, jaxRsAccessLogFormatter.bodyMaskingFilter, jaxRsAccessLogFormatter.bodyMaskingItemNames, jaxRsAccessLogFormatter.parametersSeparator, jaxRsAccessLogFormatter.sessionScopeSeparator, jaxRsAccessLogFormatter.beginOutputEnabled, jaxRsAccessLogFormatter.endOutputEnabled, HTTPアクセスログ設定, マスキング, リクエストボディログ, レスポンスボディログ, MessageBodyLogTargetMatcher, JaxRsBodyLogTargetMatcher, LogContentMaskingFilter, JaxRsBodyMaskingFilter, BasicLogFormatter, ThreadContext

</details>

## JSON形式の構造化ログとして出力する

HTTPアクセスログの各項目をJSON値として出力するには `JaxRsAccessJsonLogFormatter` を使用する（デフォルトの `JaxRsAccessLogFormatter` では各項目はmessageの値に文字列として出力される）。設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

**クラス**: `nablarch.fw.jaxrs.JaxRsAccessJsonLogFormatter`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| httpAccessLogFormatter.className | ○ | — | `nablarch.fw.jaxrs.JaxRsAccessJsonLogFormatter` を指定する |
| jaxRsAccessLogFormatter.beginTargets | | （後述のデフォルト参照） | リクエスト処理開始時のログ出力項目（カンマ区切り） |
| jaxRsAccessLogFormatter.endTargets | | （後述のデフォルト参照） | リクエスト処理終了時のログ出力項目（カンマ区切り） |
| jaxRsAccessLogFormatter.datePattern | | `yyyy-MM-dd HH:mm:ss.SSS` | 開始日時・終了日時の日時パターン（`SimpleDateFormat` 構文） |
| jaxRsAccessLogFormatter.maskingPatterns | | — | マスク対象パラメータ名・変数名を正規表現で指定する（部分一致）。カンマ区切り複数可、大文字小文字区別なし |
| jaxRsAccessLogFormatter.maskingChar | | `*` | マスクに使用する文字 |
| jaxRsAccessLogFormatter.beginOutputEnabled | | `true` | `false` を指定するとリクエスト処理開始時に出力しない |
| jaxRsAccessLogFormatter.endOutputEnabled | | `true` | `false` を指定するとリクエスト処理終了時に出力しない |
| jaxRsAccessLogFormatter.beginLabel | | `"HTTP ACCESS BEGIN"` | リクエスト処理開始時ログのlabelに出力する値 |
| jaxRsAccessLogFormatter.endLabel | | `"HTTP ACCESS END"` | リクエスト処理終了時ログのlabelに出力する値 |
| jaxRsAccessLogFormatter.structuredMessagePrefix | | `"$JSON$"` | JSON形式であることを識別するマーカー文字列。`JsonLogFormatter` に設定しているマーカー文字列と一致させる必要がある（LogWriterの `structuredMessagePrefix` プロパティも同じ値に設定すること。LogWriterのプロパティは [log-basic_setting](libraries-log.md) 参照）。 |

**beginTargetsに指定可能な出力項目（デフォルトで出力される項目に「デフォルト」と記載）:**
`label` デフォルト, `requestId` デフォルト, `userId` デフォルト, `sessionId` デフォルト, `sessionStoreId`, `url` デフォルト, `port` デフォルト, `method` デフォルト, `queryString`, `parameters`, `sessionScope`, `clientIpAddress` デフォルト, `clientHost` デフォルト, `clientUserAgent`, `requestBody`

**endTargetsに指定可能な出力項目（デフォルトで出力される項目に「デフォルト」と記載）:**
`label` デフォルト, `requestId` デフォルト, `userId` デフォルト, `sessionId` デフォルト, `sessionStoreId`, `url` デフォルト, `statusCode` デフォルト, `startTime` デフォルト, `endTime` デフォルト, `executionTime` デフォルト, `maxMemory` デフォルト, `freeMemory` デフォルト, `responseBody`

**記述例:**
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

JaxRsAccessJsonLogFormatter, JSON構造化ログ, jaxRsAccessLogFormatter.beginTargets, jaxRsAccessLogFormatter.endTargets, jaxRsAccessLogFormatter.datePattern, jaxRsAccessLogFormatter.maskingPatterns, jaxRsAccessLogFormatter.maskingChar, jaxRsAccessLogFormatter.beginOutputEnabled, jaxRsAccessLogFormatter.endOutputEnabled, jaxRsAccessLogFormatter.structuredMessagePrefix, jaxRsAccessLogFormatter.beginLabel, jaxRsAccessLogFormatter.endLabel, httpAccessLogFormatter.className, JsonLogFormatter

</details>

## セッションストアIDについて

セッションストアIDを出力に含めた場合、:ref:`session_store` が発行するセッションを識別するIDが出力される。

> **重要**: セッションストアIDは [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の往路で記録された値が使用される。セッションストアIDをログに出力する場合、[jaxrs_access_log_handler](../handlers/handlers-jaxrs_access_log_handler.md) は [session_store_handler](../handlers/handlers-SessionStoreHandler.md) より後に配置しなければならない。

セッションストアIDはリクエスト処理開始時の状態で固定されるため、以下の仕様となる:

- セッションストアIDが発行されていないリクエストでは、途中でIDが発行されたとしても、同一リクエスト内で出力されるセッションストアIDは全て空になる
- 途中で `セッションを破棄` したり `IDを変更` しても、ログに出力される値はリクエスト処理開始時のものから変化しない

<details>
<summary>keywords</summary>

セッションストアID, session_store_handler, jaxrs_access_log_handler, セッション識別ID, ハンドラ配置順序, SessionUtil

</details>
