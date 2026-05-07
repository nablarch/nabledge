# ファイルを入力とするバッチ

[ユーザ情報入力バッチ](../../guide/nablarch-batch/nablarch-batch-01-userInputBatchSpec.md)
を例に、ファイルを入力とするバッチ処理の実装方法を説明する。

![userInputBatch.jpg](../../../knowledge/assets/nablarch-batch-04-fileInputBatch/userInputBatch.jpg)

## フォーマット定義ファイル

ファイル入力を行う場合、そのファイルがどのようなレイアウトであるかを指定するために
フォーマット定義ファイルを作成する必要がある。

フォーマット定義ファイルは、外部インタフェース設計書を入力元として、
フォーマット定義ファイル自動生成ツールにより作成する。

参考として、本サンプルで使用するファイルフォーマット定義を以下に示す。

```bash
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

## 初期化処理

初期化処理では、コマンドライン引数  [1] で指定された値を取得している。

```java
/**
 * 初期化処理。
 * <p/>
 * 本処理では、コマンドライン引数で指定されたオプション(-DallowZeroRecord)を取得する。
 *
 * @param command 起動コマンドライン
 * @param context 実行コンテキスト
 */
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    this.allowZeroRecord = Boolean.valueOf(command.getParam("allowZeroRecord"));
}
```

コマンドライン引数は、initilizeメソッドの引数で渡されるCommandLineから取得する。
詳細は、 [コマンドライン引数](../../guide/nablarch-batch/nablarch-batch-02-basic.md#コマンドライン引数) を参照。

初期化処理の実装は必須ではないが、以下のような場合には、
initializeメソッドをオーバーライドすること。

* コマンドライン引数の取得が必要な場合
* インスタンス変数の初期化が必要な場合

> **Warning:**
> バッチアクションでインスタンス変数を使用する場合、以下の制約が生じる。

> * >   インスタンス変数を使用するバッチアクションは **マルチスレッド実行できない** 。
> * >   インスタンス変数は、初期化処理(initializeメソッド)で **明示的に初期化しなければならない** 。

> ただし、インスタンス変数を使用する場合であっても、以下の条件を満たす場合はマルチスレッド実行が可能である。

> * >   インスタンス変数の初期化（代入）が初期化処理で行われ、それ以降は値が更新されないこと（読取専用）。

## リーダ生成

下記メソッドを実装しておくと、スーパークラスにてリーダを生成してくれる。

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

## ファイルバリデータ生成

本バッチでは、ファイルレイアウトの精査が必要であるため、
getValidatorActionをオーバーライドし、ファイルレイアウト精査クラスを返却している。
精査クラスは内部クラスとして実装している。

```java
@Override
public ValidatableFileDataReader.FileValidatorAction getValidatorAction() {
    return new FileLayoutValidatorAction();
}

// 【説明】 中略

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

    // 【説明】 後略
```

> **Note:**
> 本項では実際の精査処理内容は省略している。
> 具体的な精査処理についてははサンプルソースコードを参照。

本精査クラスの精査内容は以下のとおり。

**【レイアウト精査】**

1. １レコード目はヘッダーレコードであること。
2. ２レコード目以降にデータレコードが複数存在していること。ただし、データレコードが存在しない場合は、トレーラレコードであること。
3. データレコードの次のレコードは、トレーラレコードであること。
4. 最終レコードはエンドレコードであること。

**【トレーラレコードの精査】**

1. トレーラレコードの総レコード数が、データレコードのレコード数と一致すること。

**【イメージ図】**

```text
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

## ファイルバリデータ実装

RecordTypeBindingハンドラにより、入力レコードのレコードタイプに応じてメソッドが呼び分けられる [2] 。
各メソッドにて精査処理を行っている。

| レコードタイプ | レコードタイプ名 | 呼び出されるメソッド名 |
|---|---|---|
| ヘッダーレコード | header | doHeader |
| データレコード | data | doData |
| トレーラレコード | trailer | doTrailer |
| エンドレコード | end | doEnd |

接頭辞 `do` にレコードタイプ名を付与したメソッドが起動される。
`public Result "do" + [レコードタイプ名](DataRecord record, ExecutionContext ctx);`

### ヘッダーレコードの精査処理

以下のチェックを行う。

* ヘッダーレコードは1レコード目であること
* ヘッダーレコードの日付フィールドと業務日付が一致すること

```java
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
```

### データレコードの精査処理

前レコードのレコード区分は、ヘッダーレコードまたはデータレコードであることを確認する。
そうでない場合は、例外を送出し処理を終了する。

```java
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
```

### トレーラレコードの精査処理

以下の精査処理を行う。

* 前レコードのレコード区分は、データレコードであること。
* 総件数項目の値がデータレコード数と一致すること。

```java
/**
 * トレーラレコードの精査。
 * <p/>
 * 前レコードのレコード区分は、データレコードであること。
 * また、総レコード数項目の値がデータレコード数と一致すること。
 *
 * データレコードの総レコード数が
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

    if (dataRecordCount == 0 && !allowZeroRecord) {
        // データレコードのレコード数が0で、0レコードを許容しない設定の場合
        throw new TransactionAbnormalEnd(104, "NB11AA0106");
    }

    preRecordKbn = TRAILER_RECORD;
    return new Success();

}
```

### エンドレコードの精査処理

前レコードのレコード区分は、トレーラであることを確認する。

```java
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
```

### バリデータクラスの終了処理

全レコードの精査が終了後に、 `onFileEnd` が起動される。
本サンプルでは、以下の処理を行っている。

* 最終レコードのレコードタイプがエンドレコードであることの確認
* 精査レコード件数のログ出力

```java
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
```

writeLogメソッドについては「 [データベースを入力とするバッチ](../../guide/nablarch-batch/nablarch-batch-03-dbInputBatch.md) 」の [ログ出力](../../guide/nablarch-batch/nablarch-batch-03-dbInputBatch.md#ログ出力) の項を参照。

## １件ごとの処理

ファイルバリデータクラスと同様に、RecordTypeBindingハンドラにより、
入力レコードのレコードタイプに応じてメソッドが呼び分けられる。

> **Note:**
> ファイルバリデータクラスにてファイル形式の精査は実施済みであり、
> 1件ごとの本処理ではファイル形式異常は考慮しなくて良い。

### ヘッダーレコードの処理

ヘッダーレコードの妥当性は前処理で確認済みであるため、
本処理においては処理は行わない。

```java
/**
 * ヘッダーレコードの処理。
 * <p/>
 * ヘッダーレコードの場合は、処理を行わない。
 *
 * @param inputData 入力データ
 * @param ctx 実行コンテキスト
 * @return 結果オブジェクト
 */
public Result doHeader(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

### データレコードの処理

データレコード1件分の処理を行う。
精査処理およびテンポラリテーブルへの登録を行っている。

精査処理の実施方法は画面オンライン処理と同様である。
違いは、精査対象となるデータの種類のみである。

| 実行制御基盤 | 精査対象データ |
|---|---|
| 画面オンライン | HTTPリクエストパラメータ |
| バッチ | DB検索結果、ファイルのレコード等 |

```java
/**
 * データレコードの処理。
 *
 * @param inputData 入力データ
 * @param ctx 実行コンテキスト
 * @return 結果オブジェクト
 */
public Result doData(DataRecord inputData, ExecutionContext ctx) {

    // 【説明】
    // ValidationUtilを使用して、データレコードの精査および
    // エンティティへのマッピングを行う。
    ValidationContext<UserInfoTempEntity> validationContext = ValidationUtil
            .validateAndConvertRequest(UserInfoTempEntity.class,
                    inputData, "validateRegister");

    if (!validationContext.isValid()) {
        // 精査エラーの場合は異常終了
        throw new TransactionAbnormalEnd(103,
                new ApplicationException(validationContext.getMessages()),
                "NB11AA0105", recordNo);
    }

    // ユーザ情報IDを採番し、ユーザ情報テンポラリを登録する。
    UserInfoTempEntity entity = validationContext.createObject();
    entity.setUserInfoId(IdGeneratorUtil.generateUserInfoId());

    ParameterizedSqlPStatement statement = getParameterizedSqlStatement(
            "INSERT_USER_INFO_TEMP");
    statement.executeUpdateByObject(entity);

    return new Success();
}
```

### トレーラレコードの処理

特に処理はないが、トレーラレコードが読み込まれたときに
呼び出されるメソッドが必要であるため実装している。

```java
/**
 * トレーラレコードの処理。
 *
 * @param inputData 入力データ
 * @param ctx 実行コンテキスト
 * @return 結果オブジェクト
 */
public Result doTrailer(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

### エンドレコードの処理。

特に処理はないが、エンドレコードが読み込まれたときに
呼び出されるメソッドが必要であるため実装している。

```java
/**
 * エンドレコードの処理。
 *
 * @param inputData 入力データ
 * @param ctx 実行コンテキスト
 * @return 結果オブジェクト
 */
public Result doEnd(DataRecord inputData, ExecutionContext ctx) {
    return new Success();
}
```

## エラー発生時の処理

特別な処理は必要ないため、実装しない。

## 終了処理

特別な処理は必要ないため、実装しない。
