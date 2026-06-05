# class CompositeCharsetDef

**パッケージ:** nablarch.core.validation.validator.unicode

**継承階層:**
```
java.lang.Object
  └─ CharsetDefSupport
      └─ nablarch.core.validation.validator.unicode.CompositeCharsetDef
```

---

```java
public class CompositeCharsetDef
extends CharsetDefSupport
```

複数の{@link CharsetDef}の組み合わせによる許容文字集合定義クラス。<br/>
本クラスでは、他の許容文字集合定義の組み合わせにより文字集合を定義できる。
<pre>
{@literal
<!-- ２つの許容文字集合定義を組み合わせ -->
<component name="composite" class="nablarch.core.validation.validator.unicode.CompositeCharsetDef">\
  <property name="charsetDefList">
    <list>
      <component-ref name="asciiWithoutControlCode"/>
      <component-ref name="zenkakuKatakanaCharset"/>
    </list>
  </property>
</component>
<!-- ASCII -->
<component name="asciiWithoutControlCode" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
  <property name="startCodePoint" value="U+0020" />
  <property name="endCodePoint" value="U+007E" />
</component>
<!-- 全角カタカナ -->
<component name="zenkakuKatakanaCharset"
  class="nablarch.core.validation.validator.unicode.CompositeCharsetDef">
  <property name="charsetDefList">
    <list>
      <component-ref name="zenkakuKatakanaCharsDef" />
      <component-ref name="zenkakuSpaceDef" />
    </list>
  </property>
</component>
}
</pre>

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### definitions

```java
private List<? extends CharsetDef> definitions
```

許容文字集合定義のリスト

---

## メソッドの詳細

### contains

```java
public boolean contains(int codePoint)
```

{@inheritDoc}

---

### setCharsetDefList

```java
public void setCharsetDefList(List<? extends CharsetDef> definitions)
```

許容文字集合定義のリストを設定する。

**パラメータ:**
- `definitions` - 許容文字集合定義のリスト

---
