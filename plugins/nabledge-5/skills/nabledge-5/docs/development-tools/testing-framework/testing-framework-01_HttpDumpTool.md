# リクエスト単体データ作成ツール

**公式ドキュメント**: [リクエスト単体データ作成ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/01_HttpDumpTool/01_HttpDumpTool.html)

## 概要

## 概要

リクエスト単体テスト（ウェブアプリケーション）では、HTMLからのリクエストパラメータにあるキーと値をテストデータとして作成する必要がある。このリクエストパラメータ作成を人手で実施すると、リクエストパラメータ名（form内のname属性）を写し間違える恐れがある。特に、登録画面などパラメータ数が多い画面ではその可能性が高くなる。

このような人手によるミスを解消するため、リクエスト単体テストで生成されたHTMLを使用して、次画面へのリクエストパラメータを作成できるツールを提供する。

<details>
<summary>keywords</summary>

概要, リクエストパラメータ作成, 人手によるミス解消, HttpDumpTool, リクエスト単体データ作成ツール

</details>

## 特徴

## 特徴

リクエスト単体テストで生成されたHTMLをブラウザで操作することで、次画面へのリクエストパラメータをExcel形式で取得できる。ウェブアプリケーションを操作するような感覚で直感的にテストデータが作成できる。

<details>
<summary>keywords</summary>

特徴, ブラウザ操作, Excel形式, 直感的テストデータ作成, リクエストパラメータ取得

</details>

## 使用方法

## 使用方法

下記の図に沿って、本ツールの使用方法を説明する。

![ツール使用フロー概要](../../../knowledge/development-tools/testing-framework/assets/testing-framework-01_HttpDumpTool/requestDumpToolAbstract.png)

<details>
<summary>keywords</summary>

使用方法, ツール使用フロー, フロー概要, HttpDumpTool, リクエスト単体データ作成ツール

</details>

## 前提条件

## 前提条件

- 開発環境構築ガイドに従って開発環境を構築済みであること。
- 詳細は [02_SetUpHttpDumpTool](testing-framework-02_SetUpHttpDumpTool.md) の [http_dump_tool_prerequisite](testing-framework-02_SetUpHttpDumpTool.md) を参照。

<details>
<summary>keywords</summary>

前提条件, 開発環境構築, HttpDumpTool, リクエスト単体データ作成ツール

</details>

## 入力となるHTML生成

## 入力となるHTML生成

リクエスト単体テストを実行し、HTMLファイルを生成する。

初期画面表示のリクエスト単体テスト用データのみ手動で用意する必要がある。初期画面表示リクエスト（メニューからの単純な画面遷移など）にはリクエストパラメータが含まれないことがほとんどのため、通常は空のリクエストパラメータを作成すればよい。

<details>
<summary>keywords</summary>

HTML生成, リクエスト単体テスト実行, 初期画面表示, リクエストパラメータ, 手動作成, テストデータ作成

</details>

## ツール起動

## ツール起動

Eclipse上からHTMLファイルを右クリックしてツールを起動する（:ref:`howToExecuteFromEclipse` 参照）。

> **補足**: Windows上での起動時に現れるコマンドプロンプトはツール内部の内蔵サーバプロセス。ツール使用中は起動したままにすること。既にサーバが起動済みの場合はサーバ起動がスキップされ2回目以降の起動が速くなる。誤って終了しても次回起動時に自動的に再起動されるため問題はない。

<details>
<summary>keywords</summary>

ツール起動, Eclipse, 内蔵サーバ, Windowsコマンドプロンプト, HttpDumpTool

</details>

## データ入力

## データ入力

HTMLファイルがブラウザで起動されるので、画面上で入力してサブミットを実行する。

<details>
<summary>keywords</summary>

データ入力, ブラウザ操作, サブミット, HTTPリクエスト

</details>

## Excelダウンロード

## Excelダウンロード

サブミットで発生したHTTPリクエストがExcelファイルに記載された状態でダウンロードできる。Excelファイルをローカルに保存する必要はなく、ブラウザから直接ExcelやOpenOfficeで開けばよい。

<details>
<summary>keywords</summary>

Excelダウンロード, HTTPリクエスト, OpenOffice, リクエストパラメータ取得

</details>

## データ編集

## データ編集

ダウンロードしたExcelファイルにHTTPリクエストパラメータのデータが記載されている。そのデータをリクエスト単体テストのテストデータにコピーする。

<details>
<summary>keywords</summary>

データ編集, テストデータ, リクエストパラメータ, Excelコピー

</details>
