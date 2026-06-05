# interface Formatter

**パッケージ:** nablarch.core.text

---

```java
public interface Formatter
```

値をフォーマットするインターフェース

**param:** フォーマット対象の型  
**作成者:** Ryota Yoshinouchi  

---

## メソッドの詳細

### getFormatClass

```java
Class<T> getFormatClass()
```

フォーマット対象のクラスを取得する

**戻り値:**
フォーマット対象のクラス

---

### getFormatterName

```java
String getFormatterName()
```

フォーマッタの名前を取得する

**戻り値:**
フォーマッタの名前

---

### format

```java
String format(T input)
```

デフォルトの書式でフォーマットする。

**パラメータ:**
- `input` - フォーマット対象

**戻り値:**
フォーマットされた文字列

---

### format

```java
String format(T input, String pattern)
```

指定された書式でフォーマットする。

**パラメータ:**
- `input` - フォーマット対象
- `pattern` - フォーマットの書式

**戻り値:**
フォーマットされた文字列

---
