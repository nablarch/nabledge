# class MeterRegistryFactory

**パッケージ:** nablarch.integration.micrometer

**実装されたインタフェース:**
- ComponentFactory<T>

---

```java
public abstract class MeterRegistryFactory
implements ComponentFactory<T>
```

{@link MeterRegistry}のコンポーネント生成に共通する処理をまとめた抽象クラス。

**param:** サブクラスで生成する具体的な{@link MeterRegistry}の型  
**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### prefix

```java
protected String prefix
```

設定値のプレフィックス。

---

### xmlConfigPath

```java
protected String xmlConfigPath
```

設定ファイルのパス。
<p>
未設定の場合に読み込まれるデフォルトのパスについては{@link MicrometerConfiguration}を参照。
</p>

---

### meterBinderListProvider

```java
protected MeterBinderListProvider meterBinderListProvider
```

生成した{@link MeterRegistry}に適用する{@link io.micrometer.core.instrument.binder.MeterBinder MeterBinder}リストのプロバイダ。

---

### tags

```java
protected Map<String,String> tags
```

すべてのメトリクスに共通で設定するタグ。

---

### applicationDisposer

```java
protected ApplicationDisposer applicationDisposer
```

廃棄処理を行うインタフェース。

---

## メソッドの詳細

### doCreateObject

```java
protected T doCreateObject()
```

{@link ComponentFactory#createObject()} の実処理を行うメソッド。
<p>
サブクラスは、本メソッドを使って {@code createObject()} を次のように実装する。
<pre><code>{@literal @}Override
public SimpleMeterRegistry createObject() {
    return doCreateObject();
}</code></pre>
</p>
<p>
これは、 {@code createObject()} の戻り値の型が総称型だった場合、
DIコンテナがコンポーネントの具象型を特定できないことに起因する。<br>
この問題は、上述のようにサブクラスで {@code createObject()} の戻り値の型を具象型として宣言することで回避できる。<br>
一方で、コンポーネントを作成するロジック自体はどの {@link MeterRegistry} でも共通なので、
コンポーネント作成処理を共通化するために、このメソッドが用意されている。
</p>

**戻り値:**
作成された {@link MeterRegistry} オブジェクト

---

### createMicrometerConfiguration

```java
private MicrometerConfiguration createMicrometerConfiguration()
```

{@link MicrometerConfiguration} を生成する。

**戻り値:**
生成された {@link MicrometerConfiguration}

---

### setupCommonTags

```java
private void setupCommonTags(MeterRegistry meterRegistry)
```

全てのメトリクスに共通して設定するタグをセットアップする。

**パラメータ:**
- `meterRegistry` - 設定対象の {@link MeterRegistry}

---

### createMeterRegistry

```java
protected abstract T createMeterRegistry(MicrometerConfiguration micrometerConfiguration)
```

{@link MeterRegistry}のインスタンスを生成する。

**パラメータ:**
- `micrometerConfiguration` - Micrometerの設定

**戻り値:**
生成した {@link MeterRegistry}のインスタンス

---

### setPrefix

```java
public void setPrefix(String prefix)
```

プレフィックスを設定する。

**パラメータ:**
- `prefix` - プレフィックス

---

### setXmlConfigPath

```java
public void setXmlConfigPath(String xmlConfigPath)
```

XML設定ファイルのパスを設定する。

**パラメータ:**
- `xmlConfigPath` - XML設定ファイルのパス

---

### setMeterBinderListProvider

```java
public void setMeterBinderListProvider(MeterBinderListProvider meterBinderListProvider)
```

{@link MeterBinderListProvider}を設定する。

**パラメータ:**
- `meterBinderListProvider` - {@link MeterBinderListProvider}

---

### setTags

```java
public void setTags(Map<String,String> tags)
```

すべてのメトリクスに共通で設定するタグを指定する。

**パラメータ:**
- `tags` - すべてのメトリクスに共通で設定するタグ

---

### setApplicationDisposer

```java
public void setApplicationDisposer(ApplicationDisposer applicationDisposer)
```

{@link ApplicationDisposer}を設定する。

**パラメータ:**
- `applicationDisposer` - {@link ApplicationDisposer}

---
