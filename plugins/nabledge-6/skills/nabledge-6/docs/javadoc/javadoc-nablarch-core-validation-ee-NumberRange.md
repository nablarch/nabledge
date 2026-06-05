# @interface NumberRange

**パッケージ:** nablarch.core.validation.ee

---

```java
public @interface NumberRange
```

入力値が指定の範囲内であるかチェックする。
入力値が実数の場合は、{@link DecimalRange}を用いること。
<pre>
入力値が1以上10以下の範囲内であるかチェックする
{@code public class Sample}{
    {@code @NumberRange(min = 1, max = 10)
    String sales;
}}

入力値が0以上であるかチェックする
{@code public class Sample}{
    {@code @NumberRange(min = 0)
    String sales;
}}
</pre>
エラー時のメッセージは、以下のルールにより決定される。
<ol>
    <li>{@link #message()}が指定されている場合は、その値を使用する。</li>
    <li>{@link #message()}が未指定で{@link #min()}のみ指定の場合は、<b>{nablarch.core.validation.ee.NumberRange.min.message}</b></li>
    <li>{@link #message()}が未指定で{@link #max()}のみ指定の場合は、<b>{nablarch.core.validation.ee.NumberRange.max.message}</b></li>
    <li>{@link #message()}が未指定で{@link #min()}と{@link #max()}を指定の場合は、<b>{nablarch.core.validation.ee.NumberRange.min.max.message}</b></li>
</ol>

**作成者:** T.Kawasaki  

---
