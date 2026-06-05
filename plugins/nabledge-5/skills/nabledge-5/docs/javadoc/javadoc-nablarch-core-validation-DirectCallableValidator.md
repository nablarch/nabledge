# interface DirectCallableValidator

**パッケージ:** nablarch.core.validation

**継承階層:**
```
java.lang.Object
  └─ Validator
      └─ nablarch.core.validation.DirectCallableValidator
```

---

```java
public interface DirectCallableValidator
extends Validator
```

{@link Validator} をメソッド内の直接呼び出しに対応させる場合に実装する
インターフェース。

---

## メソッドの詳細

### validate

```java
boolean validate(ValidationContext<T> context, String propertyName, Object propertyDisplayName, Map<String,Object> params, Object value)
```

バリデーションを実行する。<br/>
対応するチェックの結果がNGであった場合、ValidationContextにエラーメッセージを追加し、falseを返す。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - バリデーションコンテキスト
- `propertyName` - プロパティ名
- `propertyDisplayName` - プロパティの表示名オブジェクト
- `params` - バリデーション処理に対するパラメータを格納したMap (アノテーションの属性と同内容)
- `value` - バリデーション対象の値

**戻り値:**
バリデーションに通った場合true

---
