# class RequestEntityTooLarge

**パッケージ:** nablarch.fw.results

**継承階層:**
```
java.lang.Object
  └─ ClientError
      └─ nablarch.fw.results.RequestEntityTooLarge
```

---

```java
public class RequestEntityTooLarge
extends ClientError
```

要求されたリクエストが大きすぎるため、処理を継続できないことを示す例外。

---

## フィールドの詳細

### DEFAULT_MESSAGE

```java
private static final String DEFAULT_MESSAGE
```

デフォルトメッセージ

---

## コンストラクタの詳細

### RequestEntityTooLarge

```java
public RequestEntityTooLarge()
```

デフォルトコンストラクタ

---

### RequestEntityTooLarge

```java
public RequestEntityTooLarge(String message)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ

---

### RequestEntityTooLarge

```java
public RequestEntityTooLarge(Throwable cause)
```

コンストラクタ

**パラメータ:**
- `cause` - 起因となる例外

---

### RequestEntityTooLarge

```java
public RequestEntityTooLarge(String message, Throwable cause)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ
- `cause` - 起因となる例外

---

## メソッドの詳細

### getStatusCode

```java
public int getStatusCode()
```

{@inheritDoc}

---
