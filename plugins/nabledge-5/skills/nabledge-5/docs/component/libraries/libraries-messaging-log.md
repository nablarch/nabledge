# メッセージングログの出力

**目次**

* メッセージングログの出力方針
* 使用方法

  * メッセージングログの設定
  * JSON形式の構造化ログとして出力する

メッセージングログは、 [システム間メッセージング](../../component/libraries/libraries-system-messaging.md#system-messaging) の中でメッセージ送受信時に出力する。
アプリケーションでは、ログ出力を設定することにより出力する。

## メッセージングログの出力方針

メッセージングログは、アプリケーション全体のログ出力を行うアプリケーションログに出力する。

メッセージングログの出力方針

| ログレベル | ロガー名 |
|---|---|
| INFO | MESSAGING |

上記出力方針に対するログ出力の設定例を下記に示す。

log.propertiesの設定例

```properties
writerNames=appLog

# アプリケーションログの出力先
writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.appLog.encoding=UTF-8
writer.appLog.maxFileSize=10000
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=MESSAGING,ROO

# アプリケーションログの設定
loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

# メッセージングログの設定
loggers.MESSAGING.nameRegex=MESSAGING
loggers.MESSAGING.level=INFO
loggers.MESSAGING.writerNames=appLog
```

app-log.propertiesの設定例

```properties
# MessagingLogFormatter
#messagingLogFormatter.className=
#messagingLogFormatter.maskingChar=
#messagingLogFormatter.maskingPatterns=
# MOMメッセージング用フォーマット
messagingLogFormatter.sentMessageFormat=@@@@ SENT MESSAGE @@@@\
                                          \n\tthread_name    = [$threadName$]\
                                          \n\tmessage_id     = [$messageId$]\
                                          \n\tdestination    = [$destination$]\
                                          \n\tcorrelation_id = [$correlationId$]\
                                          \n\treply_to       = [$replyTo$]\
                                          \n\ttime_to_live   = [$timeToLive$]\
                                          \n\tmessage_body   = [$messageBody$]
messagingLogFormatter.receivedMessageFormat=@@@@ RECEIVED MESSAGE @@@@\
                                              \n\tthread_name    = [$threadName$]\
                                              \n\tmessage_id     = [$messageId$]\
                                              \n\tdestination    = [$destination$]\
                                              \n\tcorrelation_id = [$correlationId$]\
                                              \n\treply_to       = [$replyTo$]\
                                              \n\tmessage_body   = [$messageBody$]
# HTTPメッセージング用フォーマット
messagingLogFormatter.httpSentMessageFormat=@@@@ HTTP SENT MESSAGE @@@@\
                                              \n\tthread_name    = [$threadName$]\
                                              \n\tmessage_id     = [$messageId$]\
                                              \n\tdestination    = [$destination$]\
                                              \n\tcorrelation_id = [$correlationId$]\
                                              \n\tmessage_header = [$messageHeader$]\
                                              \n\tmessage_body   = [$messageBody$]
messagingLogFormatter.httpReceivedMessageFormat=@@@@ HTTP RECEIVED MESSAGE @@@@\
                                                  \n\tthread_name    = [$threadName$]\
                                                  \n\tmessage_id     = [$messageId$]\
                                                  \n\tdestination    = [$destination$]\
                                                  \n\tcorrelation_id = [$correlationId$]\
                                                  \n\tmessage_header = [$messageHeader$]\
                                                  \n\tmessage_body   = [$messageBody$]
```

## 使用方法

### メッセージングログの設定

メッセージングログの設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#log-app-log-setting) で説明したプロパティファイルに行う。

記述ルール

messagingLogFormatter.className

MessagingLogFormatter を実装したクラス。
差し替える場合に指定する。

messagingLogFormatter.maskingPatterns

メッセージ本文のマスク対象文字列を正規表現で指定する。
正規表現で指定された最初のキャプチャ部分(括弧で囲まれた部分)がマスク対象となる。

例えばパターンとして「<password>(.+?)</password>」と指定し、
実電文に「<password>hoge</password>」が含まれる場合、
出力される文字列は「<password>****</password>」となる。

複数指定する場合はカンマ区切り。
指定した正規表現は大文字小文字を区別しない。

messagingLogFormatter.maskingChar

マスクに使用する文字。デフォルトは’*’。

messagingLogFormatter.sentMessageFormat

MOM送信メッセージのログ出力に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$threadName$

$messageId$

$destination$

$correlationId$

$replyTo$

$timeToLive$

$messageBody$ [1]

$messageBodyHex$ [1]

$messageBodyLength$

デフォルトのフォーマット

```bash
@@@@ SENT MESSAGE @@@@
    \n\tthread_name    = [$threadName$]
    \n\tmessage_id     = [$messageId$]
    \n\tdestination    = [$destination$]
    \n\tcorrelation_id = [$correlationId$]
    \n\treply_to       = [$replyTo$]
    \n\ttime_to_live   = [$timeToLive$]
    \n\tmessage_body   = [$messageBody$]
```

messagingLogFormatter.receivedMessageFormat

MOM受信メッセージのログ出力に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$threadName$

$messageId$

$destination$

$correlationId$

$replyTo$

$timeToLive$

$messageBody$ [1]

$messageBodyHex$ [1]

$messageBodyLength$

デフォルトのフォーマット

```bash
@@@@ RECEIVED MESSAGE @@@@
    \n\tthread_name    = [$threadName$]
    \n\tmessage_id     = [$messageId$]
    \n\tdestination    = [$destination$]
    \n\tcorrelation_id = [$correlationId$]
    \n\treply_to       = [$replyTo$]
    \n\tmessage_body   = [$messageBody$]
```

messagingLogFormatter.httpSentMessageFormat

HTTP送信メッセージのログ出力に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$threadName$

$messageId$

$destination$

$correlationId$

$messageBody$ [1]

$messageBodyHex$ [1]

$messageBodyLength$

$messageHeader$

デフォルトのフォーマット

```bash
@@@@ HTTP SENT MESSAGE @@@@
    \n\tthread_name    = [$threadName$]
    \n\tmessage_id     = [$messageId$]
    \n\tdestination    = [$destination$]
    \n\tcorrelation_id = [$correlationId$]
    \n\tmessage_header = [$messageHeader$]
    \n\tmessage_body   = [$messageBody$]
```

messagingLogFormatter.httpReceivedMessageFormat

HTTP受信メッセージのログ出力に使用するフォーマット。

フォーマットに指定可能なプレースホルダ

$threadName$

$messageId$

$destination$

$correlationId$

$messageBody$ [1]

$messageBodyHex$ [1]

$messageBodyLength$

$messageHeader$

デフォルトのフォーマット

```bash
@@@@ HTTP RECEIVED MESSAGE @@@@
    \n\tthread_name    = [$threadName$]
    \n\tmessage_id     = [$messageId$]
    \n\tdestination    = [$destination$]
    \n\tcorrelation_id = [$correlationId$]
    \n\tmessage_header = [$messageHeader$]
    \n\tmessage_body   = [$messageBody$]
```

* **$messageBody$:** 電文をISO-8859-1固定でエンコードした結果を出力する。
* **$messageBodyHex$:** $messageBody$の内容をヘキサダンプして出力する。

記述例

```properties
messagingLogFormatter.className=nablarch.fw.messaging.logging.MessagingLogFormatter
messagingLogFormatter.maskingChar=#
messagingLogFormatter.maskingPatterns=<password>(.+?)</password>,<mobilePhoneNumber>(.+?)</mobilePhoneNumber>

# MOMメッセージング用フォーマット
messagingLogFormatter.sentMessageFormat=@@@@ SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\ttime_to_live   = [$timeToLive$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.receivedMessageFormat=@@@@ RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\treply_to       = [$replyTo$]\n\tmessage_body   = [$messageBody$]

# HTTPメッセージング用フォーマット
messagingLogFormatter.httpSentMessageFormat=@@@@ HTTP SENT MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
messagingLogFormatter.httpReceivedMessageFormat=@@@@ HTTP RECEIVED MESSAGE @@@@\n\tthread_name    = [$threadName$]\n\tmessage_id     = [$messageId$]\n\tdestination    = [$destination$]\n\tcorrelation_id = [$correlationId$]\n\tmessage_header = [$messageHeader$]\n\tmessage_body   = [$messageBody$]
```

### JSON形式の構造化ログとして出力する

[JSON形式の構造化ログとして出力する](../../component/libraries/libraries-log.md#log-json-log-setting) 設定によりログをJSON形式で出力できるが、
MessagingLogFormatter では
メッセージングログの各項目はmessageの値に文字列として出力される。
メッセージングログの各項目もJSONの値として出力するには、
MessagingJsonLogFormatter を使用する。
設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#log-app-log-setting) で説明したプロパティファイルに行う。

記述ルール

MessagingJsonLogFormatter を用いる際に
指定するプロパティは以下の通り。

messagingLogFormatter.className `必須`

JSON形式でログを出力する場合、
MessagingJsonLogFormatter を指定する。

messagingLogFormatter.maskingPatterns

メッセージ本文のマスク対象文字列を正規表現で指定する。
正規表現で指定された最初のキャプチャ部分(括弧で囲まれた部分)がマスク対象となる。

例えばパターンとして「<password>(.+?)</password>」と指定し、
実電文に「<password>hoge</password>」が含まれる場合、
出力される文字列は「<password>****</password>」となる。

複数指定する場合はカンマ区切り。
指定した正規表現は大文字小文字を区別しない。

messagingLogFormatter.maskingChar

マスクに使用する文字。デフォルトは’*’。

messagingLogFormatter.sentMessageTargets

MOM送信メッセージログの出力項目。カンマ区切りで指定する。

指定可能な出力項目およびデフォルトの出力項目

label `デフォルト`

threadName `デフォルト`

messageId `デフォルト`

destination `デフォルト`

correlationId `デフォルト`

replyTo `デフォルト`

timeToLive `デフォルト`

messageBody [2] `デフォルト`

messageBodyHex [2]

messageBodyLength

messagingLogFormatter.receivedMessageTargets

MOM受信メッセージログの出力項目。カンマ区切りで指定する。

指定可能な出力項目およびデフォルトの出力項目

label `デフォルト`

threadName `デフォルト`

messageId `デフォルト`

destination `デフォルト`

correlationId `デフォルト`

replyTo `デフォルト`

timeToLive

messageBody [2] `デフォルト`

messageBodyHex [2]

messageBodyLength

messagingLogFormatter.httpSentMessageTargets

HTTP送信メッセージログの出力項目。カンマ区切りで指定する。

指定可能な出力項目およびデフォルトの出力項目

label `デフォルト`

threadName `デフォルト`

messageId `デフォルト`

destination `デフォルト`

correlationId `デフォルト`

messageBody [2] `デフォルト`

messageBodyHex [2]

messageBodyLength

messageHeader `デフォルト`

messagingLogFormatter.httpReceivedMessageTargets

HTTP受信メッセージログの出力項目。カンマ区切りで指定する。

指定可能な出力項目およびデフォルトの出力項目

label `デフォルト`

threadName `デフォルト`

messageId `デフォルト`

destination `デフォルト`

correlationId `デフォルト`

messageBody [2] `デフォルト`

messageBodyHex [2]

messageBodyLength

messageHeader `デフォルト`

messagingLogFormatter.sentMessageLabel

MOM送信メッセージログのlabelに出力する値。
デフォルトは `"SENT MESSAGE"`。

messagingLogFormatter.receivedMessageLabel

MOM受信メッセージログのlabelに出力する値。
デフォルトは `"RECEIVED MESSAGE"`。

messagingLogFormatter.httpSentMessageLabel

HTTP送信メッセージログのlabelに出力する値。
デフォルトは `"HTTP SENT MESSAGE"`。

messagingLogFormatter.httpReceivedMessageLabel

HTTP受信メッセージログのlabelに出力する値。
デフォルトは `"HTTP RECEIVED MESSAGE"`。

messagingLogFormatter.structuredMessagePrefix

フォーマット後のメッセージ文字列が JSON 形式に整形されていることを識別できるようにするために、メッセージの先頭に付与するマーカー文字列。
メッセージの先頭にあるマーカー文字列が JsonLogFormatter に設定しているマーカー文字列と一致する場合、 JsonLogFormatter はメッセージを JSON データとして処理する。
デフォルトは `"$JSON$"` となる。
変更する場合は、LogWriterの `structuredMessagePrefix` プロパティを使用して JsonLogFormatter にも同じ値を設定すること（LogWriterのプロパティについては [ログ出力の設定](../../component/libraries/libraries-log.md#log-basic-setting) を参照）。

* **messageBody:** 電文をISO-8859-1固定でエンコードした結果を出力する。
* **messageBodyHex:** messageBodyの内容をヘキサダンプして出力する。

記述例

```properties
messagingLogFormatter.className=nablarch.fw.messaging.logging.MessagingJsonLogFormatter
messagingLogFormatter.structuredMessagePrefix=$JSON$

# MOMメッセージング用フォーマット
messagingLogFormatter.sentMessageTargets=threadName,messageId,destination,correlationId,replyTo,timeToLive,messageBody
messagingLogFormatter.receivedMessageTargets=threadName,messageId,destination,correlationId,replyTo,messageBody

# HTTPメッセージング用フォーマット
messagingLogFormatter.httpSentMessageTargets=threadName,messageId,destination,correlationId,messageHeader,messageBody
messagingLogFormatter.httpReceivedMessageTargets=threadName,messageId,destination,correlationId,messageHeader,messageBody
```
