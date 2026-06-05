# class Forbidden

**パッケージ:** nablarch.fw.results

**継承階層:**
```
java.lang.Object
  └─ ClientError
      └─ nablarch.fw.results.Forbidden
```

---

```java
public class Forbidden
extends ClientError
```

必要な権限が無いため、処理を継続することができない
ことを示す例外。

---

## フィールドの詳細

### DEFAULT_MESSAGE

```java
private static final String DEFAULT_MESSAGE
```

デフォルトメッセージ

---

## コンストラクタの詳細

### Forbidden

```java
public Forbidden()
```

デフォルトコンストラクタ

---

### Forbidden

```java
public Forbidden(String message)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ

---

### Forbidden

```java
public Forbidden(Throwable cause)
```

コンストラクタ

**パラメータ:**
- `cause` - 起因となる例外

---

### Forbidden

```java
public Forbidden(String message, Throwable cause)
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
