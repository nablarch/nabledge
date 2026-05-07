# Getting Started

本章を通読することで、Nablarchバッチアプリケーション方式のバッチの開発イメージを掴むことができる。

> **Tip:**
> ExampleはNablarchの機能の使用方法を示した実装例であり、Exampleを改修して本格的なアプリケーションを作成することは想定していない。

> 本格的なアプリケーションを作成する場合は [ブランクプロジェクト](../../setup/blank-project/blank-project-blank-project.md#ブランクプロジェクト) から作成すること。

前提条件

本章は [Example](../../about/about-nablarch/about-nablarch-examples.md#example) をベースに解説する。
Exampleアプリケーションの動作環境を事前に構築しておくこと。

> **Tip:**
> Exampleアプリケーションに関する以下の事項は、本章では解説しない。
> 以下の事項については、 [Example](../../about/about-nablarch/about-nablarch-examples.md#example) を参照すること。

> * >   Exampleアプリケーションの環境構築および実行
> * >   Exampleアプリケーションの設定
> * >   使用しているOSSプラグインについて

nablarch_batch/index

> **Tip:**
> Nablarchバッチアプリケーションでは、 [都度起動バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#アーキテクチャ概要) と
> [常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#アーキテクチャ概要) でアプリケーションの実装方法に違いがないため、
> 別々にGetting Startedを用意していない。
> [都度起動バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#アーキテクチャ概要) と
> [常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#アーキテクチャ概要) で異なるのは、ハンドラ構成のみである。
