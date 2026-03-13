# ウェブサービス編

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessagingException.html)

## RESTfulウェブサービスフレームワーク選択

NablarchはRESTfulウェブサービス用フレームワークを2種類提供している: :ref:`restful_web_service` と :ref:`http_messaging`。

:ref:`restful_web_service` の使用を推奨。理由: [JSR 339(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=339) で規定されている一部のアノテーションを使用して容易にウェブサービスを構築できる。

:ref:`http_messaging` には以下の制約があり、柔軟な設計・実装ができない:

1. **Nablarchの制御用領域がHTTPヘッダやボディ部に必要** — 既存外部システムと連携するウェブサービスの設計・実装難易度が高くなる
2. **レスポンスヘッダのカスタマイズが容易でない** — 変更する場合は [http_messaging_response_building_handler-header](../../component/handlers/handlers-http_messaging_response_building_handler.md) に記載の通りハンドラ自体を差し替える必要がある
3. **[data_format](../../component/libraries/libraries-data_format.md) 機能依存** — フォーマット定義ファイルの作成が必要で開発コストが高くなる。カスタマイズが容易でなく、入出力データをMapオブジェクトで扱う必要があり実装ミスを起こしやすい
4. **リクエストボディのパース例外が全て `MessagingException` にマッピング** — 根本原因による細かい例外ハンドリング不可

> **補足**: :ref:`restful_web_service` と :ref:`http_messaging` の機能比較は :ref:`restful_web_service_functional_comparison` を参照。

<details>
<summary>keywords</summary>

restful_web_service, http_messaging, MessagingException, JSR 339, JAX-RS, RESTfulウェブサービス, フレームワーク選択, http_messaging制約

</details>
