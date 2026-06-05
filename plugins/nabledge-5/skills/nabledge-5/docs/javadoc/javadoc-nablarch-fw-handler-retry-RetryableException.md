# class RetryableException

**パッケージ:** nablarch.fw.handler.retry

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.fw.handler.retry.RetryableException
```

**実装されたインタフェース:**
- Retryable

---

```java
public class RetryableException
extends RuntimeException
implements Retryable
```

RetryHandler によるリトライが可能な実行時例外。

**作成者:** Iwauo Tajiama  

---

## コンストラクタの詳細

### RetryableException

```java
public RetryableException()
```

デフォルトコンストラクタ。

---

### RetryableException

```java
public RetryableException(String message, Throwable cause)
```

コンストラクタ。

**パラメータ:**
- `message` - 例外メッセージ
- `cause` - 起因例外

---

### RetryableException

```java
public RetryableException(String message)
```

コンストラクタ。

**パラメータ:**
- `message` - 例外メッセージ

---

### RetryableException

```java
public RetryableException(Throwable cause)
```

コンストラクタ。

**パラメータ:**
- `cause` - 起因例外

---
