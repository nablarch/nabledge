# @interface Length

**パッケージ:** nablarch.core.validation.ee

---

```java
public @interface Length
```

指定された範囲内の文字列長であることを表すアノテーション。
<br/>
入力値がnull又は空文字の場合は、validと判定する。

エラー時のメッセージは、以下のルールにより決定される。
<ol>
    <li>{@link #message()}が指定されている場合は、その値を使用する。</li>
    <li>{@link #message()}が未指定で{@link #min()}のみ指定の場合は、<b>{nablarch.core.validation.ee.Length.min.message}</b></li>
    <li>{@link #message()}が未指定で{@link #max()}のみ指定の場合は、<b>{nablarch.core.validation.ee.Length.max.message}</b></li>
    <li>{@link #message()}が未指定で{@link #max()}と{@link #min()}に指定した値が同じ場合は、<b>{nablarch.core.validation.ee.Length.fixed.message}</b></li>
    <li>{@link #message()}が未指定で{@link #min()}と{@link #max()}に指定した値が異なる場合は、<b>{nablarch.core.validation.ee.Length.min.max.message}</b></li>
</ol>

文字列長の計算はサロゲートペアを考慮して行われる。

**作成者:** T.Kawasaki  

---
