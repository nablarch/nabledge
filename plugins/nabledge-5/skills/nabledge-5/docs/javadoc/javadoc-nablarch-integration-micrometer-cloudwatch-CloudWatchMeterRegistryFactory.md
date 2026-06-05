# class CloudWatchMeterRegistryFactory

**パッケージ:** nablarch.integration.micrometer.cloudwatch

**継承階層:**
```
java.lang.Object
  └─ MeterRegistryFactory<CloudWatchMeterRegistry>
      └─ nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory
```

---

```java
public class CloudWatchMeterRegistryFactory
extends MeterRegistryFactory<CloudWatchMeterRegistry>
```

{@link CloudWatchMeterRegistry}のファクトリ。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### cloudWatchAsyncClientProvider

```java
private CloudWatchAsyncClientProvider cloudWatchAsyncClientProvider
```

{@link CloudWatchAsyncClientProvider}。

---

## メソッドの詳細

### createObject

```java
public CloudWatchMeterRegistry createObject()
```

---

### createMeterRegistry

```java
protected CloudWatchMeterRegistry createMeterRegistry(MicrometerConfiguration micrometerConfiguration)
```

---

### setCloudWatchAsyncClientProvider

```java
public void setCloudWatchAsyncClientProvider(CloudWatchAsyncClientProvider cloudWatchAsyncClientProvider)
```

{@link CloudWatchAsyncClientProvider}を設定する。

**パラメータ:**
- `cloudWatchAsyncClientProvider` - {@link CloudWatchAsyncClientProvider}

---
