# 再送電文制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/mom_messaging/message_resend_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/MessageResendHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/tableschema/SentMessageTableSchema.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/InterSystemMessage.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/StandardFwHeaderDefinition.html)

## ハンドラクラス名

再送電文制御ハンドラは、同一の電文を繰り返し受信した際の再送制御を行う。応答電文が既に作成済みの場合、業務処理をスキップして保存済み応答電文を自動送信する。

> **補足**: (1) 既に応答電文が作成済みの場合、業務処理を省略しシステム負荷を低減できる。(2) DB登録処理の場合、業務処理省略により2重取り込み防止ロジックの実装が不要になる。

処理の流れ:
1. 応答電文の保存処理
2. 再送電文の場合: 保存した応答電文を送信
3. 再送電文以外または保存済み応答電文がない場合: 後続ハンドラへ処理を委譲

**クラス名**: `nablarch.fw.messaging.handler.MessageResendHandler`

<details>
<summary>keywords</summary>

MessageResendHandler, nablarch.fw.messaging.handler.MessageResendHandler, 再送電文制御, 応答電文自動送信, 2重取り込み防止

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-messaging, com.nablarch.framework, モジュール依存関係

</details>

## 制約

- [message_reply_handler](handlers-message_reply_handler.md) よりも後ろに設定すること: 本ハンドラで作成した応答電文を送信するために [message_reply_handler](handlers-message_reply_handler.md) が必要なため。
- [transaction_management_handler](handlers-transaction_management_handler.md) よりも後ろに設定すること: 本ハンドラはDBに応答電文を保存するため、トランザクション制御を行う [transaction_management_handler](handlers-transaction_management_handler.md) よりも後ろに設定が必要。

<details>
<summary>keywords</summary>

message_reply_handler, transaction_management_handler, ハンドラ設定順序, ハンドラ制約

</details>

## 応答電文の保存先について

後続ハンドラで作成された応答電文はDBテーブルに保存する。デフォルトのテーブル名・カラム名は `SentMessageTableSchema` を参照。

| カラム名 | 制約等 | 格納する値 |
|---|---|---|
| リクエストID | 主キー、文字列型 | 要求電文のリクエストID |
| メッセージID | 主キー、文字列型 | 要求電文のメッセージID（再送電文の場合は相関メッセージIDを使用。詳細は [message_resend_handler-resent_message](#s4)） |
| 宛先キューの論理名 | 文字列型 | 応答電文の宛先キュー論理名（`InterSystemMessage#getDestination()`） |
| 処理結果コード | 文字列型 | `ResponseMessage#getStatusCode()` |
| 応答電文 | バイナリ型 | `ResponseMessage#getBodyBytes()` |

テーブル名・カラム名の変更は `SentMessageTableSchema` および `sentMessageTableSchemaプロパティ` で設定可能。

<details>
<summary>keywords</summary>

SentMessageTableSchema, nablarch.fw.messaging.tableschema.SentMessageTableSchema, sentMessageTableSchema, 応答電文保存テーブル, InterSystemMessage, ResponseMessage

</details>

## 同一電文(再送電文)の判定方法

以下の条件を両方満たす電文を処理済み要求電文（再送電文）と判断し、保存済み応答電文を返却する:
1. フレームワーク制御ヘッダの再送要求フラグに値が設定されている
2. 受信した要求電文のリクエストIDとメッセージIDに紐づくデータが応答電文保存テーブルに存在する

フレームワーク制御ヘッダの詳細は [フレームワーク制御ヘッダ](../libraries/libraries-mom_system_messaging.md) を参照。

> **重要**: 相手先システムが電文を再送する際は以下の制約を満たすこと。満たせない場合、本ハンドラは使用不可のため、プロジェクト側で再送制御ハンドラを新たに作成すること。
> - 再送電文の相関メッセージIDに初回送信時の要求電文のメッセージIDを設定すること
> - フレームワーク制御ヘッダの再送要求フラグに値を設定すること

<details>
<summary>keywords</summary>

再送要求フラグ, 相関メッセージID, フレームワーク制御ヘッダ, 同一電文判定, 再送電文条件

</details>

## フレームワーク制御ヘッダの設定

フレームワーク制御ヘッダの定義を変更する場合は `fwHeaderDefinition` プロパティにプロジェクト拡張の定義を設定する。未設定時はデフォルトの `StandardFwHeaderDefinition` が使用される。

```xml
<component class="nablarch.fw.messaging.handler.MessageResendHandler">
  <property name="fwHeaderDefinition">
    <component class="sample.SampleFwHeaderDefinition" />
  </property>
</component>
```

フレームワーク制御ヘッダの詳細は [フレームワーク制御ヘッダ](../libraries/libraries-mom_system_messaging.md) を参照。

<details>
<summary>keywords</summary>

fwHeaderDefinition, StandardFwHeaderDefinition, nablarch.fw.messaging.StandardFwHeaderDefinition, フレームワーク制御ヘッダ定義カスタマイズ

</details>
