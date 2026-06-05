# class BasicLoggerFactory

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- LoggerFactory

---

```java
public class BasicLoggerFactory
implements LoggerFactory
```

{@link LoggerFactory}の基本実装クラス。<br>
<br>
フレームワーク実装の設定は、{@link nablarch.core.log.LoggerManager LoggerManager}が読み込むプロパティファイルに記述する。<br>
プロパティファイルの設定は、システムプロパティを使用して同じキー名に値を指定することで上書きすることができる。<br>
<br>
プロパティファイルの記述ルールを下記に示す。<br>
<dl>
<dt>writerNames
<dd>使用する全ての{@link LogWriter}の名称。必須。<br>
    複数指定する場合はカンマ区切り。<br>
    「”writer.” + &lt;ここで指定した{@link LogWriter}の名称&gt;」をキーのプレフィックスにして、{@link LogWriter}毎の設定を行う。

<dt>writer.&lt;{@link LogWriter}の名称&gt;.className
<dd>{@link LogWriter}のクラス名。必須。<br>
    {@link LogWriter}を実装したクラスのFQCNを指定する。

<dt>writer.&lt;{@link LogWriter}の名称&gt;.<プロパティ名>
<dd>{@link LogWriter}毎のプロパティに設定する値。<br>
    設定内容は、使用する{@link LogWriter}のJavadocを参照すること。

<dt>availableLoggersNamesOrder
<dd>使用する全ての{@link Logger}設定の名称。必須。<br>
    複数指定する場合はカンマ区切り。<br>
    「”loggers.” + &lt;ここで指定された{@link Logger}設定の名称&gt;」をキーのプレフィックスに使用して、{@link Logger}設定毎の設定を行う。

<dt>loggers.&lt;{@link Logger}設定の名称&gt;.nameRegex
<dd>{@link Logger}名とのマッチングに使用する正規表現。必須。<br>
    正規表現は、{@link Logger}設定の対象となる{@link Logger}を絞り込むために使用する。<br>
    {@link Logger}の取得時に指定された{@link Logger}名
    （つまり{@link nablarch.core.log.LoggerManager#get(String) LoggerManager#get}メソッドの引数に指定された{@link Logger}名）に対してマッチングを行う。

<dt>logger.&lt;{@link Logger}設定の名称&gt;.level
<dd>{@link LogLevel}の名称。必須。<br>
    {@link LogLevel}の名称を指定する。<br>
    ここで指定したレベル以上のログを全て出力する。

<dt>logger.&lt;{@link Logger}設定の名称&gt;.writerNames
<dd>{@link LogWriter}の名称。必須。<br>
    複数指定する場合はカンマ区切り。<br>
    ここで指定した全ての{@link LogWriter}に対してログの書き込みを行う。
</dl>
availableLoggersNamesOrderプロパティは、記述順に意味があるので注意すること。<br>
{@link Logger}の取得では、ログ出力を行うクラスが指定した{@link Logger}名に対して、
ここに記述した順番で{@link Logger}のマッチングを行い、最初にマッチした{@link Logger}を返す。<br>
そのため、availableLoggersNamesOrderプロパティは、より限定的な正規表現を指定した{@link Logger}から順に記述すること。<br>
<br>
初期処理完了後に、各{@link LogWriter}に対して、出力されるログレベルの書き込みを行う。<br>
初期処理完了後の出力例を下記に示す。
<pre>
2010-09-14 15:26:32.345 nablarch.core.log.basic.BasicLoggerFactory INFO [main] user_id[null] request_id[null] initialized.
     NAME REGEX = [MONITOR] LEVEL = [ERROR]
     NAME REGEX = [tis\.w8\.web\.handler\.HttpAccessLogHandler] LEVEL = [INFO]
     NAME REGEX = [.*] LEVEL = [WARN]
</pre>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### NULL_LOGGER

```java
private static final Logger NULL_LOGGER
```

何も処理しない{@link Logger}

---

### loggerDefinitions

```java
private List<LoggerDefinition> loggerDefinitions
```

設定で指定された全ての{@link Logger}定義

---

### writers

```java
private Map<String,LogWriter> writers
```

設定で指定された全ての{@link LogWriter}

---

## メソッドの詳細

### initialize

```java
public void initialize(LogSettings settings)
```

{@inheritDoc}<br>
<br>
ログ出力の設定に応じて、インスタンスの生成と初期化を行う。<br>
設定に不備がある場合は{@link IllegalArgumentException}をスローする。<br>
<br>
初期処理完了後に、各{@link LogWriter}に対して、出力されるログレベルの書き込みを行う。

---

### assertLoggerDefinitionMatching

```java
private void assertLoggerDefinitionMatching(LogSettings settings)
```

使用可能なロガー設定と、全てのロガー設定が一致するか検証する。<br>
一致しない場合は{@link IllegalArgumentException}を送出する。<br>
この検証は、設定ミスを防ぐために設けている。

**パラメータ:**
- `settings` - ログ出力の設定

---

### writeLoggerSettings

```java
private void writeLoggerSettings()
```

{@link LogWriter}毎に、自身に設定されているロガー設定を出力する。<br>
設定情報のフォーマットを下記に示す。<br>
<br>
LOGGER = [&lt;{@link Logger}名&gt;] NAME REGEX = [&lt;{@link Logger}名に対するマッチングに使用する正規表現&gt;] LEVEL = [&lt;ログの出力制御の基準とする{@link LogLevel}&gt;]

---

### createWriters

```java
private Map<String,LogWriter> createWriters(LogSettings settings)
```

設定で指定された全ての{@link LogWriter}の生成と初期化を行う。

**パラメータ:**
- `settings` - ログ出力の設定内容

**戻り値:**
設定で指定された全ての{@link LogWriter}

---

### createLoggerDefinitions

```java
private List<LoggerDefinition> createLoggerDefinitions(LogSettings settings)
```

設定で指定された全ての{@link Logger}定義を生成する。

**パラメータ:**
- `settings` - ログ出力の設定内容

**戻り値:**
設定で指定された全ての{@link Logger}定義

---

### terminate

```java
public void terminate()
```

{@inheritDoc}<br>
<br>
全ての{@link LogWriter}の終了処理を行う。<br>
{@link LogWriter}の終了処理で例外が発生した場合は、発生した例外をキャッチし、標準エラーにスタックトレースを出力する。<br>
発生した例外の再スローは行わない。

---

### get

```java
public Logger get(String name)
```

{@inheritDoc}<br>
<br>
availableLoggersNamesOrderプロパティで指定された順番に{@link Logger}名のマッチングを行い、最初にマッチした{@link Logger}を返す。<br>
マッチする{@link Logger}が見つからない場合は、何もしない{@link Logger}を返す。

---

### createLogWriter

```java
private LogWriter createLogWriter(ObjectSettings settings)
```

設定を使用して{@link LogWriter}を生成する。

**パラメータ:**
- `settings` - {@link LogWriter}の設定

**戻り値:**
設定を使用して生成した{@link LogWriter}

---

### createLoggerDefinition

```java
private LoggerDefinition createLoggerDefinition(String name, ObjectSettings settings)
```

設定を使用して{@link Logger}定義を生成する。

**パラメータ:**
- `name` - ロガー設定の名称
- `settings` - {@link Logger}定義の設定

**戻り値:**
設定を使用して生成した{@link Logger}定義

---

### getLogWriters

```java
private List<LogWriter> getLogWriters(ObjectSettings settings)
```

{@link Logger}定義に指定された{@link LogWriter}を取得する。

**パラメータ:**
- `settings` - {@link Logger}定義の設定

**戻り値:**
{@link Logger}に指定された{@link LogWriter}

---
