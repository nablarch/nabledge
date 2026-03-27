# 事前精査機能付きファイルデータリーダ

## 事前精査機能付きファイルデータリーダ

**クラス名**: `nablarch.fw.reader.ValidatableFileDataReader`

**読み込むデータの型**: `nablarch.core.dataformat.DataRecord`

[FileDataReader](readers-FileDataReader.md) に対して事前にファイルを全件読み込んで精査を行う機能を追加したデータリーダ。事前精査ロジックはファイルバリデータアクション（`ValidatableFileDataReader.FileValidatorAction`）に実装し、業務処理から完全に分離する。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| validatorAction | nablarch.fw.reader.ValidatableFileDataReader.FileValidatorAction | ○ | | ファイルバリデータアクション |
| useCache | boolean | | false | 事前精査時に読み込んだデータのキャッシュ可否 |

**使用例**（データリーダファクトリ内での生成）:
```java
FileValidatorAction validatorAction = new FileValidatorAction() {
    public void onFileEnd(ExecutionContext ctx) { ... }
};
DataReader<DataRecord> reader = new ValidatableFileDataReader()
                             .setValidatorAction(validatorAction)
                             .setDataFile("record.dat")
                             .setLayoutFile("record");
```

`FileBatchAction` を継承する場合は `getValidatorAction()` をオーバーライドしてファイルバリデータアクションを返すだけで事前精査を実現できる。詳細は :ref:`FileValidatorAction_implements` を参照。

**useCacheプロパティ**:
- `true` に設定すると事前精査時に読み込んだデータをメモリ上にキャッシュし、業務処理時にキャッシュデータを利用してファイル入力処理の負荷を低減できる
- 通常のバッチ処理でファイル入力処理がボトルネックになることはほとんどないため、キャッシュの使用は推奨しない
- ファイル入力処理がボトルネックになっている場合のみ、メモリ使用量を考慮しつつキャッシュの使用を検討すること

<details>
<summary>keywords</summary>

ValidatableFileDataReader, nablarch.fw.reader.ValidatableFileDataReader, DataRecord, nablarch.core.dataformat.DataRecord, FileValidatorAction, validatorAction, useCache, 事前精査機能付きファイルデータリーダ, ファイルバリデータアクション, キャッシュ設定, バッチファイル入力

</details>

## 事前精査処理の実装例

事前精査ロジックは `ValidatableFileDataReader.FileValidatorAction` インタフェースに実装する。

**精査メソッドの命名規約**:
```
public Result do[レコードタイプ名](DataRecord record, ExecutionContext ctx)
```
入力ファイルのレコードタイプに応じてディスパッチされる。例: header/data/trailerの3種類 → `doHeader()`/`doData()`/`doTrailer()` を実装する必要がある。詳細は `RecordTypeBinding` を参照。

インタフェースで定義されている `onFileEnd()` メソッドも必ず実装する。

`FileBatchAction` を継承する場合は `getValidatorAction()` をオーバーライドしてファイルバリデータアクションを返すだけでよい。

**実装例**（ファイルレイアウト事前精査＋DB取込み業務処理）:
```java
public class B11AC014Action extends FileBatchAction {

    /** 事前精査を行う場合、getValidatorAction()をオーバーライドしてファイルバリデータアクションを返却する */
    @Override
    public ValidatableFileDataReader.FileValidatorAction getValidatorAction() {
        return new FileLayoutValidatorAction();
    }

    private class FileLayoutValidatorAction implements ValidatableFileDataReader.FileValidatorAction {

        public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
            // 1レコード目がヘッダーであることを精査
            if (preRecordKbn != null) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = HEADER_RECORD;
            return new Success();
        }

        public Result doData(DataRecord inputData, ExecutionContext ctx) {
            dataRecordCount++;
            if (!HEADER_RECORD.equals(preRecordKbn)
                    && !DATA_RECORD.equals(preRecordKbn)) {
                // 前レコードがヘッダー、データでない場合
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = DATA_RECORD;
            return new Success();
        }

        public Result doTrailer(DataRecord inputData, ExecutionContext ctx) {
            if (!DATA_RECORD.equals(preRecordKbn)
                    && !HEADER_RECORD.equals(preRecordKbn)) {
                // 前レコードがヘッダー、データでない場合
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            int totalCount = inputData.getBigDecimal("totalCount").intValue();
            if (dataRecordCount != totalCount) {
                throw new TransactionAbnormalEnd(101,
                        TRAILER_RECORD_ERROR_FAILURE_CODE, totalCount, dataRecordCount);
            }
            if (dataRecordCount == 0) {
                // データレコードが0件の場合はエラー
                throw new TransactionAbnormalEnd(104, "NB11AA0106");
            }
            preRecordKbn = TRAILER_RECORD;
            return new Success();
        }

        public Result doEnd(DataRecord inputData, ExecutionContext ctx) {
            // 前レコードがトレーラであることを精査
            if (!TRAILER_RECORD.equals(preRecordKbn)) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = END_RECORD;
            return new Success();
        }

        public void onFileEnd(ExecutionContext ctx) {
            // 最終レコードがエンドレコードであることをチェック
            if (!END_RECORD.equals(preRecordKbn)) {
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, ctx.getLastRecordNumber());
            }
        }
    }

    // 事前精査成功後の業務処理（ヘッダーの妥当性は精査済みのためスキップ可）
    public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
        return new Success();
    }

    public Result doData(DataRecord inputData, ExecutionContext ctx) {
        // ファイルデータをDBに登録する処理
    }
}
```

<details>
<summary>keywords</summary>

ValidatableFileDataReader.FileValidatorAction, FileBatchAction, getValidatorAction, onFileEnd, doHeader, doData, doTrailer, doEnd, TransactionAbnormalEnd, 事前精査処理実装, レコードタイプバインディング, ファイルバリデータアクション実装

</details>
