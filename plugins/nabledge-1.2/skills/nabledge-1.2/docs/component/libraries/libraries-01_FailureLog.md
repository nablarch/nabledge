# 障害ログの出力

## 障害ログの出力

障害ログはフレームワーク（処理方式毎の例外ハンドラ）またはアプリケーション（バッチ処理の障害発生時に後続処理を継続する場合など）から出力される。

リクエストIDに1次切り分け担当者情報を含められない場合、プロパティファイルでリクエストID毎の連絡先情報を指定できる。

- キー: リクエストID（ThreadContextから取得したリクエストIDに対して前方一致検索）
- 値: 連絡先情報
- 読み込み後、キー名の長さの降順にソートされ、より限定的（長い）リクエストIDから優先検索される
- 対応する連絡先情報が見つからない場合は `null` が出力される

**プレースホルダ**: `$contact$`（フォーマットに指定して連絡先情報を埋め込む）

**プロパティ**: `failureLogFormatter.contactFilePath` — 連絡先情報プロパティファイルのクラスパスを指定

`failure-log-contact.properties` 設定例:
```bash
USERS=USRMGR999
USERS003=USRMGR300
USERS00301=USRMGR301
USERS00302=USRMGR302
USERS00303=USRMGR303
```

ソート後の検索順（キー名長降順）:
```bash
# 上3つの並び順は、キー名の長さが等しいため、実行毎に変わる。
USERS00301=USRMGR301
USERS00302=USRMGR302
USERS00303=USRMGR303
USERS003=USRMGR300
USERS=USRMGR999
```

`app-log.properties` 設定例（FailureLogFormatterの設定）:
```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$] <$contact$>
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$ <$contact$>
failureLogFormatter.contactFilePath=classpath:failure-log-contact.properties
```

リクエストID "USERS00302" の障害出力例:
```bash
# 障害通知ログ
2011-02-15 15:09:57.691 -FATAL- [APUSRMGR0001201102151509320020009] R[USERS00302] U[0000000001] [ZZ999999:an unexpected exception occurred.] <USRMGR302>
# 障害解析ログ
2011-02-15 15:09:57.707 -FATAL- [APUSRMGR0001201102151509320020009] R[USERS00302] U[0000000001] fail_code = [ZZ999999] an unexpected exception occurred. <USRMGR302>
```

連絡先情報が見つからない場合の出力例（リクエストID "USERS00333"）:
```bash
# プロパティファイルにリクエストID"USERS00333"が定義されていないので連絡先情報はnullとなる。
2011-02-15 15:09:57.691 -FATAL- [APUSRMGR0001201102151509320020009] R[USERS00333] U[0000000001] [ZZ999999:an unexpected exception occurred.] <null>
```

`$data$`プレースホルダへの出力処理カスタマイズには、`FailureLogFormatter`の拡張と`LogItem`インタフェースの実装が必要。デフォルトでは`$data$`はtoStringで全データ項目を出力する。

**カスタマイズ手順**:
1. `DataItem`を継承したクラスで`get(FailureLogContext context)`をオーバーライドし、出力内容をカスタマイズ
2. `FailureLogFormatter`を継承したクラスで`getLogItems(Map<String, String> props)`をオーバーライドし、`$data$`キーにカスタム実装を設定
3. `app-log.properties`の`failureLogFormatter.className`にカスタムクラスを指定

**CustomDataItem実装例（Map型データのみマスク処理）**:
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

**FailureLogFormatter拡張例**:
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

**app-log.properties設定例**:
```properties
failureLogFormatter.className=nablarch.core.log.app.CustomDataFailureLogFormatter
failureLogFormatter.defaultFailureCode=MSG99999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

**障害解析ログの出力例**（`CustomDataItem`に定義したマスク対象パターンにマッチするフィールドはマスクされて出力される）:
```
# 障害解析ログ
2011-09-26 21:06:35.745 -FATAL- root [EXECUTION_ID_0000000123456789] boot_proc = [] proc_sys = [] req_id = [RB11AC0160] usr_id = [batchuser1] fail_code = [NB11AA0107] ユーザ情報の登録に失敗しました。
Input Data :
{EXTENSION_NUMBER_BUILDING=13, EXTENSION_NUMBER_PERSONAL=1235, INSERT_EXECUTION_ID=EXECUTION_ID_2000000123456789, INSERT_REQUEST_ID=RB11AC0140, KANA_NAME=ヤマモトタロウ, KANJI_NAME=山本太郎, LOGIN_ID=12345678901234567890, MAIL_ADDRESS=********************, MOBILE_PHONE_NUMBER_AREA_CODE=***, MOBILE_PHONE_NUMBER_CITY_CODE=****, MOBILE_PHONE_NUMBER_SBSCR_CODE=****, UPDATED_USER_ID=batch_user, USER_INFO_ID=00000000000000000113}
```

<details>
<summary>keywords</summary>

障害ログ, FailureLog, 障害通知ログ, 障害解析ログ, 例外ハンドラ, バッチ処理障害, 連絡先情報, contactFilePath, $contact$, FailureLogFormatter, 1次切り分け担当者, リクエストID前方一致, failure-log-contact.properties, DataItem, CustomDataItem, FailureLogContext, LogItem, CustomDataFailureLogFormatter, MaskingMapValueEditor, MapValueEditor, 障害ログ プレースホルダ カスタマイズ, $data$ マスク処理, FailureLogFormatter拡張, getLogItems オーバーライド, failureLogFormatter.className, 障害解析ログ 出力例, MAIL_ADDRESS マスク, MOBILE_PHONE_NUMBER マスク

</details>

## 障害ログの出力方針

| ログ種類 | ログレベル | ロガー名 |
|---|---|---|
| 障害通知ログ | FATAL、ERROR | MONITOR |
| 障害解析ログ | FATAL、ERROR | 指定なし（クラス名） |

障害通知ログはロガー名 `MONITOR` を付けて障害通知専用ファイルへ出力し、ログ監視ツールで監視する。障害解析ログはアプリケーションログへ出力する。

log.properties設定例:
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

# アプリケーションログの設定
loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appFile

# 障害通知ログの出力設定
loggers.MON.nameRegex=MONITOR
loggers.MON.level=ERROR
loggers.MON.writerNames=monitorFile
```

アプリケーションでは、`TransactionAbnormalEnd`（`ProcessAbnormalEnd`）や `FailureLogUtil` を使用して障害ログの出力を行う。ソースコードを修正せずに、実行時にハードコードされた障害コードを変更できる。プロパティファイルに「ソース上の障害コード→出力に使用する障害コード」を指定する。

- 対応する障害コードが見つからない場合は、ソース上で指定された障害コードをそのまま使用する

> **注意**: `TransactionAbnormalEnd` の使用方法は `ProcessAbnormalEnd` と全く同じ。

`ProcessAbnormalEnd` の使用例:
```java
if (userId == null) {
    throw new ProcessAbnormalEnd(100, "UM900003");
}
```

**プロパティ**: `failureLogFormatter.appFailureCodeFilePath` — 障害コードマッピングのプロパティファイルのクラスパスを指定

`failure-log-app-codes.properties` 設定例:
```bash
# ソース上の障害コード=出力に使用する障害コード
UM900003=MSG9003
```

`app-log.properties` 設定例（FailureLogFormatterの設定）:
```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$]
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.appFailureCodeFilePath=classpath:failure-log-app-codes.properties
```

`ProcessAbnormalEnd` が障害コード "UM900003" で送出された場合の出力例（"MSG9003" に変換）:
```bash
# 障害通知ログ
2011-02-15 15:52:30.394 -FATAL- [APUSRMGR0001201102151552085470006] R[USERS00302] U[0000000001] [MSG9003:userId was invalid.]
# 障害解析ログ
2011-02-15 15:52:30.394 -FATAL- [APUSRMGR0001201102151552085470006] R[USERS00302] U[0000000001] fail_code = [MSG9003] userId was invalid.
```

<details>
<summary>keywords</summary>

障害通知ログ, 障害解析ログ, MONITOR, ロガー名, SynchronousFileLogWriter, FileLogWriter, log.properties, 出力方針, アプリケーション障害コード変更, appFailureCodeFilePath, ProcessAbnormalEnd, TransactionAbnormalEnd, FailureLogUtil, FailureLogFormatter, ハードコード障害コード変更, failure-log-app-codes.properties

</details>

## 障害ログの出力項目

| 項目名 | 説明 | 障害通知 | 障害解析 |
|---|---|---|---|
| 出力日時 | ログ出力時のシステム日時 | Y | Y |
| 障害レベル | 障害のレベルを判断するために使用 | Y | Y |
| 障害コード | 障害を一意に識別するコード。障害内容の特定に使用 | Y | Y |
| 起動プロセス | 障害が発生したアプリケーションを起動したプロセス名。実行環境の特定に使用 | Y | Y |
| 処理方式区分 | 障害が発生した処理方式の特定に使用 | Y | Y |
| リクエストID | 障害が発生した処理を一意に識別するID。1次切り分け担当者の特定に使用 | Y | Y |
| 実行時ID | 障害が発生した処理の実行を一意に識別するID | Y | Y |
| ユーザID | ログインユーザのユーザID | Y | Y |
| メッセージ | 障害コードに対応するメッセージ | Y | Y |
| 処理対象データ | データリーダで読み込まれたデータオブジェクトのtoString結果 | | Y |
| スタックトレース | 障害発生箇所の特定に使用 | | Y |
| 付加情報 | フレームワーク又はアプリケーションで追加する付加情報 | | Y |

障害ログの個別項目は「障害コード」「メッセージ」「処理対象データ」。残りは :ref:`Log_BasicLogFormatter` の設定で指定する共通項目。フォーマットの詳細は :ref:`AppLog_Format` を参照。

リクエストIDには1次切り分け担当者を特定できる情報（業務コードなど）を含める必要がある。含められない場合は :ref:`FailureLog_Contact` を使用することでリクエストID毎に連絡先情報をログに含められる。

> **注意**: 起動プロセスとリクエストIDは、システムの規模に応じてプロジェクト毎にID体系を規定する。例えば、大規模なシステムでは下記のようなID体系となる。
> - **起動プロセス**: サーバ名(8桁)＋識別文字列(4桁)　※識別文字列にはバッチ処理のJOBIDなどが入る
> - **リクエストID**: システムID(1桁)＋サブシステムID(2桁)＋業務コード(3桁)＋画面ID(2桁)＋イベントID(2桁)

> **警告**: セキュリティ要件により障害解析ログであっても個人情報・機密情報の出力が許されない場合は、処理対象データの出力処理をプロジェクトでカスタマイズすること。カスタマイズ方法は :ref:`FailureLog_PlaceholderCustomize` を参照。

> **注意**: 処理対象データの出力により派生元実行時情報（例：画面処理からバッチ処理へデータ連携する場合の画面処理実行時のリクエストIDや実行時IDなど）を障害ログに出力できる。詳細は :ref:`FailureLog_DerivedExecutionInfo` を参照。

フレームワークが送出した例外は全てデフォルトの障害コードが使用される。プロパティファイルで例外が送出されたクラスのFQCN（スタックトレースのルート要素）に対して前方一致で障害コードを検索する。

- クラス毎の設定は細かすぎて現実的でないため、パッケージ名単位での指定を推奨
- キーに指定されたパッケージ名はFQCNに対して前方一致検索される
- 読み込み後、キー名の長さの降順にソートされ、より限定的（長い）パッケージ名から優先検索される
- `nablarch` を指定することで、個別指定のない全Nablarchパッケージのデフォルト障害コードを設定できる

> **注意**: 「例外が送出されたクラス」とは、スタックトレースのルート要素を指す。

**プロパティ**: `failureLogFormatter.fwFailureCodeFilePath` — フレームワーク障害コードのプロパティファイルのクラスパスを指定

`failure-log-fw-codes.properties` 設定例:
```bash
# フレームワークのパッケージ名=障害コード
nablarch=FW999999
nablarch.core.cache=FW020100
nablarch.core.date=FW020200
nablarch.core.db=FW020300
nablarch.core.message=FW020400
nablarch.core.repository=FW020500
nablarch.core.transaction=FW020600
```

ソート後の検索順（キー名長降順）:
```bash
nablarch.core.transaction=FW020600
nablarch.core.repository=FW020500
nablarch.core.message=FW020400
nablarch.core.cache=FW020100
nablarch.core.date=FW020200
nablarch.core.db=FW020300
nablarch=FW999999
```

`app-log.properties` 設定例（FailureLogFormatterの設定）:
```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$]
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.fwFailureCodeFilePath=classpath:failure-log-fw-codes.properties
```

出力例:
- `nablarch.core.date.BasicBusinessDateProvider` で例外発生 → プロパティの `nablarch.core.date=FW020200` が該当
- `nablarch.core.message.StringResourceHolder` で例外発生（`MessageNotFoundException` が Caused by）→ プロパティの `nablarch.core.message=FW020400` が該当
- `nablarch.common.authentication.PasswordAuthenticator` で例外発生 → `nablarch.common` の個別指定なしのため `nablarch=FW999999` が該当

<details>
<summary>keywords</summary>

障害コード, リクエストID, 処理対象データ, スタックトレース, FailureLog_Contact, FailureLog_PlaceholderCustomize, FailureLog_DerivedExecutionInfo, 出力項目, 1次切り分け, 派生元実行時情報, フレームワーク障害コード, fwFailureCodeFilePath, FailureLogFormatter, パッケージ名前方一致, FQCN, RuntimeException, failure-log-fw-codes.properties, BasicBusinessDateProvider, StringResourceHolder, PasswordAuthenticator, MessageNotFoundException

</details>

## 障害ログの出力方法

- **`nablarch.core.log.app.FailureLogUtil`**: 障害ログを出力するクラス
- **`nablarch.core.log.app.FailureLogFormatter`**: 障害ログの個別項目をフォーマットするクラス
- **`nablarch.fw.TransactionAbnormalEnd`**: トランザクションデータ処理中の異常時に送出する例外クラス。フレームワークの例外ハンドラに捕捉され障害ログ出力に使用される。障害コードを指定すると対応するメッセージが出力される。
- **`nablarch.fw.launcher.ProcessAbnormalEnd`**: アプリケーション異常終了時に送出する例外クラス。`TransactionAbnormalEnd` を継承しており使用方法は同じ。

障害ログ出力の2通りの方法:
1. `FailureLogUtil` で直接出力する — 後続処理を継続する場合
2. `TransactionAbnormalEnd` や `ProcessAbnormalEnd` を送出し例外ハンドラに出力依頼する — 業務処理を終了する場合

> **重要**: `FailureLogUtil` を使用した場合は例外が送出されないためトランザクションがコミットされる。

ProcessAbnormalEnd使用例（TransactionAbnormalEndも同様）:
```java
// バリデーションエラーの場合
ValidationContext<UserForm> context = 
    ValidationUtil.validateAndConvertRequest("user", UserForm.class, inputData, "registerUser");
if (!context.isValid()) {
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

FailureLogUtil使用例:
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

障害コードのコード体系はプロジェクト毎に規定する。障害ログのメッセージは [../../01_Core/07_Message](libraries-07_Message.md) 機能で取得する。メッセージが見つからない場合は別途WARNレベルでログ出力し、障害ログには `failed to get the message to output the failure log. failureCode = [<障害コード>]` を出力する。

アプリケーションの障害コード変更は :ref:`FailureLog_AppMsgId`、フレームワーク例外の障害コード変更は :ref:`FailureLog_FwMsgId` を参照。障害コード指定がない場合は設定のデフォルト障害コードとメッセージを出力する。

前段処理から後段処理にデータ連携する場合、後段処理の障害ログに前段処理の実行時情報を出力できる。

- プレースホルダ `$data$` をフォーマットに指定すると、データリーダで読み込まれたデータが出力される
- 前段処理において予め実行時情報をデータに含めておくことで、後段処理の障害発生時に前段処理の実行時情報が出力される
- 前段処理の実行時情報設定には [db-object-store-label](libraries-04_ObjectSave.md) を使用（リクエストID・実行時ID・ユーザIDをオブジェクトに設定するアノテーションを提供）
- アノテーションの詳細については [AutoPropertyHandlerの実装クラス](libraries-04_ObjectSave.md) を参照

データ連携カラム例（前段処理で設定する実行時情報のカラム名）:

| 項目 | カラム名 |
|---|---|
| リクエストID | INSERT_REQUEST_ID |
| 実行時ID | INSERT_EXECUTION_ID |
| ユーザID | UPDATED_USER_ID |

`app-log.properties` 設定例（`$data$` を障害解析ログフォーマットに指定）:
```bash
failureLogFormatter.defaultFailureCode=MSG99999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

障害解析ログ出力例（Input Data セクションに前段処理の実行時情報が含まれる）:
```bash
2011-09-26 21:06:35.745 -FATAL- root [EXECUTION_ID_0000000123456789] boot_proc = [] proc_sys = [] req_id = [RB11AC0160] usr_id = [batchuser1] fail_code = [NB11AA0107] ユーザ情報の登録に失敗しました。
Input Data :
{... INSERT_EXECUTION_ID=EXECUTION_ID_2000000123456789, UPDATED_USER_ID=batch_user, ... INSERT_REQUEST_ID=RB11AC0140}
```

<details>
<summary>keywords</summary>

FailureLogUtil, TransactionAbnormalEnd, ProcessAbnormalEnd, FailureLogFormatter, logError, 後続処理継続, 業務処理終了, FailureLog_AppMsgId, FailureLog_FwMsgId, 障害コード変更, 派生元実行時情報, $data$, データ連携, 前段処理, 後段処理, db-object-store-label, INSERT_REQUEST_ID, INSERT_EXECUTION_ID

</details>

## 障害ログの設定方法

`FailureLogUtil` はapp-log.propertiesを読み込み `FailureLogFormatter` オブジェクトを生成して個別項目のフォーマット処理を委譲する。プロパティファイルのパス指定や実行時設定変更は :ref:`AppLog_Config` を参照。

app-log.properties設定例:
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
| failureLogFormatter.defaultFailureCode | ○ | デフォルトの障害コード。例外ハンドラでRuntimeExceptionを捕捉した場合など障害コード指定がない場合に使用。 |
| failureLogFormatter.defaultMessage | ○ | デフォルトのメッセージ。デフォルト障害コード使用時に出力するメッセージ。 |
| failureLogFormatter.language | | メッセージ取得時の言語。指定がない場合はThreadContextの言語を使用。 |
| failureLogFormatter.notificationFormat | | 障害通知ログの個別項目フォーマット。 |
| failureLogFormatter.analysisFormat | | 障害解析ログの個別項目フォーマット。 |
| failureLogFormatter.contactFilePath | | 障害の連絡先情報プロパティファイルパス。詳細は :ref:`FailureLog_Contact` を参照。 |
| failureLogFormatter.appFailureCodeFilePath | | アプリケーションの障害コード変更情報ファイルパス。詳細は :ref:`FailureLog_AppMsgId` を参照。 |
| failureLogFormatter.fwFailureCodeFilePath | | フレームワークの障害コード変更情報ファイルパス。詳細は :ref:`FailureLog_FwMsgId` を参照。 |

フォーマットに指定可能なプレースホルダ:

| 項目名 | プレースホルダ |
|---|---|
| 障害コード | $failureCode$ |
| メッセージ | $message$ |
| 処理対象データ | $data$ |
| 連絡先 | $contact$ |

デフォルトフォーマット: `fail_code = [$failureCode$] $message$`

<details>
<summary>keywords</summary>

FailureLogFormatter, failureLogFormatter.className, failureLogFormatter.defaultFailureCode, failureLogFormatter.defaultMessage, failureLogFormatter.language, failureLogFormatter.notificationFormat, failureLogFormatter.analysisFormat, failureLogFormatter.contactFilePath, failureLogFormatter.appFailureCodeFilePath, failureLogFormatter.fwFailureCodeFilePath, app-log.properties, $failureCode$, $message$, $data$, $contact$

</details>

## 障害ログの出力例

データベース接続不可の障害発生時に `FailureLogFormatter` 設定のデフォルト障害コードとデフォルトメッセージが出力される例。

app-log.properties設定例:
```bash
failureLogFormatter.defaultFailureCode=ZZ999999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$]
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
```

log.propertiesのフォーマット設定:
```bash
# 障害通知ログ
writer.monitorFile.formatter.format=$date$ -$logLevel$- [$executionId$] R[$requestId$] U[$userId$] $message$

# 障害解析ログ
writer.appFile.formatter.format=$date$ -$logLevel$- [$executionId$] R[$requestId$] U[$userId$] $message$$information$$stackTrace$
```

ログ出力例:
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

障害ログ出力例, ZZ999999, FATAL, DbAccessException, 障害通知ログ出力例, 障害解析ログ出力例

</details>
