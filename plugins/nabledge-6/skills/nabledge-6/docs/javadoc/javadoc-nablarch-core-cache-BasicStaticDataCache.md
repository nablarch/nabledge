# class BasicStaticDataCache

**パッケージ:** nablarch.core.cache

**実装されたインタフェース:**
- StaticDataCache<T>
- Initializable

---

```java
public class BasicStaticDataCache
implements StaticDataCache<T>, Initializable
```

StaticDataCacheインタフェースの基本実装クラス。<br/>
静的データをHashMapに保持する。

**作成者:** Koichi Asano  
**param:** 静的データの型  

---

## フィールドの詳細

### loadOnStartup

```java
private boolean loadOnStartup
```

初期化時ロード要否。

---

### loader

```java
private StaticDataLoader<T> loader
```

静的データのローダ。

---

### cache

```java
private Map<Object,T> cache
```

静的データのキャッシュ。

---

### indexes

```java
private Map<String,Map<Object,List<T>>> indexes
```

静的データのインデックス。

---

## メソッドの詳細

### setLoader

```java
public void setLoader(StaticDataLoader<T> loader)
```

静的データのローダを設定する。

**パラメータ:**
- `loader` - 静的データのローダ

---

### setLoadOnStartup

```java
public void setLoadOnStartup(boolean loadOnStartup)
```

初期化時ロード要否を設定する。

**パラメータ:**
- `loadOnStartup` - 初期化時ロード要否

---

### initialize

```java
public void initialize()
```

{@inheritDoc}

---

### refresh

```java
public void refresh()
```

{@inheritDoc}<br/>

一括ロードを実行する際は、データを全てロードしてからキャッシュデータの上書きを
行うことで、切り替えによるデータ取得をブロッキングする時間を最小化している。

---

### getValue

```java
public T getValue(Object id)
```

{@inheritDoc}

---

### loadValue

```java
private synchronized T loadValue(Object id)
```

静的データのローダからIDに紐付くデータをロードする。

**パラメータ:**
- `id` - ロードするデータのID

**戻り値:**
ロードしたデータ

---

### getValues

```java
public List<T> getValues(String indexName, Object key)
```

{@inheritDoc}

---

### loadIndexValues

```java
private synchronized List<T> loadIndexValues(String indexName, Object key, Map<Object,List<T>> index)
```

インデックスに紐付くデータのリストをロードする。

**パラメータ:**
- `indexName` - インデックス名
- `key` - キー
- `index` - インデックス

**戻り値:**
ロードしたデータのリスト

---

### addIndex

```java
private Map<Object,List<T>> addIndex(String indexName)
```

インデックスを追加する。

**パラメータ:**
- `indexName` - インデックス名

**戻り値:**
追加したインデックスのMap

---
