# リクエスト単体データ作成ツール

**公式ドキュメント**: [リクエスト単体データ作成ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/01_HttpDumpTool/01_HttpDumpTool.html)

## 概要

リクエスト単体テスト（ウェブアプリケーション）では、HTMLからのリクエストパラメータにあるキーと値をテストデータとして作成する必要がある。このリクエストパラメータ作成を人手で実施すると、リクエストパラメータ名（form内のname属性）を写し間違える恐れがある。特に、登録画面などパラメータ数が多い画面ではその可能性が高くなる。

このような人手によるミスを解消するため、リクエスト単体テストで生成されたHTMLを使用して、次画面へのリクエストパラメータを作成できるツールを提供する。

<details>
<summary>keywords</summary>

概要, リクエスト単体データ作成ツール, リクエストパラメータ, name属性, 人手ミス解消, HTMLフォーム

</details>

## 特徴

本ツールでは、リクエスト単体テストで生成されたHTMLをブラウザで操作することで、次画面へのリクエストパラメータをExcel形式で取得できる。ウェブアプリケーションを操作するような感覚で直感的にテストデータが作成できる。

<details>
<summary>keywords</summary>

特徴, Excel形式, ブラウザ操作, テストデータ作成, 直感的操作

</details>

## 前提条件

- 開発環境構築ガイドに従い開発環境を構築済みであること
- [02_SetUpHttpDumpTool](testing-framework-02_SetUpHttpDumpTool.md) の :ref:`http_dump_tool_prerequisite` 参照

<details>
<summary>keywords</summary>

前提条件, 開発環境構築, HttpDumpTool, セットアップ, リクエスト単体データ作成ツール

</details>

## 入力となるHTML生成

リクエスト単体テストを実行してHTMLファイルを生成する。

初期画面表示用テストデータのみ手動作成が必要。初期画面表示リクエスト（メニューからの単純な画面遷移など）にはリクエストパラメータが含まれないことがほとんどのため、通常は空のリクエストパラメータを作成すればよい。

<details>
<summary>keywords</summary>

HTML生成, リクエスト単体テスト, 初期画面表示, リクエストパラメータ, テストデータ作成

</details>

## ツール起動

Eclipse上でHTMLファイルを右クリックしてツールを起動する（:ref:`howToExecuteFromEclipse` 参照）。

> **補足**: Windows上で起動するとコマンドプロンプトが現れるが、これはツール内部の内蔵サーバのプロセス。ツール使用中はこのコマンドプロンプトを実行したままにしておくこと。ツール起動時に既にサーバが起動済みの場合はサーバ起動がスキップされ、2回目以降の起動が速くなる。誤ってコマンドプロンプトを閉じても次回ツール起動時に自動起動されるため問題はない。

<details>
<summary>keywords</summary>

Eclipse, ツール起動, 内蔵サーバ, コマンドプロンプト, HttpDumpTool起動

</details>

## データ入力

HTMLファイルがブラウザで起動されるので、画面上で入力してサブミットを実行する。

<details>
<summary>keywords</summary>

データ入力, サブミット, ブラウザ, HTMLフォーム操作

</details>

## Excelダウンロード

サブミットで発生したHTTPリクエストがExcelファイルに記載された状態でダウンロードできる。Excelファイルはローカルに保存せず、ブラウザから直接ExcelまたはOpenOfficeで起動すればよい。

<details>
<summary>keywords</summary>

Excelダウンロード, HTTPリクエスト, OpenOffice, テストデータ出力, Excel形式

</details>

## データ編集

ダウンロードしたExcelファイルにHTTPリクエストパラメータのデータが記載されている。そのデータをリクエスト単体テストのテストデータにコピーする。

<details>
<summary>keywords</summary>

データ編集, テストデータ, リクエストパラメータ, コピー, リクエスト単体テスト

</details>
