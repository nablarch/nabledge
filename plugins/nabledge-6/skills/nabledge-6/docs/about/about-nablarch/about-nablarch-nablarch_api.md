# Nablarch API

## Nablarch API概要

> **補足**: Nablarch 6からは非公開APIも含めた形でAPIドキュメントを提供している（Nablarch 5まではアーキテクトとアプリケーションプログラマ向けの公開APIのみ）。これは、Javaのバージョンが上がってJavadocの生成を拡張する仕組みが変わり、公開APIだけに絞ったJavadoc生成ができなくなったためである。

参照したクラスやメソッドが公開APIであるかどうかは、対象のJavadoc上に `@Published` が記載されているかどうかで判断する。

- `@Published(tag="architect")` が記載されている → アーキテクト向け公開API
- クラスにもメソッドにも `@Published` なし → 非公開API

**具体例**:
- `DaoContext`: クラスに `@Published(tag="architect")` が記載されているためアーキテクト向けの公開API
- `BasicDaoContext#findAll`: クラスにもメソッドにも `@Published` が記載されていないため非公開API
