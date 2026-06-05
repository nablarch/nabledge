# class SqlTimeMetricsDaoContextFactory

**パッケージ:** nablarch.integration.micrometer.instrument.dao

**継承階層:**
```
java.lang.Object
  └─ DaoContextFactory
      └─ nablarch.integration.micrometer.instrument.dao.SqlTimeMetricsDaoContextFactory
```

---

```java
public class SqlTimeMetricsDaoContextFactory
extends DaoContextFactory
```

委譲対象({@code delegate})の{@link DaoContextFactory}が生成する{@link DaoContext}をラップした
{@link SqlTimeMetricsDaoContext}を生成するファクトリクラス。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### delegate

```java
private DaoContextFactory delegate
```

移譲先の{@link DaoContextFactory}。

---

### meterRegistry

```java
private MeterRegistry meterRegistry
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

## メソッドの詳細

### create

```java
public DaoContext create()
```

---

### setDelegate

```java
public void setDelegate(DaoContextFactory delegate)
```

委譲対象の{@link DaoContextFactory}を設定する。

**パラメータ:**
- `delegate` - 委譲対象の{@link DaoContextFactory}

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

{@link SqlTimeMetricsDaoContext}に設定するメトリクス名を指定する。

**パラメータ:**
- `metricsName` - メトリクス名

---

### setMetricsDescription

```java
public void setMetricsDescription(String metricsDescription)
```

{@link SqlTimeMetricsDaoContext}に設定するメトリクスの説明を指定する。

**パラメータ:**
- `metricsDescription` - メトリクスの説明

---
