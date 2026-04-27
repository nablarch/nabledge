

![Nablarch.jpg](../../../knowledge/assets/about-nablarch-top-nablarch/Nablarch.jpg)

## Nablarchのコンテンツ

Nablarchのコンテンツは nablarchフォルダに格納されています。

### フォルダ構成

nablarchフォルダの構成について説明します。

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
      <td rowspan="88" style="border-top:none; background-color:#ffcc33">　</td>
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
        app_exe_env/
      </td>
      <td style="background-color:#ffffcc">
        アプリケーション実行環境が格納されています。

      </td>
    </tr>
    <tr>
      <td rowspan="8" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        fw/
      </td>
      <td style="background-color:#ffffee">
        Nablarch Application Framework が格納されています。
        （<a target="_blank" href="./app_exe_env/fw">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        dist/
      </td>
      <td>
        オブジェクトコードが格納されています。
      </td>
    </tr>
    <tr>
      <td colspan="3">
        lib/
      </td>
      <td>
        Application Framework のコンパイル時に使用したライブラリが格納されています。

        ライブラリの詳細については、同ディレクトリに配置した<a href="./app_exe_env/fw/lib/readme.txt"> readme.txt </a>を参照してください。
      </td>
    </tr>
    <tr>
      <td colspan="3">
        src/
      </td>
      <td>
        ソースコードが格納されています。
        （<a target="_blank" href="./app_exe_env/fw/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        fw_doc/
      </td>
      <td style="background-color:#ffffee">
        Nablarch Application Frameworkの解説書およびAPIドキュメントが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        doc/
      </td>
      <td>
        解説書が格納されています。
        （<a href="./app_exe_env/fw_doc/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        javadoc/
      </td>
      <td>
        javadoc(プロジェクトのアーキテクトが使用可能なAPIのみ)が格納されています。

        （<a href="./app_exe_env/fw_doc/javadoc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        javadoc_pg/
      </td>
      <td>
        javadoc(プロジェクトのアプリケーションプログラマが使用可能なAPIのみ)が格納されています。

        （<a href="./app_exe_env/fw_doc/javadoc_pg/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="5" style="border-bottom:none; background-color:#ffffcc">
        app_dev_env/
      </td>
      <td style="background-color:#ffffcc">
        アプリケーション開発環境が格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="64" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        app_dev/
      </td>
      <td style="background-color:#ffffee">
         アプリケーション開発基盤が格納されています。
        （<a target="_blank" href="./app_dev_env/app_dev">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="4" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        開発環境構築ガイド
      </td>
      <td>
        個々の開発者がPC用の統合開発環境をセットアップする手順を説明したガイドです。

        （<a href="./app_dev_env/app_dev/開発環境構築ガイド.doc">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        開発リポジトリ構築ガイド
      </td>
      <td>
        アプリケーションの開発環境(CI、バージョン管理システム、PC用の統合開発環境)の構築手順を説明したガイドです。

        アーキテクトなど、プロジェクトの開発環境構築を行う方が読まれることを想定しています。

        （<a href="./app_dev_env/app_dev/開発リポジトリ構築ガイド.doc">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        開発リポジトリ構築ビルドファイル
      </td>
      <td>
        開発リポジトリ構築に必要なAntのビルドファイルです。
        （<a target="_blank" href="./app_dev_env/app_dev/開発リポジトリ構築ビルドファイル">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        開発環境パッケージ
      </td>
      <td>
        チュートリアル用サンプルアプリケーションを動作させるのに必要なソフトウェアをまとめたパッケージです。以下のソフトウェアを含みます。

          <ul>
            <li> Eclipse
            <li> Apache Tomcat
          </ul>
        これらのソフトウェアは、それぞれのライセンスに従い再配布可能です。またNablarchは、本パッケージによる環境下で動作確認を行っています。

        （<a href="./app_dev_env/app_dev/Nablarch-dev-env.zip">ファイルを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        ui_dev/
      </td>
      <td style="background-color:#ffffee">
        Nablarch UI 開発基盤が格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3" style="border-bottom:none">
        doc/
      </td>
      <td>
        解説書が格納されています。
        （<a target="_blank" href="./app_dev_env/ui_dev/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        guide/
      </td>
      <td>
        UI 開発基盤を利用したJSP/HTMLの作成ガイドが格納されています。

        （<a target="_blank" href="./app_dev_env/ui_dev/guide/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        src/
      </td>
      <td>
        ソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/ui_dev/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        mobile/
      </td>
      <td style="background-color:#ffffee">
        Nablarch モバイルライブラリが格納されています。

        （<a target="_blank" href="./app_dev_env/mobile">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="8" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        doc/
      </td>
      <td>
        解説書が格納されています。

        （<a target="_blank" href="./app_dev_env/mobile/doc/arch_doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none; ">
        ios/
      </td>
      <td>
        Nablarch モバイルライブラリ (iOS版)の資材が格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="6" style="border-top:none;">　</td>
      <td colspan="2">
        bin/
      </td>
      <td>
        オブジェクトコードが格納されています。

        （<a target="_blank" href="./app_dev_env/mobile/ios/bin">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2">
        src/
      </td>
      <td>
        ソースコードが格納されています。

        （<a target="_blank" href="./app_dev_env/mobile/ios/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2">
        appledoc/
      </td>
      <td>
        appledocが格納されています。

        （<a target="_blank" href="./app_dev_env/mobile/ios/appledoc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
     <tr>
     <td colspan="2" style="border-bottom:none">
        sample/
      </td>
      <td>
        サンプルが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="1" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./app_dev_env/mobile/ios/sample/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="1" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/mobile/ios/sample/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        workflow/
      </td>
      <td style="background-color:#ffffee">
        Nablarch ワークフローライブラリが格納されています。

        （<a target="_blank" href="./app_dev_env/workflow">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="9" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        doc/
      </td>
      <td>
        解説書が格納されています。

        （<a target="_blank" href="./app_dev_env/workflow/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        src/
      </td>
      <td>
        ソースコードが格納されています。

        （<a target="_blank" href="./app_dev_env/workflow/src/">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        design_guide/
      </td>
      <td>
        ワークフローの設計ガイドが格納されています。

        （<a target="_blank" href="./app_dev_env/workflow/design_guide/">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none; ">
        tool/
      </td>
      <td>
        Nablarch ワークフローライブラリで提供するツールが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2">
        doc/
      </td>
      <td>
        ツールの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./app_dev_env/workflow/tool/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2">
        src/
      </td>
      <td>
        ツールのソースコードが格納されています。

        （<a target="_blank" href="./app_dev_env/workflow/tool/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
     <td colspan="3" style="border-bottom:none">
        sample_application/
      </td>
      <td>
        ワークフローアプリケーションの実装ガイドと、サンプルアプリケーションが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        doc/
      </td>
      <td>
        ワークフローライブラリを利用するアプリケーションの実装ガイドが格納されています。

        （<a target="_blank" href="./app_dev_env/workflow/sample_application/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルアプリケーションのソースコードが格納されています。

        （<a target="_blank" href="./app_dev_env/workflow/sample_application/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        app_lib/
      </td>
      <td style="background-color:#ffffee">
         Nablarchアプリケーションライブラリが格納されています。

         Nablarchアプリケーションライブラリは、下記のソースコードディレクトリから必要なファイルをプロジェクトに取り込んで利用してください。
      </td>
    </tr>
    <tr>
      <td rowspan="23" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3" style="border-bottom:none">
        biz_sample/
      </td>
      <td>
        頻繁に利用される業務機能のサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./app_dev_env/app_lib/biz_sample/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./app_dev_env/app_lib/biz_sample/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        fw_integration_sample/
      </td>
      <td>
        Nablarchを拡張して特定の製品に対応させる場合の拡張モジュールのサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="12" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        log4j/
      </td>
      <td>
        ログ出力機能でlog4jを使用する場合のサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="1" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/log4j/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="1" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/log4j/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        smime/
      </td>
      <td>
        メール送信機能でbouncycastleを使用する場合のサンプルです。

        本サンプルでは、 bouncycastle を使用してS/MIMEに対応した電子署名付きメール送信機能を実現しています。
      </td>
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="1" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/smime/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="1" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/smime/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        wmq/
      </td>
      <td>
        メッセージング機能でWebsphereMQを使用する場合のサンプルです。

        本サンプルでは、 WebsphereMQ の機能を使用して分散トランザクションを実現しています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="1" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/wmq/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="1" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/wmq/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        db/
      </td>
      <td>
        特定のデータベース向けにNablarch実装を拡張する実装サンプルです。

      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="1" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/db/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="1" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/fw_integration_sample/db/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        messaging_simulator_sample/
      </td>
      <td>
        メッセージング基盤テストシミュレータのサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。

        （<a target="_blank" href="./app_dev_env/app_lib/messaging_simulator_sample/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。

        （<a target="_blank" href="./app_dev_env/app_lib/messaging_simulator_sample/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        operation_sample/
      </td>
      <td>
        運用機能サンプルが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none">　</td>
      <td colspan="2" style="border-bottom:none">
        log_statistics_sample/
      </td>
      <td>
        運用時に使用するログ集計機能のサンプルです。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="1">
        doc/
      </td>
      <td>
        サンプルの設定、使用方法についての解説書が格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/operation_sample/log_statistics_sample/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="1">
        src/
      </td>
      <td>
        サンプルのソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/app_lib/operation_sample/log_statistics_sample/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        tfw/
      </td>
      <td style="background-color:#ffffee">
         Nablarch Testing Frameworkが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="5" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3" style="border-bottom:none">
        dist/
      </td>
      <td>
        オブジェクトコードおよび単体テスト用のツールが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none">　</td>
      <td colspan="2">
        auto_test/
      </td>
      <td>
        オブジェクトコードが格納されています。
      </td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom:none">
        test_tool/
      </td>
      <td>
        単体テスト用のツールが格納されています。
        （<a target="_blank" href="./app_dev_env/tfw/dist/test_tool">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        lib/
      </td>
      <td>
        Testing Framework の実行に必要なライブラリが格納されています。

        ライブラリの詳細については、同ディレクトリに配置した<a href="./app_dev_env/tfw/lib/readme.txt"> readme.txt </a>を参照してください。

      </td>
    </tr>
    <tr>
      <td colspan="3">
        src/
      </td>
      <td>
        Testing Frameworkのソースコードが格納されています。
        （<a target="_blank" href="./app_dev_env/tfw/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        tfw_doc/
      </td>
      <td style="background-color:#ffffee">
        Nablarch Testing FrameworkのAPIドキュメントが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        javadoc/
      </td>
      <td>
        javadoc(プロジェクトのアーキテクトが使用可能なAPIのみ)が格納されています。

        （<a href="./app_dev_env/tfw_doc/javadoc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        javadoc_pg/
      </td>
      <td>
        javadoc(プロジェクトのアプリケーションプログラマが使用可能なAPIのみ)が格納されています。

        （<a href="./app_dev_env/tfw_doc/javadoc_pg/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        toolbox/
      </td>
      <td style="background-color:#ffffee">
        Nablarch Toolbox が格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        doc/
      </td>
      <td>
        解説書とツールが格納されています。Toolboxの使用方法はこのドキュメントを参照してください。

        （<a href="./app_dev_env/toolbox/doc/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3">
        src/
      </td>
      <td>
        ソースコードが格納されています。

        Toolboxを改修する際に使用してください。

        （<a target="_blank" href="./app_dev_env/toolbox/src">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="5" style="border-bottom:none; background-color:#ffffcc">
        app_dev_guide/
      </td>
      <td style="background-color:#ffffcc">
        Nablarch開発標準およびガイドが格納されています。
      </td>
    </tr>
    <tr>
      <td rowspan="11" style="border-top:none; background-color:#ffffcc">　</td>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        standard/
      </td>
      <td style="background-color:#ffffee">
         Nablarch開発標準が格納されています。
        （<a target="_blank" href="./app_dev_guide/standard/">フォルダを開く</a>）
      </td>
    </tr>
    <tr>
      <td rowspan="6" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        dev_process_standard/
      </td>
      <td>
        開発プロセス標準が格納されています。
      </td>
    </tr>
    <tr>
      <td colspan="3">
        design_standard/
      </td>
      <td>
        設計標準が格納されています。下記のものが含まれます。

        　・UI標準

        　・DB設計標準

        　・共通コンポーネント設計標準
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        coding_rule/
      </td>
      <td>
        コーディング規約が格納されています。下記が含まれます。

        　・Javaコーディング規約

        　・Objective-Cコーディング規約

        　・JSPコーディング規約

        　・SQLコーディング規約

        　・javascriptコーディング規約

        　・シェルスクリプト開発標準
      </td>
    </tr>
    <tr>
      <td colspan="3">
        unit_test/
      </td>
      <td>
        単体テスト標準が格納されています。
      </td>
    </tr>
    <tr>
      <td colspan="3">
        document_standard_style/
      </td>
      <td>
        ドキュメント規約（設計書を記載する際のルールを定めたドキュメント）が格納されています。
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        document_format/
      </td>
      <td>
        設計書のフォーマットとサンプルが格納されています。

        詳細は当フォルダ内の「Nablarch設計ドキュメント解説書」を参照してください。
      </td>
    </tr>
    <tr>
      <td colspan="4" style="border-bottom:none; background-color:#ffffee">
        guide/
      </td>
      <td style="background-color:#ffffee">
        Nablarchガイドが格納されています。

      </td>
    </tr>
    <tr>
      <td rowspan="3" style="border-top:none; background-color:#ffffee">　</td>
      <td colspan="3">
        development_guide/
      </td>
      <td>
        Nablarch開発ガイドが格納されています。
        （<a href="./app_dev_guide/guide/development_guide/index.html">ドキュメントを開く</a>）
      </td>
    </tr>
    <tr>
      <td colspan="3" style="border-bottom:none">
        tutorial/
      </td>
      <td>
        基本的な業務アプリケーションの実装方法を示したチュートリアル用サンプルアプリケーションです。
      </td>
    </tr>
    <tr>
      <td style="border-top:none">　</td>
      <td colspan="2">
        チュートリアル用サンプルアプリケーション
      </td>
      <td>
        チュートリアル用サンプルのソースコードです。

        Eclipseのワークスペースの形式で提供します。

        （<a href="./app_dev_guide/guide/tutorial/Nablarch-tutorial-workspace.zip">ファイルを開く</a>）
      </td>
    </tr>
  </tbody>
</table>

### コンテンツの見方

Nablarchのコンテンツの見方を目的別に説明します。

* **Nablarchを使用したアプリケーション開発の全体像を知りたい**

[Nablarchを使用したシステム開発における標準WBS](./app_dev_guide/standard/dev_process_standard/Nablarchを使用したシステム開発における標準WBS.xls) を参照してください。

Nablarchの各コンテンツをどの工程でどのように使う想定であるかを解説しています。

* **Nablarch Application Framework、Nablarch Testing Frameworkを使用したプログラミングや単体テストの実施方法を知りたい**

1. [開発環境構築ガイド](./app_dev_env/app_dev/開発環境構築ガイド.doc) に従ってサンプルアプリケーションをインストールしてください。
  インストールに必要な資源は、 [開発環境パッケージ](./app_dev_env/app_dev/Nablarch-dev-env.zip) に含まれています。
2. [プログラミング・単体テストガイド](./app_dev_guide/guide/development_guide/index.html) に従って学習を進めてください。

* **Nablarch Application Frameworkの詳しい仕様を知りたい**

[Application Framework解説書](./app_exe_env/fw_doc/doc/index.html) を参照してください。

* **Nablarchを使用したアプリケーションの開発環境(CI環境、リポジトリ等)の構築方法を知りたい**

[開発リポジトリ構築ガイド](./app_dev_env/app_dev/開発リポジトリ構築ガイド.doc) を参照してください。

* **Nablarch Toolboxにどのようなツールがあるのかや、ツールの使い方を知りたい**

[Nablarch Toolbox解説書](./app_dev_env/toolbox/doc/index.html) を参照してください。
