# データバインド

## 機能概要

CSVやTSV、固定長といったデータをJava Beansオブジェクト及びMapオブジェクトとして扱う機能を提供する。

## Java Beansオブジェクトへの変換

**クラス**: `BeanUtil`

プロパティの型に応じて自動的に型変換。型変換失敗時は例外発生、Java Beansオブジェクト生成不可。

> **重要**: アップロードファイル等の外部データ読み込み時は、不正データを業務エラーとして通知する必要があるため、Java Beansクラスのプロパティは全てString型で定義すること。

詳細: :ref:`data_bind-file_to_bean`, :ref:`data_bind-bean_to_file`

## Mapオブジェクトへの変換

値は全てString型で格納。

詳細: :ref:`data_bind-file_to_map`, :ref:`data_bind-map_to_file`

## フォーマット指定

**クラス**: `DataBindConfig`

データファイルのフォーマットはアノテーションまたはDataBindConfigで定義（設定ファイル不使用）。

詳細: :ref:`data_bind-csv_format`, :ref:`data_bind-fixed_length_format`

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

**クラス**: `ObjectMapperFactory`, `ObjectMapper`

`ObjectMapperFactory#create` で生成したObjectMapperを使用。Java Beansクラスに定義されたアノテーションをもとにデータを読み込む。

フォーマット指定: :ref:`data_bind-csv_format-beans`, :ref:`data_bind-fixed_length_format-beans`

**実装例**:
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

> **重要**: `ObjectMapper#close` でリソースを解放すること。try-with-resourcesを使用することでクローズ処理を省略可能。

## Java Beansオブジェクトの内容をデータファイルに書き込む

**クラス**: `ObjectMapperFactory`, `ObjectMapper`

`ObjectMapperFactory#create` で生成したObjectMapperを使用。Java Beansクラスに定義されたアノテーションをもとにデータを書き込む。

フォーマット指定: :ref:`data_bind-csv_format-beans`, :ref:`data_bind-fixed_length_format-beans`

**実装例**:
```java
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, outputStream)) {
    for (Person person : personList) {
        mapper.write(person);
    }
}
```

> **補足**: プロパティ値がnullの場合、未入力を表す値が出力される（CSV: 空文字）。

## データをMapオブジェクトとして読み込む

**クラス**: `ObjectMapperFactory`, `ObjectMapper`, `DataBindConfig`

`ObjectMapperFactory#create` で生成したObjectMapperを使用。DataBindConfigの設定値をもとにデータを読み込む。

フォーマット指定: :ref:`data_bind-csv_format-map`, :ref:`data_bind-fixed_length_format-map`

**実装例**:
```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, inputStream, config)) {
    Map data;
    while ((data = mapper.read()) != null) {
        // Mapオブジェクトごとの処理
    }
} catch (InvalidDataFormatException e) {
    // フォーマット不正時の処理
}
```

## Mapオブジェクトの内容をデータファイルに書き込む

**クラス**: `ObjectMapperFactory`, `ObjectMapper`, `DataBindConfig`

`ObjectMapperFactory#create` で生成したObjectMapperを使用。DataBindConfigの設定値をもとにデータを書き込む。

フォーマット指定: :ref:`data_bind-csv_format-map`, :ref:`data_bind-fixed_length_format-map`

**実装例**:
```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config)) {
    for (Map<String, Object> data : dataList) {
        mapper.write(data);
    }
}
```

> **補足**: Mapオブジェクトのvalue値がnullの場合、未入力を表す値が出力される（CSV: 空文字）。

## ファイルのデータの論理行番号を取得する

**アノテーション**: `@LineNumber`

Java Beansクラスにプロパティを定義して@LineNumberを使用することで、データの論理行番号を取得できる。

**用途例**: バリデーションエラー発生データの行番号をログ出力

**実装例**:
```java
private Long lineNumber;

@LineNumber
public Long getLineNumber() {
    return lineNumber;
}
```

> **補足**: Mapオブジェクトとして取得する場合、行番号は取得できない。

## データの入力値をチェックする

Java Beansオブジェクトとして読み込むため、:ref:`bean_validation` による入力値チェックが可能。

**実装例**:
```java
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, inputStream)) {
    Person person;
    while ((person = mapper.read()) != null) {
        ValidatorUtil.validate(person);
        // 後続の処理
    }
} catch (InvalidDataFormatException e) {
    // フォーマット不正時の処理
}
```

## ファイルダウンロードで使用する

**クラス**: `FileResponse`

**ポイント**:
- 大量データダウンロード時のメモリ圧迫を避けるため、一時ファイルに出力
- データファイル書き込みは :ref:`data_bind-bean_to_file` を参照
- FileResponseオブジェクト生成時にデータファイルを指定する
- FileResponseのコンストラクタ第二引数をtrueにすると、リクエスト処理終了時に自動でファイルを削除
- Content-Type、Content-Dispositionを設定

**実装例**:
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

## アップロードファイルのデータを読み込む

**クラス**: `PartInfo`

**ポイント**:
- `PartInfo#getInputStream` を使用してアップロードファイルのストリームを取得
- 不正なデータが入力されている可能性があるため、:ref:`bean_validation` を使用して入力チェックを行う

**実装例**:
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

## CSVファイルのフォーマットを指定する

CSVファイルのフォーマット指定には、Java BeansクラスへのバインドとMapクラスへのバインドで2種類の方法がある。

**Java Beansクラスにバインドする場合**

**アノテーション**: `Csv`, `CsvFormat`

CSVフォーマットは予め用意されたフォーマットセット（:ref:`data_bind-csv_format_set`参照）から選択できる。

実装例:

```java
@Csv(type = Csv.CsvType.DEFAULT, properties = {"age", "name"}, headers = {"年齢", "氏名"})
public class Person {
    private Integer age;
    private String name;

    // getter、setter省略
}
```

フォーマットセットで対応できない場合、`CsvFormat`で個別指定可能:

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
public class Person {
    private Integer age;
    private String name;

    // getter、setter省略
}
```

> **補足**: Java Beansバインド時はアノテーションでフォーマット指定するため、`ObjectMapper`生成時に`DataBindConfig`を使用したフォーマット指定はできない。

**Mapクラスにバインドする場合**

`ObjectMapper`生成時に`CsvDataBindConfig`でフォーマットを指定する。`CsvDataBindConfig#withProperties`で設定したプロパティ名がMapのキーとして使用される。ヘッダ行が存在する場合、プロパティ名の設定を省略するとヘッダタイトルがキーとなる。

実装例（ヘッダタイトル、プロパティ名はCSVの項目順と一致させる）:

```java
DataBindConfig config = CsvDataBindConfig.DEFAULT.withHeaderTitles("年齢", "名前")
                                                 .withProperties("age", "name");
ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, outputStream, config);
```

## 固定長ファイルのフォーマットを指定する

固定長ファイルのフォーマット指定には、Java BeansクラスへのバインドとMapクラスへのバインドで2種類の方法がある。

**Java Beansクラスにバインドする場合**

**アノテーション**: `FixedLength`, `Field`

各フィールドに対し、パディングやトリム等の変換コンバータを指定可能。標準コンバータは`converter`パッケージ配下を参照。

実装例:

```java
@FixedLength(length = 19, charset = "MS932", lineSeparator = "\r\n")
public class Person {

    @Field(offset = 1, length = 3)
    @Lpad
    private Integer age;

    @Field(offset = 4, length = 16)
    @Rpad
    private String name;

    // getter、setter省略
}
```

未使用領域がある場合、書き込み時に`fillChar`設定文字で自動パディングされる（デフォルトは半角スペース）:

```java
@FixedLength(length = 24, charset = "MS932", lineSeparator = "\r\n", fillChar = '0')
public class Person {

    @Field(offset = 1, length = 3)
    @Lpad
    private Integer age;

    @Field(offset = 9, length = 16)
    @Rpad
    private String name;

    // getter、setter省略
}
```

**Mapクラスにバインドする場合**

`ObjectMapper`生成時に`FixedLengthDataBindConfig`でフォーマットを指定する。`FixedLengthDataBindConfigBuilder`を使用して生成する。

実装例:

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

複数フォーマットを持つ固定長ファイルのフォーマット指定には、Java BeansクラスへのバインドとMapクラスへのバインドで2種類の方法がある。

**Java Beansクラスにバインドする場合**

フォーマットごとにJavaBeansクラスを定義し、それらをプロパティとして持つ`MultiLayout`継承クラスを作成する。

実装要件:
- フォーマットごとにJava Beansクラスを定義
- `MultiLayout`継承クラスに上記Beansをプロパティとして保持
- MultiLayout継承クラスに`FixedLength`アノテーション設定し、`multiLayout`属性を`true`に設定
- `MultiLayout#getRecordIdentifier`メソッドをオーバーライドして、データとフォーマットの紐付けを識別する`RecordIdentifier`実装を返却

実装例:

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

    // getter、setter省略
}

public class Header {

    @Field(offset = 1, length = 1)
    private Long id;

    @Rpad
    @Field(offset = 2, length = 19)
    private String field;

    // getter、setter省略
}

public class Data {

    @Field(offset = 1, length = 1)
    private Long id;

    @Lpad
    @Field(offset = 2, length = 3)
    private Long age;

    @Rpad
    @Field(offset = 5, length = 16)
    private String name;

    // getter、setter省略
}

enum RecordType implements MultiLayoutConfig.RecordName {
    HEADER {
        @Override
        public String getRecordName() {
            return "header";
        }
    },
    DATA {
        @Override
        public String getRecordName() {
            return "data";
        }
    }
}
```

読み込み/書き込み例:

```java
// 読み込み
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, inputStream)) {
    final Person person = mapper.read();
    if (RecordType.HEADER == person.getRecordName()) {
        final Header header = person.getHeader();

        // 後続処理省略
    }
}

// 書き込み
try (ObjectMapper<Person> mapper = ObjectMapperFactory.create(Person.class, outputStream)) {
    final Person person = new Person();
    person.setHeader(new Header("1", "test"));
    mapper.write(person);
}
```

**Mapクラスにバインドする場合**

`multiLayout()`メソッドを呼び出してマルチレイアウト用のDataBindConfigを生成する。`recordIdentifier()`メソッドには、データとフォーマットの紐付けを識別する`RecordIdentifier`実装を指定する。

実装例:

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

読み込み/書き込み例:

```java
// 読み込み
try (ObjectMapper<Map> mapper = ObjectMapperFactory.create(Map.class, inputStream, config)) {
    final Map<String, ?> map = mapper.read();
    if (RecordType.HEADER == map.get("recordName")) {
        final Map<String, ?> header = map.get("header");

        // 後続処理省略
    }
}

// 書き込み
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

データ出力時に:ref:`format`を使用することで、日付や数値などのデータの表示形式をフォーマットできる。詳細は:ref:`format`を参照。

## 拡張例

**Java Beansクラスにバインドできるファイル形式を追加する**

新しいファイル形式を追加する手順:

1. `ObjectMapper`の実装クラスを作成し、指定形式のファイルとJava Beansクラスをバインドする
2. `ObjectMapperFactory`を継承したクラスを作成し、上記`ObjectMapper`実装を生成する処理を追加
3. `ObjectMapperFactory`継承クラスをコンポーネント設定ファイルに設定（コンポーネント名は`objectMapperFactory`とすること）

コンポーネント設定例:

```xml
<component name="objectMapperFactory" class="sample.SampleObjectMapperFactory" />
```

## CSVファイルのフォーマットとして指定できるフォーマットセット

**フォーマットセット一覧**:

| 項目 | DEFAULT | RFC4180 | EXCEL | TSV |
|---|---|---|---|---|
| 列区切り | カンマ(,) | カンマ(,) | カンマ(,) | タブ(\t) |
| 行区切り | 改行(\r\n) | 改行(\r\n) | 改行(\r\n) | 改行(\r\n) |
| フィールド囲み文字 | ダブルクォート(") | ダブルクォート(") | ダブルクォート(") | ダブルクォート(") |
| 空行を無視 | true | false | false | false |
| ヘッダ行あり | true | false | false | false |
| 文字コード | UTF-8 | UTF-8 | UTF-8 | UTF-8 |
| クォートモード | NORMAL | NORMAL | NORMAL | NORMAL |

**クォートモード**

CSVファイル書き込み時にフィールド囲み文字で囲む対象を指定するモード。

| クォートモード名 | 囲む対象のフィールド |
|---|---|
| NORMAL | フィールド囲み文字、列区切り文字、改行のいずれかを含むフィールド |
| ALL | 全てのフィールド |

> **補足**: CSVファイル読み込み時はクォートモードを使用せず、自動的にフィールド囲み文字の有無を判定する。

> **重要**: `ObjectMapper` の読み込み・書き込みはスレッドアンセーフ。複数スレッドで同一インスタンスを共有する場合は呼び出し元で同期処理が必要。
