# リクエスト単体テスト（メッセージ受信処理）

## 概要

要求電文1件を受信したときの動作を擬似的に再現してテストを行う。

![リクエスト単体テストのクラス構成](../../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_real/real_request_test_class.png)

<details>
<summary>keywords</summary>

リクエスト単体テスト, メッセージ受信処理, テストクラス構成図, 要求電文受信テスト

</details>

## 主なクラス・リソース

| クラス/リソース | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき1つ |
| Excelファイル（テストデータ） | テーブルに格納する準備データや期待する結果、入力ファイルなどテストデータを記載する | テストクラスにつき1つ |
| `StandaloneTestSupportTemplate` | バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する | — |
| `MessagingRequestTestSupport` | 同期応答メッセージ受信処理のリクエスト単体テストで必要となるテスト準備機能・各種アサートを提供する | — |
| `MessagingReceiveTestSupport` | 応答不要メッセージ受信処理のリクエスト単体テストで必要となるテスト準備機能・各種アサートを提供する | — |
| `TestShot` | データシートに定義されたテストケース1件分の情報を格納する | — |
| `MainForRequestTesting` | テスト用メインクラス。テスト実行時の差分を吸収する | — |
| `DbAccessTestSupport` | DB準備データ投入などデータベースを使用するテストに必要な機能を提供する | — |
| `MQSupport` | 電文作成などメッセージングのテストに必要な機能を提供する | — |

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, MessagingReceiveTestSupport, StandaloneTestSupportTemplate, TestShot, MainForRequestTesting, DbAccessTestSupport, MQSupport, リクエスト単体テストクラス, Excelファイル, テストデータ

</details>

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する。テストデータを読み取り、全 `TestShot` を実行する。

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, テスト実行環境, コンテナ外処理テスト, TestShot実行

</details>

## TestShot

**クラス**: `TestShot`

1テストショットの情報保持とテストショット実行を行う。テストショットの構成要素: 入力データの準備、メインクラス起動、出力結果の確認。

共通の準備処理・結果確認機能:

| 準備処理 | 結果確認 |
|---|---|
| データベースのセットアップ | データベース更新内容確認 |
|  | ログ出力結果確認 |
|  | ステータスコード確認 |

入力データ準備や結果確認ロジックはバッチや各種メッセージング処理ごとに異なるので、方式に応じたカスタマイズが可能となっている。

<details>
<summary>keywords</summary>

TestShot, テストショット, データベースセットアップ, ログ出力確認, ステータスコード確認, 入力データ準備, 出力結果確認, カスタマイズ

</details>

## MessagingRequestTestSupport

**クラス**: `MessagingRequestTestSupport`

同期応答メッセージ受信処理テスト用のスーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

`TestShot` の準備処理・結果確認に以下を追加する:

| 準備処理 | 結果確認 |
|---|---|
| 要求電文の作成 | 応答電文の内容確認 |

> **注意**: 本クラスはmain側のコンポーネント定義ファイルを読み込む（入力データをキューにPUTするため）。`nablarch.fw.messaging.FwHeaderDefinition` 実装クラスは `fwHeaderDefinition` という名前で登録されていなければならない。別の名称を使用する場合は `getFwHeaderDefinitionName()` をオーバーライドすることにより変更できる。

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, 同期応答メッセージ受信, FwHeaderDefinition, fwHeaderDefinition, getFwHeaderDefinitionName, 応答電文確認, 要求電文作成

</details>

## MessagingReceiveTestSupport

**クラス**: `MessagingReceiveTestSupport`

応答不要メッセージ処理テスト用のスーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

`TestShot` の準備処理に以下を追加する:

| 準備処理 |
|---|
| 要求電文の作成 |

<details>
<summary>keywords</summary>

MessagingReceiveTestSupport, 応答不要メッセージ受信, 要求電文作成

</details>

## MainForRequestTesting

**クラス**: `MainForRequestTesting`

リクエスト単体テスト用のメインクラス。本番用メインクラスとの主な差異:
- テスト用のコンポーネント設定ファイルからリポジトリを初期化する
- 常駐化機能を無効化する

<details>
<summary>keywords</summary>

MainForRequestTesting, テスト用メインクラス, 常駐化無効, テスト用コンポーネント設定ファイル

</details>

## MQSupport

**クラス**: `MQSupport`

メッセージに関する操作を提供するクラス。主な機能:
- テストデータから要求電文を作成し、受信キューにPUTする
- 応答電文を送信キューからGETし、テストデータの期待値と内容を比較する

<details>
<summary>keywords</summary>

MQSupport, 受信キュー, 送信キュー, 要求電文PUT, 応答電文GET, 電文作成

</details>

## テストデータ（メッセージ）

> **注意**: メッセージのパディングおよびバイナリデータの扱いは :ref:`about_fixed_length_file` と同様である。

<details>
<summary>keywords</summary>

テストデータ, メッセージ, パディング, バイナリデータ, about_fixed_length_file

</details>
