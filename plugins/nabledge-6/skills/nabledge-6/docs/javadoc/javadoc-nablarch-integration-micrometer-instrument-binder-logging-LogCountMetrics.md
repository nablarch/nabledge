# class LogCountMetrics

**パッケージ:** nablarch.integration.micrometer.instrument.binder.logging

**実装されたインタフェース:**
- MeterBinder
- Closeable

---

```java
public class LogCountMetrics
implements MeterBinder, Closeable
```

ログレベルごとのログ出力回数をメトリクスとして収集する{@link MeterBinder}。
<p>
メトリクス名は{@code log.count}になる。<br>
また、メトリクスのタグには以下の値が設定される。
<ul>
  <li>{@code level}: ログレベル</li>
  <li>{@code logger}: 実行時ロガー名({@code LoggerManager.get(String)} の引数で渡した名前)</li>
</ul>
</p>
<p>
デフォルトでは{@code WARN}以上のログのみを集計する。<br>
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### DEFAULT_METRICS_NAME

```java
static final String DEFAULT_METRICS_NAME
```

デフォルトのメトリクスの名前。

---

### DEFAULT_METRICS_DESCRIPTION

```java
static final String DEFAULT_METRICS_DESCRIPTION
```

デフォルトのメトリクスの説明。

---

### DEFAULT_LOG_LEVEL

```java
private static final LogLevel DEFAULT_LOG_LEVEL
```

デフォルトのログレベル。

---

### TAG_NAME_LEVEL

```java
static final String TAG_NAME_LEVEL
```

ログレベルのタグ名。

---

### TAG_NAME_RUNTIME_LOGGER

```java
static final String TAG_NAME_RUNTIME_LOGGER
```

実行時ロガー名のタグ名。

---

### thresholdOfLogLevel

```java
private final LogLevel thresholdOfLogLevel
```

収集対象となるログレベルのしきい値。

---

### metricsMetaData

```java
private final MetricsMetaData metricsMetaData
```

メトリクスのメタ情報。

---

### logListener

```java
private LogListener logListener
```

{@link LogPublisher} に設定する {@link LogListener} のキャッシュ。
<p>
{@link #close()} のときに {@link LogPublisher#removeListener(LogListener)} で削除できるようにするため、
フィールドで保持している。
</p>

---

## コンストラクタの詳細

### LogCountMetrics

```java
public LogCountMetrics()
```

デフォルトコンストラクタ。
<p>
ログレベルは{@link LogLevel#WARN}になる。
</p>

---

### LogCountMetrics

```java
public LogCountMetrics(LogLevel thresholdOfLogLevel)
```

収集するログレベルのしきい値を指定するコンストラクタ。
<p>
指定されたログレベル以上のログ出力が計測の対象となる。
</p>

**パラメータ:**
- `thresholdOfLogLevel` - ログレベルのしきい値

---

### LogCountMetrics

```java
public LogCountMetrics(MetricsMetaData metricsMetaData)
```

メトリクスの設定情報を指定するコンストラクタ。

**パラメータ:**
- `metricsMetaData` - メトリクスの設定情報

---

### LogCountMetrics

```java
public LogCountMetrics(MetricsMetaData metricsMetaData, LogLevel thresholdOfLogLevel)
```

メトリクスの設定情報と、収集するログレベルのしきい値を指定するコンストラクタ。
<p>
指定されたログレベル以上のログ出力が計測の対象となる。
</p>

**パラメータ:**
- `metricsMetaData` - メトリクスの設定情報
- `thresholdOfLogLevel` - ログレベルのしきい値

---

## メソッドの詳細

### bindTo

```java
public void bindTo(MeterRegistry registry)
```

---

### close

```java
public void close()
```

---
