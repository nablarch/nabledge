# class BasicLogger

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- Logger

---

```java
public class BasicLogger
implements Logger
```

{@link Logger}の基本実装クラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### name

```java
private String name
```

ロガー名

---

### runtimeName

```java
private String runtimeName
```

実行時のロガー名

---

### baseLevel

```java
private LogLevel baseLevel
```

ログの出力制御の基準とする{@link LogLevel}

---

### writers

```java
private LogWriter[] writers
```

{@link LogWriter}

---

### fatalEnabled

```java
private boolean fatalEnabled
```

FATALレベルのログ出力が有効か否か。

---

### errorEnabled

```java
private boolean errorEnabled
```

ERRORレベルのログ出力が有効か否か。

---

### warnEnabled

```java
private boolean warnEnabled
```

WARNレベルのログ出力が有効か否か。

---

### infoEnabled

```java
private boolean infoEnabled
```

INFOレベルのログ出力が有効か否か。

---

### debugEnabled

```java
private boolean debugEnabled
```

DEBUGレベルのログ出力が有効か否か。

---

### traceEnabled

```java
private boolean traceEnabled
```

TRACEレベルのログ出力が有効か否か。

---

## コンストラクタの詳細

### BasicLogger

```java
BasicLogger(String name, LogLevel baseLevel, LogWriter[] writers)
```

コンストラクタ。

**パラメータ:**
- `name` - ロガー名
- `baseLevel` - ログの出力制御の基準とする{@link LogLevel}
- `writers` - {@link LogWriter}

---

### BasicLogger

```java
BasicLogger(BasicLogger src, String runtimeName)
```

{@link BasicLogger}をコピーし実行時ロガー名を付与するコンストラクタ。

**パラメータ:**
- `src` - コピー元{@link BasicLogger}
- `runtimeName` - 実行時ロガー名

---

### BasicLogger

```java
BasicLogger(String name)
```

ロガー定義が存在しないロガー名が指定された場合に、
何もしない{@link Logger}を生成するためのコンストラクタ。

**パラメータ:**
- `name` - ロガー名

---

## メソッドの詳細

### initializeLogLevelEnabled

```java
private void initializeLogLevelEnabled()
```

全ての{@link LogLevel}に対するログ出力の有効／無効を初期化する。

---

### isFatalEnabled

```java
public boolean isFatalEnabled()
```

{@inheritDoc}

---

### logFatal

```java
public void logFatal(String message, Object options)
```

{@inheritDoc}

---

### logFatal

```java
public void logFatal(String message, Throwable error, Object options)
```

{@inheritDoc}

---

### isErrorEnabled

```java
public boolean isErrorEnabled()
```

{@inheritDoc}

---

### logError

```java
public void logError(String message, Object options)
```

{@inheritDoc}

---

### logError

```java
public void logError(String message, Throwable error, Object options)
```

{@inheritDoc}

---

### isWarnEnabled

```java
public boolean isWarnEnabled()
```

{@inheritDoc}

---

### logWarn

```java
public void logWarn(String message, Object options)
```

{@inheritDoc}

---

### logWarn

```java
public void logWarn(String message, Throwable error, Object options)
```

{@inheritDoc}

---

### isInfoEnabled

```java
public boolean isInfoEnabled()
```

{@inheritDoc}

---

### logInfo

```java
public void logInfo(String message, Object options)
```

{@inheritDoc}

---

### logInfo

```java
public void logInfo(String message, Throwable error, Object options)
```

{@inheritDoc}

---

### isDebugEnabled

```java
public boolean isDebugEnabled()
```

{@inheritDoc}

---

### logDebug

```java
public void logDebug(String message, Object options)
```

{@inheritDoc}

---

### logDebug

```java
public void logDebug(String message, Throwable error, Object options)
```

{@inheritDoc}

---

### isTraceEnabled

```java
public boolean isTraceEnabled()
```

{@inheritDoc}

---

### logTrace

```java
public void logTrace(String message, Object options)
```

{@inheritDoc}

---

### logTrace

```java
public void logTrace(String message, Throwable error, Object options)
```

{@inheritDoc}

---

### log

```java
private void log(LogLevel level, String message, Throwable error, Object options)
```

指定された{@link LogLevel}でログを出力する。<br>
<br>
{@link LogWriter}の書き込み処理で例外が発生した場合は、発生した例外をキャッチし、標準エラーにスタックトレースを出力する。<br>
発生した例外の再スローは行わない。

**パラメータ:**
- `level` - {@link LogLevel}
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---
