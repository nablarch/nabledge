# 障害ログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/failure_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureLogUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/TransactionAbnormalEnd.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureLogFormatter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LogItem.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureLogFormatter.DataItem.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureJsonLogFormatter.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html)

## 障害ログの出力方針

障害通知ログはログ監視ツールから障害を検知することを想定しているため、ロガー名`MONITOR`を使用して障害通知専用ファイルに出力する。障害解析ログはアプリケーションログに出力する。

| ログの種類 | ログレベル | ロガー名 |
|---|---|---|
| 障害通知ログ | FATAL、ERROR | MONITOR |
| 障害解析ログ | FATAL、ERROR | クラス名 |

**log.properties 設定例**:
```properties
writerNames=monitorLog,appLog

# 障害通知ログの出力先
writer.monitorLog.className=nablarch.core.log.basic.FileLogWriter
writer.monitorLog.filePath=/var/log/app/monitor.log
writer.monitorLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.monitorLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$

# アプリケーションログの出力先
writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.appLog.maxFileSize=10000
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=MON,ROO

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

loggers.MON.nameRegex=MONITOR
loggers.MON.level=ERROR
loggers.MON.writerNames=monitorLog
```

**app-log.properties 設定例**:
```properties
failureLogFormatter.defaultFailureCode=MSG99999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.language=ja
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

> **補足**: 大規模システムで障害時の連絡先が複数存在する場合、:ref:`failure_log-add_contact` を使用することでリクエストID毎に連絡先情報をログに含めることができる。

<details>
<summary>keywords</summary>

障害通知ログ, 障害解析ログ, MONITOR, ロガー名, log.properties設定, app-log.properties設定, FileLogWriter, BasicLogFormatter, 障害ログ出力方針

</details>

## 障害ログを出力する

障害ログの出力には `FailureLogUtil` を使用する。

```java
try {
    // 業務処理
} catch (UserNotFoundException e) {
    // 捕捉した例外、処理対象データ、障害コードを指定
    FailureLogUtil.logError(e, inputData, "USER_NOT_FOUND");
}
```

バッチとメッセージングで障害検知時に処理を終了したい場合は、`TransactionAbnormalEnd` または `ProcessAbnormalEnd` を送出し、例外ハンドラ（:ref:`global_error_handler` や :ref:`request_thread_loop_handler`）に障害ログの出力を委譲する。

```java
// 自ら例外を生成する場合
if (user == null) {
    throw new TransactionAbnormalEnd(100, "USER_NOT_FOUND");
}

// 例外を捕捉した場合
try {
    // 業務処理
} catch (UserNotFoundException e) {
    throw new ProcessAbnormalEnd(100, e, "USER_NOT_FOUND");
}
```

> **補足**: 上記例のように、障害ログの出力ではログから障害内容を特定するために障害コードを指定する。障害コードのコード体系は、プロジェクト毎に規定すること。

**障害ログに出力されるメッセージ**: :ref:`message` を使用して障害コードに対応するメッセージを取得する。メッセージが見つからない場合は例外が発生し、その例外をWARNレベルでログ出力した上で、障害ログには以下を出力する:
```
failed to get the message to output the failure log. failureCode = [<障害コード>]
```

障害コードの指定がない場合（例外ハンドラで捕捉した場合など）は、デフォルトの障害コード（`failureLogFormatter.defaultFailureCode`）とメッセージ（`failureLogFormatter.defaultMessage`）を出力する。

<details>
<summary>keywords</summary>

FailureLogUtil, TransactionAbnormalEnd, ProcessAbnormalEnd, 障害コード, 障害ログ出力, logError, バッチ障害ログ, UserNotFoundException, メッセージ取得失敗, 障害コード体系, プロジェクト規定

</details>

## 障害ログの設定

障害ログの設定は :ref:`log-app_log_setting` で説明したプロパティファイルに行う。

**クラス**: `nablarch.core.log.app.FailureLogFormatter`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| failureLogFormatter.className | | | FailureLogFormatterを実装したクラス。差し替える場合に指定 |
| failureLogFormatter.defaultFailureCode | ○ | | デフォルトの障害コード。障害コードの指定がない場合に使用 |
| failureLogFormatter.defaultMessage | ○ | | デフォルトのメッセージ。デフォルト障害コードを使用する場合に出力 |
| failureLogFormatter.language | | ThreadContextに設定されている言語 | 障害コードからメッセージを取得する際の言語 |
| failureLogFormatter.notificationFormat | | `fail_code = [$failureCode$] $message$` | 障害通知ログのフォーマット |
| failureLogFormatter.analysisFormat | | 障害通知ログと同じ | 障害解析ログのフォーマット |
| failureLogFormatter.contactFilePath | | | 連絡先情報のプロパティファイルパス（:ref:`failure_log-add_contact` 参照） |
| failureLogFormatter.fwFailureCodeFilePath | | | フレームワーク障害コード変更情報のプロパティファイルパス（:ref:`failure_log-change_fw_failure_code` 参照） |

**notificationFormat / analysisFormat のプレースホルダ**:

| プレースホルダ | 説明 |
|---|---|
| $failureCode$ | 障害を一意に識別するコード |
| $message$ | 障害コードに対応するメッセージ |
| $data$ | 障害が発生した処理対象データ（toStringメソッドの結果） |
| $contact$ | 連絡先情報 |

> **重要**: セキュリティ要件により個人情報や機密情報の出力が許されない場合は、:ref:`failure_log-placeholder_customize` を参照してプロジェクトでカスタマイズすること。

> **補足**: 処理対象データの出力により、派生元実行時情報（ウェブからバッチへのデータ連携時の画面処理実行時点のリクエストIDや実行IDなど）を障害ログに出力できる。詳細は :ref:`failure_log-output_src_exe_info` を参照。

**設定例**:
```properties
failureLogFormatter.className=nablarch.core.log.app.FailureLogFormatter
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.language=en
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.derivedRequestIdPropName=insertRequestId
failureLogFormatter.derivedUserIdPropName=updatedUserId
failureLogFormatter.contactFilePath=classpath:failure-log-contact.properties
failureLogFormatter.fwFailureCodeFilePath=classpath:failure-log-fw-codes.properties
```

<details>
<summary>keywords</summary>

failureLogFormatter.className, failureLogFormatter.defaultFailureCode, failureLogFormatter.defaultMessage, failureLogFormatter.language, failureLogFormatter.notificationFormat, failureLogFormatter.analysisFormat, failureLogFormatter.contactFilePath, failureLogFormatter.fwFailureCodeFilePath, FailureLogFormatter, プレースホルダ, 障害ログ設定, ThreadContext

</details>

## 障害ログに連絡先情報を追加する

障害ログにリクエストID毎の連絡先情報を含める機能。プロパティファイルにキー（リクエストID）と値（連絡先情報）を指定する。キーは `ThreadContext` から取得したリクエストIDに対して前方一致で検索する。読み込み後はより限定的なリクエストIDから検索するためキー名の長さの降順にソートされる（キー名の長さが等しいものは実行毎に順番が変わる）。

**failure-log-contact.properties 設定例**:
```properties
# リクエストID=連絡先情報
/users/=USRMGR999
/users/index=USRMGR300
/users/list=USRMGR301
/users/new=USRMGR302
/users/edit=USRMGR303
```

ソート後の検索順（キー名の長さの降順）:
```properties
/users/index=USRMGR300
/users/list=USRMGR301
/users/edit=USRMGR303
/users/new=USRMGR302
/users/=USRMGR999
```

フォーマットに `$contact$` プレースホルダを指定し、`failureLogFormatter.contactFilePath` でプロパティファイルパスを設定する。

**app-log.properties 設定例**:
```properties
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$] <$contact$>
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$ <$contact$>
failureLogFormatter.contactFilePath=classpath:failure-log-contact.properties
```

リクエストIDが `/users/new` の場合の出力例（`<>`で囲った部分に`USRMGR302`が出力される）:
```
# 障害通知ログ
2011-02-15 15:09:57.691 -FATAL- [APUSRMGR0001201102151509320020009] R[/users/new] U[0000000001] [UNEXPECTED_ERROR:an unexpected exception occurred.] <USRMGR302>

# 障害解析ログ
2011-02-15 15:09:57.707 -FATAL- [APUSRMGR0001201102151509320020009] R[/users/new] U[0000000001] fail_code = [UNEXPECTED_ERROR] an unexpected exception occurred. <USRMGR302>
```

リクエストIDに対応する連絡先情報が見つからない場合は`null`が出力される。

<details>
<summary>keywords</summary>

連絡先情報, contactFilePath, $contact$, リクエストID前方一致, failure-log-contact.properties, 障害連絡先, 大規模システム, ThreadContext

</details>

## フレームワークの障害コードを変更する

フレームワークが送出するRuntimeException系例外はデフォルト障害コードで障害ログが出力される。障害監視でフィルタリングできるよう、フレームワーク障害コードを変更する機能がある。

「例外が送出されたクラス」はスタックトレースのルート要素（最後の`Caused by`の送出クラス）を指す。プロパティファイルのキー（パッケージ名）はFQCNに前方一致で検索され、読み込み後はキー名の長さの降順にソートされる（より限定的なパッケージが優先）。基本はパッケージ名単位に指定する。

**failure-log-fw-codes.properties の設定例**:
```properties
nablarch=FW_ERROR
nablarch.core.cache=FW_CACHE_ERROR
nablarch.core.date=FW_DATE_ERROR
nablarch.core.db=FW_DB_ERROR
nablarch.core.message=FW_MESSAGE_ERROR
nablarch.core.repository=FW_REPOSITORY_ERROR
nablarch.core.transaction=FW_TRANSACTION_ERROR
```

読み込み後はキー名の長さの降順にソートされ、上から順に検索される:
```properties
nablarch.core.transaction=FW_TRANSACTION_ERROR
nablarch.core.repository=FW_REPOSITORY_ERROR
nablarch.core.message=FW_MESSAGE_ERROR
nablarch.core.cache=FW_CACHE_ERROR
nablarch.core.date=FW_DATE_ERROR
nablarch.core.db=FW_DB_ERROR
nablarch=FW_ERROR
```

**app-log.properties でプロパティファイルパスを指定**:
```properties
failureLogFormatter.fwFailureCodeFilePath=classpath:failure-log-fw-codes.properties
```

<details>
<summary>keywords</summary>

FailureLogFormatter, fwFailureCodeFilePath, フレームワーク障害コード変更, パッケージ名前方一致検索, 障害コードフィルタリング

</details>

## 派生元実行時情報を出力する

派生元実行時情報とは、前段処理（例: ウェブ処理）の実行時情報を後段処理（例: バッチ処理）の障害ログに出力する機能。後段処理の障害発生時に前段処理の追跡作業を軽減する。

プレースホルダ`$data$`を`analysisFormat`に指定すると、データリーダで読み込まれたデータが障害ログに出力される。前段処理でデータに実行時情報を含めておくことで、後段処理の障害発生時に前段処理の実行時情報が出力される。

データベースを使用したデータ連携での実行時情報カラム例:

| 項目 | カラム名 |
|---|---|
| リクエストID | INSERT_REQUEST_ID |
| 実行時ID | INSERT_EXECUTION_ID |
| ユーザID | UPDATED_USER_ID |

**app-log.properties の設定例**:
```properties
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

<details>
<summary>keywords</summary>

$data$プレースホルダ, 派生元実行時情報, データ連携障害ログ, 前段処理実行時情報出力, analysisFormat

</details>

## プレースホルダに対する出力処理をカスタマイズする

`$data$`はデフォルトでtoStringメソッドにより全データ項目が出力される。特定項目のマスクなどが必要な場合は以下の手順でカスタマイズする:

1. `LogItem` を実装したクラスを作成
2. `FailureLogFormatter` を継承し、`getLogItems(Map<String, String>)` をオーバーライドして`$data$`に対してカスタムクラスを設定
3. `app-log.properties`の`failureLogFormatter.className`に継承クラスを指定

フレームワーク提供の `DataItem` を継承して拡張可能。`FailureLogContext.getData()` で処理対象データを取得し、カスタム処理（マスク等）を適用する。`MaskingMapValueEditor` はフレームワークが提供するMap編集用のユーティリティで、マスク文字とマスク対象パターンを指定してMap値をマスクできる。

**FailureLogFormatter継承クラスの実装例**:
```java
public class CustomDataFailureLogFormatter extends FailureLogFormatter {
    @Override
    protected Map<String, LogItem<FailureLogContext>> getLogItems(Map<String, String> props) {
        Map<String, LogItem<FailureLogContext>> logItems = super.getLogItems(props);
        logItems.put("$data$", new CustomDataItem());
        return logItems;
    }
}
```

**app-log.properties の設定**:
```properties
failureLogFormatter.className=nablarch.core.log.app.CustomDataFailureLogFormatter
```

<details>
<summary>keywords</summary>

LogItem, FailureLogFormatter, DataItem, FailureLogContext, MaskingMapValueEditor, プレースホルダカスタマイズ, マスキング, getLogItems

</details>

## JSON形式の構造化ログとして出力する

:ref:`log-json_log_setting` でJSON形式ログを設定した場合、`FailureLogFormatter` では障害ログ各項目はmessageの値に文字列として出力される。各項目もJSONの値として出力するには `FailureJsonLogFormatter` を使用する。

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| failureLogFormatter.className | ○ | `nablarch.core.log.app.FailureJsonLogFormatter` を指定 |
| failureLogFormatter.defaultFailureCode | ○ | デフォルトの障害コード（障害コード指定なしの場合に使用） |
| failureLogFormatter.defaultMessage | ○ | デフォルトのメッセージ |
| failureLogFormatter.language | | 障害コードからメッセージ取得時の言語。未指定時は `ThreadContext` の言語を使用 |
| failureLogFormatter.notificationTargets | | 障害通知ログの出力項目（カンマ区切り） |
| failureLogFormatter.analysisTargets | | 障害解析ログの出力項目（カンマ区切り）。指定可能な出力項目とデフォルト設定は障害通知ログと同じ |
| failureLogFormatter.contactFilePath | | 連絡先情報プロパティファイルのパス（:ref:`failure_log-add_contact` 参照） |
| failureLogFormatter.fwFailureCodeFilePath | | フレームワーク障害コード変更情報プロパティファイルのパス（:ref:`failure_log-change_fw_failure_code` 参照） |
| failureLogFormatter.structuredMessagePrefix | | JSONマーカー文字列。デフォルト: `"$JSON$"` |

`notificationTargets`/`analysisTargets` に指定可能な出力項目（○ = デフォルト出力）:

| 出力項目 | プロパティ値 | デフォルト |
|---|---|---|
| 障害コード | failureCode | ○ |
| メッセージ | message | ○ |
| 処理対象データ | data | |
| 連絡先 | contact | |

> **重要**: `structuredMessagePrefix` を変更する場合、LogWriterの `structuredMessagePrefix` プロパティで `JsonLogFormatter` にも同じ値を設定すること（:ref:`log-basic_setting` 参照）。

**記述例**:
```properties
failureLogFormatter.className=nablarch.core.log.app.FailureJsonLogFormatter
failureLogFormatter.structuredMessagePrefix=$JSON$
failureLogFormatter.notificationTargets=failureCode,message,contact
failureLogFormatter.analysisTargets=failureCode,message,data
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
```

<details>
<summary>keywords</summary>

FailureJsonLogFormatter, JsonLogFormatter, ThreadContext, JSON構造化ログ, notificationTargets, analysisTargets, structuredMessagePrefix, failureLogFormatter.contactFilePath, failureLogFormatter.fwFailureCodeFilePath, failureLogFormatter.language, failureLogFormatter.defaultFailureCode, failureLogFormatter.defaultMessage

</details>
