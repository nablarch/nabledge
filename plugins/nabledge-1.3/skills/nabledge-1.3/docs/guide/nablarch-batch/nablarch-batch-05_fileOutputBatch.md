# ファイルを出力するバッチ

## 初期化処理

`FileRecordWriterHolder.open()` でファイルをオープン。引数: (1) ベースパス名称（リポジトリ設定ファイルに設定したデータファイルのベースパス論理名）、(2) 出力先ファイル名、(3) フォーマット定義ファイルのベースパス（リポジトリ設定ファイルに設定したフォーマット定義ファイル格納ディレクトリの論理名）、(4) データフォーマット定義ファイル名。

ヘッダレコードのように、ファイル1レコード目に必ず出力するレコードは `initialize` メソッドでファイル出力を行う。

ファイル出力は `FileRecordWriterHolder.write()` を使用。引数: (1) レコードタイプ、(2) 1レコード情報（Map）、(3) ベースパス名称、(4) 出力先ファイル名。

`SystemTimeUtil.getDateString()` でシステム日付文字列を取得できる。

```java
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    FileRecordWriterHolder.open(BASE_PATH_NAME, FILE_ID, "format", FILE_ID);

    Map<String, Object> header = new HashMap<String, Object>();
    header.put("sysDate", SystemTimeUtil.getDateString());
    writeRecord("header", header);
    dataRecordCount = 0;
}

private static void writeRecord(String recordType, Map<String, ?> record) {
    FileRecordWriterHolder.write(recordType, record, BASE_PATH_NAME, FILE_ID);
}
```

<details>
<summary>keywords</summary>

FileRecordWriterHolder, ファイルオープン, ヘッダレコード出力, initialize, バッチ初期化処理, SystemTimeUtil

</details>

## リーダ作成

`DatabaseRecordReader` を使用してデータベースからファイル出力対象データを読み込むリーダを生成する。戻り値の型は `DataReader<SqlRow>`。

```java
@Override
public DataReader<SqlRow> createReader(ExecutionContext ctx) {
    int count = countByStatementSql("GET_OUTPUT_FILE_DATA");
    writeLog("M000000001", count);

    DatabaseRecordReader reader = new DatabaseRecordReader();
    SqlPStatement statement = getSqlPStatement("GET_OUTPUT_FILE_DATA");
    reader.setStatement(statement);
    return reader;
}
```

<details>
<summary>keywords</summary>

DatabaseRecordReader, createReader, SqlPStatement, データ読み込み, DataReader, SqlRow

</details>

## １件ごとの処理

`SqlRow` のカラム名と出力ファイルのフィールド名が自動マッピングされるため、`FileRecordWriterHolder.write()` を呼び出すだけで1行分のデータがファイル出力される。処理成功時は `new Success()` を返す。

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext context) {
    writeRecord("data", inputData);
    dataRecordCount++;
    return new Success();
}
```

<details>
<summary>keywords</summary>

FileRecordWriterHolder, SqlRow, データレコード出力, handle, フィールドマッピング, Success

</details>

## エラー処理

特別なエラー処理は不要。実装しない。

<details>
<summary>keywords</summary>

エラー処理, バッチエラー処理, 例外処理

</details>

## 終了処理

`terminate` メソッドでトレーラレコードとエンドレコードをファイルに出力する。

> **注意**: `FileRecordWriterHolder` で書き込みを行った出力ファイルはフレームワークによって自動的にクローズされるため、アプリケーション側でクローズ処理の実装は不要。

```java
@Override
protected void terminate(Result result, ExecutionContext context) {
    if (result.isSuccess()) {
        writeTrailerRecord();
        writeEndRecord();
    }
}

private void writeTrailerRecord() {
    Map<String, Object> trailer = new HashMap<String, Object>();
    trailer.put("totalCount", dataRecordCount);
    writeRecord("trailer", trailer);
}

private void writeEndRecord() {
    writeRecord("end", new HashMap<String, Object>(0));
}
```

<details>
<summary>keywords</summary>

FileRecordWriterHolder, terminate, トレーラレコード, エンドレコード, ファイル自動クローズ

</details>
