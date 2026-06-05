# @interface Published

**パッケージ:** nablarch.core.util.annotation

---

```java
public @interface Published
```

Nablarchが後方互換性を維持するAPIであることを表すアノテーション。
<p/>
Nablarchが後方互換性を維持するAPI（メソッドやフィールドを含む）のことを公開APIと呼ぶ。<br/>
本アノテーションを付けたAPIは、Javadocにより仕様を公開する。<br/>
クラスの全てのAPIを公開APIとする場合は、本アノテーションをクラス宣言に付与している。<br/>
特定のAPIを公開APIとする場合は、本アノテーションを対象のAPI宣言に付与している。<br/>
また、利用者がオーバーライド可能なメソッドも公開APIとし、本アノテーションを付与している。<br/>
公開APIのオーバーライドを行う場合は、Javadocに記述された仕様に則り実装を行うこと。<br/>

**作成者:** Masayuki Fujikuma  

---
