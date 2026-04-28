![Nablarch.jpg](../../../knowledge/assets/about-nablarch-top-nablarch/Nablarch.jpg)

## Nablarch フォルダのコンテンツについて

### フォルダ構成

nablarchフォルダの構成は下記を参照してください。

<style>
table {
  border-collapse: collapse;
}
th {
  border: solid 1px #666666;
  color: #000000;
  background-color:   #FF9933;
}
td {
  border: solid 1px #666666;
  color: #000000;
  background-color: #ffffff;
}
</style>
<table>
  <thead>
    <tr>
      <th colspan="6" align="left">
        フォルダ構成
      </th>
      <th>
        説明
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td colspan="6" align="left"  style="border-bottom:none; background-color:#ffcc33">
        nablarch/
      </td>
      <td style="background-color:#ffcc33"> </td>
    </tr>
    <tr>
      <td rowspan="56" style="border-top:none; background-color:#ffcc33">　</td>
      <td colspan="5" style="background-color:#ffffcc">
        release_note/
      </td>
      <td style="background-color:#ffffcc">
        リリースノートが格納されています。

        （<a target="_blank" href="./release_note">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="5" style="border-bottom:none; background-color:#ffffcc">
        library/
      </td>
      <td style="background-color:#ffffcc">
        Nablarch ライブラリが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="11" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4" style="border-bottom:none">
        fw/
      </td>
      <td>
        Nablarch Application Frameworkが格納されています。

        （<a target="_blank" href="./library/fw">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="5" style="border-top:none">　</td>
      <td colspan="3">
        nablarch.jar
      </td>
      <td>
        Application Frameworkのオブジェクトコードです。
      </td>
    </tr>
    <tr>
      <td colspan="3">
        lib/
      </td>
      <td>
        Application Framework のコンパイル時に使用したライブラリが格納されています。

        それぞれのライブラリの詳細については、同ディレクトリに配置した readme.txt を参照してください。

        （<a href="./library/fw/lib/readme.txt"> readme.txt を開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        doc/
      </td>
      <td>
        Application Frameworkの解説書が格納されています。

        （<a href="./library/fw/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        javadoc/
      </td>
      <td>
        Application Framework のjavadoc(プロジェクトのアーキテクトが使用可能なAPIのみ)が格納されています。

        （<a href="./library/fw/javadoc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        javadoc_pg/
      </td>
      <td>
        Application Framework のjavadoc(プロジェクトのアプリケーションプログラマが使用可能なAPIのみ)が格納されています。

        （<a href="./library/fw/javadoc_pg/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none">
        tfw/
      </td>
      <td>
        Nablarch Testing Frameworkが格納されています。

        （<a target="_blank" href="./library/tfw">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="4" style="border-top:none">　</td>
      <td colspan="3">
        nablarch-tfw.jar
      </td>
      <td>
        Testing Frameworkのオブジェクトコードです。
      </td>
    </tr>
    <tr>
      <td colspan="3">
        lib/
      </td>
      <td>
        Testing Frameworkの実行に必要なライブラリが格納されています。

        それぞれのライブラリの詳細については、同ディレクトリに配置した readme.txt を参照してください。

        （<a href="./library/tfw/lib/readme.txt"> readme.txt を開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        javadoc/
      </td>
      <td>
        Testing Frameworkのjavadoc(プロジェクトのアーキテクトが使用可能なAPIのみ)が格納されています。

        （<a href="./library/tfw/javadoc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        javadoc_pg/
      </td>
      <td>
        Testing Frameworkのjavadoc(プロジェクトのアプリケーションプログラマが使用可能なAPIのみ)が格納されています。

        （<a href="./library/tfw/javadoc_pg/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="5" style="border-bottom:none; background-color:#ffffcc">
        guide/
      </td>
      <td style="background-color:#ffffcc">
        Nablarchガイドが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="8" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4" style="border-bottom:none">
        development_guide/
      </td>
      <td>
        Nablarch開発ガイドが格納されています。

        （<a href="./guide/development_guide/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none">
        environment_guide/
      </td>
      <td>
        Nablarch環境構築ガイドが格納されています。

        開発リポジトリ構築支援用のAntビルドファイルも格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none">　</td>
      <td colspan="3">
        開発環境構築ガイド.doc
      </td>
      <td>
        個々の開発者がPC用の統合開発環境をセットアップする手順を説明したガイドです。

        （<a href="./guide/environment_guide/開発環境構築ガイド.doc">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        開発リポジトリ構築ガイド.doc
      </td>
      <td>
        アプリケーションの開発環境(CI、バージョン管理システム、PC用の統合開発環境)の構築手順を説明したガイドです。

        アーキテクトなど、プロジェクトの開発環境構築を行う方が読まれることを想定しています。

        （<a href="./guide/environment_guide/開発リポジトリ構築ガイド.doc">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        開発リポジトリ構築ビルドファイル
      </td>
      <td>
        開発リポジトリ構築に必要なAntのビルドファイルです。

        （<a target="_blank" href="./guide/environment_guide/開発リポジトリ構築ビルドファイル">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none">
        tutorial/
      </td>
      <td>
        基本的な業務アプリケーションの実装方法を示したチュートリアル用サンプルアプリケーションです。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="3">
        Nablarch-tutorial-workspace.zip
      </td>
      <td>
        チュートリアル用サンプルのソースコードです。

        Eclipseのワークスペースの形式で提供します。

        （<a href="./guide/tutorial/Nablarch-tutorial-workspace.zip">ファイルを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        Nablarch-dev-env.zip
      </td>
      <td>
        チュートリアル用サンプルアプリケーションを動作させるのに必要なソフトウェアをまとめたパッケージです。以下のソフトウェアを含みます。

          <ul>
            <li> Eclipse 3.6
            <li> Apache Tomcat 6.0.32
          </ul>
        これらのソフトウェアは、それぞれのライセンスに従い再配布可能です。またNablarchは、本パッケージによる環境下で動作確認を行っています。

        （<a href="./guide/tutorial/Nablarch-dev-env.zip">ファイルを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="5" style="border-bottom:none; background-color:#ffffcc">
        standard/
      </td>
      <td style="background-color:#ffffcc">
        Nablarch開発標準が格納されています。

        （<a target="_blank" href="./standard/">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="6" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4">
        coding_rule/
      </td>
      <td>
        コーディング規約が格納されています。下記が含まれます。

        　・Javaコーディング規約

        　・JSPコーディング規約

        　・SQLコーディング規約

        　・javascriptコーディング規約

        　・シェルスクリプト開発標準
      </td>
    </tr>
    <tr>
      <td colspan="4">
        design_standard/
      </td>
      <td>
        設計標準が格納されています。下記のものが含まれます。

        　・UI標準

        　・DB標準

        　・共通コンポーネント設計標準
      </td>
    </tr>
    <tr>
      <td colspan="4">
        document_format/
      </td>
      <td>
        設計書のフォーマットとサンプルが格納されています。

        詳細は当フォルダ内の「Nablarch設計ドキュメント解説書」を参照してください。
      </td>
    </tr>
    <tr>
      <td colspan="4">
        document_standard_style/
      </td>
      <td>
        ドキュメント規約（設計書を記載する際のルールを定めたドキュメント）が格納されています。
      </td>
    </tr>
    <tr>
      <td colspan="4">
        unit_test/
      </td>
      <td>
        単体テスト標準が格納されています。
      </td>
    </tr>
    <tr>
      <td colspan="4">
        wbs/
      </td>
      <td>
        Nablarchを使用したシステム開発における標準WBSが格納されています。

        （<a href="./standard/wbs/Nablarchを使用したシステム開発における標準WBS.xls">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="5" style="border-bottom:none; background-color:#ffffcc">
        sample/
      </td>
      <td style="background-color:#ffffcc">
        Nablarchサンプルが格納されています。

        Nablarchサンプルは、下記のソースコードディレクトリから必要なファイルをプロジェクトに取り込んで利用してください。
      </td>
    </tr>
    <tr>
      <td rowspan="23" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4" style="border-bottom:none">
        biz_sample/
      </td>
      <td>
        頻繁に利用される業務機能のサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="3" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./sample/biz_sample/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./sample/biz_sample/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none">
        fw_integration_sample/
      </td>
      <td>
        Nablarchを拡張して特定の製品に対応させる場合の拡張モジュールのサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="12" style="border-top:none">　</td>
      <td colspan="3" style="border-bottom:none">
        log4j/
      </td>
      <td>
        ログ出力機能でlog4jを使用する場合のサンプルです。

      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/log4j/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/log4j/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        smime/
      </td>
      <td>
        メール送信機能でbouncycastleを使用する場合のサンプルです。

        本サンプルでは、 bouncycastle を使用してS/MIMEに対応した電子署名付きメール送信機能を実現しています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/smime/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/smime/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        wmq/
      </td>
      <td>
        メッセージング機能でWebsphereMQを使用する場合のサンプルです。

        本サンプルでは、 WebsphereMQ の機能を使用して分散トランザクションを実現しています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/wmq/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/wmq/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        db/
      </td>
      <td>
        特定のデータベース向けにNablarch実装を拡張する実装サンプルです。

      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/db/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./sample/fw_integration_sample/db/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none">
        log_statistics_sample/
      </td>
      <td>
        運用時に使用するログ集計機能のサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="3" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./sample/log_statistics_sample/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./sample/log_statistics_sample/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none">
        ui/
      </td>
      <td>
        画面開発のQCDを要件定義からPG/UTまで一体で向上させるUI開発基盤のサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none">　</td>
      <td colspan="3" style="border-bottom:none">
        doc/
      </td>
      <td>
        UI開発基盤の解説書が格納されています。

        （<a target="_blank" href="./sample/ui/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        guide/
      </td>
      <td>
        UI開発基盤を利用したJSP/HTMLの作成ガイドが格納されています。

        （<a target="_blank" href="./sample/ui/guide/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./sample/ui/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="5" style="border-bottom:none; background-color:#ffffcc">
        toolbox/
      </td>
      <td style="background-color:#ffffcc">
        Nablarch Toolbox が格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4">
        doc/
      </td>
      <td>
        Toolboxの解説書が格納されています。Toolboxの使用方法はこのドキュメントを参照してください。

        （<a href="./toolbox/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4">
        src/
      </td>
      <td>
        Toolboxのソースコードです。

        Toolbox を改修する際に使用します。

        （<a target="_blank" href="./toolbox/src">フォルダを開く</a>）
      </td>
    </tr>
  </tbody>
</table>

### コンテンツの見方

Nablarchのコンテンツの見方を目的別に説明します。

* **Nablarchを使用したアプリケーション開発の全体像を知りたい**

[Nablarchを使用したシステム開発における標準WBS](./standard/wbs/Nablarchを使用したシステム開発における標準WBS.xls) を参照してください。

Nablarchの各コンテンツをどの工程でどのように使う想定であるかを解説しています。

* **Nablarch Application Framework、Nablarch Testing Frameworkを使用したプログラミングや単体テストの実施方法を知りたい**

1. [開発環境構築ガイド](./guide/environment_guide/開発環境構築ガイド.doc) に従ってサンプルアプリケーションをインストールしてください。
  インストールに必要な資源(サンプルアプリケーションのEclipseワークスペースや、サンプルアプリケーションを動作させるために必要なミドルウェアなど)の場所は、 フォルダ構成 を参照してください。
2. [プログラミング・単体テストガイド](./guide/development_guide/index.html) に従って学習を進めてください。

* **Nablarch Application Frameworkの詳しい仕様を知りたい**

[Application Framework解説書](./library/fw/doc/index.html) を参照してください。

* **Nablarchを使用したアプリケーションの開発環境(CI環境、リポジトリ等)の構築方法を知りたい**

[開発リポジトリ構築ガイド](./guide/environment_guide/開発リポジトリ構築ガイド.doc) を参照してください。

* **Nablarch Toolboxにどのようなツールがあるのかや、ツールの使い方を知りたい**

[Nablarch Toolbox解説書](./toolbox/doc/index.html) を参照してください。
