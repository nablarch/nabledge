# class InMemoryResultSetCache

**パッケージ:** nablarch.core.db.cache

**継承階層:**
```
java.lang.Object
  └─ InMemoryExpirableCache<ResultSetCacheKey,SqlResultSet>
      └─ nablarch.core.db.cache.InMemoryResultSetCache
```

**実装されたインタフェース:**
- ResultSetCache

---

```java
public class InMemoryResultSetCache
extends InMemoryExpirableCache<ResultSetCacheKey,SqlResultSet>
implements ResultSetCache
```

メモリ上にキャッシュを保持する結果セットキャッシュ実装クラス。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### listener

```java
private final ResultSetCacheLoggingListener listener
```

ログ出力を行うリスナー

---

## コンストラクタの詳細

### InMemoryResultSetCache

```java
public InMemoryResultSetCache()
```

デフォルトコンストラクタ。

---

## メソッドの詳細

### createCacheContainer

```java
protected Map<ResultSetCacheKey,Expirable<SqlResultSet>> createCacheContainer(int max)
```

{@inheritDoc}

---

### isLoggerEnabled

```java
boolean isLoggerEnabled()
```

ログ出力可能であるか判定する。

**戻り値:**
ログ出力可能である場合、真

---
