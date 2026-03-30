# 同期応答電文送信処理用業務アクションハンドラのテンプレートクラス

## 概要

**クラス名**: `nablarch.fw.action.MessagingAction`

[../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) の業務アクションハンドラを実装するためのテンプレートクラス。

以下のテンプレートメソッドを必要に応じて実装する。

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| onReceive() | 必須 | 往路処理内で呼ばれる。`RequestMessage` の内容をもとに業務処理を実行し、`ResponseMessage` に応答内容を格納してリターンする |
| onError() | 任意 | [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた時点でコールバックされる。エラー応答電文を作成してリターンする。オーバーライドしない場合はFW制御ヘッダのみが設定された電文がエラー応答として送信される |
| usesAutoRead() | 任意 | 要求電文データ部の自動読み込みの有無を指定する。マルチレコード/マルチフォーマット構成の場合はオーバーライドしてfalseをリターンすることで手動解析が可能 |

以下のソースコードは、フレームワークが本クラスの各テンプレートメソッドをどのタイミングで呼び出すかを表したものである。

```java
RequestMessage   req;
ResponseMessage  res;
ExecutionContext ctx;

req = receive();                // (フレームワークが要求電文を受信)

try {
    if ( usesAutoRead() ) {
        req.readRecord();       // 要求電文のデータ部からデータレコードを自動的に読み込む。
                                // (主にシングルレコード形式の電文で使用する。)
    }

    res = onReceive(req, ctx);  // 要求電文毎に呼ばれる。
    commit();                   // (フレームワークが業務トランザクションをコミットする。)

} catch(e) {
    rollback();                 // (業務トランザクションをロールバックする。)
    res = onError(e, req, ctx); // 業務処理で例外が発生し、業務トランザクションが
                                // ロールバックされた直後に呼ばれる。
} finally {
    send(res);                  // (フレームワークが応答電文を送信)
}
```

> **注意**: このコードはあくまで説明用に単純化したものであり、実際の処理フローはハンドラ構成によって制御される。

<details>
<summary>keywords</summary>

MessagingAction, nablarch.fw.action.MessagingAction, onReceive, onError, usesAutoRead, RequestMessage, ResponseMessage, ExecutionContext, TransactionManagementHandler, 同期応答電文, テンプレートクラス, 業務アクションハンドラ

</details>

## ハンドラ処理フロー

**[往路処理]**
1. **(業務データ部の自動読み込み)**: `usesAutoRead()` の結果が `true` の場合、`RequestMessage` の `readRecord()` を呼び出して業務データレコードを読み込む。読み込んだレコードは `getParamMap()` 等でフィールド名をキーとするMapとしてアクセス可能
2. **(業務ロジックの実行)**: `onReceive()` を実行し、応答電文オブジェクトを取得する

**[復路処理]**
3. **(正常終了)**: 往路処理2で作成した応答電文オブジェクトをリターンして終了

**[例外処理]**
1a. **(データ終端エラー)**: データレコード読み込み時にデータ部の終端に達しなかった場合は `InvalidDataFormatException` を送出する

> **注意**: 電文内に複数のレコードが格納されうる場合は `usesAutoRead()` をオーバーライドしてfalseを返すこと

**[コールバック]**
4. **(エラー応答電文の制御)**: ハンドラ処理後に [TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、`onError()` を実行しエラー応答電文オブジェクトを返す

<details>
<summary>keywords</summary>

usesAutoRead, readRecord, onReceive, onError, InvalidDataFormatException, RequestMessage, TransactionManagementHandler, getParamMap, 往路処理, 復路処理, 例外処理, コールバック, ハンドラ処理フロー

</details>
