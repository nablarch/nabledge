# interface Transaction

**パッケージ:** nablarch.core.transaction

---

```java
public interface Transaction
```

トランザクション制御を行うインタフェース。

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### begin

```java
void begin()
```

トランザクションを開始する。

---

### commit

```java
void commit()
```

現在のトランザクションをコミットする。

---

### rollback

```java
void rollback()
```

現在のトランザクションをロールバックする。

---
