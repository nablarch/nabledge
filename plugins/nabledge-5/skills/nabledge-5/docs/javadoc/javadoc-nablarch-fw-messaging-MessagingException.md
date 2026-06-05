# class MessagingException

**パッケージ:** nablarch.fw.messaging

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.fw.messaging.MessagingException
```

---

```java
public class MessagingException
extends RuntimeException
```

メッセージ処理において問題が発生した場合に送出される実行時例外。

**作成者:** Iwauo Tajima  

---

## コンストラクタの詳細

### MessagingException

```java
public MessagingException()
```

デフォルトコンストラクタ。

---

### MessagingException

```java
public MessagingException(String message, Throwable cause)
```

コンストラクタ。

**パラメータ:**
- `message` - エラーメッセージ
- `cause` - 起因となる例外

---

### MessagingException

```java
public MessagingException(String message)
```

コンストラクタ。

**パラメータ:**
- `message` - エラーメッセージ

---

### MessagingException

```java
public MessagingException(Throwable cause)
```

コンストラクタ。

**パラメータ:**
- `cause` - 起因となる例外

---
