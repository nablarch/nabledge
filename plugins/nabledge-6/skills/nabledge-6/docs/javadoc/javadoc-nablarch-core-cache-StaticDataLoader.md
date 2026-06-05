# interface StaticDataLoader

**パッケージ:** nablarch.core.cache

---

```java
public interface StaticDataLoader
```

静的データをロードするインタフェース。
<p/>
RDBMSやXMLファイル等の媒体から静的データをロードするクラスは、このインタフェースを実装する。

**作成者:** Koichi Asano  
**param:** ロードするデータの型  

---

## メソッドの詳細

### getValue

```java
T getValue(Object id)
```

IDに紐付くデータをロードする。

**パラメータ:**
- `id` - データのID

**戻り値:**
IDに紐付くデータ

---

### getValues

```java
List<T> getValues(String indexName, Object key)
```

インデックスに紐付くデータをロードする。

**パラメータ:**
- `indexName` - インデックス名
- `key` - 静的データのキー

**戻り値:**
インデックス名、キーに対応するデータのリスト

---

### loadAll

```java
List<T> loadAll()
```

全てのデータをロードする。

**戻り値:**
全てのデータ

---

### getIndexNames

```java
List<String> getIndexNames()
```

全てのインデックス名を取得する。

**戻り値:**
全てのインデックス名

---

### getId

```java
Object getId(T value)
```

静的データからIDを取得する。

**パラメータ:**
- `value` - 静的データ

**戻り値:**
生成したID

---

### generateIndexKey

```java
Object generateIndexKey(String indexName, T value)
```

静的データからインデックスのキーを生成する。

**パラメータ:**
- `indexName` - インデックス名
- `value` - 静的データ

**戻り値:**
生成したインデックスのキー

---
