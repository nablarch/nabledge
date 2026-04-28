## 事前精査機能付きファイルデータリーダ

[ファイルデータリーダ](../../component/readers/readers-FileDataReader.md) に対して、事前にファイルを全件読み込んで精査を行う機能を追加するデータリーダ。

ファイルを入力とするバッチでは、業務処理の実行に先立って、ファイル形式が妥当であるかを確認することが多い。

本データリーダはそのような用途で使用することを想定しており、事前精査処理と業務処理を分離して実行する機能を提供する。

なお、事前精査ロジックは本データリーダが提供するインタフェース 「 **ファイルバリデータアクション** 」に実装する。
ファイルバリデータアクションを使用することで、事前精査ロジックを業務処理ロジックから完全に分離することができる。

事前精査処理を必要とするバッチ処理の実装例については、 [事前精査処理の実装例](../../component/readers/readers-ValidatableFileDataReader.md#filevalidatoraction-implements) を参照すること。

**クラス名**

nablarch.fw.reader.ValidatableFileDataReader

**読み込むデータの型**

nablarch.core.dataformat.DataRecord

**設定項目一覧**

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ファイルバリデータアクション | validatorAction | nablarch.fw.reader.ValidatableFileDataReader.FileValidatorAction | 必須指定 |
| 事前精査時に読み込んだデータのキャッシュ可否 | useCache | boolean | 任意指定(デフォルト = false) |

**使用例**

* データリーダファクトリ内で事前精査機能付きファイルデータリーダおよびファイルバリデータアクションを生成する例

```java
// ファイル内容の事前検証を行うアクションを生成する。
// 実装内容基本的に通常のバッチアクションと同じである。(後述の実装例を参照すること)
FileValidatorAction validatorAction = new FileValidatorAction() {
    public void onFileEnd(ExecutionContext ctx) {
        // (略)
    }
    // (略)
};
// 事前精査機能付きファイルデータリーダを生成し、ファイルバリデータアクションを設定する
DataReader<DataRecord> reader = new ValidatableFileDataReader()
                             .setValidatorAction(validatorAction)
                             .setDataFile("record.dat")
                             .setLayoutFile("record");
```

なお、 [FileBatchAction](../../javadoc/nablarch/fw/action/FileBatchAction.html) を継承したバッチ業務アクションを作成する場合は、 **getValidatorAction()メソッド**
をオーバーライドし、ファイルバリデータアクションを返却するだけで事前精査を実現できる。
詳細は [事前精査処理の実装例](../../component/readers/readers-ValidatableFileDataReader.md#filevalidatoraction-implements) を参照すること。

**事前精査時に読み込んだデータのキャッシュ**

**useCacheプロパティ** にtrueを設定することで、事前精査時に読み込んだデータをメモリにキャッシュできる。

キャッシュを有効にした場合、事前精査時に読み込まれたデータがメモリ上にキャッシュされ、業務処理時にはキャッシュしたデータを読み込んで処理を行うことができる。

キャッシュを使用するとファイル入力処理の負荷を低減できるメリットがあるが、その反面、データ量によってはメモリリソースを大幅に消費するというデメリットがある。

通常のバッチ処理でファイル入力処理の負荷が問題になることはほとんどないので、キャッシュの使用は推奨しない。
ファイル入力処理がボトルネックになっている場合のみ、メモリの使用量を考慮しつつキャッシュの使用を検討すること。

### 事前精査処理の実装例

事前精査機能付きファイルデータリーダを使用する場合、事前に行う精査処理は、ファイルバリデータアクション（ [ValidatableFileDataReader.FileValidatorAction](../../javadoc/nablarch/fw/reader/ValidatableFileDataReader.FileValidatorAction.html) ）に実装する。

ファイルバリデータアクションを実装する場合、インタフェースで定義されている **onFileEnd()メソッド** に加え、入力レコードのレコードタイプに応じてディスパッチされる精査メソッドを実装する。

精査メソッド名の規約は以下のとおりである。規約についての詳細は [RecordTypeBinding](../../javadoc/nablarch/fw/handler/RecordTypeBinding.html) を参照すること。

* public Result "do" + [レコードタイプ名](DataRecord record, ExecutionContext ctx);

たとえば、入力ファイルがheader, data, trailerといった３種類のレコードタイプから構成される場合、
ファイルバリデータアクションにdoHeader(), doData(), doTrailer()という３種類の精査メソッドを実装する必要がある。

以下より、 [FileBatchAction](../../javadoc/nablarch/fw/action/FileBatchAction.html) を継承したバッチ業務アクションに、
ファイルレイアウトを事前精査する処理と、精査に成功した場合のみファイルデータをDBに取り込む業務処理を実装する例を示す。

```java
public class B11AC014Action extends FileBatchAction {

    // ・・・（省略）・・・

    /*
     * 以下、事前精査処理の実装。
     */

    /** 事前精査を行う場合、getValidatorAction()メソッドをオーバーライドし、ファイルバリデータアクションを返却する */
    @Override
    public ValidatableFileDataReader.FileValidatorAction getValidatorAction() {
        return new FileLayoutValidatorAction();
    }

    /**
     * 事前にファイルレイアウト精査を行うファイルバリデータアクション。
     * バッチ業務アクションの内部クラスとして作成する。
     * <p/>
     * 具体的には入力ファイルが以下のレイアウト仕様を満たしていることの精査を行う。
     * <ul>
     *  <li>１レコード目はヘッダーレコードであること。</li>
     *  <li>２レコード目以降にデータレコードが存在することの精査。また、データレコードが存在しない場合は、トレーラレコードであること。</li>
     *  <li>データレコードの次のレコードがトレーラレコードであること。</li>
     *  <li>トレーラレコードの総レコード数項目の値が、実際に読み込んだデータレコード数と一致すること。</li>
     *  <li>最終レコードがエンドレコードであること。</li>
     * </ul>
     */
    private class FileLayoutValidatorAction implements ValidatableFileDataReader.FileValidatorAction {

        /** ファイルレイアウト不正の場合の障害コード */
        private static final String INVALID_FILE_LAYOUT_FAILURE_CODE = "NB11AA0102";

        /** トレーラレコードのエラー */
        private static final String TRAILER_RECORD_ERROR_FAILURE_CODE = "NB11AA0103";

        /** ヘッダーレコードのエラー */
        private static final String HEADER_RECORD_ERROR_FAILURE_CODE = "NB11AA0104";

        /** ファイルのレイアウト不正(レコードの並び順不正)の場合の終了コード */
        private static final int FILE_LAYOUT_ERROR_EXIT_CODE = 100;

        /** 前レコードのレコード区分 */
        private String preRecordKbn;

        /** ヘッダーレコード */
        private static final String HEADER_RECORD = "1";

        /** データレコード */
        private static final String DATA_RECORD = "2";

        /** トレーラレコード */
        private static final String TRAILER_RECORD = "8";

        /** エンドレコード */
        private static final String END_RECORD = "9";

        /** データレコードレコード数 */
        private int dataRecordCount;

        /**
         * ヘッダーレコードの精査。
         * <p/>
         * ヘッダーレコードは、1レコード目であること。
         *
         * @param inputData 入力データ
         * @param ctx 実行コンテキスト
         * @return 結果オブジェクト
         */
        public Result doHeader(DataRecord inputData, ExecutionContext ctx) {

            if (preRecordKbn != null) {
                // 前レコードの値がnull以外の場合は、1レコード目以外のためエラーとする。
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

        /**
         * データレコードの精査。
         * <p/>
         * 前レコードのレコード区分は、ヘッダーレコードまたはデータレコードであること。
         *
         * @param inputData 入力データ
         * @param ctx 実行コンテキスト
         * @return 結果オブジェクト
         */
        public Result doData(DataRecord inputData, ExecutionContext ctx) {

            dataRecordCount++;

            if (!HEADER_RECORD.equals(preRecordKbn)
                    && !DATA_RECORD.equals(preRecordKbn)) {
                // 前レコードがヘッダー、データで無い場合
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = DATA_RECORD;
            return new Success();
        }

        /**
         * トレーラレコードの精査。
         * <p/>
         * 前レコードのレコード区分は、データレコードであること。
         * また、総レコード数項目の値がデータレコード数と一致すること。
         *
         * @param inputData 入力データ
         * @param ctx 実行コンテキスト
         * @return 結果オブジェクト
         */
        public Result doTrailer(DataRecord inputData, ExecutionContext ctx) {

            if (!DATA_RECORD.equals(preRecordKbn)
                    && !HEADER_RECORD.equals(preRecordKbn)) {
                // 前レコードがヘッダー、データでない場合
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }

            int totalCount = inputData.getBigDecimal("totalCount").intValue();
            if (dataRecordCount != totalCount) {
                // データレコードのレコード数と総レコード数が一致しない場合
                throw new TransactionAbnormalEnd(101,
                        TRAILER_RECORD_ERROR_FAILURE_CODE,
                        totalCount, dataRecordCount);
            }

            if (dataRecordCount == 0) {
                // データレコードのレコード数が0の場合
                throw new TransactionAbnormalEnd(104, "NB11AA0106");
            }

            preRecordKbn = TRAILER_RECORD;
            return new Success();
        }

        /**
         * エンドレコードの精査
         * <p/>
         * 前レコードのレコード区分は、トレーラであること。
         *
         * @param inputData 入力データ
         * @param ctx 実行コンテキスト
         * @return 結果オブジェクト
         */
        public Result doEnd(DataRecord inputData, ExecutionContext ctx) {
            if (!TRAILER_RECORD.equals(preRecordKbn)) {
                // 前レコードがトレーラでない場合
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
            }
            preRecordKbn = END_RECORD;
            return new Success();
        }

        /**
         * {@inheritDoc}
         * <p/>
         * 最終レコードがエンドレコードであることをチェックする。
         */
        public void onFileEnd(ExecutionContext ctx) {
            if (!END_RECORD.equals(preRecordKbn)) {
                // 最終レコードがエンドレコードで無い場合
                throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                        INVALID_FILE_LAYOUT_FAILURE_CODE, ctx.getLastRecordNumber());
            }
            // レコード数をログに出力
            writeLog("M000000002", ctx.getLastRecordNumber());
            writeLog("M000000003", dataRecordCount);
        }
    }

    /*
     * 以下、事前精査処理に成功した場合にのみ実行される業務処理。
     */

    /**
     * ヘッダーレコードの処理。
     * <p/>
     * 本処理では、処理は行わない。
     * ヘッダーレコードの妥当性は事前に検証済み。
     *
     * @param inputData 入力データ
     * @param ctx 実行コンテキスト
     * @return 結果オブジェクト
     */
    public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
        return new Success();
    }

    /**
     * データレコードの処理。ファイルデータをDBに登録する。
     *
     * @param inputData 入力データ
     * @param ctx 実行コンテキスト
     * @return 結果オブジェクト
     */
    public Result doData(DataRecord inputData, ExecutionContext ctx) {

        // ファイルデータをDBに登録する処理（※実装の記載は省略）

    }

    // ・・・（省略）・・・

}
```
