# リクエスト単体テストの実施方法(HTTP同期応答メッセージ送信処理)

## 概要

リクエスト単体テストの実施方法は :ref:`message_sendSyncMessage_test` を参照すること。ただし、「送信キュー」「受信キュー」は「通信先」と読み替えること。本ドキュメントでは :ref:`message_sendSyncMessage_test` と異なる箇所のみを解説する。

## テストデータの書き方

## 電文を1回送信する場合

![応答電文の記述例（1回送信）](../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_send_sync_response.png)

![要求電文期待値の記述例（1回送信）](../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_send_sync_expected.png)

> **補足**: `RESPONSE_BODY_MESSAGES`（および`EXPECTED_REQUEST_BODY_MESSAGES`）は複数フィールドに分割して記述可能。フィールド名は任意の文字列を指定する（例: `XML1`, `XML2`, `XML3`）。

> **補足**: JSON・XMLデータ形式使用時は、1Excelシートに1テストケースのみ記述すること。メッセージボディはExcelの各行の文字列長が同一であることをNTFが要求するが、JSON・XMLは要求電文の長さがリクエスト毎に異なるため、事実上1テストケースしか記述できない制約がある。

## 電文を2回以上送信する場合

![応答電文の記述例（複数回送信）](../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_send_sync_ok_pattern_response.png)

![要求電文期待値の記述例（複数回送信）](../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_send_sync_ok_pattern_expected.png)

複数回電文を送信する場合のテスト記述ルール:

- 同一データタイプ（例: `RESPONSE_HEADER_MESSAGES`と`RESPONSE_BODY_MESSAGES`）はまとめて記述する（詳細: :ref:`tips_groupId` および :ref:`auto-test-framework_multi-datatype`）
- 同一リクエストIDの電文は`no`の値を変えてまとめて記述する
- 同一リクエストIDの電文は長さを合わせること（合わせられない場合は手動テストを行う）

> **補足**: 送信対象のリクエストIDが複数存在する場合、送信順のテストは不可能。順番が異なっても（例: `ProjectSaveMessage2`が`ProjectSaveMessage`より先に送信されても）テストは成功となる。

## 障害系のテスト

応答電文の表の**ヘッダおよび本文両方の「no」を除く最初のフィールド**に以下の値を設定することで障害系テストを行う。

| 設定値 | 障害内容 | 動作 |
|---|---|---|
| `errorMode:timeout` | メッセージ送信中のタイムアウトエラー | `HttpMessagingTimeoutException`（`MessagingException`のサブクラス）をスロー |
| `errorMode:msgException` | メッセージ送受信エラー | `MessagingException`をスロー |

- スローされる`HttpMessagingTimeoutException`は :ref:`message_sendSyncMessage_test` とは異なるクラス
- 業務アクション内で`MessagingException`を明示的に制御していない場合、個別のリクエスト単体テストで障害系テストを行う必要はない

## モックアップを使用するための記述・要求電文のアサート

## モックアップを使用するための記述

`testShots`の`expectedMessageByClient`および`responseMessageByClient`にグループIDを設定する。モックアップ自体は :ref:`dealUnitTest_send_sync` を参照。グループIDの関連は :ref:`message_sendSyncMessage_test` の`expectedMessage`/`responseMessage`の場合と同様。

![testShotsの記述例（HTTP）](../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_send_sync_shot.png)

同一アクション内でMOM同期応答メッセージ送信処理とHTTP同期応答メッセージ送信処理が同時に行われる場合:

- `expectedMessage`/`responseMessage`: MOM同期応答メッセージ送信処理用グループID
- `expectedMessageByClient`/`responseMessageByClient`: HTTP同期応答メッセージ送信処理用グループID

![testShotsの記述例（MOM+HTTP併用）](../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_mom_send_sync_shot.png)

> **補足**: MOMとHTTPのグループIDには必ず異なる値を設定すること。同一のグループIDを指定した場合、正しく結果検証が行われない。

## 要求電文のアサート

テストデータのディレクティブ行に設定された`file-type`の値によりアサート方法が変化する。詳細は :ref:`real_request_test` のレスポンスメッセージの項を参照。

## フレームワークで使用するクラスの設定

通常、この設定はアーキテクトが行うものであり、アプリケーションプログラマが設定する必要はない。

**クラス**: `nablarch.test.core.messaging.RequestTestingMessagingClient`

コンポーネント設定ファイルに`defaultMessageSenderClient`という名前でモックアップクラスを設定する:

```xml
<component name="defaultMessageSenderClient"
           class="nablarch.test.core.messaging.RequestTestingMessagingClient">
  <property name="charset" value="Shift-JIS"/>
</component>
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| charset | | UTF-8 | ログ出力に使用する文字コード名 |
