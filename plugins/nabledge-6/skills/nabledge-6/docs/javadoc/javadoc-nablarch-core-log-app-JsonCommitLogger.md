# class JsonCommitLogger

**パッケージ:** nablarch.core.log.app

**継承階層:**
```
java.lang.Object
  └─ BasicCommitLogger
      └─ nablarch.core.log.app.JsonCommitLogger
```

---

```java
public class JsonCommitLogger
extends BasicCommitLogger
```

コミットログ出力のJson版実装クラス。

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### structuredMessagePrefix

```java
private String structuredMessagePrefix
```

messageを構造化されていることを示す接頭辞

---

## メソッドの詳細

### setStructuredMessagePrefix

```java
public void setStructuredMessagePrefix(String structuredMessagePrefix)
```

messageを構造化されていることを示す接頭辞を設定する。

**パラメータ:**
- `structuredMessagePrefix` - messageを構造化されていることを示す接頭辞

---

### formatForIncrement

```java
protected String formatForIncrement(long count)
```

{@inheritDoc}

---

### formatForTerminate

```java
protected String formatForTerminate(long count)
```

{@inheritDoc}

---
