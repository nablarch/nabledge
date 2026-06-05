# class FailureLogUtil

**パッケージ:** nablarch.core.log.app

---

```java
public final class FailureLogUtil
```

障害ログを出力するユーティリティクラス。
<p/>
本ユーティリティを使用するには、app-log.propertiesの設定が必要である。<br/>
障害通知ログは"MONITOR"、障害解析ログは本クラス名(FQCN)をロガー名に使用する。<br/>
ログレベルは、ログ出力に使用したメソッドにより決まる。<br/>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### MONITOR_LOGGER

```java
private static final Logger MONITOR_LOGGER
```

障害通知ログを出力するロガー

---

### ANALYSIS_LOGGER

```java
private static final Logger ANALYSIS_LOGGER
```

障害解析ログを出力するロガー

---

### FAILURE_LOG_FORMATTER_CREATOR

```java
private static final ObjectCreator<FailureLogFormatter> FAILURE_LOG_FORMATTER_CREATOR
```

{@link FailureLogFormatter}を生成する{@link ObjectCreator}

---

### PROPS_CLASS_NAME

```java
private static final String PROPS_CLASS_NAME
```

使用する{@link FailureLogFormatter}のクラス名を取得する際に使用するプロパティ名

---

## コンストラクタの詳細

### FailureLogUtil

```java
private FailureLogUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### initialize

```java
public static void initialize()
```

クラスローダに紐付く{@link FailureLogFormatter}を生成する。

---

### getFailureLogFormatter

```java
private static FailureLogFormatter getFailureLogFormatter()
```

クラスローダに紐付く{@link FailureLogFormatter}を取得する。

**戻り値:**
{@link FailureLogFormatter}

---

### logFatal

```java
public static void logFatal(Object data, String failureCode, Object messageOptions)
```

FATALレベルの障害通知ログと障害解析ログを出力する。

**パラメータ:**
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

### logFatal

```java
public static void logFatal(Throwable error, Object data, String failureCode, Object messageOptions)
```

FATALレベルの障害通知ログと障害解析ログを出力する。

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

### logFatal

```java
public static void logFatal(Throwable error, Object data, String failureCode, Object[] messageOptions, Object[] logOptions)
```

FATALレベルの障害通知ログと障害解析ログを出力する。

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報
- `logOptions` - ログのオプション情報

---

### logError

```java
public static void logError(Object data, String failureCode, Object messageOptions)
```

ERRORレベルの障害通知ログと障害解析ログを出力する。

**パラメータ:**
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

### logError

```java
public static void logError(Throwable error, Object data, String failureCode, Object messageOptions)
```

ERRORレベルの障害通知ログと障害解析ログを出力する。

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

### logError

```java
public static void logError(Throwable error, Object data, String failureCode, Object[] messageOptions, Object[] logOptions)
```

ERRORレベルの障害通知ログと障害解析ログを出力する。

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報
- `logOptions` - ログのオプション情報

---

### logWarn

```java
public static void logWarn(Throwable error, Object data, String failureCode, Object messageOptions)
```

WARNレベルの障害解析ログを出力する。
<p/>
フレームワークにおいて複数例外発生時に障害ログとして出力できない例外をログ出力する場合に使用する。

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

### getNotificationMessage

```java
public static String getNotificationMessage(Object data, String failureCode, Object messageOptions)
```

フォーマットされた障害通知ログのメッセージを取得する。

**パラメータ:**
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

**戻り値:**
フォーマット済みのメッセージ

---

### getNotificationMessage

```java
public static String getNotificationMessage(Throwable error, Object data, String failureCode, Object[] messageOptions)
```

フォーマットされた障害通知ログのメッセージを取得する。

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

**戻り値:**
フォーマット済みのメッセージ

---
