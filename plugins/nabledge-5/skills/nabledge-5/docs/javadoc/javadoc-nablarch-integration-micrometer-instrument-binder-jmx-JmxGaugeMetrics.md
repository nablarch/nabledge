# class JmxGaugeMetrics

**パッケージ:** nablarch.integration.micrometer.instrument.binder.jmx

**実装されたインタフェース:**
- MeterBinder

---

```java
public class JmxGaugeMetrics
implements MeterBinder
```

指定したMBeanから定期的に値を取得し{@link Gauge}として記録する{@link MeterBinder}の実装クラス。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### metricsMetaData

```java
private final MetricsMetaData metricsMetaData
```

メトリクスのメタ情報。

---

### condition

```java
private final MBeanAttributeCondition condition
```

対象のMBeanを特定するための条件。

---

## コンストラクタの詳細

### JmxGaugeMetrics

```java
public JmxGaugeMetrics(MetricsMetaData metricsMetaData, MBeanAttributeCondition condition)
```

コンストラクタ。

**パラメータ:**
- `metricsMetaData` - メトリクスのメタ情報
- `condition` - 対象のMBeanを特定するための条件

---

## メソッドの詳細

### bindTo

```java
public void bindTo(MeterRegistry registry)
```

---

### obtainGaugeValue

```java
private double obtainGaugeValue()
```

{@link Gauge} に設定する値をMBeanから取得する。
<p>
MBeanが取得できない場合、または取得した値が{@link Number}でない場合は {@code NaN} を返す。
</p>

**戻り値:**
MBeanから取得した値

---
