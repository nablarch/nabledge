# リクエスト単体テスト（メッセージ受信処理）

## 全体像

![リクエスト単体テスト（メッセージ受信処理）クラス構成図](../../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_real/real_request_test_class.png)

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ |
| Excelファイル（テストデータ） | テーブルに格納する準備データや期待する結果、入力ファイルなどテストデータを記載する | テストクラスにつき１つ |
| StandaloneTestSupportTemplate | コンテナ外で動作する処理のテスト実行環境を提供する | — |
| MessagingRequestTestSupport | 同期応答メッセージ受信処理のリクエスト単体テストで必要となるテスト準備機能、各種アサートを提供する | — |
| MessagingReceiveTestSupport | 応答不要メッセージ受信処理のリクエスト単体テストで必要となるテスト準備機能、各種アサートを提供する | — |
| TestShot | データシートに定義されたテストケース1件分の情報を格納するクラス | — |
| MainForRequestTesting | テスト用メインクラス。テスト実行時の差分を吸収する | — |
| DbAccessTestSupport | DB準備データ投入などデータベースを使用するテストに必要な機能を提供する | — |
| MQSupport | 電文作成などメッセージングのテストに必要な機能を提供する | — |
| TestDataConvertor | Excelから読み込んだテストデータを編集するためのインタフェース。データ種別ごとにアーキテクトが実装する | — |

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, MessagingRequestTestSupport, MessagingReceiveTestSupport, TestShot, MainForRequestTesting, DbAccessTestSupport, MQSupport, TestDataConvertor, メッセージ受信処理テスト, クラス構成

</details>

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

バッチやメッセージング処理などコンテナ外で動作する処理のテスト実行環境を提供する。テストデータを読み取り、全`TestShot`を実行する。

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, TestShot, コンテナ外処理テスト, テスト実行環境, バッチテスト, メッセージングテスト

</details>

## TestShot

**クラス**: `TestShot`

1テストショットの情報保持とテストショット実行を行う。テストショットの構成要素:
1. 入力データの準備
2. メインクラス起動
3. 出力結果の確認

バッチやメッセージング処理などコンテナ外で動作する処理のテストにおいて共通の準備処理、結果確認機能を提供する。

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

## MessagingRequestTestSupport

**クラス**: `MessagingRequestTestSupport`

同期応答メッセージ受信処理テスト用のスーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

TestShotの準備処理・結果確認に以下を追加:

| 準備処理 | 結果確認 |
|---|---|
| 要求電文の作成 | 応答電文の内容確認 |

> **注意**: 本クラスは入力データをキューにPUTする用途でmain側のコンポーネント定義ファイルを読み込む。`nablarch.fw.messaging.FwHeaderDefinition`実装クラスは`fwHeaderDefinition`という名前で登録されていなければならない。別の名称を使用する場合は`getFwHeaderDefinitionName()`をオーバライドすることで変更できる。

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, 同期応答メッセージ受信処理, 要求電文作成, 応答電文確認, FwHeaderDefinition, fwHeaderDefinition, getFwHeaderDefinitionName

</details>

## MessagingReceiveTestSupport

**クラス**: `MessagingReceiveTestSupport`

応答不要メッセージ処理テスト用のスーパクラス。アプリケーションプログラマは本クラスを継承してテストクラスを作成する。

TestShotの準備処理に以下を追加（結果確認なし）:

| 準備処理 |
|---|
| 要求電文の作成 |

<details>
<summary>keywords</summary>

MessagingReceiveTestSupport, 応答不要メッセージ処理, 要求電文作成

</details>

## MainForRequestTesting

**クラス**: `MainForRequestTesting`

リクエスト単体テスト用のメインクラス。本番用メインクラスとの差異:
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

MQSupport, 要求電文, 受信キュー, 応答電文, 送信キュー, メッセージング

</details>

## TestDataConvertor

**クラス**: `TestDataConvertor`

Excelから読み込んだテストデータを編集するためのインタフェース。XMLやJSONなどのデータ種別ごとにアーキテクトが実装する。

実装クラスの機能:
- Excelから読み込んだデータに対し任意の編集を行う
- 編集を行ったデータを読み込むためのレイアウト定義データを動的に生成する

本インタフェースを実装することで、例えばExcelに日本語で記述されたデータをURLエンコーディングする等の処理を追加することが可能である。

実装クラスは`"TestDataConverter_<データ種別>"`というキー名でテスト用のコンポーネント定義ファイルに登録する必要がある。

<details>
<summary>keywords</summary>

TestDataConvertor, TestDataConverter, Excelテストデータ編集, レイアウト定義データ, データ種別, コンポーネント定義

</details>

## メッセージ

> **注意**: パディングおよびバイナリデータの扱いは :ref:`about_fixed_length_file` と同様である。

<details>
<summary>keywords</summary>

メッセージ, パディング, バイナリデータ, 固定長ファイル, about_fixed_length_file

</details>
