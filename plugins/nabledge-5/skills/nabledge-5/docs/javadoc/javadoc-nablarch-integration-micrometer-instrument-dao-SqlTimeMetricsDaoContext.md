# class SqlTimeMetricsDaoContext

**パッケージ:** nablarch.integration.micrometer.instrument.dao

**実装されたインタフェース:**
- DaoContext

---

```java
public class SqlTimeMetricsDaoContext
implements DaoContext
```

SQLの処理実行時間をメトリクスとして計測する{@link DaoContext}のラッパークラス。
<p>
メトリクスは、{@code sql.process.time}という名前になる。
</p>
<p>
また、メトリクスには以下のタグが設定される。
<ul>
  <li>{@code sql.id}: SQLID(無い場合は{@code "None"})</li>
  <li>{@code entity}: エンティティクラスの名前({@link Class#getName()})。</li>
  <li>{@code method}: 実行された{@link DaoContext}のメソッドの単純名</li>
</ul>
</p>
<p>
引数で渡されたエンティティまたはエンティティのリストが、{@code null}または空のリストの場合は、
時間は計測されない（委譲先のメソッドの処理は実行される）。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### DEFAULT_METRICS_NAME

```java
static final String DEFAULT_METRICS_NAME
```

デフォルトのメトリクス名。

---

### DEFAULT_METRICS_DESCRIPTION

```java
static final String DEFAULT_METRICS_DESCRIPTION
```

デフォルトのメトリクスの説明。

---

### TAG_NAME_SQL_ID

```java
static final String TAG_NAME_SQL_ID
```

SQLIDのタグ名。

---

### TAG_NAME_ENTITY_NAME

```java
static final String TAG_NAME_ENTITY_NAME
```

エンティティ名のタグ名。

---

### TAG_NAME_METHOD_NAME

```java
static final String TAG_NAME_METHOD_NAME
```

実行されたメソッド名のタグ名。

---

### TAG_VALUE_NO_SQL_ID

```java
static final String TAG_VALUE_NO_SQL_ID
```

SQLIDが無い場合に設定されるタグの値。

---

### delegate

```java
private final DaoContext delegate
```

移譲先の{@link DaoContext}。

---

### meterRegistry

```java
private final MeterRegistry meterRegistry
```

使用する{@link MeterRegistry}。

---

### metricsName

```java
private String metricsName
```

メトリクス名。

---

### metricsDescription

```java
private String metricsDescription
```

メトリクスの説明。

---

## コンストラクタの詳細

### SqlTimeMetricsDaoContext

```java
public SqlTimeMetricsDaoContext(DaoContext delegate, MeterRegistry meterRegistry)
```

委譲先の {@link DaoContext}と{@link MeterRegistry}を指定するコンストラクタ。

**パラメータ:**
- `delegate` - 委譲先の{@link DaoContext}
- `meterRegistry` - {@link MeterRegistry}

---

## メソッドの詳細

### findById

```java
public T findById(Class<T> entityClass, Object id)
```

---

### findByIdOrNull

```java
public T findByIdOrNull(Class<T> entityClass, Object id)
```

---

### findAll

```java
public EntityList<T> findAll(Class<T> entityClass)
```

---

### findAllBySqlFile

```java
public EntityList<T> findAllBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

---

### findAllBySqlFile

```java
public EntityList<T> findAllBySqlFile(Class<T> entityClass, String sqlId)
```

---

### findBySqlFile

```java
public T findBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

---

### findBySqlFileOrNull

```java
public T findBySqlFileOrNull(Class<T> entityClass, String sqlId, Object params)
```

---

### countBySqlFile

```java
public long countBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

---

### update

```java
public int update(T entity)
           throws OptimisticLockException
```

---

### batchUpdate

```java
public void batchUpdate(List<T> entities)
```

---

### insert

```java
public void insert(T entity)
```

---

### batchInsert

```java
public void batchInsert(List<T> entities)
```

---

### delete

```java
public int delete(T entity)
```

---

### batchDelete

```java
public void batchDelete(List<T> entities)
```

---

### recordEntityListUpdate

```java
private void recordEntityListUpdate(List<?> entities, String methodName, Runnable execution)
```

エンティティリストの更新系メソッドの時間を計測する。

**パラメータ:**
- `entities` - エンティティリスト
- `methodName` - 実行された{@link DaoContext}のメソッド名
- `execution` - 計測対象の更新処理

---

### recordEntityUpdate

```java
private T recordEntityUpdate(Object entity, String methodName, Supplier<T> execution)
```

エンティティの更新系メソッドの時間を計測する。

**パラメータ:**
- `entity` - エンティティ
- `methodName` - 実行された{@link DaoContext}のメソッド名
- `execution` - 計測対象の更新処理
- `<T>` - {@code execution} が返す値の型

**戻り値:**
{@code execution} が返した値

---

### recordTime

```java
private T recordTime(String sqlId, Class<?> entityClass, String methodName, Supplier<T> execution)
```

指定された処理の時間を計測する。

**パラメータ:**
- `sqlId` - SQIID
- `entityClass` - エンティティの{@link Class}オブジェクト
- `methodName` - 実行された{@link DaoContext}のメソッド名
- `execution` - 計測対象の処理
- `<T>` - {@code execution} が返す値の型

**戻り値:**
{@code execution} が返した値

---

### page

```java
public DaoContext page(long page)
```

---

### per

```java
public DaoContext per(long per)
```

---

### defer

```java
public DaoContext defer()
```

---

### setMetricsName

```java
public void setMetricsName(String metricsName)
```

メトリクスの名前を設定する。

**パラメータ:**
- `metricsName` - メトリクスの名前

---

### getMetricsName

```java
public String getMetricsName()
```

メトリクス名を取得する。

**戻り値:**
メトリクス名

---

### setMetricsDescription

```java
public void setMetricsDescription(String metricsDescription)
```

メトリクスの説明を設定する。

**パラメータ:**
- `metricsDescription` - メトリクスの説明

---

### getMetricsDescription

```java
public String getMetricsDescription()
```

メトリクスの説明を取得する。

**戻り値:**
メトリクスの説明

---

### getDelegate

```java
public DaoContext getDelegate()
```

委譲先の{@link DaoContext}を取得する。

**戻り値:**
委譲先の {@link DaoContext}

---

### getMeterRegistry

```java
public MeterRegistry getMeterRegistry()
```

{@link MeterRegistry}を取得する。

**戻り値:**
{@link MeterRegistry}

---
