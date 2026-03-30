# ファイルアクセス機能

## 論理パス

**論理パス**とは、ファイルの格納先ディレクトリを表す文字列。業務アプリケーションが動作環境に依存することを回避するために使用する。

各論理パスに対する物理パスの定義は `FilePathSetting` クラスに設定し、キー名 **filePathSetting** でリポジトリに登録する必要がある。

**クラス**: `nablarch.core.util.FilePathSetting`

## 既定論理パス名

| 論理パス名 | 内容 |
|---|---|
| **output** | 業務処理の結果として生成されるファイルを出力するディレクトリ |
| **input** | 業務処理の入力となるファイルを格納したディレクトリ |
| **format** | [フォーマット定義ファイル](libraries-record_format.md) を格納したディレクトリ |

各論理パスには格納されるファイルの拡張子を定義できる。この場合、ファイル名には拡張子を除いた文字列を指定する。

## 設定項目

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| basePathSettings | Map<String, String> | ○ | | 論理パス名と物理パスの組み合わせ。キー: 論理パス名、値: 物理パス |
| fileExtensions | Map<String, String> | | 空のMap | 論理パス名とファイル拡張子の組み合わせ |

**物理パスの形式**: `("file"|"classpath"):(リソースのパス)`

例: `file:./main/format`（ファイルパス）、`classpath:web/format`（クラスパス）

> **重要**: パスにはスペースを含めないこと。スペースが含まれているパスは指定できない。

クラスパスを指定する場合、そのパスにはディレクトリが存在している必要がある。ディレクトリが存在しない場合は例外をスローする。

ファイルパスを指定する場合、そのパスにディレクトリが存在していなければ、自動的にディレクトリを作成する。

## 設定例

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

FilePathSetting, basePathSettings, fileExtensions, filePathSetting, 論理パス, 物理パス, ファイルパス設定, output, input, format

</details>

## ファイルアクセスAPI

ファイルアクセスAPIは、データファイルの内容を `record_format` を用いて解析する。これにより、ファイル内の各レコードを単なるMapとしてアクセスできる。

## ファイルレコードライタ

**クラス**: `FileRecordWriterHolder`

ファイルを出力する場合は `FileRecordWriterHolder` クラスを使用する。プロセスレベルで入出力対象ファイルの管理を行い、並行スレッドからの同一ファイルへの出力の同期制御が自動的に行われる。

[../handler/FileRecordWriterDisposeHandler](../handlers/handlers-FileRecordWriterDisposeHandler.md) と組み合わせて使用することで、ファイルクローズ等の終端処理をハンドラに委譲できる。

論理パス名を省略した場合: 出力ファイルの論理パス名は **"output"**、フォーマット定義ファイルの論理パス名は **"format"** が使用される。

```java
String outputFileBasePathName = "output";
String outputFileName         = "results.dat";
String formatFileName         = "results.fmt";

FileRecordWriterHolder.open(outputFileBasePathName, outputFileName, formatFileName);

Map<String, Object> results = new DataRecord();
results.put("status", status);
results.put("processedData", processedData);

FileRecordWriterHolder.write(results, outputFileBasePathName, outputFileName);
```

## ファイルデータリーダ

ファイルの読込みには専用のデータリーダ [../reader/FileDataReader](../readers/readers-FileDataReader.md) を使用すること。データ入力は [data_reader](../../about/about-nablarch/about-nablarch-concept.md) インターフェースによって抽象化されている。

<details>
<summary>keywords</summary>

FileRecordWriterHolder, FileDataReader, FileRecordWriterDisposeHandler, DataRecord, ファイルレコードライタ, ファイルデータリーダ, ファイル出力, ファイル読み込み

</details>
