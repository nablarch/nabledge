# interface Logger

**パッケージ:** nablarch.core.log

---

```java
public interface Logger
```

ログを出力するインタフェース。<br/>
ログ出力機能の実装毎に本インタフェースの実装クラスを作成する。
<p>
アプリケーションから障害ログ出力を行う必要がある場合は、本インタフェースを直接使用するのではなく、
{@link nablarch.core.log.app.FailureLogUtil}を使用すること。
また、TRACEレベルのログ出力については、アプリケーション開発での使用は想定していない為、
非公開としている。
</p>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LS

```java
String LS
```

システムプロパティ(line.separator)から取得した行区切り記号

---

## メソッドの詳細

### isFatalEnabled

```java
boolean isFatalEnabled()
```

FATALレベルのログ出力が有効か否かを判定する。

**戻り値:**
有効な場合は<code>true</code>

---

### logFatal

```java
void logFatal(String message, Object options)
```

FATALレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `options` - オプション情報(nullでも可)

---

### logFatal

```java
void logFatal(String message, Throwable error, Object options)
```

FATALレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---

### isErrorEnabled

```java
boolean isErrorEnabled()
```

ERRORレベルのログ出力が有効か否かを判定する。

**戻り値:**
有効な場合は<code>true</code>

---

### logError

```java
void logError(String message, Object options)
```

ERRORレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `options` - オプション情報(nullでも可)

---

### logError

```java
void logError(String message, Throwable error, Object options)
```

ERRORレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---

### isWarnEnabled

```java
boolean isWarnEnabled()
```

WARNレベルのログ出力が有効か否かを判定する。

**戻り値:**
有効な場合は<code>true</code>

---

### logWarn

```java
void logWarn(String message, Object options)
```

WARNレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `options` - オプション情報(nullでも可)

---

### logWarn

```java
void logWarn(String message, Throwable error, Object options)
```

WARNレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---

### isInfoEnabled

```java
boolean isInfoEnabled()
```

INFOレベルのログ出力が有効か否かを判定する。

**戻り値:**
有効な場合は<code>true</code>

---

### logInfo

```java
void logInfo(String message, Object options)
```

INFOレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `options` - オプション情報(nullでも可)

---

### logInfo

```java
void logInfo(String message, Throwable error, Object options)
```

INFOレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---

### isDebugEnabled

```java
boolean isDebugEnabled()
```

DEBUGレベルのログ出力が有効か否かを判定する。

**戻り値:**
有効な場合は<code>true</code>

---

### logDebug

```java
void logDebug(String message, Object options)
```

DEBUGレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `options` - オプション情報(nullでも可)

---

### logDebug

```java
void logDebug(String message, Throwable error, Object options)
```

DEBUGレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---

### isTraceEnabled

```java
boolean isTraceEnabled()
```

TRACEレベルのログ出力が有効か否かを判定する。

**戻り値:**
有効な場合は<code>true</code>

---

### logTrace

```java
void logTrace(String message, Object options)
```

TRACEレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `options` - オプション情報(nullでも可)

---

### logTrace

```java
void logTrace(String message, Throwable error, Object options)
```

TRACEレベルでログを出力する。

**パラメータ:**
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---
