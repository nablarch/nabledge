# 障害ログの出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/failure_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureLogUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/TransactionAbnormalEnd.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureLogFormatter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LogItem.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureLogFormatter.DataItem.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureJsonLogFormatter.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html)

## 障害ログの出力方針

## 障害ログの出力方針

| ログの種類 | ログレベル | ロガー名 |
|---|---|---|
| 障害通知ログ | FATAL、ERROR | MONITOR |
| 障害解析ログ | FATAL、ERROR | クラス名 |

障害通知ログはログ監視ツールで障害を検知するための専用ファイルに出力する（ロガー名: MONITOR）。障害解析ログはアプリケーション全体のログを出力するアプリケーションログに出力する。

log.propertiesの設定例:
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

# アプリケーションログの設定
loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appLog

# 障害通知ログの出力設定
loggers.MON.nameRegex=MONITOR
loggers.MON.level=ERROR
loggers.MON.writerNames=monitorLog
```

app-log.propertiesの設定例:
```properties
failureLogFormatter.defaultFailureCode=MSG99999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.language=ja
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

> **補足**: 大規模システムで障害時の連絡先が複数存在する場合、[failure_log-add_contact](#s3) を使用することで、リクエストID毎に連絡先情報をログに含めることができる。

フレームワークが送出した例外は全てデフォルトの障害コードで障害ログが出力される。障害コードは、スタックトレースのルート要素（例外が送出されたクラス）のFQCNに対してプロパティファイルで前方一致指定できる。

> **補足**: クラス毎の設定は細かすぎるため、基本はパッケージ名単位で障害コードを指定する。

プロパティファイルはキー名の長さの降順にソートされ、より限定的なパッケージ名から順に検索される。

**failure-log-fw-codes.properties 設定例**:

```properties
# フレームワークのパッケージ名=障害コード
nablarch=FW_ERROR
nablarch.core.cache=FW_CACHE_ERROR
nablarch.core.date=FW_DATE_ERROR
nablarch.core.db=FW_DB_ERROR
nablarch.core.message=FW_MESSAGE_ERROR
nablarch.core.repository=FW_REPOSITORY_ERROR
nablarch.core.transaction=FW_TRANSACTION_ERROR
```

読み込み後のソート順（上から順に検索）:

```properties
nablarch.core.transaction=FW_TRANSACTION_ERROR
nablarch.core.repository=FW_REPOSITORY_ERROR
nablarch.core.message=FW_MESSAGE_ERROR
nablarch.core.cache=FW_CACHE_ERROR
nablarch.core.date=FW_DATE_ERROR
nablarch.core.db=FW_DB_ERROR
nablarch=FW_ERROR
```

`failureLogFormatter.fwFailureCodeFilePath` にclasspathパスを指定してプロパティファイルを設定する。

**app-log.properties 設定例**:

```properties
failureLogFormatter.fwFailureCodeFilePath=classpath:failure-log-fw-codes.properties
```

<details>
<summary>keywords</summary>

障害通知ログ, 障害解析ログ, MONITOR, ログレベル, ロガー名, log.properties, app-log.properties, FailureLogFormatter, 障害ログ出力方針, fwFailureCodeFilePath, 障害コード変更, フレームワーク障害コード, パッケージ名単位, 前方一致, 降順ソート, failure-log-fw-codes.properties

</details>

## 障害ログを出力する

## 障害ログを出力する

障害ログの出力には `FailureLogUtil` を使用する。

```java
try {
    // 業務処理
} catch (UserNotFoundException e) {
    // 捕捉した例外、処理対象データ、障害コードを指定している。
    FailureLogUtil.logError(e, inputData, "USER_NOT_FOUND");
}
```

バッチ・メッセージングで障害検知時に業務処理を終了したい場合は、 `TransactionAbnormalEnd` または `ProcessAbnormalEnd` を送出し、例外ハンドラ（[global_error_handler](../handlers/handlers-global_error_handler.md) や [request_thread_loop_handler](../handlers/handlers-request_thread_loop_handler.md)）に障害ログの出力を依頼する。

```java
// 自ら例外を生成する場合
if (user == null) {
    // 終了コード、障害コードを指定している。
    throw new TransactionAbnormalEnd(100, "USER_NOT_FOUND");
}

// 例外を捕捉した場合
try {
    // 業務処理
} catch (UserNotFoundException e) {
    // 終了コード、捕捉した例外、障害コードを指定している。
    throw new ProcessAbnormalEnd(100, e, "USER_NOT_FOUND");
}
```

> **補足**: 上記例のように、障害ログの出力では、ログから障害内容を特定するために障害コードを指定する。障害コードのコード体系は、プロジェクト毎に規定すること。

障害ログに出力されるメッセージは [message](libraries-message.md) を使用して障害コードに対応するメッセージを取得する。メッセージが見つからない場合は、メッセージ取得処理で発生した例外をWARNレベルでログ出力し、障害ログには以下を出力する:

```
failed to get the message to output the failure log. failureCode = [<障害コード>]
```

障害コードの指定がない場合（例外ハンドラで例外を捕捉した場合など）は、設定で指定するデフォルトの :ref:`障害コード <failure_log-prop_default_failure_code>` と :ref:`メッセージ <failure_log-prop_default_message>` を出力する。

`$data$` プレースホルダを障害解析ログのフォーマットに指定すると、データリーダで読み込まれた処理対象データが障害ログに出力される。前段処理の実行時情報をデータに含めておくことで、後段処理の障害発生時に前段処理の追跡が可能になる。

**app-log.properties 設定例**:

```properties
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

データベース連携の場合、処理対象データ（`Input Data:`）に前段処理の実行時情報（例: `INSERT_REQUEST_ID`、`INSERT_EXECUTION_ID`、`UPDATED_USER_ID`）が出力される。

<details>
<summary>keywords</summary>

FailureLogUtil, TransactionAbnormalEnd, ProcessAbnormalEnd, 障害コード, 障害ログ出力, バッチ障害処理, 例外ハンドラ, メッセージ取得失敗, $data$, 派生元実行時情報, データ連携, 前段処理, 後段処理, analysisFormat, 処理対象データ

</details>

## 障害ログの設定

## 障害ログの設定

設定は [log-app_log_setting](libraries-log.md) で説明したプロパティファイルに行う。

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| failureLogFormatter.className | | `FailureLogFormatter` を実装したクラス。差し替える場合に指定する。 |
| failureLogFormatter.defaultFailureCode | ○ | デフォルトの障害コード。障害コードの指定がない場合に使用する。 |
| failureLogFormatter.defaultMessage | ○ | デフォルトのメッセージ。デフォルト障害コード使用時に出力する。 |
| failureLogFormatter.language | | メッセージ取得時の言語。未指定の場合は `ThreadContext` に設定されている言語を使用する。 |
| failureLogFormatter.notificationFormat | | 障害通知ログのフォーマット。デフォルト: `fail_code = [$failureCode$] $message$` |
| failureLogFormatter.analysisFormat | | 障害解析ログのフォーマット。プレースホルダとデフォルトは通知ログと同じ。 |
| failureLogFormatter.contactFilePath | | 連絡先情報を指定したプロパティファイルのパス。[failure_log-add_contact](#s3) 参照。 |
| failureLogFormatter.fwFailureCodeFilePath | | フレームワーク障害コードの変更情報を指定したプロパティファイルのパス。[failure_log-change_fw_failure_code](#s4) 参照。 |

フォーマットに指定可能なプレースホルダ:

| プレースホルダ | 説明 |
|---|---|
| $failureCode$ | 障害を一意に識別するコード |
| $message$ | 障害コードに対応するメッセージ |
| $data$ | 障害発生時の処理対象データ（toStringメソッドの出力） |
| $contact$ | 連絡先情報 |

> **補足**: `$data$`（処理対象データ）の出力により、障害ログに派生元実行時情報を出力できる。派生元実行時情報とは、例えば、ウェブからバッチ処理にデータ連携する場合であれば、画面処理を実行した時点の実行時情報（リクエストIDや実行時IDなど）がバッチ処理での派生元実行時情報となる。派生元実行時情報の出力方法は、[failure_log-output_src_exe_info](#) を参照。

> **重要**: システムのセキュリティ要件により、障害解析ログであっても個人情報や機密情報の出力が許されない場合は、[failure_log-placeholder_customize](#) を参照しプロジェクトでカスタマイズすること。

設定例:
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

`$data$` はデフォルトで `toString` メソッドにより全データ項目が出力される。特定項目のマスクなどカスタマイズが必要な場合は以下の手順で対応する。

1. `LogItem` を実装したクラスを作る（`DataItem` を継承して拡張することも可能）
2. `FailureLogFormatter` を継承し `FailureLogFormatter#getLogItems` をオーバーライドして `$data$` にカスタムクラスを設定する
3. `app-log.properties` で `failureLogFormatter.className` にカスタムクラスを指定する

**カスタム FailureLogFormatter 実装例**:

```java
public class CustomDataFailureLogFormatter extends FailureLogFormatter {

    @Override
    protected Map<String, LogItem<FailureLogContext>> getLogItems(Map<String, String> props) {
        Map<String, LogItem<FailureLogContext>> logItems = super.getLogItems(props);
        // CustomDataItemで$data$を上書き設定する
        logItems.put("$data$", new CustomDataItem());
        return logItems;
    }

    private static final class CustomDataItem extends DataItem {
        private static final char MASKING_CHAR = '*';
        private static final Pattern[] MASKING_PATTERNS
                = new Pattern[] { Pattern.compile(".*MOBILE_PHONE_NUMBER.*"),
                                  Pattern.compile(".*MAIL.*")};
        // フレームワークが提供するMap編集用のユーティリティ
        private MapValueEditor mapValueEditor
            = new MaskingMapValueEditor(MASKING_CHAR, MASKING_PATTERNS);

        @Override
        @SuppressWarnings("unchecked")
        public String get(FailureLogContext context) {
            // FailureLogContextのgetDataメソッドを呼び出し処理対象データを取得する
            Object data = context.getData();
            // Mapでない場合はフレームワークのデフォルト実装を呼び出す
            if (!(data instanceof Map)) {
                return super.get(context);
            }
            // Mapをマスクした文字列を返す（TreeMapでキーをソートして出力）
            Map<String, String> editedMap = new TreeMap<String, String>();
            for (Map.Entry<Object, Object> entry : ((Map<Object, Object>) data).entrySet()) {
                String key = entry.getKey().toString();
                editedMap.put(key, mapValueEditor.edit(key, entry.getValue()));
            }
            return editedMap.toString();
        }
    }
}
```

**app-log.properties での設定**:

```properties
failureLogFormatter.className=nablarch.core.log.app.CustomDataFailureLogFormatter
```

<details>
<summary>keywords</summary>

failureLogFormatter.defaultFailureCode, failureLogFormatter.defaultMessage, failureLogFormatter.language, failureLogFormatter.notificationFormat, failureLogFormatter.analysisFormat, failureLogFormatter.contactFilePath, failureLogFormatter.fwFailureCodeFilePath, failureLogFormatter.className, failureLogFormatter.derivedRequestIdPropName, failureLogFormatter.derivedUserIdPropName, derivedRequestIdPropName, derivedUserIdPropName, $failureCode$, $message$, $data$, $contact$, FailureLogFormatter, 障害ログ設定, 個人情報マスク, 派生元実行時情報, LogItem, DataItem, getLogItems, CustomDataItem, CustomDataFailureLogFormatter, $data$カスタマイズ, マスク処理, プレースホルダカスタマイズ, MaskingMapValueEditor, MapValueEditor, FailureLogContext

</details>

## 障害ログに連絡先情報を追加する

## 障害ログに連絡先情報を追加する

リクエストID毎に連絡先情報を障害ログに出力できる。連絡先情報はプロパティファイルに「リクエストID=連絡先情報」形式で指定する。

キーに指定されたリクエストIDは `ThreadContext` から取得したリクエストIDに対して前方一致で検索する。プロパティファイルは読み込み後、キー名の長さの降順にソートされ、より限定的なリクエストIDから検索する。

failure-log-contact.propertiesの設定例:
```properties
# リクエストID=連絡先情報
/users/=USRMGR999
/users/index=USRMGR300
/users/list=USRMGR301
/users/new=USRMGR302
/users/edit=USRMGR303
```

上記プロパティファイルは読み込み後、以下の順にソートされる（キー名の長さが等しいものは実行毎に順番が変わる）:
```properties
/users/index=USRMGR300
/users/list=USRMGR301
/users/edit=USRMGR303
/users/new=USRMGR302
/users/=USRMGR999
```

フォーマットに `$contact$` プレースホルダを指定し、`failureLogFormatter.contactFilePath` でプロパティファイルのパスを指定する:

```properties
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$] <$contact$>
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$ <$contact$>
failureLogFormatter.contactFilePath=classpath:failure-log-contact.properties
```

リクエストIDが `/users/new` の場合の出力例:
```
# 障害通知ログ
2011-02-15 15:09:57.691 -FATAL- [APUSRMGR0001201102151509320020009] R[/users/new] U[0000000001] [UNEXPECTED_ERROR:an unexpected exception occurred.] <USRMGR302>

# 障害解析ログ
2011-02-15 15:09:57.707 -FATAL- [APUSRMGR0001201102151509320020009] R[/users/new] U[0000000001] fail_code = [UNEXPECTED_ERROR] an unexpected exception occurred. <USRMGR302>
```

リクエストIDに対応する連絡先情報が見つからない場合はnullが出力される。

`FailureLogFormatter` では障害ログの各項目はmessageの文字列として出力される。各項目をJSONの値として出力するには `FailureJsonLogFormatter` を使用する（[log-json_log_setting](libraries-log.md) 設定と組み合わせて使用）。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| failureLogFormatter.className | ○ | | `nablarch.core.log.app.FailureJsonLogFormatter` を指定する |
| failureLogFormatter.defaultFailureCode | ○ | | デフォルトの障害コード |
| failureLogFormatter.defaultMessage | ○ | | デフォルトの障害コード使用時のメッセージ |
| failureLogFormatter.language | | ThreadContextの言語 | 障害コードからメッセージ取得時の言語（`ThreadContext` 参照） |
| failureLogFormatter.notificationTargets | | failureCode,message | 障害通知ログの出力項目（カンマ区切り）。指定可能値: `failureCode`, `message`, `data`, `contact` |
| failureLogFormatter.analysisTargets | | failureCode,message | 障害解析ログの出力項目（カンマ区切り）。指定可能値はnotificationTargetsと同じ |
| failureLogFormatter.contactFilePath | | | 障害連絡先情報のプロパティファイルのパス（[failure_log-add_contact](#s3) 参照） |
| failureLogFormatter.fwFailureCodeFilePath | | | フレームワーク障害コード変更情報のプロパティファイルのパス（[failure_log-change_fw_failure_code](#s4) 参照） |
| failureLogFormatter.structuredMessagePrefix | | `$JSON$` | JSON形式識別用のメッセージ先頭マーカー文字列。`JsonLogFormatter` にも同じ値を設定すること（[log-basic_setting](libraries-log.md) 参照） |

**設定例**:

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

ThreadContext, 連絡先情報, 前方一致, リクエストID, failure-log-contact.properties, contactFilePath, $contact$, 障害ログ連絡先, FailureJsonLogFormatter, JsonLogFormatter, failureLogFormatter.className, failureLogFormatter.notificationTargets, failureLogFormatter.analysisTargets, failureLogFormatter.structuredMessagePrefix, failureLogFormatter.language, failureLogFormatter.contactFilePath, failureLogFormatter.fwFailureCodeFilePath, failureLogFormatter.defaultFailureCode, failureLogFormatter.defaultMessage, JSON構造化ログ, 障害ログJSON出力

</details>
