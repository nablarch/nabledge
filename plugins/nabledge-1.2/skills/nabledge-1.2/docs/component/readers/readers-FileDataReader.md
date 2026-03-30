# ファイルデータリーダ

## ファイルデータリーダ

**クラス名**: `nablarch.fw.reader.FileDataReader`

**読み込みデータ型**: `nablarch.core.dataformat.DataRecord`

[../core_library/record_format](../libraries/libraries-record_format.md) を使用して指定ファイルの内容を1レコードずつ読み込む。ファイル終端に達した時点で終了。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| layoutFile | String または String, String | | | フォーマット定義ファイル名（格納論理パスは"format"）、または 格納ディレクトリ論理パスとファイル名の組み合わせ |
| dataFile | String または String, String | | | データファイル名（格納論理パスは"input"）、または 格納ディレクトリ論理パスとファイル名の組み合わせ |
| bufferSize | int | | 8192 | 読込み時のバッファサイズ（バイト） |

```java
DataReader<DataRecord> reader = new FileDataReader()
                               .setLayoutFile("record")      // フォーマット定義ファイル名
                               .setDataFile("record.dat");    // 入力データファイル名
```

<details>
<summary>keywords</summary>

FileDataReader, nablarch.fw.reader.FileDataReader, DataRecord, nablarch.core.dataformat.DataRecord, layoutFile, dataFile, bufferSize, ファイルデータリーダ, レコード読み込み, バッチ入力ファイル

</details>
