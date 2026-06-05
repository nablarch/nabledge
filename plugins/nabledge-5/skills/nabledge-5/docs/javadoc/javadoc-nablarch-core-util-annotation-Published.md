# @interface Published

**パッケージ:** nablarch.core.util.annotation

---

```java
public @interface Published
```

Nablarchが後方互換性を維持するAPIであることを表すアノテーション。
<p/>
Nablarchが後方互換性を維持するAPIのことを公開APIと呼ぶ。<br/>
本アノテーションを付けたAPIは、javadocにより仕様が公開される。<br/>
本アノテーションをクラス宣言に付けた場合は、クラスのpublicなメンバが全て公開APIとなる。<br/>
特定のメソッドのみを公開APIとする場合は、本アノテーションをメソッド宣言に付ける。<br/>

**作成者:** Masayuki Fujikuma  

---
