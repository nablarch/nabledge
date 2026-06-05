# interface Convertor

**パッケージ:** nablarch.core.validation

---

```java
public interface Convertor
```

入力値から対応するプロパティの型に変換するインタフェース。

**作成者:** Koichi Asano  

---

## メソッドの詳細

### getTargetClass

```java
Class<?> getTargetClass()
```

変換対象のクラスを取得する。

**戻り値:**
変換対象のクラス

---

### isConvertible

```java
boolean isConvertible(ValidationContext<T> context, String propertyName, Object propertyDisplayName, Object value, Annotation format)
```

変換可否のプレチェックを行う。<br/>
変換できない文字列であった場合、エラーメッセージをValidationContextに追加し、falseを返却する。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyName` - プロパティ名
- `propertyDisplayName` - プロパティの表示名オブジェクト
- `value` - 変換可否のプレチェックを行う値
- `format` - フォーマットを指定するアノテーション（指定がない場合null)

**戻り値:**
変換できる場合true

---

### convert

```java
Object convert(ValidationContext<T> context, String propertyName, Object value, Annotation format)
```

変換を行う。<br/>
変換に失敗した場合、ValidationContextにエラー内容を設定する。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyName` - プロパティ名
- `value` - 変換する値(データ型は様々な形式がありえる。)
- `format` - フォーマットを指定するアノテーション（指定がない場合null)

**戻り値:**
変換結果のオブジェクト

---
