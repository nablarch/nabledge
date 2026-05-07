# ウェブサービス編

本章ではNablarchアプリケーションフレームワークを使用してウェブサービスを開発するために必要となる情報を提供する。

Nablarchでは、以下2種類のRESTfulウェブサービス用のフレームワークを提供している。

rest/index
http_messaging/index

これらのどちらのフレームワークを使用してもウェブサービスを構築できるが、
以下の理由により [RESTfulウェブサービス編](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) を使用してウェブサービスを作成することを推奨する。

理由

[RESTfulウェブサービス編](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) では、 [Jakarta RESTful Web Services(外部サイト、英語)](https://jakarta.ee/specifications/restful-ws/) で規定されている一部のアノテーションを使用して容易にウェブサービスを構築できる。

一方、 [HTTPメッセージング編](../../processing-pattern/http-messaging/http-messaging-http-messaging.md#http-messaging) はボディ部やHTTPヘッダ、例外制御に以下の制約があり柔軟な設計及び実装ができない。

* Nablarchの制御用領域がHTTPヘッダやボディ部に必要となる。

  既に構築済みの外部システムと連携するようなウェブサービスを構築する場合に設計及び実装の難易度が高くなる。
* レスポンスヘッダに設定する項目を容易にカスタマイズ出来ない。

  [レスポンスヘッダに設定される値](../../component/handlers/handlers-http-messaging-response-building-handler.md#http-messaging-response-building-handler-header) に記載がある通り、レスポンスヘッダの変更したい場合はハンドラ自体を差し替える必要がある。
* [汎用データフォーマット](../../component/libraries/libraries-data-format.md#data-format) 機能に依存している。

  フォーマット定義ファイルを作成する必要があり、開発コストが高くなる。
  また、カスタマイズが容易でなく、入出力データをMapオブジェクトで扱う必要があり、実装ミスを起こしやすい。
* リクエストボディのパース時の例外が全て単一の例外クラスにマッピングされるため細かく例外ハンドリングできない。

  パース中の例外は全て MessagingException として送出されるため、根本原因を元に細かな処理制御を行うことが出来ない。

> **Tip:**
> [RESTfulウェブサービス編](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) と [HTTPメッセージング編](../../processing-pattern/http-messaging/http-messaging-http-messaging.md#http-messaging) で提供している機能の違いは、[Jakarta RESTful Web Servicesサポート/Jakarta RESTful Web Services/HTTPメッセージングの機能比較](../../processing-pattern/restful-web-service/restful-web-service-functional-comparison.md#restful-web-service-functional-comparison) を参照。

functional_comparison
