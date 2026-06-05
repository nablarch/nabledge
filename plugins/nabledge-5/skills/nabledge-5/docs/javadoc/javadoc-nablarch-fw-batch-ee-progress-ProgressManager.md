# interface ProgressManager

**パッケージ:** nablarch.fw.batch.ee.progress

---

```java
public interface ProgressManager
```

進捗を管理するインタフェース。

**作成者:** Naoki Yamamoto  

---

## メソッドの詳細

### setInputCount

```java
void setInputCount(long inputCount)
```

処理対象の件数を設定する。

**パラメータ:**
- `inputCount` - 処理対象の件数

---

### outputProgressInfo

```java
void outputProgressInfo()
```

進捗状況を出力する。

---

### outputProgressInfo

```java
void outputProgressInfo(long processedCount)
```

進捗状況を出力する。

**パラメータ:**
- `processedCount` - 処理済み件数

---
