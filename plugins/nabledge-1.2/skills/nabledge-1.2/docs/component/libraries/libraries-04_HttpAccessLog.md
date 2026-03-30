# HTTPアクセスログの出力

**公式ドキュメント**: [HTTPアクセスログの出力]()

## 

HTTPアクセスログは `HttpAccessLogHandler` を使用して出力する。ハンドラの設定でHTTPアクセスログを出力できる。

リクエストパラメータを含むリクエスト情報を出力することで、証跡ログの要件を満たせる場合はHTTPアクセスログと証跡ログを兼用可能。

:ref:`リクエスト処理開始時のプレースホルダ一覧<HttpAccessLog_BeginFormat>` のプレースホルダに加えて、以下を指定可能。リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号後の状態となる。

| 項目名 | プレースホルダ |
|---|---|
| ディスパッチ先クラス | $dispatchingClass$ |
| ステータスコード(内部) | $statusCode$ |
| ステータスコード(クライアント) | $responseStatusCode$ |
| コンテンツパス | $contentPath$ |
| 開始日時 | $startTime$ |
| 終了日時 | $endTime$ |
| 実行時間 | $executionTime$ |
| 最大メモリ量 | $maxMemory$ |
| 空きメモリ量(開始時) | $freeMemory$ |

デフォルトフォーマット:

```bash
@@@@ END @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$] url = [$url$] status_code = [$statusCode$] content_path = [$contentPath$]
    \n\tstart_time     = [$startTime$]
    \n\tend_time       = [$endTime$]
    \n\texecution_time = [$executionTime$]
    \n\tmax_memory     = [$maxMemory$]
    \n\tfree_memory    = [$freeMemory$]
```

## HTTPアクセスログの出力例

パラメータ名に `password` を含むリクエストパラメータは `maskingChar` で指定した文字にマスクして出力される。

app-log.properties:

```xml
httpAccessLogFormatter.maskingChar=#
httpAccessLogFormatter.maskingPatterns=\\.*password\\.*
```

log.properties:

```bash
writerNames=appFile
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=./app.log
writer.appFile.encoding=UTF-8
writer.appFile.maxFileSize=10000
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=$date$ -$logLevel$- $loggerName$ [$executionId$] $message$$information$$stackTrace$
availableLoggersNamesOrder=ACC
loggers.ACC.nameRegex=HTTP_ACCESS
loggers.ACC.level=INFO
loggers.ACC.writerNames=appFile
```

```bash
2011-03-03 19:35:47.848 -INFO- ACC [201103031935478480009] @@@@ BEGIN @@@@ rid = [USERS00302] uid = [0000000001] sid = [60174985E7D35DB7B80681107098C426]
    url         = [http://localhost:8090/action/management/user/UserRegisterAction/USERS00302]
    method      = [POST]
    port        = [8090]
    client_ip   = [127.0.0.1]
    client_host = [127.0.0.1]
2011-03-03 19:35:47.848 -INFO- ACC [201103031935478480009] @@@@ PARAMETERS @@@@
    parameters  = [{
        users.extensionNumberBuilding = [12],
        ugroupSystemAccount.ugroupId = [0000000000],
        users.mailAddress = [yamada@sample.co.jp],
        systemAccount.loginId = [U03021934],
        users.mobilePhoneNumberAreaCode = [090],
        users.extensionNumberPersonal = [3456],
        users.kanjiName = [山田太郎],
        systemAccount.confirmPassword = [########],
        systemAccount.useCase = [UC00000000, UC00000001, UC00000002],
        users.mobilePhoneNumberCityCode = [1234],
        nablarch_token = [UmNDw+Z2nuTQPwsZ],
        users.kanaName = [ヤマダタロウ],
        systemAccount.newPassword = [########],
        users.mobilePhoneNumberSbscrCode = [5678]}]
2011-03-03 19:35:47.848 -INFO- ACC [201103031935478480009] @@@@ DISPATCHING CLASS @@@@ class = [nablarch.sample.management.user.UserRegisterAction]
2011-03-03 19:35:48.362 -INFO- ACC [201103031935478480009] @@@@ END @@@@ rid = [USERS00302] uid = [0000000001] sid = [60174985E7D35DB7B80681107098C426] url = [http://localhost:8090/action/management/user/UserRegisterAction/USERS00302] status_code = [200] content_path = [/management/user/USER-004.jsp]
    start_time     = [2011-03-03 19:35:47.848]
    end_time       = [2011-03-03 19:35:48.362]
    execution_time = [514]
    max_memory     = [66650112]
    free_memory    = [53128512]
```

<details>
<summary>keywords</summary>

HTTPアクセスログ, アクセスログ出力, 証跡ログ兼用, HttpAccessLogHandler, HTTPアクセスログ終了フォーマット, プレースホルダ, マスキング設定, ログ出力例, リクエスト処理終了, $dispatchingClass$, $statusCode$, $responseStatusCode$, $contentPath$, $startTime$, $endTime$, $executionTime$, $maxMemory$, $freeMemory$, maskingChar, maskingPatterns, FileLogWriter, BasicLogFormatter

</details>

## HTTPアクセスログの出力

## 出力方針

| ログレベル | ロガー名 |
|---|---|
| INFO | HTTP_ACCESS |

log.propertiesの設定例:

```bash
writerNames=appFile
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=/var/log/app/app.log
writer.appFile.encoding=UTF-8
writer.appFile.maxFileSize=10000
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=<アプリケーションログ用のフォーマット>

availableLoggersNamesOrder=ACC,ROO

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appFile

loggers.ACC.nameRegex=HTTP_ACCESS
loggers.ACC.level=INFO
loggers.ACC.writerNames=appFile
```

## 出力項目

| 項目名 | 説明 |
|---|---|
| 出力日時 | ログ出力時のシステム日時 |
| 起動プロセスID | アプリケーションを起動したプロセス名。実行環境の特定に使用 |
| 処理方式区分 | 処理方式の特定に使用 |
| リクエストID | 処理を一意に識別するID |
| 実行時ID | 処理の実行を一意に識別するID |
| ユーザID | ログインユーザのユーザID |
| URL | リクエストURL |
| ポート番号 | リクエストを受信したサーバの使用ポート |
| HTTPメソッド | リクエストの種類（GET、POSTなど） |
| セッションID | HTTPセッションのセッションID |
| セッションスコープ情報 | セッションスコープ情報のダンプ。個人情報・機密情報はマスク出力（マスク用設定が必要） |
| ディスパッチ先クラス | リクエストのディスパッチ先のクラス名 |
| リクエストパラメータ | リクエストパラメータのダンプ。個人情報・機密情報はマスク出力（マスク用設定が必要） |
| クライアント端末IPアドレス | リクエストを送信したクライアントのIPアドレス |
| クライアント端末ホスト | リクエストを送信したクライアントのホスト名 |
| ステータスコード(内部) | :ref:`http_response_handler_response_code_conversion` のHTTPレスポンスハンドラによるステータスコード変換前のコード |
| ステータスコード(クライアント) | :ref:`http_response_handler_response_code_conversion` のHTTPレスポンスハンドラによるステータスコード変換後のコード |
| コンテンツパス | レスポンスのコンテンツパス |
| 開始日時 | 処理の開始日時 |
| 終了日時 | 処理の終了日時 |
| 実行時間 | 処理の実行時間（終了日時－開始日時） |
| 最大メモリ量(開始時) | 処理の開始時点のヒープサイズ |
| 空きメモリ量(開始時) | 処理の開始時点の空きヒープサイズ |
| 付加情報 | アプリケーションで追加する付加情報 |

個別項目: リクエストIDからユーザID・URLから空きメモリ量(開始時)まで。残りは :ref:`Log_BasicLogFormatter` の設定で指定する共通項目。リクエストIDとユーザIDは共通項目と重複するが、フォーマットの自由度のために個別項目としても指定可能。

> **注意**: :ref:`http_response_handler` のフォワード処理で `servlet://` が指定された場合、フォワード先のサーブレットで200以外のステータスコードを返却した際も、アクセスログには200が出力される。JavaEE 5の仕様制約による。

> **警告**: ステータスコード(クライアント)は、HTTPアクセスログハンドラ処理後にJSPのエラーなどシステムエラーが発生した場合、実際の内部コードと異なることがある。障害監視ログが発生した際はこの値が正しくない可能性を考慮すること。

## 出力方法

**クラス**:
- `nablarch.common.web.handler.HttpAccessLogHandler`: HTTPアクセスログを出力するハンドラ。リクエスト処理開始時と終了時のログを出力
- `nablarch.common.web.handler.NablarchTagHandler`: Nablarchカスタムタグ機能のリクエスト処理ハンドラ。:ref:`WebView_HiddenEncryption` の改竄チェック・復号後のログを出力
- `nablarch.fw.web.handler.HttpRequestJavaPackageMapping`: URIをJavaパッケージへマッピングするディスパッチャ。ディスパッチ先クラス決定後のログを出力
- `nablarch.fw.web.handler.HttpAccessLogUtil`: HTTPアクセスログを出力するクラス
- `nablarch.fw.web.handler.HttpAccessLogFormatter`: HTTPアクセスログの個別項目をフォーマットするクラス

ログ出力の処理順序:
1. HttpAccessLogHandlerがHttpAccessLogUtilを使用してBEGINログを出力
2. NablarchTagHandlerがHttpAccessLogUtilを使用してPARAMETERSログを出力（hiddenパラメータ復号後）
3. HttpRequestJavaPackageMappingがHttpAccessLogUtilを使用してDISPATCHING CLASSログを出力
4. HttpAccessLogHandlerがHttpAccessLogUtilを使用してENDログを出力

ハンドラキューの設定順序（この順番でなければならない）:

```
ThreadContextHandler
↓
HttpAccessLogHandler
↓
NablarchTagHandler
↓
HttpRequestJavaPackageMapping
```

NablarchTagHandlerとHttpRequestJavaPackageMappingの間には、:ref:`CommonHandlers` のハンドラ（DB接続管理、トランザクション管理、認可チェックなど）が入る。

HttpAccessLogHandlerはプロパティを持たないため設定項目不要。ハンドラキューへの設定例:

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
    <property name="handlerQueue">
        <list>
            <component name="nablarchTagHandler" class="nablarch.common.web.handler.HttpAccessLogHandler" />
        </list>
    </property>
</component>
```

## 設定方法

`HttpAccessLogUtil` はapp-log.propertiesを読み込み、`HttpAccessLogFormatter` オブジェクトを生成して個別項目のフォーマットを委譲する。プロパティファイルのパス指定や設定値の変更は :ref:`AppLog_Config` を参照。

app-log.propertiesの設定例:

```bash
httpAccessLogFormatter.className=nablarch.fw.web.handler.HttpAccessLogFormatter
httpAccessLogFormatter.beginFormat=> sid = [$sessionId$] @@@@ BEGIN @@@@\n\turl = [$url$]\n\tmethod = [$method$]
httpAccessLogFormatter.parametersFormat=> sid = [$sessionId$] @@@@ PARAMETERS @@@@\n\tparameters  = [$parameters$]
httpAccessLogFormatter.dispatchingClassFormat=> sid = [$sessionId$] @@@@ DISPATCHING CLASS @@@@ class = [$dispatchingClass$]
httpAccessLogFormatter.endFormat=< sid = [$sessionId$] @@@@ END @@@@ url = [$url$] status_code = [$statusCode$] content_path = [$contentPath$]
httpAccessLogFormatter.datePattern="yyyy-MM-dd HH:mm:ss.SSS"
httpAccessLogFormatter.maskingChar=#
httpAccessLogFormatter.maskingPatterns=\\.*password\\.*,\\.*mobilePhoneNumber\\.*
httpAccessLogFormatter.parametersSeparator=,
httpAccessLogFormatter.sessionScopeSeparator=,
httpAccessLogFormatter.beginOutputEnabled=true
httpAccessLogFormatter.parametersOutputEnabled=true
httpAccessLogFormatter.dispatchingClassOutputEnabled=true
httpAccessLogFormatter.endOutputEnabled=true
```

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| httpAccessLogFormatter.className | | HttpAccessLogFormatterのクラス名。差し替える場合に指定 |
| httpAccessLogFormatter.beginFormat | | リクエスト処理開始時のログフォーマット |
| httpAccessLogFormatter.parametersFormat | | hiddenパラメータ復号後のログフォーマット |
| httpAccessLogFormatter.dispatchingClassFormat | | ディスパッチ先クラス決定後のログフォーマット |
| httpAccessLogFormatter.endFormat | | リクエスト処理終了時のログフォーマット |
| httpAccessLogFormatter.datePattern | `yyyy-MM-dd HH:mm:ss.SSS` | 開始日時・終了日時のパターン（java.text.SimpleDateFormat構文） |
| httpAccessLogFormatter.maskingPatterns | | マスク対象のパラメータ名・変数名（正規表現、カンマ区切り複数指定可）。リクエストパラメータとセッションスコープ情報の両方に適用。Pattern.CASE_INSENSITIVEでコンパイル |
| httpAccessLogFormatter.maskingChar | `*` | マスクに使用する文字 |
| httpAccessLogFormatter.parametersSeparator | `\n\t\t` | リクエストパラメータのセパレータ |
| httpAccessLogFormatter.sessionScopeSeparator | `\n\t\t` | セッションスコープ情報のセパレータ |
| httpAccessLogFormatter.beginOutputEnabled | `true` | リクエスト処理開始時の出力有無。falseで出力しない |
| httpAccessLogFormatter.parametersOutputEnabled | `true` | hiddenパラメータ復号後の出力有無。falseで出力しない |
| httpAccessLogFormatter.dispatchingClassOutputEnabled | `true` | ディスパッチ先クラス決定後の出力有無。falseで出力しない |
| httpAccessLogFormatter.endOutputEnabled | `true` | リクエスト処理終了時の出力有無。falseで出力しない |

<details>
<summary>keywords</summary>

HTTP_ACCESS, ログレベルINFO, 出力項目, ステータスコード, HttpAccessLogHandler, NablarchTagHandler, HttpRequestJavaPackageMapping, HttpAccessLogUtil, HttpAccessLogFormatter, ThreadContextHandler, httpAccessLogFormatter.className, httpAccessLogFormatter.beginFormat, httpAccessLogFormatter.parametersFormat, httpAccessLogFormatter.dispatchingClassFormat, httpAccessLogFormatter.endFormat, httpAccessLogFormatter.maskingPatterns, httpAccessLogFormatter.maskingChar, httpAccessLogFormatter.datePattern, httpAccessLogFormatter.parametersSeparator, httpAccessLogFormatter.sessionScopeSeparator, httpAccessLogFormatter.beginOutputEnabled, httpAccessLogFormatter.parametersOutputEnabled, httpAccessLogFormatter.dispatchingClassOutputEnabled, httpAccessLogFormatter.endOutputEnabled, アクセスログ出力方針, ハンドラキュー設定, app-log.properties

</details>

## リクエスト処理開始時のログ出力に使用するフォーマット

プレースホルダ一覧:

| 項目名 | プレースホルダ |
|---|---|
| リクエストID | `$requestId$` |
| ユーザID | `$userId$` |
| URL | `$url$` |
| ポート番号 | `$port$` |
| HTTPメソッド | `$method$` |
| セッションID | `$sessionId$` |
| リクエストパラメータ | `$parameters$` |
| セッションスコープ情報 | `$sessionScope$` |
| クライアント端末IPアドレス | `$clientIpAddress$` |
| クライアント端末ホスト | `$clientHost$` |
| HTTPヘッダのUser-Agent | `$clientUserAgent$` |

リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号前の状態。

デフォルトフォーマット:

```bash
@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]
    \n\turl         = [$url$]
    \n\tmethod      = [$method$]
    \n\tport        = [$port$]
    \n\tclient_ip   = [$clientIpAddress$]
    \n\tclient_host = [$clientHost$]
    \n\tparameters  = [$parameters$]
```

<details>
<summary>keywords</summary>

$requestId$, $userId$, $url$, $port$, $method$, $sessionId$, $parameters$, $sessionScope$, $clientIpAddress$, $clientHost$, $clientUserAgent$, beginFormat, リクエスト処理開始, プレースホルダ

</details>

## hiddenパラメータ復号後のログ出力に使用するフォーマット

プレースホルダ一覧は :ref:`リクエスト処理開始時のプレースホルダ一覧<HttpAccessLog_BeginFormat>` と同じ。リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号後の状態。

デフォルトフォーマット:

```bash
@@@@ PARAMETERS @@@@
    \n\tparameters  = [$parameters$]
```

<details>
<summary>keywords</summary>

parametersFormat, hiddenパラメータ復号, WebView_HiddenEncryption, 復号後パラメータ, プレースホルダ

</details>

## ディスパッチ先クラス決定後のログ出力に使用するフォーマット

:ref:`リクエスト処理開始時のプレースホルダ一覧<HttpAccessLog_BeginFormat>` に加えて、以下のプレースホルダを指定可能。リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号後の状態。

| 項目名 | プレースホルダ |
|---|---|
| ディスパッチ先クラス | `$dispatchingClass$` |

デフォルトフォーマット:

```bash
@@@@ DISPATCHING CLASS @@@@ class = [$dispatchingClass$]
```

<details>
<summary>keywords</summary>

$dispatchingClass$, dispatchingClassFormat, ディスパッチ先クラス, プレースホルダ

</details>
