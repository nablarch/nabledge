# ファイルデータリーダ

## ファイルデータリーダ

**クラス名**: `nablarch.fw.reader.FileDataReader`

指定ファイルを [../core_library/record_format](../libraries/libraries-record_format.md) で1レコードずつ読み込むデータリーダ。ファイル終端で終了。

**読み込みデータ型**: `nablarch.core.dataformat.DataRecord`

| プロパティ名 | 型 | デフォルト値 | 説明 |
|---|---|---|---|
| layoutFile | String または String, String | | フォーマット定義ファイル名（格納論理パス `format`）または 格納ディレクトリ論理パス＋ファイル名 |
| dataFile | String または String, String | | データファイル名（格納論理パス `input`）または 格納ディレクトリ論理パス＋ファイル名 |
| bufferSize | int | 8192 | （任意指定）読込み時のバッファサイズ（バイト） |

使用例（データリーダファクトリ内）:

```java
DataReader<DataRecord> reader = new FileDataReader()
                               .setLayoutFile("record")
                               .setDataFile("record.dat");
```

<details>
<summary>keywords</summary>

FileDataReader, nablarch.fw.reader.FileDataReader, DataRecord, nablarch.core.dataformat.DataRecord, layoutFile, dataFile, bufferSize, ファイルデータリーダ, レコードフォーマット, ファイル読み込み

</details>
