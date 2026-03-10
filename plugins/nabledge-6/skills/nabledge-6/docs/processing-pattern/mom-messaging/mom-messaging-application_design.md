# アプリケーションの責務配置

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/mom/application_design.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/FwHeaderReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/MessageReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Success.html)

## アプリケーションの責務配置

**クラス構成（MOMメッセージング）**:
- アクションクラス: データリーダからの要求電文を元に業務ロジックを実行し、応答電文を返す
- フォームクラス: 要求電文をマッピングし、バリデーションアノテーションと相関バリデーションロジックを持つ
- エンティティクラス: テーブルと1対1対応

**アクションクラス**
`FwHeaderReader` / `MessageReader` が読み込んだ `RequestMessage` を元に業務ロジックを実行し、`ResponseMessage` を返却する。

要求電文取り込み時の業務ロジック:
1. 要求電文からフォームクラスを作成してバリデーションを行う
2. フォームクラスからエンティティクラスを作成してデータベースにデータを追加する
3. 応答電文を作成して返す

> **補足**: 応答不要メッセージングでは以下が異なる: (1) データ取り込みが目的で、業務ロジックは後続するバッチが行うため、バリデーションを行わない (2) 電文を返さないため処理結果として `Success` を返す

**フォームクラス**
`RequestMessage` をマッピングするクラス。バリデーション用アノテーションの設定と相関バリデーションロジックを持つ。プロパティは全て `String` で定義する（バイナリ項目のみバイト配列）。`String` とすべき理由は :ref:`bean_validation-form_property` 参照。

**エンティティクラス**
テーブルと1対1に対応するクラス。カラムに対応するプロパティを持つ。

> **重要**: メッセージングはシステムで共通のデータリーダを使用するため、:ref:`Nablarchバッチアプリケーションの責務配置<nablarch_batch-application_design>` と異なり、アクションはデータリーダを生成する責務を持たない。メッセージングで使用するデータリーダはコンポーネント定義に `dataReader` という名前で追加する。

<details>
<summary>keywords</summary>

FwHeaderReader, MessageReader, RequestMessage, ResponseMessage, nablarch.fw.messaging.reader.FwHeaderReader, nablarch.fw.messaging.reader.MessageReader, nablarch.fw.messaging.RequestMessage, nablarch.fw.messaging.ResponseMessage, nablarch.fw.Result.Success, MOMメッセージング, アクションクラス, フォームクラス, エンティティクラス, データリーダ, 責務配置, 応答不要メッセージング

</details>
