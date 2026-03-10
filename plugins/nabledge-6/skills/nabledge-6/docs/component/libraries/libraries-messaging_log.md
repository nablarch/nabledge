# メッセージングログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/messaging_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/logging/MessagingLogFormatter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/logging/MessagingJsonLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html)

## メッセージングログの出力方針

メッセージングログは :ref:`system_messaging` のメッセージ送受信時に出力する。アプリケーション全体のアプリケーションログに出力する。

| ログレベル | ロガー名 |
|---|---|
| INFO | MESSAGING |

**log.properties設定例**:

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

**app-log.properties設定例（デフォルトフォーマット）**:

```properties
# MOMメッセージング用フォーマット
messagingLogFormatter.sentMessageFormat=@@@@ SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\ttime_to_live   = [$timeToLive$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.receivedMessageFormat=@@@@ RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\tmessage_body   = [$messageBody$]
# HTTPメッセージング用フォーマット
messagingLogFormatter.httpSentMessageFormat=@@@@ HTTP SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.httpReceivedMessageFormat=@@@@ HTTP RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
```

<details>
<summary>keywords</summary>

メッセージングログ出力方針, ログレベル INFO, ロガー名 MESSAGING, アプリケーションログ出力, log.properties設定, メッセージングログ設定例

</details>

## メッセージングログの設定

設定ファイルは :ref:`log-app_log_setting` で説明したプロパティファイル。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messagingLogFormatter.className | | | `MessagingLogFormatter` を実装したクラス（差し替え時のみ指定） |
| messagingLogFormatter.maskingPatterns | | | メッセージ本文マスク対象の正規表現。最初のキャプチャグループがマスク対象。複数指定はカンマ区切り、大文字小文字区別なし |
| messagingLogFormatter.maskingChar | | `*` | マスク文字 |
| messagingLogFormatter.sentMessageFormat | | 後述 | MOM送信メッセージのログフォーマット |
| messagingLogFormatter.receivedMessageFormat | | 後述 | MOM受信メッセージのログフォーマット |
| messagingLogFormatter.httpSentMessageFormat | | 後述 | HTTP送信メッセージのログフォーマット |
| messagingLogFormatter.httpReceivedMessageFormat | | 後述 | HTTP受信メッセージのログフォーマット |

**maskingPatternsの例**: パターン `<password>(.+?)</password>` の場合、`<password>hoge</password>` → `<password>****</password>`

**MOM送受信フォーマット（sentMessageFormat/receivedMessageFormat）のプレースホルダ**:

| プレースホルダ | 説明 |
|---|---|
| $threadName$ | スレッド名 |
| $messageId$ | メッセージID |
| $destination$ | 送信宛先 |
| $correlationId$ | 関連メッセージID |
| $replyTo$ | 応答宛先 |
| $timeToLive$ | 有効期間 |
| $messageBody$ | メッセージボディ内容（電文をISO-8859-1固定エンコードした結果） |
| $messageBodyHex$ | $messageBody$ のヘキサダンプ |
| $messageBodyLength$ | メッセージボディのバイト長 |

**HTTPメッセージフォーマット（httpSentMessageFormat/httpReceivedMessageFormat）のプレースホルダ**: $threadName$, $messageId$, $destination$, $correlationId$, $messageBody$, $messageBodyHex$, $messageBodyLength$, $messageHeader$

**sentMessageFormatデフォルト**:

```
@@@@ SENT MESSAGE @@@@
\n\tthread_name    = [$threadName$]
\n\tmessage_id     = [$messageId$]
\n\tdestination    = [$destination$]
\n\tcorrelation_id = [$correlationId$]
\n\treply_to       = [$replyTo$]
\n\ttime_to_live   = [$timeToLive$]
\n\tmessage_body   = [$messageBody$]
```

**receivedMessageFormatデフォルト** (time_to_liveなし):

```
@@@@ RECEIVED MESSAGE @@@@
\n\tthread_name    = [$threadName$]
\n\tmessage_id     = [$messageId$]
\n\tdestination    = [$destination$]
\n\tcorrelation_id = [$correlationId$]
\n\treply_to       = [$replyTo$]
\n\tmessage_body   = [$messageBody$]
```

**httpSentMessageFormatデフォルト**:

```
@@@@ HTTP SENT MESSAGE @@@@
\n\tthread_name    = [$threadName$]
\n\tmessage_id     = [$messageId$]
\n\tdestination    = [$destination$]
\n\tcorrelation_id = [$correlationId$]
\n\tmessage_header = [$messageHeader$]
\n\tmessage_body   = [$messageBody$]
```

**httpReceivedMessageFormatデフォルト**: httpSentMessageFormatと同様。

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

MessagingLogFormatter, messagingLogFormatter.className, messagingLogFormatter.maskingPatterns, messagingLogFormatter.maskingChar, messagingLogFormatter.sentMessageFormat, messagingLogFormatter.receivedMessageFormat, messagingLogFormatter.httpSentMessageFormat, messagingLogFormatter.httpReceivedMessageFormat, メッセージマスキング設定, MOMメッセージングフォーマット, HTTPメッセージングフォーマット, メッセージボディISO-8859-1

</details>

## JSON形式の構造化ログとして出力する

`MessagingLogFormatter` のデフォルト動作ではメッセージングログの各項目は `message` の値に文字列として出力される。各項目をJSONの値として出力するには `MessagingJsonLogFormatter` を使用する。設定は :ref:`log-app_log_setting` で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messagingLogFormatter.className | ○ | | `nablarch.fw.messaging.logging.MessagingJsonLogFormatter` を指定 |
| messagingLogFormatter.maskingPatterns | | | メッセージ本文マスク対象の正規表現。最初のキャプチャグループがマスク対象。複数指定はカンマ区切り、大文字小文字区別なし |
| messagingLogFormatter.maskingChar | | `*` | マスク文字 |
| messagingLogFormatter.sentMessageTargets | | label, threadName, messageId, destination, correlationId, replyTo, timeToLive, messageBody | MOM送信メッセージログの出力項目（カンマ区切り） |
| messagingLogFormatter.receivedMessageTargets | | label, threadName, messageId, destination, correlationId, replyTo, messageBody | MOM受信メッセージログの出力項目（カンマ区切り） |
| messagingLogFormatter.httpSentMessageTargets | | label, threadName, messageId, destination, correlationId, messageBody, messageHeader | HTTP送信メッセージログの出力項目（カンマ区切り） |
| messagingLogFormatter.httpReceivedMessageTargets | | label, threadName, messageId, destination, correlationId, messageBody, messageHeader | HTTP受信メッセージログの出力項目（カンマ区切り） |
| messagingLogFormatter.sentMessageLabel | | `SENT MESSAGE` | MOM送信メッセージログのlabel値 |
| messagingLogFormatter.receivedMessageLabel | | `RECEIVED MESSAGE` | MOM受信メッセージログのlabel値 |
| messagingLogFormatter.httpSentMessageLabel | | `HTTP SENT MESSAGE` | HTTP送信メッセージログのlabel値 |
| messagingLogFormatter.httpReceivedMessageLabel | | `HTTP RECEIVED MESSAGE` | HTTP受信メッセージログのlabel値 |
| messagingLogFormatter.structuredMessagePrefix | | `$JSON$` | JSON整形済みメッセージのマーカー文字列。`JsonLogFormatter` に設定しているマーカー文字列と一致する場合、JsonLogFormatterはメッセージをJSONデータとして処理する |

**sentMessageTargetsの全指定可能項目**: label, threadName, messageId, destination, correlationId, replyTo, timeToLive, messageBody, messageBodyHex, messageBodyLength

**receivedMessageTargetsの全指定可能項目**: label, threadName, messageId, destination, correlationId, replyTo, timeToLive, messageBody, messageBodyHex, messageBodyLength（timeToLiveはデフォルト外）

**httpSentMessageTargets/httpReceivedMessageTargetsの全指定可能項目**: label, threadName, messageId, destination, correlationId, messageBody, messageBodyHex, messageBodyLength, messageHeader

> **注意**: messageBody は電文をISO-8859-1固定でエンコードした結果を出力する。messageBodyHex は messageBody のヘキサダンプ。

> **注意**: `structuredMessagePrefix` を変更する場合は、:ref:`log-basic_setting` のLogWriterの `structuredMessagePrefix` プロパティを使用して `JsonLogFormatter` にも同じ値を設定すること。

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

MessagingJsonLogFormatter, JSON構造化ログ, messagingLogFormatter.structuredMessagePrefix, messagingLogFormatter.sentMessageTargets, messagingLogFormatter.receivedMessageTargets, messagingLogFormatter.httpSentMessageTargets, messagingLogFormatter.httpReceivedMessageTargets, messagingLogFormatter.sentMessageLabel, messagingLogFormatter.receivedMessageLabel, messagingLogFormatter.httpSentMessageLabel, messagingLogFormatter.httpReceivedMessageLabel, JsonLogFormatter, メッセージングログJSON形式出力

</details>
