# ファイルをDBに登録するバッチの作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/getting_started/nablarch_batch/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/Csv.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/CsvFormat.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/LineNumber.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/ObjectMapper.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchAction.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html)

## ファイルをDBに登録する

CSVファイルをDBに登録するバッチは「フォーム → データリーダ → バッチアクション」の3コンポーネントで構成する。処理フローは [Nablarchバッチの処理フロー](nablarch-batch-architecture.md) 、責務配置は [Nablarchバッチの責務配置](nablarch-batch-application_design.md) を参照。

### フォーム作成（CSVバインディング）

[data_bind](../../component/libraries/libraries-data_bind.md) でCSVをバインドするフォームには `Csv` および `CsvFormat` を付与する。[bean_validation](../../component/libraries/libraries-bean_validation.md) 用のバリデーションアノテーションも付与する。行番号を取得するにはゲッタに `LineNumber` を付与する。

```java
@Csv(properties = {/** プロパティ定義 **/}, type = CsvType.CUSTOM)
@CsvFormat(charset = "UTF-8", fieldSeparator = ',',
        ignoreEmptyLine = true, lineSeparator = "\r\n", quote = '"',
        quoteMode = QuoteMode.NORMAL, requiredHeader = false, emptyToNull = true)
public class ZipCodeForm {
    @Domain("localGovernmentCode")
    @Required
    private String localGovernmentCode;

    @LineNumber
    public Long getLineNumber() { return lineNumber; }
}
```

### データリーダ作成

`DataReader` を実装し、`read()`・`hasNext()`・`close()` の3メソッドを実装する。

- `read()`: 1行分のデータを業務アクションへ引き渡す
- `hasNext()`: `false` を返すとファイル読み込みが終了する
- `close()`: ストリームのクローズ処理を実装する

```java
public class ZipCodeFileReader implements DataReader<ZipCodeForm> {
    private static final String FILE_NAME = "importZipCode";
    private ObjectMapperIterator<ZipCodeForm> iterator;

    @Override
    public ZipCodeForm read(ExecutionContext ctx) {
        if (iterator == null) initialize();
        return iterator.next();
    }

    @Override
    public boolean hasNext(ExecutionContext ctx) {
        if (iterator == null) initialize();
        return iterator.hasNext();
    }

    @Override
    public void close(ExecutionContext ctx) { iterator.close(); }

    private void initialize() {
        File zipCodeFile = FilePathSetting.getInstance().getFileWithoutCreate("csv-input", FILE_NAME);
        try {
            iterator = new ObjectMapperIterator<>(ObjectMapperFactory.create(ZipCodeForm.class,
                new FileInputStream(zipCodeFile)));
        } catch (FileNotFoundException e) {
            throw new IllegalStateException(e);
        }
    }
}
```

> **補足**: `ObjectMapper` のように `hasNext()` を持たないクラスからデータを読む場合、イテレータを作成することでデータリーダをシンプルに実装できる。

### バッチアクション作成

`BatchAction` を継承し、`handle()` と `createReader()` を実装する。

- `handle()`: データリーダから渡された1行分のデータを処理する
- `createReader()`: 使用するデータリーダのインスタンスを返却する
- `UniversalDao#insert` でエンティティをDBに登録する

```java
public class ImportZipCodeFileAction extends BatchAction<ZipCodeForm> {
    @Override
    @ValidateData
    public Result handle(ZipCodeForm inputData, ExecutionContext ctx) {
        ZipCodeData data = BeanUtil.createAndCopy(ZipCodeData.class, inputData);
        UniversalDao.insert(data);
        return new Result.Success();
    }

    @Override
    public DataReader<ZipCodeForm> createReader(ExecutionContext ctx) {
        return new ZipCodeFileReader();
    }
}
```

> **補足**: [bean_validation](../../component/libraries/libraries-bean_validation.md) のロジックはバッチ間で共通のため、インターセプタ（`@ValidateData`）を作成してバリデーション処理を共通化できる。

<details>
<summary>keywords</summary>

ZipCodeForm, ZipCodeFileReader, ImportZipCodeFileAction, DataReader, BatchAction, ObjectMapper, ObjectMapperIterator, UniversalDao, BeanUtil, ZipCodeData, ExecutionContext, FilePathSetting, ObjectMapperFactory, Result, CsvType, QuoteMode, FileInputStream, FileNotFoundException, @Csv, @CsvFormat, @LineNumber, @ValidateData, @Domain, @Required, CSVファイル読み込み, データリーダ実装, バッチアクション実装, DB登録

</details>

## 住所ファイル登録バッチ実行手順

住所ファイル登録バッチの実行手順は以下の通り。

### 手順1: 登録対象テーブルのデータを削除する

H2のコンソールから下記SQLを実行し、データ登録対象テーブルのデータを削除する。

```sql
TRUNCATE TABLE ZIP_CODE_DATA;
```

### 手順2: 住所ファイル登録バッチを実行する

コマンドプロンプトから下記コマンドを実行する。`-requestPath` の形式は `アクションクラス名/リクエストID`、`-diConfig` にはDIコンテナの設定ファイルを指定する。

```bash
$cd {nablarch-example-batchリポジトリ}
$mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-requestPath' 'ImportZipCodeFileAction/ImportZipCodeFile' '-diConfig' 'classpath:import-zip-code-file.xml' '-userId' '105'"
```

主なパラメータ:
- `-requestPath`: `ImportZipCodeFileAction/ImportZipCodeFile`（アクションクラス名/リクエストID形式）
- `-diConfig`: `classpath:import-zip-code-file.xml`（DIコンテナ設定ファイル）
- `-userId`: `105`

### 手順3: ファイルの内容がDBに登録されたことを確認する

H2のコンソールから下記SQLを実行し、住所情報が登録されていることを確認する。

```sql
SELECT * FROM ZIP_CODE_DATA;
```

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Main, requestPath, ImportZipCodeFileAction/ImportZipCodeFile, diConfig, import-zip-code-file.xml, userId, ZIP_CODE_DATA, TRUNCATE, mvn exec:java, バッチ起動, requestPathフォーマット

</details>
