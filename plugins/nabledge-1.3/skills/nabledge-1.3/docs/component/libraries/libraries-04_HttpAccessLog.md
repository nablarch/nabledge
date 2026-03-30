# HTTPアクセスログの出力

## HTTPアクセスログの出力

## HTTPアクセスログの出力

HTTPアクセスログは、フレームワークが提供するハンドラを使用して出力する。アプリケーションでは、ハンドラの設定を行うことでHTTPアクセスログを出力する。

リクエストパラメータを含めたリクエスト情報を出力することで、個別アプリケーションの証跡ログの要件を満たせる場合は、HTTPアクセスログと証跡ログを兼用することも想定している。

## HTTPアクセスログの出力方針

- ログレベル: INFO、ロガー名: HTTP_ACCESS

log.properties設定例:
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

## HTTPアクセスログの出力項目

| 項目名 | 説明 |
|---|---|
| 出力日時 | ログ出力時のシステム日時 |
| 起動プロセスID | アプリケーションを起動したプロセス名。実行環境の特定に使用する |
| 処理方式区分 | 処理方式の特定に使用する |
| リクエストID | 処理を一意に識別するID |
| ユーザID | ログインユーザのユーザID |
| URL | リクエストURL |
| ポート番号 | リクエストを受信したサーバの使用ポート |
| HTTPメソッド | リクエストの種類（GET、POSTなど）|
| セッションID | HTTPセッションのセッションID |
| セッションスコープ情報 | セッションスコープ情報のダンプ。個人情報・機密情報はマスクして出力（マスク設定が必要）|
| ディスパッチ先クラス | リクエストのディスパッチ先のクラス名 |
| リクエストパラメータ | リクエストパラメータのダンプ。個人情報・機密情報はマスクして出力（マスク設定が必要）|
| クライアント端末IPアドレス | リクエストを送信したクライアントのIPアドレス |
| クライアント端末ホスト | リクエストを送信したクライアントのホスト名 |
| ステータスコード(内部) | :ref:`http_response_handler_response_code_conversion` によるステータスコード変換前のコード |
| ステータスコード(クライアント) | :ref:`http_response_handler_response_code_conversion` によるステータスコード変換後のコード |
| コンテンツパス | レスポンスのコンテンツパス |
| 開始日時 | 処理の開始日時 |
| 終了日時 | 処理の終了日時 |
| 実行時間 | 処理の実行時間（終了日時－開始日時）|
| 最大メモリ量(開始時) | 処理の開始時点のヒープサイズ |
| 空きメモリ量(開始時) | 処理の開始時点の空きヒープサイズ |
| 付加情報 | アプリケーションで追加する付加情報 |

**個別項目と共通項目の区別:**

- **個別項目**（HttpAccessLogFormatterで指定）: リクエストID、ユーザID、URLから空きメモリ量(開始時)まで
- **共通項目**（BasicLogFormatterで指定）: 出力日時、起動プロセスID、処理方式区分、付加情報

リクエストIDとユーザIDはBasicLogFormatterが出力を提供する共通項目と重複するが、HTTPアクセスログのフォーマットの自由度を高めるために個別項目として指定できるようにしている。共通項目と個別項目を組み合わせたフォーマットについては :ref:`AppLog_Format` を参照。

> **注意**: ステータスコード(内部): :ref:`http_response_handler` のフォワード処理でコンテンツパスに "servlet://" が指定された場合、フォワード先のサーブレットで200以外のステータスコードを返却した際もアクセスログには 200 が出力される。これは JavaEE 5 の仕様上フォワード先のサーブレットの処理結果を取得できない制約による。

> **警告**: ステータスコード(クライアント)の値は、HTTPアクセスログハンドラの処理の後にJSPのエラーなどシステムエラーが発生した場合、実際の内部コードと異なることがある。障害監視ログが発生した際にはこの値が正しくない可能性があることを考慮してログを検証すること。

## HTTPアクセスログの出力方法

関連クラス:
- **クラス**: `nablarch.common.web.handler.HttpAccessLogHandler` — リクエスト処理開始時と終了時のログ出力
- **クラス**: `nablarch.common.web.handler.NablarchTagHandler` — :ref:`WebView_HiddenEncryption` 機能の改竄チェック・復号処理。hiddenパラメータ復号後のログを出力
- **クラス**: `nablarch.fw.web.handler.HttpRequestJavaPackageMapping` — URI中の部分文字列をJavaパッケージへマッピングするディスパッチャ。ディスパッチ先クラス決定後のログを出力
- **クラス**: `nablarch.fw.web.handler.HttpAccessLogUtil` — HTTPアクセスログを出力するクラス
- **クラス**: `nablarch.fw.web.handler.HttpAccessLogFormatter` — HTTPアクセスログの個別項目をフォーマットするクラス

ハンドラの設定順序（この順番で指定する必要がある）:

1. ThreadContextHandler
2. HttpAccessLogHandler
3. NablarchTagHandler
4. HttpRequestJavaPackageMapping

> **補足**: NablarchTagHandlerとHttpRequestJavaPackageMappingの間には、データベース接続管理、トランザクション管理、認可チェックなど :ref:`CommonHandlers` で記載したハンドラが入る。

HttpAccessLogHandlerはプロパティを持たないため、設定項目は不要。

```xml
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">
    <property name="handlerQueue">
        <list>
            <component name="nablarchTagHandler"
                       class="nablarch.common.web.handler.HttpAccessLogHandler" />
        </list>
    </property>
</component>
```

## HTTPアクセスログの設定方法

HttpAccessLogUtilはapp-log.propertiesを読み込み、HttpAccessLogFormatterオブジェクトを生成して個別項目のフォーマット処理を委譲する。プロパティファイルのパス指定や実行時の設定値の変更方法は :ref:`AppLog_Config` を参照。

app-log.properties設定例:
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
| httpAccessLogFormatter.className | | HttpAccessLogFormatterのクラス名。差し替え時に指定 |
| httpAccessLogFormatter.beginFormat | | リクエスト処理開始時のログフォーマット |
| httpAccessLogFormatter.parametersFormat | | hiddenパラメータ復号後のログフォーマット |
| httpAccessLogFormatter.dispatchingClassFormat | | ディスパッチ先クラス決定後のログフォーマット |
| httpAccessLogFormatter.endFormat | | リクエスト処理終了時のログフォーマット |
| httpAccessLogFormatter.datePattern | "yyyy-MM-dd HH:mm:ss.SSS" | 開始日時と終了日時に使用する日時パターン（java.text.SimpleDateFormat構文）|
| httpAccessLogFormatter.maskingPatterns | | マスク対象のパラメータ名・変数名（正規表現、カンマ区切りで複数指定可）。リクエストパラメータとセッションスコープ情報の両方に適用。Pattern.CASE_INSENSITIVEでコンパイルされる |
| httpAccessLogFormatter.maskingChar | '*' | マスクに使用する文字 |
| httpAccessLogFormatter.parametersSeparator | "\\n\\t\\t" | リクエストパラメータのセパレータ |
| httpAccessLogFormatter.sessionScopeSeparator | "\\n\\t\\t" | セッションスコープ情報のセパレータ |
| httpAccessLogFormatter.beginOutputEnabled | true | リクエスト処理開始時の出力有効フラグ。falseで出力しない |
| httpAccessLogFormatter.parametersOutputEnabled | true | hiddenパラメータ復号後の出力有効フラグ。falseで出力しない |
| httpAccessLogFormatter.dispatchingClassOutputEnabled | true | ディスパッチ先クラス決定後の出力有効フラグ。falseで出力しない |
| httpAccessLogFormatter.endOutputEnabled | true | リクエスト処理終了時の出力有効フラグ。falseで出力しない |

:ref:`リクエスト処理開始時のプレースホルダ一覧<HttpAccessLog_BeginFormat>` に加えて、以下のプレースホルダを指定できる。リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号後の状態となる。

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

<details>
<summary>keywords</summary>

HttpAccessLogHandler, HttpAccessLogFormatter, HttpAccessLogUtil, NablarchTagHandler, HttpRequestJavaPackageMapping, nablarch.common.web.handler.HttpAccessLogHandler, nablarch.fw.web.handler.HttpAccessLogFormatter, nablarch.fw.web.handler.HttpAccessLogUtil, httpAccessLogFormatter.className, httpAccessLogFormatter.maskingPatterns, httpAccessLogFormatter.maskingChar, httpAccessLogFormatter.datePattern, httpAccessLogFormatter.beginOutputEnabled, httpAccessLogFormatter.parametersOutputEnabled, httpAccessLogFormatter.dispatchingClassOutputEnabled, httpAccessLogFormatter.endOutputEnabled, httpAccessLogFormatter.endFormat, httpAccessLogFormatter.parametersSeparator, httpAccessLogFormatter.sessionScopeSeparator, HTTPアクセスログ, アクセスログ設定, マスキング, ハンドラ設定順序, 個別項目, 共通項目, BasicLogFormatter, 証跡ログ, 出力日時, 起動プロセスID, 処理方式区分, 付加情報, リクエスト終了時ログ, ログフォーマット, プレースホルダ, maskingChar, maskingPatterns, $dispatchingClass$, $statusCode$, $responseStatusCode$, $contentPath$, $startTime$, $endTime$, $executionTime$, $maxMemory$, $freeMemory$, FileLogWriter

</details>

## リクエスト処理開始時のログ出力に使用するフォーマット

プレースホルダ一覧:

| 項目名 | プレースホルダ |
|---|---|
| リクエストID | $requestId$ |
| ユーザID | $userId$ |
| URL | $url$ |
| ポート番号 | $port$ |
| HTTPメソッド | $method$ |
| セッションID | $sessionId$ |
| リクエストパラメータ | $parameters$ |
| セッションスコープ情報 | $sessionScope$ |
| クライアント端末IPアドレス | $clientIpAddress$ |
| クライアント端末ホスト | $clientHost$ |
| HTTPヘッダのUser-Agent | $clientUserAgent$ |

リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号前の状態。

デフォルトのフォーマット:
```bash
@@@@ BEGIN @@@@ rid = [$requestId$] uid = [$userId$] sid = [$sessionId$]
    \n\turl         = [$url$]
    \n\tmethod      = [$method$]
    \n\tport        = [$port$]
    \n\tclient_ip   = [$clientIpAddress$]
    \n\tclient_host = [$clientHost$]
    \n\tparameters  = [$parameters$]
```

ユーザ登録を依頼するリクエストの例。パラメータ名に `password` を含むリクエストパラメータはマスク対象となり、`maskingChar` で指定した文字に置換されて出力される。HTTPアクセスログの個別項目のフォーマットは、デフォルトのフォーマットを使用する。

app-log.properties の設定例:

```properties
httpAccessLogFormatter.maskingChar=#
httpAccessLogFormatter.maskingPatterns=\\.*password\\.*
```

log.properties の設定例:

```properties
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

実際のログ出力例:

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

$requestId$, $userId$, $url$, $port$, $method$, $sessionId$, $parameters$, $sessionScope$, $clientIpAddress$, $clientHost$, $clientUserAgent$, beginFormat, beginOutputEnabled, リクエスト処理開始時, プレースホルダ, HTTPアクセスログ, ログ出力例, BEGIN, PARAMETERS, DISPATCHING CLASS, END, マスキング, password, nablarch_token, maskingChar, maskingPatterns, app-log.properties, log.properties

</details>

## hiddenパラメータ復号後のログ出力に使用するフォーマット

プレースホルダ一覧は :ref:`リクエスト処理開始時のプレースホルダ一覧<HttpAccessLog_BeginFormat>` と同じ。リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号後の状態。

デフォルトのフォーマット:
```bash
@@@@ PARAMETERS @@@@
    \n\tparameters  = [$parameters$]
```

<details>
<summary>keywords</summary>

$parameters$, $sessionId$, parametersFormat, parametersOutputEnabled, hiddenパラメータ復号後, WebView_HiddenEncryption, プレースホルダ

</details>

## ディスパッチ先クラス決定後のログ出力に使用するフォーマット

プレースホルダ一覧は :ref:`リクエスト処理開始時のプレースホルダ一覧<HttpAccessLog_BeginFormat>` に加えて以下のプレースホルダを指定できる。リクエストパラメータは :ref:`WebView_HiddenEncryption` 機能の復号後の状態。

| 項目名 | プレースホルダ |
|---|---|
| ディスパッチ先クラス | $dispatchingClass$ |

デフォルトのフォーマット:
```bash
@@@@ DISPATCHING CLASS @@@@ class = [$dispatchingClass$]
```

<details>
<summary>keywords</summary>

$dispatchingClass$, dispatchingClassFormat, dispatchingClassOutputEnabled, ディスパッチ先クラス, HttpRequestJavaPackageMapping, プレースホルダ

</details>
