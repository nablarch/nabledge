# 再送電文制御ハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.messaging.handler.MessageResendHandler`

同一電文を繰り返し受信した際に、応答電文が作成済みかを判断する。作成済みの場合、業務処理を省略して保存済み応答電文を自動送信する。

> **補足**: 業務処理を省略することでシステム負荷を低減できる。DBへの登録処理での2重取り込み防止ロジックの実装が不要になる。

処理フロー:
1. 応答電文の保存処理
2. 再送電文の場合: 保存済み応答電文を送信
3. 再送電文以外または保存済み応答電文がない場合: 後続ハンドラへ委譲

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
```

## 制約

- :ref:`message_reply_handler` よりも後ろに設定すること: 作成した応答電文を送信するために、:ref:`message_reply_handler` より後ろに配置する必要がある。
- :ref:`transaction_management_handler` よりも後ろに設定すること: 応答電文をDBに保存するため、:ref:`transaction_management_handler` より後ろに配置する必要がある。

## 応答電文の保存先について

後続ハンドラで作成された応答電文はDBテーブルに格納する。予め応答電文の保存用テーブルを作成しておく必要がある。

| カラム名 | 制約等 | 格納する値 |
|---|---|---|
| リクエストID | 主キー / 文字列型 | 要求電文のリクエストID |
| メッセージID | 主キー / 文字列型 | 要求電文のメッセージID。再送電文の場合はメッセージIDではなく相関メッセージIDを使用する |
| 宛先キューの論理名 | 文字列型 | 応答電文送信先キューの論理名 (`InterSystemMessage#getDestination()`) |
| 処理結果コード | 文字列型 | 応答電文の処理結果コード (`ResponseMessage#getStatusCode()`) |
| 応答電文 | バイナリ型 | 応答電文の内容 (`ResponseMessage#getBodyBytes()`) |

デフォルトのテーブル名・カラム名は `SentMessageTableSchema` を参照。変更する場合は `sentMessageTableSchemaプロパティ` で設定可能。

## 同一電文(再送電文)の判定方法

以下の条件を両方満たす場合、再送電文（処理済み）と判定し、保存済み応答電文を返却する:
- フレームワーク制御ヘッダの再送要求フラグに値が設定されている
- 受信した要求電文のリクエストIDとメッセージIDに紐づくデータが応答電文保存テーブルに存在している

フレームワーク制御ヘッダの詳細は :ref:`フレームワーク制御ヘッダ <mom_system_messaging-fw_header>` を参照。

> **重要**: 相手先システムが要求電文を再送する際は以下の制約を満たす必要がある。満たせない場合は本ハンドラを使用できないため、プロジェクト側で再送制御ハンドラを新規作成すること。
> - 再送電文の相関メッセージIDには、初回送信時の要求電文のメッセージIDを設定すること
> - フレームワーク制御ヘッダの再送要求フラグに値を設定すること

## フレームワーク制御ヘッダの設定

応答電文内のフレームワーク制御ヘッダ定義を変更する場合、プロジェクトで拡張したフレームワーク制御ヘッダ定義を設定する。未設定の場合はデフォルトの `StandardFwHeaderDefinition` が使用される。

```xml
<component class="nablarch.fw.messaging.handler.MessageResendHandler">
  <property name="fwHeaderDefinition">
    <component class="sample.SampleFwHeaderDefinition" />
  </property>
</component>
```
