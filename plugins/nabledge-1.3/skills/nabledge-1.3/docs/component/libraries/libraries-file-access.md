## ファイルアクセス機能

本稿では、業務アプリケーションからシステム内のファイルシステムにアクセスする際に使用する
以下の機能について解説する。

* 論理パス

  本フレームワークでは、業務アプリケーションから処理対象のファイルを指定する際、
  アプリケーションが動作環境に依存することを回避するために、 **論理パス** と呼ばれる文字列を使用する。
* ファイルアクセスAPI

  業務アプリケーションからデータファイルの読み書きを行う際に使用するAPIである。
  この機能では、データファイルの内容を [汎用データフォーマット機能](../../component/libraries/libraries-record-format.md) を用いて解析する。
  これによって、ファイル内の各レコードを単なるMapとしてアクセスできるようになっている。

-----

-----

### 論理パス

**論理パス** は、ファイルの格納先ディレクトリを表す文字列で、バッチの結果として出力されるファイル、フォーマット定義ファイル、アプリケーション固有の設定ファイルの格納先、といった用途ごとに定義する。
各論理パスに対する物理パスの定義は、 [FilePathSetting](../../javadoc/nablarch/core/util/FilePathSetting.html) クラスに設定し、それを キー名 **filePathSetting** で、 [リポジトリ](../02_FunctionDemandSpecifications/01_Core/02_Repository.html) に登録しておく必要がある。

**既定論理パス名**

以下に、本フレームワーク内の各機能において、デフォルトの参照先として設定されている論理パス名を示す。

| 論理パス名 | 内容 |
|---|---|
| **output** | 業務処理の結果として生成されるファイルを出力するディレクトリ。 |
| **input** | 業務処理の入力となるファイルを格納したディレクトリ。 |
| **format** | ファイル、電文等の [フォーマット定義ファイル](../../component/libraries/libraries-record-format.md) を格納したディレクトリ。 |

**拡張子の設定**

各論理パスには、そこに格納されるファイルの拡張子を定義することができる。
この場合、ファイル名には拡張子を除いた文字列を指定する。

#### 設定方法

[FilePathSetting](../../javadoc/nablarch/core/util/FilePathSetting.html) クラスの設定項目の一覧と、設定例を以下に示す。

**設定項目一覧**

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| basePathSettings（必須） | 論理パス名と対応する物理パスの組み合わせ。 | Map<String, String> | **キー:** 論理パス名、 **値:** 物理パス 物理パスはURLの形式で指定し、ファイルシステムもしくはクラスパス上のリソースを指定する。 **ただし、パスにはスペースを含めないこと。（スペースが含まれているパスは指定できない）**  **記述書式**  ```bash ("file"\|"classpath"):(リソースのパス) ```  **使用例**  ```bash file:./main/format   # ファイルパスの場合 classpath:web/format # クラスパスの場合 ```  クラスパスを指定する場合、そのパスにはディレクトリが存在している 必要がある。 ディレクトリが存在しない場合は、例外をスローする。  ファイルパスを指定する場合、そのパスにディレクトリが存在して いなければ、本メソッド内でディレクトリを作成する。 |
| fileExtensions | 論理パス名とその配下に格納されるファイルの拡張子の組み合わせ。 | Map<String, String> | (任意指定: デフォルトは空のMap) |

**設定ファイルの記述例**

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
      <!--フォーマット定義ファイルの格納ディレクトリ-->
      <entry key="format" value="file:./main/format" />
      <!--入力ファイルの格納ディレクトリ-->
      <entry key="input" value="file:./work/input" />
      <!--出力ファイルの格納ディレクトリ-->
      <entry key="output" value="file:./work/output" />
    </map>
  </property>
</component>
```

### ファイルアクセスAPI

-----

#### ファイルレコードライタ

アプリケーションでファイルを出力する場合は、 [FileRecordWriterHolder](../../javadoc/nablarch/common/io/FileRecordWriterHolder.html) クラスを使用する。
このクラスでは、プロセスレベルで入出力対象ファイルの管理を行っており、並行スレッドからの同一ファイルに対する出力の同期制御が自動的に行われる。

また、 [出力ファイル開放ハンドラ](../../component/handlers/handlers-FileRecordWriterDisposeHandler.md) と組み合わせて使用することで、ファイルクローズ等の終端処理をハンドラに委譲することが可能となる。

[FileRecordWriterHolder](../../javadoc/nablarch/common/io/FileRecordWriterHolder.html) クラスを使用する場合、出力するファイルとフォーマット定義ファイルが格納されるディレクトリの 論理パス名 および出力ファイル名を指定する。
論理パス名を指定しなかった場合、出力するファイルの論理パス名として **"output"** 、フォーマット定義ファイルの論理パス名として **"format"** が使用される。

```java
String outputFileBasePathName = "output";     // 出力ファイル格納ディレクトリの論理パス名
String outputFileName         = "results.dat" // 出力ファイル名
String formatFileName         = "results.fmt" // フォーマット定義ファイル格納ディレクトリの論理パス名

// 対象のファイルを開く。
FileRecordWriterHolder.open(outputFileBasePathName,
                            outputFileName,
                            formatFileName);

Map<String, Object> results = new DataRecord();
results.put("status", status);
results.put("processedData", processedData);
//
// 後略
//

// レコードを対象のファイルに出力する。
FileRecordWriterHolder.write(results, outputFileBasePathName, outputFileName);
```

#### ファイルデータリーダ

本フレームワークでは、アプリケーションに対するデータ入力は全て [データリーダ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#data-reader)
インターフェースによって抽象化されている。
ファイルの読込みについても、専用のデータリーダ [ファイルデータリーダ](../../component/readers/readers-FileDataReader.md) が用意されているので
それを使用すること。
