# interface CommitLogger

**パッケージ:** nablarch.core.log.app

---

```java
public interface CommitLogger
```

コミットログ出力インタフェース。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### SESSION_SCOPE_KEY

```java
String SESSION_SCOPE_KEY
```

セッションに自身のインスタンスを格納する際に使用するキー

---

## メソッドの詳細

### initialize

```java
void initialize()
```

初期処理を行う。

---

### increment

```java
void increment(long count)
```

コミット件数のインクリメントを行う。

**パラメータ:**
- `count` - コミット済み件数

---

### terminate

```java
void terminate()
```

終了処理を行う。

---
