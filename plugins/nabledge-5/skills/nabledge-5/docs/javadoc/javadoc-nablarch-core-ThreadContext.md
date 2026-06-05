# class ThreadContext

**パッケージ:** nablarch.core

---

```java
public final class ThreadContext
```

スレッド内で共有すべきオブジェクトを保持するクラス。
<p/>
本クラスで保持する値は、子スレッドが起動された場合、
暗黙的に全ての情報を子スレッドに引き継ぐ仕様となっている。
このため、子スレッドでは個別に値を設定することなく、親スレッドで設定した値を使用することが出来る。
また、子スレッドで個別に値を変更することも出来るが、ThreadLocalに格納したオブジェクトは各スレッドで共有され、
別スレッドの動作に影響を与える危険があるので、イミュータブルな値とスレッドセーフな値のみを格納すること。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### LANG_KEY

```java
public static final String LANG_KEY
```

言語のキー。

---

### TIME_ZONE_KEY

```java
public static final String TIME_ZONE_KEY
```

タイムゾーンのキー。

---

### USER_ID_KEY

```java
public static final String USER_ID_KEY
```

ユーザIDのキー。

---

### REQUEST_ID_KEY

```java
public static final String REQUEST_ID_KEY
```

リクエストIDのキー。

---

### INTERNAL_REQUEST_ID_KEY

```java
public static final String INTERNAL_REQUEST_ID_KEY
```

内部リクエストIDのキー。

---

### EXECUTION_ID_KEY

```java
public static final String EXECUTION_ID_KEY
```

実行時IDのキー。

---

### CONCURRENT_NUMBER_KEY

```java
public static final String CONCURRENT_NUMBER_KEY
```

並行実行スレッド数のキー。

---

### genericObjects

```java
private static ThreadLocal<Map<String,Object>> genericObjects
```

スレッド内で共有するオブジェクトを保持するThreadLocal。

---

## コンストラクタの詳細

### ThreadContext

```java
private ThreadContext()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### getLanguage

```java
public static Locale getLanguage()
```

スレッドローカルから言語を取得する。

**戻り値:**
言語

---

### setLanguage

```java
public static void setLanguage(Locale locale)
```

スレッドローカルに言語を設定する。

**パラメータ:**
- `locale` - 言語

---

### getTimeZone

```java
public static TimeZone getTimeZone()
```

スレッドローカルからタイムゾーンを取得する。

**戻り値:**
タイムゾーン

---

### setTimeZone

```java
public static void setTimeZone(TimeZone timeZone)
```

スレッドローカルにタイムゾーンを設定する。

**パラメータ:**
- `timeZone` - タイムゾーン

---

### getUserId

```java
public static String getUserId()
```

スレッドローカルからユーザIDを取得する。

**戻り値:**
ユーザID

---

### setUserId

```java
public static void setUserId(String userId)
```

スレッドローカルにユーザIDを設定する。

**パラメータ:**
- `userId` - ユーザID

---

### getRequestId

```java
public static String getRequestId()
```

スレッドローカルからリクエストIDを取得する。

**戻り値:**
リクエストID

---

### setRequestId

```java
public static void setRequestId(String requestId)
```

スレッドローカルにリクエストIDを設定する。

**パラメータ:**
- `requestId` - リクエストID

---

### getInternalRequestId

```java
public static String getInternalRequestId()
```

スレッドローカルから内部リクエストIDを取得する。

**戻り値:**
内部リクエストID

---

### setInternalRequestId

```java
public static void setInternalRequestId(String requestId)
```

スレッドローカルに内部リクエストIDを設定する。

**パラメータ:**
- `requestId` - 内部リクエストID

---

### getExecutionId

```java
public static String getExecutionId()
```

スレッドローカルから実行時IDを取得する。

**戻り値:**
実行時ID

---

### setExecutionId

```java
public static void setExecutionId(String executionId)
```

スレッドローカルに実行時IDを設定する。

**パラメータ:**
- `executionId` - 実行時ID

---

### setObject

```java
public static void setObject(String key, Object object)
```

スレッドコンテキストにオブジェクトを設定する。

**パラメータ:**
- `key` - オブジェクトのキー
- `object` - 設定するオブジェクト

---

### getObject

```java
public static Object getObject(String key)
```

スレッドコンテキストからオブジェクトを取得する。

**パラメータ:**
- `key` - オブジェクトのキー

**戻り値:**
取得したオブジェクト

---

### clear

```java
public static void clear()
```

スレッドコンテキストの内容をクリアする。

---

### getConcurrentNumber

```java
public static int getConcurrentNumber()
```

スレッドコンテキストから並行実行スレッド数を取得する。

**戻り値:**
並行実行スレッド数

---

### setConcurrentNumber

```java
public static void setConcurrentNumber(int value)
```

スレッドコンテキストに並行実行スレッド数を設定する。

**パラメータ:**
- `value` - 並行実行スレッド数

---
