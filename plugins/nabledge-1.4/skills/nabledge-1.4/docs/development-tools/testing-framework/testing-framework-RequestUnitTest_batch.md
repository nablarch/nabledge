# リクエスト単体テスト（バッチ処理）

## 全体像

![リクエスト単体テスト（バッチ処理）クラス図](../../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_batch/batch_request_test_class.png)

主なクラスとリソース:

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき1つ |
| Excelファイル（テストデータ） | テーブルに格納する準備データや期待する結果、入力ファイルなどテストデータを記載する | テストクラスにつき1つ |
| `StandaloneTestSupportTemplate` | バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する | — |
| `BatchRequestTestSupport` | バッチリクエスト単体テストで必要となるテスト準備機能、各種アサートを提供する | — |
| `TestShot` | データシートに定義されたテストケース1件分の情報を格納するクラス | — |
| `MainForRequestTesting` | テスト用メインクラス。テスト実行時の差分を吸収する | — |
| `DbAccessTestSupport` | DB準備データ投入などデータベースを使用するテストに必要な機能を提供する | — |
| `FileSupport` | 入力ファイル作成などファイルを使用するテストに必要な機能を提供する | — |

<details>
<summary>keywords</summary>

クラス図, StandaloneTestSupportTemplate, BatchRequestTestSupport, TestShot, MainForRequestTesting, DbAccessTestSupport, FileSupport, バッチリクエスト単体テスト

</details>

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する。テストデータを読み取り、全テストショット（`TestShot`）を実行する。

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, テスト実行環境, TestShot, コンテナ外処理テスト, バッチテスト

</details>

## TestShot

**クラス**: `TestShot`

1テストショットの情報保持とテストショット実行を行う。テストショットは以下の要素で成り立つ:
1. 入力データの準備
2. メインクラス起動
3. 出力結果の確認

バッチやメッセージング処理などコンテナ外で動作する処理のテストで共通の準備処理・結果確認機能を提供する。

| 準備処理 | 結果確認 |
|---|---|
| データベースのセットアップ | データベース更新内容確認 |
| | ログ出力結果確認 |
| | ステータスコード確認 |

入力データ準備や結果確認ロジックはバッチや各種メッセージング処理ごとに異なるので、方式に応じたカスタマイズが可能となっている。

<details>
<summary>keywords</summary>

TestShot, テストショット, データベースセットアップ, ステータスコード確認, ログ出力確認

</details>

## BatchRequestTestSupport

**クラス**: `BatchRequestTestSupport`

バッチ処理テスト用のスーパークラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

`TestShot`が提供する準備処理・結果確認に以下を追加:

| 準備処理 | 結果確認 |
|---|---|
| 入力ファイルの作成 | 出力ファイルの内容確認 |

<details>
<summary>keywords</summary>

BatchRequestTestSupport, バッチテストスーパークラス, 入力ファイル作成, 出力ファイル確認, テストクラス継承

</details>

## MainForRequestTesting

**クラス**: `MainForRequestTesting`

リクエスト単体テスト用メインクラス。本番用メインクラスとの差異:
- テスト用コンポーネント設定ファイルからリポジトリを初期化する
- 常駐化機能を無効化する

<details>
<summary>keywords</summary>

MainForRequestTesting, テスト用メインクラス, 常駐化無効化, コンポーネント設定ファイル

</details>

## FileSupport

**クラス**: `FileSupport`

ファイルに関する操作を提供するクラス。主な機能:
- テストデータから入力ファイルを作成する
- テストデータの期待値と実際に出力されたファイルの内容を比較する

<details>
<summary>keywords</summary>

FileSupport, 入力ファイル作成, 出力ファイル比較, ファイル操作

</details>

## 固定長ファイル

基本的な記述方法は :ref:`batch_request_test` を参照。

**パディング**: フィールド長に対してデータのバイト長が短い場合、データ型に応じたパディングが行われる。アルゴリズムはNablarch Application Framework本体と同様。

**バイナリデータの記述方法**: 16進数形式でテストデータを記述する。

- `0x`プレフィックスあり → 16進数として解釈。例: `0x4AD` → `0x04AD`（2バイトのバイト配列）

> **注意**: `0x`プレフィックスがない場合、データは文字列とみなし、ディレクティブの文字コードでエンコードしてバイト配列に変換する。例: Windows-31Jのファイルでバイナリフィールドに`4AD`と記載した場合、`0x344144`（3バイト）に変換される

<details>
<summary>keywords</summary>

固定長ファイル, パディング, バイナリデータ, 16進数, 0xプレフィックス

</details>

## 可変長ファイル

可変長ファイルのテストデータの基本的な記述方法は :ref:`batch_request_test` を参照。

<details>
<summary>keywords</summary>

可変長ファイル, テストデータ, batch_request_test

</details>

## 常駐バッチのテスト用ハンドラ構成

常駐バッチのテスト時はプロダクション用ハンドラ構成をテスト用に変更する必要がある。

> **重要**: 変更を行わずにテストを実施した場合、テスト対象の常駐バッチアプリケーションの処理が終わらないため、テストが正常に実施できなくなる。

| 変更対象のハンドラ | 変更後のハンドラ | 変更理由 |
|---|---|---|
| `RequestThreadLoopHandler` | `OneShotLoopHandler` | `RequestThreadLoopHandler`でテストを実施するとバッチ実行が終わらずテストコードに制御が戻らなくなる。`OneShotLoopHandler`に差し替えることで、セットアップした要求データを全件処理後にバッチ実行が終了しテストコードに制御が戻る |

プロダクション用設定:

```xml
<component name="requestThreadLoopHandler" class="nablarch.fw.handler.RequestThreadLoopHandler">
  <!-- プロパティへの値設定は省略 -->
</component>
```

テスト用設定（同名コンポーネントで上書き）:

```xml
<component name="requestThreadLoopHandler" class="nablarch.test.OneShotLoopHandler" />
```

<details>
<summary>keywords</summary>

常駐バッチ, RequestThreadLoopHandler, OneShotLoopHandler, ハンドラ構成変更, テスト設定

</details>

## ディレクティブのデフォルト値

ファイルのディレクティブをコンポーネント設定ファイルに記載することで、個々のテストデータでのディレクティブ記述を省略できる。map形式で記載し、name属性のルールは以下の通り:

| 対象ファイル種別 | name属性 |
|---|---|
| 共通 | `defaultDirectives` |
| 固定長ファイル | `fixedLengthDirectives` |
| 可変長ファイル | `variableLengthDirectives` |

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

ディレクティブ, defaultDirectives, fixedLengthDirectives, variableLengthDirectives, デフォルト値設定

</details>
