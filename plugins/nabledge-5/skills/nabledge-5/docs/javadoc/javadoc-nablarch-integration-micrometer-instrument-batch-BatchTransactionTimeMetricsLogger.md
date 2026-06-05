# class BatchTransactionTimeMetricsLogger

**パッケージ:** nablarch.integration.micrometer.instrument.batch

**実装されたインタフェース:**
- CommitLogger

---

```java
public class BatchTransactionTimeMetricsLogger
implements CommitLogger
```

バッチのトランザクションごとの処理時間をメトリクスとして計測するロガー。
<p>
メトリクスは、{@code "batch.transaction.time"}という名前で作成される。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### THREAD_CONTEXT_KEY_TIMER_SAMPLE

```java
private static final String THREAD_CONTEXT_KEY_TIMER_SAMPLE
```

{@link Timer} を {@link ThreadContext} に保存するときに使用するキー。

---

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

### initialize

```java
public void initialize()
```

---

### increment

```java
public void increment(long count)
```

---

### beginTimer

```java
private void beginTimer()
```

{@link Timer} を起動し、 {@link ThreadContext} に {@link Timer} を保存する。

---

### terminate

```java
public void terminate()
```

---

### setMeterRegistry

```java
public void setMeterRegistry(MeterRegistry meterRegistry)
```

{@link MeterRegistry}を設定する。

**パラメータ:**
- `meterRegistry` - {@link MeterRegistry}

---

### setMetricsName

```java
public void setMetricsName(String metricsName)
```

メトリクスの名前を設定する。

**パラメータ:**
- `metricsName` - メトリクスの名前

---

### setMetricsDescription

```java
public void setMetricsDescription(String metricsDescription)
```

メトリクスの説明を設定する。

**パラメータ:**
- `metricsDescription` - メトリクスの説明

---
