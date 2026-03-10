# ウェブサービス編

## RESTfulウェブサービスフレームワークの選択

:ref:`restful_web_service` と :ref:`http_messaging` の2種類のRESTfulウェブサービス用フレームワークを提供。:ref:`restful_web_service` の使用を推奨。

:ref:`restful_web_service` では [Jakarta RESTful Web Services](https://jakarta.ee/specifications/restful-ws/) で規定されている一部のアノテーションを使用して容易にウェブサービスを構築できる。

:ref:`http_messaging` には以下の制約があり柔軟な設計及び実装ができない:

1. HTTPヘッダやボディ部にNablarchの制御用領域が必要。既に構築済みの外部システムと連携するウェブサービスでは設計及び実装の難易度が高くなる。
2. レスポンスヘッダに設定する項目を容易にカスタマイズできない。変更する場合は :ref:`http_messaging_response_building_handler-header` に記載の通りハンドラ自体を差し替える必要がある。
3. :ref:`data_format` 機能に依存。フォーマット定義ファイルの作成が必要で開発コストが高く、カスタマイズが容易でなく、入出力データをMapオブジェクトで扱う必要があり実装ミスを起こしやすい。
4. リクエストボディのパース時の例外が全て単一の例外クラス `MessagingException` にマッピングされるため、根本原因を元に細かな処理制御を行うことができない。

> **補足**: :ref:`restful_web_service` と :ref:`http_messaging` の機能比較は [restful_web_service_functional_comparison](restful-web-service-functional_comparison.md) を参照。
