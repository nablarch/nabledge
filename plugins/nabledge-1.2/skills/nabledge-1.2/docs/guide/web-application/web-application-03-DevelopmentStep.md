# 業務アプリケーション開発手順

Nablarch Webアプリケーションフレームワークを利用したWebアプリケーションの開発手順を説明する。
バッチ等の実装においても開発プロセスは大きく変わらないため、代表として画面オンライン処理を採り上げて説明をする。

**本ガイドの目的**

アプリケーションプログラマが、Nablarch Application Frameworkを使用した画面オンライン処理の開発手順を理解すること。

* 対象工程

  本ガイドが対象とする工程は以下のとおり。

  * プログラミング・単体テスト工程

* 前提条件

  本ガイド記載の開発手順では以下の前提条件を置いている。

  * 外部設計書、内部設計書が完成していること。

Nablarch Application Frameworkを使用した画面オンライン処理の開発手順について、
Nablarchのサンプルアプリケーションへ更新機能を追加する際の実装を例として説明する。

> **Note:**
> 更新機能はサンプルアプリケーションに実装済みである。
> 以下では、簡易的な更新機能を例として取りあげる。

## 更新機能の開発手順

簡易な更新機能を実際に作成する手順を例に Nablarch を使用した画面オンライン処理の開発手順を説明する。

* [説明に使用する機能について](../../guide/web-application/web-application-01-spec.md)
* [開発フロー](../../guide/web-application/web-application-02-flow.md)
* [マスタデータのセットアップ](../../guide/web-application/web-application-03-datasetup.md)
* [Entityクラス（精査処理）の実装](../../guide/web-application/web-application-04-create-entity.md)
* [Formクラスの実装](../../guide/web-application/web-application-05-create-form.md)
* [更新画面初期表示の実装](../../guide/web-application/web-application-06-initial-view.md)
* [確認画面の実装](../../guide/web-application/web-application-07-confirm-view.md)
* [完了画面の実装](../../guide/web-application/web-application-08-complete.md)
* [動作確認をする為のサンプルアプリケーションの修正](../../guide/web-application/web-application-09-confirm-operation.md)
