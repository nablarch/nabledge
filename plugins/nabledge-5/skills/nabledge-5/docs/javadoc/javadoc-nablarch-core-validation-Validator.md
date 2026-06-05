# interface Validator

**パッケージ:** nablarch.core.validation

---

```java
public interface Validator
```

値のバリデーションを行うクラスが実装すべきメソッドを定義したインタフェース。

**作成者:** Koichi Asano  

---

## メソッドの詳細

### getAnnotationClass

```java
Class<? extends Annotation> getAnnotationClass()
```

対応するアノテーションのクラスを取得する。

**戻り値:**
対応するアノテーションのクラス

---

### validate

```java
boolean validate(ValidationContext<T> context, String propertyName, Object propertyDisplayName, Annotation annotation, Object value)
```

バリデーションを実行する。<br/>
対応するチェックの結果がNGであった場合、ValidationContextにエラーメッセージを追加し、falseを返す。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - バリデーションコンテキスト
- `propertyName` - プロパティ名
- `propertyDisplayName` - プロパティの表示名オブジェクト
- `annotation` - アノテーション
- `value` - バリデーション対象の値

**戻り値:**
バリデーションに通った場合true

---
