# class MessagingReceiveTestSupport

**パッケージ:** nablarch.test.core.messaging

**継承階層:**
```
java.lang.Object
  └─ MessagingRequestTestSupport
      └─ nablarch.test.core.messaging.MessagingReceiveTestSupport
```

---

```java
public class MessagingReceiveTestSupport
extends MessagingRequestTestSupport
```

メッセージ応答なし受信処理用のテストサポートクラス。

**作成者:** hisaaki sioiri  

---

## コンストラクタの詳細

### MessagingReceiveTestSupport

```java
protected MessagingReceiveTestSupport()
```

コンストラクタ。
サブクラスから使用されることを想定している。

---

### MessagingReceiveTestSupport

```java
public MessagingReceiveTestSupport(Class<?> testClass)
```

コンストラクタ。

**パラメータ:**
- `testClass` - テストクラス。

---

## メソッドの詳細

### createTestShotAround

```java
protected TestShot.TestShotAround createTestShotAround(Class<?> testClass)
```

{@inheritDoc}

---

### beforeExecute

```java
protected void beforeExecute(String sheetName)
```

{@inheritDoc}

---
