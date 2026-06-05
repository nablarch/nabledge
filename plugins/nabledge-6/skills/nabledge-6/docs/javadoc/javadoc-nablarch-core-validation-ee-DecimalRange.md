# @interface DecimalRange

**パッケージ:** nablarch.core.validation.ee

---

```java
public @interface DecimalRange
```

入力値が指定された値の範囲内であるかチェックする。
入力値が整数の場合は、{@link NumberRange}を用いること。
<pre>
salesが-1.5～1.5の範囲内であるかチェックする
{@code public class Sample}{
 {@code @DecimalRange(min = -1.5, max = 1.5)
 String sales;
}}
</pre>
<ol>
    <li>{@link #message()}が指定されている場合は、その値を使用する。</li>
    <li>{@link #message()}が未指定で{@link #min()}のみ指定の場合は、<b>{nablarch.core.validation.ee.DecimalRange.min.message}</b></li>
    <li>{@link #message()}が未指定で{@link #max()}のみ指定の場合は、<b>{nablarch.core.validation.ee.DecimalRange.max.message}</b></li>
    <li>{@link #message()}が未指定で{@link #min()}と{@link #max()}を指定の場合は、<b>{nablarch.core.validation.ee.DecimalRange.min.max.message}</b></li>
</ol>

**作成者:** Ukawa Shohei  

---
