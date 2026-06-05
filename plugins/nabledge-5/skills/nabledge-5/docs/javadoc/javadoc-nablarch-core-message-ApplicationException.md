# class ApplicationException

**パッケージ:** nablarch.core.message

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.core.message.ApplicationException
```

---

```java
public class ApplicationException
extends RuntimeException
```

業務エラーが発生した際のメッセージ通知に使用する例外クラス。
<p/>
本クラスは内部に処理結果メッセージ（{@link Message}）のリストを保持する。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### messages

```java
private List<Message> messages
```

処理結果メッセージのリスト。

---

## コンストラクタの詳細

### ApplicationException

```java
public ApplicationException()
```

ApplicationExceptionオブジェクトを生成する。

---

### ApplicationException

```java
public ApplicationException(Message message)
```

指定した処理結果メッセージを保持するApplicationExceptionオブジェクトを生成する。

**パラメータ:**
- `message` - 処理結果メッセージ

---

### ApplicationException

```java
public ApplicationException(List<Message> messages)
```

指定した処理結果メッセージのリストを保持するApplicationExceptionオブジェクトを生成する。

**パラメータ:**
- `messages` - 処理結果メッセージのリスト

---

## メソッドの詳細

### addMessages

```java
public void addMessages(Message message)
```

処理結果メッセージを追加する。

**パラメータ:**
- `message` - 処理結果メッセージ

---

### addMessages

```java
public void addMessages(List<Message> messages)
```

処理結果メッセージを追加する。

**パラメータ:**
- `messages` - 処理結果メッセージのリスト

---

### getMessages

```java
public List<Message> getMessages()
```

処理結果メッセージのリストを取得する。

**戻り値:**
処理結果メッセージのリスト

---

### getMessage

```java
public String getMessage()
```

---
