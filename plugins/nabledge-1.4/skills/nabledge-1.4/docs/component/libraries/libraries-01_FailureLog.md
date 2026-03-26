# 障害ログの出力

## 障害ログの出力

障害ログはフレームワーク又はアプリケーションから出力する。フレームワークでは処理方式毎の例外ハンドラで出力し、アプリケーションではバッチ処理の障害発生時に後続処理を継続する場合などに出力する。

リクエストIDに1次切り分け担当者の連絡先情報をプロパティファイルで指定する機能。

- **プロパティファイル形式**: キー=リクエストID、値=連絡先情報
- 前方一致で検索（ThreadContextから取得したリクエストIDに対して）
- 読み込み後にキー名の長さの**降順にソート**（より限定的なリクエストIDが優先して検索される）
- 連絡先情報が見つからない場合は `null` が出力される

**failure-log-contact.properties 設定例**:
```bash
USERS=USRMGR999
USERS003=USRMGR300
USERS00301=USRMGR301
USERS00302=USRMGR302
USERS00303=USRMGR303
```

読み込み後のソート順（上から検索に使用）:
```bash
# 上3つの並び順は、キー名の長さが等しいため、実行毎に変わる。
USERS00301=USRMGR301
USERS00302=USRMGR302
USERS00303=USRMGR303
USERS003=USRMGR300
USERS=USRMGR999
```

| プロパティ名 | 説明 |
|---|---|
| `failureLogFormatter.contactFilePath` | 連絡先プロパティファイルのパス（例: `classpath:failure-log-contact.properties`） |
| `failureLogFormatter.notificationFormat` | `$contact$` プレースホルダで連絡先を出力 |
| `failureLogFormatter.analysisFormat` | `$contact$` プレースホルダで連絡先を出力 |

**app-log.properties 設定例**:
```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$] <$contact$>
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$ <$contact$>
failureLogFormatter.contactFilePath=classpath:failure-log-contact.properties
```

処理対象データ(`$data$`)はデフォルトでtoStringにより全データ項目が出力される。特定項目のマスク出力が必要な場合は、`FailureLogFormatter`を拡張し`LogItem`インタフェースを実装する。

カスタマイズ手順:
1. `DataItem`を継承したカスタムクラスを実装し、`get(FailureLogContext context)`をオーバーライド
2. `FailureLogFormatter`のサブクラスで`getLogItems`をオーバーライドし、`$data$`キーにカスタムクラスを設定
3. `app-log.properties`でカスタムフォーマッタクラスを指定

Map型でない場合は`super.get(context)`（デフォルト実装）を呼び出すこと。

`CustomDataItem`実装例（Map型のみマスクする`DataItem`サブクラス）:

```java
private static final class CustomDataItem extends DataItem {
    private static final char MASKING_CHAR = '*';
    private static final Pattern[] MASKING_PATTERNS
            = new Pattern[] { Pattern.compile(".*MOBILE_PHONE_NUMBER.*"),
                              Pattern.compile(".*MAIL.*")};
    private MapValueEditor mapValueEditor = new MaskingMapValueEditor(MASKING_CHAR, MASKING_PATTERNS);

    @Override
    public String get(FailureLogContext context) {
        Object data = context.getData();
        if (!(data instanceof Map)) {
            return super.get(context);
        }
        Map<String, String> editedMap = new TreeMap<String, String>();
        for (Map.Entry<Object, Object> entry : ((Map<Object, Object>) data).entrySet()) {
            String key = entry.getKey().toString();
            editedMap.put(key, mapValueEditor.edit(key, entry.getValue()));
        }
        return editedMap.toString();
    }
}
```

`FailureLogFormatter`拡張クラスの実装例（`CustomDataItem`はインナークラスとして定義する）:

```java
public class CustomDataFailureLogFormatter extends FailureLogFormatter {
    @Override
    protected Map<String, LogItem<FailureLogContext>> getLogItems(Map<String, String> props) {
        Map<String, LogItem<FailureLogContext>> logItems = super.getLogItems(props);
        logItems.put("$data$", new CustomDataItem());
        return logItems;
    }

    private static final class CustomDataItem extends DataItem {
        // 省略。
    }
}
```

`app-log.properties`設定例:

```
failureLogFormatter.className=nablarch.core.log.app.CustomDataFailureLogFormatter
failureLogFormatter.defaultFailureCode=MSG99999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

障害解析ログの出力例（`CustomDataItem`のマスク対象パターンにマッチするデータはマスクされて出力される）:

```
2011-09-26 21:06:35.745 -FATAL- root [EXECUTION_ID_0000000123456789] boot_proc = [] proc_sys = [] req_id = [RB11AC0160] usr_id = [batchuser1] fail_code = [NB11AA0107] ユーザ情報の登録に失敗しました。
Input Data :
{EXTENSION_NUMBER_BUILDING=13, EXTENSION_NUMBER_PERSONAL=1235, ..., MAIL_ADDRESS=********************, MOBILE_PHONE_NUMBER_AREA_CODE=***, MOBILE_PHONE_NUMBER_CITY_CODE=****, MOBILE_PHONE_NUMBER_SBSCR_CODE=****, ...}
```

`MAIL_ADDRESS`は`********************`、`MOBILE_PHONE_NUMBER_*`は`***`または`****`にマスクされる。

<details>
<summary>keywords</summary>

障害ログ, 例外ハンドラ, バッチ処理, フレームワーク出力, FailureLogFormatter, failureLogFormatter.contactFilePath, $contact$, 連絡先情報, リクエストID前方一致, 障害ログ連絡先, 1次切り分け担当者, DataItem, LogItem, FailureLogContext, MapValueEditor, MaskingMapValueEditor, CustomDataItem, CustomDataFailureLogFormatter, getLogItems, getData, TreeMap, プレースホルダカスタマイズ, 障害ログマスク処理, $data$プレースホルダ, FailureLogFormatter拡張

</details>

## 障害ログの出力方針

| ログの種類 | ログレベル | ロガー名 |
|---|---|---|
| 障害通知ログ | FATAL、ERROR | MONITOR |
| 障害解析ログ | FATAL、ERROR | 指定なし(クラス名) |

障害通知ログはロガー名`MONITOR`で障害通知専用ファイルに出力し、ログ監視ツールで障害を検知する。障害解析ログはアプリケーションログに出力する。

log.propertiesの設定例:

```bash
writerNames=monitorFile,appFile

# 障害通知ログの出力先
writer.monitorFile.className=nablarch.core.log.basic.SynchronousFileLogWriter
writer.monitorFile.filePath=/var/log/app/monitor.log
writer.monitorFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.monitorFile.formatter.format=<障害通知ログ用のフォーマット>
writer.monitorFile.lockFilePath=/var/log/lock/monitor.lock
writer.monitorFile.lockRetryInterval=10
writer.monitorFile.lockWaitTime=3000
writer.monitorFile.failureCodeCreateLockFile=MSG00101
writer.monitorFile.failureCodeReleaseLockFile=MSG00102
writer.monitorFile.failureCodeForceDeleteLockFile=MSG00103
writer.monitorFile.failureCodeInterruptLockWait=MSG00104

# アプリケーションログの出力先
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=/var/log/app/app.log
writer.appFile.maxFileSize=10000
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=<アプリケーションログ用のフォーマット>

availableLoggersNamesOrder=MON,ROO

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appFile

loggers.MON.nameRegex=MONITOR
loggers.MON.level=ERROR
loggers.MON.writerNames=monitorFile
```

TransactionAbnormalEnd/ProcessAbnormalEnd や FailureLogUtil を使用した障害コードを、ソース修正なしで実行時に変更できる機能。

- **プロパティファイル形式**: キー=ソース上の障害コード、値=出力に使用する障害コード
- 対応する出力コードが見つからない場合はソース上の障害コードをそのまま使用する

アプリケーションでは障害コードをソースコード上に直接ハードコーディングする。例:
```java
if (userId == null) {
    throw new ProcessAbnormalEnd(100, "UM900003");
}
```
この `"UM900003"` がプロパティファイルのキーに対応する障害コード文字列となる。

**failure-log-app-codes.properties 設定例**:
```bash
UM900003=MSG9003
```

| プロパティ名 | 説明 |
|---|---|
| `failureLogFormatter.appFailureCodeFilePath` | アプリケーション障害コードマッピングファイルのパス（例: `classpath:failure-log-app-codes.properties`） |

**app-log.properties 設定例**:
```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$]
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.appFailureCodeFilePath=classpath:failure-log-app-codes.properties
```

<details>
<summary>keywords</summary>

障害通知ログ, 障害解析ログ, MONITOR, SynchronousFileLogWriter, FileLogWriter, log.properties, ロガー名, BasicLogFormatter, FailureLogFormatter, failureLogFormatter.appFailureCodeFilePath, TransactionAbnormalEnd, ProcessAbnormalEnd, FailureLogUtil, 障害コード変更, アプリケーション障害コード

</details>

## 障害ログの出力項目

| 項目名 | 説明 | 障害通知 | 障害解析 |
|---|---|---|---|
| 出力日時 | ログ出力時のシステム日時 | Y | Y |
| 障害レベル | 障害のレベル判断に使用 | Y | Y |
| 障害コード | 障害を一意に識別するコード。障害内容の特定に使用。 | Y | Y |
| 起動プロセス | 障害発生アプリケーションを起動したプロセス名。実行環境の特定に使用。 | Y | Y |
| 処理方式区分 | 障害発生処理方式の特定に使用 | Y | Y |
| リクエストID | 障害発生処理を一意識別するID。1次切り分け担当者の特定に使用。 | Y | Y |
| 実行時ID | 障害発生処理の実行を一意識別するID | Y | Y |
| ユーザID | ログインユーザのID | Y | Y |
| メッセージ | 障害コードに対応するメッセージ。障害内容の特定に使用。 | Y | Y |
| 処理対象データ | 障害発生処理が対象としていたデータ。データリーダで読み込まれたオブジェクトのtoStringを呼び出して出力。 |  | Y |
| スタックトレース | 障害発生箇所の特定に使用 |  | Y |
| 付加情報 | フレームワーク又はアプリケーションで追加する付加情報 |  | Y |

障害ログの個別項目（残りは :ref:`Log_BasicLogFormatter` の設定で指定する共通項目。フォーマットの詳細は :ref:`AppLog_Format` 参照）:
- 障害コード
- メッセージ
- 処理対象データ

> **警告**: システムのセキュリティ要件により障害解析ログであっても個人情報や機密情報の出力が許されない場合は、処理対象データの出力処理をプロジェクトでカスタマイズすること。カスタマイズ方法は :ref:`FailureLog_PlaceholderCustomize` を参照。

> **注意**: 障害通知ログのリクエストIDには1次切り分け担当者を特定できる情報（業務コードなど）を含める必要がある。含められない場合は :ref:`FailureLog_Contact` を使用してリクエストID毎に連絡先情報をログに含めることができる。

> **注意**: 起動プロセスとリクエストIDのID体系はシステム規模に応じてプロジェクト毎に規定する（例: 大規模システムでは起動プロセス=サーバ名(8桁)+識別文字列(4桁)、リクエストID=システムID(1桁)+サブシステムID(2桁)+業務コード(3桁)+画面ID(2桁)+イベントID(2桁)）。

> **注意**: 処理対象データの出力により障害ログに派生元実行時情報を出力できる（例: 画面処理からバッチ処理にデータ連携する場合、画面処理時点の実行時情報がバッチ処理での派生元実行時情報となる）。詳細は :ref:`FailureLog_DerivedExecutionInfo` を参照。

フレームワークが送出した例外（RuntimeException系）に対して、障害コードをパッケージ名単位で指定できる機能。

- **「例外が送出されたクラス」**: スタックトレースのルート要素のFQCN
- **プロパティファイル形式**: キー=フレームワークのパッケージ名、値=障害コード
- FQCNに対して前方一致で検索
- 読み込み後にキー名の長さの**降順にソート**（より限定的なパッケージ名が優先して検索される）
- `nablarch` を指定すると個別に設定されていない全パッケージに対して障害コードを指定できる
- クラス毎に障害コードを設定するのは分類が細かすぎるため現実的ではない。**基本はパッケージ名単位**で障害コードを指定し、フレームワークのどの機能で例外が送出されたか判断する

**failure-log-fw-codes.properties 設定例**:
```bash
nablarch=FW999999
nablarch.core.cache=FW020100
nablarch.core.date=FW020200
nablarch.core.db=FW020300
nablarch.core.message=FW020400
nablarch.core.repository=FW020500
nablarch.core.transaction=FW020600
```

読み込み後のソート順（上から検索に使用）:
```bash
nablarch.core.transaction=FW020600
nablarch.core.repository=FW020500
nablarch.core.message=FW020400
nablarch.core.cache=FW020100
nablarch.core.date=FW020200
nablarch.core.db=FW020300
nablarch=FW999999
```

| プロパティ名 | 説明 |
|---|---|
| `failureLogFormatter.fwFailureCodeFilePath` | フレームワーク障害コードマッピングファイルのパス（例: `classpath:failure-log-fw-codes.properties`） |

**app-log.properties 設定例**:
```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$]
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.fwFailureCodeFilePath=classpath:failure-log-fw-codes.properties
```

<details>
<summary>keywords</summary>

障害コード, リクエストID, 処理対象データ, スタックトレース, 障害ログ出力項目, FailureLog_Contact, 派生元実行時情報, FailureLogFormatter, failureLogFormatter.fwFailureCodeFilePath, 障害コード変更, フレームワーク障害コード, パッケージ名前方一致, RuntimeException, FQCN

</details>

## 障害ログの出力方法

| クラス名 | 概要 |
|---|---|
| `nablarch.core.log.app.FailureLogUtil` | 障害ログを出力するクラス |
| `nablarch.core.log.app.FailureLogFormatter` | 障害ログの個別項目をフォーマットするクラス |
| `nablarch.fw.TransactionAbnormalEnd` | トランザクションデータ処理中に異常が発生した場合に送出する例外クラス。例外ハンドラに捕捉され障害ログ出力に使用。障害コードを指定することで対応するメッセージが出力される。 |
| `nablarch.fw.launcher.ProcessAbnormalEnd` | アプリケーションを異常終了させる際に送出する例外クラス。`TransactionAbnormalEnd`を継承し使用方法は同じ。 |

障害ログの出力方法の選択:
- **業務処理を終了する場合**: `TransactionAbnormalEnd`または`ProcessAbnormalEnd`を使用。
- **後続処理を継続する場合**: `FailureLogUtil`を使用。`FailureLogUtil`は例外を送出しないのでトランザクションがコミットされる。

ProcessAbnormalEndの使用例（TransactionAbnormalEndも同じ実装）:

```java
// バリデーションエラーの場合
ValidationContext<UserForm> context = 
    ValidationUtil.validateAndConvertRequest("user", UserForm.class, inputData, "registerUser");
if (!context.isValid()) {
    // 終了コード、バリデーションの例外、障害コードを指定している。
    // 終了コードとはプロセスを終了する際に System#exit(int) メソッドに設定する値である。
    throw new ProcessAbnormalEnd(100, new ApplicationException(context.getMessages()), "UM900001");
}

// 自ら例外を生成する場合
if (user == null) {
    throw new ProcessAbnormalEnd(100, "UM900002");
}

// 例外を捕捉した場合
try {
    // 業務処理
} catch (UserNotFoundException e) {
    throw new ProcessAbnormalEnd(100, e, "UM900003");
}
```

FailureLogUtilの使用例:

```java
// 障害を検知した場合
if (user == null) {
    FailureLogUtil.logError(inputData, "UM800001");
}

// 例外を捕捉した場合
try {
    // 業務処理
} catch (UserNotFoundException e) {
    FailureLogUtil.logError(e, inputData, "UM800001");
}
```

障害コードのコード体系はプロジェクト毎に規定する。障害コードからメッセージは [../../01_Core/07_Message](libraries-07_Message.md) 機能で取得する。メッセージが見つからない場合はWARNレベルでログ出力し、障害ログには以下を出力する:

```bash
failed to get the message to output the failure log. failureCode = [<障害コード>]
```

メッセージが見つからない場合の障害通知ログの出力例:

```bash
# 障害コード(fail_code = [AP112233])の後にメッセージを出力している。
2011-02-23 18:23:45.680 -FATAL- usr_id = [9999999999] fail_code = [AP112233] failed to get the message to output the failure log. failureCode = [AP112233]
```

アプリケーションの障害コード変更は :ref:`FailureLog_AppMsgId` を参照。フレームワーク例外の障害コード変更は :ref:`FailureLog_FwMsgId` を参照。障害コード指定がない場合はデフォルトの障害コードとメッセージを出力する。

後段処理（例: バッチ処理）の障害発生時に、前段処理（例: 画面処理）の実行時情報を出力する機能。

- プレースホルダ `$data$` を使用すると、データリーダが読み込んだデータが障害ログに出力される
- 前段処理で [db-object-store-label](libraries-04_ObjectSave.md) を使用して予め実行時情報をデータに含めておくことで、後段処理の障害発生時に前段処理の実行時情報が出力される
- スレッドコンテキストのリクエストID・実行時ID・ユーザIDをオブジェクトに設定するアノテーションを提供。詳細は [AutoPropertyHandlerの実装クラス](libraries-04_ObjectSave.md) を参照

**app-log.properties 設定例** (`$data$` プレースホルダを analysisFormat に指定):
```bash
failureLogFormatter.defaultFailureCode=MSG99999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

<details>
<summary>keywords</summary>

FailureLogUtil, FailureLogFormatter, TransactionAbnormalEnd, ProcessAbnormalEnd, 障害ログ出力方法, logError, 障害コード, UserNotFoundException, ApplicationException, failureLogFormatter.analysisFormat, $data$, 派生元実行時情報, バッチ処理データ連携, db-object-store-label, 前段処理, 後段処理, AutoPropertyHandler

</details>

## 障害ログの設定方法

FailureLogUtilはapp-log.propertiesを読み込みFailureLogFormatterオブジェクトを生成して個別項目のフォーマット処理を委譲する。プロパティファイルのパス指定や実行時の設定値変更方法は :ref:`AppLog_Config` を参照。

app-log.propertiesの設定例:

```bash
failureLogFormatter.className=nablarch.core.log.app.FailureLogFormatter
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.language=en
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.derivedRequestIdPropName=insertRequestId
failureLogFormatter.derivedUserIdPropName=updatedUserId
failureLogFormatter.contactFilePath=classpath:failure-log-contact.properties
failureLogFormatter.appFailureCodeFilePath=classpath:failure-log-app-codes.properties
failureLogFormatter.fwFailureCodeFilePath=classpath:failure-log-fw-codes.properties
```

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| failureLogFormatter.className | | FailureLogFormatterのクラス名。デフォルト: `nablarch.core.log.app.FailureLogFormatter`。差し替える場合に指定。 |
| failureLogFormatter.defaultFailureCode | ○ | デフォルトの障害コード。RuntimeException捕捉時など障害コード指定がない場合に使用。 |
| failureLogFormatter.defaultMessage | ○ | デフォルトのメッセージ。デフォルト障害コード使用時に出力。 |
| failureLogFormatter.language | | メッセージ取得時の言語。未指定時はThreadContextに設定されている言語を使用。 |
| failureLogFormatter.notificationFormat | | 障害通知ログの個別項目フォーマット |
| failureLogFormatter.analysisFormat | | 障害解析ログの個別項目フォーマット |
| failureLogFormatter.contactFilePath | | 障害の連絡先情報プロパティファイルのパス。詳細は :ref:`FailureLog_Contact` 参照。 |
| failureLogFormatter.appFailureCodeFilePath | | アプリケーションの障害コード変更情報プロパティファイルのパス。詳細は :ref:`FailureLog_AppMsgId` 参照。 |
| failureLogFormatter.fwFailureCodeFilePath | | フレームワークの障害コード変更情報プロパティファイルのパス。詳細は :ref:`FailureLog_FwMsgId` 参照。 |

フォーマットに指定可能なプレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| 障害コード | `$failureCode$` |
| メッセージ | `$message$` |
| 処理対象データ | `$data$` |
| 連絡先 | `$contact$` |

デフォルトフォーマット: `fail_code = [$failureCode$] $message$`

<details>
<summary>keywords</summary>

failureLogFormatter.defaultFailureCode, failureLogFormatter.defaultMessage, failureLogFormatter.language, failureLogFormatter.notificationFormat, failureLogFormatter.analysisFormat, failureLogFormatter.appFailureCodeFilePath, failureLogFormatter.fwFailureCodeFilePath, failureLogFormatter.derivedRequestIdPropName, failureLogFormatter.derivedUserIdPropName, $failureCode$, $message$, $data$, $contact$, app-log.properties, FailureLogFormatter, failureLogFormatter.contactFilePath

</details>

## 障害ログの出力例

データベースに接続できない障害が発生したケース。FailureLogFormatterのデフォルト障害コードとメッセージが出力される。

app-log.propertiesの設定例:

```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$]
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
```

log.propertiesの設定例:

```bash
writerNames=monitorFile,appFile

# 障害通知ログの出力先
writer.monitorFile.className=nablarch.core.log.basic.SynchronousFileLogWriter
writer.monitorFile.filePath=/var/log/app/monitor.log
writer.monitorFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.monitorFile.formatter.format=$date$ -$logLevel$- [$executionId$] R[$requestId$] U[$userId$] $message$
writer.monitorFile.lockFilePath=/var/log/lock/monitor.lock
writer.monitorFile.lockRetryInterval=10
writer.monitorFile.lockWaitTime=3000
writer.monitorFile.failureCodeCreateLockFile=MSG00101
writer.monitorFile.failureCodeReleaseLockFile=MSG00102
writer.monitorFile.failureCodeForceDeleteLockFile=MSG00103
writer.monitorFile.failureCodeInterruptLockWait=MSG00104

# アプリケーションログの出力先
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=/var/log/app/app.log
writer.appFile.maxFileSize=10000
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=$date$ -$logLevel$- [$executionId$] R[$requestId$] U[$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=MON,ROO

# アプリケーションログの設定
loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appFile

# 障害通知ログの出力設定
loggers.MON.nameRegex=MONITOR
loggers.MON.level=ERROR
loggers.MON.writerNames=monitorFile
```

ログの出力例:

```bash
# 障害通知ログ
2011-02-15 14:47:17.745 -FATAL- [APUSRMGR0001201102151447176990004] R[USERS00101] U[0000000001] [ZZ999999:an unexpected exception occurred.]

# 障害解析ログ
2011-02-15 14:47:17.745 -FATAL- [APUSRMGR0001201102151447176990004] R[USERS00101] U[0000000001] fail_code = [ZZ999999] an unexpected exception occurred.
Stack Trace Information : 
nablarch.core.db.DbAccessException: failed to get database connection.
    at nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource.getConnection(BasicDbConnectionFactoryForDataSource.java:35)
    at nablarch.common.handler.DbConnectionManagementHandler.handle(DbConnectionManagementHandler.java:72)
```

<details>
<summary>keywords</summary>

障害ログ出力例, ZZ999999, 障害通知ログ, 障害解析ログ, DbAccessException

</details>
