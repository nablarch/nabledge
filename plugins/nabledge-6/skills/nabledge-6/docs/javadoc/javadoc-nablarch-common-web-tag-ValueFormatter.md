# interface ValueFormatter

**パッケージ:** nablarch.common.web.tag

---

```java
public interface ValueFormatter
```

値をフォーマットするインタフェース。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### format

```java
String format(PageContext pageContext, String name, Object value, String pattern)
```

指定されたパターンを使用して値をフォーマットする。

**パラメータ:**
- `pageContext` - ページコンテキスト
- `name` - name属性の値
- `value` - 値
- `pattern` - パターン

**戻り値:**
フォーマット済みの値

---
