# @interface Size

**パッケージ:** nablarch.core.validation.ee

---

```java
public @interface Size
```

要素数が指定した値の範囲内であるかチェックするアノテーション。
<pre>
arrayの要素数が1～3の範囲内であるかチェック
{@code public class Sample}{
    {@code @Size(min = 1, max = 3)
    String[] array;
}}

arrayの要素数が2以上であるかチェック
{@code public class Sample}{
    {@code @Size(min = 2)
    String[] array;
}}
</pre>

エラー時のメッセージは、以下のルールにより決定される。
<ol>
    <li>{@link #message()}が指定されている場合は、その値を使用する。</li>
    <li>{@link #message()}が未指定で{@link #min()}のみ指定の場合は、<b>{nablarch.core.validation.ee.Size.min.message}</b></li>
    <li>{@link #message()}が未指定で{@link #max()}のみ指定の場合は、<b>{nablarch.core.validation.ee.Size.max.message}</b></li>
    <li>{@link #message()}が未指定で{@link #min()}と{@link #max()}を指定の場合は、<b>{nablarch.core.validation.ee.Size.min.max.message}</b></li>
</ol>

**作成者:** T.Kawasaki  

---
