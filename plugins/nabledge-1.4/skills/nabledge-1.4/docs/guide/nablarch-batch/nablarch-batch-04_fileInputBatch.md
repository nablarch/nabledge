# ファイルを入力とするバッチ

## フォーマット定義ファイル

ファイル入力バッチでは、入力ファイルのレイアウトを指定するフォーマット定義ファイルを作成する。フォーマット定義ファイルは、外部インタフェース設計書を入力元として、フォーマット定義ファイル自動生成ツールにより作成する。

以下は固定長ファイルのフォーマット定義例:

```
#-------------------------------------------------------------------------------
# ユーザ情報一覧の固定長ファイルフォーマット
#-------------------------------------------------------------------------------
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    420     # 各レコードの長さ
record-separator: "\r\n"  # 改行コード(crlf)
file-type:      "Fixed"
 
[Classifier] # レコードタイプ識別フィールド定義
1   recordKbn   X(1) #       データ区分
                     #    1: ヘッダー、2: データレコード
                     #    8: トレーラー、9: エンドレコード
 
[header]  # ヘッダーレコード
recordKbn = "1"
1   recordKbn                   X(1)  "1"   # データ区分
2   date                        X(8)        # システム日付
10  ?filler                     X(411)      # 空白領域
 
[data] # データレコード
recordKbn  =  "2"
1   recordKbn                   X(1)  "2"   # データ区分
2   loginId                     X(20)       # ログインID
22  kanjiName                   N(100)      # 漢字氏名
122 kanaName                    N(100)      # カナ氏名
222 ?filler1                    X(50)       # 空白領域
272 mailAddress                 X(100)      # メールアドレス
372 extensionNumberBuilding     X(2)        # 内線番号（ビル番号）
374 extensionNumberPersonal     X(4)        # 内線番号（個人番号）
378 mobilePhoneNumberAreaCode   X(3)        # 携帯番号（市外）
381 mobilePhoneNumberCityCode   X(4)        # 携帯電話番号(市内)
385 mobilePhoneNumberSbscrCode  X(4)        # 携帯電話番号(加入)
389 ?filler2                    X(32)       # 空白領域
 
[trailer] # トレーラレコード
recordKbn = "8"
1   recordKbn                   X(1)  "8"   # データ区分
2   totalCount                  X(19)       # 総件数
21  ?filler                     X(400)      # 空白領域
 
[end]
recordKbn = "9"
1   recordKbn                   X(1)  "9"   # データ区分
2   ?filler                     X(419)      # 空白領域
```

エンドレコード精査の`doEnd`メソッドでは、前レコードのレコード区分が`TRAILER_RECORD`であることを確認する。トレーラでない場合は`TransactionAbnormalEnd`をスローする。

```java
public Result doEnd(DataRecord inputData, ExecutionContext ctx) {
    if (!TRAILER_RECORD.equals(preRecordKbn)) {
        throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
    }
    preRecordKbn = END_RECORD;
    return new Success();
}
```

<details>
<summary>keywords</summary>

フォーマット定義ファイル, 固定長ファイル, text-encoding, record-length, MS932, Classifier, recordKbn, ヘッダーレコード定義, データレコード定義, トレーラレコード定義, エンドレコード定義, doEnd, TransactionAbnormalEnd, エンドレコード精査, レコード区分チェック, TRAILER_RECORD, ファイルレイアウトエラー

</details>

## 初期化処理

初期化処理では、コマンドライン引数で指定された値を取得する。`initialize` メソッドの引数で渡される `CommandLine` からコマンドライン引数を取得できる。

```java
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    this.allowZeroRecord = Boolean.valueOf(command.getParam("allowZeroRecord"));
}
```

初期化処理の実装は必須ではないが、以下のような場合には `initialize` メソッドをオーバーライドする:

- コマンドライン引数の取得が必要な場合
- インスタンス変数の初期化が必要な場合

> **警告: インスタンス変数使用時の制約**
>
> バッチアクションでインスタンス変数を使用する場合、以下の制約が生じる:
>
> - インスタンス変数を使用するバッチアクションは**マルチスレッド実行できない**。
> - インスタンス変数は、初期化処理（`initialize` メソッド）で**明示的に初期化しなければならない**。
>
> ただし、インスタンス変数の初期化（代入）が初期化処理で行われ、それ以降は値が更新されない（読取専用）場合はマルチスレッド実行が可能である。

全レコードの精査終了後に`onFileEnd`が起動される。処理内容:
1. 最終レコードのレコードタイプがエンドレコードであることの確認（エンドレコードでない場合は`TransactionAbnormalEnd`をスロー）
2. 精査レコード件数のログ出力

```java
public void onFileEnd(ExecutionContext ctx) {
    if (!END_RECORD.equals(preRecordKbn)) {
        throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                INVALID_FILE_LAYOUT_FAILURE_CODE, ctx.getLastRecordNumber());
    }
    writeLog("M000000002", ctx.getLastRecordNumber());
    writeLog("M000000003", dataRecordCount);
}
```

writeLogメソッドについては[03_dbInputBatch](nablarch-batch-03_dbInputBatch.md)の:ref:`log_output_in_batch_action`を参照。

<details>
<summary>keywords</summary>

initialize, CommandLine, ExecutionContext, allowZeroRecord, getParam, コマンドライン引数, インスタンス変数初期化, マルチスレッド実行, onFileEnd, TransactionAbnormalEnd, バリデータクラス終了処理, 最終レコードチェック, レコード件数ログ出力, END_RECORD

</details>

## リーダ生成

`getDataFileName()` と `getFormatFileName()` メソッドをオーバーライドして実装しておくと、スーパークラスにてリーダを生成する。両メソッドはファイルIDを返す。

```java
/** ファイルID */
private static final String FILE_ID = "N11AA002";

@Override
public String getDataFileName() {
    return FILE_ID;
}

@Override
public String getFormatFileName() {
    return FILE_ID;
}
```

ヘッダーレコードの妥当性はファイルバリデータクラスの前処理で確認済みのため、本処理では何も行わない。

> **注意**: ファイルバリデータクラスにてファイル形式の精査は実施済みのため、1件ごとの本処理ではファイル形式異常は考慮しなくて良い。

RecordTypeBindingハンドラにより、入力レコードのレコードタイプに応じてメソッドが呼び分けられる。

```java
public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

<details>
<summary>keywords</summary>

getDataFileName, getFormatFileName, FILE_ID, ファイルID, リーダ生成, スーパークラス, doHeader, ヘッダーレコード処理, RecordTypeBindingハンドラ, 前処理済みスキップ

</details>

## ファイルバリデータ生成とレイアウト精査ルール

ファイルレイアウトの精査が必要な場合、`getValidatorAction` をオーバーライドしてファイルレイアウト精査クラスを返却する。精査クラスは内部クラスとして実装する。

```java
@Override
public ValidatableFileDataReader.FileValidatorAction getValidatorAction() {
    return new FileLayoutValidatorAction();
}

private class FileLayoutValidator implements FileValidator {
    /** ファイルレイアウト不正の場合の障害コード */
    private static final String INVALID_FILE_LAYOUT_FAILURE_CODE = "NB11AA0102";

    /** トレーラレコードのエラー */
    private static final String TRAILER_RECORD_ERROR_FAILURE_CODE = "NB11AA0103";

    /** ヘッダーレコードのエラー */
    private static final String HEADER_RECORD_ERROR_FAILURE_CODE = "NB11AA0104";

    /** レコード区分 */
    private String preRecordKbn;

    /** ヘッダーレコード */
    private static final String HEADER_RECORD = "1";

    /** データレコード */
    private static final String DATA_RECORD = "2";

    /** トレーラレコード */
    private static final String TRAILER_RECORD = "8";

    /** レコードカウント */
    private int recordCount;

    /** エンドレコード */
    private static final String END_RECORD = "9";

    /** データレコード件数 */
    private int dataRecordCount;
    // ...
}
```

**レイアウト精査ルール:**

1. 1レコード目はヘッダーレコードであること。
2. 2レコード目以降にデータレコードが複数存在していること。ただし、データレコードが存在しない場合は、トレーラレコードであること。
3. データレコードの次のレコードは、トレーラレコードであること。
4. 最終レコードはエンドレコードであること。

**トレーラレコードの精査ルール:**

1. トレーラレコードの総レコード数が、データレコードのレコード数と一致すること。

レコード構造のイメージ:
```
+------------------+
|ヘッダーレコード  |先頭に必ず1件
+------------------+
|データコレード    |0件以上(無くても良い)
+------------------+
|       ：         |
+------------------+
|データコレード    |
+------------------+
|トレーラレコード  |必ず1件かつ総レコード＝データレコード数
+------------------+
|エンドレコード    |末尾に必ず1件
+------------------+
```

データレコード1件ごとに精査処理とテンポラリテーブルへの登録を行う。精査処理の方法は画面オンライン処理と同様で、精査対象データの種類のみ異なる。

| 実行制御基盤 | 精査対象データ |
|---|---|
| 画面オンライン | HTTPリクエストパラメータ |
| バッチ | DB検索結果、ファイルのレコード等 |

```java
public Result doData(DataRecord inputData, ExecutionContext ctx) {
    N11AA004DataForm form;
    try {
        form = N11AA004DataForm.validate(inputData, "insert");
    } catch (ApplicationException e) {
        throw new TransactionAbnormalEnd(
                103, e, "NB11AA0105", inputData.getRecordNumber());
    }
    UserInfoTempEntity entity = form.getUserInfoTempEntity();
    entity.setUserInfoId(IdGeneratorUtil.generateUserInfoId());
    ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_USER_INFO_TEMP");
    statement.executeUpdateByObject(entity);
    return new Success();
}
```

<details>
<summary>keywords</summary>

getValidatorAction, ValidatableFileDataReader, FileValidatorAction, FileLayoutValidatorAction, FileValidator, レイアウト精査, ヘッダーレコード, データレコード, トレーラレコード, エンドレコード, 総レコード数, N11AA004DataForm, TransactionAbnormalEnd, ApplicationException, IdGeneratorUtil, ParameterizedSqlPStatement, UserInfoTempEntity, データレコード処理, バリデーション, テンポラリテーブル登録

</details>

## ヘッダーレコードの精査処理

RecordTypeBindingハンドラにより、入力レコードのレコードタイプに応じてメソッドが呼び分けられる。メソッド名は接頭辞 `do` にレコードタイプ名を付与する形式:
`public Result "do" + [レコードタイプ名](DataRecord record, ExecutionContext ctx)`

| レコードタイプ | レコードタイプ名 | 呼び出されるメソッド名 |
|---|---|---|
| ヘッダーレコード | header | doHeader |
| データレコード | data | doData |
| トレーラレコード | trailer | doTrailer |
| エンドレコード | end | doEnd |

**精査チェック項目:**
- ヘッダーレコードは1レコード目であること（`preRecordKbn` が null 以外の場合はエラー）
- 日付フィールド（`date`）と業務日付（`BusinessDateUtil.getDate()`）が一致すること

```java
public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
    if (preRecordKbn != null) {
        // 前レコードの値がnull以外の場合は、1レコード目以外のためエラー
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
```

トレーラレコードが読み込まれたときに呼び出されるメソッドが必要なため実装する（特別な処理はなし）。RecordTypeBindingハンドラによりレコードタイプに応じてメソッドが呼び分けられる。

```java
public Result doTrailer(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

<details>
<summary>keywords</summary>

RecordTypeBindingハンドラ, doHeader, doEnd, TransactionAbnormalEnd, DataRecord, ExecutionContext, BusinessDateUtil, Success, ヘッダーレコード精査, エンドレコード処理, レコードタイプ別メソッド呼び分け, ファイルレイアウト検証, doTrailer, トレーラレコード処理, メソッド実装要件

</details>

## データレコードの精査処理

前レコードのレコード区分がヘッダーレコードまたはデータレコードでない場合は、例外を送出して処理を終了する。

```java
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
```

エンドレコードが読み込まれたときに呼び出されるメソッドが必要なため実装する（特別な処理はなし）。RecordTypeBindingハンドラによりレコードタイプに応じてメソッドが呼び分けられる。

```java
public Result doEnd(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

<details>
<summary>keywords</summary>

doData, DataRecord, ExecutionContext, TransactionAbnormalEnd, Success, データレコード精査, レコード区分チェック, 前レコード検証, doEnd, エンドレコード処理, RecordTypeBindingハンドラ, メソッド実装要件

</details>

## トレーラレコードの精査処理

**精査チェック項目:**
- 前レコードのレコード区分はデータレコードであること（ヘッダーレコードも許容）
- 総件数項目（`totalCount`）の値がデータレコード数（`dataRecordCount`）と一致すること
- データレコードが0件かつ `allowZeroRecord` が false の場合はエラー

```java
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
    if (dataRecordCount == 0 && !allowZeroRecord) {
        throw new TransactionAbnormalEnd(104, "NB11AA0106");
    }
    preRecordKbn = TRAILER_RECORD;
    return new Success();
}
```

エラー発生時の処理は、特別な処理は必要ないため、実装しない。

<details>
<summary>keywords</summary>

doTrailer, DataRecord, ExecutionContext, TransactionAbnormalEnd, totalCount, getBigDecimal, allowZeroRecord, Success, トレーラレコード精査, 総件数チェック, ゼロレコード制御, エラー発生時の処理, 実装不要

</details>

## 終了処理

終了処理は、特別な処理は必要ないため、実装しない。

<details>
<summary>keywords</summary>

終了処理, 実装不要

</details>
