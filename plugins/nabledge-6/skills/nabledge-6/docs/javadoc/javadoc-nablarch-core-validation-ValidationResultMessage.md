# class ValidationResultMessage

**パッケージ:** nablarch.core.validation

**継承階層:**
```
java.lang.Object
  └─ Message
      └─ nablarch.core.validation.ValidationResultMessage
```

---

```java
public class ValidationResultMessage
extends Message
```

バリデーション結果のメッセージを保持するクラス。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### propertyName

```java
private String propertyName
```

バリデーション対象のプロパティ名。

---

## コンストラクタの詳細

### ValidationResultMessage

```java
public ValidationResultMessage(String propertyName, StringResource message, Object[] parameters)
```

{@code ValidationResultMessage}オブジェクトを構築する。
<p/>
メッセージの通知レベルは{@link MessageLevel#ERROR}が指定される。

**パラメータ:**
- `propertyName` - バリデーション対象のプロパティ名
- `message` - バリデーション結果のメッセージ
- `parameters` - メッセージのオプションパラメータ

---

## メソッドの詳細

### getPropertyName

```java
public String getPropertyName()
```

バリデーション対象のプロパティ名を取得する。

**戻り値:**
バリデーション対象のプロパティ名

---

### equals

```java
public boolean equals(Object obj)
```

このオブジェクトと等価であるかを返す。
<p/>
{@code obj}が以下の条件を全て満たす場合{@code true}を返す。
<ul>
    <li>{@code null}ではないこと。</li>
    <li>このオブジェクトと同じ型であること。</li>
    <li>メッセージIDが同値であること。</li>
    <li>バリデーション対象のプロパティ名が同値であること。</li>
</ul>

**戻り値:**
このオブジェクトと等価である場合{@code true}

---

### hashCode

```java
public int hashCode()
```

このオブジェクトのハッシュコード値を返す。

**戻り値:**
ハッシュコード値。メッセージIDとバリデーション対象プロパティが同値のオブジェクトは、同じハッシュコード値を返す。

---

### toString

```java
public String toString()
```

このオブジェクトの文字列表現を返す。

**戻り値:**
メッセージIDとバリデーション対象プロパティを記載した文字列

---
