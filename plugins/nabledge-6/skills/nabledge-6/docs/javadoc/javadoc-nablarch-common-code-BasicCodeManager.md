# class BasicCodeManager

**パッケージ:** nablarch.common.code

**実装されたインタフェース:**
- CodeManager

---

```java
public class BasicCodeManager
implements CodeManager
```

CodeManagerの基本実装クラス。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### codeDefinitionCache

```java
private StaticDataCache<Code> codeDefinitionCache
```

Codeのキャッシュ。

---

### DEFAULT_LOCALE

```java
private static final Locale DEFAULT_LOCALE
```

デフォルトの言語

---

## メソッドの詳細

### setCodeDefinitionCache

```java
public void setCodeDefinitionCache(StaticDataCache<Code> codeDefinitionCache)
```

Codeのキャッシュをセットする。<br/>

Codeのキャッシュは、コード値をキーとしてCodeインタフェースを実装したクラスが取得できなければならない。

**パラメータ:**
- `codeDefinitionCache` - Codeのキャッシュ

---

### contains

```java
public boolean contains(String codeId, String value)
```

{@inheritDoc}

---

### contains

```java
public boolean contains(String codeId, String pattern, String value)
```

{@inheritDoc}

---

### getName

```java
public String getName(String codeId, String value)
```

{@inheritDoc}

---

### getName

```java
public String getName(String codeId, String value, Locale locale)
```

{@inheritDoc}

---

### getShortName

```java
public String getShortName(String codeId, String value)
```

{@inheritDoc}

---

### getShortName

```java
public String getShortName(String codeId, String value, Locale locale)
```

{@inheritDoc}

---

### getOptionalName

```java
public String getOptionalName(String codeId, String value, String optionColumnName)
```

{@inheritDoc}

---

### getOptionalName

```java
public String getOptionalName(String codeId, String value, String optionColumnName, Locale locale)
```

{@inheritDoc}

---

### getValues

```java
public List<String> getValues(String codeId)
```

{@inheritDoc}

---

### getValues

```java
public List<String> getValues(String codeId, String pattern)
```

{@inheritDoc}

---

### getValues

```java
public List<String> getValues(String codeId, Locale locale)
```

{@inheritDoc}

---

### getValues

```java
public List<String> getValues(String codeId, String pattern, Locale locale)
```

{@inheritDoc}

---

### getLanguage

```java
private static Locale getLanguage()
```

スレッドコンテキストから言語を取得する。

スレッドコンテキストに設定されていない場合は
{@link Locale#getDefault()}から取得した言語を返す。

**戻り値:**
言語

---
