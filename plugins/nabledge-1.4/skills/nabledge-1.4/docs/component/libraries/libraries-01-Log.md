# ログ出力

## 概要

フレームワーク、アプリケーションからログ出力を行う機能を提供する。

本機能を使用する際は、明示的な初期処理を必要としない。ただし、ログ出力に使用するリソースを解放するため、終了処理が必要となる。
この終了処理は本フレームワークの他の機能で行う必要がある。
例えば、Webアプリケーションでの終了処理は、 [Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md) の機能で行う。

アプリケーションプログラマは、個別アプリケーション毎のログ出力方針に基づいて、プログラム中でログ出力を行う。
アプリケーションからログを出力する方法は、 [ログ出力](../../component/libraries/libraries-01-Log.md#ログ出力) に記述する。

## 特徴

### ログ出力機能の高い拡張性

本機能は、以下３つの処理から構成されており、それぞれの実装を差し替えることができる構造となっている。:

```
a) ログの書き込み処理
b) ログのフォーマット処理
c) アプリケーションからのログ出力要求受付処理
```

個別アプリケーションのログ出力要件に応じて、aやbの単位で差し替えることもできるし、
これらだけでは要件を満たせなければcを実装してほぼ全ての処理を差し替えることもできる。
例えば、過去のプロジェクトで作成したログ出力ライブラリを使用したい場合などはcを差し替えればよい。
尚、オープンソースで使用実績の多いLog4Jについては、専用のcを既に用意している。
以降では、他のログ出力実装と区別するため、本フレームワークが提供する各実装を「フレームワーク実装」と呼ぶ。

### 各種ログの出力機能

本フレームワークでは、アプリケーションに共通で必要とされる各種ログの出力機能を予め提供している。
本フレームワークが出力機能を提供す各種ログの一例を下記に示す。

* [障害通知ログ](../../component/libraries/libraries-01-FailureLog.md#障害ログの出力)
* [障害解析ログ](../../component/libraries/libraries-01-FailureLog.md#障害ログの出力)
* [SQLログ](../../component/libraries/libraries-02-SqlLog.md#sqlログの出力)
* [パフォーマンスログ](../../component/libraries/libraries-03-PerformanceLog.md#パフォーマンスログの出力)
* [HTTPアクセスログ](../../component/libraries/libraries-04-HttpAccessLog.md#httpアクセスログの出力)
* [メッセージングログ](../../component/libraries/libraries-05-MessagingLog.md#メッセージングログの出力)

各種ログの出力機能では、ログのフォーマットを設定で変更できるので、個別アプリケーションのログ出力要件に応じてカスタマイズして使用できる。

## 要求

### 実装済み

* ログ出力機能の実装を差し替えることができる。
* ログ毎にログの出力有無を制御するログレベルと出力先を設定できる。
* パッケージ単位やクラス単位で設定対象のログを絞り込める。
* 1つのログを複数の出力先に出力できる。これにより、障害解析用と監視用など、1つのログを目的に応じて別々に収集できる。
* ログの出力先を変更できる。
* ログをファイルに出力できる。
* ログファイルが指定サイズに達したら、出力ファイルを自動で切り替える（出力ファイルをバックアップした後、初期化する）ことができる。
* ログのフォーマットを変更できる。
* ログに出力するログレベルを表す文言を変更できる。
* オブジェクト情報(クラス名とフィールドに保持している値)をログに出力できる。
* エラー情報(例外クラスのエラーメッセージとスタックトレース)をログに出力できる。
* ログのフォーマットを設定のみで変更できる。
* 性能測定を目的としたログ集計ができる。
* アクセスログを取得できる。

  * アクセスログにリクエストパラメータを出力できる。
  * アクセスログに含まれるリクエストパラメータの特定項目をマスクできる。
  * アクションの処理結果(正常終了、業務精査エラー、システムエラー)をログに出力できる。
* ログ監視ツールから監視可能なフォーマットでログを出力できる。
* 複数プロセスから1つのログファイルに出力できる。

### 未実装

* データベースにログを出力できる。
* 日付毎に出力ファイルを自動で切り替えることができる。

### 未検討

* リクエストID単位でログの出力有無を制御できる。（リクエストIDについては、 [リクエストの識別と業務処理の実行](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) を参照）
* アプリケーションを停止することなく、設定の変更を反映できる。
* ログファイルの改竄を防止できる。
* ファイルへのログ出力で指定するファイルパスに置換文字を使用できる。
* ログ出力用のスレッドを、業務処理を実行しているワーカスレッドから独立させることができる。
* ログ出力機能の実装を部分的に差し替えることができる。（Log4Jのアペンダだけ使用したい場合など）
* 外部ツールからログの出力ファイルを切り替えることができる。
* ログに出力するスタックトレース内のメッセージをマスクできる。
* フレームワークが行う処理の実行時間を測定できる。
* リクエスト処理の実行時間に対して上限値を指定し、上限値を超えた場合はアラートをログ出力できる。
* 1トランザクションにおけるSQL文の発行回数の上限値を指定し、上限値を超えた場合はアラートをログ出力できる。

## ログ出力要求受付処理

はじめに、ログ出力要求受付処理について解説する。

### クラス図

![Log_ClassDiagram.jpg](../../../knowledge/assets/libraries-01-Log/Log_ClassDiagram.jpg)

#### 各クラスの責務

##### インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| nablarch.core.log.Logger | ログを出力するインタフェース。  ログ出力機能の実装毎に本インタフェースの実装クラスを作成する。 Loggerインタフェースを実装したクラス及びインスタンスをロガーと呼ぶ。 |
| nablarch.core.log.LoggerFactory | ロガーを生成するインタフェース。  フレームワーク内部でログ出力機能の実装に対応するロガーを生成するために使用する。 ログ出力機能の実装毎に本インタフェースの実装クラスを作成する。 LoggerFactoryインタフェースを実装したクラス及びインスタンスをロガーファクトリと呼ぶ。 |

##### クラス定義

a) ロガー

| クラス名 | 概要 |
|---|---|
| nablarch.core.log.basic.BasicLogger | ロガーの基本実装クラス。 |
| nablarch.core.log.log4j.Log4JLogger | Log4Jを使用してログ出力を行うクラス。 |

b) ロガーファクトリ

| クラス名 | 概要 |
|---|---|
| nablarch.core.log.basic.BasicLoggerFactory | BasicLoggerを生成するロガーファクトリの基本実装クラス。 |
| nablarch.core.log.log4j.Log4JLoggerFactory | Log4JLoggerを生成するクラス。 |

c) その他のクラス

| クラス名 | 概要 |
|---|---|
| nablarch.core.log.LoggerManager | ログ出力機能の全体を取りまとめるクラス。  設定で指定されたロガーファクトリを生成・保持する。 ログ出力機能の実装に依存する初期処理・終了処理・ロガーの生成はロガーファクトリに委譲する。 LoggerManagerクラスをロガーマネージャと呼ぶ。 |
| nablarch.core.log.LogSettings | ログ出力機能の設定をロードして保持するクラス。 |

### ログレベルの定義

ログレベルは、Log4JやJava Logging APIといった実装毎に定義が異なるため、ここで本フレームワークにおけるログレベルを定義しておく。

本フレームワークにおけるログレベルは、FATAL>ERROR>WARN>INFO>DEBUG>TRACEの6段階とし、FATALからTRACEに向かって順にレベルが低くなる。
レベルに応じた出力制御では、指定されたレベル以上のログを全て出力する。
例えば、WARNレベルが指定された場合は、FATALレベル,ERRORレベル,WARNレベルで出力を指示しているログのみ出力する。

各ログレベルの意味を下記に示す。

| レベル | 意味 |
|---|---|
| FATAL | アプリケーションの継続が不可能になる深刻な問題が発生したことを示す。 監視が必須で即通報および即対応が必要となる。 |
| ERROR | アプリケーションの継続に支障をきたす問題が発生したことを示す。 監視が必須であるが、通報および対応にFATALレベルほどの緊急性がない。 |
| WARN | すぐには影響を与えないが、放置しておくとアプリケーションの継続に支障をきたす問題になる恐れがある事象が発生したことを示す。 できれば監視した方がよいが、ERRORレベルほどの緊急性がない。 |
| INFO | 本番運用時にアプリケーションの情報を出力するログレベル。 アクセスログや統計ログが該当する。 |
| DEBUG | 開発時にデバッグ情報を出力するログレベル。 SQLログや性能ログが該当する。 |
| TRACE | 開発時にデバッグ情報より、さらに細かい情報を出力したい場合に使用するログレベル。 |

フレームワークが出力するログについては、  [フレームワークのログ出力方針](../../component/libraries/libraries-01-Log.md#フレームワークのログ出力方針) を参照すること。

> **Warning:**
> FATALレベル・ERRORレベル・WARNレベル・INFOレベル:

> ```
> 通常は、運用監視体制と密接に関わるため、個別アプリケーションではなくフレームワークで出力する。
> 例外として、業務的には必要であるがフレームワークでは出力できないログ（バッチ処理における処理件数など）を出力したい場合などには、
> プロジェクトの方針に従い、個別アプリケーションからもログ出力を行う。
> ```

> DEBUGレベル・TRACEレベル:

> ```
> ログの出力量が増えることにより、性能劣化とログファイルのサイズが肥大化するため、通常の本番運用時には出力してはならない。
> ```

> **Note:**
> 通常は、本番運用時にINFOレベルでログを出力する。ログファイルのサイズが肥大化しないよう各プロジェクトにて出力内容を規定すること。

### ログ出力

アプリケーションからログを出力するには、ロガーを使用する。このロガーはロガーマネージャから取得する。
出力実装例を下記に示す。この例では、UserManagerクラスにおいて、DEBUGレベルのログを出力している。

```java
// ロガーの取得。クラス変数に保持する。
private static final Logger LOGGER = LoggerManager.get(UserManager.class);
```

```java
// ログの出力有無を事前にチェックし、ログ出力を行う。
if (LOGGER.isDebugEnabled()) {
    String message = "userId[" + user.getId() + "],name[" + user.getName() + "]";
    LOGGER.logDebug(message);
}
```

ロガーの取得処理では、ロガー名を引数に指定する。ロガー名の指定方法は、ロガー名を直接指定する方法とクラスを指定する方法がある。
クラスを指定した場合は、指定されたクラスのFQCNをロガー名として使用する。

このロガー名に、出力要求側（つまり出力要求を行うアプリケーション）のFQCNを指定しておくと、そのFQCN毎にログ出力設定を変更できる。
例えば、出力要求を行うアプリケーションのクラス毎やパッケージ毎に設定を変更できる。

通常ロガー名には、SQLログや監視ログなど、特定の用途向けのログ出力を行う場合は、その用途を表す名前(SQLやMONITOR等）を指定し、
それ以外はクラスのFQCNを指定する。アプリケーションプログラマは、個別アプリケーションのログ出力方針に基づき、ロガー名を指定すること。

メッセージの組み立て処理が必要な場合は、Logger#is<ログレベル>Enabledメソッドを使用して、事前に出力有無をチェックすること。
ログの出力を行わない場合には、不必要なログ組み立て処理が実行されることによる性能劣化を防ぐためである。

> **Note:**
> 個別アプリケーションにおいて、常にログを出力することになっているレベルは、ソースコードの可読性が落ちるため、事前チェックをしなくてよい。
> 例えば、本番運用時に出力するログレベルをINFOレベルにするのであれば、FATALレベルからINFOレベルまでは事前チェックしなくてよい。

### 初期処理と終了処理

ログの出力先によってはリソースの確保と解放が必要となるため、本機能ではロガーマネージャが初期処理と終了処理を行う。

初期処理は、始めてロガーの取得が行われるタイミングでロガーマネージャが内部的に実行するが、
終了処理は、フレームワーク側で実行するタイミングを判断できない。
そのため、個別アプリケーション毎にアプリケーションの終了時にLoggerManager#terminateメソッドを呼び出すこと。

> **Warning:**
> 本機能を使用する場合は、ロガーマネージャの終了処理の呼び出しをしないと、
> アプリケーション終了後にメモリリークが発生する可能性があるため、必ず終了処理を呼び出すこと。

Webアプリケーションでの終了処理は、 [Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md) の機能で行う。

### ロガーファクトリの設定方法

個別アプリケーションにおいて使用する実装（フレームワーク実装やLog4Jなど）は、どのロガーファクトリを使用するかで決まる。
使用するロガーファクトリは、プロパティファイルに「loggerFactory.className = LoggerFactoryインタフェースを実装したクラス」で設定する。

プロパティファイルの記述例を下記に示す。

```bash
# フレームワーク実装を使用する例
loggerFactory.className=nablarch.core.log.basic.BasicLoggerFactory
```

```bash
# Log4Jを使用する例
loggerFactory.className=nablarch.core.log.log4j.Log4JLoggerFactory
```

プロパティファイルのパスは、システムプロパティを使用して、"nablarch.log.filePath"をキーにファイルパスを指定する。
このファイルパスは、クラスパスとファイルシステム上のパスのどちらを指定しても良い。
ファイルパスの指定方法は、nablarch.core.util.FileUtil#getResource(String)のJavadocを参照すること。
システムプロパティを指定しなかった場合は、クラスパス直下のlog.propertiesが使用される。

クラスパス上のパスを指定する例を下記に示す。
javaコマンドのオプション-Dによる指定を用いて、下記のように実行時のオプションとしてシステムプロパティを設定する。

```bash
>java -Dnablarch.log.filePath=classpath:nablarch/core/log/log.properties ...
```

> **Note:**
> プロパティファイルが存在しない場合は、ロガーマネージャが例外を送出する。

## 書き込み処理とフォーマット処理

ここからは、ログの書き込み処理とフォーマット処理について解説する。

### クラス図

![Log_Basic_ClassDiagram.jpg](../../../knowledge/assets/libraries-01-Log/Log_Basic_ClassDiagram.jpg)

#### 各クラスの責務

##### インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| nablarch.core.log.basic.LogWriter | ログを出力先に書き込むインタフェース。  出力先の媒体毎に本インタフェースの実装クラスを作成する。 LogWriterインタフェースを実装したクラス及びインスタンスをログライタと呼ぶ。 |
| nablarch.core.log.basic.LogFormatter | ログのフォーマットを行うインタフェース。  ログのフォーマットの種類毎に本インタフェースの実装クラスを作成する。 LogFormatterインタフェースを実装したクラス及びインスタンスをログフォーマッタと呼ぶ。 |

##### クラス定義

a) ログライタ

| クラス名 | 概要 |
|---|---|
| nablarch.core.log.basic.LogWriterSupport | ログライタの実装をサポートするクラス。  ログレベルに応じた出力制御とログフォーマッタを使用したログのフォーマットを行う。 サブクラスでは、フォーマット済みのログの書き込み処理を実装する。 |
| nablarch.core.log.basic.FileLogWriter | ファイルにログを書き込むクラス。  ファイルにログを出力するのであれば、基本的にはFileLogWriterを使用すれば良いが、 ファイルサイズや日付以外の条件でログファイルの自動切り替えを実現する必要がある場合には、 これを実装したクラスを作成して入れ替える。  > **Note:** > 本ログライタは、プロセス単位にログを出力する。 > 複数プロセスから単一のログファイルに出力したい場合には、後述の *SynchronousFileLogWriter* を使用すること。 |
| nablarch.core.log.basic.SynchronousFileLogWriter | 複数プロセスから単一のファイルにログを書き込むクラス。  本クラスを使用するとプロセスをまたがってログ出力処理を直列化できるので、 複数プロセスから単一のファイルにログ出力を行う場合でも確実にログを出力できる。  用途としては、障害通知ログのように出力頻度が低く、かつサーバ単位でログファイルを一元管理するほうが効率的なログの出力にのみ使用することを想定している。 頻繁にログの出力が行われる場面で本クラスを使用するとロック取得待ちによって性能が著しく劣化するので、 アプリケーションログやアクセスログのように出力頻度の高いログ出力での使用は推奨しない。  > **Note:** > 直列化の方法として、ロックファイルを使用してプロセス間の同期をとりログ出力を行う。 |
| nablarch.core.log.basic.StandardOutputLogWriter | 標準出力にログを書き込むクラス。 |

b) ログフォーマッタ

| クラス名 | 概要 |
|---|---|
| nablarch.core.log.basic.BasicLogFormatter | ログフォーマッタの基本実装クラス。  ログに最低限必要な情報（日時、ユーザID、リクエストIDなど）、 オブジェクトのフィールド情報、例外オブジェクトのスタックトレースなどをログ出力用にフォーマットする。 デバッグ情報やアクセスログ、障害解析用のログなど、多目的に使用できる。 |

c) その他のクラス

| クラス名 | 概要 |
|---|---|
| nablarch.core.log.basic.LogContext | ログ出力に必要な情報を保持するクラス。  メッセージ、エラー情報、日時、ユーザID、リクエストIDなどを保持する。 ユーザID、リクエストIDは、ThreadContextから取得する。 |
| nablarch.core.log.basic.LogLevelLabelProvider | ログに出力するログレベルを表す文言を提供するクラス。 |

##### 列挙型

| クラス名 | 概要 |
|---|---|
| nablarch.core.log.basic.LogLevel | ログレベルを表す列挙型。 |

### フレームワーク実装の設定方法

フレームワーク実装の設定は、ロガーファクトリの設定と同じプロパティファイルに記述する。
プロパティファイルのパスの指定方法については、 [ロガーファクトリの設定方法](../../component/libraries/libraries-01-Log.md#ロガーファクトリの設定方法) を参照すること。

プロパティファイルの記述例を下記に示す。
記述ルールの詳細は、 [プロパティファイルの記述ルール](../../component/libraries/libraries-01-Log.md#プロパティファイルの記述ルール) に記述する。

```bash
# フレームワーク実装のロガーファクトリを指定する。
loggerFactory.className=nablarch.core.log.basic.BasicLoggerFactory

# 使用する全てのログライタの名称を指定する。
# 「"writer." + <ここで指定した名称>」を使用してログライタ毎の設定を行う。
writerNames=appFile,sqlFile,monitorFile,stdout

# ログライタ毎の設定
# <ログライタのプレフィックス>.classNameに使用するログライタのクラス名を指定する。
# className以外のプロパティは、使用するログライタに応じて設定内容が変わるため、
# ログライタのJavadocを参照すること。

# アプリケーション用のログファイルの設定例
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=/var/log/app/app.log

# SQL出力用のログファイルの設定例
writer.sqlFile.className=nablarch.core.log.basic.FileLogWriter
writer.sqlFile.filePath=/var/log/app/sql.log

# 監視用のログファイルの設定例
writer.monitorFile.className=nablarch.core.log.basic.SynchronousFileLogWriter
writer.monitorFile.filePath=/var/log/app/monitoring.log
writer.monitorFile.lockFilePath=/var/log/lock/monitor.lock
writer.monitorFile.failureCodeCreateLockFile=MSG00101
writer.monitorFile.failureCodeReleaseLockFile=MSG00102
writer.monitorFile.failureCodeForceDeleteLockFile=MSG00103
writer.monitorFile.failureCodeInterruptLockWait=MSG00104

# 標準出力の設定例
writer.stdout.className=nablarch.core.log.basic.StandardOutputLogWriter

# 全てのロガー設定の名称を指定する。
# ロガー設定については、下記の「ロガー設定」にて解説する。
# 「"loggers." + <ここで指定された名称>」を使用してロガー設定毎の設定を行う。
# ここでの記述順は、意味があるので注意すること。下記の警告を参照。
availableLoggersNamesOrder=sql,monitoring,access,validation,root

# 全てのロガー名をログ出力の対象にする設定例
# 全てのロガー取得を対象に、WARNレベル以上をappFileに出力する。
loggers.root.nameRegex=.*
loggers.root.level=WARN
loggers.root.writerNames=appFile

# 特定のロガー名をログ出力の対象にする設定例。
# ロガー名に"MONITOR"を指定したロガー取得を対象に、
# ERRORレベル以上をappFile,monitorFileに出力する。
loggers.monitoring.nameRegex=MONITOR
loggers.monitoring.level=ERROR
loggers.monitoring.writerNames=appFile,monitorFile

# 特定のロガー名をログ出力の対象にする設定例。
# ロガー名に"SQL"を指定したロガー取得を対象に、
# DEBUGレベル以上をsqlFileに出力する。
loggers.sql.nameRegex=SQL
loggers.sql.level=DEBUG
loggers.sql.writerNames=sqlFile

# 特定のクラスをログ出力の対象にする設定例。
# ロガー名に"app.user.UserManager"を指定したロガー取得を対象に、
# INFOレベル以上をappFileとstdoutに出力する。
loggers.access.nameRegex=app\\.user\\.UserManager
loggers.access.level=INFO
loggers.access.writerNames=appFile,stdout

# 特定のパッケージ以下をログ出力の対象にする設定例。
# ロガー名に"nablarch.core.validation"から始まる名前を指定したロガー取得を対象に、
# DEBUGレベル以上をstdoutに出力する。
loggers.validation.nameRegex=nablarch\\.core\\.validation\\..*
loggers.validation.level=DEBUG
loggers.validation.writerNames=stdout
```

> **Warning:**
> availableLoggersNamesOrderプロパティは、記述順に意味があるので注意すること。
> ロガーの取得では、ログ出力を行うクラスが指定したロガー名に対して、
> ここに記述した順番でロガーのマッチングを行い、最初にマッチしたロガーを返す。
> 例えば、上記の設定にあるavailableLoggersNamesOrderの記述順をavailableLoggersNamesOrder=root,sqlと記述した場合、
> 全てのロガー取得がロガー設定「root」にマッチしてしまう。
> その結果、ロガー名「SQL」でログ出力してもログライタ「sqlFile」に出力されず、
> ロガー設定「root」に指定されたログライタ「appFile」に出力される。
> したがって、availableLoggersNamesOrderプロパティは、より限定的な正規表現を指定したロガー設定から順に記述すること。

> **Warning:**
> availableLoggersNamesOrderとloggers.*で指定するロガー設定の名称は、必ず一致させる必要がある。
> BasicLoggerFactoryの初期処理で一致しているかチェックを行い、一致しない場合は例外をスローする。
> 例えば、上記の設定にあるavailableLoggersNamesOrderからaccessを取り除くと、例外がスローされる。
> このチェックは、設定漏れの発生を防ぐために行っている。
> 上記の設定にあるavailableLoggersNamesOrderからaccessを取り除いた場合は、明示的にloggers.access.*の設定も取り除く必要がある。

> **Note:**
> ロガー設定では、全てのログ出力にマッチするロガー設定を1つ用意し、availableLoggersNamesOrderの最後に指定することを推奨する。
> 万が一設定が漏れた場合でも、重要なログの出力を逃してしまう事態を防ぐことができる。

> 設定例を以下に示す。

> ```bash
> availableLoggersNamesOrder=sql,app,root
> 
> loggers.root.nameRegex=.*
> loggers.root.level=WARN
> loggers.root.writerNames=appFile
> ```

プロパティファイルの設定は、システムプロパティを使用して、プロパティファイルと同じキー名で値を指定することにより上書きすることができる。
この機能を使用して、共通のプロパティファイルに記述し、プロセス毎にログ出力設定を変更したい場合には **-D** オプションで上書きを行うことが出来るようになる。
例えば、上記の設定にあるロガー「root」のログレベルをWARNからINFOに変更したい場合は、javaコマンドのオプション **-D** による指定を用いて、
下記のように実行時のオプションとしてシステムプロパティを設定する。

```bash
>java -Dloggers.root.level=INFO ...
```

BasicLoggerFactoryクラスは、初期処理完了後に、各ログライタに対してロガー設定の情報をINFOレベルで出力する。
上記設定例のログライタ「appFile」に対する出力例を下記に示す。

```java
2012-04-18 11:11:04.525 -INFO- nablarch.core.log.basic.BasicLoggerFactory [null] boot_proc = [] proc_sys = [] req_id = [null] usr_id = [null] initialized.
    LOGGER = [monitoring] NAME REGEX = [MONITOR] LEVEL = [ERROR]
    LOGGER = [access] NAME REGEX = [app\.user\.UserManager] LEVEL = [INFO]
    LOGGER = [root] NAME REGEX = [.*] LEVEL = [WARN]
```

#### ロガー設定

ロガー設定では、3つのプロパティを指定する。:

```
a) <ロガー設定のプレフィックス>.nameRegex   : このロガー設定の対象となるロガーを絞り込むための正規表現
b) <ロガー設定のプレフィックス>.level       : ログの出力有無の基準とするログレベル
c) <ロガー設定のプレフィックス>.writerNames : 出力先とするログライタの名称（複数可）
```

aは、bとcと設定値の意味が異なる。
aの正規表現は、ロガー設定(bとc)の対象となるロガーを絞り込むために使用する。
ロガーの取得時に指定されたロガー名（つまりLoggerManager#getメソッドの引数に指定されたロガー名）に対してマッチングを行う。
一方、bとcは、aで絞り込まれたロガーに対して設定される。

ロガー設定のイメージをつかむために例を示す。

例えば、下記3つのクラスのロガー取得に対する設定例を示す。
LoggerManager#getメソッドでクラスを指定した場合は、FQCNがロガー名となる。

```java
// 説明のために変数名に番号を振っているが、実際の開発ではこのような実装を行わない。

// nablarch.core.validation.validator.NumberRangeValidator
private static final Logger LOGGER1 = LoggerManager.get(NumberRangeValidator.class);

// nablarch.core.validation.validator.RequiredValidator
private static final Logger LOGGER2 = LoggerManager.get(RequiredValidator.class);

// nablarch.core.validation.convertor.LongConvertor
private static final Logger LOGGER3 = LoggerManager.get(LongConvertor.class);
```

3つのロガーを対象とする設定例を示す。
以降、ロガー設定の名称はsampleとする。

```bash
loggers.sample.nameRegex=nablarch\\.core\\.validation\\..*
loggers.sample.level=INFO
loggers.sample.writerNames=xxx,yyy,zzz
```

上記の設定により、LOGGER1,LOGGER2,LOGGER3のINFOレベル以上のログ出力がxxx,yyy,zzzのログライタに対して出力される。

RequiredValidatorのロガーのみを対象とする設定例を示す。

```bash
loggers.sample.nameRegex=nablarch\\.core\\.validation\\.validator\\.RequiredValidator
loggers.sample.level=DEBUG
loggers.sample.writerNames=aaa,bbb,ccc
```

上記の設定により、LOGGER2のDEBUGレベル以上のログ出力がaaa,bbb,cccのログライタに対して出力される。

#### ロガーのインスタンス構造

上記プロパティファイルの記述例を基に、ロガーのインスタンス構造を示す。
一番左の列は、ログ出力を要求するクラスのインスタンスを示しており、ノートにロガー取得時のコードを示している。

* ロガーのインスタンスはロガー設定毎に生成され、複数のログ出力を要求するインスタンスから使用される。
* ログライタのインスタンスはログライタの設定毎に生成され、複数のロガーから使用される。

![Log_Basic_InstanceImage.jpg](../../../knowledge/assets/libraries-01-Log/Log_Basic_InstanceImage.jpg)

### ログライタの使用方法

フレームワーク実装が提供するログライタの使用方法を解説する。

#### FileLogWriter

FileLogWriterクラスは、ファイルにログを書き込むログライタである。

FileLogWriterクラスの特徴を下記に示す。

* ログフォーマッタを設定で指定できる。
* ログファイルが指定サイズに達したら、出力ファイルを自動で切り替える。
* 初期処理と終了処理、ログファイルの切り替え時に、書き込み先のログファイルにINFOレベルでメッセージを出力する。

FileLogWriterクラスを使用する場合の設定例を下記に示す。
記述ルールの詳細は、 [プロパティファイルの記述ルール](../../component/libraries/libraries-01-Log.md#プロパティファイルの記述ルール) を参照すること。

```bash
writerNames=appFile

# FileLogWriterクラスを指定する。
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
# 書き込み先のファイルパスを指定する。
writer.appFile.filePath=/var/log/app/app.log
# 書き込み時に使用する文字エンコーディングを指定する。
writer.appFile.encoding=UTF-8
# 出力バッファのサイズを指定する。（単位はキロバイト。1000バイトを1キロバイトと換算する。指定しなければ8KB）
writer.appFile.outputBufferSize=8
# 書き込み先ファイルの最大サイズを指定する。（単位はキロバイト。1000バイトを1キロバイトと換算する）
writer.appFile.maxFileSize=50000
# ログフォーマッタのクラス名を指定する。
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
# LogLevel列挙型の名称を指定する。ここで指定したレベル以上のログを全て出力する。
# この設定項目については、下記の「ログライタにおけるレベルに応じた出力制御」にて解説する。
writer.appFile.level=INFO
```

上記設定例に対する初期処理後のログ出力例を下記に示す。
初期処理の後は、ログライタの設定情報が出力される。

```java
2012-04-18 11:24:02.959 -INFO- nablarch.core.log.basic.FileLogWriter [null] boot_proc = [] proc_sys = [] req_id = [null] usr_id = [null] initialized.
    WRITER NAME        = [appFile]
    WRITER CLASS       = [nablarch.core.log.basic.FileLogWriter]
    FORMATTER CLASS    = [nablarch.core.log.basic.BasicLogFormatter]
    LEVEL              = [INFO]
    FILE PATH          = [/var/log/app/app.log]
    ENCODING           = [UTF-8]
    OUTPUT BUFFER SIZE = [8000]
    FILE AUTO CHANGE   = [true]
    MAX FILE SIZE      = [50000000]
    CURRENT FILE SIZE  = [0]
```

上記の設定例では、ファイルの最大サイズを指定しているので、出力ファイルが自動で切り替わる。
出力ファイルが自動で切り替わった後のファイル一覧の例を下記に示す。
app.logファイルが現在の出力ファイルである。
古いログファイルは、<通常のファイル名>.yyyyMMddHHmmssSSS.oldという命名ルールで同じディレクトリにバックアップされる。

```java
app.log
app.log.20120418112403395.old
app.log.20120418112403411.old
app.log.20120418112403489.old
```

ファイルの切り替え時に、切り替え元と切り替え先それぞれで出力されるログの例を下記に示す。
切り替え元のファイルには、ファイル名を変更したメッセージが出力される。
切り替え先のファイルには、ファイル名の変更に加えて、ログライタの設定情報が出力される。

```java
// 切り替え元
2012-04-18 11:24:03.411 -INFO- nablarch.core.log.basic.FileLogWriter [null] boot_proc = [] proc_sys = [] req_id = [null] usr_id = [null] change [/var/log/app/app.log] -> [/var/log/app/app.log.20120418112403411.old]
```

```java
// 切り替え先
2012-04-18 11:24:02.959 -INFO- nablarch.core.log.basic.FileLogWriter [null] boot_proc = [] proc_sys = [] req_id = [null] usr_id = [null] initialized.
    WRITER NAME        = [appFile]
    WRITER CLASS       = [nablarch.core.log.basic.FileLogWriter]
    FORMATTER CLASS    = [nablarch.core.log.basic.BasicLogFormatter]
    LEVEL              = [INFO]
    FILE PATH          = [./log/app.log]
    ENCODING           = [UTF-8]
    OUTPUT BUFFER SIZE = [8000]
    FILE AUTO CHANGE   = [true]
    MAX FILE SIZE      = [50000000]
    CURRENT FILE SIZE  = [0]
```

終了処理後のログ出力例を下記に示す。

```java
2012-04-18 11:32:58.939 -INFO- nablarch.core.log.basic.FileLogWriter [null] boot_proc = [] proc_sys = [] req_id = [null] usr_id = [null] terminated.
```

#### SynchronousFileLogWriter

SynchronousFileLogWriterクラスは、ロックファイルを用いて排他制御を行いながらファイルにログを書き込むログライタである。
本クラスはFileLogWriterクラスを継承しており、FileLogWriterクラスの特徴に加え、以下の特徴を持つ。

* プロセスをまたがってログ出力処理を直列化できるので、複数プロセスから同一のファイルにログ出力を行う場合でも確実にログを出力できる。

ログ出力時の動作は、 [障害が発生した場合のログ出力](../../component/libraries/libraries-01-Log.md#synchronousfilelogwriter) を参照すること。

SynchronousFileLogWriterクラスを使用する場合の設定例を下記に示す。
記述ルールの詳細は、 [プロパティファイルの記述ルール](../../component/libraries/libraries-01-Log.md#プロパティファイルの記述ルール) を参照すること。

```bash
writerNames=monitorFile

# SynchronousFileLogWriterクラスを指定する。
writer.monitorFile.className=nablarch.core.log.basic.SynchronousFileLogWriter
# 書き込み先のファイルパスを指定する。
writer.monitorFile.filePath=/var/log/app/monitor.log
# 書き込み時に使用する文字エンコーディングを指定する。
writer.monitorFile.encoding=UTF-8
# 出力バッファのサイズを指定する。（単位はキロバイト。1000バイトを1キロバイトと換算する。指定しなければ8KB）
writer.monitorFile.outputBufferSize=8
# 書き込み先ファイルの最大サイズを指定する。（単位はキロバイト。1000バイトを1キロバイトと換算する）
writer.monitorFile.maxFileSize=50000
# ログフォーマッタのクラス名を指定する。
writer.monitorFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
# LogLevel列挙型の名称を指定する。ここで指定したレベル以上のログを全て出力する。
# この設定項目については、下記の「ログライタにおけるレベルに応じた出力制御」にて解説する。
writer.monitorFile.level=ERROR
# ロックファイルのファイル名を指定する。
writer.monitorFile.lockFilePath=/var/log/lock/monitor.lock
# ロック取得の再試行間隔（ミリ秒）を指定する。
writer.monitorFile.lockRetryInterval=10
# ロック取得の待機時間（ミリ秒）を指定する。
writer.monitorFile.lockWaitTime=3000
# ロックファイルが生成できない場合の障害通知コードを指定する。
writer.monitorFile.failureCodeCreateLockFile=MSG00101
# 生成したロックファイルを解放（削除）できない場合の障害通知コードを指定する。
writer.monitorFile.failureCodeReleaseLockFile=MSG00102
# 解放されないロックファイルを強制削除できない場合の障害通知コードを指定する。
writer.monitorFile.failureCodeForceDeleteLockFile=MSG00103
# ロック待ちでスレッドをスリープしている際に、割り込みが発生した場合の障害通知コードを指定する。
writer.monitorFile.failureCodeInterruptLockWait=MSG00104
```

上記設定例の場合。出力対象のログレベルが **ERROR** 以上なので初期処理後のログは出力されない。
出力対象のログレベルに **INFO** レベルが含まれている場合は、以下のログが初期処理後に出力される。

```java
2012-04-18 11:56:27.137 -INFO- nablarch.core.log.basic.FileLogWriter [null] boot_proc = [] proc_sys = [] req_id = [null] usr_id = [null] initialized.
    WRITER NAME        = [monitorFile]
    WRITER CLASS       = [nablarch.core.log.basic.SynchronousFileLogWriter]
    FORMATTER CLASS    = [nablarch.core.log.basic.BasicLogFormatter]
    LEVEL              = [ERROR]
    FILE PATH          = [/var/log/app/monitor.log]
    ENCODING           = [UTF-8]
    OUTPUT BUFFER SIZE = [8000]
    FILE AUTO CHANGE   = [true]
    MAX FILE SIZE      = [50000000]
    CURRENT FILE SIZE  = [0]
    LOCK FILE PATH                      = [/var/log/lock/monitor.lock]
    LOCK RETRY INTERVAL                 = [1]
    LOCK WAIT TIME                      = [1800]
    FAILURE CODE CREATE LOCK FILE       = [MSG00101]
    FAILURE CODE RELEASE LOCK FILE      = [MSG00102]
    FAILURE CODE FORCE DELETE LOCK FILE = [MSG00103]
    FAILURE CODE INTERRUPT LOCK WAIT    = [MSG00104]
```

**障害が発生した場合のログ出力**

本ログライタは、ロック取得の待機時間を超えてもロックを取得できない場合、強制的にロックファイルを削除し、自身のスレッド用のロックファイルを生成してからログの出力を行う。
もし強制的にロックファイルを削除できない場合は、ロックを取得していない状態で強制的にログの出力を行い、ログ出力処理を終了 [1] する。
また、ロックファイルの生成に失敗した場合および、ロック取得待ちの際に割り込みが発生した場合も、ロックを取得していない状態で強制的にログの出力を行い、処理を終了 [1] する。

ロックを取得しない状態で強制的にログを出力する場合に、複数プロセスからのログ出力が競合するとログが正常に出力されない場合がある点に注意すること。

このような障害が発生した場合には、強制出力したログに加えて、同一のログファイルに障害のログを出力する。
デフォルトでは本フレームワークが用意したログが出力されるが、本ログライタのプロパティに障害コードを設定することで、障害通知ログのフォーマット（障害コードを含む）でログを出力することができる。
障害通知ログのフォーマットで出力することで通常の障害通知ログと同様の方法でログの監視が可能となるので、障害コードの設定を行うことを推奨する。

下表に障害ログの詳細を示す。障害時には、これら障害ログの内容に従って対応を行うこと。

| 障害の種類 | ログレベル | 障害コードを設定するプロパティの名前 | 障害コードに対応するメッセージの設定例（{0}にはロックファイルのパスが設定される） | 本フレームワークがデフォルトで出力するログ（障害コードなどは出力されない） |
|---|---|---|---|---|
| ロックファイルが生成できない | FATAL | failureCodeCreateLockFile | ロックファイルの生成に失敗しました。おそらくロックファイルのパスが間違っています。ロックファイルパス=[{0}]。 | failed to create lock file. perhaps lock file path was invalid. lock file path=[{0}]. |
| 生成したロックファイルを解放（削除）できない | FATAL | failureCodeReleaseLockFile | ロックファイルの削除に失敗しました。ロックファイルパス=[{0}]。 | failed to delete lock file. lock file path=[{0}]. |
| 解放されないロックファイルを強制削除できない | FATAL | failureCodeForceDeleteLockFile | ロックファイルの強制削除に失敗しました。ロックファイルが不正に開かれています。ロックファイルパス=[{0}]。 | failed to delete lock file forcedly. lock file was opened illegally. lock file path=[{0}]. |
| ロック取得待ちでスレッドをスリープしている際に、割り込みが発生 | FATAL | failureCodeInterruptLockWait | ロック取得中に割り込みが発生しました。 | interrupted while waiting for lock retry. |

処理を終了とは、ログ出力処理を終了し呼び出し元に処理を正常に処理を戻すことを意味する。

> **Warning:**
> 障害コードを設定した場合、障害通知ログのフォーマットで同一のログファイルにログが出力されるが、障害解析ログは出力されない点に注意すること。

#### ログライタにおけるレベルに応じた出力制御

LogWriterSupportクラスを継承しているクラスでは、ログライタにおいてレベルに応じた出力制御を行うことができる。

レベルに応じた出力制御は、通常ロガー設定を指定することで行う。
しかし、ロガー設定では、ロガー名毎の設定となるため、同じロガー名で異なるレベルで別々のファイルに出力することができない。
例えば、本番運用時のログレベルがINFOレベルの場合、アプリケーションログは障害時の解析に使用するのでINFOレベルまで出力したいが、
通知に使用するログはERRORレベル以上だけでよいといった場合がある。このような場合は、ロガー設定ではINFOレベルを指定しておき、
通知に使用するログを書き込むログライタの設定でERRORレベルを指定することで対応できる。

設定例を下記に示す。説明に必要ない部分は省略している。

```bash
writerNames=appFile,monitorFile

writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.filePath=/var/log/app/app.log

writer.monitorFile.className=nablarch.core.log.basic.SynchronousFileLogWriter
writer.monitorFile.filePath=/var/log/app/monitor.log
writer.monitorFile.level=ERROR
writer.monitorFile.lockFilePath=/var/log/lock/monitor.lock
writer.monitorFile.failureCodeCreateLockFile=MSG00101
writer.monitorFile.failureCodeReleaseLockFile=MSG00102
writer.monitorFile.failureCodeForceDeleteLockFile=MSG00103
writer.monitorFile.failureCodeInterruptLockWait=MSG00104

availableLoggersNamesOrder=root

loggers.root.nameRegex=.*
loggers.root.level=INFO
loggers.root.writerNames=appFile,monitorFile
```

ログライタ「appFile」は、ログレベルを指定していないので、ロガー設定で指定しているINFOレベル以上のログが出力される。
一方、ログライタ「monitorFile」は、ログレベルを指定しているので、ログライタで指定しているERRORレベル以上のログのみ出力される。

#### StandardOutputLogWriter

StandardOutputLogWriterクラスは、標準出力にログを書き込むログライタである。

開発時にコンソール上で出力されたログを確認する場合などに使用できる。

設定例を下記に示す。

```bash
writerNames=stdout

# StandardOutputLogWriterクラスを指定する。
writer.stdout.className=nablarch.core.log.basic.StandardOutputLogWriter
# ログフォーマッタのクラス名を指定する。
writer.stdout.formatter.className=nablarch.core.log.basic.BasicLogFormatter
```

> **Warning:**
> 誤って開発時に使用したデバッグ設定のまま、本番運用時に使用しないこと。

### ログフォーマッタの使用方法

フレームワーク実装が提供するログフォーマッタの使用方法を解説する。

#### BasicLogFormatter

BasicLogFormatterクラスは、汎用的に使用できるログフォーマッタである。

BasicLogFormatterクラスの特徴を下記に示す。

* ログに最低限必要な情報（日時、リクエストID、ユーザIDなど）を出力できる。
* アプリケーションを起動しているプロセスを識別するために、システムプロパティで指定されたプロセス名をログに出力できる。
* オブジェクトを指定してフィールド情報を出力できる。
* 例外オブジェクトを指定してスタックトレースを出力できる。
* フォーマットを設定のみで変更することができる。

BasicLogFormatterでは、出力されたログの状況を特定するために、リクエストIDの他に下記項目を出力できる。
これらの出力項目について先に説明する。

* 起動プロセス
* 処理方式
* 実行時ID

##### 起動プロセス

起動プロセスとは、アプリケーションを起動した実行環境を特定するために使用する名前である。
起動プロセスにサーバ名とJOBIDなどの識別文字列を組み合わせた名前を使用することで、
同一サーバの複数プロセスから出力されたログの実行環境を特定することができる。
起動プロセスは、プロジェクト毎にID体系などで体系を規定することを想定している。

起動プロセスは、システムプロパティに"nablarch.bootProcess"というキーで指定する。
システムプロパティの指定がない場合、起動プロセスはブランクとなる。

システムプロパティの設定例を下記に示す。
javaコマンドのオプション-Dによる指定を用いて、下記のように実行時のオプションとしてシステムプロパティを設定する。

```bash
>java -Dnablarch.bootProcess=APP0001 ...
```

##### 処理方式

処理方式とは、画面オンライン処理、バッチ処理、ディレード処理などを意味する。
アプリケーションの処理方式を識別したい場合に、プロジェクト毎に規定して使用する。

処理方式は、プロパティファイルに"nablarch.processingSystem"というキーで指定する。
プロパティファイルのパスの指定方法については、 [ロガーファクトリの設定方法](../../component/libraries/libraries-01-Log.md#ロガーファクトリの設定方法) を参照。
処理方式の設定例を下記に示す。

```bash
# 処理方式に"1"を指定している。
nablarch.processingSystem=1
```

プロパティの指定がない場合はブランクとなる。

##### 実行時ID

実行時IDとは、リクエストIDに対するアプリケーションの個々の実行を識別するためにつけるIDである。
1つのリクエストIDに対して実行された数だけ実行時IDが発行されるため、リクエストIDと実行時IDの関係は1対多となる。
実行時IDは、複数のログを出力している場合に、出力された複数のログを紐付けるために使用する。

実行時IDは、各処理方式のThreadContextを初期化するタイミングで発行し、ThreadContextに設定される。
実行時IDのID体系を下記に示す。

```bash
# 起動プロセスは指定された場合のみ付加する。
起動プロセス＋システム日時(yyyyMMddHHmmssSSS)＋連番(4桁)
```

##### BasicLogFormatterのフォーマット指定

BasicLogFormatterは、プレースホルダを使用してフォーマットを指定する。
フォーマットに指定可能なプレースホルダの一覧を下記に示す。

| プレースホルダ | 説明 |
|---|---|
| $date$ | このログ出力を要求した時点の日時。 |
| $logLevel$ | このログ出力のログレベル。 デフォルトはLogLevel列挙型の名称を文言に使用する。 文言はプロパティファイルの設定で変更することができる。 文言変更の詳細は、 [ログに出力するログレベルを表す文言の変更方法](../../component/libraries/libraries-01-Log.md#ログに出力するログレベルを表す文言の変更方法) を参照。 |
| $loggerName$ | このログ出力が対応するロガー設定の名称。 プロパティファイルでロガー設定を行う際に指定した名称となる。 |
| $bootProcess$ | [起動プロセス](../../component/libraries/libraries-01-Log.md#起動プロセス) を識別する名前。 |
| $processingSystem$ | [処理方式](../../component/libraries/libraries-01-Log.md#処理方式) を識別する名前。 |
| $requestId$ | このログ出力を要求した時点のリクエストID 。 |
| $executionId$ | このログ出力を要求した時点の [実行時ID](../../component/libraries/libraries-01-Log.md#実行時id) 。 |
| $userId$ | このログ出力を要求した時点のログインユーザのユーザID。 |
| $message$ | このログ出力のメッセージ。 指定がない場合はブランク。 |
| $information$ | オプション情報に指定されたオブジェクトのフィールド情報。 オブジェクトのフィールドに対して、Object#toString()メソッドを実行した結果を表示する。 オプション情報に指定されたオブジェクトが基本データ型のラッパクラス、CharSequenceインタフェース、 Dateクラスの場合は、オブジェクトに対してObject#toString()メソッドを実行した結果のみを表示する。 オブジェクト情報の指定がない場合は表示しない。 |
| $stackTrace$ | エラー情報に指定された例外オブジェクトのスタックトレース。 エラー情報の指定がない場合は表示しない。 |

$information$と$stackTrace$は、出力内容が複数行になるため、先頭に改行コードを付加して出力する。

フォーマットに改行コードとタブ文字を含めたい場合は、下記に示すように、Javaと同様の記述を使用する。
改行コードは、Java標準のシステムプロパティに含まれる"line.separator"から取得する。
このため、システムプロパティの"line.separator"を変更しなければOSの改行コードが使用される。
尚、BasicLogFormatterは"\n"と"\t"という文字列を出力することはできない。

| 含めたい文字 | 記述する文字列 |
|---|---|
| 改行コード | \\n |
| タブ文字 | \\t |

フォーマットの指定がない場合に使用するデフォルトのフォーマットを下記に示す。

```bash
$date$ -$logLevel$- $loggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$
```

##### BasicLogFormatterの出力例

デフォルトのフォーマットによるログの出力例を下記に示す。

システムプロパティの設定例

```bash
# システムプロパティで起動パラメータと処理方式を指定する。
>java -Dnablarch.bootProcess=APP0001
```

log.propertiesの設定例

```bash
# 処理方式に"1"を指定している。
nablarch.processingSystem=1
```

ログの出力を依頼するコードの実装例

```java
// ThreadContextは下記の値が設定されているものとする。
// ユーザID=0000000001
// リクエストID=USERS00302
// 実行時ID=APP001201102041542175080001

User user = new User(null, "山田太郎", 28);
String userId = null;
String name = "山田花子";
long price = 2000000;

try {
    doSomething(); // new IllegalArgumentException("error test.")が送出される。
} catch (IllegalArgumentException e) {
    // メッセージ、エラー情報、オプション情報(userからpriceまで)を指定している。
    LOGGER.logInfo("テストメッセージ", e, user, userId, name, price);
    throw e;
}
```

ログの出力例

```bash
2011-02-14 16:01:37.578 -INFO- root [APP001201102041542175080001] boot_proc = [APP001] proc_sys = [1] req_id = [USERS00302] usr_id = [0000000001] テストメッセージ
Object Information[0]: Class Name = [nablarch.core.log.basic.User]
    id = [null]
    name = [山田太郎]
    age = [28]
    toString() = [nablarch.core.log.basic.User@10b4199]
Object Information[1]: null
Object Information[2]: Class Name = [java.lang.String]
    toString() = [山田花子]
Object Information[3]: Class Name = [java.lang.Long]
    toString() = [2000000]
Stack Trace Information :
java.lang.IllegalArgumentException: error test.
    at my.log.BasicLogFormatterSample.doSomething(BasicLogFormatterSample.java:50)
    # 以降のスタックトレースは省略。
```

次に、フォーマットを指定した場合のログの出力例を下記に示す。
BasicLogFormatterのdatePatternプロパティを指定することで日時のフォーマットに使用するパターンを変更することもできる。
ログの出力を指示するソースコードは、デフォルトのフォーマットによるログの出力例と同じとする。

```bash
# フォーマットの指定

# フォーマットを指定する場合はBasicLogFormatterクラスを明示的に指定する必要がある。
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter

# 日時のフォーマットに使用するパターンを指定している。
writer.appFile.formatter.datePattern=yyyy/MM/dd HH:mm:ss[SSS]

# 実行時ID以降を改行して表示するようにフォーマットを指定している。
writer.appFile.formatter.format=$date$ -$logLevel$- $loggerName$ [$executionId$]\n\tboot_proc = [$bootProcess$]\n\tproc_sys = [$processingSystem$]\n\treq_id = [$requestId$]\n\tusr_id = [$userId$]\n\t$message$$information$$stackTrace$
```

```bash
# ログの出力例

2011/02/14 16:08:55[107] -INFO- root [APP001201102041542175080001]
    boot_proc = [APP001]
    proc_sys = [1]
    req_id = [USERS00302]
    usr_id = [0000000001]
    テストメッセージ
# 以降のオプション情報とスタックトレースは、デフォルトのフォーマットによるログの出力例と同じため省略。
```

#### ログに出力するログレベルを表す文言の変更方法

LogLevelLabelProviderクラスを使用することで、ログレベルを表す文言をプロパティファイルに設定できる。
ログレベルを表す文言のデフォルトは、LogLevel列挙型の名称となる。
BasicLogFormatterクラスは、LogLevelLabelProviderクラスを使用して、ログレベルを表す文言の変更をサポートしている。

まず、文言を変更する前の設定例と出力例を下記に示す。
ロガー設定の名称（root）の後にデフォルトの文言（FATAL, ERRORなど）が表示されている。

```bash
writerNames=appFile

writer.appFile.filePath=/var/log/app/app.log
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=$date$ -$logLevel$- $loggerName$ [$executionId$] boot_proc = [$bootProcess$] req_id = [$requestId$] usr_id = [$userId$] $message$
```

```java
2011-02-28 12:32:26.366 -FATAL- root [null] boot_proc = [] req_id = [null] usr_id = [null] FATALメッセージ
2011-02-28 12:32:26.366 -ERROR- root [null] boot_proc = [] req_id = [null] usr_id = [null] ERRORメッセージ
2011-02-28 12:32:26.366 -WARN- root [null] boot_proc = [] req_id = [null] usr_id = [null] WARNメッセージ
2011-02-28 12:32:26.366 -INFO- root [null] boot_proc = [] req_id = [null] usr_id = [null] INFOメッセージ
2011-02-28 12:32:26.366 -DEBUG- root [null] boot_proc = [] req_id = [null] usr_id = [null] DEBUGメッセージ
2011-02-28 12:32:26.366 -TRACE- root [null] boot_proc = [] req_id = [null] usr_id = [null] TRACEメッセージ
```

次に、文言を変更した後の設定例と出力例を下記に示す。
ロガー設定の名称（root）の後に指定した文言（F, Eなど）が表示される。

```bash
writerNames=appFile

writer.appFile.filePath=/var/log/app/app.log
writer.appFile.className=nablarch.core.log.basic.FileLogWriter
writer.appFile.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.appFile.formatter.format=$date$ -$logLevel$- $loggerName$ [$executionId$] boot_proc = [$bootProcess$] req_id = [$requestId$] usr_id = [$userId$] $message$
# <ログライタのプレフィックス>.formatter.label.<LogLevel列挙型の名称の小文字>に文言を指定する。
writer.appFile.formatter.label.fatal=F
writer.appFile.formatter.label.error=E
writer.appFile.formatter.label.warn=W
writer.appFile.formatter.label.info=I
writer.appFile.formatter.label.debug=D
writer.appFile.formatter.label.trace=T
```

```java
2011-02-28 12:33:39.569 -F- root [null] boot_proc = [] req_id = [null] usr_id = [null] FATALメッセージ
2011-02-28 12:33:39.569 -E- root [null] boot_proc = [] req_id = [null] usr_id = [null] ERRORメッセージ
2011-02-28 12:33:39.569 -W- root [null] boot_proc = [] req_id = [null] usr_id = [null] WARNメッセージ
2011-02-28 12:33:39.569 -I- root [null] boot_proc = [] req_id = [null] usr_id = [null] INFOメッセージ
2011-02-28 12:33:39.569 -D- root [null] boot_proc = [] req_id = [null] usr_id = [null] DEBUGメッセージ
2011-02-28 12:33:39.569 -T- root [null] boot_proc = [] req_id = [null] usr_id = [null] TRACEメッセージ
```

### カスタマイズ方法

ログライタとログフォーマッタのカスタマイズ方法について説明する。

#### ログライタのカスタマイズ方法

新しいログライタを追加する場合は、LogWriterインタフェースを実装したクラスを作成する。
ログフォーマッタを使用するログライタを作成する場合は、共通処理を提供するLogWriterSupportクラスを継承して作成できる。

#### ログフォーマッタのカスタマイズ方法

新しいログフォーマッタを追加する場合は、LogFormatterインタフェースを実装したクラスを作成する。
ログレベルを表す文言を設定で変更可能にしたい場合は、LogLevelLabelProviderクラスを使用する。

新しいログフォーマッタの追加に伴い、ログ出力時に指定するパラメータを増やし、ログフォーマッタで増やしたパラメータを受け取りたいことがある。
本機能では、ログ出力時に指定するパラメータを増やす目的で、Loggerインタフェースのログ出力メソッドにObject型の可変長引数optionsを設けている。
シグネチャの例としてLogger#logInfoメソッドを下記に示す。

```java
// Logger#logInfoメソッドのシグネチャ
public void logInfo(String message, Object... options)
public void logInfo(String message, Throwable cause, Object... options)
```

ログ出力時のパラメータを増やしたい場合は、options引数を規定して使用すること。

##### ログ出力項目の変更方法

BasicLogFormatterは、LogItemインタフェースを使用して各プレースホルダに対応する出力項目を取得する。
既存プレースホルダの出力内容の変更や新規にプレースホルダを追加したい場合は、
LogItemを実装したクラスとBasicLogFormatterを継承したクラスを作成することで実現できる。

ログフォーマッタの設定から起動プロセスを取得するように変更する場合の例を示す。
ログフォーマッタの設定は、下記を想定する。

```bash
# ログフォーマッタの設定例(ログライタの設定は省略)
writer.appFile.className=＜ログライタのクラス名＞
# カスタムのログフォーマッタを指定する。
writer.appFile.formatter.className=nablarch.core.log.basic.CustomLogFormatter
# フォーマットを指定する。
writer.appFile.formatter.format=$logLevel$ $loggerName$ [$bootProcess$]
# ログフォーマッタの設定で起動プロセスを指定する。
# ここで指定した起動プロセスを$bootProcess$に出力する。
writer.appFile.formatter.bootProcess=CUSTOM_PROCESS
```

まず、LogItemを実装したクラス(CustomBootProcessItem)を作成し、ログフォーマッタの設定から起動プロセスを取得する。
CustomBootProcessItemの実装例を下記に示す。

```java
// カスタムの起動プロセスを取得するクラス。
public class CustomBootProcessItem implements LogItem<LogContext> {
    private String bootProcess;
    public CustomBootProcessItem(ObjectSettings settings) {
        // ログフォーマッタの設定から起動プロセスを取得する。
        bootProcess = settings.getProp("bootProcess");
    }
    public String get(LogContext context) {
        // 設定から取得した起動プロセスを返す。
        return bootProcess;
    }
}
```

次に、BasicLogFormatterを継承し、作成したCustomBootProcessItemを追加する。実装例を下記に示す。
BasicLogFormatterのgetLogItemsメソッドをオーバーライドしてCustomBootProcessItemを追加する。

```java
public class CustomLogFormatter extends BasicLogFormatter {

    // フォーマット対象のログ出力項目を取得するメソッドをオーバーライドする。
    protected Map<String, LogItem<LogContext>> getLogItems(ObjectSettings settings) {

        // 起動プロセスのプレースホルダを上書きで設定する。
        Map<String, LogItem<LogContext>> logItems = super.getLogItems(settings);
        logItems.put("$bootProcess$", new CustomBootProcessItem(settings));
        return logItems;
    }
}
```

ログフォーマッタの設定例に示した設定値によるログの出力例を下記に示す。
ログフォーマッタの設定で指定した起動プロセスが出力される。

```bash
# ロブレベル、ロガー名、起動プロセスが出力される。
INFO ROO [CUSTOM_PROCESS]
```

## プロパティファイルの記述ルール

### ロガーファクトリの設定

| プロパティ名 | 設定値 |
|---|---|
| loggerFactory.className | 生成するロガーファクトリのクラス名。 LoggerFactoryを実装したクラスのFQCNを指定する。 |

### フレームワーク実装の設定

#### ログライタの設定

| プロパティ名 | 設定値 |
|---|---|
| writerNames | 使用する全てのログライタの名称。必須。 複数指定する場合はカンマ区切り。 「"writer." + <ここで指定したログライタの名称>」をキーのプレフィックスにして、ログライタ毎の設定を行う。 |
| writer.<ログライタの名称>.className | ログライタのクラス名。必須。 LogWriterを実装したクラスのFQCNを指定する。 |
| writer.<ログライタの名称>.<プロパティ名> | ログライタ毎のプロパティに設定する値。 設定内容は、使用するログライタのJavadocを参照すること。 |

#### ロガーの設定

| プロパティ名 | 設定値 |
|---|---|
| availableLoggersNamesOrder | 使用する全てのロガー設定の名称。必須。 複数指定する場合はカンマ区切り。 「"loggers." + <ここで指定されたロガー設定の名称>」をキーのプレフィックスに使用して、ロガー設定毎の設定を行う。 |
| loggers.<ロガー設定の名称>.nameRegex | ロガー名とのマッチングに使用する正規表現。必須。 正規表現は、ロガー設定の対象となるロガーを絞り込むために使用する。 ロガーの取得時に指定されたロガー名（つまりLoggerManager#getメソッドの引数に指定されたロガー名）に対してマッチングを行う。 |
| loggers.<ロガー設定の名称>.level | ログレベルの名称。必須。 LogLevel列挙型の名称を指定する。 ここで指定したレベル以上のログを全て出力する。 |
| loggers.<ロガー設定の名称>.writerNames | 出力先とするログライタの名称。必須。 複数指定する場合はカンマ区切り。 ここで指定した全てのログライタに対してログの書き込みを行う。 |

#### FileLogWriterの設定

| プロパティ名 | 設定値 |
|---|---|
| writer.<ログライタの名称>.level | ログレベルの名称。(必須) LogLevel列挙型の名称を指定する。 ここで指定したレベル以上のログを全て出力する。 指定がない場合はレベルに応じた出力制御を行わず、全てのレベルのログを出力する。 |
| writer.<ログライタの名称>.formatter.className | ログライタで使用するログフォーマッタのクラス名。 LogFormatterを実装したクラスのFQCNを指定する。 |
| writer.<ログライタの名称>.formatter.<プロパティ名> | ログフォーマッタ毎のプロパティに設定する値。 設定内容は、使用するログフォーマッタのJavadocを参照すること。 |
| writer.<ログライタの名称>.filePath | 書き込み先のファイルパス。(必須) |
| writer.<ログライタの名称>.encoding | 書き込み時に使用する文字エンコーディング。オプション。 指定しなければシステムプロパティ(file.encoding)から取得した文字エンコーディング。 指定できるエンコーディングは、「java.nio.charset.Charset#forName」に指定する形式と同じである。 |
| writer.<ログライタの名称>.outputBufferSize | 出力バッファのサイズ。オプション。 単位はキロバイト。1000バイトを1キロバイトと換算する。 １以上を指定する。指定しなければ8KB。 |
| writer.<ログライタの名称>.maxFileSize | 書き込み先ファイルの最大サイズ。オプション。 単位はキロバイト。1000バイトを1キロバイトと換算する。 指定しなければ自動切替なし。 指定値が解析可能な整数値(Long.parseLong)でない場合は自動切替なし。 指定値が０以下の場合は自動切替なし。 古いログファイル名は、<通常のファイル名>.yyyyMMddHHmmssSSS.old。 |

#### SynchronousFileLogWriterの設定

SynchronousFileLogWriterは、  [FileLogWriterの設定](../../component/libraries/libraries-01-Log.md#filelogwriterの設定) で記載したプロパティに加えて以下のプロパティを持つ。

| プロパティ名 | 設定値 |
|---|---|
| writer.<ログライタの名称>.lockFilePath | ロックファイルのパス。(必須) |
| writer.<ログライタの名称>.lockRetryInterval | ロック取得失敗時の再試行間隔（ミリ秒）。 指定しなければ1ミリ秒間隔で再試行が行われる。 |
| writer.<ログライタの名称>.lockWaitTime | ロック取得の待機時間（ミリ秒）。 ここで設定した時間を超えてもロックを取得できなかった場合、例外をスローする。 指定しなければ1800ミリ秒までロック取得待ちが行われる。 |
| writer.<ログライタの名称>.failureCodeCreateLockFile | ロックファイルが生成できない場合のログ出力に使用する障害通知コード。 指定しなければ以下のログが出力される。（{0}にはロックファイルのパスが設定される） "failed to create lock file. perhaps lock file path was invalid. lock file path=[{0}]." |
| writer.<ログライタの名称>.failureCodeReleaseLockFile | 生成したロックファイルを解放（削除）できない場合のログ出力に使用する障害通知コード。 指定しなければ以下のログが出力される。（{0}にはロックファイルのパスが設定される） "failed to delete lock file. lock file path=[{0}]." |
| writer.<ログライタの名称>.failureCodeForceDeleteLockFile | 解放されないロックファイルを強制削除できない場合のログ出力に使用する障害通知コード。 指定しなければ以下のログが出力される。（{0}にはロックファイルのパスが設定される） "failed to delete lock file forcedly. lock file was opened illegally. lock file path=[{0}]." |
| writer.<ログライタの名称>.failureCodeInterruptLockWait | ロック待ちでスレッドをスリープしている際に割り込みが発生した場合のログ出力に使用する障害通知コード。 指定しなければ以下のログが出力される。 "interrupted while waiting for lock retry." |

#### BasicLogFormatterの設定

| プロパティ名 | 設定値 |
|---|---|
| writer.<ログライタの名称>.formatter.format | フォーマット文字列(オプション) |
| writer.<ログライタの名称>.formatter.datePattern | 日時のフォーマットに使用するパターン(オプション) 指定しなければはyyyy-MM-dd HH:mm:ss.SSS |
| writer.<ログライタの名称>.formatter.label.<LogLevel列挙型の名称の小文字> | ログレベルを表す文言(オプション) 指定しなければLogLevel列挙型の名称を使用する。 |

## 各種ログの出力

本フレームワークでは、アプリケーションに共通で必要とされるログの種類を定義し、ログの種類毎に出力機能を提供する。

### ログの種類

本フレームワークで出力機能を提供しているログの種類を下記に示す。

| ログの種類 | 説明 |
|---|---|
| [障害通知ログ](../../component/libraries/libraries-01-FailureLog.md#障害ログの出力) | 障害発生時に1次切り分け担当者を特定するのに必要な情報を出力する。 |
| [障害解析ログ](../../component/libraries/libraries-01-FailureLog.md#障害ログの出力) | 障害原因の特定に必要な情報を出力する。 |
| [SQLログ](../../component/libraries/libraries-02-SqlLog.md#sqlログの出力) | 深刻なパフォーマンス劣化の要因となりやすいSQL文の実行について、パフォーマンスチューニングに使用するために、 SQL文の実行時間とSQL文を出力する。 |
| [パフォーマンスログ](../../component/libraries/libraries-03-PerformanceLog.md#パフォーマンスログの出力) | 任意の処理について、パフォーマンスチューニングに使用するために実行時間とメモリ使用量を出力する。 |
| [HTTPアクセスログ](../../component/libraries/libraries-04-HttpAccessLog.md#httpアクセスログの出力) | 画面オンライン処理において、アプリケーションの実行状況を把握するための情報を出力する。 アプリケーションの性能測定に必要な情報、アプリケーションの負荷測定に必要な情報の出力も含む。 さらに、アプリケーションの不正使用を検知するために、全てのリクエスト及びレスポンス情報を出力する証跡ログとしても使用する。 |
| [メッセージングログ](../../component/libraries/libraries-05-MessagingLog.md#メッセージングログの出力) | メッセージング処理において、メッセージ送受信の状況を把握するための情報を出力する。 |

本フレームワークでは、障害通知ログと障害解析ログを合わせて障害ログと呼ぶ。
ここでは、各種ログの共通項目のフォーマットと各種ログの設定について説明する。
各種ログの詳細は下記を参照。

01/01_FailureLog
01/02_SqlLog
01/03_PerformanceLog
01/04_HttpAccessLog
01/05_MessagingLog

### 各種ログの共通項目のフォーマット

各種ログの出力は、 [ログ出力要求受付処理](../../component/libraries/libraries-01-Log.md#ログ出力要求受付処理) を使用してログ出力を行う。
このため、各種ログの共通項目は、使用するログ出力実装に依存する。
各種ログの出力では、 [BasicLogFormatter](../../component/libraries/libraries-01-Log.md#basiclogformatter) の出力項目を共通項目とする。
したがって、各種ログの出力にフレームワーク以外のログ出力実装を使用する場合は、 [BasicLogFormatter](../../component/libraries/libraries-01-Log.md#basiclogformatter) と同等の出力項目を出力できるように実装が必要となる。
以降では、各種ログの出力にフレームワーク実装を使用することを想定して説明する。

各種ログのフォーマットは、下記2つのフォーマットから構成される。

a) 各種ログの共通項目のフォーマット( [BasicLogFormatter](../../component/libraries/libraries-01-Log.md#basiclogformatter) のフォーマット)
b) 各種ログの個別項目のフォーマット

これら2つのフォーマットは、各種ログの個別項目をフォーマットした結果を、 [BasicLogFormatter](../../component/libraries/libraries-01-Log.md#basiclogformatter) のプレースホルダ$message$に指定することで組み合わせる。
HTTPアクセスログを例にフォーマット指定のイメージを下記に示す。

```bash
# 共通項目のフォーマット(BasicLogFormatterのフォーマット)
$date$ req_id = [$requestId$] <$message$> usr_id = [$userId$]

# $message$以外の共通項目をフォーマットした結果
2011-02-07 19:07:30.970 req_id = [USERS00302] <$message$> usr_id = [0000000001]
```

```bash
# 個別項目のフォーマット(HTTPアクセスログのフォーマット)
# $url$: リクエストURL、$port$: ポート番号、$method$: HTTPメソッドが入るプレースホルダとする。
url:$url$ port:$port$ method:$method$

# 個別項目をフォーマットした結果
url:/action/management/user/UserRegisterAction/USERS00302 port:8090 method:POST
```

上記フォーマット指定におけるHTTPアクセスログの出力例を下記に示す。
BasicLogFormatterの$message$部分に、HTTPアクセスログの個別項目をフォーマットした結果が入る。

```bash
# アクセスログの出力例
2011-02-07 19:07:30.970 req_id = [USERS00302] <url:/action/management/user/UserRegisterAction/USERS00302 port:8090 method:POST> usr_id = [0000000001]
```

### 各種ログの設定

各種ログの出力では、フォーマットなどの設定をプロパティファイルに指定する。
プロパティファイルは、クラスパス直下に"app-log.properties"というファイル名で配置する。
配置場所を変更したい場合は、"nablarch.appLog.filePath"というキー名でシステムプロパティを指定する。
プロパティファイル内の設定値は、プロパティ名と同じキー名でシステムプロパティを指定することで実行時に変更できる。

システムプロパティの設定例を下記に示す。
javaコマンドのオプション-Dによる指定を用いて、下記のように実行時のオプションとしてシステムプロパティを設定する。

```bash
>java -Dnablarch.appLog.filePath=/var/log/app/app-log.properties ...
```

## フレームワークのログ出力方針

本フレームワークでは、下記の出力方針に基づきログ出力を行う。

| ログレベル | 出力方針 |
|---|---|
| FATAL / ERROR | [障害ログ](../../component/libraries/libraries-01-FailureLog.md#障害ログの出力) は、障害監視の対象であり、障害発生時の一時切り分けの起点ともなる為、 原則として1件の障害に対して、1件の障害ログを出力する方針としている。  このため、 [実行制御基盤](../../about/about-nablarch/about-nablarch-fw.md#目次) では単一のハンドラ(例外を処理するハンドラ)により障害通知ログを出力する方針としている。 なお、出力するレベル及び出力方針は、各実行制御基板のハンドラ構成及び例外を処理するハンドラの仕様に依存するため、 詳細は [実行制御基盤](../../about/about-nablarch/about-nablarch-fw.md#目次) のハンドラ構成及び例外を処理するハンドラの仕様を参照すること。 |
| WARN | 障害発生時に連鎖して例外が発生した場合など、障害ログとして出力できない例外をWARNレベルで出力する。 例えば、業務処理とトランザクションの終了処理の2つで例外が発生した場合は、 業務処理の例外を障害ログに出力し、トランザクションの終了処理の例外をWARNレベルで出力する。 |
| INFO | アプリケーションの実行状況に関連するエラーを検知した場合にINFOレベルで出力する。 例えば、URLパラメータの改竄エラーや認可エラーが発生した場合にINFOレベルで出力する。 |
| DEBUG | アプリケーション開発時に使用するデバッグ情報を出力する。 アプリケーション開発時は、DEBUGレベルを設定することで開発に必要な情報が出力されるよう考慮している。 |
| TRACE | フレームワーク開発時に使用するデバッグ情報を出力する。 アプリケーション開発での使用は想定していない。 |
