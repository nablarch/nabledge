# ファイルを出力するバッチ

## 初期化処理

**クラス**: `FileRecordWriterHolder`

`FileRecordWriterHolder.open(ベースパス名称, 出力先ファイル名, フォーマット定義ファイルのベースパス, データフォーマット定義ファイル名)` で出力先ファイルをオープンする。ベースパス名称・フォーマット定義ファイルのベースパスはリポジトリ設定ファイルに設定した論理名を指定する。

ファイル先頭に必ず出力するレコード（ヘッダーレコード等）は `initialize` メソッドでファイル出力を行う。

`FileRecordWriterHolder.write(レコードタイプ, 1レコード情報, ベースパス名称, ファイルID)` でレコードを出力する。

```java
@Override
protected void initialize(CommandLine command, ExecutionContext context) {
    FileRecordWriterHolder.open(BASE_PATH_NAME, FILE_ID, "format", FILE_ID);

    Map<String, Object> header = new HashMap<String, Object>();
    header.put("sysDate", SystemTimeUtil.getDateString());
    FileRecordWriterHolder.write("header", header, BASE_PATH_NAME, FILE_ID);

    dataRecordCount = 0;
}
```

<details>
<summary>keywords</summary>

FileRecordWriterHolder, open, write, initialize, SystemTimeUtil, ファイルオープン, ヘッダーレコード出力, 初期化処理

</details>

## リーダ作成

**クラス**: `DatabaseRecordReader`, `SqlPStatement`

DBからファイル出力対象データを読み込む `DatabaseRecordReader` を生成する。

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

DatabaseRecordReader, createReader, SqlPStatement, SqlRow, リーダ作成, DBからデータ読み込み

</details>

## １件ごとの処理

`SqlRow` のカラム名と出力ファイルのフィールド名がマッピングされるため、`FileRecordWriterHolder.write()` を呼び出すだけで1行分のデータがファイル出力される。

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext context) {
    FileRecordWriterHolder.write("data", inputData, BASE_PATH_NAME, FILE_ID);
    dataRecordCount++;
    return new Success();
}
```

<details>
<summary>keywords</summary>

FileRecordWriterHolder, SqlRow, handle, Success, データレコード出力, 1件ごとの処理, ファイル出力

</details>

## エラー処理

特別な処理は必要ないため、実装しない。

<details>
<summary>keywords</summary>

エラー処理, バッチエラー処理, エラーハンドリング

</details>

## 終了処理

> **注意**: `FileRecordWriterHolder` を使用して書き込んだ出力ファイルはフレームワークによって自動的にクローズされる。アプリケーション側でクローズ処理を実装する必要はない。

`terminate` メソッドで処理成功時にトレーラレコードとエンドレコードを出力する。

```java
@Override
protected void terminate(Result result, ExecutionContext context) {
    if (result.isSuccess()) {
        Map<String, Object> trailer = new HashMap<String, Object>();
        trailer.put("totalCount", dataRecordCount);
        FileRecordWriterHolder.write("trailer", trailer, BASE_PATH_NAME, FILE_ID);
        FileRecordWriterHolder.write("end", new HashMap<String, Object>(0), BASE_PATH_NAME, FILE_ID);
    }
}
```

<details>
<summary>keywords</summary>

FileRecordWriterHolder, terminate, Result, 自動クローズ, トレーラレコード, エンドレコード, 終了処理

</details>
