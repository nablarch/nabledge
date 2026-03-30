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
| [DataReadHandler](handlers-DataReadHandler.md) | 本ハンドラが作成したデータリーダ ([../reader/DatabaseRecordReader](../readers/readers-DatabaseRecordReader.md)) を使用して処理対象レコードの読込みを行う。 |

<details>
<summary>keywords</summary>

AsyncMessageSendAction, nablarch.fw.messaging.action.AsyncMessageSendAction, 応答不要電文送信, メッセージ送信バッチ, アクションハンドラ, MultiThreadExecutionHandler, MessagingContextHandler, TransactionManagementHandler, DataReadHandler

</details>

## ハンドラ処理フロー

**[コールバック]**

1. **(送信メッセージのメッセージIDを取得)**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) の処理開始前にコールバックされ、起動引数 **-messageRequestId** の値を `CommandLine` オブジェクトより取得する。

2. **(データリーダの作成)**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) からコールバックされ、送信メッセージの内容が格納されたテーブルに対するデータリーダ ([../reader/DatabaseRecordReader](../readers/readers-DatabaseRecordReader.md)) を作成してリターンする。使用するSQLリソース:
   ```
   (SQL定義配置パッケージ設定値) + "." + (メッセージリクエストID) + "#" + "SELECT_SEND_DATA"
   ```

**[往路処理]**

3. **(送信電文オブジェクトの作成)**: 送信電文オブジェクト(`SendingMessage`) を生成する。

4. **(フレームワーク制御ヘッダ部フォーマット定義を取得)**: 設定値に指定されたフレームワーク制御ヘッダ定義ファイルを取得する。

5. **(フレームワーク制御ヘッダを作成)**: 4. で取得したフォーマット定義に従い、以下の手順でフレームワーク制御ヘッダを作成し送信電文オブジェクトに設定する:
   - 1. で取得したメッセージリクエストIDを **requestId** フレームワーク制御ヘッダに設定。
   - フレームワーク制御ヘッダ項目名リストに設定された項目名と同じフィールドが処理対象レコードに定義されていればその値をヘッダ値として設定する。当該フィールドが存在しない場合はnullを設定する。

6. **(メッセージデータ部フォーマット定義を取得)**: 設定値のフォーマット定義ファイル論理パスから以下のファイル名のフォーマット定義を取得する:
   ```
   (メッセージリクエストID) + "_SEND"
   ```

7. **(メッセージデータ部を作成)**: 6. で取得したフォーマット定義に従い、処理対象レコードからメッセージデータ部を作成し送信電文オブジェクトに設定する。処理対象レコードの各フィールドがフォーマット定義上の各フィールドの値として設定される。

8. **(メッセージ送信)**: 設定値に指定された送信宛先キュー論理名を送信電文オブジェクトに設定し、カレントスレッド上のメッセージングコンテキストを使用して送信する。

**[往路処理]**

- **(正常終了)**: 正常終了のマーカオブジェクト(`Result.Success`)をリターンして終了する。後続ハンドラへの処理移譲は行わない。

**[例外処理]**

明示的な例外制御なし。処理中に発生した実行時例外はそのまま送出される。

**[コールバック]**

6. **(処理対象レコードステータス変更1)**: [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でのコミット完了時にコールバックされ、以下のSQLリソースを実行して処理対象レコードのステータスを処理済みに更新する:
   ```
   (SQL定義配置パッケージ設定値) + "." + (メッセージリクエストID) + "#" + "UPDATE_NORMAL_END"
   ```

6a. **(処理対象レコードステータス変更2)**: [TransactionManagementHandler](handlers-TransactionManagementHandler.md) において業務トランザクションがロールバックした場合にコールバックされ、以下のSQLリソースを実行して処理対象レコードのステータスをエラーに更新する:
   ```
   (SQL定義配置パッケージ設定値) + "." + (メッセージリクエストID) + "#" + "UPDATE_ABNORMAL_END"
   ```

7. **(ステータス変更エラー)**: 6. または6a. でのステータス変更対象レコード数が1でなかった場合、実行時例外を送出する。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, MultiThreadExecutionHandler, TransactionManagementHandler, SendingMessage, DatabaseRecordReader, CommandLine, Result.Success, メッセージ送信, フレームワーク制御ヘッダ, SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END

</details>

## 設定項目・拡張ポイント

設定値は `AsyncMessageSendActionSettings` に集約されている。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| sqlFilePackage | String | ○ | | 使用するSQL定義ファイルを格納するパッケージ名 |
| queueName | String | ○ | | メッセージの送信宛先キューの論理名 |
| formatDir | String | | "format" | 送信電文のフォーマット定義を格納するディレクトリの論理パス |
| headerFormatName | String | ○ | | 送信電文のフレームワーク制御ヘッダのフォーマット定義ファイル名 |
| formClassName | String | ○ | | 送信要求テーブル上の送信ステータス項目更新処理で使用するフォームクラスの名称 |
| headerItemList | List\<String\> | | ヘッダ項目には何も指定しない | レコードのフィールドのうち、送信電文のフレームワーク制御ヘッダとして設定する項目のリスト |
| transactionName | String | | "transaction" | 送信要求のステータス変更処理で使用するトランザクションの識別名 |

<details>
<summary>keywords</summary>

AsyncMessageSendActionSettings, sqlFilePackage, queueName, formatDir, headerFormatName, formClassName, headerItemList, transactionName, 設定項目

</details>
