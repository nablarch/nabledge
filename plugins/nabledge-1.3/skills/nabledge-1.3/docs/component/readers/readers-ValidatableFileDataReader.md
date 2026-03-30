# 事前精査機能付きファイルデータリーダ

## 事前精査機能付きファイルデータリーダ

**クラス名**: `nablarch.fw.reader.ValidatableFileDataReader`

**読み込むデータの型**: `nablarch.core.dataformat.DataRecord`

[FileDataReader](readers-FileDataReader.md) に事前ファイル全件読み込み＋精査機能を追加したデータリーダ。事前精査ロジックは **ファイルバリデータアクション**（`ValidatableFileDataReader.FileValidatorAction`）インタフェースに実装する。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| validatorAction | nablarch.fw.reader.ValidatableFileDataReader.FileValidatorAction | ○ | | ファイルバリデータアクション |
| useCache | boolean | | false | 事前精査時に読み込んだデータのキャッシュ可否 |

**使用例（データリーダファクトリ内）**:

```java
FileValidatorAction validatorAction = new FileValidatorAction() {
    public void onFileEnd(ExecutionContext ctx) { /* (略) */ }
    // (略)
};
DataReader<DataRecord> reader = new ValidatableFileDataReader()
    .setValidatorAction(validatorAction)
    .setDataFile("record.dat")
    .setLayoutFile("record");
```

`FileBatchAction` を継承したバッチ業務アクションの場合、`getValidatorAction()` メソッドをオーバーライドしてファイルバリデータアクションを返却するだけで事前精査を実現できる。詳細は :ref:`FileValidatorAction_implements` を参照。

**useCacheプロパティ**: `useCache=true` に設定すると事前精査時に読み込んだデータをメモリにキャッシュし、業務処理時にキャッシュデータを使用できる。データ量によってはメモリリソースを大幅に消費するデメリットがある。通常のバッチ処理ではキャッシュ使用は推奨しない。ファイル入力処理がボトルネックになっている場合のみ、メモリ使用量を考慮した上で検討すること。

<details>
<summary>keywords</summary>

ValidatableFileDataReader, FileValidatorAction, FileDataReader, validatorAction, useCache, 事前精査, ファイルデータリーダ, DataRecord, FileBatchAction, getValidatorAction

</details>

## 事前精査処理の実装例

ファイルバリデータアクション（`ValidatableFileDataReader.FileValidatorAction`）には、`onFileEnd()` メソッドに加え、レコードタイプに応じてディスパッチされる精査メソッドを実装する。

**精査メソッド名の規約**: `public Result "do" + [レコードタイプ名](DataRecord record, ExecutionContext ctx)`

例: header/data/trailerの3種類のレコードタイプを持つ場合 → `doHeader()`、`doData()`、`doTrailer()` を実装する（:ref:`RecordTypeBinding` 参照）。

`FileBatchAction` を継承する場合は `getValidatorAction()` をオーバーライドしてファイルバリデータアクションを返す。

```java
public class B11AC014Action extends FileBatchAction {

    @Override
    public ValidatableFileDataReader.FileValidatorAction getValidatorAction() {
        return new FileLayoutValidatorAction();
    }

    private class FileLayoutValidatorAction
            implements ValidatableFileDataReader.FileValidatorAction {

        private String preRecordKbn;
        private int dataRecordCount;

        public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
            if (preRecordKbn != null) {
                // 1レコード目以外でヘッダーが来た場合はエラー
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            String date = inputData.getString("date");
            String businessDate = BusinessDateUtil.getDate();
            if (!businessDate.equals(date)) {
                // 日付が業務日付と不一致の場合
                throw new TransactionAbnormalEnd(102,
                        HEADER_RECORD_ERROR_FAILURE_CODE,
                        date, businessDate);
            }
            preRecordKbn = HEADER_RECORD;
            return new Success();
        }

        public Result doData(DataRecord inputData, ExecutionContext ctx) {
            dataRecordCount++;
            if (!HEADER_RECORD.equals(preRecordKbn) && !DATA_RECORD.equals(preRecordKbn)) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = DATA_RECORD;
            return new Success();
        }

        public Result doTrailer(DataRecord inputData, ExecutionContext ctx) {
            if (!DATA_RECORD.equals(preRecordKbn) && !HEADER_RECORD.equals(preRecordKbn)) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            int totalCount = inputData.getBigDecimal("totalCount").intValue();
            if (dataRecordCount != totalCount) {
                throw new TransactionAbnormalEnd(101,
                        TRAILER_RECORD_ERROR_FAILURE_CODE, totalCount, dataRecordCount);
            }
            if (dataRecordCount == 0) {
                throw new TransactionAbnormalEnd(104, "NB11AA0106");
            }
            preRecordKbn = TRAILER_RECORD;
            return new Success();
        }

        public Result doEnd(DataRecord inputData, ExecutionContext ctx) {
            if (!TRAILER_RECORD.equals(preRecordKbn)) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = END_RECORD;
            return new Success();
        }

        public void onFileEnd(ExecutionContext ctx) {
            if (!END_RECORD.equals(preRecordKbn)) {
                // 最終レコードがエンドレコードでない場合はエラー
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, ctx.getLastRecordNumber());
            }
            // レコード数をログに出力
            writeLog("M000000002", ctx.getLastRecordNumber());
            writeLog("M000000003", dataRecordCount);
        }
    }

    // 以下、事前精査成功時のみ実行される業務処理
    public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
        return new Success(); // 事前精査済みのため処理不要
    }

    public Result doData(DataRecord inputData, ExecutionContext ctx) {
        // ファイルデータをDBに登録する処理
    }
}
```

<details>
<summary>keywords</summary>

ValidatableFileDataReader.FileValidatorAction, onFileEnd, B11AC014Action, FileBatchAction, getValidatorAction, doHeader, doData, doTrailer, doEnd, 事前精査実装, TransactionAbnormalEnd, RecordTypeBinding, FileLayoutValidatorAction, BusinessDateUtil

</details>
