# ファイルを出力するバッチ

## 初期化処理

## 初期化処理

`initialize` メソッドでファイルオープンとヘッダーレコード出力を行う。

**ファイルオープン**: `FileRecordWriterHolder.open(ベースパス名称, 出力ファイル名, フォーマット定義ベースパス, フォーマット定義ファイル名)`
- 第1引数: ベースパス名称（リポジトリ設定ファイルに設定したベースパス論理名）
- 第2引数: 出力先ファイル名
- 第3引数: フォーマット定義ファイルのベースパス（格納ディレクトリ論理名）
- 第4引数: データフォーマット定義ファイル名

ヘッダーレコードのようにファイル先頭に必ず出力するレコードは `initialize` メソッド内で出力する。

**ファイル出力**: `FileRecordWriterHolder.write(レコードタイプ, 1レコード情報, ベースパス名称, ファイルID)`

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

FileRecordWriterHolder, ファイルオープン, ヘッダーレコード出力, initialize, ファイル出力バッチ, SystemTimeUtil

</details>

## リーダ作成

## リーダ作成

`createReader` メソッドで `DatabaseRecordReader` を生成し、`getSqlPStatement` でSQLステートメントを設定してデータベースからデータを読み込む。

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

DatabaseRecordReader, SqlPStatement, createReader, getSqlPStatement, データベース読み込み, DataReader

</details>

## １件ごとの処理

## １件ごとの処理

`SqlRow` のカラム名と出力ファイルのフィールド名が自動マッピングされるため、`FileRecordWriterHolder.write` を呼び出すだけで1行分のデータを出力できる。

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

SqlRow, FileRecordWriterHolder, handle, データレコード出力, カラム名マッピング, Success

</details>

## エラー処理

## エラー処理

特別な処理は不要のため実装しない。

<details>
<summary>keywords</summary>

エラー処理, 実装不要, ファイル出力バッチ

</details>

## 終了処理

## 終了処理

`terminate` メソッドでトレーラレコードとエンドレコードをファイルに出力する。

> **注意**: `FileRecordWriterHolder` で書き込んだ出力ファイルはフレームワークが自動的にクローズするため、アプリケーション側でのクローズ処理は不要。

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

FileRecordWriterHolder, terminate, トレーラレコード, エンドレコード, ファイル自動クローズ, Result

</details>
