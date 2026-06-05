# class SessionEntry

**パッケージ:** nablarch.common.web.session

**実装されたインタフェース:**
- Map<String,Object>

---

```java
public class SessionEntry
implements Map<String,Object>
```

セッションに登録するオブジェクト。

JSPなどから値オブジェクトのプロパティを参照するために、Mapのインタフェースを実装している。
Mapインターフェースで操作する場合は、unmodifiableなMapとして振る舞う。
また、getter実行時に例外が発生する場合は、空のMapとして振る舞う。

**作成者:** kawasima  
**作成者:** tajima  

---

## フィールドの詳細

### key

```java
private final String key
```

セッションへの登録キー

---

### value

```java
private final Object value
```

セッションに登録した値

---

### storage

```java
private final SessionStore storage
```

このエントリーを記録する際に使用する{@link SessionStore}

---

### valueObjectMap

```java
private Map<String,Object> valueObjectMap
```

エントリーのJavaBeansプロパティのキー/値を格納するMap

---

## コンストラクタの詳細

### SessionEntry

```java
public SessionEntry(String key, Object value, SessionStore storage)
```

コンストラクタ。

**パラメータ:**
- `key` - セッションキー
- `value` - セッション値
- `storage` - セッションストレージ

---

## メソッドの詳細

### getKey

```java
public String getKey()
```

セッションへの登録キーを取得する。

**戻り値:**
セッションキー

---

### getValue

```java
public Object getValue()
```

セッションに登録された値を取得する。

**戻り値:**
セッション値

---

### getStorage

```java
public SessionStore getStorage()
```

このエントリーを記録する際に使用する{@link SessionStore}を使用する。

**戻り値:**
セッションストレージ

---

### introspectValue

```java
private void introspectValue()
```

プロパティからメソッドを読み込み、実施、値を取得する。

---

### size

```java
public int size()
```

---

### isEmpty

```java
public boolean isEmpty()
```

---

### containsKey

```java
public boolean containsKey(Object key)
```

---

### containsValue

```java
public boolean containsValue(Object value)
```

---

### get

```java
public Object get(Object key)
```

---

### put

```java
public Object put(String key, Object value)
```

---

### remove

```java
public Object remove(Object key)
```

---

### putAll

```java
public void putAll(Map<? extends String,?> m)
```

---

### clear

```java
public void clear()
```

---

### keySet

```java
public Set<String> keySet()
```

---

### values

```java
public Collection<Object> values()
```

---

### entrySet

```java
public Set<Entry<String,Object>> entrySet()
```

---
