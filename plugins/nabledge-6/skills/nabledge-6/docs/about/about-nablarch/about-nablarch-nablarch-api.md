# Nablarch API

* Nablarch APIドキュメント
* Nablarch Testing APIドキュメント

> **Tip:**
> Nablarch 5までのAPIドキュメントは、アーキテクトとアプリケーションプログラマ向けの公開APIだけに絞ったものを提供していた。
> しかし、Nablarch 6からは非公開APIも含めた形でAPIドキュメントを提供している。

> これは、Javaのバージョンが上がってJavadocの生成を拡張する仕組みが変わり、公開APIだけに絞ったJavadoc生成ができなくなったためである。

> 参照したクラスやメソッドが公開APIであるかどうかは、対象のJavadoc上に `@Published` が記載されているかどうかで判断できる。

> 例えば、 DaoContext はクラスに `@Published(tag="architect")` が記載されているためアーキテクト向けの公開APIであることが分かる。
> 一方で、 BasicDaoContextのfindAllメソッド はクラスにもメソッドにも `@Published` が記載されていないことから非公開APIであることが分かる。

> なお、公開APIに関する仕様の詳細は [後方互換性ポリシー](../../about/about-nablarch/about-nablarch-versionup-policy.md#後方互換性ポリシー) および [使用不許可APIチェックツールのREADME (外部サイト)](https://github.com/Fintan-contents/coding-standards/blob/main/java/staticanalysis/unpublished-api/README.md) を参照すること。
