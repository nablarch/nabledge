# class BatchProcessedRecordCountMetricsLogger

**パッケージ:** nablarch.integration.micrometer.instrument.batch

**実装されたインタフェース:**
- CommitLogger

---

```java
public class BatchProcessedRecordCountMetricsLogger
implements CommitLogger
```

バッチの処理件数をメトリクスとして収集する{@link CommitLogger}の実装クラス。
<p>
メトリクスは、{@code "batch.processed.record.count"}という名前で作成される。<br>
また、以下のタグが設定される。
<ul>
  <li>{@code class} : バッチのアクションクラス名</li>
</ul>
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

### meterRegistry

```java
private MeterRegistry meterRegistry
```

使用する {@link MeterRegistry}。

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

## メソッドの詳細

### increment

```java
public void increment(long count)
```

---

### initialize

```java
public void initialize()
```

---

### terminate

```java
public void terminate()
```

---

### setMetricsName

```java
public void setMetricsName(String metricsName)
```

メトリクス名を設定する。

**パラメータ:**
- `metricsName` - メトリクス名

---

### setMetricsDescription

```java
public void setMetricsDescription(String metricsDescription)
```

メトリクスの説明を設定する。

**パラメータ:**
- `metricsDescription` - メトリクスの説明

---

### setMeterRegistry

```java
public void setMeterRegistry(MeterRegistry meterRegistry)
```

{@link MeterRegistry}を設定する。

**パラメータ:**
- `meterRegistry` - {@link MeterRegistry}

---
