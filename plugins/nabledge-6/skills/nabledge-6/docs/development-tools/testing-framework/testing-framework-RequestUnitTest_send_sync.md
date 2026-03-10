# リクエスト単体テスト（同期応答メッセージ送信処理）

## 概要

リクエスト単体テスト（同期応答メッセージ送信処理）では、要求電文1件をキューに送信し、結果を同期的に受信する際の動作を擬似的に再現し、テストを行う。

## 全体像

![バッチ処理での同期応答メッセージ送信処理の全体像](../../knowledge/development-tools/testing-framework/assets/testing-framework-RequestUnitTest_send_sync/send_sync.png)

> **補足**: 同期応答メッセージ送信処理のリクエスト単体テストを行う場合、テストケースの親クラスは以下の2クラスのいずれかを継承する必要がある。
> - `StandaloneTestSupportTemplate`
> - `AbstractHttpRequestTestTemplate`

主なクラス・リソース:

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき1つ作成 |
| Excelファイル（テストデータ） | 要求電文の期待値および応答電文などのテストデータを記載する | テストクラスにつき1つ作成 |
| `StandaloneTestSupportTemplate` | Action実行後に、MockMessagingContextを用いて要求電文のアサートを実行する | － |
| `AbstractHttpRequestTestTemplate` | Action実行後に、MockMessagingContextを用いて要求電文のアサートを実行する | － |
| `MessageSender` | 同期応答メッセージ送信処理を行う際に使用するコンポーネント | － |
| `RequestTestingMessagingProvider` | リクエスト単体テストにおいて、要求電文のアサート機能および応答電文の生成・返却機能を提供する | － |
| `TestDataConvertor` | Excelから読み込んだテストデータを編集するためのインタフェース | － |

## StandaloneTestSupportTemplate

**クラス**: `StandaloneTestSupportTemplate`

Action実行後に`MockMessagingContext`を用いて要求電文のアサートを行う機能を提供する。同期応答メッセージ送信処理のリクエスト単体テストでは、処理形態に応じて本クラスまたは`AbstractHttpRequestTestTemplate`を継承したテストケースを使用する。

## AbstractHttpRequestTestTemplate

**クラス**: `AbstractHttpRequestTestTemplate`

Action実行後に`MockMessagingContext`を用いて要求電文のアサートを行う機能を提供する。同期応答メッセージ送信処理のリクエスト単体テストでは、処理形態に応じて本クラスまたは`StandaloneTestSupportTemplate`を継承したテストケースを使用する。

## RequestTestingMessagingProvider

**クラス**: `RequestTestingMessagingProvider`

要求電文のアサートおよび応答電文の生成・返却機能を提供する。Excelに記載された要求電文の期待値と応答電文の読み込みも実行する。

| 準備処理 | 結果確認 |
|---|---|
| 応答電文の生成 | 要求電文のアサート |

> **補足**: 要求電文のアサートは、要求電文が送信されるたびではなく、Action実行後に一括で行う。

## MessageSender

**クラス**: `MessageSender`

同期応答メッセージ送信処理で使用するコンポーネント。主な機能:
1. 呼び出し元から渡されたパラメータから要求電文を生成する
2. 要求電文を元に`MockMessagingContext`を実行する
3. `MockMessagingContext`から返却された応答電文をパースする
4. パース結果のオブジェクトを呼び出し元に返却する

## TestDataConvertor

**クラス**: `TestDataConvertor`

Excelから読み込んだテストデータを編集するためのインタフェース。データ種別（XMLやJSONなど）ごとにアーキテクトが実装する。

実装クラスでの実装内容:
- Excelから読み込んだデータを任意の値に編集する
- 編集したデータを読み込むためのレイアウト定義データを動的に生成する

実装クラスはテスト用コンポーネント設定ファイルに `TestDataConverter_<データ種別>` というキー名で登録する必要がある。

## 同期応答メッセージ送信処理（テストデータ）

同期応答メッセージ送信処理の基本的な記述方法は :ref:`send_sync_request_write_test_data` を参照。

> **補足**: パディングおよびバイナリデータの扱いは、:ref:`about_fixed_length_file` と同様である。
