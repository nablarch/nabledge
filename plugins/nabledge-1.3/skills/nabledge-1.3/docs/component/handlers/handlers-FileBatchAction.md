# ファイル入力のバッチ業務アクションハンドラのテンプレートクラス

## 概要

**クラス**: `nablarch.fw.action.FileBatchAction`

ファイルを入力とした [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) の業務アクションハンドラ実装用テンプレートクラス。[BatchAction](handlers-BatchAction.md) と同構造だが、業務処理を `handler()` ではなくレコード種別ごとに以下シグニチャの個別メソッドに実装する:

```java
public Result do[レコード種別名](DataRecord record, ExecutionContext context);
```

特化機能:
- ファイル内容の事前検証の実行
- バッチ処理中断時の再開機能

## テンプレートメソッド

| メソッド名 | 必須/任意 | 説明 |
|---|---|---|
| `do[レコード種別名]()` | 必須 | 各レコード種別の業務処理。正常終了時は `Result.Success` を返す |
| `getFormatFileName()` | 必須 | 入力ファイルのファイル名を返す |
| `getFormatFileName()` | 必須 | レコードフォーマット定義ファイルのファイル名を返す |
| `getDataFileDirName()` | 任意 | 入力ファイルのディレクトリ論理パス名。デフォルト: `"input"` |
| `getFormatFileDirName()` | 任意 | フォーマット定義ファイルのディレクトリ論理パス名。デフォルト: `"format"` |
| `getValidatorAction()` | 任意 | `ValidatableFileDataReader.FileValidatorAction` を返す。デフォルト: 事前検証なし |
| `transactionSuccess()` | 任意 | 業務トランザクションのコミット完了後コールバック。デフォルト: なし |
| `transactionFailure()` | 任意 | 業務トランザクションのロールバック後コールバック。デフォルト: なし |
| `initialize()` | 任意 | バッチ処理開始前に一度だけ呼ばれる。デフォルト: なし |
| `error()` | 任意 | 実行時例外/エラーによるエラー終了時に一度だけコールバック。デフォルト: なし |
| `terminate()` | 任意 | バッチ処理全件終了/エラー終了後に一度だけコールバック。デフォルト: なし |

<details>
<summary>keywords</summary>

FileBatchAction, nablarch.fw.action.FileBatchAction, BatchAction, DataRecord, ExecutionContext, ValidatableFileDataReader, ValidatableFileDataReader.FileValidatorAction, ResumeDataReader, Result.Success, getFormatFileName, getDataFileDirName, getFormatFileDirName, getValidatorAction, transactionSuccess, transactionFailure, initialize, error, terminate, ファイル入力バッチ, テンプレートクラス, レコード種別, 事前検証, バッチ再開

</details>

## ハンドラ処理フロー

**[コールバック]**

1. **(バッチ処理開始前初期処理)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に `initialize()` を実行
2. **(ファイルデータリーダ生成)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) での処理開始時に以下手順でデータリーダを作成:
   1. `getFormatFileName()`、`getFormatFileDirName()`、`getDataFileName()`、`getDataFileDirName()` を実行し [../reader/FileDataReader](../readers/readers-FileDataReader.md) を作成
   2. `getValidatorAction()` の結果が非nullの場合、`ValidatableFileDataReader` を作成しリーダを設定
   3. `ResumeDataReader` を作成し前段のデータリーダを設定

**[往路処理]**

3. **(入力レコードのレコード種別を取得)** `getRecordType()` でレコード種別名を取得
4. **(業務処理の実行)** `do[レコード種別名](DataRecord record, ExecutionContext context)` を呼び出し

**[復路処理]**

5. **(正常終了)** 4. の結果をリターン

**[例外処理]**

- **4a. (ディスパッチエラー)** 該当メソッドが未定義の場合、`Result.NotFound`（ステータスコード404）をスロー
- **4b. (エラー終了)** 業務処理中に例外が発生した場合、そのまま再スロー

**[コールバック]**

6. **(業務トランザクション正常終了時)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でコミット完了後、`transactionSuccess()` を実行
- **6a. (業務トランザクションロールバック時)** [TransactionManagementHandler](handlers-TransactionManagementHandler.md) でロールバック後、`transactionFailure()` を実行
7. **(バッチエラー終了時)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のサブスレッドがエラー停止した場合、`error()` を実行
8. **(バッチ終了時)** [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) のサブスレッドが終了した場合、`terminate()` を実行（エラー終了時も7.の後で呼ばれる）

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, FileDataReader, ValidatableFileDataReader, ResumeDataReader, TransactionManagementHandler, Result.NotFound, getRecordType, getDataFileName, ハンドラ処理フロー, ファイルデータリーダ生成, コールバック, バッチ処理フロー

</details>
