# ログ出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogWriter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/Logger.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LoggerFactory.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogger.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLoggerFactory.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/FileLogWriter.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/SynchronousFileLogWriter.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/StandardOutputLogWriter.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogPublisher.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/BasicLogFormatter.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/DateRotatePolicy.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/FileSizeRotatePolicy.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LoggerManager.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogLevel.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/util/FileUtil.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/RotatePolicy.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogWriterSupport.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogLevelLabelProvider.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LogItem.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/JsonLogFormatter.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/FailureJsonLogFormatter.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlJsonLogFormatter.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/PerformanceJsonLogFormatter.html) [27](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpAccessJsonLogFormatter.html) [28](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsAccessJsonLogFormatter.html) [29](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/logging/MessagingJsonLogFormatter.html) [30](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/ApplicationSettingLogFormatter.html) [31](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/ApplicationSettingJsonLogFormatter.html) [32](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/logging/LauncherLogFormatter.html) [33](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/logging/LauncherJsonLogFormatter.html) [34](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/CommitLogger.html) [35](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/BasicCommitLogger.html) [36](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/JsonCommitLogger.html) [37](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogListener.html) [38](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogContext.html)

## 機能概要 — ログ出力機能の実装を差し替えることができる

ログ出力は3つの処理（Logger/LoggerFactory、LogWriter、LogFormatter）で構成され、それぞれの実装を差し替え可能。

- `LogWriter` や `LogFormatter` 単位での差し替えが可能
- 要件を満たせない場合は `Logger` / `LoggerFactory` を実装してほぼ全処理を差し替え可能
- オープンソースのログ出力ライブラリを使用したい場合はLogger/LoggerFactoryを差し替える（詳細は [log_adaptor](../adapters/adapters-log_adaptor.md)）

デフォルト提供クラス:

**Logger/LoggerFactory**:
- `BasicLogger`
- `BasicLoggerFactory`

**LogWriter**:
- `FileLogWriter` (ファイルへ出力、ログのローテーション)
- `SynchronousFileLogWriter` (複数プロセスから1ファイルへの出力)
- `StandardOutputLogWriter` (標準出力へ出力)
- `LogPublisher` (任意のリスナーへ出力)

**LogFormatter**:
- `BasicLogFormatter` (パターン文字列によるフォーマット)

**RotatePolicy**:
- `DateRotatePolicy` (日時によるログのローテーション)
- `FileSizeRotatePolicy` (ファイルサイズによるログのローテーション)

> **重要**: `SynchronousFileLogWriter` を使う場合は [log-synchronous_file_log_writer_attention](#) を参照すること。

> **補足**: ログレベルについては [log-log_level](#) を参照。

システムプロパティを使用して、プロパティファイルと同じキー名で値を指定することにより、ログ出力設定を上書きできる。共通のプロパティファイルを用意しておき、プロセスごとにログ出力設定を変更することが可能。

**設定例**: ロガー設定 `root` のログレベルをINFOに変更する場合

```bash
java -Dloggers.root.level=INFO ...
```

## LogWriterのJsonLogFormatter設定

LogWriterで使用するフォーマッタを `nablarch.core.log.basic.JsonLogFormatter` に変更することで、ログ出力をJSON形式にできる。

properties設定例:
```properties
writer.appLog.formatter.className=nablarch.core.log.basic.JsonLogFormatter
writer.appLog.formatter.targets=date,logLevel,message,information,stackTrace
writer.appLog.formatter.datePattern=yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
```

`targets`プロパティにカンマ区切りで出力項目を指定する。デフォルトは全項目出力。

| 出力項目 | 説明 |
|---|---|
| date | ログ出力要求時点の日時 |
| logLevel | ログレベル |
| loggerName | ロガー設定の名称 |
| runtimeLoggerName | LoggerManagerからロガー取得に指定した名称 |
| bootProcess | 起動プロセスを識別する名前 |
| processingSystem | 処理方式を識別する名前 |
| requestId | ログ出力要求時点のリクエストID |
| executionId | ログ出力要求時点の実行時ID |
| userId | ログ出力要求時点のログインユーザのユーザID |
| message | ログのメッセージ |
| stackTrace | 例外オブジェクトのスタックトレース |
| payload | オプション情報に指定されたオブジェクト |

> **補足**: `datePattern`および`label`（ログレベルの文言指定）は、BasicLogFormatterと同様に機能する。

使用例:
```java
private static final Logger LOGGER = LoggerManager.get(UserManager.class);
LOGGER.logInfo("hello");
// 出力: {"date":"2021-02-04 12:34:56.789","logLevel":"INFO","message":"hello"}
```

### payloadによる独自項目追加

`targets`に`payload`を含む場合、オプション情報の`Map<String, Object>`をJSONオブジェクトとして出力する。Javaオブジェクトの変換ルール:

| Javaクラス | JSON出力 |
|---|---|
| String | JSON文字列 |
| Number（Integer, Long, Short, Byte, Float, Double, BigDecimal, BigInteger, AtomicInteger, AtomicLong）| `toString()`の戻り値をJSON数値として出力。NaN・無限大はJSON文字列 |
| Boolean | `true` / `false` |
| Date, Calendar, LocalDateTime（Java8以降）| JSON文字列。デフォルト書式: `yyyy-MM-dd HH:mm:ss.SSS`。変更は`datePattern`プロパティで指定 |
| Mapの実装クラス | JSONオブジェクト。キーがStringでない場合や値がnullの場合はそのキーも含め出力されない。nullを出力する場合は`ignoreNullValueMember`に`false`をセット |
| Listの実装クラス、配列 | JSON配列 |
| null | JSON null。Mapの値がnullの場合はデフォルトで出力対象外 |
| その他のオブジェクト | `toString()`の戻り値をJSON文字列として出力 |

使用例:
```java
Map<String, Object> structuredArgs = new HashTable<String, Object>();
structuredArgs.put("key1", "value1");
structuredArgs.put("key2", 123);
structuredArgs.put("key3", true);
structuredArgs.put("key4", null);
structuredArgs.put("key5", new Date());
LOGGER.logInfo("addition fields", structuredArgs);
// 出力: {"date":"2021-02-04 12:34:56.789","logLevel":"INFO","message":"addition fields","key1":"value1","key2":123,"key3":true,"key5":"2021-02-04 12:34:56.789"}
```

> **補足**: JsonLogFormatterを使用する場合、オプション情報に`Map<String, Object>`以外をセットしないこと。Mapオブジェクトは複数指定できるが、キーが重複した場合はいずれかの値が無視され出力されない。

**クラス**: `nablarch.core.log.basic.SynchronousFileLogWriter`

> **重要**: `SynchronousFileLogWriter` は複数プロセスからの書き込み用だが、[障害通知ログ](libraries-failure_log.md) のように出力頻度が低いログ出力にのみ使用すること。アプリケーションログやアクセスログのように出力頻度の高いログに `SynchronousFileLogWriter` を使用してはいけない。ロック取得待ちによる性能劣化や競合によるログの消失が発生する可能性がある。

> **重要**: 以下の制約がある。
> - ログのローテーションができない
> - 出力されるログの内容が正常でない場合がある

ロックファイルで排他制御しながらログを書き込む。ロック取得の待機時間を超えた場合、強制的にロックファイルを削除して書き込む。強制削除失敗・ロックファイル生成失敗・割り込み発生時はロック未取得状態で強制出力する。

**ロックを取得しない状態で強制的にログを出力する場合に、複数プロセスからのログ出力が競合するとログが正常に出力されない場合がある。** 障害発生時は同一ログファイルに障害ログも出力する。障害コードを設定することで障害通知ログのフォーマット（障害コードを含む）で出力でき、通常の障害通知ログと同様の方法で監視が可能になるため推奨。

障害コードのプロパティ（`{0}` にはロックファイルのパスが設定される）:

| プロパティ名 | 障害の内容 | ログレベル | メッセージ設定例 | デフォルトログ |
|---|---|---|---|---|
| failureCodeCreateLockFile | ロックファイルが生成できない | FATAL | ロックファイルの生成に失敗しました。おそらくロックファイルのパスが間違っています。ロックファイルパス=[{0}]。 | failed to create lock file. perhaps lock file path was invalid. lock file path=[{0}]. |
| failureCodeReleaseLockFile | 生成したロックファイルを解放(削除)できない | FATAL | ロックファイルの削除に失敗しました。ロックファイルパス=[{0}]。 | failed to delete lock file. lock file path=[{0}]. |
| failureCodeForceDeleteLockFile | 解放されないロックファイルを強制削除できない | FATAL | ロックファイルの強制削除に失敗しました。ロックファイルが不正に開かれています。ロックファイルパス=[{0}]。 | failed to delete lock file forcedly. lock file was opened illegally. lock file path=[{0}]. |
| failureCodeInterruptLockWait | ロック取得待ちでスリープ中に割り込みが発生 | FATAL | ロック取得中に割り込みが発生しました。 | interrupted while waiting for lock retry. |

> **重要**: 障害コードを設定した場合、障害通知ログのフォーマットで同一ログファイルに出力されるが、障害解析ログは出力されない。

設定例:

```properties
writerNames=monitorLog

writer.monitorLog.className=nablarch.core.log.basic.SynchronousFileLogWriter
writer.monitorLog.filePath=/var/log/app/monitor.log
writer.monitorLog.encoding=UTF-8
# 出力バッファのサイズを指定する。単位はキロバイト（1000バイト = 1キロバイト）。デフォルトは8KB。
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

> **重要**: `maxFileSize` プロパティを指定するとログのローテーションが発生し、ログ出力ができなくなることがあるため指定しないこと。

<details>
<summary>keywords</summary>

ログ出力, LogWriter, LogFormatter, Logger, LoggerFactory, BasicLogger, BasicLoggerFactory, FileLogWriter, SynchronousFileLogWriter, StandardOutputLogWriter, LogPublisher, BasicLogFormatter, DateRotatePolicy, FileSizeRotatePolicy, ログ実装差し替え, ログアダプタ, システムプロパティ, ログ設定の上書き, loggers.root.level, プロパティファイル上書き, プロセスごとの設定変更, JsonLogFormatter, LoggerManager, targets, datePattern, ignoreNullValueMember, payload独自項目追加, JSON形式ログ出力, 構造化ログ, nablarch.core.log.basic.SynchronousFileLogWriter, failureCodeCreateLockFile, failureCodeReleaseLockFile, failureCodeForceDeleteLockFile, failureCodeInterruptLockWait, lockFilePath, lockRetryInterval, lockWaitTime, maxFileSize, outputBufferSize, 複数プロセス書き込み, ロックファイル排他制御, 障害通知ログフォーマット

</details>

## 機能概要 — 各種ログの出力機能を予め提供している

本フレームワークでは、アプリケーションに共通で必要とされる各種ログの出力機能を予め提供している。アプリケーションの要件に応じて、ログのフォーマットを設定で変更して使用できる。各種ログの出力機能はフォーマット処理のみを行い、ログの出力処理自体は本ログ出力機能を使用している（[log-app_log_setting](#) 参照）。

Nablarchの提供するアーキタイプから生成したブランクプロジェクトでは各種ログのフォーマットが設定してある。各設定値は :download:`デフォルト設定一覧 <../configuration/デフォルト設定一覧.xlsx>` を参照。

各種ログの種類:

| ログの種類 | 説明 |
|---|---|
| [障害通知ログ](libraries-failure_log.md) | 障害発生時に1次切り分け担当者を特定するのに必要な情報を出力 |
| [障害解析ログ](libraries-failure_log.md) | 障害原因の特定に必要な情報を出力 |
| [SQLログ](libraries-sql_log.md) | SQL文の実行時間とSQL文を出力（パフォーマンスチューニング用） |
| [パフォーマンスログ](libraries-performance_log.md) | 任意の処理の実行時間とメモリ使用量を出力 |
| [HTTPアクセスログ](libraries-http_access_log.md) | ウェブアプリケーションの実行状況、性能・負荷測定情報、証跡ログを出力 |
| [HTTPアクセスログ（RESTfulウェブサービス用）](libraries-jaxrs_access_log.md) | RESTfulウェブサービスの実行状況、性能・負荷測定情報、証跡ログを出力 |
| [メッセージングログ](libraries-messaging_log.md) | メッセージング処理のメッセージ送受信状況を出力 |

> **補足**: 本フレームワークでは、[障害通知ログ](libraries-failure_log.md) と [障害解析ログ](libraries-failure_log.md) を合わせて障害ログと呼ぶ。

**クラス**: `BasicLogFormatter`

プレースホルダを使用してフォーマットを指定する。フォーマットはLogWriterのプロパティに指定する。

**設定例**:
```properties
# BasicLogFormatterを明示的に指定する
writer.appLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter

# プレースホルダを使ってフォーマットを指定する
writer.appLog.formatter.format=$date$ -$logLevel$- $loggerName$ $message$

# 日時フォーマット（デフォルト: "yyyy-MM-dd HH:mm:ss.SSS"）
writer.appLog.formatter.datePattern=yyyy/MM/dd HH:mm:ss[SSS]

# ログレベルの文言（デフォルト: LogLevel列挙型の名前 FATAL/INFOなど）
writer.appLog.formatter.label.fatal=F
writer.appLog.formatter.label.error=E
writer.appLog.formatter.label.warn=W
writer.appLog.formatter.label.info=I
writer.appLog.formatter.label.debug=D
writer.appLog.formatter.label.trace=T
```

### 起動プロセス

アプリケーションを起動した実行環境を特定するための名前。システムプロパティ `nablarch.bootProcess` で指定する。指定がない場合はブランク。

### 処理方式

ウェブ、バッチなどの処理方式を識別する値。[log-basic_setting](#s4) のプロパティファイルに `nablarch.processingSystem` というキーで指定する。指定がない場合はブランク。

### 実行時ID

リクエストIDに対するアプリケーションの個々の実行を識別するID。1つのリクエストIDに対して複数の実行時IDが発行されるため、リクエストIDと実行時IDの関係は1対多。`ThreadContext` を初期化するタイミングで発行され、ThreadContextに設定される。複数のログを紐付けるために使用する。

**ID体系**:
```
起動プロセス＋システム日時(yyyyMMddHHmmssSSS)＋連番(4桁)
※起動プロセスは指定された場合のみ付加する
```

> **重要**: リクエストID、実行時ID、ユーザIDを出力する場合は、取得元が `ThreadContext` のため、ハンドラ構成に [thread_context_handler](../handlers/handlers-thread_context_handler.md) が含まれている必要がある。特にユーザIDは [thread_context_handler-user_id_attribute_setting](../handlers/handlers-thread_context_handler.md) を参照してアプリケーションでセッションに値を設定する必要がある。

### 改行コード・タブ文字

フォーマットに改行コードとタブ文字を含める場合はJavaと同様の記述（`\n`、`\t`）を使用する。改行コードはシステムプロパティ `line.separator` から取得されるため、変更しなければOSの改行コードが使用される。

> **補足**: `BasicLogFormatter` では `\n` と `\t` という文字列は出力できない。

## 各種ログのJSON版フォーマッタ

各種ログのフォーマッタをJSON用に差し替えることで、各種ログもJSON形式で出力できる。具体的な設定方法は各リンク先を参照。

| ログの種類 | フォーマッタ |
|---|---|
| 障害ログ | FailureJsonLogFormatter (`nablarch.core.log.app.FailureJsonLogFormatter`) |
| SQLログ | SqlJsonLogFormatter (`nablarch.core.db.statement.SqlJsonLogFormatter`) |
| パフォーマンスログ | PerformanceJsonLogFormatter (`nablarch.core.log.app.PerformanceJsonLogFormatter`) |
| HTTPアクセスログ | HttpAccessJsonLogFormatter (`nablarch.fw.web.handler.HttpAccessJsonLogFormatter`) |
| HTTPアクセスログ（RESTfulウェブサービス用） | JaxRsAccessJsonLogFormatter (`nablarch.fw.jaxrs.JaxRsAccessJsonLogFormatter`) |
| メッセージングログ | MessagingJsonLogFormatter (`nablarch.fw.messaging.logging.MessagingJsonLogFormatter`) |

**クラス**: `nablarch.core.log.basic.LogPublisher`, `nablarch.core.log.basic.LogListener`, `nablarch.core.log.basic.LogContext`

`LogPublisher` は、出力されたログ情報（`LogContext`）を登録された `LogListener` に連携する機能を提供する。出力されたログ情報に対してプログラム的な処理を行いたい場合に使用する。

**使用手順:**

1. `LogPublisher` を `LogWriter` として設定し、ログ情報を処理したいloggerの `writerNames` に追加する

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

2. `LogListener` の実装クラスを作成する

```java
public class CustomLogListener implements LogListener {
    @Override
    public void onWritten(LogContext context) {
        // LogContext を使った処理を実装する
    }
}
```

3. `LogListener` のインスタンスを `LogPublisher` の `static` メソッドで登録する

```java
LogListener listener = new CustomLogListener();
LogPublisher.addListener(listener);
```

登録した `LogListener` の削除: `removeListener(LogListener)` または `removeAllListeners()` で削除できる。

<details>
<summary>keywords</summary>

ログの種類, 障害通知ログ, 障害解析ログ, 障害ログ, SQLログ, パフォーマンスログ, HTTPアクセスログ, メッセージングログ, ブランクプロジェクト, アーキタイプ, デフォルト設定, BasicLogFormatter, nablarch.core.log.basic.BasicLogFormatter, LogFormatter, 起動プロセス, 処理方式, 実行時ID, ThreadContext, nablarch.core.ThreadContext, nablarch.bootProcess, nablarch.processingSystem, ログフォーマット, プレースホルダ, thread_context_handler, datePattern, line.separator, FailureJsonLogFormatter, SqlJsonLogFormatter, PerformanceJsonLogFormatter, HttpAccessJsonLogFormatter, JaxRsAccessJsonLogFormatter, MessagingJsonLogFormatter, ログフォーマッタ差し替え, 各種ログJSON設定, LogPublisher, LogListener, LogContext, nablarch.core.log.basic.LogPublisher, nablarch.core.log.basic.LogListener, nablarch.core.log.basic.LogContext, addListener, removeListener, removeAllListeners, onWritten, ログイベント連携, ログリスナー登録

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

各種ログの出力機能を使うには、[log-basic_setting](#s4) に加えて各種ログの設定が必要。設定はプロパティファイルに行う。

**プロパティファイルの場所**: クラスパス直下の `app-log.properties` を使用する。場所を変更する場合はシステムプロパティ `nablarch.appLog.filePath` をキーにファイルパスを指定する。ファイルパスの指定方法は `FileUtil#getResource` を参照。

```bash
java -Dnablarch.appLog.filePath=file:/var/log/app/app-log.properties ...
```

各種ログの設定は以下を参照:
- [failure_log-setting](libraries-failure_log.md)
- [sql_log-setting](libraries-sql_log.md)
- [performance_log-setting](libraries-performance_log.md)
- [http_access_log-setting](libraries-http_access_log.md)
- [jaxrs_access_log-setting](libraries-jaxrs_access_log.md)
- [messaging_log-setting](libraries-messaging_log.md)

## NablarchバッチのログをJSON形式にする

NablarchバッチのログをJSON形式にするには、各種ログのフォーマッタ設定に加えて以下の3つの設定が必要。

### ApplicationSettingJsonLogFormatter

`ApplicationSettingLogFormatter`（システム設定値をログに出力するときに使用）をJSON形式で出力するには、`ApplicationSettingJsonLogFormatter` に切り替える。

| プロパティ名 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| applicationSettingLogFormatter.className | ○ | | `nablarch.core.log.app.ApplicationSettingJsonLogFormatter`を指定 |
| applicationSettingLogFormatter.appSettingTargets | | `systemSettings` | 業務日付なしの出力項目。カンマ区切り。指定可能: `systemSettings`, `businessDate` |
| applicationSettingLogFormatter.appSettingWithDateTargets | | 全項目 | 業務日付ありの出力項目。カンマ区切り。指定可能: `systemSettings`, `businessDate` |
| applicationSettingLogFormatter.systemSettingItems | | 空（何も出力しない） | 出力するシステム設定値の名前の一覧。カンマ区切り |
| applicationSettingLogFormatter.structuredMessagePrefix | | `$JSON$` | JSONメッセージを識別するマーカー文字列。JsonLogFormatterはこのマーカーがある場合メッセージをJSONデータとして処理 |

設定例:
```properties
applicationSettingLogFormatter.className=nablarch.core.log.app.ApplicationSettingJsonLogFormatter
applicationSettingLogFormatter.structuredMessagePrefix=$JSON$
applicationSettingLogFormatter.appSettingTargets=systemSettings
applicationSettingLogFormatter.appSettingWithDateTargets=systemSettings,businessDate
applicationSettingLogFormatter.systemSettingItems=dbUser,dbUrl,threadCount
```

### LauncherJsonLogFormatter

`LauncherLogFormatter`（バッチの開始・終了ログを出力するときに使用）をJSON形式で出力するには、`LauncherJsonLogFormatter` に切り替える。

| プロパティ名 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| launcherLogFormatter.className | ○ | | `nablarch.fw.launcher.logging.LauncherJsonLogFormatter`を指定 |
| launcherLogFormatter.startTargets | | 全項目 | バッチ開始ログの出力項目。カンマ区切り。指定可能: `label`, `commandLineOptions`, `commandLineArguments` |
| launcherLogFormatter.endTargets | | 全項目 | バッチ終了ログの出力項目。カンマ区切り。指定可能: `label`, `exitCode`, `executeTime` |
| launcherLogFormatter.startLogMsgLabel | | `BATCH BEGIN` | 開始ログのlabelの値 |
| launcherLogFormatter.endLogMsgLabel | | `BATCH END` | 終了ログのlabelの値 |
| launcherLogFormatter.structuredMessagePrefix | | `$JSON$` | JSONメッセージを識別するマーカー文字列 |

設定例:
```properties
launcherLogFormatter.className=nablarch.fw.launcher.logging.LauncherJsonLogFormatter
launcherLogFormatter.structuredMessagePrefix=$JSON$
launcherLogFormatter.startTargets=label,commandLineOptions,commandLineArguments
launcherLogFormatter.endTargets=label,exitCode,executionTime
launcherLogFormatter.startLogMsgLabel=BATCH BEGIN
launcherLogFormatter.endLogMsgLabel=BATCH END
```

### JsonCommitLogger

`CommitLogger`（コミット件数をログに出力するために使用）をJSON形式で出力するには、`JsonCommitLogger` をコンポーネントとして定義する。デフォルトは `BasicCommitLogger` が使用される。

コンポーネント名は `commitLogger` で定義する必要がある。

```xml
<component name="commitLogger" class="nablarch.core.log.app.JsonCommitLogger">
  <property name="interval" value="${nablarch.commitLogger.interval}" />
</component>
```

ログレベルは6段階（高い順）。設定で指定されたレベル以上のログを全て出力する。例えばWARNが設定された場合、FATAL・ERROR・WARNのみ出力する。

| ログレベル | 説明 |
|---|---|
| FATAL | アプリケーションの継続が不可能になる深刻な問題。監視必須で即通報・即対応が必要。 |
| ERROR | アプリケーション継続に支障をきたす問題。監視必須だがFATALほどの緊急性なし。 |
| WARN | すぐには影響しないが放置するとアプリ継続に支障をきたす恐れがある事象。できれば監視。 |
| INFO | 本番運用時のアプリ情報出力レベル。アクセスログや統計ログが該当。 |
| DEBUG | 開発時のデバッグ情報出力レベル。SQLログや性能ログが該当。 |
| TRACE | DEBUGより細かい情報を出力したい場合に使用。 |

> **補足**: 本番運用時はINFOレベルでの出力を想定。ログファイルサイズ肥大化を防ぐため、プロジェクト毎にログ出力内容を規定すること。

> **補足**: フレームワーク自身のログ出力方針については [log-fw_log_policy](#) を参照。

<details>
<summary>keywords</summary>

nablarch-core, nablarch-core-applog, nablarch-core-jdbc, nablarch-fw-web, nablarch-fw-jaxrs, nablarch-fw-messaging, モジュール, Maven依存関係, app-log.properties, nablarch.appLog.filePath, 各種ログ設定, クラスパス, FileUtil, ApplicationSettingLogFormatter, ApplicationSettingJsonLogFormatter, LauncherLogFormatter, LauncherJsonLogFormatter, JsonCommitLogger, BasicCommitLogger, CommitLogger, structuredMessagePrefix, appSettingTargets, appSettingWithDateTargets, systemSettingItems, startTargets, endTargets, startLogMsgLabel, endLogMsgLabel, バッチログJSON設定, FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ログレベル定義, ログ出力制御, 本番運用ログレベル

</details>

## ログを出力する

**クラス**: `nablarch.core.log.Logger`, `nablarch.core.log.LoggerManager`

ログの出力には `Logger` を使用し、`LoggerManager` から取得する。Loggerはクラス変数に保持する。

```java
private static final Logger LOGGER = LoggerManager.get(UserManager.class);
```

```java
// ログの出力有無を事前にチェックし、ログ出力を行う。
if (LOGGER.isDebugEnabled()) {
    String message = "userId[" + user.getId() + "],name[" + user.getName() + "]";
    LOGGER.logDebug(message);
}
```

ロガー名には文字列またはクラスが指定でき、クラスが指定された場合はFQCNがロガー名となる。

> **重要**: 常にログを出力するレベルは事前チェック不要（ソースコードの可読性が落ちるため）。例：本番運用でINFOレベルであればFATAL〜INFOレベルは事前チェックしなくてよい。

> **補足**: SQLログや監視ログなど特定用途の場合はその用途を表す名前（SQL、MONITOR等）をロガー名に指定し、それ以外はクラスのFQCNを指定する。

`FileLogWriter` は設定したポリシーに従ってログファイルのローテーションを行う。デフォルトのローテーションポリシーは `FileSizeRotatePolicy`（ファイルサイズによるローテーション）。`RotatePolicy` の実装クラスを作成することでローテーションポリシーを変更できる。

提供されている `RotatePolicy` の実装クラス:
- `FileSizeRotatePolicy`
- `DateRotatePolicy`

**設定例** (ローテーションポリシーはLogWriterのプロパティに指定):
```properties
writerNames=sample

# rotatePolicyにRotatePolicyが実装されたクラスのFQCNを指定する
writer.sample.rotatePolicy=nablarch.core.log.basic.DateRotatePolicy
# 更新時刻（オプション）
writer.sample.rotateTime=12:00
```

| ログレベル | 出力方針 |
|---|---|
| FATAL/ERROR | 障害ログ出力時に使用。原則として1件の障害に対して1件の障害ログを出力する。実行制御基盤では単一のハンドラ（例外処理ハンドラ）により障害通知ログを出力する。 |
| WARN | 障害発生時に連鎖して例外が発生した場合など、障害ログとして出力できない例外を出力する。例: 業務処理とトランザクション終了処理の両方で例外が発生した場合、業務処理の例外は障害ログ、トランザクション終了処理の例外はWARNレベルで出力する。 |
| INFO | アプリケーション実行状況に関連するエラー検知時に出力。例: URLパラメータ改竄エラー、認可チェックエラー。 |
| DEBUG | アプリ開発時に使用するデバッグ情報を出力。DEBUGレベル設定で開発に必要な情報が出力される。 |
| TRACE | フレームワーク開発時に使用するデバッグ情報。アプリ開発での使用は想定外。 |

<details>
<summary>keywords</summary>

Logger, LoggerManager, isDebugEnabled, logDebug, ログ出力, ロガー名, FQCN, 事前チェック, FileSizeRotatePolicy, nablarch.core.log.basic.FileSizeRotatePolicy, DateRotatePolicy, nablarch.core.log.basic.DateRotatePolicy, RotatePolicy, nablarch.core.log.basic.RotatePolicy, ログローテーション, rotatePolicy, rotateTime, FileLogWriter, フレームワークログ出力方針, 障害ログ出力, WARNレベル連鎖例外, INFOレベル認可エラー, DEBUGレベルデバッグ情報

</details>

## ログ出力の設定

設定はプロパティファイル（クラスパス直下の **log.properties**）に行う。場所を変更する場合はシステムプロパティ `nablarch.log.filePath` で指定する（`FileUtil#getResource` 参照）。

```bash
java -Dnablarch.log.filePath=classpath:nablarch/example/log.properties ...
```

**LoggerFactory設定**:

| プロパティ名 | 説明 |
|---|---|
| `loggerFactory.className` | LoggerFactoryを実装したクラスのFQCN。本機能を使う場合は `nablarch.core.log.basic.BasicLoggerFactory` を指定 |

**LogWriter設定**:

| プロパティ名 | 説明 |
|---|---|
| `writerNames` | 使用する全LogWriterの名前（カンマ区切り） |
| `writer.<名前>.className` | LogWriterを実装したクラスのFQCN |
| `writer.<名前>.<プロパティ名>` | LogWriter毎のプロパティ（詳細は各LogWriterのJavadoc参照） |

**ロガー設定**:

| プロパティ名 | 説明 |
|---|---|
| `availableLoggersNamesOrder` | 使用する全ロガー設定の名前（カンマ区切り） |
| `loggers.<名前>.nameRegex` | ロガー名とのマッチングに使用する正規表現 |
| `loggers.<名前>.level` | `LogLevel` の名前。指定レベル以上を全て出力 |
| `loggers.<名前>.writerNames` | 出力先LogWriterの名前（カンマ区切り） |

> **重要**: `availableLoggersNamesOrder` は記述順に意味がある。ロガー取得時に記述順でマッチングを行い、最初にマッチしたLoggerを返す。より限定的な正規表現のロガー設定から順に記述すること（例：`.*` にマッチする `root` を先に書くと全てのロガー取得が `root` にマッチしてしまう）。

> **重要**: `availableLoggersNamesOrder` と `loggers.*` で指定するロガー設定の名称は必ず一致させること。不一致の場合は `BasicLoggerFactory` の初期処理で例外がスローされる。`availableLoggersNamesOrder` から名前を取り除いた場合は、対応する `loggers.<名前>.*` の設定も取り除く必要がある。

> **補足**: 全てのログ出力にマッチするロガー設定を1つ用意し、`availableLoggersNamesOrder` の最後に指定することを推奨する（設定漏れによる重要ログの欠落を防ぐため）。

プロパティファイル全体の設定例:

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

### LogWriterを追加する

新しいLogWriterを追加する場合は `LogWriter` インタフェースを実装したクラスを作成する。`LogFormatter` を使用するLogWriterを作成する場合は、共通処理を提供する `LogWriterSupport` を継承して作成する。

### LogFormatterを追加する

新しいLogFormatterを追加する場合は `LogFormatter` インタフェースを実装したクラスを作成する。ログレベルの文言を設定で変更可能にしたい場合は `LogLevelLabelProvider` を使用する。

ログ出力時にパラメータを追加したい場合は、`Logger` インタフェースのログ出力メソッドのObject型の可変長引数 `options` を規定して使用する。

```java
// Logger#logInfoメソッドのシグネチャ
public void logInfo(String message, Object... options)
public void logInfo(String message, Throwable cause, Object... options)
```

### ログの出力項目（プレースホルダ）を追加する

`BasicLogFormatter` に新規プレースホルダを追加する場合:

1. `LogItem` を実装したクラスを作成する
2. `BasicLogFormatter` を継承したクラスを作成し `getLogItems(ObjectSettings)` をオーバーライドしてプレースホルダを追加する

**設定例**:
```properties
# カスタムのLogFormatterを指定する
writer.appLog.formatter.className=nablarch.core.log.basic.CustomLogFormatter
writer.appLog.formatter.format=$date$ -$logLevel$- $loggerName$ [$bootProcess$] $message$
writer.appLog.formatter.bootProcess=CUSTOM_PROCESS
```

**LogItemの実装例**:
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
```

**BasicLogFormatterの継承例**:
```java
public class CustomLogFormatter extends BasicLogFormatter {
    @Override
    protected Map<String, LogItem<LogContext>> getLogItems(ObjectSettings settings) {
        Map<String, LogItem<LogContext>> logItems = super.getLogItems(settings);
        logItems.put("$bootProcess$", new CustomBootProcessItem(settings));
        return logItems;
    }
}
```

### ログの初期化メッセージを出力しないようにする

[log_adaptor](../adapters/adapters-log_adaptor.md) を使用した場合は初期化メッセージは出力されないため、本対応は不要。使用しない場合の対応手順:

1. ベースとなるWriterクラスのソースコードをプロジェクト側に取り込む（例: ファイル出力の場合は `FileLogWriter` をコピー）
2. 初期化ログを出力している箇所を削除する
3. `LogWriterSupport` の `needsToWrite` をオーバーライドし、初回の初期化メッセージ（"initialized."で始まるメッセージ）を出力しないよう変更する
4. 作成したクラスをlog.propertiesに設定する

**needsToWriteのオーバーライド例**:
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

**log.propertiesの設定例**:
```properties
writerNames=sample

# 作成したクラスのFQCNを指定する（例: sample.CustomFileLogWriter）
writer.sample.className = sample.CustomFileLogWriter
```

log4jとの機能比較（○：提供あり　△：一部提供あり　×：提供なし　－：対象外）

| 機能 | Nablarch | log4j |
|---|---|---|
| ログの出力有無をログレベルで制御できる | ○ | ○ |
| ログの出力有無をカテゴリ(パッケージ単位や名前など)で制御できる | ○ | ○ |
| 1つのログを複数の出力先に出力できる | ○ | ○ |
| ログを標準出力に出力できる | ○ | ○ |
| ログをファイルに出力できる | ○ | ○ |
| ファイルサイズによるログファイルのローテーションができる | △[1] | ○ |
| 日時によるログファイルのローテーションができる | △[1] | ○ |
| ログをメールで送信できる | ×[2] | ○ |
| ログをTelnetで送信できる | ×[2] | ○ |
| ログをSyslogで送信できる | ×[2] | ○ |
| ログをWindows NTのイベントログに追加できる | ×[2] | ○ |
| データベースにログを出力できる | ×[2] | ○ |
| ログを非同期で出力できる | ×[2] | ○ |
| ログのフォーマットをパターン文字列で指定できる | ○ | ○ |
| 障害ログを出力できる | ○ | — |
| HTTPアクセスログを出力できる | ○ | — |
| SQLログを出力できる | ○ | — |
| パフォーマンスログを出力できる | ○ | — |
| メッセージングログを出力できる | ○ | — |

[1] Nablarchのログ出力はファイルの世代管理を提供していないため、一部提供ありとしている。
[2] [log_adaptor](../adapters/adapters-log_adaptor.md) を使用するか、プロジェクトで作成する（作成方法は [log-add_log_writer](#) を参照）。

<details>
<summary>keywords</summary>

log.properties, loggerFactory.className, writerNames, availableLoggersNamesOrder, loggers.nameRegex, loggers.level, loggers.writerNames, BasicLoggerFactory, LogLevel, ログ設定, ロガー設定, プロパティファイル, nablarch.log.filePath, LogWriter, nablarch.core.log.basic.LogWriter, LogWriterSupport, nablarch.core.log.basic.LogWriterSupport, LogFormatter, nablarch.core.log.basic.LogFormatter, LogLevelLabelProvider, nablarch.core.log.basic.LogLevelLabelProvider, LogItem, nablarch.core.log.LogItem, FileLogWriter, nablarch.core.log.basic.FileLogWriter, Logger, nablarch.core.log.Logger, 拡張, 初期化メッセージ, プレースホルダ追加, needsToWrite, options引数, ObjectSettings, LogContext, BasicLogFormatter, StringUtil, log4j, 機能比較, ログローテーション, log_adaptor, log-add_log_writer, ログ出力機能一覧, 非同期ログ出力

</details>
