## バッチ処理用業務アクションハンドラのテンプレートクラス

**クラス名:** `nablarch.fw.action.BatchAction`

-----

-----

### バッチ処理用アクションハンドラのバリエーション

本ハンドラは、バッチ処理の実装において汎用的に利用できることを目的として設計されているが、
その他にも、特定の用途に特化した以下の実装が用意されているので、要件と照らし合わせて適切なものを選択すること。

| テンプレートクラス | 内容 |
|---|---|
| [バッチ処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-BatchAction.md) | (本ハンドラ) バッチ処理の実装において汎用的に利用できる標準実装。 |
| [ファイル入力のバッチ業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-FileBatchAction.md) | ファイルを入力とし、レコード種別(ヘッダー、データ、トレーラ ...etc) ごとに、 実行する業務処理を呼び分けたい場合に使用する。 |
| [入力データを使用しないバッチ処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-NoInputDataBatchAction.md) | レコード1件ごとに業務処理を行うのではなく、一回だけ特定の処理を実行したい場合に使用する。 (アンロード処理のような単発処理を実行するバッチを作成する場合に用いる。) |

### 概要

本クラスは、 [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) における
業務アクションハンドラを実装する際に使用するテンプレートクラスである。

[バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) では、
1トランザクション分の業務処理に必要なレコードを読み込む機能を実装したデータリーダの **read()** メソッドと、
業務トランザクション内で実行する業務処理を実装した本クラスの **handler()** メソッドを交互に呼び出し、
データリーダからレコードが読み込めなくなった時点で終了する。

データリーダは、本クラスに実装された **createReader()** メソッドの戻り値が使用される。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| バッチ処理用業務アクションハンドラ | nablarch.fw.action.BatchAction | SqlRow | Result | データリーダが読み込んだ1件分のデータレコードを入力として業務処理を実行する。 | 処理結果オブジェクトを返す。(通常はResult.Successを返す) | - |

-----

本クラスを継承してアクションハンドラを実装するには、以下のテンプレートメソッドを必要に応じて実装する。

| メソッド名 | 内容 |
|---|---|
| createReader() | (必須実装) フレームワークがバッチの処理対象レコードの読込みに使用する [データリーダ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#data-reader) を作成する際に コールバックされるので、 バッチ処理で使用するデータリーダを生成してリターンする。 |
| handle() | (必須実装) バッチの処理対象レコード1件ごとに呼び出される。 [データリーダ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#data-reader) によって読み込まれた1件分のレコードが渡されるので、それをもとに 業務処理を実行する。  正常に終了した場合は、ハンドラの処理が正常終了したことを表す マーカーオブジェクト([Result.Success](../../javadoc/nablarch/fw/Result.Success.html))をリターンすればよい。 |
| transactionSuccess() | (任意実装) 業務トランザクションのコミットが完了した後でコールバックされる。 デフォルトでは何もしない。 |
| transactionFailure() | (任意実装) 業務トランザクションのロールバック後にコールバックされる。 デフォルトでは何もしない。 |
| initialize() | (任意実装) バッチ処理の開始前に一度だけ呼ばれる。 デフォルトでは何もしない。 |
| error() | (任意実装) 実行時例外/エラーの発生によってバッチがエラー終了した場合に 一度だけコールバックされる。 デフォルトでは何もしない。 |
| terminate() | (任意実装) バッチ処理が全件終了もしくはエラーにより終了した後で 一度だけコールバックされる。 デフォルトでは何もしない。 |

以下のソースコードは、フレームワークが本クラスの各テンプレートメソッドを
どのタイミングで呼び出すかを表したものである。

```java
CommandLine      command;   // バッチ起動時のコマンドライン
ExecutionContext ctx;       // 実行コンテキスト

initialize(command, ctx);                       // バッチ処理開始前に一度だけ呼ばれる。
DataReader<TData> reader = createReader(ctx);   // バッチ処理開始前に一度だけ呼ばれる。

Result result = null;

try {
    while(reader.hasNext()) {               // データリーダ上のレコードが終端に達するまで繰り返す。

        TData data = reader.read(ctx);      // 業務トランザクション1件分の入力データを読み込む。

        try {
            result = handle(data, ctx);     // 入力データ1件毎に繰り返し呼ばれる。
            commit();                       // 業務トランザクションをコミット
            transactionSuccess(data, ctx);  // 業務トランザクションがコミットされた後で呼ばれる。

        } catch(e) {
            rollback();                     // 業務トランザクションをロールバック
            transactionFailure(data, ctx);  // 業務トランザクションがロールバックされた後で呼ばれる。
            throw e;
        }
    }

} catch(e) {
    error(e, ctx);                           // バッチがエラー終了した場合に、一度だけ呼ばれる。

} finally {
    terminate(result, ctx)                   // バッチが終了した後、一度だけ呼ばれる。
}
```

> **Note:**
> このコードはあくまで説明用に単純化したものであり、実際の処理フローはこのようなロジックでは無く、
> ハンドラ構成によって制御されており、全く別物である。

### ハンドラ処理フロー

**[コールバック]**

**1. (バッチ処理開始前初期処理)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) での処理開始時に **initialize()** を実行する。

**2. (データリーダ生成)**

続いて、 [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) での処理開始時に、 **createReader()** を実行する。
リターンした [データリーダ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#data-reader) は、実行コンテキストに設定され、以降の処理で使用する。

**[往路処理]**

**3. (入力レコード1件に対する業務処理を実行)**

引数として渡された入力レコードに対する業務処理を実行する。

**[復路処理]**

**4. (正常終了)**

正常終了を表すマーカオブジェクト( [Result.Success](../../javadoc/nablarch/fw/Result.Success.html) ) をリターンする。

**[例外処理]**

**4a. (エラー終了)**

業務処理に失敗した場合は、実行時例外を送出する。

**[コールバック]**

**5. (業務トランザクション正常終了時の処理)**

本ハンドラでの処理終了後、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) で業務トランザクションが正常にコミットされた場合、
本ハンドラの **transactionSuccess()** を実行する。

**5a. (業務トランザクションロールバック時の処理)**

本ハンドラでの処理終了後、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、
本ハンドラの **transactionFailure()** を実行する。

**6. (バッチエラー終了時)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドがエラーにより停止した場合、
本ハンドラの **error()** を実行する。

**7. (バッチ終了時)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドが終了した場合、
本ハンドラの **terminate()** を実行する。
(このコールバックは、バッチがエラー終了した場合でも、 **6.** の処理の後で呼ばれる。)
