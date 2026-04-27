# リクエスト単体データ作成ツール

## 概要

リクエスト単体テスト(ウェブアプリケーション)では、HTMLからのリクエストパラメータにあるキーと値をテストデータとして作成する必要がある [*] 。
このリクエストパラメータ作成を人手で実施すると、リクエストパラメータ名（form内のname属性）を
写し間違える恐れがある。特に、登録画面などパラメータ数が多い画面ではその可能性が高くなる。

このような人手によるミスを解消するため、リクエスト単体テストで生成されたHTMLを使用して、
次画面へのリクエストパラメータを作成できるツールを提供する。

リクエストパラメータのテストデータ記述方法については、 [リクエスト単体テストの実施方法](../../development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest.md) （特に「  [リクエストパラメータ](../../development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest.md#request-test-req-params) 」の項 ）を参照

## 特徴

本ツールでは、リクエスト単体テストで生成されたHTMLをブラウザで操作することで、
次画面へのリクエストパラメータをExcel形式で取得できるようになっている。
ウェブアプリケーションを操作するような感覚で直感的にテストデータが作成できる。

## 使用方法

下記の図に沿って、本ツールの使用方法を説明する。

![requestDumpToolAbstract.png](../../../knowledge/assets/testing-framework-01-HttpDumpTool/requestDumpToolAbstract.png)

### 前提条件

* 開発環境構築ガイドに従って開発環境を構築済みであること。
* [リクエスト単体データ作成ツール インストールガイド](../../development-tools/testing-framework/testing-framework-02-SetUpHttpDumpTool.md) の [前提事項](../../development-tools/testing-framework/testing-framework-02-SetUpHttpDumpTool.md#http-dump-tool-prerequisite) 参照

### 入力となるHTML生成

リクエスト単体テストを実行し、HTMLファイルを生成する。

初期画面表示のリクエスト単体テスト用データだけは、手動で用意する必要がある。
初期画面表示リクエスト（例えば、メニューからの単純な画面遷移）には
リクエストパラメータが含まれていないことがほとんどであるので、
通常は空のリクエストパラメータを作成すればよい。

### ツール起動

Eclipse上からHTMLファイルを右クリックし、ツールを起動する。
（ [HTMLファイルからの起動方法](../../development-tools/testing-framework/testing-framework-02-SetUpHttpDumpTool.md#howtoexecutefromeclipse) を参照）

> **Tip:**
> Windows上で本ツールを起動するとコマンドプロンプトが現れるが、これはツール内部で使用される内蔵サーバのプロセスである。本ツールを使用する間はこのコマンドプロンプトは実行したままにしておくとよい。ツール起動時に、既にサーバが起動されている場合はサーバ起動がスキップされるので、２回目以降のツール起動が速くなる。誤ってこのコマンドプロンプトを落としてしまっても、次回のツール起動時に自動的に起動されるので問題はない。

### データ入力

HTMLファイルがブラウザで起動されるので、画面上で入力してサブミットを実行する。

### Excelダウンロード

サブミットで発生したHTTPリクエストがExcelファイルに記載された状態で
ダウンロードできる。Excelファイルをローカル上に保存する必要はないので、
ブラウザから直接ExcelやOpenOfficeで起動すればよい。

### データ編集

ダウンロードしたExcelファイルに、HTTPリクエストパラメータのデータが記載されている。
そのデータをリクエスト単体テストのテストデータにコピーする。
