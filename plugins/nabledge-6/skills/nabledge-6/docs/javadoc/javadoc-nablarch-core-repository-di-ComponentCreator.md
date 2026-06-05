# interface ComponentCreator

**パッケージ:** nablarch.core.repository.di

---

```java
public interface ComponentCreator
```

コンポーネントを生成するインタフェース。

**作成者:** Koichi Asano  

---

## メソッドの詳細

### createComponent

```java
Object createComponent(DiContainer container, ComponentDefinition def)
```

コンポーネントを生成する。

**パラメータ:**
- `container` - コンテナ
- `def` - 生成するコンポーネントの定義

**戻り値:**
生成したコンポーネント

---
