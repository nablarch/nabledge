# class LogWriterSupport

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- LogWriter

---

```java
public abstract class LogWriterSupport
implements LogWriter
```

{@link LogWriter}の実装をサポートするクラス。<br>
<br>
このクラスでは、下記の機能を提供する。
<ul>
<li>{@link LogLevel}に応じた出力制御</li>
<li>{@link LogFormatter}を使用したログのフォーマット</li>
</ul>
上記の機能は、プロパティファイルに設定を記述して使用する。<br>
プロパティファイルの記述ルールを下記に示す。
<dl>
<dt>writer.&lt;{@link LogWriter}の名称&gt;.level
<dd>{@link LogLevel}の名称。オプション。<br>
    {@link LogLevel}の名称を指定する。<br>
    ここで指定したレベル以上のログを全て出力する。
    指定がない場合はレベルに応じた出力制御を行わず、全てのレベルのログを出力する。

<dt>writer.&lt;{@link LogWriter}の名称&gt;.formatter.className
<dd>{@link LogWriter}で使用する{@link LogFormatter}のクラス名。<br>
    {@link LogFormatter}を実装したクラスのFQCNを指定する。
    指定がない場合は{@link BasicLogFormatter}を使用する。

<dt>writer.&lt;{@link LogWriter}の名称&gt;.formatter.<プロパティ名>
<dd>{@link LogFormatter}毎のプロパティに設定する値。<br>
    設定内容は、使用する{@link LogFormatter}のJavadocを参照すること。
</dl>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### name

```java
private String name
```

設定で指定された{@link LogWriter}の名称

---

### baseLevel

```java
private LogLevel baseLevel
```

ログの出力制御の基準とする{@link LogLevel}

---

### baseLevelValue

```java
private int baseLevelValue
```

ログの出力制御の基準とする{@link LogLevel}の値

---

### formatter

```java
private LogFormatter formatter
```

{@link LogFormatter}

---

## メソッドの詳細

### initialize

```java
public void initialize(ObjectSettings settings)
```

{@inheritDoc}<br>
<br>
設定を使用して{@link LogLevel}と{@link LogFormatter}を初期化する。

---

### createLogFormatter

```java
protected LogFormatter createLogFormatter(ObjectSettings settings)
```

設定を使用して{@link LogFormatter}を生成する。

**パラメータ:**
- `settings` - {@link LogFormatter}の設定

**戻り値:**
設定を使用して生成した{@link LogFormatter}。指定がない場合は<code>null</code>

---

### onInitialize

```java
protected void onInitialize(ObjectSettings settings)
```

初期処理を行う。<br>
ログの出力先に応じたリソースの確保などを実装する。<br>
デフォルト実装では何もしない。

**パラメータ:**
- `settings` - {@link LogWriter}の設定内容

---

### terminate

```java
public void terminate()
```

{@inheritDoc}

---

### onTerminate

```java
protected void onTerminate()
```

終了処理を行う。<br>
ログの出力先に応じて確保しているリソースの解放などを実装する。<br>
デフォルト実装では何もしない。

---

### write

```java
public void write(LogContext context)
```

フォーマット済みのログを出力先に書き込む。<br>
<br>
設定で{@link LogLevel}が指定されている場合は、有効なレベルの場合のみ{@link #onWrite(String)}メソッドを呼び出す。<br>
有効なレベルのログでない場合は、何も処理しない。

**パラメータ:**
- `context` - {@link LogContext}

---

### needsToWrite

```java
public boolean needsToWrite(LogContext context)
```

現在の設定から、指定されたログエントリを出力するか否かを返す。

**パラメータ:**
- `context` - ログエントリオブジェクト

**戻り値:**
ログを出力する場合はtrue

---

### onWrite

```java
protected abstract void onWrite(String formattedMessage)
```

フォーマット済みのログを出力先に書き込む。

**パラメータ:**
- `formattedMessage` - フォーマット済みのログ

---

### getSettings

```java
protected String getSettings()
```

設定情報を取得する。<br>
<br>
設定情報のフォーマットを下記に示す。<br>
<br>
WRITER NAME        = [&lt;{@link LogWriter}の名称&gt;]<br>
WRITER CLASS       = [&lt;{@link LogWriter}のクラス名&gt;]<br>
FORMATTER CLASS    = [&lt;{@link LogFormatter}のクラス名&gt;]<br>
LEVEL              = [&lt;ログの出力制御の基準とする{@link LogLevel}&gt;]

**戻り値:**
設定情報

---

### getName

```java
protected String getName()
```

設定で指定された{@link LogWriter}の名称を取得する。

**戻り値:**
設定で指定された{@link LogWriter}の名称

---

### getFormatter

```java
protected LogFormatter getFormatter()
```

{@link LogFormatter}を取得する。

**戻り値:**
{@link LogFormatter}

---
