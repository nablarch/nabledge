# Jakarta RESTful Web Servicesサポート/Jakarta RESTful Web Services/HTTPメッセージングの機能比較

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/functional_comparison.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html)

## 機能比較表

> **補足**: Jakarta RESTful Web ServicesサポートとHTTPメッセージングの表内マークはクリックで解説ページへ遷移する。

凡例: ○=提供あり　△=一部提供あり　×=提供なし　－=対象外

| 機能 | Jakarta RESTful Web Servicesサポート | HTTPメッセージング | Jakarta RESTful Web Services |
|---|---|---|---|
| リクエストとリソースメソッドのマッピング | [△](restful-web-service-feature_details.md) | [○](../http-messaging/http-messaging-feature_details.md) | ○ |
| リクエストとパラメータのマッピング | [△](restful-web-service-feature_details.md) | × [1] | ○ |
| HTTPメソッドのマッチング | [△](restful-web-service-feature_details.md) | × [1] | ○ |
| メディアタイプに応じたリクエスト/レスポンスの変換 | [△](../../component/handlers/handlers-body_convert_handler.md) | × [1] | ○ |
| エンティティのバリデーション | [○](restful-web-service-feature_details.md) | [○](../http-messaging/http-messaging-feature_details.md) | ○ |
| リソースクラスへのインジェクション（Jakarta Contexts and Dependency Injection） | × [2] | × [2] | ○ |
| リクエスト/レスポンスに対するフィルタ | × [3] | × [3] | ○ |
| ボディの読み書きに対するインターセプタ | × [4] | × [5] | ○ |
| クライアントAPI | × [6] | [○](../../component/libraries/libraries-http_system_messaging.md) | ○ |
| 非同期処理 | × [7] | × [7] | ○ |
| エラー時ログ出力 | [○](../../component/handlers/handlers-jaxrs_response_handler.md) | [○](../../component/handlers/handlers-http_messaging_error_handler.md) | — |
| リクエストボディの最大容量チェック | × [8] | [○](../../component/handlers/handlers-http_messaging_request_parsing_handler.md) | — |
| 証跡ログの出力 | × [9] | [○](../../component/libraries/libraries-messaging_log.md) | — |
| 再送制御 | × [9] | [○](../../component/handlers/handlers-message_resend_handler.md) | — |
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

<details>
<summary>keywords</summary>

機能比較, Jakarta RESTful Web Servicesサポート, HTTPメッセージング, Jakarta RESTful Web Services, リクエストマッピング, バリデーション, クライアントAPI, MessagingAction, BodyConverter, DataRecordFormatter, JaxRsResponseHandler, RESTfulウェブサービス選択, 非同期処理, トランザクション制御

</details>
