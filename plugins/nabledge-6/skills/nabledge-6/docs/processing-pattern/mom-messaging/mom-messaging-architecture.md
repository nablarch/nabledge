# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/mom/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/FwHeaderReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/MessageReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/StatusCodeConvertHandler.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/AsyncMessageReceiveAction.html)

## MOMメッセージングの構成

MOMメッセージングは、外部からの要求電文に対し電文中のリクエストIDに対応するアクションを実行する（MQはメッセージキューの略称）。

**同期応答メッセージング**: 業務処理の実行結果をもとに応答電文を作成してMQに送信する。オーソリ業務のような即時応答が必要な場合に使用する。

**応答不要メッセージング**: 応答電文を送信せず、MQから受信した要求電文の内容をDBテーブルに格納する。業務処理はこのテーブルを入力とする後続バッチ（:ref:`db_messaging`）で実行する。

> **補足**: 応答不要メッセージングはフレームワーク提供のアクションクラスをそのまま使用でき、コーディングは不要。

> **重要**: MOMメッセージングで扱える形式は、:ref:`data_format` の固定長データのみである。

メッセージの送受信には :ref:`mom_system_messaging` を使用する。MOMメッセージングの構成は :ref:`nablarch_batch` とまったく同じである（:ref:`nablarch_batch-structure` 参照）。

<details>
<summary>keywords</summary>

MOMメッセージング, 同期応答メッセージング, 応答不要メッセージング, 固定長データ, メッセージキュー, MQ, db_messaging, mom_system_messaging, data_format

</details>

## 要求電文によるアクションとリクエストIDの指定

要求電文中の特定フィールドをリクエストIDとして使用する。ウェブアプリケーションのリクエストパスとは異なり、リクエストIDには階層構造が含まれない。

:ref:`request_path_java_package_mapping` を使用し、アクションクラスのパッケージやクラス名のサフィックスを設定でリクエストIDに対応するクラスへディスパッチする。

リクエストIDは要求電文中のフレームワーク制御ヘッダ部に含める必要がある（:ref:`フレームワーク制御ヘッダ <mom_system_messaging-fw_header>` 参照）。

<details>
<summary>keywords</summary>

リクエストID, フレームワーク制御ヘッダ, request_path_java_package_mapping, アクションディスパッチ, mom_system_messaging-fw_header

</details>

## MOMメッセージングの処理の流れ

応答不要メッセージングは応答電文を返却しない点のみ異なる。

1. :ref:`共通起動ランチャ(Main) <main>` がハンドラキューを実行する。
2. `FwHeaderReader` / `MessageReader` がMQを監視し、受信電文を1件ずつ提供する。
3. ハンドラキューが要求電文の特定フィールドのリクエストIDをもとにアクションクラスを特定し、ハンドラキュー末尾に追加する。
4. アクションクラスがフォーム/エンティティクラスを使用して業務ロジックを実行する。
5. アクションクラスが `ResponseMessage` を返却する。
6. プロセス停止要求があるまで2〜5を繰り返す。
7. `StatusCodeConvertHandler` がステータスコードをプロセス終了コードに変換し、処理結果として返す。

<details>
<summary>keywords</summary>

FwHeaderReader, MessageReader, ResponseMessage, StatusCodeConvertHandler, 処理フロー, ハンドラキュー, MOMメッセージング処理の流れ

</details>

## MOMメッセージングで使用するハンドラ

## 利用可能なハンドラ

**リクエスト/レスポンス変換**:
- :ref:`status_code_convert_handler`
- :ref:`data_read_handler`

**プロセス実行制御**:
- :ref:`duplicate_process_check_handler`
- :ref:`multi_thread_execution_handler`
- :ref:`retry_handler`
- :ref:`request_thread_loop_handler`
- :ref:`process_stop_handler`
- :ref:`request_path_java_package_mapping`

**メッセージング関連**:
- :ref:`messaging_context_handler`
- :ref:`message_reply_handler`
- :ref:`message_resend_handler`

**DB関連**:
- :ref:`database_connection_management_handler`
- :ref:`transaction_management_handler`

**エラー処理**:
- :ref:`global_error_handler`

**その他**:
- :ref:`thread_context_handler`
- :ref:`thread_context_clear_handler`
- :ref:`ServiceAvailabilityCheckHandler`

## 同期応答メッセージングの最小ハンドラ構成

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換する | — |
| 2 | :ref:`global_error_handler` | メイン | — | — | 実行時例外/エラーの場合、ログ出力する |
| 3 | :ref:`multi_thread_execution_handler` | メイン | サブスレッドを作成し後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッドの完了まで待機し起因例外を再送出 |
| 4 | :ref:`retry_handler` | サブ | — | — | リトライ可能な実行時例外を捕捉し、リトライ上限未達なら後続ハンドラを再実行 |
| 5 | :ref:`messaging_context_handler` | サブ | MQ接続を取得 | MQ接続を解放 | — |
| 6 | :ref:`database_connection_management_handler` | サブ | DB接続を取得 | DB接続を解放 | — |
| 7 | :ref:`request_thread_loop_handler` | サブ | 後続ハンドラを繰り返し実行 | ハンドラキューを復旧しループ継続 | プロセス停止要求か致命的エラーの場合のみループ停止 |
| 8 | :ref:`thread_context_clear_handler` | サブ | — | :ref:`thread_context_handler` でスレッドローカルに設定した値を全削除 | — |
| 9 | :ref:`thread_context_handler` | サブ | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数を初期化 | — | — |
| 10 | :ref:`process_stop_handler` | サブ | リクエストテーブルの停止フラグがオンの場合、後続ハンドラを実行せず `ProcessStop` を送出 | — | — |
| 11 | :ref:`message_reply_handler` | サブ | — | 後続ハンドラの応答電文をもとにMQへ送信 | エラー内容をもとにMQへ送信 |
| 12 | :ref:`data_read_handler` | サブ | データリーダで要求電文を1件読み込み後続ハンドラへ渡す。実行時IDを採番 | — | 読み込んだ電文をログ出力後、元例外を再送出 |
| 13 | :ref:`request_path_java_package_mapping` | サブ | リクエストIDをもとに呼び出すアクションを決定 | — | — |
| 14 | :ref:`transaction_management_handler` | サブ | トランザクションを開始 | トランザクションをコミット | トランザクションをロールバック |

## 応答不要メッセージングの最小ハンドラ構成

同期応答メッセージングから :ref:`message_reply_handler` と :ref:`message_resend_handler` を除いた構成。

> **重要**: 応答不要メッセージングでは、電文保存失敗時にエラー応答を送信できないため、取得電文をキューに戻して既定回数リトライする。DBへの登録処理とキュー操作を1つのトランザクション（2相コミット制御）として扱う必要がある。:ref:`transaction_management_handler` を2相コミット対応実装に差し替えること。NablarchではIBM MQ用の2相コミットアダプタを提供（:ref:`webspheremq_adaptor` 参照）。

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換する | — |
| 2 | :ref:`global_error_handler` | メイン | — | — | 実行時例外/エラーの場合、ログ出力する |
| 3 | :ref:`multi_thread_execution_handler` | メイン | サブスレッドを作成し後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッドの完了まで待機し起因例外を再送出 |
| 4 | :ref:`retry_handler` | サブ | — | — | リトライ可能な実行時例外を捕捉し、リトライ上限未達なら後続ハンドラを再実行 |
| 5 | :ref:`messaging_context_handler` | サブ | MQ接続を取得 | MQ接続を解放 | — |
| 6 | :ref:`database_connection_management_handler` | サブ | DB接続を取得 | DB接続を解放 | — |
| 7 | :ref:`request_thread_loop_handler` | サブ | 後続ハンドラを繰り返し実行 | ハンドラキューを復旧しループ継続 | プロセス停止要求か致命的エラーの場合のみループ停止 |
| 8 | :ref:`thread_context_clear_handler` | サブ | — | :ref:`thread_context_handler` でスレッドローカルに設定した値を全削除 | — |
| 9 | :ref:`thread_context_handler` | サブ | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数を初期化 | — | — |
| 10 | :ref:`process_stop_handler` | サブ | リクエストテーブルの停止フラグがオンの場合、後続ハンドラを実行せず `ProcessStop` を送出 | — | — |
| 11 | :ref:`transaction_management_handler` | サブ | トランザクションを開始 | トランザクションをコミット | トランザクションをロールバック |
| 12 | :ref:`data_read_handler` | サブ | データリーダで要求電文を1件読み込み後続ハンドラへ渡す。実行時IDを採番 | — | 読み込んだ電文をログ出力後、元例外を再送出 |
| 13 | :ref:`request_path_java_package_mapping` | サブ | リクエストIDをもとに呼び出すアクションを決定 | — | — |

<details>
<summary>keywords</summary>

ハンドラキュー, 最小ハンドラ構成, 同期応答メッセージング, 応答不要メッセージング, 2相コミット, message_reply_handler, transaction_management_handler, ProcessStop, webspheremq_adaptor

</details>

## MOMメッセージングで使用するデータリーダ

- `FwHeaderReader`: 電文からフレームワーク制御ヘッダを読み込む
- `MessageReader`: MQから電文を読み込む

> **補足**: 上記で要件を満たせない場合は、`DataReader` インタフェースを実装したクラスをプロジェクトで作成する。

<details>
<summary>keywords</summary>

FwHeaderReader, MessageReader, DataReader, データリーダ, 電文読み込み

</details>

## MOMメッセージングで使用するアクション

- `MessagingAction`: 同期応答メッセージング用アクションのテンプレートクラス
- `AsyncMessageReceiveAction`: 応答不要メッセージングのアクションクラス

<details>
<summary>keywords</summary>

MessagingAction, AsyncMessageReceiveAction, アクションクラス, 同期応答メッセージング, 応答不要メッセージング

</details>
