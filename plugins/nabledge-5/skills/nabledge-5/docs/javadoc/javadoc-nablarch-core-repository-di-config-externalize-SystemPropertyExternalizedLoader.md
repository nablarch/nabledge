# class SystemPropertyExternalizedLoader

**パッケージ:** nablarch.core.repository.di.config.externalize

**実装されたインタフェース:**
- ExternalizedComponentDefinitionLoader

---

```java
public class SystemPropertyExternalizedLoader
implements ExternalizedComponentDefinitionLoader
```

システムプロパティをコンポーネント定義として読み込む{@link ExternalizedComponentDefinitionLoader}。
<p/>
このローダーは、システムプロパティで指定されている値をすべて{@link String}のコンポーネントとしてロードする。

**作成者:** Tomoyuki Tanaka  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

---

## メソッドの詳細

### load

```java
public List<ComponentDefinition> load(DiContainer container, Map<String,ComponentHolder> loadedComponents)
```

---
