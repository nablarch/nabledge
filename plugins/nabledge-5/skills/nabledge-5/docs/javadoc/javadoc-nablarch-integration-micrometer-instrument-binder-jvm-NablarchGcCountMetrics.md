# class NablarchGcCountMetrics

**パッケージ:** nablarch.integration.micrometer.instrument.binder.jvm

**実装されたインタフェース:**
- MeterBinder

---

```java
public class NablarchGcCountMetrics
implements MeterBinder
```

GCの発生回数をカウントする{@link MeterBinder}。
<p>
{@code jvm.gc.count} という名前のメトリクスが、メモリマネージャの数だけ登録される。<br>
各メトリクスには、メモリマネージャの名前が {@code memory.manager.name} タグで設定される。
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

### tags

```java
private final Iterable<Tag> tags
```

追加のタグ一覧。

---

### metricsName

```java
private final String metricsName
```

メトリクス名。

---

### metricsDescription

```java
private final String metricsDescription
```

メトリクスの説明。

---

## コンストラクタの詳細

### NablarchGcCountMetrics

```java
public NablarchGcCountMetrics()
```

コンストラクタ。

---

### NablarchGcCountMetrics

```java
public NablarchGcCountMetrics(String metricsName, String metricsDescription)
```

メトリクス名と説明を設定するコンストラクタ。

**パラメータ:**
- `metricsName` - メトリクス名
- `metricsDescription` - メトリクスの説明

---

### NablarchGcCountMetrics

```java
public NablarchGcCountMetrics(Iterable<Tag> tags)
```

追加のタグを指定するコンストラクタ。

**パラメータ:**
- `tags` - 追加で指定するタグ

---

### NablarchGcCountMetrics

```java
public NablarchGcCountMetrics(MetricsMetaData metricsMetaData)
```

メトリクス名と説明、追加のタグを{@link MetricsMetaData}で指定するコンストラクタ。

**パラメータ:**
- `metricsMetaData` - メトリクスの設定情報

---

### NablarchGcCountMetrics

```java
public NablarchGcCountMetrics(String metricsName, String metricsDescription, Iterable<Tag> tags)
```

メトリクス名と説明、追加のタグを指定するコンストラクタ。

**パラメータ:**
- `metricsName` - メトリクス名
- `metricsDescription` - メトリクスの説明
- `tags` - 追加で指定するタグ

---

## メソッドの詳細

### bindTo

```java
public void bindTo(MeterRegistry registry)
```

---
