# リクエスト単体テスト（バッチ処理）

## 概要・主なクラスとリソース

バッチをコマンドラインから起動したときの動作を擬似的に再現してテストを行う。

## 主なクラス・リソース

| クラス名 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき1つ |
| Excelファイル（テストデータ） | テーブル準備データ・期待結果・入力ファイルなどテストデータを記載 | テストクラスにつき1つ |
| `StandaloneTestSupportTemplate` | バッチ/メッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供 | — |
| `BatchRequestTestSupport` | バッチリクエスト単体テストのテスト準備機能・各種アサートを提供 | — |
| `TestShot` | データシートに定義されたテストケース1件分の情報を格納 | — |
| `MainForRequestTesting` | テスト用メインクラス。テスト実行時の差分を吸収する | — |
| `DbAccessTestSupport` | DB準備データ投入などデータベーステストに必要な機能を提供 | — |
| `FileSupport` | 入力ファイル作成などファイルテストに必要な機能を提供 | — |

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, BatchRequestTestSupport, TestShot, MainForRequestTesting, DbAccessTestSupport, FileSupport, バッチリクエスト単体テスト, テスト実行環境, テストデータ

</details>

## 構造: StandaloneTestSupportTemplate

バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する。テストデータを読み取り、全テストショット（`TestShot`）を実行する。

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, テスト実行環境, テストショット実行, コンテナ外, バッチ処理テスト, メッセージング処理テスト

</details>

## 構造: TestShot

1テストショットの情報保持とテストショット実行を行う。

テストショットは以下の要素で成り立っている:
1. 入力データの準備
2. メインクラス起動
3. 出力結果の確認

バッチやメッセージング処理などコンテナ外で動作する処理のテストにおいて共通の準備処理、結果確認機能を提供する。

| 準備処理 | 結果確認 |
|---|---|
| データベースのセットアップ | データベース更新内容確認 |
| | ログ出力結果確認 |
| | ステータスコード確認 |

入力データ準備や結果確認ロジックはバッチや各種メッセージング処理ごとに異なるのでカスタマイズが可能。

<details>
<summary>keywords</summary>

TestShot, テストショット, 入力データ準備, メインクラス起動, 出力結果確認, データベースセットアップ, ステータスコード確認, ログ出力確認, カスタマイズ

</details>

## 構造: BatchRequestTestSupport

バッチ処理テスト用のスーパクラス。アプリケーションプログラマはこのクラスを継承してテストクラスを作成する。

`TestShot` が提供する準備処理・結果確認に加えて以下の機能を提供する:

| 準備処理 | 結果確認 |
|---|---|
| 入力ファイルの作成 | 出力ファイルの内容確認 |

このクラスを使用することで、リクエスト単体テストのテストソース・テストデータを定型化でき、テストソース記述量を大きく削減できる。

<details>
<summary>keywords</summary>

BatchRequestTestSupport, テストクラス継承, 入力ファイル作成, 出力ファイル確認, バッチ処理テスト用スーパクラス

</details>

## 構造: MainForRequestTesting

リクエスト単体テスト用のメインクラス。本番用メインクラスとの主な差異:
- テスト用のコンポーネント設定ファイルからリポジトリを初期化する
- 常駐化機能を無効化する

<details>
<summary>keywords</summary>

MainForRequestTesting, テスト用メインクラス, 常駐化機能無効化, コンポーネント設定ファイル, リポジトリ初期化

</details>

## 構造: FileSupport

ファイルに関する操作を提供するクラス。主な機能:
- テストデータから入力ファイルを作成する
- テストデータの期待値と実際に出力されたファイルの内容を比較する

バッチ処理以外（例: ファイルダウンロード等）でも必要なため、独立したクラスとして提供している。

<details>
<summary>keywords</summary>

FileSupport, 入力ファイル作成, 出力ファイル比較, ファイルダウンロード, ファイル操作

</details>

## テストデータ: 固定長ファイル（パディング・バイナリデータ）

## パディング

フィールド長よりデータのバイト長が短い場合、データ型に応じたパディングが行われる。パディングのアルゴリズムはNablarch Application Framework本体と同様。

## バイナリデータの記述方法

バイナリデータを表現するには16進数形式でテストデータを記述する。例: `0x4AD` と記述した場合、`0x04AD` (2バイト) として解釈される。

> **注意**: プレフィックス0xが付与されていない場合、そのデータを文字列とみなし、ディレクティブの文字コードでエンコードしてバイト配列に変換する。例: 文字コードWindows-31Jのファイルでデータ型がバイナリのフィールドに `4AD` と記載した場合、`0x344144` (3バイト) に変換される。

<details>
<summary>keywords</summary>

固定長ファイル, パディング, バイナリデータ, 16進数, 0x, テストデータ記述方法, Windows-31J

</details>

## 各種設定値: ディレクティブのデフォルト値

コンポーネント設定ファイルにmap形式でデフォルトのディレクティブを記載することで、個々のテストデータでのディレクティブ記述を省略できる。

ネーミングルール:

| 対象ファイル種別 | name属性 |
|---|---|
| 共通 | `defaultDirectives` |
| 固定長ファイル | `fixedLengthDirectives` |
| 可変長ファイル | `variableLengthDirectives` |

設定例:

```xml
<!-- ディレクティブ（共通） -->
<map name="defaultDirectives">
  <entry key="text-encoding" value="Windows-31J" />
</map>

<!-- ディレクティブ（固定長） -->
<map name="fixedLengthDirectives">
  <entry key="record-separator" value="NONE"/>
</map>

<!-- ディレクティブ（可変長） -->
<map name="variableLengthDirectives">
  <entry key="quoting-delimiter" value="" />
  <entry key="record-separator" value="CRLF"/>
</map>
```

<details>
<summary>keywords</summary>

defaultDirectives, fixedLengthDirectives, variableLengthDirectives, ディレクティブ, コンポーネント設定ファイル, text-encoding, record-separator, quoting-delimiter

</details>
