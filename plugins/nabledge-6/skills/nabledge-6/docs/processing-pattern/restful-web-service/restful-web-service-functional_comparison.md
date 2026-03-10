# Jakarta RESTful Web Servicesサポート/Jakarta RESTful Web Services/HTTPメッセージングの機能比較

## 機能比較表

> **補足**: Jakarta RESTful Web ServicesサポートとHTTPメッセージングの表内マークはクリックで解説ページへ遷移する。

凡例: ○=提供あり　△=一部提供あり　×=提供なし　－=対象外

| 機能 | Jakarta RESTful Web Servicesサポート | HTTPメッセージング | Jakarta RESTful Web Services |
|---|---|---|---|
| リクエストとリソースメソッドのマッピング | :ref:`△ <rest-action_mapping>` | :ref:`○ <http_messaging-action_mapping>` | ○ |
| リクエストとパラメータのマッピング | :ref:`△ <rest-path_query_param>` | × [1] | ○ |
| HTTPメソッドのマッチング | :ref:`△ <rest-action_mapping>` | × [1] | ○ |
| メディアタイプに応じたリクエスト/レスポンスの変換 | :ref:`△ <body_convert_handler>` | × [1] | ○ |
| エンティティのバリデーション | :ref:`○ <rest-request_validation>` | :ref:`○ <http_messaging-request_validation>` | ○ |
| リソースクラスへのインジェクション（Jakarta Contexts and Dependency Injection） | × [2] | × [2] | ○ |
| リクエスト/レスポンスに対するフィルタ | × [3] | × [3] | ○ |
| ボディの読み書きに対するインターセプタ | × [4] | × [5] | ○ |
| クライアントAPI | × [6] | :ref:`○ <http_system_messaging-message_send>` | ○ |
| 非同期処理 | × [7] | × [7] | ○ |
| エラー時ログ出力 | :ref:`○ <jaxrs_response_handler-error_log>` | :ref:`○ <http_messaging_error_handler-error_response_and_log>` | — |
| リクエストボディの最大容量チェック | × [8] | :ref:`○ <http_messaging_request_parsing_handler-limit_size>` | — |
| 証跡ログの出力 | × [9] | :ref:`○ <messaging_log>` | — |
| 再送制御 | × [9] | :ref:`○ <message_resend_handler>` | — |
| サービス提供の可否チェック | × [10] | × [10] | — |
| トランザクション制御 | × [11] | × [11] | — |
| 業務処理エラー時のコールバック | × [12] | `○` | — |

[1] HTTPメッセージングはRESTを考慮した作りになっていない。RESTfulウェブサービスには、Jakarta RESTful Web Servicesサポートを使用する。
[2] Jakarta RESTful Web ServicesサポートとHTTPメッセージングは、Nablarchのウェブアプリケーションとして動作するため、Jakarta Contexts and Dependency Injectionは使用できない。
[3] リクエスト/レスポンスに対するフィルタを作りたい場合は、ハンドラを作成する。
[4] ボディの読み書きに対するインターセプタを作りたい場合は、Jakarta RESTful Web ServicesサポートのBodyConverterを作成する。
[5] ボディの読み書きにはNablarchのデータフォーマットを使用している。変更したい場合は、データフォーマットのDataRecordFormatterを作成する。
[6] Jakarta RESTful Web Servicesクライアントが必要な場合は、Jakarta RESTful Web Servicesの実装（JerseyやRESTEasyなど）を使用する。
[7] サーバサイドで非同期処理が必要になる要件がないと想定している。要望があれば対応を検討する。
[8] ウェブサーバやアプリケーションサーバにあるリクエストサイズをチェックする機能を使用する。
[9] アプリケーションごとに要件が異なると想定している。アプリケーションで設計/実装する。
[10] Nablarchにあるサービス提供可否チェックがアプリケーションの要件にマッチする場合はそれを使用する。マッチしない場合は、アプリケーションで設計/実装する。
[11] Nablarchにあるトランザクション管理を使用する。
[12] エラー処理は共通化し、JaxRsResponseHandlerをカスタマイズすることを想定している。業務処理で個別にエラー処理をしたい場合は、リソースメソッドにてtry/catchを使用する。
