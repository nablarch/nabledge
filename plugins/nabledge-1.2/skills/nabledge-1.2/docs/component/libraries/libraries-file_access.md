# ファイルアクセス機能

## 論理パス

**論理パス**は、ファイルの格納先ディレクトリを表す文字列。用途ごとに定義する。物理パスの定義は `FilePathSetting` クラスに設定し、キー名 **filePathSetting** でリポジトリに登録する必要がある。

**既定論理パス名**

| 論理パス名 | 内容 |
|---|---|
| output | 業務処理の結果として生成されるファイルを出力するディレクトリ |
| input | 業務処理の入力となるファイルを格納したディレクトリ |
| format | [フォーマット定義ファイル](libraries-record_format.md) を格納したディレクトリ |

各論理パスには拡張子を定義できる。この場合、ファイル名には拡張子を除いた文字列を指定する。

**クラス**: `nablarch.core.util.FilePathSetting`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| basePathSettings | Map\<String, String\> | ○ | | 論理パス名と物理パスの組み合わせ。物理パスは `file:` または `classpath:` プレフィックスのURL形式で指定。**パスにスペースを含めないこと。** |
| fileExtensions | Map\<String, String\> | | 空のMap | 論理パス名とファイル拡張子の組み合わせ |

`basePathSettings` の制約:
- `classpath:` を指定する場合、ディレクトリが存在している必要がある。ディレクトリが存在しない場合は例外をスローする。
- `file:` を指定する場合、ディレクトリが存在していなければ本メソッド内でディレクトリを作成する。

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

FilePathSetting, basePathSettings, fileExtensions, filePathSetting, 論理パス, 物理パス, ファイルパス設定, 拡張子設定

</details>

## ファイルアクセスAPI

データファイルの内容は [record_format](libraries-record_format.md) を用いて解析され、ファイル内の各レコードを単なるMapとしてアクセスできる。

## ファイルレコードライタ

**クラス**: `FileRecordWriterHolder`

ファイル出力には `FileRecordWriterHolder` を使用する。プロセスレベルで入出力対象ファイルを管理し、並行スレッドからの同一ファイルへの出力の同期制御が自動的に行われる。

[../handler/FileRecordWriterDisposeHandler](../handlers/handlers-FileRecordWriterDisposeHandler.md) と組み合わせることで、ファイルクローズ等の終端処理をハンドラに委譲できる。

論理パス名を省略した場合のデフォルト:
- 出力ファイルの論理パス名: **"output"**
- フォーマット定義ファイルの論理パス名: **"format"**

```java
// 対象のファイルを開く
FileRecordWriterHolder.open(outputFileBasePathName, outputFileName, formatFileName);

Map<String, Object> results = new DataRecord();
results.put("status", status);
results.put("processedData", processedData);

// レコードを対象のファイルに出力する
FileRecordWriterHolder.write(results, outputFileBasePathName, outputFileName);
```

## ファイルデータリーダ

本フレームワークでは、アプリケーションに対するデータ入力は全て [data_reader](../../about/about-nablarch/about-nablarch-concept.md) インターフェースによって抽象化されている。ファイルの読込みについても、専用のデータリーダ [../reader/FileDataReader](../readers/readers-FileDataReader.md) が用意されているのでそれを使用すること。

<details>
<summary>keywords</summary>

FileRecordWriterHolder, FileDataReader, FileRecordWriterDisposeHandler, DataRecord, data_reader, record_format, ファイル出力, ファイル読み込み, 同期制御, ファイルレコードライタ, ファイルデータリーダ

</details>
