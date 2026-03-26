# 同期応答電文送信処理用業務アクションハンドラのテンプレートクラス

## 

同期応答電文送信処理用業務アクションハンドラのテンプレートクラス。

**クラス名**: `nablarch.fw.action.MessagingAction`

<details>
<summary>keywords</summary>

MessagingAction, nablarch.fw.action.MessagingAction, 同期応答電文送信, 業務アクションハンドラ

</details>

## 概要

[../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) における業務アクションハンドラを実装する際に使用するテンプレートクラス。

<details>
<summary>keywords</summary>

テンプレートクラス, messaging_request_reply, 同期応答電文送信処理, 業務アクションハンドラ実装

</details>

## 

本クラスを継承してアクションハンドラを実装する際のテンプレートメソッド:

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| onReceive() | 必須 | 往路処理で呼ばれる。`RequestMessage` をもとに業務処理を実行し、`ResponseMessage` に応答内容を格納してリターンする。 |
| onError() | 任意 | 業務トランザクションがロールバックされた時点で [TransactionManagementHandler](handlers-TransactionManagementHandler.md) からコールバックされる。エラー応答電文を返す。オーバーライドしない場合はFW制御ヘッダのみ設定された電文が返される。 |
| usesAutoRead() | 任意 | 要求電文データ部の自動読み込みの有無を指定。マルチレコード/マルチフォーマット構成の場合はfalseを返すようオーバーライドすることでデータ部を手動解析できる。 |

```java
RequestMessage   req;
ResponseMessage  res;
ExecutionContext ctx;

req = receive();

try {
    if (usesAutoRead()) {
        req.readRecord(); // 要求電文のデータ部からデータレコードを自動的に読み込む(主にシングルレコード形式で使用)
    }
    res = onReceive(req, ctx); // 要求電文毎に呼ばれる
    commit(); // 業務トランザクションをコミット
} catch(e) {
    rollback(); // 業務トランザクションをロールバック
    res = onError(e, req, ctx); // 業務処理で例外が発生しロールバックされた直後に呼ばれる。エラー応答電文を返す。
} finally {
    send(res); // 応答電文を送信
}
```

> **注意**: このコードは説明用に単純化したものであり、実際の処理フローはハンドラ構成によって制御される。

<details>
<summary>keywords</summary>

onReceive, onError, usesAutoRead, RequestMessage, ResponseMessage, テンプレートメソッド, マルチレコード, マルチフォーマット, TransactionManagementHandler, ExecutionContext

</details>

## ハンドラ処理フロー

**[往路処理]**

1. (業務データ部の自動読み込み) usesAutoRead()がtrueの場合、`RequestMessage` の readRecord() を呼び出し業務データレコードを読み込む。読み込んだデータは getParamMap() 等でフィールド名をキーとするMapとしてアクセス可能。
2. (業務ロジックの実行) onReceive() を実行し応答電文オブジェクトを取得する。

**[復路処理]**

3. (正常終了) onReceive() の応答電文オブジェクトをリターンして終了。

**[例外処理]**

- (データ終端エラー) readRecord() 実行時にデータ部の終端に達しなかった場合、`InvalidDataFormatException` を送出する。

> **注意**: 電文内に複数レコードが格納される場合は、usesAutoRead() をオーバーライドしてfalseを返すこと。

**[コールバック]**

4. (エラー応答電文の制御) [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、onError() を実行しエラー応答電文オブジェクトを返す。

<details>
<summary>keywords</summary>

InvalidDataFormatException, readRecord, getParamMap, 往路処理, 復路処理, 例外処理, コールバック, データ終端エラー, TransactionManagementHandler

</details>
