# class BasicLogFormatter

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- LogFormatter

---

```java
public class BasicLogFormatter
implements LogFormatter
```

{@link LogFormatter}の基本実装クラス。<br>
<br>
BasicLogFormatterクラスの特徴を下記に示す。<br>
<ul>
<li>ログに最低限必要な情報（日時、リクエストID、ユーザIDなど）を出力できる。</li>
<li>アプリケーションを起動しているプロセスを識別するために、システムプロパティで指定されたプロセス名をログに出力できる。</li>
<li>オブジェクトを指定してフィールド情報を出力できる。</li>
<li>例外オブジェクトを指定してスタックトレースを出力できる。</li>
<li>フォーマットを設定のみで変更することができる。</li>
</ul>
BasicLogFormatterは、プレースホルダを使用してフォーマットを指定する。
フォーマットに指定可能なプレースホルダの一覧を下記に示す。
<pre>
$date$
    このログ出力を要求した時点の日時。
$logLevel$
    このログ出力のログレベル。
    デフォルトはLogLevel列挙型の名称を文言に使用する。
    文言はプロパティファイルの設定で変更することができる。
$loggerName$
    このログ出力が対応するロガー設定の名称。
    このログ出力を呼び出した箇所に関わらず、プロパティファイル(log.properties)に記載したロガー名となる。
$runtimeLoggerName$
    実行時に、{@link nablarch.core.log.LoggerManager}からロガー取得に指定した名称。
    このログ出力を呼び出した際に{@link nablarch.core.log.LoggerManager#get(Class)}で指定したクラス名
    または{@link nablarch.core.log.LoggerManager#get(String)}で指定した名称となる。
$bootProcess$
    起動プロセスを識別する名前。
    起動プロセスは、システムプロパティ"nablarch.bootProcess"から取得する。
    指定がない場合はブランク。
$processingSystem$
    処理方式を識別する名前。
    処理方式は、プロパティファイル("nablarch.processingSystem")から取得する。
    指定がない場合はブランク。
$requestId$
    このログ出力を要求した時点のリクエストID。
$executionId$
    このログ出力を要求した時点の実行時ID
$userId$
    このログ出力を要求した時点のログインユーザのユーザID。
$message$
    このログ出力のメッセージ。
    指定がない場合はブランク。
$information$
    オプション情報に指定されたオブジェクトのフィールド情報。
    オブジェクトのフィールドに対して、Object#toString()メソッドを実行した結果を表示する。
    オプション情報に指定されたオブジェクトが基本データ型のラッパクラス、CharSequenceインタフェース、
    Dateクラスの場合は、オブジェクトに対してObject#toString()メソッドを実行した結果のみを表示する。
    オブジェクト情報の指定がない場合は表示しない。
$stackTrace$
    エラー情報に指定された例外オブジェクトのスタックトレース。
    エラー情報の指定がない場合は表示しない。
</pre>
フォーマット指定が無い場合に使用するフォーマットを下記に示す。
<br>
$date$ -$logLevel$- $loggerName$ [$executionId$]
boot_proc = [$bootProcess$] proc_sys = [$processingSystem$]
req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$
<br>
<br>
プロパティファイルの記述ルールを下記に示す。
<dl>
  <dt>writer.&lt;{@link LogWriter}の名称&gt;.formatter.label.&lt;{@link LogLevel}の名称の小文字&gt;
  <dd>{@link LogLevel}に使用するラベル。オプション。<br>
      指定しなければ{@link LogLevel}の名称を使用する。
  <dt>writer.&lt;{@link LogWriter}の名称&gt;.formatter.format
  <dd>フォーマット。オプション。
  <dt>writer.&lt;{@link LogWriter}の名称&gt;.formatter.datePattern
  <dd>日時のフォーマットに使用するパターン。オプション。<br>
      指定しなければはyyyy-MM-dd HH:mm:ss.SSSを使用する。
</dl>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### DEFAULT_DATE_FORMAT

```java
private static final DateFormat DEFAULT_DATE_FORMAT
```

デフォルトの日時フォーマット

---

### DEFAULT_FORMAT

```java
private static final String DEFAULT_FORMAT
```

フォーマット指定が無い場合に使用するフォーマット

---

### formattedLogItems

```java
private LogItem<LogContext>[] formattedLogItems
```

フォーマット済みのログ出力項目

---

## メソッドの詳細

### initialize

```java
public void initialize(ObjectSettings settings)
```

{@inheritDoc}<br>
<br>
フォーマットとログレベルに使用するラベルを初期化する。

---

### getLogItems

```java
protected Map<String,LogItem<LogContext>> getLogItems(ObjectSettings settings)
```

フォーマット対象のログ出力項目を取得する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
フォーマット対象のログ出力項目

---

### getDateFormat

```java
protected DateFormat getDateFormat(ObjectSettings settings)
```

日時フォーマットを取得する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
日時フォーマット

---

### getLogLevelLabelProvider

```java
protected LogLevelLabelProvider getLogLevelLabelProvider(ObjectSettings settings)
```

LogLevelLabelProviderを取得する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
LogLevelLabelProvider

---

### getFormat

```java
protected String getFormat(ObjectSettings settings)
```

フォーマットを取得する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
フォーマット

---

### format

```java
public String format(LogContext context)
```

{@inheritDoc}

---
