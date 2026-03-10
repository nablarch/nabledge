# ログ出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/Logger.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LoggerFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogger.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLoggerFactory.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/FileLogWriter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/SynchronousFileLogWriter.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/StandardOutputLogWriter.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogPublisher.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogFormatter.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/DateRotatePolicy.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/FileSizeRotatePolicy.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LoggerManager.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogLevel.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/util/FileUtil.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogFormatter.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/RotatePolicy.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogWriter.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogWriterSupport.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogLevelLabelProvider.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LogItem.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureJsonLogFormatter.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlJsonLogFormatter.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/PerformanceJsonLogFormatter.html) [27](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpAccessJsonLogFormatter.html) [28](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessJsonLogFormatter.html) [29](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/logging/MessagingJsonLogFormatter.html) [30](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/ApplicationSettingJsonLogFormatter.html) [31](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/ApplicationSettingLogFormatter.html) [32](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/logging/LauncherJsonLogFormatter.html) [33](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/logging/LauncherLogFormatter.html) [34](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/CommitLogger.html) [35](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/BasicCommitLogger.html) [36](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/JsonCommitLogger.html) [37](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogContext.html) [38](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogListener.html)

## 機能概要

ログ出力は3コンポーネント（LogWriter・LogFormatter・Logger/LoggerFactory）で構成され、それぞれの実装を差し替えられる。オープンソースのログ出力ライブラリを使用したい場合は `Logger` / `LoggerFactory` を差し替える。既存ロギングフレームワーク向けの専用アダプタについては :ref:`log_adaptor` を参照。

**デフォルト提供クラス**

Logger/LoggerFactory:
- **クラス**: `nablarch.core.log.basic.BasicLogger`, `nablarch.core.log.basic.BasicLoggerFactory`

LogWriter:
- **クラス**: `nablarch.core.log.basic.FileLogWriter`（ファイルへ出力、ログのローテーション）
- **クラス**: `nablarch.core.log.basic.SynchronousFileLogWriter`（複数プロセスから1ファイルへの出力）
- **クラス**: `nablarch.core.log.basic.StandardOutputLogWriter`（標準出力へ出力）
- **クラス**: `nablarch.core.log.basic.LogPublisher`（任意のリスナーへ出力）

LogFormatter:
- **クラス**: `nablarch.core.log.basic.BasicLogFormatter`（パターン文字列によるフォーマット）

RotatePolicy:
- **クラス**: `nablarch.core.log.basic.DateRotatePolicy`（日時によるローテーション）
- **クラス**: `nablarch.core.log.basic.FileSizeRotatePolicy`（ファイルサイズによるローテーション）

> **重要**: `SynchronousFileLogWriter` を使う場合は :ref:`log-synchronous_file_log_writer_attention` を参照すること。

各種ログの出力機能はフォーマット処理のみを行い、ログの出力処理自体は本機能を使用している。Nablarchの提供するアーキタイプから生成したブランクプロジェクトでは各種ログのフォーマットが設定してある。デフォルト設定値は :download:`デフォルト設定一覧 <../configuration/デフォルト設定一覧.xlsx>` を参照。

| ログの種類 | 説明 |
|---|---|
| :ref:`障害通知ログ <failure_log>` | 障害発生時に1次切り分け担当者の特定に必要な情報を出力する。 |
| :ref:`障害解析ログ <failure_log>` | 障害原因の特定に必要な情報を出力する。 |
| :ref:`SQLログ <sql_log>` | SQL文の実行時間とSQL文を出力する（パフォーマンスチューニング用）。 |
| :ref:`パフォーマンスログ <performance_log>` | 任意の処理の実行時間とメモリ使用量を出力する（パフォーマンスチューニング用）。 |
| :ref:`HTTPアクセスログ <http_access_log>` | Webアプリケーションの実行状況、性能・負荷測定情報、全リクエスト/レスポンスの証跡ログを出力する。 |
| :ref:`HTTPアクセスログ（RESTfulウェブサービス用） <jaxrs_access_log>` | RESTfulウェブサービスの実行状況、性能・負荷測定情報、全リクエスト/レスポンスの証跡ログを出力する。 |
| :ref:`メッセージングログ <messaging_log>` | メッセージング処理のメッセージ送受信状況を出力する。 |

> **補足**: 本フレームワークでは、:ref:`障害通知ログ <failure_log>` と :ref:`障害解析ログ <failure_log>` を合わせて**障害ログ**と呼ぶ。

<details>
<summary>keywords</summary>

BasicLogger, BasicLoggerFactory, FileLogWriter, SynchronousFileLogWriter, StandardOutputLogWriter, LogPublisher, BasicLogFormatter, DateRotatePolicy, FileSizeRotatePolicy, LogWriter, LogFormatter, Logger, LoggerFactory, ログ出力機能, LogWriter差し替え, LogFormatter差し替え, Logger差し替え, ログの種類, failure_log, sql_log, performance_log, http_access_log, jaxrs_access_log, messaging_log, 障害ログ, ブランクプロジェクト, アーキタイプ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-applog</artifactId>
</dependency>

<!-- SQLログを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>

<!-- HTTPアクセスログを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>

<!-- HTTPアクセスログ（RESTfulウェブサービス用）を使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>

<!-- メッセージングログを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, nablarch-core-applog, nablarch-core-jdbc, nablarch-fw-web, nablarch-fw-jaxrs, nablarch-fw-messaging, Maven依存関係, モジュール設定

</details>

## ログを出力する

ログ出力には `Logger` を使用し、`LoggerManager` から取得する。ロガー名には文字列またはクラスが指定できる。クラスが指定された場合はFQCNがロガー名となる。

```java
// クラスを指定してLoggerを取得する。Loggerはクラス変数に保持する。
private static final Logger LOGGER = LoggerManager.get(UserManager.class);
```

```java
// ログの出力有無を事前にチェックし、ログ出力を行う。
if (LOGGER.isDebugEnabled()) {
    String message = "userId[" + user.getId() + "],name[" + user.getName() + "]";
    LOGGER.logDebug(message);
}
```

> **重要**: 常にログを出力することになっているレベルは、ソースコードの可読性が落ちるため事前チェックをしなくてよい。例えば本番運用時の出力レベルがINFOの場合、FATALからINFOまでは事前チェック不要。

> **補足**: SQLログや監視ログなど特定用途向けのログ出力では、その用途を表す名前（SQL、MONITORなど）をロガー名に指定し、それ以外はクラスのFQCNを指定する。

<details>
<summary>keywords</summary>

Logger, LoggerManager, LoggerManager.get, isDebugEnabled, logDebug, ログ出力, ロガー取得, ログレベル事前チェック

</details>

## ログ出力の設定

**プロパティファイルの場所**: クラスパス直下の `log.properties` を使用する。場所を変更する場合はシステムプロパティ `nablarch.log.filePath` でファイルパスを指定する（`FileUtil#getResource` 参照）。

```bash
>java -Dnablarch.log.filePath=classpath:nablarch/example/log.properties ...
```

**LoggerFactory設定**:

| プロパティ名 | 説明 |
|---|---|
| `loggerFactory.className` | LoggerFactoryを実装したクラスのFQCN。本機能使用時は `nablarch.core.log.basic.BasicLoggerFactory` を指定。 |

```properties
loggerFactory.className=nablarch.core.log.basic.BasicLoggerFactory
```

**LogWriter設定**:

| プロパティ名 | 説明 |
|---|---|
| `writerNames` | 使用する全LogWriterの名前（カンマ区切り） |
| `writer.<名前>.className` | LogWriterを実装したクラスのFQCN |
| `writer.<名前>.<プロパティ名>` | LogWriter固有プロパティ（詳細は各LogWriterのJavadoc参照） |

```properties
writerNames=appLog,stdout
writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log
writer.stdout.className=nablarch.core.log.basic.StandardOutputLogWriter
```

**ロガー設定**:

| プロパティ名 | 説明 |
|---|---|
| `availableLoggersNamesOrder` | 使用する全ロガー設定の名前（カンマ区切り） |
| `loggers.<名前>.nameRegex` | ロガー名とのマッチングに使用する正規表現 |
| `loggers.<名前>.level` | `LogLevel` の名前。このレベル以上のログを全て出力する。 |
| `loggers.<名前>.writerNames` | 出力先LogWriterの名前（カンマ区切り） |

> **重要**: `availableLoggersNamesOrder` は記述順に意味がある。ロガー取得時に記述順でマッチングし最初にマッチしたLoggerを返すため、より限定的な正規表現のロガー設定を先に記述すること。例えば `availableLoggersNamesOrder=root,sql` と記述すると全ロガー取得が `root` にマッチし、ロガー名 `SQL` でも `sqlLog` に出力されない。

> **重要**: `availableLoggersNamesOrder` と `loggers.*` で指定するロガー設定の名称は必ず一致させること。`BasicLoggerFactory` の初期処理で一致チェックを行い、一致しない場合は例外をスローする。設定を取り除く場合は `availableLoggersNamesOrder` と `loggers.*` の両方から取り除くこと。

> **補足**: 全てのログ出力にマッチするロガー設定（`nameRegex=.*`）を1つ用意し、`availableLoggersNamesOrder` の最後に指定することを推奨する。設定漏れがあっても重要ログの出力を逃さないようにするため。

**プロパティファイル全体の記述例**:

```properties
loggerFactory.className=nablarch.core.log.basic.BasicLoggerFactory

writerNames=appLog,sqlLog,monitorLog,stdout

writer.appLog.className=nablarch.core.log.basic.FileLogWriter
writer.appLog.filePath=/var/log/app/app.log

writer.sqlLog.className=nablarch.core.log.basic.FileLogWriter
writer.sqlLog.filePath=/var/log/app/sql.log

writer.monitorLog.className=nablarch.core.log.basic.FileLogWriter
writer.monitorLog.filePath=/var/log/app/monitoring.log

writer.stdout.className=nablarch.core.log.basic.StandardOutputLogWriter

availableLoggersNamesOrder=sql,monitoring,access,validation,root

loggers.root.nameRegex=.*
loggers.root.level=WARN
loggers.root.writerNames=appLog

loggers.monitoring.nameRegex=MONITOR
loggers.monitoring.level=ERROR
loggers.monitoring.writerNames=appLog,monitorLog

loggers.sql.nameRegex=SQL
loggers.sql.level=DEBUG
loggers.sql.writerNames=sqlLog

loggers.access.nameRegex=app\\.user\\.UserManager
loggers.access.level=INFO
loggers.access.writerNames=appLog,stdout

loggers.validation.nameRegex=nablarch\\.core\\.validation\\..*
loggers.validation.level=DEBUG
loggers.validation.writerNames=stdout
```

<details>
<summary>keywords</summary>

log.properties, nablarch.log.filePath, loggerFactory.className, writerNames, availableLoggersNamesOrder, nameRegex, loggers, BasicLoggerFactory, LogLevel, FileUtil, ログ設定, プロパティファイル, LogWriter設定, ロガー設定, FileLogWriter, StandardOutputLogWriter

</details>

## ログ出力の設定を上書く

システムプロパティを使用して、プロパティファイルと同じキー名で値を指定することにより設定を上書きできる。共通プロパティファイルを用意しておき、プロセス毎にログ出力設定を変更できる。

ロガー設定 `root` のログレベルをINFOに変更する例:

```bash
java -Dloggers.root.level=INFO ...
```

<details>
<summary>keywords</summary>

システムプロパティ, ログ設定上書き, プロセス毎設定変更, loggers.root.level

</details>

## ログのフォーマットを指定する

汎用的な `LogFormatter` 実装として `BasicLogFormatter` が提供されている。プレースホルダを使用してフォーマットを指定する（使用できるプレースホルダは `BasicLogFormatter` のJavadocを参照）。

フォーマットはLogWriterのプロパティに指定する:

```properties
# フォーマットを指定する場合はBasicLogFormatterを明示的に指定する。
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
# プレースホルダを使ってフォーマットを指定する。
writer.appLog.formatter.format=$date$ -$logLevel$- $loggerName$ $message$
# 日時のフォーマットに使用するパターン（未指定時: "yyyy-MM-dd HH:mm:ss.SSS"）
writer.appLog.formatter.datePattern=yyyy/MM/dd HH:mm:ss[SSS]
# ログレベルの文言（未指定時はLogLevel列挙型の名前: FATAL、INFO など）
writer.appLog.formatter.label.fatal=F
writer.appLog.formatter.label.error=E
writer.appLog.formatter.label.warn=W
writer.appLog.formatter.label.info=I
writer.appLog.formatter.label.debug=D
writer.appLog.formatter.label.trace=T
```

`BasicLogFormatter` では以下の出力項目を使用できる:

**起動プロセス** (`$bootProcess$`): アプリケーションを起動した実行環境を特定する名前。システムプロパティ `nablarch.bootProcess` で指定。未指定の場合はブランク。

**処理方式**: ウェブ、バッチなどを示す識別値。プロパティファイルに `nablarch.processingSystem` キーで指定。未指定の場合はブランク。

**実行時ID**: リクエストIDに対するアプリケーションの個々の実行を識別するID（リクエストIDと1対多の関係）。複数ログの紐付けに使用する。各処理方式の `ThreadContext` 初期化時に発行・設定される。

ID体系:

```
起動プロセス（指定時のみ付加）＋システム日時(yyyyMMddHHmmssSSS)＋連番(4桁)
```

> **重要**: リクエストID、実行時ID、ユーザIDを出力する場合、取得元が `ThreadContext` のため、ハンドラ構成に :ref:`thread_context_handler` が含まれている必要がある。ユーザIDについては :ref:`thread_context_handler-user_id_attribute_setting` を参照しセッションへの値設定が必要。

**改行コード・タブ文字**: フォーマットに含める場合は `\n`（改行）、`\t`（タブ）をJavaと同様に記述する。改行コードはシステムプロパティ `line.separator` から取得（変更しなければOSの改行コード）。

> **補足**: `BasicLogFormatter` では `\n` と `\t` という文字列は出力できない。

<details>
<summary>keywords</summary>

BasicLogFormatter, LogFormatter, ThreadContext, 起動プロセス, 処理方式, 実行時ID, thread_context_handler, nablarch.bootProcess, nablarch.processingSystem, プレースホルダ, datePattern, ログフォーマット

</details>

## 各種ログの設定

各種ログの出力機能（:ref:`failure_log-setting`、:ref:`sql_log-setting` など）を使用するには、:ref:`log-basic_setting` に加えて各種ログの設定が必要。設定はプロパティファイルに記述する。

**プロパティファイルの場所**: クラスパス直下の `app-log.properties` を使用。場所を変更する場合はシステムプロパティ `nablarch.appLog.filePath` でファイルパスを指定する（ファイルパスの指定方法は `FileUtil#getResource` を参照）。

```bash
java -Dnablarch.appLog.filePath=file:/var/log/app/app-log.properties ...
```

各種ログの設定は各ドキュメントを参照:
- :ref:`failure_log-setting`
- :ref:`sql_log-setting`
- :ref:`performance_log-setting`
- :ref:`http_access_log-setting`
- :ref:`jaxrs_access_log-setting`
- :ref:`messaging_log-setting`

<details>
<summary>keywords</summary>

app-log.properties, nablarch.appLog.filePath, FileUtil, 各種ログ設定, failure_log, sql_log, performance_log, http_access_log, jaxrs_access_log, messaging_log

</details>

## ログファイルのローテーションを行う

`FileLogWriter` は設定したポリシーに従ってログファイルのローテーションを行う。

デフォルトのローテーションポリシーは `FileSizeRotatePolicy`（ファイルサイズによるローテーション）。`RotatePolicy` の実装クラスを作成することでポリシーを変更できる。

提供されている `RotatePolicy` 実装クラス（各設定はJavadocを参照）:
- `FileSizeRotatePolicy`
- `DateRotatePolicy`

ローテーションポリシーはLogWriterのプロパティに指定する:

```properties
writerNames=sample

# writerのrotatePolicyにRotatePolicyが実装されたクラスのFQCNを指定する
writer.sample.rotatePolicy=nablarch.core.log.basic.DateRotatePolicy
# 更新時刻（オプション）
writer.sample.rotateTime=12:00
```

<details>
<summary>keywords</summary>

FileSizeRotatePolicy, DateRotatePolicy, RotatePolicy, FileLogWriter, ログローテーション, rotatePolicy, rotateTime

</details>

## LogWriterを追加する

新しいLogWriterを追加する場合は `LogWriter` インタフェースを実装したクラスを作成する。`LogFormatter` を使用するLogWriterを作成する場合は、共通処理を提供する `LogWriterSupport` を継承して作成する。

<details>
<summary>keywords</summary>

LogWriter, LogWriterSupport, LogFormatter, LogWriter拡張, LogWriter追加

</details>

## LogFormatterを追加する

新しいLogFormatterを追加する場合は `LogFormatter` インタフェースを実装したクラスを作成する。ログレベルの文言を設定で変更可能にしたい場合は `LogLevelLabelProvider` を使用する。

ログ出力時のパラメータを増やしたい場合は `Logger` インタフェースのログ出力メソッドの `options` 引数（`Object...`）を使用する:

```java
public void logInfo(String message, Object... options)
public void logInfo(String message, Throwable cause, Object... options)
```

<details>
<summary>keywords</summary>

LogFormatter, LogLevelLabelProvider, Logger, LogFormatter拡張, LogFormatter追加, options引数, 可変長引数, logInfo

</details>

## ログの出力項目（プレースホルダ）を追加する

`BasicLogFormatter` は `LogItem` インタフェースで各プレースホルダに対応する出力項目を取得する。新規プレースホルダを追加する場合:

1. `LogItem` を実装したクラスを作成する
2. `BasicLogFormatter` を継承したクラスを作成し、`getLogItems(ObjectSettings settings)` をオーバーライドしてプレースホルダを追加する

カスタム起動プロセスプレースホルダ `$bootProcess$` の追加例:

```properties
writer.appLog.formatter.className=nablarch.core.log.basic.CustomLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $loggerName$ [$bootProcess$] $message$
writer.appLog.formatter.bootProcess=CUSTOM_PROCESS
```

```java
public class CustomBootProcessItem implements LogItem<LogContext> {
    private String bootProcess;
    public CustomBootProcessItem(ObjectSettings settings) {
        bootProcess = settings.getProp("bootProcess");
    }
    @Override
    public String get(LogContext context) {
        return bootProcess;
    }
}

public class CustomLogFormatter extends BasicLogFormatter {
    @Override
    protected Map<String, LogItem<LogContext>> getLogItems(ObjectSettings settings) {
        Map<String, LogItem<LogContext>> logItems = super.getLogItems(settings);
        logItems.put("$bootProcess$", new CustomBootProcessItem(settings));
        return logItems;
    }
}
```

<details>
<summary>keywords</summary>

BasicLogFormatter, LogItem, ObjectSettings, LogContext, プレースホルダ追加, getLogItems, CustomBootProcessItem, CustomLogFormatter

</details>

## ログの初期化メッセージを出力しないようにする

初期化メッセージが不要な場合は、提供するWriterを元に初期化メッセージを出力しないWriterを作成して対応する。:ref:`log_adaptor` を使用した場合は初期化メッセージが出力されないため本対応は不要。

対応手順:
1. ベースWriterクラスのソースをプロジェクト側にコピーする（例: `FileLogWriter`）
2. 初期化ログを出力している箇所を削除する（`FileLogWriter` の `initializeWriter()` 内の初期化メッセージ出力処理を削除する）
3. `LogWriterSupport.needsToWrite` をオーバーライドして初回の初期化メッセージを出力しないよう変更する:

```java
private boolean suppressionWriting = true;

@Override
public boolean needsToWrite(final LogContext context) {
    final String message = context.getMessage();
    if (suppressionWriting) {
        if (StringUtil.hasValue(message) && message.startsWith("initialized.")) {
            suppressionWriting = false;
            return false;
        }
    }
    return super.needsToWrite(context);
}
```

4. 作成したクラスを `log.properties` に設定する:

```properties
writerNames=sample
writer.sample.className = sample.CustomFileLogWriter
```

<details>
<summary>keywords</summary>

FileLogWriter, LogWriterSupport, needsToWrite, 初期化メッセージ抑制, suppressionWriting, log_adaptor, 初期化メッセージ, StringUtil, initializeWriter

</details>

## LogWriterでのJsonLogFormatter設定

LogWriterのフォーマッタを `JsonLogFormatter` に変更することでJSON形式ログを出力できる。

**クラス**: `nablarch.core.log.basic.JsonLogFormatter`

```properties
writer.appLog.formatter.className=nablarch.core.log.basic.JsonLogFormatter
writer.appLog.formatter.targets=date,logLevel,message,stackTrace
writer.appLog.formatter.datePattern=yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
```

`targets` プロパティにカンマ区切りで出力項目を指定。デフォルトは全項目出力。

| 出力項目 | 説明 |
|---|---|
| date | ログ出力要求時点の日時 |
| logLevel | ログレベル |
| loggerName | ロガー設定の名称 |
| runtimeLoggerName | `LoggerManager` からロガー取得に指定した名称 |
| bootProcess | 起動プロセスを識別する名前 |
| processingSystem | 処理方式を識別する名前 |
| requestId | ログ出力要求時点のリクエストID |
| executionId | ログ出力要求時点の実行時ID |
| userId | ログインユーザのユーザID |
| message | ログのメッセージ |
| stackTrace | 例外オブジェクトのスタックトレース |
| payload | オプション情報に指定されたオブジェクト |

> **補足**: `datePattern` および `label`（ログレベルの文言指定）は `BasicLogFormatter` と同様に機能する。

**出力例**:
```
{"date":"2021-02-04 12:34:56.789","logLevel":"INFO","message":"hello"}
```

### payloadによる項目追加

`targets` に `payload` を含む場合、オプション情報の `Map<String, Object>` がJSONオブジェクトとして出力される。

| Javaクラス | JSON出力 |
|---|---|
| String | JSON文字列 |
| Number及びサブクラス（Integer, Long, Short, Byte, Float, Double, BigDecimal, BigInteger, AtomicInteger, AtomicLong） | `toString()` の戻り値をJSON数値。NaN・無限大はJSON文字列 |
| Boolean | JSON真理値（`true`/`false`） |
| Date, Calendar及びサブクラス, LocalDateTime | JSON文字列。デフォルト書式 `"yyyy-MM-dd HH:mm:ss.SSS"`。書式変更は `datePattern` プロパティで指定 |
| Map実装クラス | JSONオブジェクト。キーがStringでない場合や値がnullの場合はキーごと出力されない。nullを出力するには `ignoreNullValueMember=false` を指定 |
| List実装クラス、配列 | JSON配列 |
| null | JSON null。MapのValueがnullのときはデフォルトで出力対象外 |
| その他 | `toString()` の戻り値をJSON文字列 |

> **補足**: `JsonLogFormatter` 使用時、オプション情報に `Map<String, Object>` 以外をセットしないこと。Mapオブジェクトは複数指定可能だが、キーが重複した場合はいずれかの値が無視される。

**記述例**:
```java
Map<String, Object> structuredArgs = new HashTable<String, Object>();
structuredArgs.put("key1", "value1");
structuredArgs.put("key2", 123);
structuredArgs.put("key3", true);
structuredArgs.put("key4", null);
structuredArgs.put("key5", new Date());
LOGGER.logInfo("addition fields", structuredArgs);
```

**出力例**:
```
{"date":"2021-02-04 12:34:56.789","logLevel":"INFO","message":"addition fields","key1":"value1","key2":123,"key3":true,"key5":"2021-02-04 12:34:56.789"}
```

<details>
<summary>keywords</summary>

JsonLogFormatter, BasicLogFormatter, LoggerManager, targets, datePattern, ignoreNullValueMember, payload, JSON形式ログ出力, 構造化ログ, JsonLogFormatter設定, payload追加, writer.appLog.formatter.className, writer.appLog.formatter.targets, writer.appLog.formatter.datePattern

</details>

## 各種ログのJSON版フォーマッタ

各種ログのフォーマッタをJSON用に差し替えることで各種ログもJSON形式で出力できる。それぞれのフォーマッタの具体的な設定方法は各ログのリンク先を参照のこと。

| ログの種類 | フォーマッタ |
|---|---|
| :ref:`障害ログ <failure_log-json_setting>` | `FailureJsonLogFormatter` |
| :ref:`SQLログ <sql_log-json_setting>` | `SqlJsonLogFormatter` |
| :ref:`パフォーマンスログ <performance_log-json_setting>` | `PerformanceJsonLogFormatter` |
| :ref:`HTTPアクセスログ <http_access_log-json_setting>` | `HttpAccessJsonLogFormatter` |
| :ref:`HTTPアクセスログ（RESTfulウェブサービス用） <jaxrs_access_log-json_setting>` | `JaxRsAccessJsonLogFormatter` |
| :ref:`メッセージングログ <messaging_log-json_setting>` | `MessagingJsonLogFormatter` |

<details>
<summary>keywords</summary>

FailureJsonLogFormatter, SqlJsonLogFormatter, PerformanceJsonLogFormatter, HttpAccessJsonLogFormatter, JaxRsAccessJsonLogFormatter, MessagingJsonLogFormatter, 各種ログJSON, フォーマッタ差し替え, 障害ログ, SQLログ, パフォーマンスログ, HTTPアクセスログ, メッセージングログ

</details>

## NablarchバッチのJSON出力設定

Nablarchバッチでは上述のフォーマッタ設定に加えて以下の3つの設定が必要。

### ApplicationSettingJsonLogFormatter

`ApplicationSettingLogFormatter` をJSON形式で出力するには `ApplicationSettingJsonLogFormatter` に切り替える。

| プロパティ名 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| applicationSettingLogFormatter.className | ○ | | `nablarch.core.log.app.ApplicationSettingJsonLogFormatter` を指定 |
| applicationSettingLogFormatter.appSettingTargets | | systemSettings | アプリ設定ログ出力項目（業務日付なし）。指定可能: `systemSettings`, `businessDate` |
| applicationSettingLogFormatter.appSettingWithDateTargets | | 全項目 | アプリ設定ログ出力項目（業務日付あり）。指定可能: `systemSettings`, `businessDate` |
| applicationSettingLogFormatter.systemSettingItems | | 空（出力なし） | 出力するシステム設定値の名前一覧（カンマ区切り） |
| applicationSettingLogFormatter.structuredMessagePrefix | | $JSON$ | JSON形式メッセージ識別マーカー。メッセージ先頭に付与され `JsonLogFormatter` がJSONデータとして処理する |

```properties
applicationSettingLogFormatter.className=nablarch.core.log.app.ApplicationSettingJsonLogFormatter
applicationSettingLogFormatter.structuredMessagePrefix=$JSON$
applicationSettingLogFormatter.appSettingTargets=systemSettings
applicationSettingLogFormatter.appSettingWithDateTargets=systemSettings,businessDate
applicationSettingLogFormatter.systemSettingItems=dbUser,dbUrl,threadCount
```

### LauncherJsonLogFormatter

`LauncherLogFormatter` をJSON形式で出力するには `LauncherJsonLogFormatter` に切り替える。

| プロパティ名 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| launcherLogFormatter.className | ○ | | `nablarch.fw.launcher.logging.LauncherJsonLogFormatter` を指定 |
| launcherLogFormatter.startTargets | | 全項目 | 開始ログ出力項目。指定可能: `label`, `commandLineOptions`, `commandLineArguments` |
| launcherLogFormatter.endTargets | | 全項目 | 終了ログ出力項目。指定可能: `label`, `exitCode`, `executeTime` |
| launcherLogFormatter.startLogMsgLabel | | BATCH BEGIN | 開始ログのlabel値 |
| launcherLogFormatter.endLogMsgLabel | | BATCH END | 終了ログのlabel値 |
| launcherLogFormatter.structuredMessagePrefix | | $JSON$ | JSON形式メッセージ識別マーカー |

```properties
launcherLogFormatter.className=nablarch.fw.launcher.logging.LauncherJsonLogFormatter
launcherLogFormatter.structuredMessagePrefix=$JSON$
launcherLogFormatter.startTargets=label,commandLineOptions,commandLineArguments
launcherLogFormatter.endTargets=label,exitCode,executionTime
launcherLogFormatter.startLogMsgLabel=BATCH BEGIN
launcherLogFormatter.endLogMsgLabel=BATCH END
```

### JsonCommitLogger

コミット件数をJSON形式でログ出力するには `JsonCommitLogger` をコンポーネントとして定義する（デフォルトは `BasicCommitLogger`）。コンポーネント名は `commitLogger` で定義すること。

```xml
<component name="commitLogger" class="nablarch.core.log.app.JsonCommitLogger">
  <property name="interval" value="${nablarch.commitLogger.interval}" />
</component>
```

<details>
<summary>keywords</summary>

ApplicationSettingJsonLogFormatter, ApplicationSettingLogFormatter, LauncherJsonLogFormatter, LauncherLogFormatter, CommitLogger, BasicCommitLogger, JsonCommitLogger, structuredMessagePrefix, applicationSettingLogFormatter.className, applicationSettingLogFormatter.appSettingTargets, applicationSettingLogFormatter.appSettingWithDateTargets, applicationSettingLogFormatter.systemSettingItems, launcherLogFormatter.className, launcherLogFormatter.startTargets, launcherLogFormatter.endTargets, launcherLogFormatter.startLogMsgLabel, launcherLogFormatter.endLogMsgLabel, バッチJSON設定, commitLogger

</details>

## SynchronousFileLogWriterを使用するにあたっての注意事項

> **重要**: `SynchronousFileLogWriter` は複数プロセスからの書き込み用に作成されたものだが、:ref:`障害通知ログ <failure_log>` のように出力頻度が低いログ出力にのみ使用すること。頻繁にログを出力する場面で使用するとロック取得待ちによる性能劣化や競合によるログの消失が発生する可能性がある。アプリケーションログやアクセスログのように出力頻度の高いログに使用してはいけない。

> **重要**: 以下の制約があるため、使用にあたっては十分検討すること。
> - ログのローテーションができない。
> - 出力されるログの内容が正常でない場合がある。

**クラス**: `nablarch.core.log.basic.SynchronousFileLogWriter`

ロックファイルを用いて排他制御を行いながらファイルにログを書き込む。ロック取得の待機時間を超えてもロックを取得できない場合は、強制的にロックファイルを削除し自身のスレッド用のロックファイルを生成してからログを出力する。強制削除できない場合、またはロックファイル生成失敗・割り込み発生の場合は、ロックを取得していない状態で強制的にログを出力する。

> **重要**: ロックを取得しない状態で強制的にログを出力する場合に、複数プロセスからのログ出力が競合するとログが正常に出力されない場合がある。

障害が発生した場合、強制出力したログに加えて同一ログファイルに障害ログを出力する。障害コードを設定することで障害通知ログのフォーマット（障害コードを含む）で出力可能。障害コードの設定を推奨する。

| プロパティ名 | 障害の内容 | ログレベル | メッセージの設定例 | デフォルトメッセージ |
|---|---|---|---|---|
| failureCodeCreateLockFile | ロックファイルが生成できない | FATAL | ロックファイルの生成に失敗しました。おそらくロックファイルのパスが間違っています。ロックファイルパス=[{0}]。({0}にはロックファイルのパスが設定される) | failed to create lock file. perhaps lock file path was invalid. lock file path=[{0}]. |
| failureCodeReleaseLockFile | 生成したロックファイルを解放(削除)できない | FATAL | ロックファイルの削除に失敗しました。ロックファイルパス=[{0}]。({0}にはロックファイルのパスが設定される) | failed to delete lock file. lock file path=[{0}]. |
| failureCodeForceDeleteLockFile | 解放されないロックファイルを強制削除できない | FATAL | ロックファイルの強制削除に失敗しました。ロックファイルが不正に開かれています。ロックファイルパス=[{0}]。({0}にはロックファイルのパスが設定される) | failed to delete lock file forcedly. lock file was opened illegally. lock file path=[{0}]. |
| failureCodeInterruptLockWait | ロック取得待ちでスレッドをスリープしている際に割り込みが発生 | FATAL | ロック取得中に割り込みが発生しました。 | interrupted while waiting for lock retry. |

> **重要**: 障害コードを設定した場合、障害通知ログのフォーマットで同一ログファイルにログが出力されるが、障害解析ログは出力されない。

設定例:

```properties
writerNames=monitorLog

writer.monitorLog.className=nablarch.core.log.basic.SynchronousFileLogWriter
writer.monitorLog.filePath=/var/log/app/monitor.log
writer.monitorLog.encoding=UTF-8
# 出力バッファのサイズを指定する。(単位はキロバイト。1000バイトを1キロバイトと換算する。指定しなければ8KB)
writer.monitorLog.outputBufferSize=8
writer.monitorLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.monitorLog.level=ERROR
writer.monitorLog.lockFilePath=/var/log/lock/monitor.lock
writer.monitorLog.lockRetryInterval=10
writer.monitorLog.lockWaitTime=3000
writer.monitorLog.failureCodeCreateLockFile=MSG00101
writer.monitorLog.failureCodeReleaseLockFile=MSG00102
writer.monitorLog.failureCodeForceDeleteLockFile=MSG00103
writer.monitorLog.failureCodeInterruptLockWait=MSG00104
```

> **重要**: `maxFileSize`プロパティを指定するとログのローテーションが発生し、ログが出力できなくなるので指定しないこと。

<details>
<summary>keywords</summary>

SynchronousFileLogWriter, nablarch.core.log.basic.SynchronousFileLogWriter, failureCodeCreateLockFile, failureCodeReleaseLockFile, failureCodeForceDeleteLockFile, failureCodeInterruptLockWait, lockFilePath, lockRetryInterval, lockWaitTime, outputBufferSize, 複数プロセス書き込み, ロックファイル排他制御, 障害通知ログ, ログ競合, BasicLogFormatter, maxFileSize, filePath, encoding, level, writerNames

</details>

## LogPublisherの使い方

`LogPublisher` は、出力されたログ情報(`LogContext`)を登録された `LogListener` に連携する機能。出力されたログ情報に対してプログラム的に処理を行いたい場合に使用する。

**クラス**: `nablarch.core.log.basic.LogPublisher`, `nablarch.core.log.basic.LogListener`, `nablarch.core.log.basic.LogContext`

1. `LogPublisher` を `LogWriter` として設定する:

```properties
writerNames=monitorFile,appFile,stdout,logPublisher

writer.logPublisher.className=nablarch.core.log.basic.LogPublisher
writer.logPublisher.formatter.className=nablarch.core.log.basic.BasicLogFormatter

loggers.ROO.nameRegex=.*
loggers.ROO.level=INFO
loggers.ROO.writerNames=appFile,stdout,logPublisher

loggers.MON.nameRegex=MONITOR
loggers.MON.level=ERROR
loggers.MON.writerNames=monitorFile,logPublisher
```

2. `LogListener` の実装クラスを作成する:

```java
package example.micrometer.log;

import nablarch.core.log.basic.LogContext;
import nablarch.core.log.basic.LogListener;

public class CustomLogListener implements LogListener {

    @Override
    public void onWritten(LogContext context) {
        // LogContext を使った処理を実装する
    }
}
```

3. `LogListener` のインスタンスを `LogPublisher` の `static` メソッドで登録する:

```java
LogListener listener = new CustomLogListener();
LogPublisher.addListener(listener);
```

登録した `LogListener` は、`removeListener(LogListener)` または `removeAllListeners()` で削除できる。

<details>
<summary>keywords</summary>

LogPublisher, LogListener, LogContext, nablarch.core.log.basic.LogPublisher, nablarch.core.log.basic.LogListener, nablarch.core.log.basic.LogContext, addListener, removeListener, removeAllListeners, ログイベント連携, ログリスナー登録, onWritten

</details>

## ログレベルの定義

ログレベルは6段階。FATALからTRACEに向かって順にレベルが低くなる。設定で指定されたレベル以上のログをすべて出力する（例: WARNレベル指定時はFATAL・ERROR・WARNのみ出力）。

| ログレベル | 説明 |
|---|---|
| FATAL | アプリケーションの継続が不可能になる深刻な問題。監視が必須で即通報および即対応が必要。 |
| ERROR | アプリケーションの継続に支障をきたす問題。監視が必須だがFATALほどの緊急性はない。 |
| WARN | すぐには影響がないが放置するとアプリケーションの継続に支障をきたす恐れがある事象。 |
| INFO | 本番運用時にアプリケーション情報を出力するレベル。アクセスログや統計ログが該当。 |
| DEBUG | 開発時にデバッグ情報を出力するレベル。SQLログや性能ログが該当。 |
| TRACE | 開発時にデバッグ情報よりさらに細かい情報を出力したい場合に使用するレベル。 |

> **補足**: 本番運用時はINFOレベルでログを出力することを想定している。ログファイルのサイズが肥大化しないように、プロジェクト毎にログの出力内容を規定すること。

> **補足**: フレームワークが出力するログについては、:ref:`log-fw_log_policy` を参照すること。

<details>
<summary>keywords</summary>

FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ログレベル定義, ログ出力制御

</details>

## フレームワークのログ出力方針

| ログレベル | 出力方針 |
|---|---|
| FATAL/ERROR | 障害ログの出力時にFATAL/ERRORレベルで出力する。1件の障害に対して1件の障害ログを出力する方針。実行制御基盤では単一のハンドラ（例外を処理するハンドラ）により障害通知ログを出力する。 |
| WARN | 障害発生時に連鎖して例外が発生した場合など、障害ログとして出力できない例外をWARNレベルで出力する。例: 業務処理とトランザクション終了処理の両方で例外が発生した場合、業務処理の例外を障害ログに出力し、トランザクション終了処理の例外をWARNで出力する。 |
| INFO | アプリケーションの実行状況に関連するエラーを検知した場合にINFOレベルで出力する。例: URLパラメータの改竄エラー、認可チェックエラー。 |
| DEBUG | アプリケーション開発時に使用するデバッグ情報を出力する。DEBUGレベルを設定することで開発に必要な情報が出力されるよう考慮されている。 |
| TRACE | フレームワーク開発時に使用するデバッグ情報を出力する。アプリケーション開発での使用は想定していない。 |

<details>
<summary>keywords</summary>

フレームワークログ出力方針, 障害ログ, FATAL, ERROR, WARN, INFO, DEBUG, TRACE

</details>

## log4jとの機能比較

凡例: ○=提供あり、△=一部提供あり、×=提供なし、—=対象外

| 機能 | Nablarch | log4j |
|---|---|---|
| ログの出力有無をログレベルで制御できる | ○ | ○ |
| ログの出力有無をカテゴリ(パッケージ単位や名前など)で制御できる | ○ | ○ |
| 1つのログを複数の出力先に出力できる | ○ | ○ |
| ログを標準出力に出力できる | ○ | ○ |
| ログをファイルに出力できる | ○ | ○ |
| ファイルサイズによるログファイルのローテーションができる | △ [1] | ○ |
| 日時によるログファイルのローテーションができる | △ [1] | ○ |
| ログをメールで送信できる | × [2] | ○ |
| ログをTelnetで送信できる | × [2] | ○ |
| ログをSyslogで送信できる | × [2] | ○ |
| ログをWindows NTのイベントログに追加できる | × [2] | ○ |
| データベースにログを出力できる | × [2] | ○ |
| ログを非同期で出力できる | × [2] | ○ |
| ログのフォーマットをパターン文字列で指定できる | ○ | ○ |
| 障害ログを出力できる | ○ | — |
| HTTPアクセスログを出力できる | ○ | — |
| SQLログを出力できる | ○ | — |
| パフォーマンスログを出力できる | ○ | — |
| メッセージングログを出力できる | ○ | — |

[1] Nablarchのログ出力はファイルの世代管理を提供していないので、一部提供ありとしている。
[2] :ref:`log_adaptor` を使用する。または、プロジェクトで作成する。作成方法は :ref:`log-add_log_writer` を参照。

<details>
<summary>keywords</summary>

log4j, 機能比較, ログローテーション, log_adaptor, log-add_log_writer, ファイルサイズローテーション, 非同期ログ出力

</details>
