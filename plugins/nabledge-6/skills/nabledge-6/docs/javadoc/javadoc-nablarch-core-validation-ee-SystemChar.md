# @interface SystemChar

**パッケージ:** nablarch.core.validation.ee

---

```java
public @interface SystemChar
```

システム許容文字で構成された文字列であることを表わすアノテーション。
<p>
  許容文字集合 "全角文字" を次のように定義する。
  許容文字集合の定義方法は、範囲指定やリテラル指定などいくつかあるので、詳細は{@link nablarch.core.validation.validator.unicode}パッケージのjavadocを参照。
  <pre>
     {@code <component name="全角文字" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
        <!-- 省略 -->
    </component>}
  </pre>
  上で定義した許容文字集合 "全角文字" のバリデーションを行うドメインを次のように定義する。
  <pre>
     {@code public class SampleDomain }{
         {@code @Length(max = 10)}
         {@code @SystemChar(charsetDef="全角文字")
        String name;
    }}
  </pre>
  このドメイン定義を使用して、バリデーションを行う設定については{@link Domain}のjavadocを参照。
</p>

<p>
  このバリデーションでは、デフォルトではサロゲートペアを許容しない。
  （例え{@link nablarch.core.validation.validator.unicode.LiteralCharsetDef LiteralCharsetDef}で明示的にサロゲートペアの文字を定義していても許容しない）
</p>
<p>
  サロゲートペアを許容する場合は次のようにコンポーネント設定ファイルに{@link SystemCharConfig}を設定する必要がある。
</p>
<pre>
  {@code <component name="ee.SystemCharConfig" class="nablarch.core.validation.ee.SystemCharConfig">
    <property name="allowSurrogatePair" value="true"/>
  </component>}
</pre>

**作成者:** T.Kawasaki  

---
