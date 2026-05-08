## 同期応答電文送信処理用業務アクションハンドラのテンプレートクラス

**クラス名:** `nablarch.fw.action.MessagingAction`

-----

### 概要

本クラスは、 [MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) における
業務アクションハンドラを実装する際に使用するテンプレートクラスである。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| 同期応答電文処理用業務アクションハンドラ | nablarch.fw.action.MessagingAction | RequestMessage | ResponseMessage | 要求電文の内容をもとに業務処理を実行する。 | 業務処理の結果と要求電文の内容から応答電文の内容を作成して返却する。 | - | トランザクションロールバック時にエラー応答電文を作成する。 |

-----

本クラスを継承してアクションハンドラを実装するには、以下のテンプレートメソッドを必要に応じて実装する。

| メソッド名 | 内容 |
|---|---|
| onReceive() | (必須実装) 本ハンドラの往路処理の中で呼ばれる。 要求電文オブジェクト( [RequestMessage](../../javadoc/nablarch/fw/messaging/RequestMessage.html) )の内容をもとに業務処理を実行し、 応答電文オブジェクト( [ResponseMessage](../../javadoc/nablarch/fw/messaging/ResponseMessage.html) )に応答電文の内容を格納してリターンする。 |
| onError() | (任意実装) 業務トランザクションがロールバックされた時点で、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) からコールバックされる。 エラー応答電文を作成してリターンする。 オーバーライドしなかった場合は、FW制御ヘッダのみが設定された電文がエラー応答として 送信される。 |
| usesAutoRead() | (任意実装) 要求電文のデータ部の読込みを自動で行うか否かを指定する。 要求電文のデータ部がマルチレコード/マルチフォーマット構成である場合は、 このメソッドをオーバーライドしてfalseをリターンすることで、 データ部の解析を手動で行うことができる。 |

以下のソースコードは、フレームワークが本クラスの各テンプレートメソッドを
どのタイミングで呼び出すかを表したものである。

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

> **Note:**
> このコードはあくまで説明用に単純化したものであり、実際の処理フローはこのようなロジックでは無く、
> ハンドラ構成によって制御されており、全く別物である。

### ハンドラ処理フロー

**[往路処理]**

**1. (業務データ部の自動読み込み)**

**usesAutoRead()** を実行し、その結果が **true** であった場合は、
[RequestMessage](../../javadoc/nablarch/fw/messaging/RequestMessage.html) の **readRecord()** メソッドを呼び出し、
要求電文内の業務データレコードの読み込みを行なう。

ここで読み込まれたデータレコードの内容は、 **getParamMap()** 等のメソッドにより、
レコードのフィールド名をキーとするMapとしてアクセスすることができる。

**2. (業務ロジックの実行)**

要求電文オブジェクトと実行コンテキストを引数として、 **onReceive()** メソッドを実行し、
その結果(応答電文オブジェクト)を取得する。

**[復路処理]**

**3. (正常終了)**

**2.** で作成した応答電文オブジェクトをリターンし終了する。

**[例外処理]**

**1a. (データ終端エラー)**

要求電文内のデータレコードを読み込んだ時点で、データ部の終端に達しなかった場合は、
実行時例外( [InvalidDataFormatException](../../javadoc/nablarch/core/dataformat/InvalidDataFormatException.html) )を送出する。

> **Note:**
> 電文内に複数のレコードが格納されうる場合は、 **usesAutoRead()** をオーバライドし、falseを返すこと。

**[コールバック]**

**4. (エラー応答電文の制御)**

本ハンドラでの処理終了後、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、
**onError()** メソッドを実行し、その結果(エラー応答電文オブジェクト)を返す。
