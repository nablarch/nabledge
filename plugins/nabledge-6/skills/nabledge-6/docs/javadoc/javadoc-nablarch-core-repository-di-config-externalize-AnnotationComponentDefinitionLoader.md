# class AnnotationComponentDefinitionLoader

**パッケージ:** nablarch.core.repository.di.config.externalize

**実装されたインタフェース:**
- ExternalizedComponentDefinitionLoader

---

```java
public abstract class AnnotationComponentDefinitionLoader
implements ExternalizedComponentDefinitionLoader
```

アノテーションが付与されたクラスをコンポーネントとして読み込む{@link ExternalizedComponentDefinitionLoader}。
<p/>
このローダーは{@link SystemRepositoryComponent}が付与されたクラスをコンポーネントとして読み込む。
読み込む対象となるパッケージは{@link #getBasePackage()}で取得する。
ローダーの使用時にサブクラスを作成し、オーバーライドすること。

---

## メソッドの詳細

### getBasePackage

```java
protected abstract String getBasePackage()
```

スキャン対象のパッケージを返す。

**戻り値:**
スキャン対象のパッケージ

---

### load

```java
public List<ComponentDefinition> load(DiContainer container, Map<String,ComponentHolder> loadedComponents)
```

---

### newComponentCreator

```java
protected ComponentCreator newComponentCreator()
```

---
