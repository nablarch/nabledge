# ファイルを入力とするバッチ

## フォーマット定義ファイル

## フォーマット定義ファイル

ファイル入力を行う場合、そのファイルがどのようなレイアウトであるかを指定するためにフォーマット定義ファイルを作成する必要がある。フォーマット定義ファイルは、外部インタフェース設計書を入力元として、フォーマット定義ファイル自動生成ツールにより作成する。

以下はユーザ情報一覧の固定長ファイルフォーマット定義の例。

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
1   recordKbn                   X(1)  "9"    # データ区分
2   ?filler                     X(419)      # 空白領域
```

エンドレコード検証: 前レコードのレコード区分が`TRAILER_RECORD`であることを確認する。前レコードがトレーラでない場合は`TransactionAbnormalEnd`をスロー。

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

フォーマット定義ファイル, 固定長ファイル, text-encoding, record-length, record-separator, file-type, Classifier, recordKbn, MS932, Fixed, header, data, trailer, end, loginId, kanjiName, kanaName, mailAddress, extensionNumber, mobilePhoneNumber, filler, totalCount, TransactionAbnormalEnd, DataRecord, ExecutionContext, doEnd, TRAILER_RECORD, エンドレコード精査, レコード区分チェック, ファイルレイアウトエラー

</details>

## 初期化処理

## 初期化処理

初期化処理では、コマンドライン引数で指定された値を取得する。以下の例ではコマンドライン引数のオプション（`-DallowZeroRecord`）を取得している。

```java
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    this.allowZeroRecord = Boolean.valueOf(command.getParam("allowZeroRecord"));
}
```

コマンドライン引数は、`initialize`メソッドの引数で渡される`CommandLine`から取得する。

初期化処理の実装は必須ではないが、以下のような場合には`initialize`メソッドをオーバーライドすること。

- コマンドライン引数の取得が必要な場合
- インスタンス変数の初期化が必要な場合

> **警告**: バッチアクションでインスタンス変数を使用する場合、以下の制約が生じる。
>
> - インスタンス変数を使用するバッチアクションは**マルチスレッド実行できない**。
> - インスタンス変数は、初期化処理（`initialize`メソッド）で**明示的に初期化しなければならない**。
>
> ただし、インスタンス変数を使用する場合であっても、インスタンス変数の初期化（代入）が初期化処理で行われ、それ以降は値が更新されないこと（読取専用）を満たす場合はマルチスレッド実行が可能である。

全レコード精査後に`onFileEnd`が起動される。処理内容:
1. 最終レコードのレコードタイプがエンドレコードであることの確認
2. 精査レコード件数のログ出力

最終レコードがエンドレコードでない場合は`TransactionAbnormalEnd`をスロー。

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

`writeLog`メソッドについては [03_dbInputBatch](nablarch-batch-03_dbInputBatch.md) の :ref:`log_output_in_batch_action` を参照。

<details>
<summary>keywords</summary>

initialize, CommandLine, ExecutionContext, allowZeroRecord, getParam, initializeメソッド, コマンドライン引数, インスタンス変数初期化, マルチスレッド, BatchAction, onFileEnd, TransactionAbnormalEnd, writeLog, バリデータ終了処理, 最終レコード確認, レコード件数ログ出力

</details>

## リーダ生成

## リーダ生成

以下のメソッドを実装しておくと、スーパークラスにてリーダを生成してくれる。

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

`RecordTypeBindingハンドラ`により、入力レコードのレコードタイプに応じてメソッドが呼び分けられる。

> **注意**: ファイルバリデータクラスにてファイル形式の精査は実施済みであり、1件ごとの本処理ではファイル形式異常は考慮しなくて良い。

ヘッダーレコードの妥当性は前処理で確認済みのため、本処理では処理を行わない。

```java
public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

<details>
<summary>keywords</summary>

getDataFileName, getFormatFileName, FILE_ID, リーダ生成, スーパークラス, ファイルID, doHeader, DataRecord, ExecutionContext, RecordTypeBindingハンドラ, ヘッダーレコード処理, レコードタイプ分岐

</details>

## ファイルバリデータ生成

## ファイルバリデータ生成

ファイルレイアウトの精査が必要な場合、`getValidatorAction`をオーバーライドしてファイルレイアウト精査クラスを返却する。精査クラスは内部クラスとして実装する。

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

本精査クラスの精査内容は以下のとおり。

**レイアウト精査**

1. 1レコード目はヘッダーレコードであること。
2. 2レコード目以降にデータレコードが複数存在していること。ただし、データレコードが存在しない場合は、トレーラレコードであること。
3. データレコードの次のレコードは、トレーラレコードであること。
4. 最終レコードはエンドレコードであること。

**トレーラレコードの精査**

1. トレーラレコードの総レコード数が、データレコードのレコード数と一致すること。

**イメージ図**

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

データレコード1件分の精査処理とテンポラリテーブルへの登録を行う。精査処理の実施方法は画面オンライン処理と同様で、精査対象データのみ異なる。

| 実行制御基盤 | 精査対象データ |
|---|---|
| 画面オンライン | HTTPリクエストパラメータ |
| バッチ | DB検索結果、ファイルのレコード等 |

`ValidationUtil.validateAndConvertRequest`でデータレコードの精査およびエンティティへのマッピングを行う。精査エラーの場合は`TransactionAbnormalEnd`をスロー。

```java
public Result doData(DataRecord inputData, ExecutionContext ctx) {
    ValidationContext<UserInfoTempEntity> validationContext = ValidationUtil
            .validateAndConvertRequest(UserInfoTempEntity.class,
                    inputData, "validateRegister");

    if (!validationContext.isValid()) {
        throw new TransactionAbnormalEnd(103,
                new ApplicationException(validationContext.getMessages()),
                "NB11AA0105", recordNo);
    }

    UserInfoTempEntity entity = validationContext.createObject();
    entity.setUserInfoId(IdGeneratorUtil.generateUserInfoId());

    ParameterizedSqlPStatement statement = getParameterizedSqlStatement(
            "INSERT_USER_INFO_TEMP");
    statement.executeUpdateByObject(entity);

    return new Success();
}
```

<details>
<summary>keywords</summary>

getValidatorAction, ValidatableFileDataReader, FileValidatorAction, FileLayoutValidator, FileValidator, INVALID_FILE_LAYOUT_FAILURE_CODE, TRAILER_RECORD_ERROR_FAILURE_CODE, HEADER_RECORD_ERROR_FAILURE_CODE, preRecordKbn, recordCount, dataRecordCount, ファイルバリデータ, レイアウト精査, ヘッダーレコード, データレコード, トレーラレコード, エンドレコード, ValidationUtil, UserInfoTempEntity, IdGeneratorUtil, ParameterizedSqlPStatement, ValidationContext, validateAndConvertRequest, generateUserInfoId, doData, TransactionAbnormalEnd, ApplicationException, データレコード精査, テンポラリテーブル登録

</details>

## ファイルバリデータ実装

## ファイルバリデータ実装

`RecordTypeBinding`ハンドラにより、入力レコードのレコードタイプに応じてメソッドが呼び分けられる。各メソッドにて精査処理を行う。

| レコードタイプ | レコードタイプ名 | 呼び出されるメソッド名 |
|---|---|---|
| ヘッダーレコード | header | doHeader |
| データレコード | data | doData |
| トレーラレコード | trailer | doTrailer |
| エンドレコード | end | doEnd |

接頭辞`do`にレコードタイプ名を付与したメソッドが起動される。シグネチャ: `public Result "do" + [レコードタイプ名](DataRecord record, ExecutionContext ctx);`

特に処理はないが、トレーラレコードが読み込まれたときに呼び出されるメソッドが必要なため実装する。

```java
public Result doTrailer(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

<details>
<summary>keywords</summary>

RecordTypeBindingHandler, RecordTypeBinding, doHeader, doData, doTrailer, doEnd, レコードタイプ, メソッド呼び分け, FileValidator, FileLayoutValidator, ValidatableFileDataReader, DataRecord, ExecutionContext, トレーラレコード処理, RecordTypeBindingハンドラ

</details>

## ヘッダーレコードの精査処理

## ヘッダーレコードの精査処理

以下のチェックを行う。

- ヘッダーレコードは1レコード目であること（前レコードのレコード区分が`null`以外の場合はレイアウトエラー）
- ヘッダーレコードの日付フィールドと業務日付（`BusinessDateUtil.getDate()`）が一致すること

```java
public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
    if (preRecordKbn != null) {
        // 前レコードの値がnull以外の場合は、1レコード目以外のためエラーとする。
        throw new TransactionAbnormalEnd(FILE_LAYOUT_ERROR_EXIT_CODE,
                INVALID_FILE_LAYOUT_FAILURE_CODE, inputData.getRecordNumber());
    }
    String date = inputData.getString("date");
    String businessDate = BusinessDateUtil.getDate();
    if (!businessDate.equals(date)) {
        throw new TransactionAbnormalEnd(102,
                HEADER_RECORD_ERROR_FAILURE_CODE,
                date, businessDate);
    }
    preRecordKbn = HEADER_RECORD;
    return new Success();
}
```

特に処理はないが、エンドレコードが読み込まれたときに呼び出されるメソッドが必要なため実装する。

```java
public Result doEnd(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

<details>
<summary>keywords</summary>

doHeader, TransactionAbnormalEnd, DataRecord, ExecutionContext, BusinessDateUtil, Success, ヘッダーレコード精査, 業務日付チェック, ファイルレイアウト検証, 1レコード目チェック, ValidatableFileDataReader, FileValidator, FileLayoutValidator, doEnd, エンドレコード処理, RecordTypeBindingハンドラ

</details>

## データレコードの精査処理

## データレコードの精査処理

前レコードのレコード区分は、ヘッダーレコードまたはデータレコードであること。そうでない場合は`TransactionAbnormalEnd`を送出して処理を終了する。

```java
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
```

特別な処理は必要ないため、実装しない。

<details>
<summary>keywords</summary>

doData, TransactionAbnormalEnd, DataRecord, ExecutionContext, Success, データレコード精査, レコード区分チェック, 前レコード検証, FileValidator, FileLayoutValidator, エラー発生時, エラーハンドリング不要

</details>

## トレーラレコードの精査処理

## トレーラレコードの精査処理

以下の精査処理を行う。

- 前レコードのレコード区分は、データレコードまたはヘッダーレコードであること
- 総件数項目（`totalCount`）の値がデータレコード数と一致すること
- データレコードが0件かつ`allowZeroRecord=false`の場合はエラー

```java
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
    if (dataRecordCount == 0 && !allowZeroRecord) {
        // データレコードのレコード数が0で、0レコードを許容しない設定の場合
        throw new TransactionAbnormalEnd(104, "NB11AA0106");
    }
    preRecordKbn = TRAILER_RECORD;
    return new Success();
}
```

特別な処理は必要ないため、実装しない。

<details>
<summary>keywords</summary>

doTrailer, TransactionAbnormalEnd, DataRecord, ExecutionContext, Success, トレーラレコード精査, 総件数チェック, allowZeroRecord, ゼロレコードチェック, totalCount, FileValidator, FileLayoutValidator, 終了処理不要, 後処理

</details>
