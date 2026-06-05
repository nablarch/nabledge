# class BusinessDateUtil

**パッケージ:** nablarch.core.date

---

```java
public final class BusinessDateUtil
```

業務日付を取得するユーティリティクラス。
<p/>
業務日付の取得処理は{@link BusinessDateProvider}によって提供される。
BusinessDateProviderの実装は、{@link SystemRepository}からコンポーネント名 businessDateProvider で取得される。
<p/>
業務日付の複数設定について<br/>
本フレームワークでは、オンラインとバッチで別の業務日付を使用するなど、用途ごとに複数の業務日付を管理できる。
業務日付には、それぞれを識別するための「区分」が設定される。
本クラスは、区分を指定して業務日付を取得する機能を提供する。

**作成者:** Miki Habu  

---

## フィールドの詳細

### DATE_PROVIDER

```java
private static final String DATE_PROVIDER
```

業務日付取得コンポーネント名。

---

## コンストラクタの詳細

### BusinessDateUtil

```java
private BusinessDateUtil()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### getDate

```java
public static String getDate()
```

業務日付を取得する。区分はデフォルトを使用する。

**戻り値:**
業務日付(yyyyMMdd形式)

---

### getDate

```java
public static String getDate(String segment)
```

区分を指定して、業務日付を取得する。

**パラメータ:**
- `segment` - 区分

**戻り値:**
指定された区分の業務日付(yyyyMMdd形式)

---

### getAllDate

```java
public static Map<String,String> getAllDate()
```

全区分の業務日付を取得する。

**戻り値:**
区分をキー、対応する業務日付(yyyyMMdd形式)を値としたMap

---

### getProvider

```java
private static BusinessDateProvider getProvider()
```

業務日付取得コンポーネントを取得する。

**戻り値:**
業務日付取得コンポーネント

---
