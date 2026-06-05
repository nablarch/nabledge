# class LogContext

**パッケージ:** nablarch.core.log.basic

---

```java
public class LogContext
```

ログ出力に必要な情報を保持するクラス。
<br>
スレッド名、ユーザID、リクエストIDは、スレッドに紐付く値をクラスの内部で設定する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### loggerName

```java
private String loggerName
```

ロガー名

---

### runtimeLoggerName

```java
private String runtimeLoggerName
```

実行時ロガー名

---

### level

```java
private LogLevel level
```

{@link LogLevel}

---

### message

```java
private String message
```

メッセージ

---

### error

```java
private Throwable error
```

エラー情報

---

### options

```java
private Object[] options
```

オプション情報

---

### date

```java
private Date date
```

LogContext作成時点の日時

---

### userId

```java
private String userId
```

LogContext作成時点のユーザID

---

### requestId

```java
private String requestId
```

LogContext作成時点のリクエストID

---

### executionId

```java
private String executionId
```

LogContext作成時点の実行時ID

---

## コンストラクタの詳細

### LogContext

```java
public LogContext(String loggerName, LogLevel level, String message, Throwable error, Object options)
```

コンストラクタ。

**パラメータ:**
- `loggerName` - ロガー名
- `level` - {@link LogLevel}
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---

### LogContext

```java
public LogContext(String loggerName, String runtimeLoggerName, LogLevel level, String message, Throwable error, Object options)
```

実行時ロガー名を付与するコンストラクタ。

**パラメータ:**
- `loggerName` - ロガー名
- `runtimeLoggerName` - 実行時ロガー名
- `level` - {@link LogLevel}
- `message` - メッセージ
- `error` - エラー情報(nullでも可)
- `options` - オプション情報(nullでも可)

---

## メソッドの詳細

### getLoggerName

```java
public String getLoggerName()
```

ロガー設定の名称を取得する。

**戻り値:**
ロガー設定の名称

---

### getRuntimeLoggerName

```java
public String getRuntimeLoggerName()
```

ロガーを取得したときの名称を実行時ロガー名として取得する。

**戻り値:**
ロガーを取得したときの名称

---

### getLevel

```java
public LogLevel getLevel()
```

{@link LogLevel}を取得する。

**戻り値:**
{@link LogLevel}

---

### getMessage

```java
public String getMessage()
```

メッセージを取得する。

**戻り値:**
メッセージ

---

### getError

```java
public Throwable getError()
```

エラー情報を取得する。

**戻り値:**
エラー情報

---

### getOptions

```java
public Object[] getOptions()
```

オプション情報を取得する。

**戻り値:**
オプション情報

---

### getDate

```java
public Date getDate()
```

LogContext作成時点の日時を取得する。

**戻り値:**
LogContext作成時点の日時

---

### getUserId

```java
public String getUserId()
```

LogContext作成時点のユーザIDを取得する。

**戻り値:**
LogContext作成時点のユーザID

---

### getRequestId

```java
public String getRequestId()
```

LogContext作成時点のリクエストIDを取得する。

**戻り値:**
LogContext作成時点のリクエストID

---

### getExecutionId

```java
public String getExecutionId()
```

LogContext作成時点の実行時IDを取得する。

**戻り値:**
LogContext作成時点の実行時ID

---
