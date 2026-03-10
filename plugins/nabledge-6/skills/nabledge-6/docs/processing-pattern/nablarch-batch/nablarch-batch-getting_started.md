# Getting Started

## Exampleアプリケーションの位置づけ

> **補足**: ExampleはNablarchの機能の使用方法を示した実装例であり、Exampleを改修して本格的なアプリケーションを作成することは想定していない。本格的なアプリケーションを作成する場合は :ref:`blank_project` から作成すること。

## 前提条件

本章は `example_application` をベースに解説する。Exampleアプリケーションの動作環境を事前に構築しておくこと。

> **補足**: Exampleアプリケーションに関する以下の事項は本章では解説しない。詳細は `example_application` を参照すること。
> - Exampleアプリケーションの環境構築および実行
> - Exampleアプリケーションの設定
> - 使用しているOSSプラグインについて

## 概要

> **補足**: Nablarchバッチアプリケーションでは、:ref:`都度起動バッチ<nablarch_batch-each_time_batch>` と :ref:`常駐バッチ<nablarch_batch-resident_batch>` でアプリケーションの実装方法に違いがない。両者で異なるのはハンドラ構成のみであるため、Getting Startedは共通化されている。
