# 応答不要電文送信処理用アクションハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.action.AsyncMessageSendAction`

[../core_library/messaging_sending_batch](../libraries/libraries-messaging_sending_batch.md) において電文送信処理を実行するアクションハンドラ。

**ハンドラキュー構成**: Main → MultiThreadExecutionHandler → MessagingContextHandler → TransactionManagementHandler → DataReadHandler → AsyncMessageSendAction

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [Main](handlers-Main.md) | 送信対象電文のリクエストIDを起動時の引数 **-messageRequestId** に指定する |
| [MessagingContextHandler](handlers-MessagingContextHandler.md) | スレッドローカル上の [メッセージングコンテキスト](../libraries/libraries-enterprise_messaging_mom.md) を用いて送信処理を行う |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | トランザクションコミット完了後、およびロールバック時のコールバック内で、送信ステータスの更新処理を行う |
| [DataReadHandler](handlers-DataReadHandler.md) | [../reader/DatabaseRecordReader](../readers/readers-DatabaseRecordReader.md) を使用して処理対象レコードの読込みを行う |

<details>
<summary>keywords</summary>

AsyncMessageSendAction, nablarch.fw.messaging.action.AsyncMessageSendAction, 応答不要電文送信, メッセージ送信バッチ, MessagingContextHandler, TransactionManagementHandler, DataReadHandler, MultiThreadExecutionHandler, messaging_api

</details>

## ハンドラ処理フロー

**[コールバック]**

1. (送信メッセージのメッセージIDを取得) [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) の処理開始前にコールバックされ、起動引数 **-messageRequestId** の値を `CommandLine` オブジェクトより取得する。
2. (データリーダの作成) [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) からコールバックされ、以下のSQLリソースを取得し [../reader/DatabaseRecordReader](../readers/readers-DatabaseRecordReader.md) を作成して返す。

```
(SQL定義配置パッケージ設定値) + "." + (1.で取得したメッセージリクエストID) + "#" + "SELECT_SEND_DATA"
```

**[往路処理]**

3. (送信電文オブジェクトの作成) 送信電文オブジェクト(`SendingMessage`)を生成する。
4. (フレームワーク制御ヘッダ部フォーマット定義を取得) 設定値に指定されたフレームワーク制御ヘッダ定義ファイルを取得する。
5. (フレームワーク制御ヘッダを作成) 4.のフォーマット定義に従い以下の手順で作成し送信電文オブジェクトに設定する。
   - 1.で取得したメッセージリクエストIDを **requestId** フレームワーク制御ヘッダに設定する
   - フレームワーク制御ヘッダ項目名リストと同名フィールドが処理対象レコードに存在すればその値を設定し、存在しない場合はnullを設定する
6. (メッセージデータ部フォーマット定義を取得) 以下のファイル名のフォーマット定義を取得する。

```
(1.で取得したメッセージリクエストID) + "_SEND"
```

7. (メッセージデータ部を作成) 6.のフォーマット定義に従い、処理対象レコードからメッセージデータ部を作成し送信電文オブジェクトに設定する。処理対象レコードの各フィールドがフォーマット定義上の各フィールドの値として設定される。
8. (メッセージ送信) 設定値に指定された送信宛先キュー論理名を送信電文オブジェクトに設定し、カレントスレッド上のメッセージングコンテキストを使用して送信する。

**[往路処理]**

5. (正常終了) 正常終了のマーカオブジェクト(`Result.Success`)をリターンして終了する。このハンドラでは後続ハンドラへの処理移譲は行わない。

**[例外処理]**

明示的な例外制御は行わない。処理中に発生した実行時例外はそのまま送出される。

**[コールバック]**

6. (処理対象レコードステータス変更1) [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でのコミットが完了した場合にコールバックされ、以下のSQLリソースを実行して処理対象レコードのステータスを処理済みに更新する。

```
(SQL定義配置パッケージ設定値) + "." + (1.で取得したメッセージリクエストID) + "#" + "UPDATE_NORMAL_END"
```

6a. (処理対象レコードステータス変更2) 業務トランザクションがロールバックした場合にコールバックされ、以下のSQLリソースを実行して処理対象レコードのステータスをエラーに更新する。

```
(SQL定義配置パッケージ設定値) + "." + (1.で取得したメッセージリクエストID) + "#" + "UPDATE_ABNORMAL_END"
```

7. (ステータス変更エラー) 6.または6a.でのステータス変更の対象となったレコード数が1でなかった場合は、実行時例外を送出する。

<details>
<summary>keywords</summary>

コールバック, CommandLine, DatabaseRecordReader, SendingMessage, Result.Success, SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, メッセージ送信処理フロー, ステータス更新, 往路処理, 例外処理

</details>

## 設定項目・拡張ポイント

設定値は `AsyncMessageSendActionSettings` に集約されている。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| sqlFilePackage | String | ○ | | このハンドラで使用するSQL定義ファイルを格納するパッケージ名 |
| queueName | String | ○ | | メッセージの送信宛先キューの論理名 |
| formatDir | String | | format | 送信電文のフォーマット定義を格納するディレクトリの論理パス |
| headerFormatName | String | ○ | | 送信電文のフレームワーク制御ヘッダのフォーマット定義ファイル名 |
| formClassName | String | ○ | | 送信要求テーブル上の送信ステータス項目更新処理で使用するフォームクラスの名称 |
| headerItemList | List\<String\> | | (なし) | レコードのフィールドのうち送信電文のフレームワーク制御ヘッダとして設定する項目のリスト |
| transactionName | String | | transaction | 送信要求のステータス変更処理で使用するトランザクションの識別名 |

<details>
<summary>keywords</summary>

AsyncMessageSendActionSettings, sqlFilePackage, queueName, formatDir, headerFormatName, formClassName, headerItemList, transactionName, 設定項目

</details>
