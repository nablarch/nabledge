# ファイル入力のバッチ業務アクションハンドラのテンプレートクラス

## 概要

**クラス名**: `nablarch.fw.action.FileBatchAction`

ファイルを入力とした [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) におけるバッチ業務アクションハンドラのテンプレートクラス。[BatchAction](handlers-BatchAction.md) と同じ基本構造だが、業務処理は `handler()` メソッドではなく、レコード種別ごとの個別メソッドに実装する:

```java
public Result do[レコード種別名](DataRecord record, ExecutionContext context);
```

以下の機能を簡便に実装できる:
- ファイル内容の事前検証
- バッチ処理中断時の再開機能

**テンプレートメソッド**:

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| `do[レコード種別名]()` | 必須 | 各レコード種別ごとの業務処理。正常終了時は `Result.Success` を返す |
| `getFormatFileName()` | 必須 | 入力ファイルのファイル名を返す |
| `getFormatFileName()` | 必須 | レコードフォーマット定義ファイルのファイル名を返す |
| `getDataFileDirName()` | 任意 | 入力ファイルのディレクトリ論理パス名。デフォルト: `"input"` |
| `getFormatFileDirName()` | 任意 | フォーマット定義ファイルのディレクトリ論理パス名。デフォルト: `"format"` |
| `getValidatorAction()` | 任意 | 事前検証処理オブジェクト(`ValidatableFileDataReader.FileValidatorAction`)を返す。デフォルトは事前検証なし |
| `transactionSuccess()` | 任意 | 業務トランザクションのコミット完了後のコールバック。デフォルトは何もしない |
| `transactionFailure()` | 任意 | 業務トランザクションのロールバック後のコールバック。デフォルトは何もしない |
| `initialize()` | 任意 | バッチ処理開始前に一度だけ呼ばれる。デフォルトは何もしない |
| `error()` | 任意 | 実行時例外/エラーでバッチがエラー終了した場合に一度だけコールバック。デフォルトは何もしない |
| `terminate()` | 任意 | バッチ処理が全件終了またはエラー終了後に一度だけコールバック（エラー終了時も呼ばれる）。デフォルトは何もしない |

<details>
<summary>keywords</summary>

FileBatchAction, nablarch.fw.action.FileBatchAction, DataRecord, ExecutionContext, ValidatableFileDataReader, ValidatableFileDataReader.FileValidatorAction, ResumeDataReader, Result.Success, getFormatFileName, getDataFileDirName, getFormatFileDirName, getValidatorAction, transactionSuccess, transactionFailure, initialize, error, terminate, ファイル入力バッチ, テンプレートクラス, レコード種別, 事前検証, 再開機能

</details>

## ハンドラ処理フロー

**[コールバック]**

1. **バッチ処理開始前初期処理**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) 処理開始時に `initialize()` を実行
2. **ファイルデータリーダ生成**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) 処理開始時、以下の手順でデータリーダを生成:
   1. `getFormatFileName()`、`getFormatFileDirName()`、`getDataFileName()`、`getDataFileDirName()` を実行し [../reader/FileDataReader](../readers/readers-FileDataReader.md) を作成
   2. `getValidatorAction()` の結果がnullでなければ `ValidatableFileDataReader` を作成し、`getValidatorAction()` の結果と前段のファイルリーダを設定
   3. `ResumeDataReader` を作成し前段のデータリーダを設定

**[往路処理]**

3. **入力レコードのレコード種別取得**: `getRecordType()` でレコード種別名を取得
4. **業務処理の実行**: `do[レコード種別名](DataRecord record, ExecutionContext context)` を呼び出し

**[復路処理]**

5. **正常終了**: 手順4の結果をリターン

**[例外処理]**

- 4a. **ディスパッチエラー**: 該当するメソッドが未定義の場合、`Result.NotFound`（ステータスコード404）を送出
- 4b. **エラー終了**: 業務処理中に例外が発生した場合、そのまま再送出

**[コールバック]**

6. **業務トランザクション正常終了時**: [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でコミット後、`transactionSuccess()` を実行

   6a. **業務トランザクションロールバック時**: [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でロールバック後、`transactionFailure()` を実行

7. **バッチエラー終了時**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のサブスレッドがエラー停止した場合、`error()` を実行
8. **バッチ終了時**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のサブスレッドが終了した場合、`terminate()` を実行（エラー終了時も手順7の後で呼ばれる）

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, TransactionManagementHandler, FileDataReader, ResumeDataReader, ValidatableFileDataReader, Result.NotFound, getRecordType, getDataFileName, initialize, getFormatFileName, getFormatFileDirName, getDataFileDirName, getValidatorAction, transactionSuccess, transactionFailure, error, terminate, ハンドラ処理フロー, コールバック, ファイルデータリーダ生成, トランザクション制御

</details>
