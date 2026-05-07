## 応答不要電文送信処理用アクションハンドラ

**クラス名:** `nablarch.fw.messaging.action.AsyncMessageSendAction`

-----

-----

### 概要

本クラスは、 [応答不要メッセージ送信常駐バッチ](../../component/libraries/libraries-messaging-sending-batch.md) において、
電文送信処理を実行するアクションハンドラである。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| 共通起動ランチャ | nablarch.fw.handler.Main | CommandLine | Integer | Javaコマンドから直接実行することで、DIリポジトリを初期化し、ハンドラキューを構築・実行する。 | 後続ハンドラの処理結果(整数値)を終了コードに指定し、プロセスを停止する。 | Fatalログを出力しプロセスを異常終了させる。 | - |
| マルチスレッド実行制御ハンドラ | nablarch.fw.handler.MultiThreadExecutionHandler | Object | MultiStatus | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 実行コンテキスト上にデータリーダが存在しない場合は、コールバックを行う。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 | 1. 処理開始前 / 2. データリーダ作成 / 3. スレッド異常終了時 / 4. 処理完了時 |
| メッセージングコンテキスト管理ハンドラ | nablarch.fw.messaging.handler.MessagingContextHandler | Object | Object | メッセージングコンテキスト(MQ接続)を取得し、スレッドローカルに保持する。 | メッセージングコンテキストを開放する。（プールに戻す） | メッセージングコンテキストを開放する。（プールに戻す） | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| データリードハンドラ | nablarch.fw.handler.DataReadHandler | Object | Result | 業務アクションハンドラが決定したデータリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。また実行時IDを採番する。 | - | 読み込んだレコードをログ出力した後、元例外を再送出する。 | - |
| 応答不要電文送信処理用アクションハンドラ | nablarch.fw.messaging.action.AsyncMessageSendAction | SqlRow | Result | テーブル上の各レコードの内容から送信電文オブジェクトを生成し送信する。 | 正常終了(Result.Success)をリターンする。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [共通起動ランチャ](../../component/handlers/handlers-Main.md) | 送信対象電文のリクエストIDを起動時の引数 **-messageRequestId** に指定する。 |
| [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-MessagingContextHandler.md) | 本ハンドラでは、スレッドローカル上の [メッセージングコンテキスト](../../component/libraries/libraries-enterprise-messaging-mom.md#メッセージング基盤api) を用いて送信処理を行う。 |
| [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) | トランザクションコミット完了後、およびロールバック時のコールバック内で、 送信ステータスの更新処理を行う。 |
| [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) | 本ハンドラが作成したデータリーダ ( [データベースレコードリーダ](../../component/readers/readers-DatabaseRecordReader.md) )  を 使用して処理対象レコードの読込みを行う。 |

### ハンドラ処理フロー

**[コールバック]**

**1. (送信メッセージのメッセージIDを取得)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) の処理開始前にコールバックされ、
起動引数 **-messageRequestId** の値を [CommandLine](../../javadoc/nablarch/fw/launcher/CommandLine.html) オブジェクトより取得する。

**2. (データリーダの作成)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) からコールバックされ、送信メッセージの内容が格納されたテーブルに対する
データリーダを作成してリターンする。

具体的には以下のSQLリソースを取得し、そのクエリに対するプリペアドステートメントを使用する
[データベースレコードリーダ](../../component/readers/readers-DatabaseRecordReader.md) を作成して返す。

```bash
(SQL定義配置パッケージ設定値) + "." + ( 1. で取得したメッセージリクエストID ) + "#" + "SELECT_SEND_DATA"
```

**[往路処理]**

**3. (送信電文オブジェクトの作成)**

送信電文オブジェクト( [SendingMessage](../../javadoc/nablarch/fw/messaging/SendingMessage.html) ) を生成する。

**4. (フレームワーク制御ヘッダ部フォーマット定義を取得)**

設定値に指定されたフレームワーク制御ヘッダ定義ファイルを取得する。

**5. (フレームワーク制御ヘッダを作成)**

**4.** で取得したフォーマット定義に従って、フレームワーク制御ヘッダを以下の手順で作成し、
送信電文オブジェクトに設定する。

* **1.** で取得したメッセージリクエストIDを、 **requestId** フレームワーク制御ヘッダに設定。
* フレームワーク制御ヘッダ項目名リストに設定された項目名と同じフィールドが処理対象レコードに定義されていれば
  その値をヘッダ値として設定する。当該のフィールドが存在しない場合は、nullを設定する。

**6. (メッセージデータ部フォーマット定義を取得)**

設定値に指定されたフォーマット定義ファイルの論理パスから、下記ファイル名のフォーマット定義を取得する。

```bash
( 1.で取得したメッセージリクエストID ) + "_SEND"
```

**7. (メッセージデータ部を作成)**

**6.** で取得したフォーマット定義に従って、処理対象レコードからメッセージデータ部を作成し、
送信電文オブジェクトに設定する。
(処理対象レコードの各フィールドが、フォーマット定義上の各フィールドの値として設定される。)

**8. (メッセージ送信)**

設定値に指定された送信宛先キュー論理名を送信電文オブジェクトに設定し、
カレントスレッド上のメッセージングコンテキストを使用して送信する。

**[往路処理]**

**5. (正常終了)**

正常終了のマーカオブジェクト([Result.Success](../../javadoc/nablarch/fw/Result.Success.html))をリターンして終了する。
(このハンドラでは後続ハンドラに対する処理移譲は行わない。)

**[例外処理]**

(本ハンドラでは明示的な例外制御は行わない。処理中に発生した実行時例外はそのまま送出される。)

**[コールバック]**

**6. (処理対象レコードステータス変更1)**

[トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) でのコミットが完了した場合にコールバックされ、
以下のSQLリソースを実行し、処理対象レコードのステータスを処理済みに更新する。

```bash
(SQL定義配置パッケージ設定値) + "." + ( 1. で取得したメッセージリクエストID ) + "#" + "UPDATE_NORMAL_END"
```

**6a. (処理対象レコードステータス変更2)**

[トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) において、業務トランザクションがロールバックした場合に場合にコールバックされ、
以下のSQLリソースを実行し、処理対象レコードのステータスをエラーに更新する。

```bash
(SQL定義配置パッケージ設定値) + "." + ( 1. で取得したメッセージリクエストID ) + "#" + "UPDATE_ABNORMAL_END"
```

**7. (ステータス変更エラー)**

**6.** もしくは **6a.** でのステータス変更の対象となったレコード数が1でなかった場合は、実行時例外を送出する。

### 設定項目・拡張ポイント

本ハンドラの設定値は、 AsyncMessageSendActionSettings に集約されている。
以下はその設定項目の一覧である。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| SQL定義配置パッケージ | sqlFilePackage | String | (必須指定) このハンドラで使用するSQL定義ファイルを格納する パッケージ名を設定する。 |
| 送信宛先キュー論理名 | queueName | String | (必須設定) メッセージの送信宛先キューの論理名を設定する。 |
| フォーマット定義格納ディレクトリ | formatDir | String | (任意指定: デフォルト="format") 送信電文のフォーマット定義を格納するディレクトリ の論理パスを指定する。 |
| ヘッダフォーマット定義名 | headerFormatName | String | (必須指定) 送信電文のフレームワーク制御ヘッダのフォーマット 定義ファイル名を指定する。 |
| フォームクラス名 | formClassName | String | (必須指定) 送信要求テーブル上の送信ステータス項目更新処理で 使用するフォームクラスの名称を指定する。 |
| フレームワーク制御ヘッダ項目リスト | headerItemList | List<String> | (任意指定: デフォルト=ヘッダ項目には何も指定しない) レコードのフィールドのうち、 送信電文のフレームワーク制御ヘッダとして設定する 項目のリストを設定する。 |
| トランザクション名 | transactionName | String | (任意指定: デフォルト="transaction") 送信要求のステータス変更処理で使用する トランザクションの識別名 |
