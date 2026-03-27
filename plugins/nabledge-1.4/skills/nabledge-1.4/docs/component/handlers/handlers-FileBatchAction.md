# ファイル入力のバッチ業務アクションハンドラのテンプレートクラス

## 

ファイルを入力とするバッチ業務アクションハンドラのテンプレートクラス。

**クラス名**: `nablarch.fw.action.FileBatchAction`

<details>
<summary>keywords</summary>

FileBatchAction, nablarch.fw.action.FileBatchAction, ファイル入力バッチ, 業務アクションハンドラ, テンプレートクラス

</details>

## 概要

ファイルを入力とした [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) における業務アクションハンドラのテンプレートクラス。[BatchAction](handlers-BatchAction.md) と同様の構造だが、業務処理は `handler()` ではなく、レコード種別ごとに以下シグニチャのメソッドに実装する:

```java
public Result do[レコード種別名](DataRecord record, ExecutionContext context);
```

- ファイル内容の事前検証の実行
- バッチ処理エラー時の再開機能

<details>
<summary>keywords</summary>

FileBatchAction, BatchAction, ファイル入力バッチ, レコード種別, DataRecord, ExecutionContext, 事前検証, 再開機能

</details>

## 

| メソッド名 | 必須/任意 | 内容 |
|---|---|---|
| do[レコード種別名]() | 必須 | 各レコード種別の業務処理。正常終了時は `Result.Success` を返す |
| getFormatFileName() | 必須 | 入力ファイルのファイル名を返す |
| getFormatFileName() | 必須 | レコードフォーマット定義ファイルのファイル名を返す |
| getDataFileDirName() | 任意 | 入力ファイル格納ディレクトリの論理パス名。デフォルト: `"input"` |
| getFormatFileDirName() | 任意 | フォーマット定義ファイル格納ディレクトリの論理パス名。デフォルト: `"format"` |
| getValidatorAction() | 任意 | 入力ファイルの事前検証処理オブジェクト（`ValidatableFileDataReader.FileValidatorAction`）を返す。デフォルトは事前検証なし。事前検証が必要な場合にオーバーライドする |
| transactionSuccess() | 任意 | 業務トランザクションのコミット完了後にコールバック。デフォルト: 何もしない |
| transactionFailure() | 任意 | 業務トランザクションのロールバック後にコールバック。デフォルト: 何もしない |
| initialize() | 任意 | バッチ処理開始前に1回だけ呼ばれる。デフォルト: 何もしない |
| error() | 任意 | 実行時例外/エラーでバッチがエラー終了した場合に1回コールバック。デフォルト: 何もしない |
| terminate() | 任意 | バッチ処理が全件終了/エラー終了後に1回コールバック（エラー終了時も `error()` の後で呼ばれる）。デフォルト: 何もしない |

<details>
<summary>keywords</summary>

do[レコード種別名], getFormatFileName, getDataFileDirName, getFormatFileDirName, getValidatorAction, transactionSuccess, transactionFailure, initialize, error, terminate, ValidatableFileDataReader, FileValidatorAction, Result.Success, テンプレートメソッド

</details>

## ハンドラ処理フロー

1. **[コールバック] バッチ処理開始前初期処理**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) 処理開始時に `initialize()` を実行
2. **[コールバック] ファイルデータリーダ生成**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) 処理開始時:
   1. `getFormatFileName()`、`getFormatFileDirName()`、`getDataFileName()`、`getDataFileDirName()` をもとに [../reader/FileDataReader](../readers/readers-FileDataReader.md) を作成
   2. `getValidatorAction()` の結果がnull以外の場合、`ValidatableFileDataReader` を作成し検証アクションと前段のファイルリーダを設定
   3. `ResumeDataReader` を作成し前段までのデータリーダを設定
3. **[往路処理] 入力レコードのレコード種別取得**: `getRecordType()` でレコード種別名を取得
4. **[往路処理] 業務処理の実行**: `do[レコード種別名](DataRecord record, ExecutionContext context)` を呼び出す
5. **[復路処理] 正常終了**: 4. の結果をリターン

**例外処理**:
- **4a. ディスパッチエラー**: 該当メソッドが未定義の場合、実行時例外（`Result.NotFound`: ステータスコード404）を送出
- **4b. エラー終了**: 業務処理中の例外はそのまま再送出

6. **[コールバック] 業務トランザクション正常終了時**: [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でコミット後、`transactionSuccess()` を実行
6a. **[コールバック] 業務トランザクションロールバック時** (6. の代替): [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でロールバック後、`transactionFailure()` を実行
7. **[コールバック] バッチエラー終了時**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のサブスレッドがエラーで停止した場合、`error()` を実行
8. **[コールバック] バッチ終了時**: [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のサブスレッド終了時に `terminate()` を実行（エラー終了時も7. の後で呼ばれる）

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, FileDataReader, ValidatableFileDataReader, ResumeDataReader, TransactionManagementHandler, Result.NotFound, initialize, transactionSuccess, transactionFailure, ハンドラ処理フロー, ファイルデータリーダ生成, getDataFileName

</details>
