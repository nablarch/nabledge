# class SystemTimeUtil

**パッケージ:** nablarch.core.date

---

```java
public final class SystemTimeUtil
```

システム日付を取得するユーティリティ。
<p/>
日時、及び日付の取得処理は{@link SystemTimeProvider}によって提供される。
{@link SystemTimeProvider}の実装は、{@link SystemRepository}からコンポーネント名 systemTimeProvider で取得される。

**関連項目:** SystemTimeProvider  
**作成者:** Miki Habu  

---

## フィールドの詳細

### TIME_PROVIDER

```java
private static final String TIME_PROVIDER
```

システム日時取得コンポーネント名。

---

### DATE_FORMAT

```java
private static final String DATE_FORMAT
```

日付フォーマット

---

### SHORT_FORMAT

```java
private static final String SHORT_FORMAT
```

日時フォーマット(秒まで)

---

### LONG_FORMAT

```java
private static final String LONG_FORMAT
```

日時フォーマット(ミリ秒まで)

---

## コンストラクタの詳細

### SystemTimeUtil

```java
private SystemTimeUtil()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### getDate

```java
public static Date getDate()
```

システム日時を取得する。

**戻り値:**
システム日時

---

### getTimestamp

```java
public static Timestamp getTimestamp()
```

システム日時を取得する。

**戻り値:**
システム日時

---

### getDateString

```java
public static String getDateString()
```

システム日付を yyyyMMdd 形式の文字列で取得する。

**戻り値:**
システム日付

---

### getDateTimeString

```java
public static String getDateTimeString()
```

システム日時を yyyyMMddHHmmss 形式の文字列で取得する。

**戻り値:**
システム日時

---

### getDateTimeMillisString

```java
public static String getDateTimeMillisString()
```

システム日時を yyyyMMddHHmmssSSS 形式の文字列で取得する。

**戻り値:**
システム日時

---

### getProvider

```java
private static SystemTimeProvider getProvider()
```

システム日時取得コンポーネントを取得する。

**戻り値:**
システム日時取得コンポーネント

---
