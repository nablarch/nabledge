# リクエスト単体テスト（メッセージ受信処理）

## 概要

メッセージ受信処理のリクエスト単体テストでは、要求電文1件を受信したときの動作を擬似的に再現し、テストを行う。

![テストクラス全体像](../../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_real/real_request_test_class.png)

<details>
<summary>keywords</summary>

リクエスト単体テスト, メッセージ受信処理, 要求電文, テスト実行

</details>

## 主なクラス・リソース

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき1つ |
| Excelファイル（テストデータ） | 準備データ、期待結果、入力ファイルなどを記載する | テストクラスにつき1つ |
| `StandaloneTestSupportTemplate` | コンテナ外で動作する処理のテスト実行環境を提供する | ー |
| `MessagingRequestTestSupport` | 同期応答メッセージ受信処理のリクエスト単体テスト用テスト準備・アサート機能を提供する | ー |
| `MessagingReceiveTestSupport` | 応答不要メッセージ受信処理のリクエスト単体テスト用テスト準備・アサート機能を提供する | ー |
| `TestShot` | データシート定義のテストケース1件分の情報を格納するクラス | ー |
| `MainForRequestTesting` | テスト用メインクラス。テスト実行時の差分を吸収する | ー |
| `DbAccessTestSupport` | DB準備データ投入などデータベース使用テストに必要な機能を提供する | ー |
| `MQSupport` | 電文作成などメッセージングテストに必要な機能を提供する | ー |

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, MessagingRequestTestSupport, MessagingReceiveTestSupport, TestShot, MainForRequestTesting, DbAccessTestSupport, MQSupport, テストクラス構成

</details>

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する。テストデータを読み取り、全`TestShot`を実行する。

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, コンテナ外テスト, テスト実行環境, TestShot

</details>

## TestShot

**クラス**: `TestShot`

1テストショットの情報保持とテストショット実行を担う。

テストショットの構成要素:
1. 入力データの準備
2. メインクラス起動
3. 出力結果の確認

提供する準備処理・結果確認機能:

| 準備処理 | 結果確認 |
|---|---|
| データベースのセットアップ | データベース更新内容確認 |
| | ログ出力結果確認 |
| | ステータスコード確認 |

入力データ準備や結果確認ロジックはバッチや各種メッセージング処理ごとに異なるため、方式に応じたカスタマイズが可能。

<details>
<summary>keywords</summary>

TestShot, テストショット, データベースセットアップ, ログ出力確認, ステータスコード確認

</details>

## MessagingRequestTestSupport

**クラス**: `MessagingRequestTestSupport`

同期応答メッセージ受信処理テスト用のスーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

本クラスを使用することで、リクエスト単体テストのテストソース、テストデータを定型化でき、テストソース記述量を大きく削減できる。

`TestShot`が提供する準備処理・結果確認に追加する機能:

| 準備処理 | 結果確認 |
|---|---|
| 要求電文の作成 | 応答電文の内容確認 |

> **注意**: 本クラスは入力データをキューにPUTする用途でmain側のコンポーネント定義ファイルを読み込む。`nablarch.fw.messaging.FwHeaderDefinition`実装クラスは`fwHeaderDefinition`という名前で登録されていなければならない。別の名前を使用する場合は`getFwHeaderDefinitionName()`をオーバライドして変更できる。

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, 同期応答メッセージ, FwHeaderDefinition, fwHeaderDefinition, getFwHeaderDefinitionName, 要求電文作成, 応答電文確認

</details>

## MessagingReceiveTestSupport

**クラス**: `MessagingReceiveTestSupport`

応答不要メッセージ処理テスト用のスーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

本クラスを使用することで、リクエスト単体テストのテストソース、テストデータを定型化でき、テストソース記述量を大きく削減できる。

`TestShot`が提供する準備処理に追加する機能:

| 準備処理 |
|---|
| 要求電文の作成 |

<details>
<summary>keywords</summary>

MessagingReceiveTestSupport, 応答不要メッセージ, 要求電文作成

</details>

## MainForRequestTesting

**クラス**: `MainForRequestTesting`

リクエスト単体テスト用のメインクラス。本番用メインクラスとの主な差異:
- テスト用のコンポーネント設定ファイルからリポジトリを初期化する
- 常駐化機能を無効化する

<details>
<summary>keywords</summary>

MainForRequestTesting, テスト用メインクラス, 常駐化無効化, コンポーネント設定ファイル

</details>

## MQSupport

**クラス**: `MQSupport`

メッセージに関する操作を提供するクラス。主な機能:
- テストデータから要求電文を作成し、受信キューにPUTする
- 応答電文を送信キューからGETし、テストデータの期待値と内容を比較する

<details>
<summary>keywords</summary>

MQSupport, 要求電文作成, 受信キュー, 送信キュー, メッセージング

</details>

## テストデータ（メッセージ）

> **注意**: パディングおよびバイナリデータの扱いは、:ref:`about_fixed_length_file` と同様である。

<details>
<summary>keywords</summary>

テストデータ, メッセージ, パディング, バイナリデータ, about_fixed_length_file

</details>
