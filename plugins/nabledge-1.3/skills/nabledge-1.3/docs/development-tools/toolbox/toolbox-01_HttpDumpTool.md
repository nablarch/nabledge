# リクエスト単体データ作成ツール

## 概要と特徴

## 概要と特徴

リクエスト単体テスト（画面オンライン処理）で次画面へのリクエストパラメータをExcel形式で取得するツール。リクエスト単体テストで生成されたHTMLをブラウザで操作し、HTTPリクエストパラメータをExcelファイルとしてダウンロードできる。

リクエストパラメータのテストデータ記述方法は [../../05_UnitTestGuide/02_RequestUnitTest/index](../testing-framework/testing-framework-02_RequestUnitTest.md)（特に :ref:`request_test_req_params`）を参照。

<details>
<summary>keywords</summary>

リクエスト単体テスト, リクエストパラメータ作成, Excel出力, テストデータ作成, HttpDumpTool, 画面オンライン処理

</details>

## 使用方法

## 使用方法

### 前提条件

- 開発環境構築ガイドに従って開発環境を構築済みであること
- [02_SetUpHttpDumpTool](toolbox-02_SetUpHttpDumpTool.md) の [http_dump_tool_prerequisite](toolbox-02_SetUpHttpDumpTool.md) を参照

### 手順

1. **HTML生成**: リクエスト単体テストを実行してHTMLファイルを生成する
   - 初期画面表示のリクエスト単体テスト用データのみ手動作成が必要（通常は空のリクエストパラメータを作成する）
2. **ツール起動**: EclipseでHTMLファイルを右クリックしてツールを起動（:ref:`howToExecuteFromEclipse` 参照）
3. **データ入力**: ブラウザで開かれたHTMLで画面入力を行いサブミットを実行する
4. **Excelダウンロード**: サブミットで発生したHTTPリクエストパラメータが記載されたExcelファイルをダウンロードする（ローカル保存不要。ブラウザから直接ExcelまたはOpenOfficeで開けばよい）
5. **データ編集**: ExcelのHTTPリクエストパラメータをリクエスト単体テストのテストデータにコピーする

> **注意**: Windows上でツール起動時にコマンドプロンプトが現れるが、これは内蔵サーバのプロセス。ツール使用中は実行したままにすること。既にサーバが起動中の場合はスキップされる（2回目以降の起動が速くなる）。誤ってコマンドプロンプトを閉じてしまっても、次回のツール起動時に自動的に起動されるので問題はない。

<details>
<summary>keywords</summary>

Eclipse, HTML生成, Excelダウンロード, ツール起動手順, 内蔵サーバ, データ入力, howToExecuteFromEclipse, http_dump_tool_prerequisite, 開発環境構築ガイド

</details>
