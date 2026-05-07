# 障害ログの出力

**目次**

* 障害ログの出力方針
* 使用方法

  * 障害ログを出力する
  * 障害ログの設定
  * 障害ログに連絡先情報を追加する
  * フレームワークの障害コードを変更する
  * 派生元実行時情報を出力する
  * プレースホルダに対する出力処理をカスタマイズする
  * JSON形式の構造化ログとして出力する

フレームワークでは、処理方式毎の例外ハンドラにおいて出力する。
アプリケーションでは、バッチ処理の障害発生時に後続処理を継続する場合などに出力する。

## 障害ログの出力方針

障害通知ログは、ログ監視ツールから監視することで障害を検知することを想定しているので、
ロガー名を付けて障害通知専用のファイルに出力する。
障害解析ログは、アプリケーション全体のログ出力を行うアプリケーションログに出力する。

障害ログの出力方針

| ログの種類 | ログレベル | ロガー名 |
|---|---|---|
| 障害通知ログ | FATAL、ERROR | MONITOR |
| 障害解析ログ | FATAL、ERROR | クラス名 |

上記出力方針に対するログ出力の設定例を下記に示す。

log.propertiesの設定例

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

app-log.propertiesの設定例

```properties
# FailureLogFormatter
#failureLogFormatter.className=
failureLogFormatter.defaultFailureCode=MSG99999
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.language=ja
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
#failureLogFormatter.contactFilePath=
#failureLogFormatter.fwFailureCodeFilePath=
```

> **Tip:**
> 大規模システムで障害時の連絡先が複数存在する場合、
> [障害ログに連絡先情報を追加する](../../component/libraries/libraries-failure-log.md#failure-log-add-contact) を使用することで、リクエストID毎に連絡先情報をログに含めることができる。

## 使用方法

### 障害ログを出力する

障害ログの出力には、 FailureLogUtil を使用する。

```java
try {
    // 業務処理
} catch (UserNotFoundException e) {
    // 捕捉した例外、処理対象データ、障害コードを指定している。
    FailureLogUtil.logError(e, inputData, "USER_NOT_FOUND");
}
```

なお、バッチとメッセージングにおいては、障害を検知した時点で、
障害ログを出力して業務処理を終了したい場合がある。
このような場合は、
TransactionAbnormalEnd または
ProcessAbnormalEnd を送出し、
例外ハンドラ([グローバルエラーハンドラ](../../component/handlers/handlers-global-error-handler.md#global-error-handler) や [リクエストスレッド内ループ制御ハンドラ](../../component/handlers/handlers-request-thread-loop-handler.md#request-thread-loop-handler)) に障害ログの出力を依頼する。

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

> **Tip:**
> 上記例のように、障害ログの出力では、ログから障害内容を特定するために障害コードを指定する。
> 障害コードのコード体系は、プロジェクト毎に規定すること。

障害ログに出力されるメッセージ

障害ログに出力されるメッセージは、 [メッセージ管理](../../component/libraries/libraries-message.md#message) を使用して障害コードに対応するメッセージを取得する。
[メッセージ管理](../../component/libraries/libraries-message.md#message) では、メッセージが見つからない場合に例外が発生する。
メッセージ取得処理で例外が発生した場合は、障害ログとは別に、
メッセージ取得処理で発生した例外をWARNレベルでログ出力し、障害ログには下記のメッセージを出力する。

```bash
failed to get the message to output the failure log. failureCode = [<障害コード>]
```

フレームワークの例外ハンドラで例外やエラーを捕捉した場合など、障害コードの指定がない場合は、
設定で指定するデフォルトの [障害コード](../../component/libraries/libraries-failure-log.md#failure-log-prop-default-failure-code) と
[メッセージ](../../component/libraries/libraries-failure-log.md#failure-log-prop-default-message) を出力する。

### 障害ログの設定

障害ログの設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#log-app-log-setting) で説明したプロパティファイルに行う。

記述ルール

failureLogFormatter.className

FailureLogFormatter を実装したクラス。
差し替える場合に指定する。

failureLogFormatter.defaultFailureCode `必須`

デフォルトの障害コード。
例外ハンドラで例外がエラーを捕捉した場合など、障害コードの指定がない場合に使用する。

failureLogFormatter.defaultMessage `必須`

デフォルトのメッセージ。
デフォルトの障害コードを使用する場合に出力するメッセージとなる。

failureLogFormatter.language

障害コードからメッセージを取得する際に使用する言語。
指定がない場合は ThreadContext に設定されている言語を使用する。

failureLogFormatter.notificationFormat

障害通知ログのフォーマット。

フォーマットに指定可能なプレースホルダ

| 項目名 | プレースホルダ | 説明 |
|---|---|---|
| 障害コード | $failureCode$ | 障害を一意に識別するコード。障害内容の特定に使用する。 |
| メッセージ | $message$ | 障害コードに対応するメッセージ。障害内容の特定に使用する。 |
| 処理対象データ | $data$ | 障害が発生した処理が対象としていたデータを特定するために使用する。 データリーダを使用して読み込まれたデータオブジェクトのtoStringメソッドを呼び出し出力される。 |
| 連絡先 | $contact$ | 連絡先を特定するために使用する。 |

デフォルトのフォーマット

```java
fail_code = [$failureCode$] $message$
```

failureLogFormatter.analysisFormat

障害解析ログのフォーマット。
フォーマットに指定可能なプレースホルダとデフォルトのフォーマットは、
[障害通知ログのフォーマット](../../component/libraries/libraries-failure-log.md#failure-log-prop-notification-format) と同じ。

failureLogFormatter.contactFilePath

障害の連絡先情報を指定したプロパティファイルのパス。
障害の連絡先情報を出力する場合に指定する。
詳細は [障害ログに連絡先情報を追加する](../../component/libraries/libraries-failure-log.md#failure-log-add-contact) を参照。

failureLogFormatter.fwFailureCodeFilePath

フレームワークの障害コードの変更情報を指定したプロパティファイルのパス。
障害ログ出力時にフレームワークの障害コードを変更する場合に指定する。
詳細は [フレームワークの障害コードを変更する](../../component/libraries/libraries-failure-log.md#failure-log-change-fw-failure-code) を参照。

> **Important:**
> システムのセキュリティ要件により、障害解析ログであっても個人情報や機密情報の出力が許されない場合は、
> [プレースホルダに対する出力処理をカスタマイズする](../../component/libraries/libraries-failure-log.md#failure-log-placeholder-customize) を参照し、プロジェクトでカスタマイズすること。

> **Tip:**
> 処理対象データの出力により、障害ログに派生元実行時情報を出力できる。
> 派生元実行時情報とは、例えば、ウェブからバッチ処理にデータ連携する場合であれば、
> 画面処理を実行した時点の実行時情報(リクエストIDや実行時IDなど)がバッチ処理での派生元実行時情報となる。
> 派生元実行時情報の出力方法は、 [派生元実行時情報を出力する](../../component/libraries/libraries-failure-log.md#failure-log-output-src-exe-info) を参照。

記述例

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

### 障害ログに連絡先情報を追加する

大規模システムで障害時の連絡先が複数存在する場合など、障害ログに連絡先情報を含めたい場合がある。
そこで、障害ログの出力では、リクエストID毎に連絡先情報を指定する機能を提供する。

連絡先情報の追加は、プロパティファイルに指定する。キーにリクエストID、値に連絡先情報を指定する。
キーに指定されたリクエストIDは、 ThreadContext から取得したリクエストIDに対して、前方一致で検索する。
このため、プロパティファイルの内容は読み込み後に、より限定的なリクエストIDから検索するように、キー名の長さの降順にソートする。

連絡先情報の追加例を下記に示す。

まず、プロパティファイルを準備する。 `failure-log-contact.properties` というファイル名でクラスパス直下に配置しているものとする。

failure-log-contact.propertiesの設定例

```properties
# リクエストID=連絡先情報
/users/=USRMGR999
/users/index=USRMGR300
/users/list=USRMGR301
/users/new=USRMGR302
/users/edit=USRMGR303
```

上記プロパティファイルは、読み込み後下記の通りソートされ、上から順に検索に使用する。

```properties
# キー名の長さが等しいものは、実行毎に順番が変わる。
/users/index=USRMGR300
/users/list=USRMGR301
/users/edit=USRMGR303
/users/new=USRMGR302
/users/=USRMGR999
```

次に、障害ログのフォーマットで連絡先情報を表すプレースホルダ `$contact$` を指定する。
さらに、プロパティファイルのパスを指定する。

app-log.propertiesの設定例

```properties
# FailureLogFormatterの設定
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$] <$contact$>
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$ <$contact$>

# プロパティファイルのパスを指定する。
failureLogFormatter.contactFilePath=classpath:failure-log-contact.properties
```

上記の設定により、リクエストID毎に連絡先情報が出力される。
リクエストIDが `/users/new` の場合に発生した障害の出力例を下記に示す。
`$contact$` を指定した箇所(<>で囲った部分)に `USRMGR302` が出力される。

```bash
# 障害通知ログ
2011-02-15 15:09:57.691 -FATAL- [APUSRMGR0001201102151509320020009] R[/users/new] U[0000000001] [UNEXPECTED_ERROR:an unexpected exception occurred.] <USRMGR302>

# 障害解析ログ
2011-02-15 15:09:57.707 -FATAL- [APUSRMGR0001201102151509320020009] R[/users/new] U[0000000001] fail_code = [UNEXPECTED_ERROR] an unexpected exception occurred. <USRMGR302>
# スタックトレースは省略。
```

なお、リクエストIDに対応する連絡先情報が見つからない場合はnullが出力される。

### フレームワークの障害コードを変更する

フレームワークでは、想定しないエラーが発生した際にRuntimeException系の例外を送出している。
その結果、フレームワークが送出した例外は、全てデフォルトの障害コードが使用されて障害ログが出力される。
障害監視において、障害コードにより監視対象をフィルタリングしたいケースが考えられるため、
障害ログの出力では、フレームワークの障害コードを指定する機能を提供する。

フレームワークの障害コードは、例外が送出されたクラス名毎に指定できる。
「例外が送出されたクラス」とは、スタックトレースのルート要素を指している。
例えば、下記のスタックトレースであれば、nablarch.core.message.StringResourceHolderクラスとなる。

```bash
Stack Trace Information :
java.lang.RuntimeException: ValidateFor method invocation failed. targetClass = java.lang.Class, method = validateForRegisterUser
    at nablarch.core.validation.ValidationManager.validateAndConvert(ValidationManager.java:202)
    # 途中のスタックトレースは省略。
Caused by: nablarch.core.message.MessageNotFoundException: message was not found. message id = MSG00010
    at nablarch.core.message.StringResourceHolder.get(StringResourceHolder.java:40)
    # 以降のスタックトレースは省略。(以降Caused byは出現しない)
```

ただし、フレームワークのクラス毎に障害コードを設定するのは、分類が細かすぎるため現実的ではない。
基本はパッケージ名単位に障害コードを指定することで、フレームワークのどの機能で例外が送出されたか判断できる。

フレームワークの障害コードは、プロパティファイルに指定する。
プロパティファイルでは、キーにフレームワークのパッケージ名、値に障害コードを指定する。
キーに指定されたパッケージ名は、スタックトレースから取得した例外が送出されたクラスのFQCN(完全修飾クラス名)に対して、
前方一致で検索する。このため、プロパティファイルの内容は読み込み後に、より限定的なパッケージ名から検索するように、
キー名の長さの降順にソートする。

フレームワークの障害コードの変更例を下記に示す。

まず、プロパティファイルを準備する。
`failure-log-fw-codes.properties` というファイル名でクラスパス直下に配置しているものとする。
nablarchというパッケージ名を指定することで、個別に指定していない全てのパッケージに対して障害コードを指定できる。

failure-log-fw-codes.propertiesの設定例

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

上記プロパティファイルは、読み込み後下記の通りソートされ、上から順に検索に使用する。

```properties
nablarch.core.transaction=FW_TRANSACTION_ERROR
nablarch.core.repository=FW_REPOSITORY_ERROR
nablarch.core.message=FW_MESSAGE_ERROR
nablarch.core.cache=FW_CACHE_ERROR
nablarch.core.date=FW_DATE_ERROR
nablarch.core.db=FW_DB_ERROR
nablarch=FW_ERROR
```

次に、FailureLogFormatterの設定でプロパティファイルのパスを指定する。

app-log.propertiesの設定例

```properties
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=[$failureCode$:$message$]
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$
# プロパティファイルのパスを指定する。
failureLogFormatter.fwFailureCodeFilePath=classpath:failure-log-fw-codes.properties
```

上記の設定により、フレームワークの障害コードが変更される。障害通知ログでいくつか出力例を下記に示す。

nablarch.core.date.BasicBusinessDateProviderクラスで例外を送出した場合

```bash
# プロパティファイルのnablarch.core.date=FW_DATE_ERRORが該当する。
2011-02-15 16:48:54.993 -FATAL- [APUSRMGR0001201102151648315060002] R[/login] U[9999999999] fail_code = [FW_DATE_ERROR] segment was not found. segment:00.
Stack Trace Information :
java.lang.IllegalStateException: segment was not found. segment:00.
    at nablarch.core.date.BasicBusinessDateProvider.getDate(BasicBusinessDateProvider.java:103)
    # 以降のスタックトレースは省略。
```

nablarch.core.message.StringResourceHolderクラスで例外を送出した場合

```bash
# プロパティファイルのnablarch.core.message=FW_MESSAGE_ERRORが該当する。
2011-02-15 16:54:06.413 -FATAL- [APUSRMGR0001201102151653476260011] R[/users/edit] U[0000000001] fail_code = [FW_MESSAGE_ERROR] ValidateFor method invocation failed. targetClass = java.lang.Class, method = validateForRegisterUser
Stack Trace Information :
java.lang.RuntimeException: ValidateFor method invocation failed. targetClass = java.lang.Class, method = validateForRegisterUser
    at nablarch.core.validation.ValidationManager.validateAndConvert(ValidationManager.java:202)
    # 途中のスタックトレースは省略。
Caused by: nablarch.core.message.MessageNotFoundException: message was not found. message id = MSG00010
    at nablarch.core.message.StringResourceHolder.get(StringResourceHolder.java:40)
    # 以降のスタックトレースは省略。
```

nablarch.common.authentication.PasswordAuthenticatorクラスで例外を送出した場合

```bash
# プロパティファイルのnablarch=FW_ERRORが該当する。
2011-02-15 16:59:03.076 -FATAL- [APUSRMGR0001201102151658551890017] R[/login] U[9999999999] fail_code = [FW_ERROR] authentication failed.
Stack Trace Information :
nablarch.common.authentication.AuthenticationFailedException
    at nablarch.common.authentication.PasswordAuthenticator.authenticate(PasswordAuthenticator.java:302)
    # 以降のスタックトレースは省略。
```

### 派生元実行時情報を出力する

派生元実行時情報とは、例えば、ウェブからバッチにデータ連携する場合であれば、
画面処理を実行した時点の実行時情報がバッチ処理での派生元実行時情報となる。
以降では、処理方式間でデータ連携した場合に、先に処理を行う側を前段処理、後に処理を行う側を後段処理と呼ぶ。
後段処理における障害発生時に、前段処理の追跡作業を軽減するために派生元実行時情報を出力する。

派生元実行時情報の出力には、本機能のプレースホルダ「$data$」が使用できる。
プレースホルダ「$data$」が指定された場合、データリーダを使用して読み込まれたデータが障害ログに出力される。
この機能を使用して、前段処理において予め実行時情報をデータに含めておくことで、
後段処理の障害発生時に処理対象データとして前段処理の実行時情報が出力されることになる。

ここでは、データベースを使用したデータ連携における派生元実行時情報の出力例を示す。
前段処理において下記のカラム名で実行時情報が設定されていることとする。

| 項目 | カラム名 |
|---|---|
| リクエストID | INSERT_REQUEST_ID |
| 実行時ID | INSERT_EXECUTION_ID |
| ユーザID | UPDATED_USER_ID |

app-log.propertiesの設定例

```properties
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
# 処理対象データのプレースホルダ「data」を障害解析ログのフォーマットに指定する。
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

障害解析ログの出力例

```bash
# 障害解析ログ
2011-09-26 21:06:35.745 -FATAL- root [EXECUTION_ID_0000000123456789] boot_proc = [] proc_sys = [] req_id = [RB11AC0160] usr_id = [batchuser1] fail_code = [USER_REGISTER_FAILED] ユーザ情報の登録に失敗しました。
Input Data :
{MOBILE_PHONE_NUMBER_AREA_CODE=002, KANJI_NAME=山本太郎, USER_INFO_ID=00000000000000000113, INSERT_EXECUTION_ID=EXECUTION_ID_2000000123456789, MAIL_ADDRESS=yamamoto@sample.com, MOBILE_PHONE_NUMBER_CITY_CODE=0003, UPDATED_USER_ID=batch_user, MOBILE_PHONE_NUMBER_SBSCR_CODE=0004, KANA_NAME=ヤマモトタロウ, EXTENSION_NUMBER_BUILDING=13, LOGIN_ID=12345678901234567890, EXTENSION_NUMBER_PERSONAL=1235, INSERT_REQUEST_ID=RB11AC0140}
Stack Trace Information :
[100 TransactionAbnormalEnd] ユーザ情報の登録に失敗しました。
    at nablarch.sample.ss11AC.B11AC016Action.handle(B11AC016Action.java:73)
    at nablarch.sample.ss11AC.B11AC016Action.handle(B11AC016Action.java:1)
    at nablarch.fw.action.BatchAction.handle(BatchAction.java:1)
    # 以降のスタックトレースは省略。
```

処理対象データ(出力例の「Input Data :」)に下記の実行時情報が出力される。

```properties
INSERT_REQUEST_ID=RB11AC0140
INSERT_EXECUTION_ID=EXECUTION_ID_2000000123456789
UPDATED_USER_ID=batch_user
```

### プレースホルダに対する出力処理をカスタマイズする

処理対象データ($data$)はデフォルトでtoStringメソッドにより全てのデータ項目が出力されるため、
プロジェクトのセキュリティ要件で特定項目をマスクした出力が要求されるケースが考えられる。
このように、プレースホルダに対する出力処理をカスタマイズしたい場合は、以下のとおり対応する。

* LogItem を実装したクラスを作る
* FailureLogFormatter を継承したクラスを作り、プレースホルダを追加する
* FailureLogFormatter を継承したクラスを使うように設定する

ここでは、処理対象データ($data$)に対する出力処理のカスタマイズ例を示す。

LogItem を実装したクラスを作る

処理対象データ($data$)に対する出力内容を提供するクラスを作る。
今回はフレームワークが提供する DataItem を継承して作成し、
処理対象データがMap型の場合のみマスク処理を行うように実装している。

```java
// FailureLogFormatterの拡張クラスにインナークラスとして定義している。
private static final class CustomDataItem extends DataItem {

    /** マスク文字 */
    private static final char MASKING_CHAR = '*';

    /** マスク対象のパターン */
    private static final Pattern[] MASKING_PATTERNS
            = new Pattern[] { Pattern.compile(".*MOBILE_PHONE_NUMBER.*"),
                              Pattern.compile(".*MAIL.*")};

    /**
     * マップの値をマスキングするエディタ。
     * フレームワークが提供するMap編集用のユーティリティ。
     */
    private MapValueEditor mapValueEditor
        = new MaskingMapValueEditor(MASKING_CHAR, MASKING_PATTERNS);

    @Override
    @SuppressWarnings("unchecked")
    public String get(FailureLogContext context) {

        // FailureLogContextのgetDataメソッドを呼び出し処理対象データを取得する。
        Object data = context.getData();

        // Mapでない場合はフレームワークのデフォルト実装を呼び出す。
        if (!(data instanceof Map)) {
            return super.get(context);
        }

        // Mapをマスクした文字列を返す。
        Map<String, String> editedMap = new TreeMap<String, String>();
        for (Map.Entry<Object, Object> entry : ((Map<Object, Object>) data).entrySet()) {
            String key = entry.getKey().toString();
            editedMap.put(key, mapValueEditor.edit(key, entry.getValue()));
        }
        return editedMap.toString();
    }
}
```

FailureLogFormatter を継承したクラスを作り、プレースホルダを追加する

FailureLogFormatter#getLogItems
をオーバライドし、プレースホルダ `$data$` に対して上記のCustomDataItemを設定する。

```java
public class CustomDataFailureLogFormatter extends FailureLogFormatter {

    @Override
    protected Map<String, LogItem<FailureLogContext>> getLogItems(Map<String, String> props) {

        Map<String, LogItem<FailureLogContext>> logItems = super.getLogItems(props);

        // CustomDataItemで$data$を上書き設定する。
        logItems.put("$data$", new CustomDataItem());

        return logItems;
    }

    private static final class CustomDataItem extends DataItem {
        // 省略。
    }
 }
```

FailureLogFormatter を継承したクラスを使うように設定する

障害ログのフォーマッタとしてCustomDataFailureLogFormatterを使用するように `app-log.properties` に設定する。

```properties
# CustomDataFailureLogFormatterを指定する。
failureLogFormatter.className=nablarch.core.log.app.CustomDataFailureLogFormatter
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
failureLogFormatter.notificationFormat=fail_code = [$failureCode$] $message$
failureLogFormatter.analysisFormat=fail_code = [$failureCode$] $message$\nInput Data :\n$data$
```

### JSON形式の構造化ログとして出力する

[JSON形式の構造化ログとして出力する](../../component/libraries/libraries-log.md#log-json-log-setting) 設定でログをJSON形式で出力できるが、
FailureLogFormatter では
障害ログの各項目はmessageの値に文字列として出力される。
障害ログの各項目もJSONの値として出力するには、
FailureJsonLogFormatter を使用する。
設定は、 [各種ログの設定](../../component/libraries/libraries-log.md#log-app-log-setting) で説明したプロパティファイルに行う。

記述ルール

FailureJsonLogFormatter を用いる際に
指定するプロパティは以下の通り。

failureLogFormatter.className `必須`

JSON形式でログを出力する場合、
FailureJsonLogFormatter を指定する。

failureLogFormatter.defaultFailureCode `必須`

デフォルトの障害コード。
例外ハンドラで例外がエラーを捕捉した場合など、障害コードの指定がない場合に使用する。

failureLogFormatter.defaultMessage `必須`

デフォルトのメッセージ。
デフォルトの障害コードを使用する場合に出力するメッセージとなる。

failureLogFormatter.language

障害コードからメッセージを取得する際に使用する言語。
指定がない場合は ThreadContext に設定されている言語を使用する。

failureLogFormatter.notificationTargets

障害通知ログの出力項目。カンマ区切りで指定する。

指定可能な出力項目およびデフォルトの出力項目

| 項目名 | 出力項目 | 説明 | デフォルト出力 |
|---|---|---|---|
| 障害コード | failureCode | 障害を一意に識別するコード。障害内容の特定に使用する。 | ○ |
| メッセージ | message | 障害コードに対応するメッセージ。障害内容の特定に使用する。 | ○ |
| 処理対象データ | data | 障害が発生した処理が対象としていたデータを特定するために使用する。 データリーダを使用して読み込まれたデータオブジェクトのtoStringメソッドを呼び出し出力される。 |  |
| 連絡先 | contact | 連絡先を特定するために使用する。 |  |

failureLogFormatter.analysisTargets

障害解析ログの出力項目。カンマ区切りで指定する。
指定可能な出力項目とデフォルト設定は、
[障害通知ログの出力項目](../../component/libraries/libraries-failure-log.md#failure-log-prop-notification-targets) と同じ。

failureLogFormatter.contactFilePath

障害の連絡先情報を指定したプロパティファイルのパス。
障害の連絡先情報を出力する場合に指定する。
詳細は [障害ログに連絡先情報を追加する](../../component/libraries/libraries-failure-log.md#failure-log-add-contact) を参照。

failureLogFormatter.fwFailureCodeFilePath

フレームワークの障害コードの変更情報を指定したプロパティファイルのパス。
障害ログ出力時にフレームワークの障害コードを変更する場合に指定する。
詳細は [フレームワークの障害コードを変更する](../../component/libraries/libraries-failure-log.md#failure-log-change-fw-failure-code) を参照。

failureLogFormatter.structuredMessagePrefix

フォーマット後のメッセージ文字列が JSON 形式に整形されていることを識別できるようにするために、メッセージの先頭に付与するマーカー文字列。
メッセージの先頭にあるマーカー文字列が JsonLogFormatter に設定しているマーカー文字列と一致する場合、 JsonLogFormatter はメッセージを JSON データとして処理する。
デフォルトは `"$JSON$"` となる。
変更する場合は、LogWriterの `structuredMessagePrefix` プロパティを使用して JsonLogFormatter にも同じ値を設定すること（LogWriterのプロパティについては [ログ出力の設定](../../component/libraries/libraries-log.md#log-basic-setting) を参照）。

記述例

```properties
failureLogFormatter.className=nablarch.core.log.app.FailureJsonLogFormatter
failureLogFormatter.structuredMessagePrefix=$JSON$
failureLogFormatter.notificationTargets=failureCode,message,contact
failureLogFormatter.analysisTargets=failureCode,message,data
failureLogFormatter.defaultFailureCode=UNEXPECTED_ERROR
failureLogFormatter.defaultMessage=an unexpected exception occurred.
```
