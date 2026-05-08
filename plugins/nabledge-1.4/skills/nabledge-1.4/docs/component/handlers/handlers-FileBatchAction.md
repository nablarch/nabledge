## ファイル入力のバッチ業務アクションハンドラのテンプレートクラス

**クラス名:** `nablarch.fw.action.FileBatchAction`

-----

### 概要

本クラスは、ファイルを入力とした [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) における
業務アクションハンドラを実装する際に使用できるテンプレートクラスである。

基本的な構造は、 [バッチ処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-BatchAction.md) と同じであるが、業務処理は **handler()** メソッドに実装するのでは無く、
ヘッダー、データ、トレーラーなどのレコード種別ごとに、以下のシグニチャをもつ個別のメソッドに実装することができる。

```java
public Result do[レコード種別名](DataRecord record, ExecutionContext context);
```

また、本クラスでは、ファイル入力のバッチ実装に特化した以下の機能を簡便に実装することができる。

* ファイル内容の事前検証の実行
* バッチ処理がエラー等の理由で中断した場合の再開機能

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| ファイル入力バッチ処理用業務アクションハンドラ | nablarch.fw.action.FileBatchAction | DataRecord | Result | 設定されたファイル内のデータレコードを入力として業務処理を実行する。 | 処理結果オブジェクトを返す。(通常はResult.Successを返す) | - |

-----

本クラスを継承してアクションハンドラを実装するには、以下のテンプレートメソッドを必要に応じて実装する。

| メソッド名 | 内容 |
|---|---|
| do[レコード種別名]() | (必須実装) 各レコード種別ごとの業務処理を実行する。  正常に終了した場合は、ハンドラの処理が正常終了したことを表す マーカーオブジェクト([Result.Success](../../javadoc/nablarch/fw/Result.Success.html))をリターンすればよい。 |
| getFormatFileName() | (必須実装) 入力ファイルのファイル名を返す。 |
| getFormatFileName() | (必須実装) レコードフォーマット定義ファイルのファイル名を返す。 |
| getDataFileDirName() | (任意実装) 入力ファイルが格納されたディレクトリの論理パス名を指定する。 デフォルトでは、論理パス名 **"input"** を使用する。 |
| getFormatFileDirName() | (任意実装) フォーマット定義ファイルが格納されたディレクトリの論理パス名を指定する。 デフォルトでは、論理パス名 **"format"** を使用する。 |
| getValidatorAction() | (任意実装) 入力ファイルの事前検証処理を実装したオブジェクト ( [ValidatableFileDataReader.FileValidatorAction](../../javadoc/nablarch/fw/reader/ValidatableFileDataReader.FileValidatorAction.html) )を返す。  デフォルトでは事前検証処理は行われない。 事前検証が必要な場合にオーバーライドすること。 |
| transactionSuccess() | (任意実装) 業務トランザクションのコミットが完了した後でコールバックされる。 デフォルトでは何もしない。 |
| transactionFailure() | (任意実装) 業務トランザクションのロールバック後にコールバックされる。 デフォルトでは何もしない。 |
| initialize() | (任意実装) バッチ処理の開始前に一度だけ呼ばれる。 デフォルトでは何もしない。 |
| error() | (任意実装) 実行時例外/エラーの発生によってバッチがエラー終了した場合に 一度だけコールバックされる。 デフォルトでは何もしない。 |
| terminate() | (任意実装) バッチ処理が全件終了もしくはエラーにより終了した後で 一度だけコールバックされる。 デフォルトでは何もしない。 |

### ハンドラ処理フロー

**[コールバック]**

**1. (バッチ処理開始前初期処理)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) での処理開始時に本クラスの **initialize()** を実行する。

**2. (ファイルデータリーダ生成)**

続いて、 [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) での処理開始時に、以下の手順に沿って作成されたデータリーダを返す。

1. 本クラスの **getFormatFileName()** 、 **getFormatFileDirName()** 、 **getDataFileName()** 、 **getDataFileDirName()**
  をそれぞれ実行し、その結果をもとに [ファイルデータリーダ](../../component/readers/readers-FileDataReader.md) を作成する。
2. 本クラスの **getValidatorAction()** を実行し、その結果がnullでなければ、
  [ValidatableFileDataReader](../../javadoc/nablarch/fw/reader/ValidatableFileDataReader.html)  を作成し、 **getValidatorAction()** の結果と前段で作成したファイルリーダを設定する。

　　3. ResumeDataReaderを作成し、前段までで作成したデータリーダを設定する。

**[往路処理]**

**3. (入力レコードのレコード種別を取得)**

入力レコードの getRecordType() メソッドを実行し、レコード種別名を取得する。

**4. (業務処理の実行)**

本クラスに実装された、以下のシグニチャのメソッドを呼び出し、その結果を取得する。

```java
public Result do[レコード種別名](DataRecord record, ExecutionContext context);
```

**[復路処理]**

**5. (正常終了)**

**4.** の結果をリターンし、終了する。

**[例外処理]**

**4a. (ディスパッチエラー)**

本クラスに、該当するメソッドが定義されていなかった場合は、実行時例外( [Result.NotFound](../../javadoc/nablarch/fw/Result.NotFound.html) :ステータスコード404)
を送出する。

**4b. (エラー終了)**

業務処理実行中に例外が送出された場合は、そのまま再送出する。

**[コールバック]**

**6. (業務トランザクション正常終了時の処理)**

本ハンドラでの処理終了後、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) で業務トランザクションが正常にコミットされた場合、
本ハンドラの **transactionSuccess()** を実行する。

**6a. (業務トランザクションロールバック時の処理)**

本ハンドラでの処理終了後、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) で業務トランザクションがロールバックされた場合、
本ハンドラの **transactionFailure()** を実行する。

**7. (バッチエラー終了時)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドがエラーにより停止した場合、
本ハンドラの **error()** を実行する。

**8. (バッチ終了時)**

[マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) でバッチ処理実行用のサブスレッドが終了した場合、
本ハンドラの **terminate()** を実行する。
(このコールバックは、バッチがエラー終了した場合でも、 **7.** の処理の後で呼ばれる。)
