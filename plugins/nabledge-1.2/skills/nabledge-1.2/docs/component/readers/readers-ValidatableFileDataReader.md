# 事前精査機能付きファイルデータリーダ

## 事前精査機能付きファイルデータリーダ

**クラス名**: `nablarch.fw.reader.ValidatableFileDataReader`

[FileDataReader](readers-FileDataReader.md) に事前ファイル全件読み込み・精査機能を追加したデータリーダ。事前精査ロジックはインタフェース **FileValidatorAction** に実装し、業務処理ロジックと完全に分離できる。

**読み込むデータの型**: `nablarch.core.dataformat.DataRecord`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| validatorAction | nablarch.fw.reader.ValidatableFileDataReader.FileValidatorAction | ○ | | ファイルバリデータアクション |
| useCache | boolean | | false | 事前精査時に読み込んだデータのキャッシュ可否 |

**使用例** (データリーダファクトリ内での生成):

```java
FileValidatorAction validatorAction = new FileValidatorAction() {
    public void onFileEnd(ExecutionContext ctx) {
        // (略)
    }
    // (略)
};
DataReader<DataRecord> reader = new ValidatableFileDataReader()
                             .setValidatorAction(validatorAction)
                             .setDataFile("record.dat")
                             .setLayoutFile("record");
```

`FileBatchAction` を継承したバッチ業務アクションの場合は、`getValidatorAction()` メソッドをオーバーライドしてファイルバリデータアクションを返却するだけで事前精査を実現できる。詳細は :ref:`FileValidatorAction_implements` を参照すること。

> **注意**: `useCache` をtrueにするとファイル入力処理の負荷を低減できるが、データ量によってはメモリリソースを大幅に消費する。通常のバッチ処理ではキャッシュ使用は推奨しない。ファイル入力処理がボトルネックの場合のみ、メモリ使用量を考慮の上で検討すること。

<details>
<summary>keywords</summary>

ValidatableFileDataReader, FileValidatorAction, FileDataReader, DataRecord, ExecutionContext, validatorAction, useCache, FileBatchAction, getValidatorAction, 事前精査, ファイルデータリーダ, バッチ処理, キャッシュ

</details>

## 事前精査処理の実装例

事前精査処理は `ValidatableFileDataReader.FileValidatorAction` に実装する。必須メソッドは **onFileEnd()** で、これに加えてレコードタイプに応じたディスパッチメソッドを実装する。

**精査メソッド名規約**: `public Result do[レコードタイプ名](DataRecord record, ExecutionContext ctx)`

例: 入力ファイルがheader、data、trailerといった3種類のレコードタイプから構成される場合は、`doHeader()`、`doData()`、`doTrailer()` という3種類の精査メソッドを実装する必要がある。

`FileBatchAction` を継承したバッチ業務アクションに事前精査を追加する場合は `getValidatorAction()` をオーバーライドして返却するだけでよい:

```java
public class B11AC014Action extends FileBatchAction {

    @Override
    public ValidatableFileDataReader.FileValidatorAction getValidatorAction() {
        return new FileLayoutValidatorAction();
    }

    private class FileLayoutValidatorAction implements ValidatableFileDataReader.FileValidatorAction {

        private static final String INVALID_FILE_LAYOUT_FAILURE_CODE = "NB11AA0102";
        private static final String TRAILER_RECORD_ERROR_FAILURE_CODE = "NB11AA0103";
        private static final String HEADER_RECORD_ERROR_FAILURE_CODE = "NB11AA0104";
        private static final int FILE_LAYOUT_ERROR_EXIT_CODE = 100;
        private String preRecordKbn;
        private static final String HEADER_RECORD = "1";
        private static final String DATA_RECORD = "2";
        private static final String TRAILER_RECORD = "8";
        private static final String END_RECORD = "9";
        private int dataRecordCount;

        public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
            if (preRecordKbn != null) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            String date = inputData.getString("date");
            String businessDate = BusinessDateUtil.getDate();
            if (!businessDate.equals(date)) {
                throw new TransactionAbnormalEnd(102,
                        HEADER_RECORD_ERROR_FAILURE_CODE, date, businessDate);
            }
            preRecordKbn = HEADER_RECORD;
            return new Success();
        }

        public Result doData(DataRecord inputData, ExecutionContext ctx) {
            dataRecordCount++;
            if (!HEADER_RECORD.equals(preRecordKbn)
                    && !DATA_RECORD.equals(preRecordKbn)) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = DATA_RECORD;
            return new Success();
        }

        public Result doTrailer(DataRecord inputData, ExecutionContext ctx) {
            if (!DATA_RECORD.equals(preRecordKbn)
                    && !HEADER_RECORD.equals(preRecordKbn)) {
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
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, ctx.getLastRecordNumber());
            }
            writeLog("M000000002", ctx.getLastRecordNumber());
            writeLog("M000000003", dataRecordCount);
        }
    }

    /*
     * 以下、事前精査処理に成功した場合にのみ実行される業務処理。
     */

    public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
        return new Success();
    }

    public Result doData(DataRecord inputData, ExecutionContext ctx) {
        // ファイルデータをDBに登録する処理（※実装の記載は省略）
    }
}
```

<details>
<summary>keywords</summary>

ValidatableFileDataReader.FileValidatorAction, FileBatchAction, B11AC014Action, FileLayoutValidatorAction, getValidatorAction, onFileEnd, ExecutionContext, Result, Success, TransactionAbnormalEnd, BusinessDateUtil, 事前精査実装, レコードタイプ

</details>
