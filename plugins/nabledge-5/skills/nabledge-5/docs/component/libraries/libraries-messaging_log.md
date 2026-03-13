# メッセージングログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/messaging_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/logging/MessagingLogFormatter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/logging/MessagingJsonLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html)

## メッセージングログの出力方針

メッセージングログは [system_messaging](libraries-system_messaging.md) でのメッセージ送受信時にアプリケーションログへ出力する。

**出力方針**:

| ログレベル | ロガー名 |
|---|---|
| INFO | MESSAGING |

**log.properties 設定例**:
```properties
writerNames=appLog
writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.appLog.encoding=UTF-8
writer.appLog.maxFileSize=10000
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=MESSAGING,ROO

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

loggers.MESSAGING.nameRegex=MESSAGING
loggers.MESSAGING.level=INFO
loggers.MESSAGING.writerNames=appLog
```

**app-log.properties フォーマット設定例（MOMメッセージング）**:
```properties
messagingLogFormatter.sentMessageFormat=@@@@ SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\ttime_to_live   = [$timeToLive$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.receivedMessageFormat=@@@@ RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\tmessage_body   = [$messageBody$]
```

**app-log.properties フォーマット設定例（HTTPメッセージング）**:
```properties
messagingLogFormatter.httpSentMessageFormat=@@@@ HTTP SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.httpReceivedMessageFormat=@@@@ HTTP RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
```

<details>
<summary>keywords</summary>

メッセージングログ出力方針, アプリケーションログ, INFOレベル, MESSAGINGロガー, log.properties設定, app-log.properties設定

</details>

## メッセージングログの設定

設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

**クラス**: `nablarch.fw.messaging.logging.MessagingLogFormatter`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messagingLogFormatter.className | | | `MessagingLogFormatter` を実装したクラス。差し替える場合に指定する。 |
| messagingLogFormatter.maskingPatterns | | | マスク対象文字列を正規表現で指定。最初のキャプチャ部分（括弧で囲まれた部分）がマスク対象。複数はカンマ区切り。大文字小文字区別しない。 |
| messagingLogFormatter.maskingChar | | `*` | マスクに使用する文字。 |
| messagingLogFormatter.sentMessageFormat | | 下記 | MOM送信メッセージのフォーマット。 |
| messagingLogFormatter.receivedMessageFormat | | 下記 | MOM受信メッセージのフォーマット。 |
| messagingLogFormatter.httpSentMessageFormat | | 下記 | HTTP送信メッセージのフォーマット。 |
| messagingLogFormatter.httpReceivedMessageFormat | | 下記 | HTTP受信メッセージのフォーマット。 |

**sentMessageFormat / receivedMessageFormat のプレースホルダ**: `$threadName$`, `$messageId$`, `$destination$`, `$correlationId$`, `$replyTo$`, `$timeToLive$`, `$messageBody$`, `$messageBodyHex$`, `$messageBodyLength$`

**httpSentMessageFormat / httpReceivedMessageFormat のプレースホルダ**: `$threadName$`, `$messageId$`, `$destination$`, `$correlationId$`, `$messageBody$`, `$messageBodyHex$`, `$messageBodyLength$`, `$messageHeader$`

> **注意**: `$messageBody$` は電文をISO-8859-1固定でエンコードして出力する。`$messageBodyHex$` は `$messageBody$` のヘキサダンプ。

**設定例**:
```properties
messagingLogFormatter.className=nablarch.fw.messaging.logging.MessagingLogFormatter
messagingLogFormatter.maskingChar=#
messagingLogFormatter.maskingPatterns=<password>(.+?)</password>,<mobilePhoneNumber>(.+?)</mobilePhoneNumber>
messagingLogFormatter.sentMessageFormat=@@@@ SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\ttime_to_live   = [$timeToLive$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.receivedMessageFormat=@@@@ RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.httpSentMessageFormat=@@@@ HTTP SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.httpReceivedMessageFormat=@@@@ HTTP RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
```

<details>
<summary>keywords</summary>

MessagingLogFormatter, messagingLogFormatter.className, messagingLogFormatter.maskingPatterns, messagingLogFormatter.maskingChar, messagingLogFormatter.sentMessageFormat, messagingLogFormatter.receivedMessageFormat, messagingLogFormatter.httpSentMessageFormat, messagingLogFormatter.httpReceivedMessageFormat, メッセージングログ設定, マスク処理, MOMメッセージング, HTTPメッセージング, プレースホルダ, messageBody, messageBodyHex, messageBodyLength

</details>

## JSON形式の構造化ログとして出力する

`MessagingJsonLogFormatter` を使用することで、メッセージングログの各項目をJSONの値として出力できる。設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messagingLogFormatter.className | ○ | | `nablarch.fw.messaging.logging.MessagingJsonLogFormatter` を指定。 |
| messagingLogFormatter.maskingPatterns | | | 標準フォーマットと同様。 |
| messagingLogFormatter.maskingChar | | `*` | マスクに使用する文字。 |
| messagingLogFormatter.sentMessageTargets | | label,threadName,messageId,destination,correlationId,replyTo,timeToLive,messageBody | MOM送信ログの出力項目。カンマ区切り。選択可能: label,threadName,messageId,destination,correlationId,replyTo,timeToLive,messageBody,messageBodyHex,messageBodyLength |
| messagingLogFormatter.receivedMessageTargets | | label,threadName,messageId,destination,correlationId,replyTo,messageBody | MOM受信ログの出力項目。カンマ区切り。選択可能: label,threadName,messageId,destination,correlationId,replyTo,timeToLive,messageBody,messageBodyHex,messageBodyLength |
| messagingLogFormatter.httpSentMessageTargets | | label,threadName,messageId,destination,correlationId,messageBody,messageHeader | HTTP送信ログの出力項目。カンマ区切り。選択可能: label,threadName,messageId,destination,correlationId,messageBody,messageBodyHex,messageBodyLength,messageHeader |
| messagingLogFormatter.httpReceivedMessageTargets | | label,threadName,messageId,destination,correlationId,messageBody,messageHeader | HTTP受信ログの出力項目。カンマ区切り。選択可能: label,threadName,messageId,destination,correlationId,messageBody,messageBodyHex,messageBodyLength,messageHeader |
| messagingLogFormatter.sentMessageLabel | | `"SENT MESSAGE"` | MOM送信ログのlabelに出力する値。 |
| messagingLogFormatter.receivedMessageLabel | | `"RECEIVED MESSAGE"` | MOM受信ログのlabelに出力する値。 |
| messagingLogFormatter.httpSentMessageLabel | | `"HTTP SENT MESSAGE"` | HTTP送信ログのlabelに出力する値。 |
| messagingLogFormatter.httpReceivedMessageLabel | | `"HTTP RECEIVED MESSAGE"` | HTTP受信ログのlabelに出力する値。 |
| messagingLogFormatter.structuredMessagePrefix | | `"$JSON$"` | JSONマーカー文字列。`JsonLogFormatter` に設定している値と一致させること（[log-basic_setting](libraries-log.md) 参照）。 |

> **注意**: `messageBody` は電文をISO-8859-1固定でエンコードして出力する。`messageBodyHex` は `messageBody` のヘキサダンプ。

**設定例**:
```properties
messagingLogFormatter.className=nablarch.fw.messaging.logging.MessagingJsonLogFormatter
messagingLogFormatter.structuredMessagePrefix=$JSON$
messagingLogFormatter.sentMessageTargets=threadName,messageId,destination,correlationId,replyTo,timeToLive,messageBody
messagingLogFormatter.receivedMessageTargets=threadName,messageId,destination,correlationId,replyTo,messageBody
messagingLogFormatter.httpSentMessageTargets=threadName,messageId,destination,correlationId,messageHeader,messageBody
messagingLogFormatter.httpReceivedMessageTargets=threadName,messageId,destination,correlationId,messageHeader,messageBody
```

<details>
<summary>keywords</summary>

MessagingJsonLogFormatter, JsonLogFormatter, messagingLogFormatter.sentMessageTargets, messagingLogFormatter.receivedMessageTargets, messagingLogFormatter.httpSentMessageTargets, messagingLogFormatter.httpReceivedMessageTargets, messagingLogFormatter.structuredMessagePrefix, messagingLogFormatter.sentMessageLabel, messagingLogFormatter.receivedMessageLabel, messagingLogFormatter.httpSentMessageLabel, messagingLogFormatter.httpReceivedMessageLabel, JSON構造化ログ, MOMメッセージング, HTTPメッセージング

</details>
