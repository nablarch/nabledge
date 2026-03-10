# データバインド

## 機能概要

CSVやTSV、固定長データをJava BeansオブジェクトまたはMapオブジェクトとして扱う機能。

**Java Beansとして扱う場合**: `BeanUtil` で自動型変換。型変換失敗時は例外発生し、Java Beansオブジェクトは生成されない。

> **重要**: アップロードファイルなど外部から受け付けたデータを読み込む場合、不正データを業務エラーとして通知するため、Java BeansクラスのプロパティはすべてString型で定義しなければならない。

**Mapとして扱う場合**: 値はすべてString型で格納される。

**フォーマット指定**: 設定ファイルではなく、アノテーションまたは `DataBindConfig` を使用して定義する。

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

## データをJava Beansオブジェクトとして読み込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用してデータを読み込む。

> **注意**: `ObjectMapper` はスレッドセーフではない。複数スレッドで共有せず、スレッドごとに生成して使用すること。

> **重要**: 全データの読み込みが完了したら `ObjectMapper#close` でリソースを解放すること。`try-with-resources` を使用することでクローズ処理を省略可能。

```java
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, inputStream)) {
    Person person;
    while ((person = mapper.read()) != null) {
        // Java Beansオブジェクトごとの処理を記述
    }
} catch (InvalidDataFormatException e) {
    // 読み込んだデータのフォーマットが不正な場合の処理を記述
}
```

アノテーション定義方法: :ref:`data_bind-csv_format-beans`、:ref:`data_bind-fixed_length_format-beans`

## Java Beansオブジェクトの内容をデータファイルに書き込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用してデータを書き込む。

> **注意**: `ObjectMapper` はスレッドセーフではない。複数スレッドで共有せず、スレッドごとに生成して使用すること。

> **補足**: プロパティの値が `null` の場合は未入力を表す値が出力される（例: CSVの場合は空文字）。

```java
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, outputStream)) {
    for (Person person : personList) {
        mapper.write(person);
    }
}
```

アノテーション定義方法: :ref:`data_bind-csv_format-beans`、:ref:`data_bind-fixed_length_format-beans`

## データをMapオブジェクトとして読み込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用。 `DataBindConfig` の設定値をもとにデータを読み込む。

> **注意**: `ObjectMapper` はスレッドセーフではない。複数スレッドで共有せず、スレッドごとに生成して使用すること。

```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, inputStream, config)) {
    Person person;
    while ((person = mapper.read()) != null) {
        // Java Beansオブジェクトごとの処理を記述
    }
} catch (InvalidDataFormatException e) {
    // 読み込んだデータのフォーマットが不正な場合の処理を記述
}
```

DataBindConfig設定方法: :ref:`data_bind-csv_format-map`、:ref:`data_bind-fixed_length_format-map`

## Mapオブジェクトの内容をデータファイルに書き込む

`ObjectMapperFactory#create` で生成した `ObjectMapper` を使用。 `DataBindConfig` の設定値をもとにデータを書き込む。

> **注意**: `ObjectMapper` はスレッドセーフではない。複数スレッドで共有せず、スレッドごとに生成して使用すること。

> **補足**: Mapオブジェクトのvalue値が `null` の場合は未入力を表す値が出力される（例: CSVの場合は空文字）。

```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config)) {
    for (Map<String, Object> person : personList) {
        mapper.write(person);
    }
}
```

DataBindConfig設定方法: :ref:`data_bind-csv_format-map`、:ref:`data_bind-fixed_length_format-map`

## ファイルのデータの論理行番号を取得する

Java Beansクラスに `Long` 型プロパティを定義し、 `LineNumber` アノテーションをgetterに付与することで、データの論理行番号を取得できる（例: バリデーションエラー発生行番号のログ出力など）。

> **補足**: Mapオブジェクトとして取得する場合は、データの行番号を取得できない。

```java
private Long lineNumber;

@LineNumber
public Long getLineNumber() {
    return lineNumber;
}
```

## データの入力値をチェックする

Java Beansオブジェクトとして読み込んだデータに対して :ref:`bean_validation` による入力値チェックが可能。

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

## ファイルダウンロードで使用する

ウェブアプリケーションでのファイルダウンロード実装のポイント:
- 大量データのメモリ圧迫を避けるため、一時ファイルに出力する。
- `FileResponse` オブジェクト生成時にデータファイルを指定する。
- `FileResponse` コンストラクタの第二引数に `true` を指定するとリクエスト処理終了時にファイルが自動削除される。
- レスポンスに `Content-Type` 及び `Content-Disposition` を設定する。

```java
public HttpResponse download(HttpRequest request, ExecutionContext context) {
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

## アップロードファイルのデータを読み込む

ウェブアプリケーションでのアップロードファイル読み込みのポイント:
- `PartInfo#getInputStream` を使用してアップロードファイルのストリームを取得する。
- 不正なデータが入力されている可能性があるため、 :ref:`bean_validation` で入力チェックを行う。

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
    // データファイルのフォーマット不正時の処理
}
```

## CSVファイルのフォーマットを指定する

CSVファイルのフォーマット指定は、Java BeansクラスとMapクラスへのバインドで2種類の指定方法がある。

## Java Beansクラスにバインドする場合

**アノテーション**: `Csv`, `CsvFormat`

フォーマットセットから選択する場合は`@Csv`の`type`属性に定義済みの`CsvType`を指定する（:ref:`data_bind-csv_format_set` 参照）。

```java
@Csv(type = Csv.CsvType.DEFAULT, properties = {"age", "name"}, headers = {"年齢", "氏名"})
public class Person {
    private Integer age;
    private String name;
}
```

定義済みフォーマットセットに該当しない場合は`@Csv(type = Csv.CsvType.CUSTOM)`と`CsvFormat` を組み合わせて個別指定する。

```java
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
public class Person { ... }
```

> **補足**: Java Beansバインドの場合、フォーマット指定はアノテーションで行う。`ObjectMapper` 生成時に `DataBindConfig` を使用したフォーマット指定は不可。

## Mapクラスにバインドする場合

`ObjectMapper` 生成時に `CsvDataBindConfig` で個別フォーマットを指定する。

- `CsvDataBindConfig#withProperties` で設定したプロパティ名がMapのキーとして使用される
- CSVにヘッダ行がある場合、プロパティ名を省略するとヘッダタイトルをキーとして使用できる
- ヘッダタイトル・プロパティ名はCSVの項目順と一致するように定義すること

```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config);
```

## 固定長ファイルのフォーマットを指定する

固定長ファイルのフォーマット指定は、Java BeansクラスとMapクラスへのバインドで2種類の指定方法がある。

## Java Beansクラスにバインドする場合

**アノテーション**: `FixedLength`, `Field`

各フィールドにパディング・トリム等のコンバータを指定できる。標準コンバータは `converter` パッケージ配下を参照。

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
```

未使用領域がある場合、書き込み時に`FixedLength#fillChar`に設定した文字で自動パディングされる（デフォルトは半角スペース）。

```java
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

`ObjectMapper` 生成時に `FixedLengthDataBindConfig` で個別フォーマットを指定する。`FixedLengthDataBindConfig` は `FixedLengthDataBindConfigBuilder` で生成する。

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

## 固定長ファイルに複数のフォーマットを指定する

複数フォーマットを持つ固定長ファイルも、Java BeansクラスとMapクラスへのバインドで2種類の指定方法がある。

## Java Beansクラスにバインドする場合

1. フォーマットごとにJava Beansクラスを定義する
2. それらをプロパティとして持つ `MultiLayout` の継承クラスを作成する
3. 継承クラスに`@FixedLength`を設定し、`multiLayout = true`を指定する
4. `MultiLayout#getRecordIdentifier` をオーバーライドして、対象データがどのフォーマットに紐づくかを識別する `RecordIdentifier` の実装クラスを返す

```java
@FixedLength(length = 20, charset = "MS932", lineSeparator = "\r\n", multiLayout = true)
public class Person extends MultiLayout {

    @Record
    private Header header;

    @Record
    private Data data;

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
```

読み込み・書き込み例：

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

- `multiLayout()` メソッドを呼び出してマルチレイアウト用の`DataBindConfig`を生成する
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

読み込み・書き込み例：

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

## 出力するデータの表示形式をフォーマットする

データ出力時に :ref:`format` を使用して日付・数値などの表示形式をフォーマットできる。詳細は :ref:`format` を参照。

## 拡張例



## CSVファイルのフォーマットとして指定できるフォーマットセット

CSVフォーマットセットのデフォルト設定値:

| 設定項目 | DEFAULT | RFC4180 | EXCEL | TSV |
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

> **補足**: CSVファイルの読み込み時は、クォートモードは使用せずに自動的にフィールド囲み文字の有無を判定して読み込みを行う。

`ObjectMapper` の読み込み及び書き込みはスレッドアンセーフ。複数スレッドで `ObjectMapper` インスタンスを共有する場合は、呼び出し元にて同期処理を行うこと。
