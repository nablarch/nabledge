# ファイルをDBに登録するバッチの作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/getting_started/nablarch_batch/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/Csv.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/CsvFormat.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/LineNumber.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/ObjectMapper.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchAction.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html)

## 住所ファイル登録バッチ実行手順

## 住所ファイル登録バッチ実行手順

### 1. 登録対象テーブルのデータを削除する

H2のコンソールから下記SQLを実行し、データ登録対象テーブルのデータを削除する。

```sql
TRUNCATE TABLE ZIP_CODE_DATA;
```

### 2. 住所ファイル登録バッチを実行する

コマンドプロンプトから下記コマンドを実行する。

```bash
$cd {nablarch-example-batchリポジトリ}
$mvn exec:java -Dexec.mainClass=nablarch.fw.launcher.Main ^
    -Dexec.args="'-requestPath' 'ImportZipCodeFileAction/ImportZipCodeFile' '-diConfig' 'classpath:import-zip-code-file.xml' '-userId' '105'"
```

### 3. ファイルの内容がDBに登録されたことを確認する

H2のコンソールから下記SQLを実行し、住所情報が登録されていることを確認する。

```sql
SELECT * FROM ZIP_CODE_DATA;
```

<details>
<summary>keywords</summary>

ZIP_CODE_DATA, TRUNCATE, ImportZipCodeFileAction, ImportZipCodeFile, import-zip-code-file.xml, mvn exec:java, nablarch.fw.launcher.Main, requestPath, diConfig, userId, バッチ実行, テーブル削除, 登録確認

</details>

## 入力データソースからデータを読み込む

## フォームクラスの作成

**クラス**: `ZipCodeForm`
**アノテーション**: `Csv`, `CsvFormat`, `LineNumber`

- [data_bind](../../component/libraries/libraries-data_bind.md) でCSVをバインドするフォームに `@Csv` と `@CsvFormat` を付与する
- `@Csv` の `type` 属性に `CsvType.CUSTOM` を指定し、`@CsvFormat` の `quoteMode` 属性に `QuoteMode.NORMAL` を指定する
- [bean_validation](../../component/libraries/libraries-bean_validation.md) 実施のためバリデーションアノテーション（`@Domain`, `@Required`）を付与する
- 行数プロパティのゲッタに `@LineNumber` を付与すると対象データの行番号が自動設定される

## データリーダの作成

**クラス**: `ZipCodeFileReader`（`DataReader` 実装）

- ファイルパスの取得には `FilePathSetting.getInstance()` を使用し、`csv-input` ベースパスから `importZipCode` ファイルを取得する
- `ObjectMapperFactory.create(ZipCodeForm.class, ...)` で `ObjectMapper` を生成し、`ObjectMapperIterator` でラップしてイテレータを作成する
- `read`: イテレータから一行分のデータを返却し、業務アクションハンドラへ引き渡す
- `hasNext`: 次行の有無を判定。`false` を返すとファイル読み込みが終了する
- `close`: `ObjectMapperIterator#close()` を呼び出してストリームのclose処理を行う

> **補足**: `ObjectMapper` のように `hasNext` メソッドを持たないクラスからデータを読む場合、`ObjectMapperIterator` を作成するとデータリーダの実装をシンプルにできる

<details>
<summary>keywords</summary>

ZipCodeForm, ZipCodeFileReader, ObjectMapperIterator, ObjectMapperFactory, FilePathSetting, DataReader, ObjectMapper, @Csv, @CsvFormat, @LineNumber, @Domain, @Required, CsvType, QuoteMode, CSVファイル読み込み, データリーダ, csv-input, importZipCode, バリデーション, 行番号

</details>

## 業務ロジックを実行する

## 業務アクションの作成

**クラス**: `ImportZipCodeFileAction`（`BatchAction` 継承）

- `handle`: データリーダから渡された一行分のデータに対する処理を実装する。`BeanUtil.createAndCopy(ZipCodeData.class, inputData)` でフォームをエンティティ（`ZipCodeData`）に変換し、`UniversalDao.insert` でDBに登録する。処理成功時は `return new Result.Success();` を返す
- `createReader`: 使用するデータリーダクラス（`ZipCodeFileReader`）のインスタンスを返す
- `@ValidateData` インターセプタにより、`handle` メソッドには常にバリデーション済みの入力データが引き渡される

> **補足**: [bean_validation](../../component/libraries/libraries-bean_validation.md) のロジックはバッチ間で差がないため、インターセプタ（`@ValidateData`）を作成してバリデーション処理を共通化できる

<details>
<summary>keywords</summary>

ImportZipCodeFileAction, BatchAction, ZipCodeData, BeanUtil, UniversalDao, ZipCodeFileReader, @ValidateData, handle, createReader, Result, Result.Success, 業務アクション, DBへのデータ登録, インターセプタ, バリデーション共通化

</details>
