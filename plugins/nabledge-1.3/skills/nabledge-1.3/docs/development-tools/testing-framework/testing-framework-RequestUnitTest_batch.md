# リクエスト単体テスト（バッチ処理）

## 概要

バッチをコマンドラインから起動したときの動作を擬似的に再現してテストを行う。

![バッチリクエスト単体テスト クラス構成](../../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_batch/batch_request_test_class.png)

<details>
<summary>keywords</summary>

バッチリクエスト単体テスト, コマンドライン起動, 動作再現

</details>

## 主なクラス・リソース

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象Actionにつき1つ |
| Excelファイル（テストデータ） | テーブルの準備データ・期待結果・入力ファイルなどテストデータを記載する | テストクラスにつき1つ |
| `StandaloneTestSupportTemplate` | コンテナ外で動作する処理（バッチ・メッセージング等）のテスト実行環境を提供する | — |
| `BatchRequestTestSupport` | バッチリクエスト単体テストに必要なテスト準備機能・各種アサートを提供する | — |
| `TestShot` | データシートに定義されたテストケース1件分の情報を格納するクラス | — |
| `MainForRequestTesting` | テスト用メインクラス。テスト実行時の差分を吸収する | — |
| `DbAccessTestSupport` | DB準備データ投入などデータベースを使用するテストに必要な機能を提供する | — |
| `FileSupport` | 入力ファイル作成などファイルを使用するテストに必要な機能を提供する | — |

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, BatchRequestTestSupport, TestShot, MainForRequestTesting, DbAccessTestSupport, FileSupport, テストクラス作成単位, Excelファイル

</details>

## 構造

**StandaloneTestSupportTemplate**: テストデータを読み取り、全`TestShot`を実行するテスト実行環境。

**TestShot**: 1テストショットの情報保持と実行を担当。提供する準備処理・結果確認:

| 準備処理 | 結果確認 |
|---|---|
| データベースのセットアップ | データベース更新内容確認 |
| | ログ出力結果確認 |
| | ステータスコード確認 |

入力データ準備・結果確認ロジックはバッチ・各種メッセージング処理ごとに異なるためカスタマイズ可能。

**BatchRequestTestSupport**: バッチ処理テスト用スーパクラス。テストクラスは本クラスを継承して作成する。`TestShot`の準備処理・結果確認に以下を追加する:

| 準備処理 | 結果確認 |
|---|---|
| 入力ファイルの作成 | 出力ファイルの内容確認 |

本クラスを使用することで、リクエスト単体テストのテストソース・テストデータを定型化でき、テストソース記述量を大きく削減できる。

詳細は [../05_UnitTestGuide/02_RequestUnitTest/batch](testing-framework-batch.md) を参照。

**MainForRequestTesting**: リクエスト単体テスト用メインクラス。本番用との主な差異:
- テスト用コンポーネント設定ファイルからリポジトリを初期化する
- 常駐化機能を無効化する

**FileSupport**: ファイル操作クラス（バッチ処理以外でも使用可能）。主な機能:
- テストデータから入力ファイルを作成する
- テストデータの期待値と実際の出力ファイルの内容を比較する

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, BatchRequestTestSupport, TestShot, MainForRequestTesting, FileSupport, テストショット, 準備処理, 結果確認, 常駐化無効

</details>

## テストデータ

固定長ファイル・可変長ファイルの基本的な記述方法は :ref:`batch_request_test` を参照。

**固定長ファイル — パディング**: 指定フィールド長に対してデータのバイト長が短い場合、データ型に応じたパディングが行われる。アルゴリズムはNablarch Application Framework本体と同様。

**固定長ファイル — バイナリデータ**: バイナリデータは`0x`プレフィックス付きの16進数形式で記述する。例: `0x4AD` → 2バイトのバイト配列`0x04AD`。

> **注意**: `0x`プレフィックスがない場合、そのデータを文字列とみなしディレクティブの文字コードでエンコードしてバイト配列に変換する。例: 文字コードWindows-31Jのファイルでバイナリフィールドに`4AD`と記載した場合、`0x344144`（3バイト）に変換される。

<details>
<summary>keywords</summary>

固定長ファイル, 可変長ファイル, パディング, バイナリデータ, 16進数形式

</details>

## 各種設定値

**常駐バッチのテスト用ハンドラ構成**

> **重要**: 常駐バッチのテストでは、プロダクション用ハンドラ構成をテスト用に変更する必要がある。変更しない場合、テスト対象のバッチ処理が終わらずテストコードに制御が戻らなくなる。

| 変更対象のハンドラ | 変更後のハンドラ | 変更理由 |
|---|---|---|
| `RequestThreadLoopHandler` | `OneShotLoopHandler` | `RequestThreadLoopHandler`でテストを実施するとバッチ実行が終わらずテストコードに制御が戻らないため。`OneShotLoopHandler`に差し替えることで、セットアップした要求データを全件処理後にバッチ終了しテストコードに制御が戻る |

プロダクション用設定例:

```xml
<!-- リクエストスレッドループ -->
<component name="requestThreadLoopHandler" class="nablarch.fw.handler.RequestThreadLoopHandler">
  <!-- プロパティへの値設定は省略 -->
</component>
```

テスト用設定例（プロダクション用と同名でコンポーネントを上書き）:

```xml
<!-- リクエストスレッドループハンドラをテスト用のハンドラに置き換える設定 -->
<component name="requestThreadLoopHandler" class="nablarch.test.OneShotLoopHandler" />
```

**ディレクティブのデフォルト値**

システム内でディレクティブが統一されている場合、コンポーネント設定ファイルにデフォルト値を記載することで個々のテストデータでのディレクティブ記述を省略できる。

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
<map name="variableLengthDirectives">
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

RequestThreadLoopHandler, OneShotLoopHandler, nablarch.fw.handler.RequestThreadLoopHandler, 常駐バッチ, ハンドラ置き換え, defaultDirectives, fixedLengthDirectives, variableLengthDirectives, ディレクティブデフォルト値

</details>
