# class GlobalMeterRegistryFactory

**パッケージ:** nablarch.integration.micrometer

**継承階層:**
```
java.lang.Object
  └─ MeterRegistryFactory<MeterRegistry>
      └─ nablarch.integration.micrometer.GlobalMeterRegistryFactory
```

---

```java
public class GlobalMeterRegistryFactory
extends MeterRegistryFactory<MeterRegistry>
```

Micrometerのグローバルレジストリ({@code io.micrometer.core.instrument.Metrics.globalRegistry})を
コンポーネントとして生成するファクトリクラス。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### createObject

```java
public MeterRegistry createObject()
```

---

### createMeterRegistry

```java
protected MeterRegistry createMeterRegistry(MicrometerConfiguration micrometerConfiguration)
```

---
