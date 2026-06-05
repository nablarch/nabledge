# class DefaultMeterBinderListProvider

**パッケージ:** nablarch.integration.micrometer

**実装されたインタフェース:**
- MeterBinderListProvider
- Disposable

---

```java
public class DefaultMeterBinderListProvider
implements MeterBinderListProvider, Disposable
```

デフォルトの{@link MeterBinder}リストを提供するクラス。
<p>
{@link MeterBinder}の中には{@link AutoCloseable}を実装したものがある（例：{@link JvmGcMetrics}）。<br>
このクラスは{@link Disposable}を実装しており、作成した{@link MeterBinder}の中に
{@link AutoCloseable}を実装したものがある場合は、{@code close()}を呼ぶようになっている。
</p>
<p>
{@link AutoCloseable}な{@link MeterBinder}を含むリストを返す独自の{@link MeterBinderListProvider}が必要な場合は、
このクラスを継承して{@link #createMeterBinderList()}をオーバーライドして作成することで
{@code close()}の実装を省略できる。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー。

---

### meterBinderList

```java
private final List<MeterBinder> meterBinderList
```

供給する {@link MeterBinder} のリスト。

---

## コンストラクタの詳細

### DefaultMeterBinderListProvider

```java
public DefaultMeterBinderListProvider()
```

コンストラクタ。

---

## メソッドの詳細

### createMeterBinderList

```java
protected List<MeterBinder> createMeterBinderList()
```

{@link #provide()}で返す{@link MeterBinder}のリストを生成する。

**戻り値:**
{@link #provide()}で返す{@link MeterBinder}のリスト

---

### provide

```java
public List<MeterBinder> provide()
```

---

### dispose

```java
public void dispose()
```

---
