# 汎用データフォーマット

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_io/data_format.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Map.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/datatype/JsonNumber.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/datatype/JsonBoolean.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/datatype/DataType.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/io/FileRecordWriterHolder.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/download/DataRecordResponse.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpRequest.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/util/FilePathSetting.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/FormatterFactory.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/DataRecordFormatter.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/java/io/InputStream.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/upload/util/UploadHelper.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/XmlDataParser.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/CharacterReplacementManager.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/CharacterReplacementConfig.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/FixedLengthConvertorFactory.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/VariableLengthConvertorFactory.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/JsonDataConvertorFactory.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/XmlDataConvertorFactory.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/FixedLengthConvertorSetting.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/VariableLengthConvertorSetting.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/JsonDataConvertorSetting.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/XmlDataConvertorSetting.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/XmlDataBuilder.html)

## 機能概要

標準でサポートするフォーマット: 固定長、可変長（CSV/TSVなど）、JSON、XML。固定長・可変長はマルチレイアウトデータ（レコード毎に異なるレイアウト）に対応。

> **重要**: 本機能には以下のデメリットがあるため、**やむを得ない場合を除き非推奨**。代替機能を使用すること。
>
> - [フォーマット定義ファイル](#s3) が複雑
> - 入出力が `Map` に限定されており実装誤りを起こしやすい
>   - フィールド名を文字列指定のためIDEの補完が使えない
>   - Mapから取り出した値のダウンキャストが必要（誤ると、実行時に例外が送出される）
> - `BeanUtil` を使用していないため他の機能とマッピング方法が異なる
> - フォーマットによってMapの扱い方が異なるため、同一データを複数フォーマットで出力すると正常動作しないケースがある（例：XMLとJSONで必須項目にnullを指定した場合、XMLは空文字出力、JSONは必須例外送出）
> - `JsonNumber` や `JsonBoolean` 使用時、出力データ型が対応していない場合に不正なJSONが出力される（例：数値型指定で文字列"data"を出力すると `{"number":data}` のような不正JSON）
> - `DataType` の実装クラスがデータ形式毎に異なるため拡張しづらく、設定誤りは実行時まで検知できない
>
> 代替機能:
> - 固定長・可変長: [data_bind](libraries-data_bind.md) を使用すること
> - XML: `JAXB` を推奨
> - JSON: OSSを推奨（例: [Jackson(外部サイト、英語)](https://github.com/FasterXML/jackson)）
>
> 例外: [messaging](../../processing-pattern/db-messaging/db-messaging-messaging.md) は内部で本機能を使用しているため代替機能を使用できない。

文字セット・文字種: UTF-8、Shift_JIS、EBCDICなどJVMがサポートする文字セットに対応。パック数値・ゾーン10進数形式にも対応。

パディング・トリミング: スペースおよびゼロパディング・トリミングに対応。アプリケーション側での処理不要。詳細は [data_format-field_convertor_list](libraries-format_definition.md) 参照。

JSONやXMLの階層構造データをMapで読み書きする際のキー形式。

> **注意**: JSONの場合には、`file-type` を `JSON` に読み替えること。

- 階層構造のMapキーは「親要素名 + `.` + 子要素名」形式（ドット区切り）
- 階層が深い場合はさらに `.` で連結
- 最上位要素名はキーに含めない
- 配列要素は添字（0から開始）を付与: `user[0].name`

> **重要**: 親要素が任意で、親要素が存在する場合のみ子要素を必須とする設定は非対応。階層構造のデータはすべて任意項目として定義することを推奨。

**フォーマット定義ファイル例（XML）**:
```xml
file-type:        "XML"
text-encoding:    "UTF-8"

[users]
1 user    [0..*] OB

[user]
1 name    [0..1] N
2 age     [0..1] X9
3 address [0..1] N
```

**Mapの構造例**:
```java
Map<String, Object> data = new HashMap<String, Object>();
data.put("user[0].name", "なまえ1");
data.put("user[0].address", "住所1");
data.put("user[0].age", 30);
data.put("user[1].name", "なまえ2");
data.put("user[1].address", "住所2");
data.put("user[1].age", 31);
```

**XML出力例**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<users>
  <user>
    <name>なまえ1</name>
    <address>住所1</address>
    <age>30</age>
  </user>
  <user>
    <name>なまえ2</name>
    <address>住所2</address>
    <age>31</age>
  </user>
</users>
```

**JSON出力例**:
```json
{
  "user": [
    {"name": "なまえ1", "address": "住所1", "age": 30},
    {"name": "ななえ2", "address": "住所2", "age": 31}
  ]
}
```

## フィールドタイプを追加する

[Nablarchが提供する標準データタイプ](libraries-format_definition.md) では要件を満たせない場合（例：文字列タイプのパディング文字がバイナリの場合）は、プロジェクト固有のフィールドタイプを定義する。

手順:
1. `DataType` 実装クラスを作成する
2. フォーマットに応じたファクトリの継承クラスを作成して追加フィールドタイプを登録する
3. 作成したファクトリクラスをフォーマットに応じた設定クラスのプロパティに設定する

> **補足**: 標準フィールドタイプ実装は `nablarch.core.dataformat.convertor.datatype` パッケージ配下にある。実装追加時の参考にすること。

フォーマット別ファクトリクラス:

| フォーマット | ファクトリクラス |
|---|---|
| Fixed(固定長) | `FixedLengthConvertorFactory` |
| Variable(可変長) | `VariableLengthConvertorFactory` |
| JSON | `JsonDataConvertorFactory` |
| XML | `XmlDataConvertorFactory` |

Fixed(固定長)のファクトリ継承クラス実装例:

```java
public class CustomFixedLengthConvertorFactory extends FixedLengthConvertorFactory {
    @Override
    protected Map<String, Class<?>> getDefaultConvertorTable() {
        final Map<String, Class<?>> defaultConvertorTable = new CaseInsensitiveMap<Class<?>>(
                new ConcurrentHashMap<String, Class<?>>(super.getDefaultConvertorTable()));
        defaultConvertorTable.put("custom", CustomType.class);
        return Collections.unmodifiableMap(defaultConvertorTable);
    }
}
```

フォーマット別設定クラスとプロパティ:

| フォーマット | 設定クラス名(コンポーネント名) | プロパティ名 |
|---|---|---|
| Fixed(固定長) | `FixedLengthConvertorSetting` (fixedLengthConvertorSetting) | fixedLengthConvertorFactory |
| Variable(可変長) | `VariableLengthConvertorSetting` (variableLengthConvertorSetting) | variableLengthConvertorFactory |
| JSON | `JsonDataConvertorSetting` (jsonDataConvertorSetting) | jsonDataConvertorFactory |
| XML | `XmlDataConvertorSetting` (xmlDataConvertorSetting) | xmlDataConvertorFactory |

Fixed(固定長)の設定例:

```xml
<component name="fixedLengthConvertorSetting"
    class="nablarch.core.dataformat.convertor.FixedLengthConvertorSetting">
  <property name="fixedLengthConvertorFactory">
    <component class="com.sample.CustomFixedLengthConvertorFactory" />
  </property>
</component>
```

> **重要**: 設定クラスの `convertorTable` プロパティを使ったフィールドタイプ追加は推奨しない。理由: (1) 追加したいフィールドタイプだけでなくデフォルトで定義されたフィールドタイプも全て設定する必要があり、バージョンアップ時にデフォルトが変更されても自動適用されず手動修正が必要になる (2) デフォルト定義はファクトリクラスのソースコードに実装されており、コンポーネント設定ファイルへの転記時に設定ミスを起こしやすい。

<details>
<summary>keywords</summary>

汎用データフォーマット, 固定長, 可変長, JSON, XML, マルチレイアウト, 非推奨, BeanUtil, data_bind, JsonNumber, JsonBoolean, DataType, JAXB, JSON階層構造, XML階層構造, Mapキー形式, ドット区切り, 配列要素添字, フィールドタイプ追加, カスタムデータタイプ, FixedLengthConvertorFactory, VariableLengthConvertorFactory, JsonDataConvertorFactory, XmlDataConvertorFactory, FixedLengthConvertorSetting, VariableLengthConvertorSetting, JsonDataConvertorSetting, XmlDataConvertorSetting, コンバータファクトリ拡張, convertorTable非推奨

</details>

## モジュール一覧

**モジュール**:
```xml
<!-- 汎用データフォーマット -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-dataformat</artifactId>
</dependency>
```

[アップロードヘルパー](#s6) または [ファイルダウンロード](#s4) を使用する場合は以下を追加:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-extension</artifactId>
</dependency>
```

> **重要**: XML入力時にDTDはデフォルトで使用不可。DTD付きXMLを読み込もうとすると例外が発生する（[XML外部実体参照(XXE)](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing)防止のための措置）。信頼できるXMLの場合のみ `allowDTD` プロパティでDTD使用を許可できる。許可する場合は信頼できるXML以外には使用してはならない。

**クラス**: `nablarch.core.dataformat.XmlDataParser`

`XmlDataParser` という名前で明示的にコンポーネント設定ファイルに設定する:

```xml
<component name="XmlDataParser" class="nablarch.core.dataformat.XmlDataParser">
  <!--
      DTDの使用を許可する。
      XXE攻撃の危険性があるため、信頼できるXML以外には使用してはならない。
   -->
  <property name="allowDTD" value="true" />
</component>
```

> **補足**: 以下のJDKバージョンには不具合があり、本機能使用時に `NullPointerException` が発生する。JDKをバージョンアップして回避すること。
> - JDK6 6u65 未満
> - JDK7 7u6 b15 未満
>
> 不具合詳細: [JDK-7157610](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=7157610)

## XMLで属性を持つ要素のコンテンツ名を変更する

属性を持つ要素のコンテンツ名を変更するには、`XmlDataParser` と `XmlDataBuilder` をコンポーネント設定ファイルに設定し、`contentName` プロパティに変更後のコンテンツ名を設定する。

- `XmlDataParser` のコンポーネント名は `XmlDataParser` とすること
- `XmlDataBuilder` のコンポーネント名は `XmlDataBuilder` とすること

```xml
<component name="XmlDataParser" class="nablarch.core.dataformat.XmlDataParser">
  <property name="contentName" value="change" />
</component>

<component name="XmlDataBuilder" class="nablarch.core.dataformat.XmlDataBuilder">
  <property name="contentName" value="change" />
</component>
```

<details>
<summary>keywords</summary>

nablarch-core-dataformat, nablarch-fw-web-extension, モジュール依存関係, XmlDataParser, allowDTD, DTD使用許可, XXE防止, NullPointerException, XmlDataBuilder, XMLコンテンツ名変更, contentName, XML属性要素

</details>

## 入出力データのフォーマットを定義する

入出力対象データのフォーマット定義はフォーマット定義ファイル（テキスト形式）に記述する。詳細仕様は [data_format/format_definition](libraries-format_definition.md) 参照。

```bash
file-type:        "Variable" # 可変長
text-encoding:    "MS932"    # 文字列型フィールドの文字エンコーディング
record-separator: "\r\n"     # 改行コード(crlf)
field-separator:  ","        # csv

[Classifier]
1 dataKbn X
3 type    X

[parentData]
dataKbn = "1"
type    = "01"
1 dataKbn X
2 ?filler X
3 type    X
4 data    X

[childData]
dataKbn = "1"
type    = "02"
1 dataKbn X
2 ?filler X
3 type    X
4 data    X
```

フォーマット定義ファイルで名前空間を定義することで、XMLの名前空間に対応できる。

- 名前空間は `?@xmlns:{名前空間}` として定義（タイプ: `X`、フィールドコンバータ部にURI指定）
- 要素名は「名前空間:要素名」形式
- MapのキーはXML要素の「名前空間＋要素名（先頭大文字）」形式

**フォーマット定義ファイル例**:
```
file-type:        "XML"
text-encoding:    "UTF-8"

[testns:data]
1 ?@xmlns:testns X "http://testns.hoge.jp/apply"
2 testns:key1 X
```

**XMLデータ例**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<testns:data xmlns:testns="http://testns.hoge.jp/apply">
  <testns:key1>value1</testns:key1>
</testns:data>
```

**Mapデータ例**:
```java
Map<String, Object> data = new HashMap<String, Object>();
data.put("testnsKey1", "value1");
```

<details>
<summary>keywords</summary>

フォーマット定義ファイル, file-type, text-encoding, record-separator, field-separator, マルチレイアウト定義, Classifier, XML名前空間, xmlns, 名前空間定義, ?@xmlns

</details>

## ファイルにデータを出力する

`FileRecordWriterHolder` を使用してファイルにデータを出力する。

- 書き込みデータは `Map` として準備する
- Mapのキー値はフォーマット定義ファイルのフィールド名（大文字/小文字区別なし）
- `open` メソッドでファイルリソースを開き、`write` メソッドでデータを書き込む

```java
Map<String, Object> user = new HashMap<>();
user.put("name", "名前");
user.put("age", 20);
FileRecordWriterHolder.open("users.csv", "user_csv_format");
FileRecordWriterHolder.write(user, "user.csv");
```

> **補足**: `FileRecordWriterHolder` を使用するには、フォーマット定義ファイルの配置ディレクトリと出力先ディレクトリを [file_path_management](libraries-file_path_management.md) に設定する必要がある。

> **重要**: `FileRecordWriterHolder` で開いたファイルリソースは [file_record_writer_dispose_handler](../handlers/handlers-file_record_writer_dispose_handler.md) で自動解放される。必ずハンドラキュー上に [file_record_writer_dispose_handler](../handlers/handlers-file_record_writer_dispose_handler.md) を設定すること。

> **重要**: 出力データに不正な値が設定されていた場合に正しく処理できない可能性があるため、事前にアプリケーション側で入力値をチェックすること。

> **重要**: デフォルトでは1レコード毎にファイルへの書き込みを行う。大量データ出力時に性能要件を満たせない場合は、以下のコンポーネント定義を追加し、`open` メソッドのバッファサイズ引数で出力バッファサイズを指定すること。

```xml
<!-- コンポーネント名はdataFormatConfigとする -->
<component name="dataFormatConfig" class="nablarch.core.dataformat.DataFormatConfig">
  <property name="flushEachRecordInWriting" value="false" />
</component>
```

XMLで属性を持つ要素にコンテンツを定義する場合、フォーマット定義ファイルにコンテンツフィールドを定義する。

- コンテンツフィールド名はデフォルトで `body`
- デフォルト名変更は [data_format-xml_content_name_change](#) を参照

**フォーマット定義ファイル例**:
```
file-type:        "XML"
text-encoding:    "UTF-8"

[parent]
1 child   OB

[child]
1 @attr   X
2 body    X
```

**XMLデータ例**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<parent>
  <child attr="value1">value2</child>
</parent>
```

**Mapデータ例**:
```java
Map<String, Object> data = new HashMap<String, Object>();
data.put("child.attr", "value1");
data.put("child.body", "value2");
```

<details>
<summary>keywords</summary>

FileRecordWriterHolder, ファイル出力, file_record_writer_dispose_handler, DataFormatConfig, flushEachRecordInWriting, バッファサイズ, XML属性コンテンツ, bodyフィールド, data_format-xml_content_name_change

</details>

## ファイルダウンロードで使用する

`DataRecordResponse` を使用してファイルダウンロード形式でレスポンスを返す。

- `DataRecordResponse` 生成時にフォーマット定義ファイルの論理パス名とファイル名を指定する
- `DataRecordResponse#write` でデータを出力（複数レコードは繰り返し呼び出し）
- `Content-Type` および `Content-Disposition` を設定して返却する

```java
public HttpResponse download(HttpRequest request, ExecutionContext context) {
    Map<String, Object> user = new HashMap<>();
    user.put("name", "なまえ");
    user.put("age", 30);
    DataRecordResponse response = new DataRecordResponse("format", "users_csv");
    response.write(user);
    response.setContentType("text/csv; charset=Shift_JIS");
    response.setContentDisposition("メッセージ一覧.csv");
    return response;
}
```

> **補足**: フォーマット定義ファイルの格納パスは [file_path_management](libraries-file_path_management.md) に設定する必要がある。

外部データ読み込み時にシステムで使用可能な文字に置き換える機能（寄せ字）。

**制約**:
- 置き換え前・後ともに1文字のみ
- サロゲートペアは非対応

**設定手順**:

1. propertiesファイルに置き換えルールを「置き換え前=置き換え後」形式で定義:
```properties
髙=高
﨑=崎
唖=■
```

2. `CharacterReplacementManager` をコンポーネント名 `characterReplacementManager` で設定。`configList` プロパティに `CharacterReplacementConfig` をリスト形式で設定:

```xml
<component name="characterReplacementManager"
    class="nablarch.core.dataformat.CharacterReplacementManager">
  <property name="configList">
    <list>
      <component class="nablarch.core.dataformat.CharacterReplacementConfig">
        <property name="typeName" value="a_system"/>
        <property name="filePath" value="classpath:a-system.properties"/>
        <property name="encoding" value="UTF-8"/>
      </component>
      <component class="nablarch.core.dataformat.CharacterReplacementConfig">
        <property name="typeName" value="b_system"/>
        <property name="filePath" value="classpath:b-system.properties"/>
        <property name="encoding" value="UTF-8"/>
      </component>
    </list>
  </property>
</component>
```

| プロパティ名 | 型 | 説明 |
|---|---|---|
| `typeName` | String | 置き換えルールの識別名（複数ファイル使用時に区別） |
| filePath | String | propertiesファイルのパス（例: classpath:a-system.properties） |
| encoding | String | ファイルのエンコーディング |

3. `characterReplacementManager` を初期化対象リストに追加:
```xml
<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="characterReplacementManager" />
    </list>
  </property>
</component>
```

4. フォーマット定義ファイルで :ref:`replacement <data_format-replacement_convertor>` を使用（引数に `typeName` を指定）:
```
1 name N(100) replacement("a_system")
```

> **補足**: 接続先ごとに置き換えルールを定義する場合は、複数のpropertiesファイルを作成し、それぞれ異なる `typeName` を設定する。

<details>
<summary>keywords</summary>

DataRecordResponse, ファイルダウンロード, Content-Type, Content-Disposition, 寄せ字, 文字置き換え, CharacterReplacementManager, CharacterReplacementConfig, typeName, filePath, encoding, replacement

</details>

## アップロードしたファイルを読み込む

アップロードファイルの読み込みには2種類の方法があるが、**汎用データフォーマット（本機能）のみを使った方法を推奨**する。

### 汎用データフォーマットのみを使った読み込み（推奨）

- `HttpRequest#getPart` でアップロードファイルを取得（引数はパラメータ名）
- `FilePathSetting` からフォーマット定義ファイルの `File` オブジェクトを取得
- `FormatterFactory` から `DataRecordFormatter` を生成
- フォーマッタに設定する `InputStream` は `mark`/`reset` サポートが必要（`BufferedInputStream` でラップする）

```java
public HttpResponse upload(HttpRequest req, ExecutionContext ctx) {
    final List<PartInfo> partInfoList = request.getPart("users");
    final File format = FilePathSetting.getInstance().getFile("format", "users-layout");
    try (final DataRecordFormatter formatter = FormatterFactory.getInstance().createFormatter(format)) {
        formatter.setInputStream(new BufferedInputStream(partInfoList.get(0).getInputStream())).initialize();
        while (formatter.hasNext()) {
            final DataRecord record = formatter.readRecord();
            final Users users = BeanUtil.createAndCopy(Users.class, record);
        }
    } catch (IOException e) {
        throw new RuntimeException(e);
    }
}
```

### アップロードヘルパーを使った読み込み（非推奨）

`UploadHelper` を使用するとファイル読み込み・バリデーション・DB保存を簡易的に実行できるが、以下の制限があるため非推奨:

- 入力値チェックが [nablarch_validation](libraries-nablarch_validation.md) に限定される（推奨される [bean_validation](libraries-bean_validation.md) が使用できない）
- 拡張難易度が高い

```java
PartInfo partInfo = req.getPart("fileToSave").get(0);
UploadHelper helper = new UploadHelper(partInfo);
int cnt = helper
    .applyFormat("N11AC002")
    .setUpMessageIdOnError("format.error", "validation.error", "file.empty.error")
    .validateWith(UserInfoTempEntity.class, "validateRegister")
    .importWith(this, "INSERT_SQL");
```

データ出力時に :ref:`format` を使用することで日付や数値などの表示形式をフォーマットできる。詳細は :ref:`format` を参照。

<details>
<summary>keywords</summary>

UploadHelper, DataRecordFormatter, FormatterFactory, FilePathSetting, アップロードファイル読み込み, BufferedInputStream, PartInfo, DataRecord, BulkValidator, BulkValidationResult, 出力フォーマット, 日付フォーマット, 数値フォーマット, format

</details>
