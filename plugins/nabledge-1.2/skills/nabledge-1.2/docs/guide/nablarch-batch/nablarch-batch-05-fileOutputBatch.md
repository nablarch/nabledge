# ファイルを出力するバッチ

[ユーザ情報削除バッチ](../../guide/nablarch-batch/nablarch-batch-01-userDeleteBatchSpec.md)
の「削除ユーザレポート出力バッチ」を例に、ファイルを出力するバッチ処理の実装方法を説明する。

![userDeleteBatch.jpg](../../../knowledge/assets/nablarch-batch-05-fileOutputBatch/userDeleteBatch.jpg)

## 初期化処理

初期化処理では、 `FileRecordWriterHolder` の `open` メソッドを使用して、出力先のファイルをオープンする。
第1引数にベースパス名称、第2引数に出力先ファイル名、第3引数には、フォーマット定義ファイルのベースパス、第4引数にデータフォーマット定義ファイル名を指定している。
ベースパス名称はリポジトリ設定ファイルに設定した、書き込むデータファイルのベースパス論理名を指定を指定している。
フォーマット定義ファイルのベースパスはリポジトリ設定ファイルに設定した、フォーマット定義ファイルの格納ディレクトリの論理名を指定している。

また、 ヘッダーレコードの出力を行う。ヘッダレコードのように、ファイル１レコード目に必ず出力するようなレコードはinitializeメソッドでファイル出力を行う。

ファイル出力処理には `FileRecordWriterHolder` の `write` メソッドを使用している。
`FileRecordWriterHolder` の `write` メソッドの第1引数にレコードタイプ、第2引数に出力する1レコード情報、第3引数に出力先ファイル名を指定している。

```java
/**
 * {@inheritDoc}
 * <p/>
 * ヘッダーレコードを出力する。
 */
@Override
protected void initialize(CommandLine command, ExecutionContext context) {

    // 【説明】 出力先のファイルをオープンする。
    FileRecordWriterHolder.open(BASE_PATH_NAME, FILE_ID, "format", FILE_ID);

    // 【説明】 ヘッダー行の出力を行う。
    Map<String, Object> header = new HashMap<String, Object>();
    header.put("sysDate", SystemTimeUtil.getDateString());
    writeRecord("header", header);

    dataRecordCount = 0;
}

/**
 * ファイル出力処理。
 * 指定されたMapを1レコードとしてファイル出力を行う。
 *
 * @param recordType レコードタイプを表す文字列
 * @param record 1レコードの情報を格納したMap
 */
private static void writeRecord(String recordType, Map<String, ?> record) {

    // 【説明】ファイル出力処理を行う。
    FileRecordWriterHolder.write(recordType, record, BASE_PATH_NAME, FILE_ID);
}
```

## リーダ作成

削除ユーザ一覧を読み込むリーダを生成する。

```java
/**
 * {@inheritDoc}
 * ファイル出力対象のデータを読み込む{@link DatabaseRecordReader}を生成する。
 */
@Override
public DataReader<SqlRow> createReader(ExecutionContext ctx) {

    int count = countByStatementSql("GET_OUTPUT_FILE_DATA");
    writeLog("M000000001", count);

    // 【説明】 データベースからファイル出力対象のデータを読み込むリーダを作成する。
    DatabaseRecordReader reader = new DatabaseRecordReader();
    SqlPStatement statement = getSqlPStatement("GET_OUTPUT_FILE_DATA");
    reader.setStatement(statement);
    return reader;

}
```

## １件ごとの処理

削除ユーザ1件ごとの処理を行う。
この処理は、削除ユーザの件数分だけ繰り返し起動される。

引数で渡された、1件ごとのデータが格納されたSqlRowをそのままファイル出力している。
`SqlRow` のカラム名と出力ファイルのフィールド名がマッピングされる為、
単純に `FileRecordWriterHolder` の `write` メソッドを呼び出すだけで1行分のデータがファイル出力される。
ここでは、上記で定義したファイル出力処理を行う `writeRecord` に処理を委譲している。

```java
/**
  * {@inheritDoc}
  * <p/>
  * 削除ユーザレポートテンポラリから取得したレコードをデータレコードに出力する。
  */
 @Override
 public Result handle(SqlRow inputData, ExecutionContext context) {

     // 【説明】 データレコードの出力を行う。
     writeRecord("data", inputData);

     // 【説明】 総件数のインクリメントを行う。
     dataRecordCount++;

     return new Success();
 }
```

## エラー処理

特別な処理は必要ないため、実装しない。

## 終了処理

トレーラレコードとエンドレコードをファイルに出力する。

> **Note:**
> `FileRecordWriterHolder` を使用して書き込みを行った出力ファイルはフレームワークによって自動的に開放（クローズ）されるため、アプリケーション側で開放処理を実装する必要はない。

```java
/**
 * {@inheritDoc}
 * <p/>
 * トレーラレコードと、エンドレコードを出力する。
 */
@Override
protected void terminate(Result result, ExecutionContext context) {

    if (result.isSuccess()) {
        // 【説明】 トレーラレコードの出力を行う。
        writeTrailerRecord();
        // 【説明】 エンドレコードの出力を行う。
        writeEndRecord();
    }
}

/** トレーラレコードを出力する。 */
private void writeTrailerRecord() {
    Map<String, Object> trailer = new HashMap<String, Object>();
    trailer.put("totalCount", dataRecordCount);
    writeRecord("trailer", trailer);
}

/** エンドレコードを出力する。 */
private void writeEndRecord() {
    writeRecord("end", new HashMap<String, Object>(0));
}
```
