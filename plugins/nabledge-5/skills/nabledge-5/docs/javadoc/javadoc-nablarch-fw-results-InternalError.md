# class InternalError

**パッケージ:** nablarch.fw.results

**継承階層:**
```
java.lang.Object
  └─ ServiceError
      └─ nablarch.fw.results.InternalError
```

---

```java
public class InternalError
extends ServiceError
```

ハンドラの内部処理で発生した問題により、処理が継続できないことを
示す例外。

---

## フィールドの詳細

### STATUS_CODE

```java
public static final int STATUS_CODE
```

処理継続が不可能であることを示すステータスコード

---

### DEFAULT_MESSAGE

```java
private static final String DEFAULT_MESSAGE
```

デフォルトメッセージ

---

## コンストラクタの詳細

### InternalError

```java
public InternalError()
```

デフォルトコンストラクタ

---

### InternalError

```java
public InternalError(String message)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ

---

### InternalError

```java
public InternalError(Throwable cause)
```

コンストラクタ

**パラメータ:**
- `cause` - 起因となる例外

---

### InternalError

```java
public InternalError(String message, Throwable cause)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ
- `cause` - 起因となる例外

---

### InternalError

```java
public InternalError(LogLevel logLevel, String messageId, Object messageParams)
```

コンストラクタ

**パラメータ:**
- `logLevel` - 運用ログの出力レベル
- `messageId` - エラーメッセージのID
- `messageParams` - エラーメッセージの埋め込みパラメータ

---

### InternalError

```java
public InternalError(LogLevel logLevel, Throwable cause, String messageId, Object messageParams)
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
