# HTTPアクセスログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/http_access_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpAccessLogFormatter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpAccessJsonLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogFormatter.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html)

## HTTPアクセスログの出力方針

## 必要なハンドラ

HTTPアクセスログ出力には以下の3つのハンドラが必要:

- [http_access_log_handler](../handlers/handlers-http_access_log_handler.md): リクエスト処理開始時と終了時のログ出力
- [nablarch_tag_handler](../handlers/handlers-nablarch_tag_handler.md): hiddenパラメータ復号後のログ出力（:ref:`hidden暗号化<tag-hidden_encryption>` 参照）
- [http_request_java_package_mapping](../handlers/handlers-http_request_java_package_mapping.md): ディスパッチ先クラス決定後のログ出力

リクエストパラメータを含めたリクエスト情報を出力することで証跡ログの要件を満たせる場合、HTTPアクセスログと証跡ログを兼用可能。

## HTTPアクセスログの出力方針

アプリケーション全体のアプリケーションログに出力する。

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

**app-log.properties設定例:**

```properties
# HttpAccessLogFormatter
#httpAccessLogFormatter.className=
#httpAccessLogFormatter.datePattern=
#httpAccessLogFormatter.maskingChar=
#httpAccessLogFormatter.maskingPatterns=
#httpAccessLogFormatter.parametersSeparator=
#httpAccessLogFormatter.sessionScopeSeparator=
#httpAccessLogFormatter.beginOutputEnabled=
#httpAccessLogFormatter.parametersOutputEnabled=
#httpAccessLogFormatter.dispatchingClassOutputEnabled=
#httpAccessLogFormatter.endOutputEnabled=
httpAccessLogFormatter.beginFormat=@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]\
                                      \n\turl          = [$url$$query$]\
                                      \n\tmethod      = [$method$]\
                                      \n\tport        = [$port$]\
                                      \n\tclient_ip   = [$clientIpAddress$]\
                                      \n\tclient_host = [$clientHost$]
httpAccessLogFormatter.parametersFormat=@@@@ PARAMETERS @@@@\n\tparameters  = [$parameters$]
httpAccessLogFormatter.dispatchingClassFormat=@@@@ DISPATCHING CLASS @@@@ class = [$dispatchingClass$]
httpAccessLogFormatter.endFormat=@@@@ END @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$] url = [$url$$query$] method = [$method$] status_code = [$statusCode$] content_path = [$contentPath$]\
                                    \n\tstart_time     = [$startTime$]\
                                    \n\tend_time       = [$endTime$]\
                                    \n\texecution_time = [$executionTime$]\
                                    \n\tmax_memory     = [$maxMemory$]\
                                    \n\tfree_memory    = [$freeMemory$]
```

## HTTPアクセスログの設定（テキスト形式）

**クラス**: `nablarch.fw.web.handler.HttpAccessLogFormatter`

設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| httpAccessLogFormatter.className | | `HttpAccessLogFormatter` を実装したクラス。差し替える場合に指定する |
| httpAccessLogFormatter.beginFormat | (後述) | リクエスト処理開始時のログフォーマット |
| httpAccessLogFormatter.parametersFormat | (後述) | hiddenパラメータ復号後のログフォーマット |
| httpAccessLogFormatter.dispatchingClassFormat | (後述) | ディスパッチ先クラス決定後のログフォーマット |
| httpAccessLogFormatter.endFormat | (後述) | リクエスト処理終了時のログフォーマット |
| httpAccessLogFormatter.datePattern | `yyyy-MM-dd HH:mm:ss.SSS` | 開始・終了日時のパターン（SimpleDateFormat形式） |
| httpAccessLogFormatter.maskingPatterns | | マスク対象パラメータ名または変数名（正規表現・カンマ区切り・大文字小文字不区別）。例: `password` と指定すると `password` `newPassword` `password2` 等にマッチ |
| httpAccessLogFormatter.maskingChar | `*` | マスク文字 |
| httpAccessLogFormatter.parametersSeparator | `\n\t\t` | リクエストパラメータのセパレータ |
| httpAccessLogFormatter.sessionScopeSeparator | `\n\t\t` | セッションスコープ情報のセパレータ |
| httpAccessLogFormatter.beginOutputEnabled | `true` | リクエスト処理開始時の出力有無 |
| httpAccessLogFormatter.parametersOutputEnabled | `true` | hiddenパラメータ復号後の出力有無 |
| httpAccessLogFormatter.dispatchingClassOutputEnabled | `true` | ディスパッチ先クラス決定後の出力有無 |
| httpAccessLogFormatter.endOutputEnabled | `true` | リクエスト処理終了時の出力有無 |

**beginFormatのプレースホルダ**: `$requestId$`, `$userId$`, `$url$`, `$query$`, `$port$`, `$method$`, `$sessionId$`, `$sessionStoreId$`, `$parameters$`, `$sessionScope$`, `$clientIpAddress$`, `$clientHost$`, `$clientUserAgent$`

デフォルト:
```bash
@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]
    \n\turl         = [$url$]
    \n\tmethod      = [$method$]
    \n\tport        = [$port$]
    \n\tclient_ip   = [$clientIpAddress$]
    \n\tclient_host = [$clientHost$]
```

> **補足**: リクエストパラメータは :ref:`hidden暗号化<tag-hidden_encryption>` の復号前の状態となる。

> **重要**: リクエストIDとユーザIDは `BasicLogFormatter` が出力する項目と重複するが、HTTPアクセスログのフォーマットの自由度を高めるために設けている。これらは `ThreadContext` から取得するため、ハンドラ構成に [thread_context_handler](../handlers/handlers-thread_context_handler.md) が必要。ユーザIDは [thread_context_handler-user_id_attribute_setting](../handlers/handlers-thread_context_handler.md) を参照してセッションに値を設定すること。

**parametersFormatのプレースホルダ**: beginFormatと同じ。

デフォルト:
```bash
@@@@ PARAMETERS @@@@
    \n\tparameters  = [$parameters$]
```

**dispatchingClassFormatのプレースホルダ**: `$dispatchingClass$`, `$sessionStoreId$`

デフォルト:
```bash
@@@@ DISPATCHING CLASS @@@@ class = [$dispatchingClass$]
```

**endFormatのプレースホルダ**: `$dispatchingClass$`, `$statusCode$`, `$responseStatusCode$`, `$contentPath$`, `$startTime$`, `$endTime$`, `$executionTime$`, `$maxMemory$`, `$freeMemory$`, `$sessionStoreId$`

デフォルト:
```bash
@@@@ END @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$] url = [$url$] status_code = [$statusCode$] content_path = [$contentPath$]
    \n\tstart_time     = [$startTime$]
    \n\tend_time       = [$endTime$]
    \n\texecution_time = [$executionTime$]
    \n\tmax_memory     = [$maxMemory$]
    \n\tfree_memory    = [$freeMemory$]
```

> **補足**: ステータスコード(内部)は [http_access_log_handler](../handlers/handlers-http_access_log_handler.md) の復路時点のコード。ステータスコード(クライアント)は [http_response_handler](../handlers/handlers-http_response_handler.md) でクライアントに返却するコード（変換ルール: [http_response_handler-convert_status_code](../handlers/handlers-http_response_handler.md)）。ステータスコード(クライアント)はログ出力時点では確定していないが、 [http_response_handler](../handlers/handlers-http_response_handler.md) と同じ機能を使い導出して出力する。

> **重要**: ステータスコード(クライアント)は、HTTPアクセスログハンドラの処理後にJSPのエラー等のシステムエラーが発生した場合、実際の内部コードと異なることがある。障害監視ログが発生した際はこの値が正しくない可能性を考慮してログを検証すること。

設定例:
```properties
httpAccessLogFormatter.className=nablarch.fw.web.handler.HttpAccessLogFormatter
httpAccessLogFormatter.beginFormat=> sid = [$sessionId$] @@@@ BEGIN @@@@\n\turl = [$url$]\n\tmethod = [$method$]
httpAccessLogFormatter.parametersFormat=> sid = [$sessionId$] @@@@ PARAMETERS @@@@\n\tparameters  = [$parameters$]
httpAccessLogFormatter.dispatchingClassFormat=> sid = [$sessionId$] @@@@ DISPATCHING CLASS @@@@ class = [$dispatchingClass$]
httpAccessLogFormatter.endFormat=< sid = [$sessionId$] @@@@ END @@@@ url = [$url$] status_code = [$statusCode$] content_path = [$contentPath$]
httpAccessLogFormatter.datePattern="yyyy-MM-dd HH:mm:ss.SSS"
httpAccessLogFormatter.maskingChar=#
httpAccessLogFormatter.maskingPatterns=password,mobilePhoneNumber
httpAccessLogFormatter.parametersSeparator=,
httpAccessLogFormatter.sessionScopeSeparator=,
httpAccessLogFormatter.beginOutputEnabled=true
httpAccessLogFormatter.parametersOutputEnabled=true
httpAccessLogFormatter.dispatchingClassOutputEnabled=true
httpAccessLogFormatter.endOutputEnabled=true
```

<details>
<summary>keywords</summary>

HTTPアクセスログ, HttpAccessLogFormatter, HTTP_ACCESS, http_access_log_handler, nablarch_tag_handler, http_request_java_package_mapping, ログ出力設定, httpAccessLogFormatter.beginFormat, httpAccessLogFormatter.endFormat, httpAccessLogFormatter.maskingPatterns, 証跡ログ兼用, アクセスログ設定, FileLogWriter, BasicLogFormatter, nablarch.fw.web.handler.HttpAccessLogFormatter, nablarch.core.log.basic.BasicLogFormatter, ThreadContext, nablarch.core.ThreadContext, httpAccessLogFormatter.className, httpAccessLogFormatter.parametersFormat, httpAccessLogFormatter.dispatchingClassFormat, httpAccessLogFormatter.maskingChar, httpAccessLogFormatter.datePattern, httpAccessLogFormatter.parametersSeparator, httpAccessLogFormatter.sessionScopeSeparator, httpAccessLogFormatter.beginOutputEnabled, httpAccessLogFormatter.parametersOutputEnabled, httpAccessLogFormatter.dispatchingClassOutputEnabled, httpAccessLogFormatter.endOutputEnabled, HTTPアクセスログ設定, ログフォーマット設定, マスキング設定

</details>

## JSON形式の構造化ログとして出力する

## JSON形式の構造化ログとして出力する

**クラス**: `nablarch.fw.web.handler.HttpAccessJsonLogFormatter`

[log-json_log_setting](libraries-log.md) によりJSON出力する場合、デフォルトの `HttpAccessLogFormatter` ではHTTPアクセスログの各項目はmessageの値に文字列として出力される。各項目もJSONの値として出力するには `HttpAccessJsonLogFormatter` を使用する。設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| httpAccessLogFormatter.className | ○ | | `nablarch.fw.web.handler.HttpAccessJsonLogFormatter` を指定 |
| httpAccessLogFormatter.beginTargets | | (後述) | リクエスト処理開始時の出力項目（カンマ区切り） |
| httpAccessLogFormatter.parametersTargets | | `label,parameters` | hiddenパラメータ復号後の出力項目（カンマ区切り） |
| httpAccessLogFormatter.dispatchingClassTargets | | (後述) | ディスパッチ先クラス決定後の出力項目（カンマ区切り） |
| httpAccessLogFormatter.endTargets | | (後述) | リクエスト処理終了時の出力項目（カンマ区切り） |
| httpAccessLogFormatter.datePattern | | `yyyy-MM-dd HH:mm:ss.SSS` | 日時パターン（SimpleDateFormat形式） |
| httpAccessLogFormatter.maskingPatterns | | | マスク対象（正規表現・カンマ区切り・大文字小文字不区別） |
| httpAccessLogFormatter.maskingChar | | `*` | マスク文字 |
| httpAccessLogFormatter.beginOutputEnabled | | `true` | リクエスト処理開始時の出力有無 |
| httpAccessLogFormatter.parametersOutputEnabled | | `true` | hiddenパラメータ復号後の出力有無 |
| httpAccessLogFormatter.dispatchingClassOutputEnabled | | `true` | ディスパッチ先クラス決定後の出力有無 |
| httpAccessLogFormatter.endOutputEnabled | | `true` | リクエスト処理終了時の出力有無 |
| httpAccessLogFormatter.beginLabel | | `"HTTP ACCESS BEGIN"` | リクエスト処理開始時ログのlabel値 |
| httpAccessLogFormatter.parametersLabel | | `"PARAMETERS"` | hiddenパラメータ復号後ログのlabel値 |
| httpAccessLogFormatter.dispatchingClassLabel | | `"DISPATCHING CLASS"` | ディスパッチ先クラス決定後ログのlabel値 |
| httpAccessLogFormatter.endLabel | | `"HTTP ACCESS END"` | リクエスト処理終了時ログのlabel値 |
| httpAccessLogFormatter.structuredMessagePrefix | | `"$JSON$"` | JSONメッセージ識別マーカー文字列。 `JsonLogFormatter` の同プロパティと一致させること（[log-basic_setting](libraries-log.md) 参照） |

**beginTargetsの指定可能項目**: `label`（デフォルト）, `requestId`（デフォルト）, `userId`（デフォルト）, `sessionId`（デフォルト）, `url`（デフォルト）, `port`（デフォルト）, `method`（デフォルト）, `clientIpAddress`（デフォルト）, `clientHost`（デフォルト）, `sessionStoreId`, `queryString`, `parameters`, `sessionScope`, `clientUserAgent`

**dispatchingClassTargetsの指定可能項目**: `label`（デフォルト）, `dispatchingClass`（デフォルト）, `sessionId`, `sessionStoreId`

**endTargetsの指定可能項目**: `label`（デフォルト）, `requestId`（デフォルト）, `userId`（デフォルト）, `sessionId`（デフォルト）, `url`（デフォルト）, `statusCode`（デフォルト）, `contentPath`（デフォルト）, `startTime`（デフォルト）, `endTime`（デフォルト）, `executionTime`（デフォルト）, `maxMemory`（デフォルト）, `freeMemory`（デフォルト）, `sessionStoreId`, `dispatchingClass`, `responseStatusCode`

設定例:
```properties
httpAccessLogFormatter.className=nablarch.fw.web.handler.HttpAccessJsonLogFormatter
httpAccessLogFormatter.structuredMessagePrefix=$JSON$
httpAccessLogFormatter.beginTargets=sessionId,url,method
httpAccessLogFormatter.parametersTargets=sessionId,parameters
httpAccessLogFormatter.dispatchingClassTargets=sessionId,dispatchingClass
httpAccessLogFormatter.endTargets=sessionId,url,statusCode,contentPath
httpAccessLogFormatter.beginLabel=HTTP ACCESS BEGIN
httpAccessLogFormatter.parametersLabel=PARAMETERS
httpAccessLogFormatter.dispatchingClassLabel=DISPATCHING CLASS
httpAccessLogFormatter.endLabel=HTTP ACCESS END
```

<details>
<summary>keywords</summary>

HttpAccessJsonLogFormatter, nablarch.fw.web.handler.HttpAccessJsonLogFormatter, JsonLogFormatter, nablarch.core.log.basic.JsonLogFormatter, httpAccessLogFormatter.className, httpAccessLogFormatter.beginTargets, httpAccessLogFormatter.endTargets, httpAccessLogFormatter.structuredMessagePrefix, httpAccessLogFormatter.parametersTargets, httpAccessLogFormatter.dispatchingClassTargets, httpAccessLogFormatter.beginLabel, httpAccessLogFormatter.parametersLabel, httpAccessLogFormatter.dispatchingClassLabel, httpAccessLogFormatter.endLabel, JSON構造化ログ出力

</details>

## セッションストアIDについて

## セッションストアIDについて

セッションストアIDを出力に含めた場合、 :ref:`session_store` が発行するセッションを識別するIDが出力される。値は [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の往路で記録されたものを使用する。

> **重要**: セッションストアIDをログに出力する場合、 [http_access_log_handler](../handlers/handlers-http_access_log_handler.md) は [session_store_handler](../handlers/handlers-SessionStoreHandler.md) より後に配置しなければならない。

セッションストアIDはリクエスト処理開始時の状態で固定されるため:
- セッションストアIDが発行されていないリクエストでは、途中でIDが発行されても同一リクエスト内で出力されるセッションストアIDは全て空になる
- 途中で `セッションを破棄` または `IDを変更` しても、ログに出力される値はリクエスト処理開始時のものから変化しない

<details>
<summary>keywords</summary>

SessionUtil, nablarch.common.web.session.SessionUtil, セッションストアID, session_store, session_store_handler, http_access_log_handler

</details>
