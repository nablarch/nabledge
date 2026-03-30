# 応答不要電文送信処理用アクションハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.action.AsyncMessageSendAction`

[../core_library/messaging_sending_batch](../libraries/libraries-messaging_sending_batch.md) において電文送信処理を実行するアクションハンドラ。

**ハンドラキュー構成**: Main → MultiThreadExecutionHandler → MessagingContextHandler → TransactionManagementHandler → DataReadHandler → AsyncMessageSendAction

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [Main](handlers-Main.md) | 送信対象電文のリクエストIDを起動時の引数 **-messageRequestId** に指定する。 |
| [MessagingContextHandler](handlers-MessagingContextHandler.md) | スレッドローカル上の [メッセージングコンテキスト](../libraries/libraries-enterprise_messaging.md) を用いて送信処理を行う。 |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | トランザクションコミット完了後、およびロールバック時のコールバック内で、送信ステータスの更新処理を行う。 |
| [DataReadHandler](handlers-DataReadHandler.md) | 本ハンドラが作成したデータリーダ（[../reader/DatabaseRecordReader](../readers/readers-DatabaseRecordReader.md)）を使用して処理対象レコードの読込みを行う。 |

<details>
<summary>keywords</summary>

AsyncMessageSendAction, nablarch.fw.messaging.action.AsyncMessageSendAction, 応答不要電文送信, メッセージング送信バッチ, ハンドラキュー構成, MultiThreadExecutionHandler, MessagingContextHandler, TransactionManagementHandler, DataReadHandler

</details>

## ハンドラ処理フロー

**[コールバック]**

1. **送信メッセージのリクエストID取得**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) の処理開始前にコールバックされ、起動引数 **-messageRequestId** の値を `CommandLine` オブジェクトより取得する。
2. **データリーダの作成**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) からコールバックされ、送信メッセージ格納テーブルに対するデータリーダを作成して返す。以下のSQLリソースに対するプリペアードステートメントを使用する [../reader/DatabaseRecordReader](../readers/readers-DatabaseRecordReader.md) を作成する:
   ```
   (sqlFilePackage) + "." + (messageRequestId) + "#" + "SELECT_SEND_DATA"
   ```

**[往路処理]**

3. **送信電文オブジェクトの作成**: `SendingMessage` を生成する。
4. **フレームワーク制御ヘッダ部フォーマット定義を取得**: 設定値に指定されたフレームワーク制御ヘッダ定義ファイルを取得する。
5. **フレームワーク制御ヘッダを作成**: 以下の手順でヘッダを作成し送信電文オブジェクトに設定する:
   - 取得したメッセージリクエストIDを `requestId` フレームワーク制御ヘッダに設定。
   - `headerItemList` に設定された項目名と同名フィールドが処理対象レコードに存在すればその値を設定、存在しなければnullを設定。
6. **メッセージデータ部フォーマット定義を取得**: 以下のファイル名のフォーマット定義を取得する:
   ```
   (messageRequestId) + "_SEND"
   ```
7. **メッセージデータ部を作成**: 処理対象レコードの各フィールドをフォーマット定義の各フィールドの値として設定し、送信電文オブジェクトに設定する。
8. **メッセージ送信**: 設定値の送信宛先キュー論理名を送信電文オブジェクトに設定し、カレントスレッド上のメッセージングコンテキストを使用して送信する。

**[往路処理]**

- **正常終了**: `Result.Success` をリターンして終了。このハンドラでは後続ハンドラへの処理移譲は行わない。

**[例外処理]**

明示的な例外制御なし。処理中に発生した実行時例外はそのまま送出される。

**[コールバック]**

6. **処理対象レコードステータス変更（正常）**: [TransactionManagementHandler](handlers-TransactionManagementHandler.md) のコミット完了後にコールバックされ、以下のSQLリソースを実行して処理対象レコードのステータスを処理済みに更新する:
   ```
   (sqlFilePackage) + "." + (messageRequestId) + "#" + "UPDATE_NORMAL_END"
   ```
6a. **処理対象レコードステータス変更（異常）**: 業務トランザクションのロールバック時にコールバックされ、以下のSQLリソースを実行して処理対象レコードのステータスをエラーに更新する:
   ```
   (sqlFilePackage) + "." + (messageRequestId) + "#" + "UPDATE_ABNORMAL_END"
   ```
7. **ステータス変更エラー**: 6. または 6a. でのステータス変更の対象となったレコード数が1でなかった場合は実行時例外を送出する。

<details>
<summary>keywords</summary>

SendingMessage, CommandLine, Result.Success, DatabaseRecordReader, SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, 電文送信処理フロー, コールバック, メッセージリクエストID, requestId, フレームワーク制御ヘッダ

</details>

## 設定項目・拡張ポイント

本ハンドラの設定値は `AsyncMessageSendActionSettings` に集約されている。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| sqlFilePackage | String | ○ | | このハンドラで使用するSQL定義ファイルを格納するパッケージ名 |
| queueName | String | ○ | | メッセージの送信宛先キューの論理名 |
| formatDir | String | | "format" | 送信電文のフォーマット定義を格納するディレクトリの論理パス |
| headerFormatName | String | ○ | | 送信電文のフレームワーク制御ヘッダのフォーマット定義ファイル名 |
| formClassName | String | ○ | | 送信要求テーブル上の送信ステータス項目更新処理で使用するフォームクラスの名称 |
| headerItemList | List\<String\> | | (なし) | レコードのフィールドのうち、送信電文のフレームワーク制御ヘッダとして設定する項目のリスト |
| transactionName | String | | "transaction" | 送信要求のステータス変更処理で使用するトランザクションの識別名 |

<details>
<summary>keywords</summary>

AsyncMessageSendActionSettings, sqlFilePackage, queueName, formatDir, headerFormatName, formClassName, headerItemList, transactionName, 設定項目

</details>
