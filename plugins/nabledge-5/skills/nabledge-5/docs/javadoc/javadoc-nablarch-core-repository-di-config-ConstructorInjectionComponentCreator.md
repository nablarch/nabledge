# class ConstructorInjectionComponentCreator

**パッケージ:** nablarch.core.repository.di.config

**継承階層:**
```
java.lang.Object
  └─ BeanComponentCreator
      └─ nablarch.core.repository.di.config.ConstructorInjectionComponentCreator
```

---

```java
public class ConstructorInjectionComponentCreator
extends BeanComponentCreator
```

コンストラクタインジェクションできるよう拡張した{@link BeanComponentCreator}。

---

## メソッドの詳細

### createComponent

```java
public Object createComponent(DiContainer container, ComponentDefinition def)
```

---

### createComponentWithConstructorInjection

```java
private Object createComponentWithConstructorInjection(DiContainer container, Constructor<?> constructor)
```

コンポーネントの生成とコンストラクタインジェクションを行う。

**パラメータ:**
- `container` - DIコンテナ
- `constructor` - コンストラクタ

**戻り値:**
インジェクション済のコンポーネント

---

### newContainerProcessException

```java
private ContainerProcessException newContainerProcessException(Constructor<?> constructor, Exception cause)
```

---

### getComponent

```java
private Object getComponent(DiContainer container, Class<?> type, Annotation[] annotations)
```

コンストラクタの引数にインジェクトするコンポーネントを取得する。
{@link ConfigValue}、{@link ComponentRef}が付与された引数の場合名前でコンポーネントを取得
それ以外の引数は型でコンポーネントを取得する。

**パラメータ:**
- `container` - DIコンテナ
- `type` - コンストラクタ引数の型
- `annotations` - コンストラクタ引数に付与されたアノテーション

**戻り値:**
インジェクトするコンポーネント

---

### getConfigValueComponent

```java
private Object getConfigValueComponent(DiContainer container, Class<?> type, ConfigValue annotation)
```

{@link ConfigValue}の情報をもとに設定値を取得する。

**パラメータ:**
- `container` - DIコンテナ
- `type` - コンストラクタ引数の型
- `annotation` - アノテーション

**戻り値:**
{@link ConfigValue}に指定した変数を解決した設定値

---

### getReferenceComponent

```java
private Object getReferenceComponent(DiContainer container, Class<?> type, ComponentRef annotation)
```

{@link ComponentRef}の情報をもとにコンポーネントを取得する。

**パラメータ:**
- `container` - DIコンテナ
- `type` - コンストラクタ引数の型
- `annotation` - アノテーション

**戻り値:**
{@link ComponentRef}の名前で取得したコンポーネント

---
