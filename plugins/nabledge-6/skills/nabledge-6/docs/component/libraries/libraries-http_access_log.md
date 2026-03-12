# HTTPアクセスログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/http_access_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpAccessLogFormatter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpAccessJsonLogFormatter.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html)

## HTTPアクセスログの出力方針

HTTPアクセスログの出力に必要なハンドラ:
- [http_access_log_handler](../handlers/handlers-http_access_log_handler.md): リクエスト処理開始時と終了時のログ出力
- [nablarch_tag_handler](../handlers/handlers-nablarch_tag_handler.md): hiddenパラメータ復号後のログ出力（:ref:`hidden暗号化<tag-hidden_encryption>` 参照）
- [http_request_java_package_mapping](../handlers/handlers-http_request_java_package_mapping.md): ディスパッチ先クラス決定後のログ出力

リクエストパラメータを含むリクエスト情報を出力することで証跡ログの要件を満たせる場合は、HTTPアクセスログと証跡ログを兼用できる。

**出力方針**:

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

設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

**クラス**: `HttpAccessLogFormatter`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| httpAccessLogFormatter.className | | | HttpAccessLogFormatterを実装したクラス（差し替え時に指定） |
| httpAccessLogFormatter.beginFormat | | 下記参照 | リクエスト処理開始時のログフォーマット |
| httpAccessLogFormatter.parametersFormat | | 下記参照 | hiddenパラメータ復号後のログフォーマット |
| httpAccessLogFormatter.dispatchingClassFormat | | 下記参照 | ディスパッチ先クラス決定後のログフォーマット |
| httpAccessLogFormatter.endFormat | | 下記参照 | リクエスト処理終了時のログフォーマット |
| httpAccessLogFormatter.datePattern | | `yyyy-MM-dd HH:mm:ss.SSS` | 開始日時・終了日時のパターン（SimpleDateFormat構文） |
| httpAccessLogFormatter.maskingPatterns | | | マスク対象パラメータ名・変数名の正規表現（カンマ区切り、大文字小文字区別なし）。リクエストパラメータとセッションスコープ情報の両方に適用。例: `password` と指定すると `password`, `newPassword`, `password2` 等にマッチする |
| httpAccessLogFormatter.maskingChar | | `*` | マスクに使用する文字 |
| httpAccessLogFormatter.parametersSeparator | | `\n\t\t` | リクエストパラメータのセパレータ |
| httpAccessLogFormatter.sessionScopeSeparator | | `\n\t\t` | セッションスコープ情報のセパレータ |
| httpAccessLogFormatter.beginOutputEnabled | | `true` | リクエスト処理開始時の出力有効/無効 |
| httpAccessLogFormatter.parametersOutputEnabled | | `true` | hiddenパラメータ復号後の出力有効/無効 |
| httpAccessLogFormatter.dispatchingClassOutputEnabled | | `true` | ディスパッチ先クラス決定後の出力有効/無効 |
| httpAccessLogFormatter.endOutputEnabled | | `true` | リクエスト処理終了時の出力有効/無効 |

**beginFormatのプレースホルダ**: `$requestId$`, `$userId$`, `$url$`, `$query$`, `$port$`, `$method$`, `$sessionId$`, `$sessionStoreId$`, `$parameters$`, `$sessionScope$`, `$clientIpAddress$`, `$clientHost$`, `$clientUserAgent$`

beginFormatデフォルト値:
```bash
@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]
    \n\turl         = [$url$]
    \n\tmethod      = [$method$]
    \n\tport        = [$port$]
    \n\tclient_ip   = [$clientIpAddress$]
    \n\tclient_host = [$clientHost$]
```

> **補足**: リクエストパラメータは :ref:`hidden暗号化<tag-hidden_encryption>` の復号前の状態となる。

> **重要**: リクエストIDとユーザIDは、`BasicLogFormatter` が出力する項目と重複するが、HTTPアクセスログのフォーマットの自由度を高めるために設けている。リクエストID、ユーザIDの取得元は `ThreadContext` のため、ハンドラ構成に [thread_context_handler](../handlers/handlers-thread_context_handler.md) が含まれている必要がある。ユーザIDは [thread_context_handler-user_id_attribute_setting](../handlers/handlers-thread_context_handler.md) を参照してセッションに値を設定すること。

**parametersFormatのデフォルト値**:
```bash
@@@@ PARAMETERS @@@@
    \n\tparameters  = [$parameters$]
```

**dispatchingClassFormatのプレースホルダ**: `$dispatchingClass$`, `$sessionStoreId$`

dispatchingClassFormatデフォルト値:
```bash
@@@@ DISPATCHING CLASS @@@@ class = [$dispatchingClass$]
```

**endFormatのプレースホルダ**: `$dispatchingClass$`, `$statusCode$`, `$responseStatusCode$`, `$contentPath$`, `$startTime$`, `$endTime$`, `$executionTime$`, `$maxMemory$`, `$freeMemory$`, `$sessionStoreId$`

endFormatデフォルト値:
```bash
@@@@ END @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$] url = [$url$] status_code = [$statusCode$] content_path = [$contentPath$]
    \n\tstart_time     = [$startTime$]
    \n\tend_time       = [$endTime$]
    \n\texecution_time = [$executionTime$]
    \n\tmax_memory     = [$maxMemory$]
    \n\tfree_memory    = [$freeMemory$]
```

> **補足**: ステータスコード(内部)は [http_access_log_handler](../handlers/handlers-http_access_log_handler.md) の復路時点のコード。ステータスコード(クライアント)は [http_response_handler](../handlers/handlers-http_response_handler.md) でクライアントに返却するコード。ステータスコード(クライアント)はログ出力時点では未確定だが [http_response_handler](../handlers/handlers-http_response_handler.md) と同じ機能で導出する。変換ルールは [http_response_handler-convert_status_code](../handlers/handlers-http_response_handler.md) 参照。

> **重要**: ステータスコード(クライアント)は、HTTPアクセスログハンドラ処理後にJSPエラー等のシステムエラーが発生した場合、実際の内部コードと異なることがある。障害監視ログが発生した際はこの値が正しくない可能性を考慮してログを検証すること。

記述例:
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

HTTPアクセスログ, HttpAccessLogFormatter, HTTP_ACCESS, http_access_log_handler, ログ出力設定, 証跡ログ, beginFormat, endFormat, parametersFormat, dispatchingClassFormat, FileLogWriter, BasicLogFormatter, nablarch_tag_handler, http_request_java_package_mapping, SimpleDateFormat, httpAccessLogFormatter.className, httpAccessLogFormatter.beginFormat, httpAccessLogFormatter.endFormat, httpAccessLogFormatter.parametersFormat, httpAccessLogFormatter.dispatchingClassFormat, httpAccessLogFormatter.maskingPatterns, httpAccessLogFormatter.maskingChar, httpAccessLogFormatter.datePattern, httpAccessLogFormatter.parametersSeparator, httpAccessLogFormatter.sessionScopeSeparator, httpAccessLogFormatter.beginOutputEnabled, httpAccessLogFormatter.parametersOutputEnabled, httpAccessLogFormatter.dispatchingClassOutputEnabled, httpAccessLogFormatter.endOutputEnabled, ThreadContext, HTTPアクセスログ設定, アクセスログフォーマット, リクエストパラメータマスキング, ログ出力有効無効制御

</details>

## JSON形式の構造化ログとして出力する

[log-json_log_setting](libraries-log.md) でJSON形式のログ出力が可能だが、`HttpAccessLogFormatter` ではHTTPアクセスログ各項目はmessageに文字列として出力される。各項目もJSONの値として出力するには `HttpAccessJsonLogFormatter` を使用する。設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| httpAccessLogFormatter.className | ○ | | `nablarch.fw.web.handler.HttpAccessJsonLogFormatter` を指定 |
| httpAccessLogFormatter.beginTargets | | 下記参照 | リクエスト処理開始時の出力項目（カンマ区切り） |
| httpAccessLogFormatter.parametersTargets | | `label,parameters` | hiddenパラメータ復号後の出力項目（カンマ区切り） |
| httpAccessLogFormatter.dispatchingClassTargets | | 下記参照 | ディスパッチ先クラス決定後の出力項目（カンマ区切り） |
| httpAccessLogFormatter.endTargets | | 下記参照 | リクエスト処理終了時の出力項目（カンマ区切り） |
| httpAccessLogFormatter.datePattern | | `yyyy-MM-dd HH:mm:ss.SSS` | 開始日時・終了日時のパターン（SimpleDateFormat構文） |
| httpAccessLogFormatter.maskingPatterns | | | マスク対象パラメータ名・変数名の正規表現（カンマ区切り、大文字小文字区別なし、部分一致）。リクエストパラメータとセッションスコープ情報の両方に適用。例: `password` と指定すると `password`, `newPassword`, `password2` 等にマッチする |
| httpAccessLogFormatter.maskingChar | | `*` | マスクに使用する文字 |
| httpAccessLogFormatter.beginOutputEnabled | | `true` | リクエスト処理開始時の出力有効/無効 |
| httpAccessLogFormatter.parametersOutputEnabled | | `true` | hiddenパラメータ復号後の出力有効/無効 |
| httpAccessLogFormatter.dispatchingClassOutputEnabled | | `true` | ディスパッチ先クラス決定後の出力有効/無効 |
| httpAccessLogFormatter.endOutputEnabled | | `true` | リクエスト処理終了時の出力有効/無効 |
| httpAccessLogFormatter.beginLabel | | `"HTTP ACCESS BEGIN"` | リクエスト処理開始時ログのlabel値 |
| httpAccessLogFormatter.parametersLabel | | `"PARAMETERS"` | hiddenパラメータ復号後ログのlabel値 |
| httpAccessLogFormatter.dispatchingClassLabel | | `"DISPATCHING CLASS"` | ディスパッチ先クラス決定後ログのlabel値 |
| httpAccessLogFormatter.endLabel | | `"HTTP ACCESS END"` | リクエスト処理終了時ログのlabel値 |
| httpAccessLogFormatter.structuredMessagePrefix | | `"$JSON$"` | JSON形式であることを識別するメッセージ先頭マーカー。変更する場合は、LogWriterの `structuredMessagePrefix` プロパティを使用して `JsonLogFormatter` にも同じ値を設定すること（LogWriterのプロパティについては [log-basic_setting](libraries-log.md) を参照） |

**beginTargetsの指定可能項目**（デフォルト: `label`, `requestId`, `userId`, `sessionId`, `url`, `port`, `method`, `clientIpAddress`, `clientHost`）:
`label`, `requestId`, `userId`, `sessionId`, `sessionStoreId`, `url`, `port`, `method`, `queryString`, `parameters`, `sessionScope`, `clientIpAddress`, `clientHost`, `clientUserAgent`

**dispatchingClassTargetsの指定可能項目**（デフォルト: `label`, `dispatchingClass`）:
`label`, `sessionId`, `sessionStoreId`, `dispatchingClass`

**endTargetsの指定可能項目**（デフォルト: `label`, `requestId`, `userId`, `sessionId`, `url`, `statusCode`, `contentPath`, `startTime`, `endTime`, `executionTime`, `maxMemory`, `freeMemory`）:
`label`, `requestId`, `userId`, `sessionId`, `sessionStoreId`, `url`, `dispatchingClass`, `statusCode`, `responseStatusCode`, `contentPath`, `startTime`, `endTime`, `executionTime`, `maxMemory`, `freeMemory`

記述例:
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

HttpAccessJsonLogFormatter, JsonLogFormatter, SimpleDateFormat, httpAccessLogFormatter.beginTargets, httpAccessLogFormatter.parametersTargets, httpAccessLogFormatter.dispatchingClassTargets, httpAccessLogFormatter.endTargets, httpAccessLogFormatter.structuredMessagePrefix, httpAccessLogFormatter.beginLabel, httpAccessLogFormatter.parametersLabel, httpAccessLogFormatter.dispatchingClassLabel, httpAccessLogFormatter.endLabel, httpAccessLogFormatter.datePattern, httpAccessLogFormatter.maskingPatterns, httpAccessLogFormatter.maskingChar, httpAccessLogFormatter.beginOutputEnabled, httpAccessLogFormatter.parametersOutputEnabled, httpAccessLogFormatter.dispatchingClassOutputEnabled, httpAccessLogFormatter.endOutputEnabled, JSON構造化ログ, HTTPアクセスログJSON出力, ログ出力項目設定

</details>

## セッションストアIDについて

セッションストアIDを出力に含めた場合、:ref:`session_store` が発行するセッション識別IDが出力される。この値は [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の往路で記録されたものが使用される。

> **重要**: セッションストアIDをログに出力する場合、[http_access_log_handler](../handlers/handlers-http_access_log_handler.md) は [session_store_handler](../handlers/handlers-SessionStoreHandler.md) より後に配置しなければならない。

セッションストアIDはリクエスト処理開始時の状態で固定されるため、以下の仕様になる:

- セッションストアIDが発行されていないリクエストでは、途中でIDが発行されても、同一リクエスト内で出力されるセッションストアIDは全て空になる
- `セッションを破棄` したり `IDを変更` しても、ログに出力される値はリクエスト処理開始時から変化しない

<details>
<summary>keywords</summary>

SessionUtil, セッションストアID, ハンドラ配置順序, session_store_handler, http_access_log_handler, セッション識別ID, セッション破棄

</details>
