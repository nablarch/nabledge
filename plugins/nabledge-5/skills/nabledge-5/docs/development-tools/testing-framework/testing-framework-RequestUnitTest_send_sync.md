# リクエスト単体テスト（同期応答メッセージ送信処理）

**公式ドキュメント**: [リクエスト単体テスト（同期応答メッセージ送信処理）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/RequestUnitTest_send_sync.html)

## 全体像

リクエスト単体テスト（同期応答メッセージ送信処理）では、要求電文1件をキューに送信し、結果を同期的に受信する際の動作を擬似的に再現し、テストを行う。

> **補足**: 同期応答メッセージ送信処理のリクエスト単体テストを行う場合、テストケースの親クラスは以下の２クラスのうちのいずれかを継承しておく必要がある。
> - `StandaloneTestSupportTemplate`
> - `AbstractHttpRequestTestTemplate`

![同期応答メッセージ送信処理の全体像](../../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_send_sync/send_sync.png)

## 主なクラス・リソース

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ |
| Excelファイル（テストデータ） | 要求電文の期待値および応答電文などのテストデータを記載する | テストクラスにつき１つ |
| `StandaloneTestSupportTemplate` | Action実行後に`MockMessagingContext`を用いて要求電文のアサートを実行する | — |
| `AbstractHttpRequestTestTemplate` | Action実行後に`MockMessagingContext`を用いて要求電文のアサートを実行する | — |
| `MessageSender` | 同期応答メッセージ送信処理を行う際に使用するコンポーネント | — |
| `RequestTestingMessagingProvider` | 要求電文のアサート機能および応答電文の生成・返却機能を提供する | — |
| `TestDataConvertor` | Excelから読み込んだテストデータを編集するためのインタフェース | — |

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, AbstractHttpRequestTestTemplate, MockMessagingContext, MessageSender, RequestTestingMessagingProvider, TestDataConvertor, 同期応答メッセージ送信処理, リクエスト単体テスト全体像, 要求電文送信, 同期受信

</details>

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

Action実行後に`MockMessagingContext`を用いて要求電文のアサートを行う機能。

> **補足**: 同期応答メッセージ送信処理のリクエスト単体テストを行う場合、処理の形態に合わせて本クラスもしくは`AbstractHttpRequestTestTemplate`を実装したテストケースを使用する必要がある。

<details>
<summary>keywords</summary>

StandaloneTestSupportTemplate, MockMessagingContext, AbstractHttpRequestTestTemplate, 要求電文アサート, 同期応答メッセージ送信処理テスト

</details>

## AbstractHttpRequestTestTemplate

**クラス**: `AbstractHttpRequestTestTemplate`

Action実行後に`MockMessagingContext`を用いて要求電文のアサートを行う機能。

> **補足**: 同期応答メッセージ送信処理のリクエスト単体テストを行う場合、処理の形態に合わせて本クラスもしくは`StandaloneTestSupportTemplate`を実装したテストケースを使用する必要がある。

<details>
<summary>keywords</summary>

AbstractHttpRequestTestTemplate, MockMessagingContext, StandaloneTestSupportTemplate, 要求電文アサート, HTTPリクエストテスト

</details>

## RequestTestingMessagingProvider

**クラス**: `RequestTestingMessagingProvider`

要求電文のアサートおよび応答電文の生成・返却機能を提供するクラス。Excelに記載された要求電文の期待値と応答電文の読み込みも実行する。

| 準備処理 | 結果確認 |
|---|---|
| 応答電文の生成 | 要求電文のアサート |

> **補足**: 要求電文のアサートは、要求電文が送信されるたびに行うのではなく、Action実行後に一括で行う。

<details>
<summary>keywords</summary>

RequestTestingMessagingProvider, MockMessagingContext, 応答電文生成, 要求電文アサート, テストデータ読み込み

</details>

## MessageSender

**クラス**: `MessageSender`

同期応答メッセージ送信処理で使用するコンポーネント。主な機能:

1. 呼び出し元から渡されたパラメータから要求電文を生成する
2. 要求電文を元に`MockMessagingContext`を実行する
3. `MockMessagingContext`から返却された応答電文をパースする
4. パース結果のオブジェクトを呼び出し元に返却する

<details>
<summary>keywords</summary>

MessageSender, MockMessagingContext, 要求電文生成, 応答電文パース, 同期メッセージ送信

</details>

## TestDataConvertor

**クラス**: `TestDataConvertor`

Excelから読み込んだテストデータを編集するためのインタフェース。XMLやJSONなどのデータ種別ごとにアーキテクトが実装する。

実装クラスで実装する機能:
1. Excelから読み込んだデータを任意の値に編集する
2. 編集したデータを読み込むためのレイアウト定義データを動的に生成する

実装クラスは `"TestDataConverter_<データ種別>"` というキー名でテスト用のコンポーネント設定ファイルに登録する必要がある。

Excelに日本語で記述されたデータをURLエンコーディングする等の処理を追加可能。

<details>
<summary>keywords</summary>

TestDataConvertor, テストデータ編集, レイアウト定義データ生成, コンポーネント設定ファイル登録, URLエンコーディング

</details>

## 同期応答メッセージ送信処理

テストデータの基本的な記述方法は :ref:`send_sync_request_write_test_data` を参照。

> **補足**: パディングおよびバイナリデータの扱いは、:ref:`about_fixed_length_file` と同様である。

<details>
<summary>keywords</summary>

send_sync_request_write_test_data, about_fixed_length_file, パディング, バイナリデータ, テストデータ記述方法

</details>
