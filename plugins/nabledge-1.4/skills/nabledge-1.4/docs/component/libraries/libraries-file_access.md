# ファイルアクセス機能

## 概要

- **論理パス**: アプリケーションが動作環境に依存することを回避するため、処理対象ファイルを指定する際に使用する文字列。
- **ファイルアクセスAPI**: データファイルの内容を [record_format](libraries-record_format.md) を用いて解析し、各レコードをMapとしてアクセスする。

<details>
<summary>keywords</summary>

論理パス, ファイルアクセスAPI, ファイルシステムアクセス, record_format, ファイル読み書き

</details>

## 論理パス

**クラス**: `nablarch.core.util.FilePathSetting`

各論理パスの物理パスは`FilePathSetting`クラスに設定し、キー名 **filePathSetting** でリポジトリに登録する。

**既定論理パス名**

| 論理パス名 | 内容 |
|---|---|
| output | 業務処理の結果として生成されるファイルを出力するディレクトリ |
| input | 業務処理の入力となるファイルを格納したディレクトリ |
| format | [フォーマット定義ファイル](libraries-record_format.md) を格納したディレクトリ |

各論理パスにはファイルの拡張子を定義可能。この場合、ファイル名には拡張子を除いた文字列を指定する。

<details>
<summary>keywords</summary>

FilePathSetting, 論理パス設定, 物理パス, 論理パス名, output, input, format, 拡張子設定

</details>

## 論理パス設定方法

`FilePathSetting`クラスの設定項目と設定例。

**設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| basePathSettings | Map\<String, String\> | ○ | | 論理パス名と物理パスの組み合わせ。物理パスはURLの形式（`file:パス` or `classpath:パス`）で指定。**パスにスペースを含めないこと** |
| fileExtensions | Map\<String, String\> | | 空のMap | 論理パス名とファイル拡張子の組み合わせ |

> **重要**: `classpath:`を指定する場合、そのディレクトリが存在している必要がある（存在しない場合は例外スロー）。`file:`を指定する場合、ディレクトリが存在しなければ自動作成する。

```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting">
  <property name="fileExtensions">
    <map>
      <entry key="format" value="fmt" />
      <entry key="csv-output" value="csv" />
      <entry key="tsv-input" value="tsv" />
    </map>
  </property>
  <property name="basePathSettings">
    <map>
      <entry key="format" value="file:./main/format" />
      <entry key="input" value="file:./work/input" />
      <entry key="output" value="file:./work/output" />
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

FilePathSetting, basePathSettings, fileExtensions, classpath, file:, 物理パス, 論理パス設定例

</details>

## ファイルアクセスAPI

### ファイルレコードライタ

**クラス**: `FileRecordWriterHolder`

プロセスレベルで入出力対象ファイルを管理し、並行スレッドからの同一ファイルへの出力の同期制御が自動的に行われる。[../handler/FileRecordWriterDisposeHandler](../handlers/handlers-FileRecordWriterDisposeHandler.md) と組み合わせることで、ファイルクローズ等の終端処理をハンドラに委譲可能。

論理パス名を省略した場合、出力ファイルの論理パス名は **"output"**、フォーマット定義ファイルの論理パス名は **"format"** が使用される。

```java
// ファイルを開く
FileRecordWriterHolder.open("output", "results.dat", "results.fmt");

Map<String, Object> results = new DataRecord();
results.put("status", status);
results.put("processedData", processedData);

// レコードを出力する
FileRecordWriterHolder.write(results, "output", "results.dat");
```

### ファイルデータリーダ

本フレームワークでは、アプリケーションに対するデータ入力は全て [data_reader](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) インターフェースによって抽象化されている。ファイルの読込みには専用のデータリーダ [../reader/FileDataReader](../readers/readers-FileDataReader.md) を使用すること。

<details>
<summary>keywords</summary>

FileRecordWriterHolder, FileDataReader, ファイルレコードライタ, ファイルデータリーダ, ファイル出力, ファイル入力, FileRecordWriterDisposeHandler, DataRecord, data_reader

</details>
