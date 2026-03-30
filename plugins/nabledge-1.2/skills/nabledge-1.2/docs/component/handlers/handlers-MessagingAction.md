# 同期応答電文送信処理用業務アクションハンドラのテンプレートクラス

## 概要

**クラス名**: `nablarch.fw.action.MessagingAction`

[../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) における業務アクションハンドラ実装用テンプレートクラス。

以下のテンプレートメソッドを必要に応じて実装する:

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| `onReceive()` | 必須 | 往路処理で呼ばれる。`RequestMessage` の内容をもとに業務処理を実行し、`ResponseMessage` に応答内容を格納してリターン |
| `onError()` | 任意 | 業務トランザクションがロールバックされた時点で [TransactionManagementHandler](handlers-TransactionManagementHandler.md) からコールバック。エラー応答電文を作成してリターン。オーバーライドしない場合はFW制御ヘッダのみ設定された電文がエラー応答として送信される |
| `usesAutoRead()` | 任意 | 要求電文データ部の自動読み込みを行うか指定。マルチレコード/マルチフォーマット構成の場合はオーバーライドしてfalseをリターンし、手動でデータ部を解析する |

以下のコードは、フレームワークが各テンプレートメソッドをどのタイミングで呼び出すかを示す:

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
                                // エラー応答電文をリターンして返す。
} finally {
    send(res);                  // (フレームワークが応答電文を送信)
}
```

> **注意**: このコードはあくまで説明用に単純化したものであり、実際の処理フローはこのようなロジックでは無く、ハンドラ構成によって制御されており、全く別物である。

<details>
<summary>keywords</summary>

MessagingAction, nablarch.fw.action.MessagingAction, onReceive, onError, usesAutoRead, RequestMessage, ResponseMessage, ExecutionContext, TransactionManagementHandler, 同期応答電文送信, 業務アクションハンドラ, テンプレートクラス

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(業務データ部の自動読み込み)**: `usesAutoRead()` を実行し、結果が `true` の場合は `RequestMessage` の `readRecord()` を呼び出して業務データレコードを読み込む。読み込んだデータレコードは `getParamMap()` 等でフィールド名をキーとするMapとしてアクセス可能。
2. **(業務ロジックの実行)**: 要求電文オブジェクトと実行コンテキストを引数として `onReceive()` を実行し、応答電文オブジェクトを取得する。

**[復路処理]**

3. **(正常終了)**: 2. で作成した応答電文オブジェクトをリターンして終了。

**[例外処理]**

1a. **(データ終端エラー)**: データレコード読み込み時にデータ部の終端に達しなかった場合、`InvalidDataFormatException` を送出する。

> **注意**: 電文内に複数のレコードが格納されうる場合は、`usesAutoRead()` をオーバーライドしてfalseを返すこと。

**[コールバック]**

4. **(エラー応答電文の制御)**: 本ハンドラ処理終了後、[TransactionManagementHandler](handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、`onError()` を実行し、その結果（エラー応答電文オブジェクト）を返す。

<details>
<summary>keywords</summary>

usesAutoRead, readRecord, onReceive, onError, getParamMap, InvalidDataFormatException, TransactionManagementHandler, 往路処理, 復路処理, データ終端エラー, コールバック

</details>
