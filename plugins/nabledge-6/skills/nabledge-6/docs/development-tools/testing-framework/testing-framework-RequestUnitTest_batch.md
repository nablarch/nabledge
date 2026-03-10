# リクエスト単体テスト（バッチ処理）

## 概要

リクエスト単体テスト（バッチ処理）では、実際にバッチをコマンドラインから起動したときの動作を擬似的に再現し、テストを行う。

## 全体像

![バッチリクエスト単体テストクラス構成図](../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_batch/batch_request_test_class.png)

## 主なクラス・リソース一覧

バッチリクエスト単体テストを構成する主なクラスとリソース:

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ作成 |
| Excelファイル（テストデータ） | テーブルに格納する準備データや期待する結果、入力ファイルなど、テストデータを記載する | テストクラスにつき１つ作成 |
| StandaloneTestSupportTemplate | バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する | － |
| BatchRequestTestSupport | バッチリクエスト単体テストで必要となるテスト準備機能、各種アサートを提供する | － |
| TestShot | データシートに定義されたテストケース1件分の情報を格納するクラス | － |
| MainForRequestTesting | テスト用メインクラス。テスト実行時の差分を吸収する | － |
| DbAccessTestSupport | DB準備データ投入などデータベースを使用するテストに必要な機能を提供する | － |
| FileSupport | 入力ファイル作成などファイルを使用するテストに必要な機能を提供する | － |

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

バッチ・メッセージング処理など、コンテナ外で動作する処理のテスト実行環境を提供する。テストデータを読み取り、全 `TestShot` を実行する。

## TestShot

**クラス**: `TestShot`

1テストショットの情報保持とテスト実行を担うクラス。テストショットは以下の3要素で構成される:
1. 入力データの準備
2. メインクラス起動
3. 出力結果の確認

| 準備処理 | 結果確認 |
|---|---|
| データベースのセットアップ | データベース更新内容確認 |
| | ログ出力結果確認 |
| | ステータスコード確認 |

入力データ準備や結果確認ロジックはバッチや各種メッセージング処理ごとに異なるので、方式に応じたカスタマイズが可能となっている。

## BatchRequestTestSupport

**クラス**: `BatchRequestTestSupport`

バッチ処理テスト用スーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。`TestShot` の準備処理・結果確認に加え、以下の機能を提供する:

| 準備処理 | 結果確認 |
|---|---|
| 入力ファイルの作成 | 出力ファイルの内容確認 |

本クラスを使用することで、リクエスト単体テストのテストソース、テストデータを定型化でき、テストソース記述量を大きく削減できる。

具体的な使用方法は [../05_UnitTestGuide/02_RequestUnitTest/batch](testing-framework-batch.md) を参照。

## MainForRequestTesting

**クラス**: `MainForRequestTesting`

リクエスト単体テスト用メインクラス。本番用メインクラスとの差異:
- テスト用コンポーネント設定ファイルからシステムリポジトリを初期化する
- 常駐化機能を無効化する

## DbAccessTestSupport

**クラス**: `DbAccessTestSupport`

DB準備データ投入などデータベースを使用するテストに必要な機能を提供するクラス。

## FileSupport

**クラス**: `FileSupport`

ファイル操作を提供するクラス（バッチ処理以外でも使用可能）:
- テストデータから入力ファイルを作成する
- テストデータの期待値と実際に出力されたファイルの内容を比較する

## 固定長ファイル

基本的な記述方法は :ref:`batch_request_test` を参照。

**パディング**: フィールド長よりデータのバイト長が短い場合、データ型に応じたパディングが行われる（Nablarch Application Framework本体と同アルゴリズム）。

**バイナリデータ**: 16進数形式（`0x`プレフィックス付き）で記述する。例：`0x4AD` → 2バイトのバイト配列 `0x04AD`。

> **補足**: `0x`プレフィックスなしの場合は文字列とみなし、ディレクティブの文字コードでエンコードしてバイト配列に変換される。例：文字コードWindows-31Jで`4AD`と記載した場合、`0x344144`（3バイト）に変換される。

## 可変長ファイル

可変長ファイルのテストデータの基本的な記述方法は :ref:`batch_request_test` を参照。

## 常駐バッチのテスト用ハンドラ構成

> **重要**: 常駐バッチのテスト時は、プロダクション用ハンドラ構成をテスト用に変更すること。変更しないとバッチ実行が終わらず、テストコードに制御が戻らなくなる。

| 変更対象ハンドラ | 変更後ハンドラ | 変更理由 |
|---|---|---|
| `RequestThreadLoopHandler` | `OneShotLoopHandler` | RequestThreadLoopHandlerではバッチ実行が終わらないため。OneShotLoopHandlerに差し替えることで、セットアップした要求データを全件処理後にバッチが終了しテストコードに制御が戻る |

プロダクション用設定:
```xml
<component name="requestThreadLoopHandler" class="nablarch.fw.handler.RequestThreadLoopHandler">
  <!-- プロパティへの値設定は省略 -->
</component>
```

テスト用設定（プロダクション用と同名コンポーネントで上書き）:
```xml
<component name="requestThreadLoopHandler" class="nablarch.test.OneShotLoopHandler" />
```

## ディレクティブのデフォルト値

ファイルのディレクティブがシステム内で統一されている場合、コンポーネント設定ファイルにmap形式でデフォルト値を設定することで、個々のテストデータでのディレクティブ記述を省略できる。

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
