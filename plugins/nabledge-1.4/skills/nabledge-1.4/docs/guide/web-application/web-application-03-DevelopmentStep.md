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
  * UI開発基盤を使用して業務画面JSP（設計工程時点）が作成されていること。
  * Nablarch Application Frameworkを使用してアプリケーション開発を行うための環境構築が完了していること。

**本ガイドで使用する開発環境**

本ガイドでは、Nablarchの提供するtutorialワークスペースに含まれている、step-by-stepプロジェクトを使用する。

> **Warning:**
> 本チュートリアルを開始する前に、 [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) を参照すること。

**ユーザ情報登録機能の開発手順**

* [説明に使用する機能について](../../guide/web-application/web-application-01-spec.md)
* [開発フロー](../../guide/web-application/web-application-02-flow.md)
* [マスタデータのセットアップ](../../guide/web-application/web-application-03-datasetup.md)
* [FormBaseクラスの自動生成](../../guide/web-application/web-application-04-generate-form-base.md)
* [Formクラスの実装](../../guide/web-application/web-application-05-create-form.md)
* [登録画面初期表示の実装](../../guide/web-application/web-application-06-initial-view.md)
* [確認画面の実装](../../guide/web-application/web-application-07-confirm-view.md)
* [完了画面の実装](../../guide/web-application/web-application-08-complete.md)
* [動作確認の実施](../../guide/web-application/web-application-09-confirm-operation.md)
