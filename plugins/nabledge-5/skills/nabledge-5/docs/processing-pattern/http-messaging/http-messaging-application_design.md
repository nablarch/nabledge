# アプリケーションの責務配置

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/application_design.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html)

## アプリケーションの責務配置

HTTPメッセージングのクラス構成と責務:

**アクションクラス**: `RequestMessage` を受け取り、業務ロジックを実行し `ResponseMessage` を返すクラス

- リクエスト取り込み処理の例: (1) リクエストメッセージからフォームクラスを作成しバリデーション (2) フォームからエンティティを作成しDB登録 (3) レスポンスメッセージを作成して返却

**フォームクラス**: `RequestMessage` をマッピングするクラス

- バリデーションアノテーションの設定・相関バリデーションロジックを持つ
- プロパティは全て `String` で定義（理由: [Bean Validation](../../component/libraries/libraries-bean_validation.md) 参照）
- バイナリ項目の場合はバイト配列で定義

**エンティティクラス**: テーブルと1対1で対応するクラス。カラムに対応するプロパティを持つ。

<details>
<summary>keywords</summary>

RequestMessage, ResponseMessage, アクションクラス, フォームクラス, エンティティクラス, HTTPメッセージング, バリデーション, 責務配置

</details>
