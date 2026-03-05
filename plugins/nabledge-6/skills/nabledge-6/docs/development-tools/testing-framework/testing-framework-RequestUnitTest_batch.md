# リクエスト単体テスト（バッチ処理）

## 全体像

リクエスト単体テスト（バッチ処理）では、実際にバッチをコマンドラインから起動したときの動作を擬似的に再現し、テストを行う。

![バッチリクエスト単体テストのクラス図](../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_batch/batch_request_test_class.png)

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき1つ |
| Excelファイル（テストデータ） | テーブルの準備データ、期待結果、入力ファイル等のテストデータを記載 | テストクラスにつき1つ |
| StandaloneTestSupportTemplate | バッチやメッセージング処理等コンテナ外で動作する処理のテスト実行環境を提供 | — |
| BatchRequestTestSupport | バッチリクエスト単体テストのテスト準備機能、各種アサートを提供 | — |
| TestShot | データシートに定義されたテストケース1件分の情報を格納 | — |
| MainForRequestTesting | テスト用メインクラス。テスト実行時の差分を吸収 | — |
| DbAccessTestSupport | DB準備データ投入等データベースを使用するテストに必要な機能を提供 | — |
| FileSupport | 入力ファイル作成等ファイルを使用するテストに必要な機能を提供 | — |

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

バッチやメッセージング処理等コンテナ外で動作する処理のテスト実行環境を提供する。テストデータを読み取り、全テストショット([TestShot](#test-shot))を実行する。

## TestShot

**クラス**: `TestShot`

1テストショットの情報保持とテストショットを実行する。テストショットは以下の要素で成り立つ：

- 入力データの準備
- メインクラス起動
- 出力結果の確認

バッチやメッセージング処理等コンテナ外で動作する処理のテストにおいて共通の準備処理、結果確認機能を提供する。

**準備処理**: データベースのセットアップ

**結果確認**: データベース更新内容確認、ログ出力結果確認、ステータスコード確認

入力データ準備や結果確認ロジックはバッチや各種メッセージング処理ごとに異なるため、方式に応じたカスタマイズが可能。

## BatchRequestTestSupport

**クラス**: `BatchRequestTestSupport`

バッチ処理テスト用のスーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

本クラスは[TestShot](#test-shot)が提供する準備処理、結果確認に以下の機能を追加する：

**準備処理**: 入力ファイルの作成

**結果確認**: 出力ファイルの内容確認

本クラスを使用することで、リクエスト単体テストのテストソース、テストデータを定型化でき、テストソース記述量を大きく削減できる。

具体的な使用方法は :doc:`../05_UnitTestGuide/02_RequestUnitTest/batch` を参照。

## MainForRequestTesting

**クラス**: `MainForRequestTesting`

リクエスト単体テスト用のメインクラス。本番用メインクラスとの主な差異：

- テスト用のコンポーネント設定ファイルからシステムリポジトリを初期化
- 常駐化機能を無効化

## FileSupport

**クラス**: `FileSupport`

ファイルに関する操作を提供するクラス。主に以下の機能を提供：

- テストデータから入力ファイルを作成
- テストデータの期待値と実際に出力されたファイルの内容を比較

ファイルに関する操作はバッチ処理以外でも必要となるため（例: ファイルダウンロード等）、独立したクラスとして提供。

## 固定長ファイル

**基本的な記述方法**: :ref:`batch_request_test` を参照

#### パディング

指定したフィールド長に対してデータのバイト長が短い場合、そのフィールドのデータ型に応じたパディングが行われる。

#### バイナリデータの記述方法

バイナリデータを表現するには、16進数形式でテストデータを記述する。例: `0x4AD` → `0000 0100 1010 1101` (`0x04AD`) という2バイトのバイト配列に解釈される。

> **補足**: テストデータにプレフィックス0xが付与されていない場合、そのデータを文字列とみなし、その文字列をディレクティブの文字コードでエンコードしてバイト配列に変換する。例: 文字コードがWindows-31Jのファイルで、データ型がバイナリのフィールドに `4AD` と記載した場合、`0011 0100 0100 0001 0100 0100` (`0x344144`) という3バイトのバイト配列に変換される。

## 可変長ファイル

**基本的な記述方法**: :ref:`batch_request_test` を参照

## 常駐バッチのテスト用ハンドラ構成

常駐バッチのテストを実施する際には、プロダクション用ハンドラ構成をテスト用に変更する必要がある。この変更をせずにテストを実施した場合、テスト対象の常駐バッチアプリケーションの処理が終わらないため、テストが正常に実施できなくなる。

| 変更対象のハンドラ | 変更後のハンドラ | 変更理由 |
|---|---|---|
| RequestThreadLoopHandler | OneShotLoopHandler | RequestThreadLoopHandlerでテストを実施すると、バッチ実行が終わらずにテストコードに制御が戻らなくなるため。OneShotLoopHandlerにハンドラを差し替えることで、テスト実行前にセットアップした要求データを全件処理後にバッチ実行が終了しテストコードに制御が戻るようになる。 |

**プロダクション用設定**:
```xml
<!-- リクエストスレッドループ -->
<component name="requestThreadLoopHandler" class="nablarch.fw.handler.RequestThreadLoopHandler">
  <!-- プロパティへの値設定は省略 -->
</component>
```

**テスト用設定** (プロダクション用設定と同名でコンポーネントを設定し、テスト用のハンドラを使用するように上書き):
```xml
<!-- リクエストスレッドループハンドラをテスト用のハンドラに置き換える設定 -->
<component name="requestThreadLoopHandler" class="nablarch.test.OneShotLoopHandler" />
```

## ディレクティブのデフォルト値

ファイルのディレクティブがシステム内である程度統一されている場合、個々のテストデータに同じディレクティブを記載することは冗長である。デフォルトのディレクティブをコンポーネント設定ファイルに記載することで、個々のテストデータではディレクティブの記述を省略できる。

コンポーネント設定ファイルにmap形式で記載する。

| 対象となるファイル種別 | name属性 |
|---|---|
| 共通 | defaultDirectives |
| 固定長ファイル | fixedLengthDirectives |
| 可変長ファイル | variableLengthDirectives |

**設定例**:
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
