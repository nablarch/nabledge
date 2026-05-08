# ファイルデータリーダ

指定されたファイルの内容を [汎用データフォーマット機能](../../component/libraries/libraries-record-format.md) を使用して1レコードずつ読み込むデータリーダ。
ファイル終端に達した時点で終了する。

本クラスのプロパティとして指定するフォーマット定義ファイルの記述方法等については
[汎用データフォーマット機能](../../component/libraries/libraries-record-format.md) の項を参照すること。

**クラス名**

nablarch.fw.reader.FileDataReader

**読み込むデータの型**

nablarch.core.dataformat.DataRecord

**設定項目一覧**

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| フォーマット定義ファイル | layoutFile | String String, String | ファイル名 (格納論理パスは"format") 格納ディレクトリ論理パス、ファイル名 |
| データファイル | dataFile | String String, String | ファイル名 (格納論理パスは"input") 格納ディレクトリ論理パス、ファイル名 |
| バッファサイズ(バイト) | bufferSize | int | (任意指定: デフォルト=8192B) 読込み時に使用するバッファサイズ。 |

**使用例**

* データリーダファクトリ内でデータリーダを作成する例

  ```java
  DataReader<DataRecord> reader = new FileDataReader()
                                 .setLayoutFile("record")  // フォーマット定義ファイル名
                                 .setDataFile("record.dat");   // 入力データファイル名
  ```
