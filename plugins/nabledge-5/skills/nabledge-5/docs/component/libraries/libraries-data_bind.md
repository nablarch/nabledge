# データバインド

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_io/data_bind.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/DataBindConfig.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/ObjectMapperFactory.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/ObjectMapper.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/LineNumber.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/download/FileResponse.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/upload/PartInfo.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/Csv.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/CsvFormat.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/CsvDataBindConfig.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/fixedlength/FixedLength.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/fixedlength/Field.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/fixedlength/FixedLengthDataBindConfig.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/fixedlength/FixedLengthDataBindConfigBuilder.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/fixedlength/MultiLayout.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/fixedlength/MultiLayoutConfig/RecordIdentifier.html)

## 機能概要

CSVやTSV、固定長データをJava BeansオブジェクトまたはMapオブジェクトとして扱う機能。

## Java Beansオブジェクトとして扱う
- `BeanUtil` による自動型変換。型変換失敗時は例外が発生し、Java Beansオブジェクトは生成されない

> **重要**: アップロードファイルなど外部から受け付けたデータを読み込む場合、不正なデータを業務エラーとして通知するため、Java BeansクラスのプロパティはすべてString型で定義すること

## Mapオブジェクトとして扱う
- 値はすべてString型で格納される

## フォーマット指定
- アノテーションまたは `DataBindConfig` で定義できる（設定ファイル不要）
- CSV: [data_bind-csv_format](#s10)
- 固定長: [data_bind-fixed_length_format](#)

CSVファイルのフォーマット指定はJava BeansクラスにバインドするとMapクラスにバインドする2種類の指定方法がある。

## Java Beansクラスにバインドする場合

**アノテーション**: `Csv`, `CsvFormat`

CSVファイルのフォーマットは予め用意したフォーマットセットから選択できる（[data_bind-csv_format_set](#) 参照）。フォーマットセットに該当しない場合は `CsvFormat` で個別指定し、`@Csv` の `type` 属性に `CUSTOM` を指定する。

```java
// DEFAULTフォーマットセット使用
@Csv(type = Csv.CsvType.DEFAULT, properties = {"age", "name"}, headers = {"年齢", "氏名"})
public class Person {
    private Integer age;
    private String name;
}

// CUSTOMフォーマット個別指定
@Csv(type = Csv.CsvType.CUSTOM, properties = {"age", "name"})
@CsvFormat(
        fieldSeparator = '\t',
        lineSeparator = "\r\n",
        quote = '\'',
        ignoreEmptyLine = false,
        requiredHeader = false,
        charset = "UTF-8",
        quoteMode = CsvDataBindConfig.QuoteMode.ALL,
        emptyToNull = true)
public class Person {
    private Integer age;
    private String name;
}
```

> **補足**: Java BeansクラスにバインドするはObjectMapper生成時にDataBindConfigを使ったフォーマット指定はできない。フォーマットはアノテーションで行う。

## Mapクラスにバインドする場合

`ObjectMapper` 生成時に `CsvDataBindConfig` でフォーマット指定する。`CsvDataBindConfig#withProperties` で設定したプロパティ名がMapオブジェクトのキーになる。CSVにヘッダ行がある場合、プロパティ名の設定を省略するとヘッダタイトルがキーとして使われる。

ヘッダタイトルとプロパティ名はCSVの項目順と一致するように定義すること。

```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config);
```

## CSVファイルのフォーマットとして指定できるフォーマットセット

デフォルトで提供しているCSVファイルのフォーマットセット及び設定値:

| | DEFAULT | RFC4180 | EXCEL | TSV |
|---|---|---|---|---|
| 列区切り | カンマ(,) | カンマ(,) | カンマ(,) | タブ(\t) |
| 行区切り | 改行(\r\n) | 改行(\r\n) | 改行(\r\n) | 改行(\r\n) |
| フィールド囲み文字 | ダブルクォート(") | ダブルクォート(") | ダブルクォート(") | ダブルクォート(") |
| 空行を無視 | true | false | false | false |
| ヘッダ行あり | true | false | false | false |
| 文字コード | UTF-8 | UTF-8 | UTF-8 | UTF-8 |
| クォートモード | NORMAL | NORMAL | NORMAL | NORMAL |

**クォートモード**: CSVファイルへの書き込み時にどのフィールドをフィールド囲み文字で囲むかを示すモード。

| クォートモード名 | 対象フィールド |
|---|---|
| NORMAL | フィールド囲み文字、列区切り文字、改行のいずれかを含むフィールド |
| ALL | 全てのフィールド |

> **補足**: CSVファイルの読み込み時はクォートモードは使用せず、自動的にフィールド囲み文字の有無を判定して読み込みを行う。

`ObjectMapper` の読み込み・書き込みはスレッドアンセーフ。複数スレッドで共有する場合は呼び出し元にて同期処理を行うこと。

<details>
<summary>keywords</summary>

BeanUtil, DataBindConfig, CSVデータバインド, Mapオブジェクト変換, 型変換, フォーマット指定, アノテーション, Csv, CsvFormat, CsvDataBindConfig, ObjectMapper, ObjectMapperFactory, @Csv, @CsvFormat, withProperties, CsvType, CSVフォーマット指定, Java Beansバインド, Mapバインド, フォーマットセット, CSVフォーマットセット, DEFAULT, RFC4180, EXCEL, TSV, クォートモード, nablarch.common.databind.ObjectMapper, スレッドアンセーフ, フィールド囲み文字

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-databind</artifactId>
</dependency>

<!-- ファイルダウンロードを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-extension</artifactId>
</dependency>
```

固定長ファイルのフォーマット指定はJava BeansクラスにバインドするとMapクラスにバインドする2種類の指定方法がある。

## Java Beansクラスにバインドする場合

**アノテーション**: `FixedLength`, `Field`

各フィールドにパディングやトリムを行うコンバータを指定できる。標準コンバータは `nablarch.common.databind.fixedlength.converter` パッケージ配下を参照。

未使用領域が存在する場合、固定長ファイルへの書き込み時に `FixedLength#fillChar` に設定した文字で自動的にパディングされる（デフォルトは半角スペース）。

```java
@FixedLength(length = 19, charset = "MS932", lineSeparator = "\r\n")
public class Person {
    @Field(offset = 1, length = 3)
    @Lpad
    private Integer age;

    @Field(offset = 4, length = 16)
    @Rpad
    private String name;
}

// 未使用領域あり（fillCharで'0'埋め）
@FixedLength(length = 24, charset = "MS932", lineSeparator = "\r\n", fillChar = '0')
public class Person {
    @Field(offset = 1, length = 3)
    @Lpad
    private Integer age;

    @Field(offset = 9, length = 16)
    @Rpad
    private String name;
}
```

## Mapクラスにバインドする場合

`ObjectMapper` 生成時に `FixedLengthDataBindConfig` でフォーマット指定する。`FixedLengthDataBindConfig` は `FixedLengthDataBindConfigBuilder` で生成する。

```java
final DataBindConfig config = FixedLengthDataBindConfigBuilder
        .newBuilder()
        .length(19)
        .charset(Charset.forName("MS932"))
        .lineSeparator("\r\n")
        .singleLayout()
        .field("age", 1, 3, new Lpad.Converter('0'))
        .field("name", 4, 16, new Rpad.RpadConverter(' '))
        .build();

final ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config);
```

<details>
<summary>keywords</summary>

nablarch-common-databind, nablarch-fw-web-extension, Maven依存関係, モジュール設定, FixedLength, Field, FixedLengthDataBindConfig, FixedLengthDataBindConfigBuilder, ObjectMapperFactory, @FixedLength, @Field, @Lpad, @Rpad, fillChar, 固定長フォーマット指定, パディング, トリム, singleLayout

</details>

## データをJava Beansオブジェクトとして読み込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用。Java Beansクラスのアノテーション定義に基づきデータを読み込む。

アノテーション定義方法: [data_bind-csv_format-beans](#), [data_bind-fixed_length_format-beans](#)

```java
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, inputStream)) {
    Person person;
    while ((person = mapper.read()) != null) {
        // Java Beansオブジェクトごとの処理
    }
} catch (InvalidDataFormatException e) {
    // フォーマット不正時の処理
}
```

> **重要**: 全データ読み込み後は `ObjectMapper#close` でリソースを解放すること。Java 7以降は `try-with-resources` でクローズ処理を省略可能

複数フォーマットの固定長ファイルの指定もJava BeansクラスにバインドするとMapクラスにバインドする2種類の指定方法がある。

## Java Beansクラスにバインドする場合

フォーマットごとにJava Beansクラスを定義し、それらをプロパティとして持つ `MultiLayout` の継承クラスを作成する。

ポイント:
1. フォーマットごとにJava Beansクラスを定義する
2. それらをプロパティとして持つ `MultiLayout` の継承クラスを定義する
3. `FixedLength` アノテーションの `multiLayout` 属性に `true` を設定する
4. `MultiLayout#getRecordIdentifier` をオーバーライドし、データがどのフォーマットに紐づくかを識別する `RecordIdentifier` の実装クラスを返す

```java
@FixedLength(length = 20, charset = "MS932", lineSeparator = "\r\n", multiLayout = true)
public class Person extends MultiLayout {
    @Record private Header header;
    @Record private Data data;

    @Override
    public RecordIdentifier getRecordIdentifier() {
        return new RecordIdentifier() {
            @Override
            public RecordName identifyRecordName(byte[] record) {
                return record[0] == 0x31 ? RecordType.HEADER : RecordType.DATA;
            }
        };
    }
}

public class Header {
    @Field(offset = 1, length = 1) private Long id;
    @Rpad @Field(offset = 2, length = 19) private String field;
}

public class Data {
    @Field(offset = 1, length = 1) private Long id;
    @Lpad @Field(offset = 2, length = 3) private Long age;
    @Rpad @Field(offset = 5, length = 16) private String name;
}

enum RecordType implements MultiLayoutConfig.RecordName {
    HEADER { public String getRecordName() { return "header"; } },
    DATA   { public String getRecordName() { return "data"; } }
}
```

読み込み・書き込み例:

```java
// 読み込む場合
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, inputStream)) {
    final Person person = mapper.read();
    if (RecordType.HEADER == person.getRecordName()) {
        final Header header = person.getHeader();
    }
}

// 書き込む場合
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, outputStream)) {
    final Person person = new Person();
    person.setHeader(new Header("1", "test"));
    mapper.write(person);
}
```

## Mapクラスにバインドする場合

[data_bind-fixed_length_format-map](#) と同様の手順でフォーマット指定する。

ポイント:
- `multiLayout()` メソッドを呼び出してマルチレイアウト用のDataBindConfigを生成する
- `recordIdentifier()` メソッドに `RecordIdentifier` の実装クラスを指定する

```java
final DataBindConfig config = FixedLengthDataBindConfigBuilder
        .newBuilder()
        .length(20)
        .charset(Charset.forName("MS932"))
        .lineSeparator("\r\n")
        .multiLayout()
        .record("header")
        .field("id", 1, 1, new DefaultConverter())
        .field("field", 2, 19, new Rpad.RpadConverter(' '))
        .record("data")
        .field("id", 1, 1, new DefaultConverter())
        .field("age", 2, 3, new Lpad.LpadConverter('0'))
        .field("name", 5, 16, new Rpad.RpadConverter(' '))
        .recordIdentifier(new RecordIdentifier() {
            @Override
            public RecordName identifyRecordName(byte[] record) {
                return record[0] == 0x31 ? RecordType.HEADER : RecordType.DATA;
            }
        })
        .build();
```

読み込み・書き込み例:

```java
// 読み込む場合
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, inputStream, config)) {
    final Map<String, ?> map = mapper.read();
    if (RecordType.HEADER == map.get("recordName")) {
        final Map<String, ?> header = map.get("header");
    }
}

// 書き込む場合
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config)) {
    final Map<String, ?> header = new HashMap<>();
    header.put("id", "1");
    header.put("field", "test");
    final Map<String, ?> map = new HashMap<>();
    map.put("recordName", RecordType.HEADER);
    map.put("header", header);
    mapper.write(map);
}
```

<details>
<summary>keywords</summary>

ObjectMapperFactory, ObjectMapper, InvalidDataFormatException, Java Beansオブジェクト読み込み, ファイル読み込み, try-with-resources, MultiLayout, MultiLayoutConfig, RecordIdentifier, RecordName, @Record, multiLayout, getRecordIdentifier, FixedLengthDataBindConfigBuilder, DefaultConverter, マルチレイアウト, 複数フォーマット, 固定長マルチレイアウト, identifyRecordName

</details>

## Java Beansオブジェクトの内容をデータファイルに書き込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用。Java Beansクラスのアノテーション定義に基づきデータを書き込む。

アノテーション定義方法: [data_bind-csv_format-beans](#), [data_bind-fixed_length_format-beans](#)

```java
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, outputStream)) {
    for (Person person : personList) {
        mapper.write(person);
    }
}
```

> **補足**: プロパティの値が `null` の場合は、未入力を表す値が出力される（例: CSVでは空文字）

データを出力する際に :ref:`format` を使用することで日付や数値などのデータの表示形式をフォーマットできる。詳細は :ref:`format` を参照すること。

<details>
<summary>keywords</summary>

ObjectMapperFactory, ObjectMapper, Java Beansオブジェクト書き込み, ファイル書き込み, nullプロパティ, format, 日付フォーマット, 数値フォーマット, 表示形式, データ出力

</details>

## データをMapオブジェクトとして読み込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用。`DataBindConfig` の設定値に基づきデータを読み込む。

DataBindConfig設定方法: [data_bind-csv_format-map](#), [data_bind-fixed_length_format-map](#)

```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, inputStream, config)) {
    Person person;
    while ((person = mapper.read()) != null) {
        // Mapオブジェクトごとの処理
    }
} catch (InvalidDataFormatException e) {
    // フォーマット不正時の処理
}
```

Java Beansクラスにバインドできるファイル形式を追加するには以下の手順が必要:

1. 指定した形式のファイルとJava Beansクラスをバインドさせるため、`ObjectMapper` の実装クラスを作成する
2. `ObjectMapperFactory` を継承したクラスを作成し、作成した `ObjectMapper` 実装クラスを生成する処理を追加する
3. `ObjectMapperFactory` の継承クラスをコンポーネント設定ファイルに設定する。コンポーネント名は **objectMapperFactory** とすること

```xml
<component name="objectMapperFactory" class="sample.SampleObjectMapperFactory" />
```

<details>
<summary>keywords</summary>

ObjectMapperFactory, ObjectMapper, DataBindConfig, CsvDataBindConfig, Mapオブジェクト読み込み, InvalidDataFormatException, objectMapperFactory, ファイル形式追加, Java Beansバインド拡張, コンポーネント設定

</details>

## Mapオブジェクトの内容をデータファイルに書き込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用。`DataBindConfig` の設定値に基づきデータを書き込む。

DataBindConfig設定方法: [data_bind-csv_format-map](#), [data_bind-fixed_length_format-map](#)

```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config)) {
    for (Map<String, Object> person : personList) {
        mapper.write(person);
    }
}
```

> **補足**: Mapオブジェクトのvalue値が `null` の場合は、未入力を表す値が出力される（例: CSVでは空文字）

<details>
<summary>keywords</summary>

ObjectMapperFactory, ObjectMapper, DataBindConfig, CsvDataBindConfig, Mapオブジェクト書き込み

</details>

## ファイルのデータの論理行番号を取得する

Java Beansクラスにプロパティを定義し `LineNumber` を付与することで、データ読み込み時に論理行番号を取得できる（例: バリデーションエラー発生データの行番号をログ出力）。

```java
private Long lineNumber;

@LineNumber
public Long getLineNumber() {
    return lineNumber;
}
```

> **補足**: Mapオブジェクトとして取得する場合は行番号を取得できない

<details>
<summary>keywords</summary>

LineNumber, @LineNumber, 論理行番号, バリデーションエラー行番号

</details>

## データの入力値をチェックする

データをJava Beansオブジェクトとして読み込むため、[bean_validation](libraries-bean_validation.md) による入力値チェックが可能。

```java
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, inputStream)) {
    Person person;
    while ((person = mapper.read()) != null) {
        ValidatorUtil.validate(person);
        // 後続の処理
    }
} catch (InvalidDataFormatException e) {
    // データファイルのフォーマット不正時の処理
}
```

<details>
<summary>keywords</summary>

ValidatorUtil, InvalidDataFormatException, bean_validation, 入力値チェック, バリデーション

</details>

## ファイルダウンロードで使用する

ウェブアプリケーションでのファイルダウンロード実装のポイント:
- 大量データのメモリ圧迫を避けるため一時ファイルに出力する
- `FileResponse` 生成時にデータファイルを指定する
- リクエスト処理終了時に自動削除する場合は `FileResponse` コンストラクタの第二引数に `true` を指定する
- レスポンスに `Content-Type` と `Content-Disposition` を設定する

```java
public HttpResponse download(HttpRequest request, ExecutionContext context) {
    // 業務処理

    final Path path = Files.createTempFile(null, null);
    try (ObjectMapper<Person> mapper =
            ObjectMapperFactory.create(Person.class, Files.newOutputStream(path))) {
        for (Person person : persons) {
            mapper.write(BeanUtil.createAndCopy(PersonDto.class, person));
        }
    }

    FileResponse response = new FileResponse(path.toFile(), true);
    response.setContentType("text/csv; charset=Shift_JIS");
    response.setContentDisposition("person.csv");

    return response;
}
```

<details>
<summary>keywords</summary>

FileResponse, BeanUtil, ファイルダウンロード, Content-Type, Content-Disposition, 一時ファイル

</details>

## アップロードファイルのデータを読み込む

ウェブアプリケーションでのアップロードファイル読み込みのポイント:
- `PartInfo#getInputStream` でアップロードファイルのストリームを取得する
- 不正データの可能性があるため [bean_validation](libraries-bean_validation.md) で入力チェックを行う

```java
List<PartInfo> partInfoList = request.getPart("uploadFile");
if (partInfoList.isEmpty()) {
    // アップロードファイルが見つからない場合の処理
}

PartInfo partInfo = partInfoList.get(0);
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, partInfo.getInputStream())) {
    Person person;
    while ((person = mapper.read()) != null) {
        ValidatorUtil.validate(person);
        // 後続の処理
    }
} catch (InvalidDataFormatException e) {
    // フォーマット不正時の処理
}
```

<details>
<summary>keywords</summary>

PartInfo, getInputStream, ValidatorUtil, アップロードファイル読み込み, bean_validation, 入力チェック

</details>
