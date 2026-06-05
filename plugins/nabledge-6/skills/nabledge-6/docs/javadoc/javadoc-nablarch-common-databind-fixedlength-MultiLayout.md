# class MultiLayout

**パッケージ:** nablarch.common.databind.fixedlength

---

```java
public abstract class MultiLayout
```

マルチレイアウトな固定長データを表すクラス。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### recordName

```java
private MultiLayoutConfig.RecordName recordName
```

レコード名

---

## メソッドの詳細

### getRecordName

```java
public MultiLayoutConfig.RecordName getRecordName()
```

レコード名を取得する。

**戻り値:**
レコード名

---

### setRecordName

```java
public void setRecordName(MultiLayoutConfig.RecordName recordName)
```

レコード名を設定する。

**パラメータ:**
- `recordName` - レコード名

---

### getRecordIdentifier

```java
public abstract RecordIdentifier getRecordIdentifier()
```

レコード識別クラスを取得する。

**戻り値:**
レコード識別クラス

---
