# class PropertiesStringResourceLoader

**パッケージ:** nablarch.core.message

**実装されたインタフェース:**
- StaticDataLoader<StringResource>

---

```java
public class PropertiesStringResourceLoader
implements StaticDataLoader<StringResource>
```

文字列リソースをプロパティファイルから取得するクラス。

**作成者:** kawasima  
**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### messages

```java
private final Map<String,Map<String,String>> messages
```

プロパティファイルからロードしたメッセージ一覧

---

### directory

```java
private String directory
```

プロパティファイルが配置されているディレクトリ

---

### fileName

```java
private String fileName
```

プロパティファイル名

---

### defaultLocale

```java
private String defaultLocale
```

デフォルトのロケール

---

### locales

```java
private Set<String> locales
```

ロケール一覧

---

## メソッドの詳細

### getValue

```java
public StringResource getValue(Object key)
```

---

### loadAll

```java
public List<StringResource> loadAll()
```

---

### load

```java
private synchronized void load()
```

プロパティファイルからメッセージをロードする。

---

### load

```java
private void load(String locale, String path)
```

プロパティファイルからメッセージをロードする。

**パラメータ:**
- `locale` - ロケール
- `path` - プロパティファイルのパス

---

### getValues

```java
public List<StringResource> getValues(String indexName, Object key)
```

---

### getId

```java
public Object getId(StringResource value)
```

---

### generateIndexKey

```java
public Object generateIndexKey(String indexName, StringResource value)
```

---

### getIndexNames

```java
public List<String> getIndexNames()
```

---

### setDirectory

```java
public void setDirectory(String directory)
```

ディレクトリを設定する。

**パラメータ:**
- `directory` - ディレクトリ

---

### setFileName

```java
public void setFileName(String fileName)
```

プロパティファイル名を設定する。

**パラメータ:**
- `fileName` - プロパティファイル名

---

### setDefaultLocale

```java
public void setDefaultLocale(String defaultLocale)
```

デフォルトのロケールを設定する。

**パラメータ:**
- `defaultLocale` - デフォルトのロケール

---

### setLocales

```java
public void setLocales(List<String> locales)
```

ロケール一覧を設定する。

**パラメータ:**
- `locales` - ロケール一覧

---
