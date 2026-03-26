# リクエスト単体テスト（同期応答メッセージ送信処理）

## 全体像

リクエスト単体テスト（同期応答メッセージ送信処理）では、要求電文1件をキューに送信し、結果を同期的に受信する際の動作を擬似的に再現し、テストを行う。

![同期応答メッセージ送信処理の全体像](../../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_send_sync/send_sync.png)

> **注意**: 同期応答メッセージ送信処理のリクエスト単体テストを行う場合、テストケースの親クラスは `StandaloneTestSupportTemplate` または `AbstractHttpRequestTestTemplate` のいずれかを継承する必要がある。

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ |
| Excelファイル（テストデータ） | 要求電文の期待値および応答電文などのテストデータを記載する | テストクラスにつき１つ |
| StandaloneTestSupportTemplate | Action実行後にMockMessagingContextを用いて要求電文のアサートを実行する | — |
| AbstractHttpRequestTestTemplate | Action実行後にMockMessagingContextを用いて要求電文のアサートを実行する | — |
| MessageSender | 同期応答メッセージ送信を行う際に使用するコンポーネント | — |
| RequestTestingMessagingProvider | 要求電文のアサート機能および応答電文の生成・返却機能を提供する | — |
| TestDataConvertor | Excelから読み込んだテストデータを編集するためのインタフェース（必要に応じてアーキテクトが実装） | — |

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, AbstractHttpRequestTestTemplate, MessageSender, RequestTestingMessagingProvider, TestDataConvertor, MockMessagingContext, 同期応答メッセージ送信処理, 全体像, 主なクラス, 要求電文, キュー送信, 同期受信

</details>

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

Action実行後に `MockMessagingContext` を用いて要求電文のアサートを行う機能を提供する。

同期応答メッセージ送信処理のリクエスト単体テストでは、処理の形態に合わせて本クラスまたは `AbstractHttpRequestTestTemplate` のいずれかを実装したテストケースを使用する必要がある。

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, MockMessagingContext, 同期応答メッセージ送信処理, リクエスト単体テスト, テストケース継承

</details>

## AbstractHttpRequestTestTemplate

**クラス**: `AbstractHttpRequestTestTemplate`

Action実行後に `MockMessagingContext` を用いて要求電文のアサートを行う機能を提供する。

同期応答メッセージ送信処理のリクエスト単体テストでは、処理の形態に合わせて本クラスまたは `StandaloneTestSupportTemplate` のいずれかを実装したテストケースを使用する必要がある。

<details>
<summary>keywords</summary>

AbstractHttpRequestTestTemplate, MockMessagingContext, 同期応答メッセージ送信処理, リクエスト単体テスト, HTTPリクエストテスト

</details>

## RequestTestingMessagingProvider

**クラス**: `RequestTestingMessagingProvider`

要求電文のアサートおよび応答電文の生成・返却機能を提供する。Excelに記載された要求電文の期待値と応答電文の読み込みも実行する。

| 準備処理 | 結果確認 |
|---|---|
| 応答電文の生成 | 要求電文のアサート |

> **注意**: 要求電文のアサートは、要求電文が送信されるたびに行うのではなく、Action実行後に一括で行う。

<details>
<summary>keywords</summary>

RequestTestingMessagingProvider, 要求電文アサート, 応答電文生成, MockMessagingContext, テストデータ読み込み, 一括アサート

</details>

## MessageSender

**クラス**: `MessageSender`

同期応答メッセージ送信処理で使用するコンポーネント。主な機能:

1. 呼び出し元から渡されたパラメータから要求電文を生成する
2. 要求電文を元に `MockMessagingContext` を実行する
3. `MockMessagingContext` から返却された応答電文をパースする
4. パース結果のオブジェクトを呼び出し元に返却する

<details>
<summary>keywords</summary>

MessageSender, 同期応答メッセージ送信, MockMessagingContext, 要求電文生成, 応答電文パース

</details>

## TestDataConvertor

**インタフェース**: `TestDataConvertor`

Excelから読み込んだテストデータを編集するためのインタフェース。XMLやJSONなどのデータ種別ごとにアーキテクトが実装する。

実装クラスで実装する機能:
1. Excelから読み込んだデータに対し任意の編集を行う（例: 日本語データのURLエンコーディング）
2. 編集を行ったデータを読み込むためのレイアウト定義データを動的に生成する

> **注意**: 実装クラスは `"TestDataConverter_<データ種別>"` というキー名でテスト用のコンポーネント定義ファイルに登録する必要がある。

<details>
<summary>keywords</summary>

TestDataConvertor, TestDataConverter, テストデータ変換, URLエンコーディング, コンポーネント定義, レイアウト定義

</details>

## 同期応答メッセージ送信処理（テストデータ）

同期応答メッセージ送信処理固有のテストデータの記述方法は、:ref:`send_sync_request_write_test_data` を参照。

> **注意**: パディングおよびバイナリデータの扱いは、:ref:`about_fixed_length_file` と同様。

<details>
<summary>keywords</summary>

同期応答メッセージ送信処理, テストデータ, パディング, バイナリデータ, 固定長ファイル

</details>
