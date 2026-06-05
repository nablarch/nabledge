# interface FormCreator

**パッケージ:** nablarch.core.validation

---

```java
public interface FormCreator
```

フォームを生成するインタフェース。

**作成者:** Koichi Asano  

---

## メソッドの詳細

### create

```java
T create(Class<T> targetClass, Map<String,Object> propertyValues, FormValidationDefinition formValidationDefinition)
```

フォームを作成する。

**パラメータ:**
- `<T>` - 作成するフォームの型
- `targetClass` - フォームのクラス
- `propertyValues` - フォームのプロパティにセットする値のマップ
- `formValidationDefinition` - FormValidationDefinition

**戻り値:**
生成し、プロパティがセットされたフォーム

---
