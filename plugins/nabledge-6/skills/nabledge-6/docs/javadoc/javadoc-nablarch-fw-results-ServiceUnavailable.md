# class ServiceUnavailable

**パッケージ:** nablarch.fw.results

**継承階層:**
```
java.lang.Object
  └─ ServiceError
      └─ nablarch.fw.results.ServiceUnavailable
```

---

```java
public class ServiceUnavailable
extends ServiceError
```

一時的に処理の受付を停止していることを表す例外。

---

## フィールドの詳細

### DEFAULT_MESSAGE

```java
private static final String DEFAULT_MESSAGE
```

デフォルトメッセージ

---

### retryAfter

```java
private Long retryAfter
```

処理受付が再開される予定時刻(Unix-Time)

---

## コンストラクタの詳細

### ServiceUnavailable

```java
public ServiceUnavailable()
```

デフォルトコンストラクタ

---

### ServiceUnavailable

```java
public ServiceUnavailable(String message)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ

---

### ServiceUnavailable

```java
public ServiceUnavailable(Throwable cause)
```

コンストラクタ

**パラメータ:**
- `cause` - 起因となる例外

---

### ServiceUnavailable

```java
public ServiceUnavailable(String message, Throwable cause)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ
- `cause` - 起因となる例外

---

### ServiceUnavailable

```java
public ServiceUnavailable(LogLevel logLevel, String messageId, Object messageParams)
```

コンストラクタ

**パラメータ:**
- `logLevel` - 運用ログの出力レベル
- `messageId` - エラーメッセージのID
- `messageParams` - エラーメッセージの埋め込みパラメータ

---

### ServiceUnavailable

```java
public ServiceUnavailable(LogLevel logLevel, Throwable cause, String messageId, Object messageParams)
```

コンストラクタ

**パラメータ:**
- `logLevel` - 運用ログの出力レベル
- `cause` - 起因となる例外
- `messageId` - エラーメッセージのID
- `messageParams` - エラーメッセージの埋め込みパラメータ

---

## メソッドの詳細

### getStatusCode

```java
public int getStatusCode()
```

{@inheritDoc}

---

### setRetryAfter

```java
public ServiceUnavailable setRetryAfter(Date retryAfter)
```

処理受付が再開される予定時刻を設定する。

**パラメータ:**
- `retryAfter` - 再開予定時刻

**戻り値:**
自身のインスタンス

---

### getRetryAfter

```java
public Date getRetryAfter()
```

処理受付が再開される予定時刻を返す。
デフォルトはnull。(=再開時期未定)

**戻り値:**
再開予定時間

---
