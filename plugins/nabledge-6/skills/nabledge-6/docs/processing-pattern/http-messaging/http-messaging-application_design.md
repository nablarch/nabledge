# アプリケーションの責務配置

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/application_design.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html)

## アプリケーションの責務配置

**アクションクラス**: `RequestMessage` を元に業務ロジックを実行し、`ResponseMessage` を作成して返却する。例えば、リクエストメッセージの取り込み処理であれば、業務ロジックとして以下の処理を行う。

1. リクエストメッセージからフォームクラスを作成し、バリデーションを行う
2. フォームクラスからエンティティクラスを作成して、データベースにデータを追加する
3. レスポンスメッセージを作成し返却する

**フォームクラス**: `RequestMessage` をマッピングするクラス。バリデーションアノテーションの設定と相関バリデーションロジックを持つ。プロパティは全て `String` で定義する（バイナリ項目はバイト配列）（[Bean Validation](../../component/libraries/libraries-bean_validation.md) 参照）。

**エンティティクラス**: テーブルと1対1で対応するクラス。カラムに対応するプロパティを持つ。

<details>
<summary>keywords</summary>

RequestMessage, ResponseMessage, nablarch.fw.messaging.RequestMessage, nablarch.fw.messaging.ResponseMessage, アクションクラス, フォームクラス, エンティティクラス, HTTPメッセージング責務配置, バリデーション

</details>
