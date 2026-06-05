# interface BusinessDateProvider

**パッケージ:** nablarch.core.date

---

```java
public interface BusinessDateProvider
```

業務日付を提供するクラスのインタフェース。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### getDate

```java
String getDate()
```

デフォルトの区分を使用して業務日付を取得する。

**戻り値:**
業務日付(yyyyMMdd形式)

---

### getDate

```java
String getDate(String segment)
```

区分を指定して業務日付を取得する。

**パラメータ:**
- `segment` - 区分値

**戻り値:**
業務日付(yyyyMMdd形式)

---

### getAllDate

```java
Map<String,String> getAllDate()
```

全ての業務日付を取得する。

**戻り値:**
区分をキー、対応する業務日付(yyyyMMdd形式)を値としたMap

---

### setDate

```java
void setDate(String segment, String date)
```

区分を指定して業務日付を設定する。

**パラメータ:**
- `segment` - 区分値
- `date` - 業務日付(yyyyMMdd形式)

---
