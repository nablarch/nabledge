# class CompositeCommitLogger

**パッケージ:** nablarch.core.log.app

**実装されたインタフェース:**
- CommitLogger

---

```java
public class CompositeCommitLogger
implements CommitLogger
```

複数の{@link CommitLogger}を組み合わせたロガークラス。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### commitLoggerList

```java
private List<? extends CommitLogger> commitLoggerList
```

---

## メソッドの詳細

### initialize

```java
public void initialize()
```

---

### increment

```java
public void increment(long count)
```

---

### terminate

```java
public void terminate()
```

---

### setCommitLoggerList

```java
public void setCommitLoggerList(List<? extends CommitLogger> commitLoggerList)
```

{@link CommitLogger}のリストを設定する。

**パラメータ:**
- `commitLoggerList` - {@link CommitLogger}のリスト

---
