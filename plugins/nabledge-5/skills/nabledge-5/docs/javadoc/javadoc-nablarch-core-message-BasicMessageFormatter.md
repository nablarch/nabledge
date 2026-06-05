# class BasicMessageFormatter

**パッケージ:** nablarch.core.message

**実装されたインタフェース:**
- MessageFormatter

---

```java
public class BasicMessageFormatter
implements MessageFormatter
```

オプション情報によりメッセージのフォーマット方法を切り替えフォーマットを行うクラス。

オプション情報が1つで{@link Map}のサブタイプの場合は、{@link NamedMessageFormat}を使用してメッセージをフォーマットする。
それ以外の場合は、{@link MessageFormat}を使用してメッセージをフォーマットする。

**作成者:** Hisaaki Shioiri  
**関連項目:** MessageFormat  
**関連項目:** NamedMessageFormat  

---

## メソッドの詳細

### format

```java
public String format(String template, Object[] options)
```

---

### isMap

```java
private static boolean isMap(Object[] options)
```

オプション情報がMapかどうか判定する。
<p>
以下の条件をみたす場合Mapと判断する。
<ul>
<li>オプションの要素数が1つの場合</li>
<li>オプションの唯一の要素が{@link Map}の実装クラスの場合</li>
</ul>

**パラメータ:**
- `options` - オプション情報

**戻り値:**
{@code Map}の場合{@code true}

---

### toMap

```java
private static Map<String,Object> toMap(Object option)
```

オプション情報をMapに変換する。

**パラメータ:**
- `option` - オプション

**戻り値:**
Mapに変換した値

---
