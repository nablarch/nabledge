# リクエスト単体テスト（同期応答メッセージ送信処理）

## 概要

リクエスト単体テスト（同期応答メッセージ送信処理)では、
要求電文1件をキューに送信し、結果を同期的に受信する際の動作を擬似的に再現し、テストを行う。

> **Note:**
> リクエスト単体テストそのものの概要については、
> [リクエスト単体テストの実施方法(同期応答メッセージ送信処理)](../../development-tools/testing-framework/testing-framework-02-requestunittest-send-sync.md#リクエスト単体テストの実施方法同期応答メッセージ送信処理)
> を参照。

### 全体像

バッチ処理の中で同期応答メッセージ送信処理を行う場合について、以下に全体像を示す。

![send_sync.png](../../../knowledge/assets/testing-framework-RequestUnitTest-send-sync/send_sync.png)

> **Note:**
> 同期応答メッセージ送信処理のリクエスト単体テストを行う場合、テストケースの親クラスは以下の２クラスのうちのいずれかを継承しておく必要がある。

> * >   StandaloneTestSupportTemplate
> * >   AbstractHttpRequestTestTemplate

## 主なクラス, リソース

| 名称 | 役割 | 作成単位 |
|---|---|---|
| リクエスト単体 テストクラス | テストロジックを実装する。 | テスト対象クラス(Action)につき１つ作成 |
| Excelファイル （テストデータ） | 要求電文の期待値および応答電文などの テストデータを記載する。 | テストクラスにつき１つ作成 |
| StandaloneTest SupportTemplate | Action実行後に、MockMessagingContextを用いて 要求電文のアサートを実行する。 | － |
| AbstractHttpRequest TestTemplate | Action実行後に、MockMessagingContextを用いて 要求電文のアサートを実行する。 | － |
| MessageSender | 同期応答メッセージ送信を行う際に 使用するコンポーネント。 | － |
| RequestTestingMessagingProvider | リクエスト単体テストにおいて、 要求電文のアサート機能および 応答電文の生成・返却機能を提供する。 | － |
| TestDataConvertor | Excelから読み込んだテストデータを編集するための インタフェース。 必要に応じてデータ種別ごとにアーキテクトが実装する。 | － |

## 構造

### StandaloneTestSupportTemplate

Action実行後に、MockMessagingContextを用いて、要求電文のアサートを行う機能。

同期応答メッセージ送信処理のリクエスト単体テストを行う場合は、処理の形態に合わせて
本クラスもしくはAbstractHttpRequestTestTemplateを実装したテストケースを使用する必要がある。

### AbstractHttpRequestTestTemplate

Action実行後に、MockMessagingContextを用いて、要求電文のアサートを行う機能。

同期応答メッセージ送信処理のリクエスト単体テストを行う場合は、処理の形態に合わせて
本クラスもしくはStandaloneTestSupportTemplateを実装したテストケースを使用する必要がある。

### RequestTestingMessagingProvider

要求電文のアサートおよび、応答電文の生成・返却する機能を提供するクラス。

また、Excelに記載された要求電文の期待値と、応答電文の読み込みも実行する。

本クラスは、以下の準備処理、結果確認機能を提供する。

| 準備処理 | 結果確認 |
|---|---|
| 応答電文の生成 | 要求電文のアサート |

> **Note:**
> 要求電文のアサートは、要求電文が送信されるたびに行うのではなく、Action実行後に一括で行う。

### MessageSender

同期応答メッセージ送信処理で使用するコンポーネント。

主に以下の機能を提供する。

* Actionなどの呼び出し元から渡されたパラメータから、要求電文を生成する。
* 要求電文を元にMockMessagingContextを実行する。
* MockMessagingContextから返却された応答電文をパースする。
* パース結果のオブジェクトを呼び出し元に返却する。

### TestDataConvertor

Excelから読み込んだテストデータを編集するためのインタフェース。
必要に応じてXMLやJSONなどのデータ種別ごとにアーキテクトが実装する。

実装クラスでは以下の機能を実装する。

* Excelから読み込んだデータに対し任意の編集を行う。
* 編集を行ったデータを読み込むためのレイアウト定義データを動的に生成する。

本インタフェースを実装することで、例えばExcelに日本語で記述されたデータをURLエンコーディングする等の処理を追加することが可能である。

実装クラスは "TestDataConverter_<データ種別>" というキー名でテスト用のコンポーネント定義ファイルに登録する必要がある。

## テストデータ

同期応答メッセージ送信処理固有のテストデータについて説明する。

### 同期応答メッセージ送信処理

基本的な記述方法は、
 [テストデータの書き方](../../development-tools/testing-framework/testing-framework-02-requestunittest-http-send-sync.md#テストデータの書き方)
を参照。

> **Note:**
> パディングおよびバイナリデータの扱いは、 [固定長ファイル](../../development-tools/testing-framework/testing-framework-RequestUnitTest-batch.md#固定長ファイル) と同様である。
