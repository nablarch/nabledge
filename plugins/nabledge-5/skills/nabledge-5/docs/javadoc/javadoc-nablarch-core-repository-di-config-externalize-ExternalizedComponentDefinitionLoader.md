# interface ExternalizedComponentDefinitionLoader

**パッケージ:** nablarch.core.repository.di.config.externalize

---

```java
public interface ExternalizedComponentDefinitionLoader
```

外部化されたコンポーネント定義をロードするインタフェース。
<p/>
外部化されたコンポーネント定義には、設定ファイル以外の例えばシステムプロパティや
OS環境変数などで指定された値などが該当する。

**作成者:** Tomoyuki Tanaka  

---

## メソッドの詳細

### load

```java
List<ComponentDefinition> load(DiContainer container, Map<String,ComponentHolder> loadedComponents)
```

外部化されたコンポーネントを読み込む。

**パラメータ:**
- `container` - DIコンテナ
- `loadedComponents` - 読み込み済みのコンポーネント（マップのキーはコンポーネントの名前）

**戻り値:**
読み込んだコンポーネント定義のリスト

---
