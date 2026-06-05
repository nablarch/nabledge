# class CompositeKeyConvertor

**パッケージ:** nablarch.common.web.compositekey

**実装されたインタフェース:**
- Convertor

---

```java
public class CompositeKeyConvertor
implements Convertor
```

値を{@link CompositeKey}に変換するクラス。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### conversionFailedMessageId

```java
private String conversionFailedMessageId
```

変換失敗時のデフォルトのエラーメッセージのメッセージID。

---

## メソッドの詳細

### getTargetClass

```java
public Class<?> getTargetClass()
```

{@inheritDoc}

---

### setConversionFailedMessageId

```java
public void setConversionFailedMessageId(String conversionFailedMessageId)
```

変換失敗時のデフォルトのエラーメッセージのメッセージIDを設定する。<br/>
デフォルトメッセージの例 : "{0}が正しくありません"

**パラメータ:**
- `conversionFailedMessageId` - 変換失敗時のデフォルトのエラーメッセージのメッセージID

---

### isConvertible

```java
public boolean isConvertible(ValidationContext<T> context, String propertyName, Object propertyDisplayName, Object value, Annotation format)
```

{@inheritDoc}

---

### convert

```java
public Object convert(ValidationContext<T> context, String propertyName, Object value, Annotation format)
```

---
