# class ServiceError

**パッケージ:** nablarch.fw.results

**継承階層:**
```
java.lang.Object
  └─ nablarch.fw.Result.Error
      └─ nablarch.fw.results.ServiceError
```

---

```java
public abstract class ServiceError
extends nablarch.fw.Result.Error
```

サービス側で生じた問題により処理が継続できないことを示す例外。
<p/>
問題解決には、サービス側での対処が必要となるため、エラーメッセージの内容として、
呼び出し側が問題が発生したことをサービス管理者に連絡する方法と、
管理者に伝えるべき内容を含める必要がある。

また、メッセージIDを設定することにより、
運用ログへの出力に関する制御を行うことができる。

---

## フィールドの詳細

### logLevel

```java
private LogLevel logLevel
```

ログレベル

---

### messageId

```java
private String messageId
```

メッセージID

---

### messageParams

```java
private Object[] messageParams
```

メッセージ埋め込みパラメータ

---

### logOptions

```java
private Object[] logOptions
```

ログのオプション情報

---

## コンストラクタの詳細

### ServiceError

```java
public ServiceError()
```

デフォルトコンストラクタ

---

### ServiceError

```java
public ServiceError(String message)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ

---

### ServiceError

```java
public ServiceError(Throwable cause)
```

コンストラクタ

**パラメータ:**
- `cause` - 起因となる例外

---

### ServiceError

```java
public ServiceError(String message, Throwable cause)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ
- `cause` - 起因となる例外

---

### ServiceError

```java
public ServiceError(LogLevel logLevel, String messageId, Object messageParams)
```

運用ログへの出力に関する制御情報を含む例外を生成する。

**パラメータ:**
- `logLevel` - ログ出力レベル
- `messageId` - ログ内容のメッセージID
- `messageParams` - ログメッセージの埋め込みパラメータ

---

### ServiceError

```java
public ServiceError(LogLevel logLevel, Throwable cause, String messageId, Object messageParams)
```

運用ログへの出力に関する制御情報を含む例外を生成する。

**パラメータ:**
- `logLevel` - ログ出力レベル
- `cause` - 障害の起因となる例外
- `messageId` - ログ内容のメッセージID
- `messageParams` - ログメッセージの埋め込みパラメータ

---

## メソッドの詳細

### getMessageId

```java
public String getMessageId()
```

メッセージIDを返す。

**戻り値:**
メッセージID

---

### getMessageParams

```java
public Object[] getMessageParams()
```

メッセージパラメータを返す。

**戻り値:**
メッセージパラメータ

---

### getMessage

```java
public String getMessage()
```

{@inheritDoc}
<p/>
このインスタンスにメッセージIDが指定されている場合は、
そのIDに対応したメッセージ内容を返す。

---

### writeLog

```java
public void writeLog(ExecutionContext context)
```

この障害の内容について運用ログに出力する。
<p/>
ログレベルがエラーレベル以上の場合に、障害内容を運用ログに出力する。
ワーニングレベル以下の場合は何もしない。

**パラメータ:**
- `context` - 実行コンテキスト

---

### getStatusCode

```java
public int getStatusCode()
```

{@inheritDoc}

---
