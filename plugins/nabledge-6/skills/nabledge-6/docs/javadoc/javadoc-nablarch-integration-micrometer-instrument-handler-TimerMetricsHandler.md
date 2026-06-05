# class TimerMetricsHandler

**パッケージ:** nablarch.integration.micrometer.instrument.handler

**実装されたインタフェース:**
- Handler<TData,TResult>

---

```java
public class TimerMetricsHandler
implements Handler<TData,TResult>
```

ハンドラキューに追加することで、後続処理の実行時間をメトリクスとして収集するハンドラクラス。

**param:** 処理対象データ型  
**param:** 処理結果データ型  
**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### meterRegistry

```java
private MeterRegistry meterRegistry
```

使用する{@link MeterRegistry}。

---

### handlerMetricsMetaDataBuilder

```java
private HandlerMetricsMetaDataBuilder<TData,TResult> handlerMetricsMetaDataBuilder
```

{@link HandlerMetricsMetaDataBuilder}。

---

### percentiles

```java
private double[] percentiles
```

収集対象のパーセンタイル。

---

### enablePercentileHistogram

```java
private boolean enablePercentileHistogram
```

ヒストグラムバケットの連携の有効・無効フラグ。

---

### serviceLevelObjectives

```java
private Duration[] serviceLevelObjectives
```

SLOに基づく追加のバケット。

---

### minimumExpectedValue

```java
private Long minimumExpectedValue
```

バケットの最小値。

---

### maximumExpectedValue

```java
private Long maximumExpectedValue
```

バケットの最大値。

---

## メソッドの詳細

### handle

```java
public TResult handle(TData param, ExecutionContext executionContext)
```

---

### setupPercentileOptions

```java
private void setupPercentileOptions(Timer.Builder builder)
```

パーセンタイルについての設定を行う。

**パラメータ:**
- `builder` - 設定対象の{@link io.micrometer.core.instrument.Timer.Builder}

---

### setMeterRegistry

```java
public void setMeterRegistry(MeterRegistry meterRegistry)
```

{@link MeterRegistry} を設定する。

**パラメータ:**
- `meterRegistry` - {@link MeterRegistry}

---

### setHandlerMetricsMetaDataBuilder

```java
public void setHandlerMetricsMetaDataBuilder(HandlerMetricsMetaDataBuilder<TData,TResult> handlerMetricsMetaDataBuilder)
```

{@link HandlerMetricsMetaDataBuilder} を設定する。

**パラメータ:**
- `handlerMetricsMetaDataBuilder` - {@link HandlerMetricsMetaDataBuilder}

---

### setPercentiles

```java
public void setPercentiles(List<String> percentiles)
```

このハンドラによって収集されるメトリクスに、指定されたパーセンタイルのメトリクスを追加する。
<p>
95パーセンタイルの情報を追加したい場合は、{@code 0.95}を設定する。
</p>
<p>
このセッターはコンポーネント定義ファイルからプロパティとして設定されることを想定している。<br>
システムリポジトリによるリストプロパティの設定は総称型に応じたキャストをサポートしていないため、
いったん文字列で受け取って内部で{@code double}にパースしている。
</p>
<p>
ここで渡した値は、{@code io.micrometer.core.instrument.Timer.Builder#publishPercentiles(double...)}の引数に渡される。
</p>

**パラメータ:**
- `percentiles` - 追加するパーセンタイルのリスト

---

### setEnablePercentileHistogram

```java
public void setEnablePercentileHistogram(boolean enablePercentileHistogram)
```

ヒストグラムバケットを生成するかどうかを設定する。
<p>
ここで渡した値は、{@code io.micrometer.core.instrument.Timer.Builder#publishPercentileHistogram(java.lang.Boolean)}の引数に渡される。
</p>

**パラメータ:**
- `enablePercentileHistogram` - ヒストグラムバケットを生成する場合は{@code true}

---

### setServiceLevelObjectives

```java
public void setServiceLevelObjectives(List<String> serviceLevelObjectives)
```

サービスレベル目標（ミリ秒）のリストを設定する。
<p>
このセッターはコンポーネント定義ファイルからプロパティとして設定されることを想定している。<br>
システムリポジトリによるリストプロパティの設定は総称型に応じたキャストをサポートしていないため、
いったん文字列で受け取って内部で{@code long}にパースしている。
</p>
<p>
ここで渡した値は、{@code io.micrometer.core.instrument.Timer.Builder#serviceLevelObjectives(java.time.Duration...)}の引数に渡される。
</p>

**パラメータ:**
- `serviceLevelObjectives` - サービスレベル目標のリスト

---

### setMinimumExpectedValue

```java
public void setMinimumExpectedValue(long minimumExpectedValue)
```

ヒストグラムバケットの下限（ミリ秒）を設定する。
<p>
ここで渡した値は、{@code io.micrometer.core.instrument.Timer.Builder#minimumExpectedValue(java.time.Duration)}の引数に渡される。
</p>

**パラメータ:**
- `minimumExpectedValue` - ヒストグラムバケットの下限

---

### setMaximumExpectedValue

```java
public void setMaximumExpectedValue(long maximumExpectedValue)
```

ヒストグラムバケットの上限（ミリ秒）を設定する。
<p>
ここで渡した値は、{@code io.micrometer.core.instrument.Timer.Builder#maximumExpectedValue(java.time.Duration)}の引数に渡される。
</p>

**パラメータ:**
- `maximumExpectedValue` - ヒストグラムバケットの上限

---
