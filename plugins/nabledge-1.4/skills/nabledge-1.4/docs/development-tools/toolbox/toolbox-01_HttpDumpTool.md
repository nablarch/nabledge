# リクエスト単体データ作成ツール

## 概要

## 概要

リクエスト単体テスト（画面オンライン処理）では、HTMLからのリクエストパラメータにあるキーと値をテストデータとして作成する必要がある。

このリクエストパラメータ作成を人手で実施すると、リクエストパラメータ名（form内のname属性）を写し間違える恐れがある。特に、登録画面などパラメータ数が多い画面ではその可能性が高くなる。

このような人手によるミスを解消するため、リクエスト単体テストで生成されたHTMLを使用して、次画面へのリクエストパラメータを作成できるツールを提供する。

> **参考**: リクエストパラメータのテストデータ記述方法については、リクエスト単体テストガイド（特に「リクエストパラメータ」の項）を参照。

<details>
<summary>keywords</summary>

リクエスト単体データ作成ツール, 概要, リクエスト単体テスト, 画面オンライン処理, リクエストパラメータ, name属性, 人為ミス防止, HttpDumpTool

</details>

## 特徴

## 特徴

本ツールでは、リクエスト単体テストで生成されたHTMLをブラウザで操作することで、次画面へのリクエストパラメータをExcel形式で取得できるようになっている。Webアプリケーションを操作するような感覚で直感的にテストデータが作成できる。

<details>
<summary>keywords</summary>

特徴, HTML操作, Excelファイル, 次画面リクエストパラメータ, Webアプリケーション操作, 直感的, テストデータ作成

</details>

## 前提条件

## 前提条件

- 開発環境構築ガイドに従って開発環境を構築済みであること。
- [02_SetUpHttpDumpTool](toolbox-02_SetUpHttpDumpTool.md) の [http_dump_tool_prerequisite](toolbox-02_SetUpHttpDumpTool.md) 参照

<details>
<summary>keywords</summary>

リクエスト単体データ作成ツール, 前提条件, 開発環境構築, HttpDumpTool, http_dump_tool_prerequisite

</details>

## 入力となるHTML生成

## 入力となるHTML生成

リクエスト単体テストを実行し、HTMLファイルを生成する。

> **注意**: 初期画面表示のリクエスト単体テスト用データのみ手動で用意する必要がある。初期画面表示リクエストはリクエストパラメータを含まないことがほとんどであるため、空のリクエストパラメータを作成すればよい。

<details>
<summary>keywords</summary>

HTML生成, リクエスト単体テスト, 初期画面表示, リクエストパラメータ, テストデータ作成

</details>

## ツール起動

## ツール起動

Eclipse上でHTMLファイルを右クリックしてツールを起動する（:ref:`howToExecuteFromEclipse` 参照）。

> **注意**: Windows上で本ツールを起動するとコマンドプロンプトが現れるが、これはツール内部の内蔵サーバのプロセスである。ツール使用中はこのコマンドプロンプトを維持すること。ツール起動時に既にサーバが起動されている場合はサーバ起動がスキップされ、2回目以降の起動が速くなる。誤ってコマンドプロンプトを終了しても、次回のツール起動時に自動的に再起動される。

<details>
<summary>keywords</summary>

ツール起動, Eclipse, 内蔵サーバ, Windows, コマンドプロンプト, howToExecuteFromEclipse

</details>

## データ入力

## データ入力

HTMLファイルがブラウザで起動されるので、ブラウザ上で画面入力を行いサブミットを実行する。

<details>
<summary>keywords</summary>

データ入力, ブラウザ, サブミット, HTMLファイル, 画面入力

</details>

## Excelダウンロード

## Excelダウンロード

サブミットで発生したHTTPリクエストがExcelファイルに記載された状態でダウンロードできる。Excelファイルをローカルに保存する必要はなく、ブラウザから直接ExcelやOpenOfficeで起動すればよい。

<details>
<summary>keywords</summary>

Excelダウンロード, HTTPリクエスト, OpenOffice, テストデータ, リクエストパラメータ取得

</details>

## データ編集

## データ編集

ダウンロードしたExcelファイルにHTTPリクエストパラメータのデータが記載されている。そのデータをリクエスト単体テストのテストデータにコピーする。

<details>
<summary>keywords</summary>

データ編集, リクエストパラメータ, テストデータ, Excel, コピー

</details>
