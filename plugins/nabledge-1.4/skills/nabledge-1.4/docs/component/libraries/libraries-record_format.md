# 汎用データフォーマット機能

## 

固定長、可変長データおよびXML/JSON形式をサポートする汎用入出力ライブラリ。システム間通信、バッチ処理のデータファイル読み書き、ファイルアップロード処理など様々な場面で使用される。

**主な特徴**:
- 固定長、可変長データおよびXML/JSON形式をサポート
- マルチレイアウト対応
- EBCDIC対応、パックおよびゾーン10進数形式をサポート（ホスト環境での利用を想定）
- 形式精査、パディング/トリミングといった精査・変換処理を実行
- カスタムのデータ形式や変換処理を追加・拡張可能

## フォーマット定義ファイルの書式

フォーマット定義ファイルは以下の2つの部分で構成される:
1. **ディレクティブ宣言部**: データ形式（固定長/可変長/XML/JSON）、エンコーディングなどの共通設定
2. **レコードフォーマット定義部**: 各フィールドの開始位置、データ型、変換処理。マルチフォーマット形式では複数レコードフォーマットを定義し条件で動的切り替え可能

**行末コメント**: `#` から行末までの文字列はコメントとして扱われる。任意の行で使用可能。

**文字コード**: デフォルトはUTF-8。他の文字コードを使用する場合は**フォーマッターファクトリ**に設定を追加すること。

**リテラル表記**:

| リテラル型 | 例 | 備考 |
|---|---|---|
| 文字列 | `"Nablarch"`, `"\\r\\n"` | Javaの文字リテラルと同じ仕様。`\\Uxxxx` のUnicodeエスケープは非サポート |
| 10進整数 | `0`, `123`, `-456`, `+78` | 小数は不可 |
| 真偽値 | `true`, `false`, `TRUE`, `FALSE` | |

**任意識別子**: レコードタイプ名・フィールド名等には以下の正規表現に合致する文字列を使用する（ASCIIでのJava識別子定義と同じ）:
```
/[a-zA-Z_$][a-zA-Z0-9_$]*/
```

### ディレクティブ宣言部

書式: `[ディレクティブ名] : [ディレクティブ値(リテラル)]`

**共通ディレクティブ**:

| ディレクティブ名 | 内容 |
|---|---|
| `file-type` | データ形式。`"Fixed"`(固定長)、`"Variable"`(可変長)、`"JSON"`、`"XML"` のいずれかを指定。**必須** |
| `text-encoding` | 文字列フィールドの読み書きエンコーディング。JDKで利用可能なエンコーディング名（`"UTF-8"`, `"SJIS"`, `"MS932"` など）。**必須**。JSONの場合はUTF-8/UTF-16(BE or LE)/UTF-32(BE or LE)のみ対応（その他はエラー）。XMLの読み込み時はXML宣言部のエンコーディングが優先 |
| `record-separator` | レコード終端文字列。可変長では**必須**（レコード終端判断用）。固定長では各レコード直後に付加する文字列として扱う。XML/JSONでは不使用。バイト長は`record-length`に含まれない |

**固定長データ形式でのみ指定可能なディレクティブ**:

| ディレクティブ名 | 内容 |
|---|---|
| `record-length` | 1レコードのバイト長。**必須** |
| `positive-zone-sign-nibble` / `negative-zone-sign-nibble` | 符号付きゾーン数値の符号Nibble値。デフォルト: ASCII互換（UTF-8/SJISなど）は正=0x3/負=0x7、EBCDIC互換は正=0xC/負=0xD |
| `positive-pack-sign-nibble` / `negative-pack-sign-nibble` | 符号付きパック数値の符号Nibble値。デフォルト: ASCII互換は正=0x3/負=0x7、EBCDIC互換は正=0xC/負=0xD |
| `required-decimal-point` | 符号なし/符号付き数値の小数点の要否。`true`で書き込みデータに小数点付与。デフォルト: `true` |
| `fixed-sign-position` | 符号位置の固定/非固定。`true`で符号はフィールド左端に固定、`false`で符号は数値直前に付与。デフォルト: `true` |
| `required-plus-sign` | 正の符号の要否。`true`で読み込みデータに正の符号がなければエラー、書き込みデータに正の符号を出力。デフォルト: `false` |

**可変長データ形式でのみ指定可能なディレクティブ**:

| ディレクティブ名 | 内容 |
|---|---|
| `field-separator` | フィールドの区切り文字。**必須** |
| `quoting-delimiter` | フィールド値クォート文字。デフォルト: ダブルクォート(`"`) |
| `ignore-blank-lines` | 空行を無視するか。`true`で空行の読み込みをスキップ。デフォルト: `true` |
| `requires-title` | 最初の行をタイトルとして読み書きするか。`true`でレコードタイプ名`[Title]`で読み書き可能。デフォルト: `false` |
| `max-record-length` | 1行の許容文字数。デフォルト: `1000000` |
| `title-record-type-name` | タイトルのレコードタイプ名。デフォルト: `[Title]` |

JSONおよびXMLデータ形式専用のディレクティブは存在しない。

### レコードフォーマット定義部

書式（シングルフォーマット）:
```
[レコードタイプ名]
[フィールド定義]
...
```

フィールド定義の書式:
```
[フィールド開始位置] [フィールド名] [フィールドタイプ定義] ([フィールドコンバータ定義]...)
```

| 要素名 | 必須 | 内容 |
|---|---|---|
| フィールド開始位置 | ○ | 固定長: 開始バイト数(1起算)、可変長: カラム通番、JSON/XML: 要素通番 |
| フィールド名 | ○ | Mapのキーとなる任意識別子。先頭に`?`を付与するとFILLER項目（入力時にMapに格納されない）。数字のみのフィールド名は不可（実行時に例外発生）。XMLの場合、先頭に`@`を付与で属性項目として入出力 |
| 多重度 | △(階層構造) | JSON/XMLなど階層構造データ形式の場合に出現回数を指定。`[]`が付与されていない項目は`[1]`を指定されたものと見なして出現回数は1回に限定される。`[2]`=2回固定、`[*]`=出現回数に条件なし（`[0..*]`と同義）、`[1..3]`=1〜3回、`[1..*]`=1回以上、`[0..*]`=出現回数に条件なし |
| フィールドタイプ定義 | ○ | フィールドのデータ型定義。詳細は [types_and_converters](#) 参照 |
| フィールドコンバータ定義 | - | 入出力の事前処理（トリム・パディング、デフォルト値等）。複数指定可。詳細は [types_and_converters](#) 参照 |

> **注意**: レコードタイプ名は1つのフォーマット定義ファイル内で一意であること。重複は不可。

記述例（固定長）:
```
file-type:     "Fixed"
text-encoding: "ms932"
record-length:  120

[Default]
1    dataKbn       X(1)  "2"
2    FIcode        X(4)
6    FIname        X(15)
39  ?tegataNum     X(4)  "9999"
114 ?unused        X(7)  pad("0")
```

## マルチフォーマット形式の利用

ヘッダーレコードとデータレコードでフォーマットが異なるデータ形式では、マルチフォーマット形式でフォーマット定義を記述する必要がある。定義ファイル上に複数のレコードフォーマットを定義し、特定のフィールドの値に応じてフォーマットを動的に切り替える。

### レコードタイプ識別フィールド（Classifier）

レコードタイプ識別フィールドは、レコード中の特定のフィールドの内容をもとに使用するフォーマットを決定する。

**記法**: レコードタイプ名を `Classifier` とする点を除き、通常のレコードフォーマット定義と同じ。

```bash
[Classifier]
1   dataKbn   X(1)   # データ区分
                     # 1: ヘッダー、2: データレコード
                     # 8: トレーラー、9: エンドレコード
```

各レコードフォーマット定義では、レコードタイプ名の直後にレコードタイプ識別フィールドの**適用条件**を記述する（例: `dataKbn = "1"`）。

```bash
[header]
dataKbn = "1"  # フォーマットの適用条件（dataKbnが"1"の場合このフォーマットを使用）
1   dataKbn     X(1)  "1"
2   sysDate     X(8)
10  ?filler     X(411)
```

なお、レコードタイプ識別フィールド定義の内容と実際のレコード定義の内容は、必ずしも一致させる必要はない。

### フォーマット定義例（固定長マルチフォーマット）

```bash
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    420
record-separator: "\r\n"

[Classifier]
1   dataKbn   X(1)

[header]
dataKbn = "1"
1   dataKbn     X(1)  "1"
2   sysDate     X(8)
10  ?filler     X(411)

[data]
dataKbn = "2"
1   dataKbn                     X(1)  "2"
2   userId                      X(10)
12  loginId                     X(20)
32  kanjiName                   N(100)
132 kanaName                    N(100)
232 ?filler1                    X(50)
282 mailAddress                 X(100)
382 extensionNumberBuilding     X(2)
384 extensionNumberPersonal     X(4)
388 mobilePhoneNumberAreaCode   X(3)
391 mobilePhoneNumberCityCode   X(4)
395 mobilePhoneNumberSbscrCode  X(4)
399 ?filler2                    X(22)

[trailer]
dataKbn = "8"
1   dataKbn                     X(1)  "8"
2   totalCount                  Z(19)
21  ?filler                     X(400)

[end]
dataKbn = "9"
1   dataKbn                     X(1)  "9"
2   ?filler                     X(419)
```

## フィールドコンバータ（文字列置換）の設定

**クラス**: `nablarch.core.dataformat.CharacterReplacementManager`, `nablarch.core.dataformat.CharacterReplacementConfig`

初期化コンポーネント（`BasicApplicationInitializer`）の`initializeList`に`characterReplacementManager`を追加し、文字列置換コンポーネントを定義する。

```xml
<component name="initializer"
      class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="characterReplacementManager" />
    </list>
  </property>
</component>

<component name="characterReplacementManager"
    class="nablarch.core.dataformat.CharacterReplacementManager">
  <property name="configList">
    <list>
      <component class="nablarch.core.dataformat.CharacterReplacementConfig">
        <property name="typeName" value="sample"/>
        <property name="filePath" value="classpath:messaging/characterconvertor/input.properties"/>
        <property name="encoding" value="UTF-8"/>
        <property name="byteLengthCheck" value="false"/>
      </component>
    </list>
  </property>
</component>
```

**CharacterReplacementConfigプロパティ**:

| プロパティ名 | 説明 |
|---|---|
| typeName | 変換タイプの名称。フォーマット定義ファイルで利用する際に指定する。 |
| filePath | 変換ルールの設定ファイルのパス |
| encoding | 変換時のエンコーディング |
| byteLengthCheck | 変換前後のバイト長チェック実施有無。デフォルト: `true`（実施する） |

**変換ルール設定ファイル**: `変換前=変換後` の形式で1文字ごとに記述する。

```properties
\u9ad9=\u9ad8
\uff11=\u4e00
\uff12=\u4e8c
```

フォーマット定義ファイルでは、コンバータの引数に`typeName`で設定した変換タイプ名を渡すことで使用する変換タイプを指定する。

```
3  kanjiName  XN  replacement("sample")  #漢字氏名
```

**置換結果の取得** (`CharacterReplacementUtil`):

```java
// 直前のフォーマット変換処理における置換結果を取得
CharacterReplacementResult resultBean = CharacterReplacementUtil.getResult("kanjiName");
boolean result = resultBean.isReplacement();       // true=変換有り、false=変換無し
String inputString = resultBean.getInputString();   // 変換前の文字列
String resultString = resultBean.getResultString(); // 変換後の文字列
```

JSONおよびXMLデータ形式ではデータレコードの概念が存在しない。そのため、入出力はデータ全体を１レコードとして取り扱い、複数レコードが設定されている場合は処理対象外とする。

本機能で取り扱うMapオブジェクトの形式はバリデーション機能で取り扱うMapオブジェクトの形式と等しい。そのため、本機能で取り扱うMapオブジェクトとForm形式を相互に変換して、階層構造および繰り返しデータを容易に扱うことが可能である。

<details>
<summary>keywords</summary>

汎用データフォーマット機能, 固定長, 可変長, XML/JSON, EBCDIC, マルチレイアウト, パディング, トリミング, ファイル入出力, フォーマット定義ファイル, ディレクティブ宣言部, レコードフォーマット定義部, file-type, text-encoding, record-separator, record-length, field-separator, positive-zone-sign-nibble, negative-zone-sign-nibble, positive-pack-sign-nibble, negative-pack-sign-nibble, required-decimal-point, fixed-sign-position, required-plus-sign, quoting-delimiter, requires-title, ignore-blank-lines, max-record-length, title-record-type-name, FILLER項目, マルチフォーマット, 固定長データ形式, 可変長データ形式, マルチフォーマット形式, Classifier, レコードタイプ識別フィールド, フォーマット切り替え, 固定長マルチフォーマット, CharacterReplacementManager, CharacterReplacementConfig, CharacterReplacementUtil, CharacterReplacementResult, BasicApplicationInitializer, typeName, filePath, encoding, byteLengthCheck, isReplacement, getInputString, getResultString, フィールドコンバータ, 文字列置換, replacementコンバータ, 変換ルール設定, JSONデータ形式, XMLデータ形式, データレコード概念なし, 1レコード, 複数レコード処理対象外, Mapオブジェクト形式, Form形式相互変換, 階層構造, 繰り返しデータ

</details>

## 基本構造

本機能は以下の3要素で構成される。プログラム側ではパース/シリアライズ等の定型処理を記述する必要はなく、データソース上のレコードをMapオブジェクトとして扱うことができる。

1. **フォーマット定義ファイル**: レコード内のフィールドのレイアウト、データ型、パディング/トリミング等の事前処理定義を記述したファイル。アプリケーションプログラマが作成する。
2. **レコードフォーマッター** (`DataRecordFormatter`): フォーマット定義ファイルに沿ってデータの読み書きを行うオブジェクト。読み込んだレコードは各フィールド名をキーとするMapオブジェクトとして取得できる。Mapインターフェースを実装した任意のオブジェクトをレコードとして出力可能。
3. **レコードフォーマッターファクトリ** (`FormatterFactory`): フォーマット定義ファイルを解析しレコードフォーマッターを生成するクラス。機能を拡張する場合は、このファクトリに拡張機能を実装したクラスを設定する。

> **注意**: 別添のツールを使用することで、データファイルや電文の形式を定義した各種仕様書からフォーマット定義ファイルを生成可能。

![汎用データフォーマット機能の概念図](../../../knowledge/component/libraries/assets/libraries-record_format/dataformat_concept.png)

## フィールドタイプ・フィールドコンバータ定義一覧

### フィールドタイプ定義一覧

#### 固定長データ形式

| タイプ識別子 | Java型 | 内容 | デフォルト実装クラス |
|---|---|---|---|
| X | String | シングルバイト文字列（バイト長=文字数）。デフォルトで半角空白による右トリム・パディング。引数: バイト長（必須）。nullの場合は空文字に変換。 | `nablarch.core.dataformat.convertor.datatype.SingleByteCharacterString` |
| N | String | ダブルバイト文字列（バイト長=文字数÷2）。デフォルトで全角空白による右トリム・パディング。引数: バイト長（必須）。バイト長が2の倍数でない場合は構文エラー。nullの場合は空文字に変換。 | `nablarch.core.dataformat.convertor.datatype.DoubleByteCharacterString` |
| XN | String | マルチバイト文字列。UTF-8のようにバイト長が異なる文字が混在する場合、または全角文字列のパディングに半角スペースを使用する場合に指定。デフォルトで半角空白による右トリム・パディング。引数: バイト長（必須）。nullの場合は空文字に変換。 | `nablarch.core.dataformat.convertor.datatype.ByteStreamDataString` |
| Z | BigDecimal | ゾーン10進数値（バイト長=桁数）。デフォルトで'0'による左トリム・パディング。引数1: バイト長（必須）、引数2: 小数点以下桁数（任意、デフォルト=0）。nullの場合は0に変換。 | `nablarch.core.dataformat.convertor.datatype.ZonedDecimal` |
| SZ | BigDecimal | 符号付ゾーン10進数値（バイト長=桁数）。デフォルトで'0'による左トリム・パディング。引数1: バイト長（必須）、引数2: 小数点以下桁数（任意、デフォルト=0）、引数3: 正数時の最小桁バイトの上位4ビットパターン (16進表記の文字列[0-9A-F]、任意指定)、引数4: 負数時の最小桁バイトの上位4ビットパターン (16進表記の文字列[0-9A-F]、任意指定)。nullの場合は0に変換。 | `nablarch.core.dataformat.convertor.datatype.SignedZonedDecimal` |
| P | BigDecimal | パック10進数値（バイト長=桁数÷2 [端数切り上げ]）。デフォルトで'0'による左トリム・パディング。引数1: バイト長（必須）、引数2: 小数点以下桁数（任意、デフォルト=0）。nullの場合は0に変換。 | `nablarch.core.dataformat.convertor.datatype.PackedDecimal` |
| SP | BigDecimal | 符号付パック10進数値（バイト長=(桁数+1)÷2 [端数切り上げ]）。デフォルトで'0'による左トリム・パディング。引数1: バイト長（必須）、引数2: 小数点以下桁数（任意、デフォルト=0）、引数3: 正数時の最下位4ビットパターン (16進表記の文字列[0-9A-F]、任意指定)、引数4: 負数時の最下位4ビットパターン (16進表記の文字列[0-9A-F]、任意指定)。nullの場合は0に変換。 | `nablarch.core.dataformat.convertor.datatype.SignedPackedDecimal` |
| B | byte[] | バイナリ列。パディングは行わない。引数: バイト長（必須）。**nullの場合は変換を行わずInvalidDataFormatExceptionを送出する。本フィールドタイプを使用する場合、要件に合わせてアプリケーション側で明示的に値を設定すること。** | `nablarch.core.dataformat.convertor.datatype.Bytes` |
| X9 | BigDecimal | 符号無し数値文字列（バイト長=文字数）。デフォルトで'0'による左トリム・パディング。小数点記号（"."）を含めることができる。引数1: バイト長（必須）、引数2: フィールド中に小数点記号がない場合の小数点以下桁数（任意、デフォルト=0）。nullの場合は0に変換。 | `nablarch.core.dataformat.convertor.datatype.NumberStringDecimal` |
| SX9 | BigDecimal | 符号付き数値文字列（バイト長=文字数）。デフォルトで'0'による左トリム・パディング。引数1: バイト長（必須）、引数2: フィールド中に小数点記号がない場合の小数点以下桁数（任意、デフォルト=0）。nullの場合は0に変換。 | `nablarch.core.dataformat.convertor.datatype.NumberStringDecimal` |

#### 可変長データ形式

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| X、N、XN、X9、SX9 | String | すべてのフィールドを文字列として読み書き。タイプ識別子による動作の違いはない。フィールド長の概念がなく引数不要。Number型（BigDecimalなど）が必要な場合はnumber/signed_numberコンバータを使用すること。nullの場合は空文字に変換。 |

#### JSONおよびXMLデータ形式

いずれのタイプ識別子もフィールド長の概念がなく引数不要。

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| X、N、XN | String | 文字列。パディングなし。出力時はダブルクォートで括られる。nullの場合: JSONは変換なし、XMLは空文字に変換。 |
| X9、SX9 | String | 数字。パディングなし。値がそのまま出力される。Number型（BigDecimalなど）が必要な場合はnumber/signed_numberコンバータを使用すること。nullの場合: JSONは変換なし、XMLは空文字に変換。 |
| BL | String | 文字列（true or false）。パディングなし。値がそのまま出力される。nullの場合: JSONは変換なし、XMLは空文字に変換。 |
| OB | — | ネストオブジェクト。ネストされたレコードタイプを指定する場合に使用。nullの場合: JSONは変換なし、XMLは空文字に変換。 |

### フィールドコンバータ定義一覧

| コンバータ名 | Java型（変換前後） | 内容 | デフォルト実装クラス |
|---|---|---|---|
| pad | N/A | パディング・トリムの対象値を設定。X・N・XN: 右トリム・パディング。Z・SZ・P・SP・X9・SX9: 左トリム・パディング。B: 無効。引数: パディング・トリムの対象値（必須）。 | `nablarch.core.dataformat.convertor.value.Padding` |
| encoding | N/A | 文字エンコーディングを指定。X・N・XN以外のフィールドに設定した場合は無視される。引数: エンコーディング名（必須）。 | `nablarch.core.dataformat.convertor.value.UseEncoding` |
| リテラル値 | Object <-> Object | 入力時: なにもしない。出力時: 出力する値が未設定の場合に指定されたリテラル値を出力する。引数: なし。 | `nablarch.core.dataformat.convertor.value.DefaultValue` |
| number | String <-> BigDecimal | 入力: 符号なし数値チェック後BigDecimalに変換（null/空文字の場合はnullを返却）。出力: 文字列に変換し符号なし数値チェック後出力（nullの場合は空文字）。引数: なし。 | `nablarch.core.dataformat.convertor.value.NumberString` |
| signed_number | String <-> BigDecimal | 符号が許可される点以外はnumberコンバータと同じ仕様。引数: なし。 | `nablarch.core.dataformat.convertor.value.SignedNumberString` |
| replacement | String <-> String | 入出力とも、置換え対象文字を変換先の文字に置換して返す。引数: 置換タイプ名（任意）。詳細は [converters_sample](#) を参照すること。 | `nablarch.core.dataformat.convertor.value.CharacterReplacer` |

### データ形式ごとのデフォルト設定

| コンバータ名 | 固定長 | 可変長 | JSON | XML |
|---|---|---|---|---|
| pad | 有り | — | — | — |
| encoding | 有り | 有り | — | — |
| リテラル値 | 有り | 有り | 有り | 有り |
| number | 有り | 有り | 有り | 有り |
| signed_number | 有り | 有り | 有り | 有り |
| replacement | 有り | 有り | 有り | 有り |

## 可変長ファイルにおけるタイトル行の読み書き

`requires-title: true` をフォーマット定義ファイルに設定すると、最初の行をタイトル行として通常のレコードタイプとは別に取り扱える。最初の行はレコードタイプ名 `[Title]` で読み書きされる。

タイトル行とデータ行を識別するフィールドが存在しない場合でも、本機能を使用すればシングルフォーマット定義で読み込むことができる。最初の行がタイトル行であることが保証されるため、ファイルレイアウトの精査を省略できる。最初の行にタイトルが存在するファイルを読み込む場合は本機能を使用することを推奨する。

**制約**:
- レコードタイプ `[Title]` を必ずフォーマット定義しなければならない。
- 最初の行を書き込む際に指定するレコードタイプは `[Title]` でなければならない。
- 最初の行以降を書き込む際に指定するレコードタイプは `[Title]` 以外でなければならない。
- レコードタイプ `[Title]` にフォーマットの適用条件が定義されている場合、最初の行は必ずその適用条件を満たさなければならない。また、最初の行以降の行はその適用条件を満たしてはいけない。

**シングルフォーマット定義の例**:

```
file-type:    "Variable"
text-encoding:     "ms932"
record-separator:  "\r\n"
field-separator:   ","
quoting-delimiter: "\""
requires-title: true         # 最初の行をタイトルとして読み書きする

[Title]                      # タイトル固有のレコードタイプ
1   Name       N  "書籍名"
2   Publisher  N  "出版社"
3   Authors    N  "著者"
4   Price      N  "価格"

[Books]                      # データのレコードタイプ
1   Name       X
2   Publisher  X
3   Authors    X
4   Price      X  Number
```

**マルチフォーマット定義の例**:

```
file-type:    "Variable"
text-encoding:     "ms932"
record-separator:  "\r\n"
field-separator:   ","
quoting-delimiter: "\""
requires-title: true

[Classifier]
1  Kubun X

[Title]                      # マルチフォーマットでもフォーマットの適用条件は不要
1   Kubun      N  "データ区分"
2   Name       N  "書籍名"
3   Publisher  N  "出版社"
4   Authors    N  "著者"
5   Price      N  "価格"

[DataRecord]
  Kubun = "1"
1   Kubun      X
2   Name       N
3   Publisher  N
4   Authors    N
5   Price      N

[TrailerRecord]
  Kubun = "2"
1   Kubun      X
2   RecordNum  X
```

タイトル固有のレコードタイプ名はデフォルトでは `[Title]` だが、`title-record-type-name` ディレクティブで個別に指定することも可能。

JSONおよびXMLデータ形式では階層構造でデータが表現される。本機能で取り扱うMapオブジェクトは "." で区切られたキー名を使用して階層構造を表現し、Mapオブジェクトとしては１階層のものとする。

フィールド名に対応するレコードタイプ定義が存在する場合は、そのフィールドを階層オブジェクトとして認識し、子要素を再帰的に解析・構築する。階層の深さについて制限は無い。

**フォーマット定義ファイル例:**

```bash
#-------------------------------------------------------------------------------
# ユーザデータのJSONデータフォーマット
#-------------------------------------------------------------------------------
file-type:       "JSON"      # JSONデータ形式
text-encoding:   "UTF-8"     # ファイルエンコーディング

[UserData]                   # ユーザデータ(ルート要素)のレコードタイプ
1  header OB                 # ヘッダ項目
2  data   OB                 # データ項目

[header]                     # ヘッダ項目のレコードタイプ
1  msg_id X                  # メッセージID

[data]                       # データ項目のレコードタイプ
1  name   N                  # 氏名
2  age    X9                 # 年齢
```

**JSONデータ例:**

```json
{
  "header":{
    "msg_id":"123456"
  },
  "data":{
    "name":"nablarch",
    "age":30
  }
}
```

**XMLデータ例:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<UserData>
  <header>
    <msg_id>123456</msg_id>
  </header>
  <data>
    <name>nablarch</name>
    <age>30</age>
  </data>
</UserData>
```

**Mapオブジェクト（変換結果）:**

| キー | 値 |
|------|----|
| `"header.msg_id"` | `"123456"` |
| `"data.name"` | `"nablarch"` |
| `"data.age"` | `"30"` |

<details>
<summary>keywords</summary>

DataRecordFormatter, FormatterFactory, フォーマット定義ファイル, レコードフォーマッター, レコードフォーマッターファクトリ, Mapオブジェクト, パース, シリアライズ, フィールドタイプ, フィールドコンバータ, X, N, XN, Z, SZ, P, SP, B, SingleByteCharacterString, DoubleByteCharacterString, ByteStreamDataString, ZonedDecimal, SignedZonedDecimal, PackedDecimal, SignedPackedDecimal, Bytes, NumberStringDecimal, Padding, UseEncoding, DefaultValue, NumberString, SignedNumberString, CharacterReplacer, InvalidDataFormatException, X9, SX9, BL, OB, pad, encoding, number, signed_number, replacement, requires-title, title-record-type-name, タイトル行, 可変長ファイル, シングルフォーマット, マルチフォーマット, Titleレコードタイプ, タイトル行識別, 階層構造, ドット区切りキー, 1階層, レコードタイプ定義, 再帰的解析, 再帰的構築, 深さ制限なし

</details>

## 使用例

**フォーマット定義ファイルの例（固定長ファイル）**:
```bash
#
# ディレクティブ定義部
#
file-type:     "Fixed"  # 固定長ファイル
text-encoding: "ms932"  # 文字列型フィールドの文字エンコーディング
record-length:  120     # 各レコードbyte長

#
# データレコード定義部
#
[Default]
1    dataKbn       X(1)  "2"
2    FIcode        X(4)
6    FIname        X(15)
21   officeCode    X(3)
24   officeName    X(15)
39  ?tegataNum     X(4)  "9999"
43   syumoku       X(1)
44   accountNum    X(7)
51   recipientName X(30)
81   amount        X(10)
91   isNew         X(1)
92   ediInfo       X(20)
112  transferType  X(1)
113  withEdi       X(1)  "Y"
114 ?unused        X(7)  pad("0")
```

**レコードフォーマッターの作成**:
```java
File formatFile = new File("./test.fmt");
DataRecordFormatter formatter = FormatterFactory
                               .getInstance()
                               .createFormatter(formatFile);
```

**データの読み込み**:
```java
InputStream in = new FileInputStream("./data.dat");
formatter.setInputStream(in).initialize();
List<Map<String, Object>> records = new ArrayList<Map<String, Object>>();
while (formatter.hasNext()) {
    records.add(formatter.readRecord());
}
```

**データの書き込み**:
```java
OutputStream out = new FileOutputStream("./data.dat");
formatter.setOutputStream(out).initialize();
formatter.writeRecord(new HashMap() {{
    put("FIcode",     "9999");
    put("FIname",     "ﾅﾌﾞﾗｰｸｷﾞﾝｺｳ");
    put("officeCode", "111");
}});
```

JSONおよびXMLデータ形式では繰り返し出現するデータが存在する。本機能では以下のように繰り返し項目を表現しMapオブジェクトに格納する。

| 対象データ | 格納形式 |
|-----------|----------|
| 文字列 | String配列としてデータを格納する |
| オブジェクト | Mapのキー名に配列添字（`[0]`、`[1]` など）を付与し、階層構造格納時と同様に格納する |

**フォーマット定義ファイル例:**

```bash
#-------------------------------------------------------------------------------
# ユーザデータのJSONデータフォーマット
#-------------------------------------------------------------------------------
file-type:       "JSON"       # JSONデータ形式
text-encoding:   "UTF-8"      # ファイルエンコーディング

[UserData]                    # ユーザデータ(ルート要素)のレコードタイプ
1  header      OB             # ヘッダ項目
2  data [1..3] OB             # データ項目(最大３要素)

[header]                      # ヘッダ項目のレコードタイプ
1  msg_id      X              # メッセージID

[data]                        # データ項目のレコードタイプ
1  name        N              # 氏名
2  age         XS9            # 年齢
3  mail [0..2] X              # メールアドレス(省略可能、最大２要素)
```

**JSONデータ例:**

```json
{
  "header":{
    "msg_id":"123456"
  },
  "data":[
    {
      "name":"nablarch1",
      "age":30,
      "mail":["nablarch1-1@tis.co.jp", "nablarch1-2@tis.co.jp"]
    },
    {
      "name":"nablarch2",
      "age":31,
      "mail":["nablarch2-1@tis.co.jp"]
    },
    {
      "name":"nablarch3",
      "age":32
    }
  ]
}
```

**XMLデータ例:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<UserData>
  <header>
    <msg_id>123456</msg_id>
  </header>
  <data>
    <name>nablarch1</name>
    <age>30</age>
    <mail>nablarch1-1@tis.co.jp</mail>
    <mail>nablarch1-2@tis.co.jp</mail>
  </data>
  <data>
    <name>nablarch2</name>
    <age>31</age>
    <mail>nablarch2-1@tis.co.jp</mail>
  </data>
  <data>
    <name>nablarch3</name>
    <age>32</age>
  </data>
</UserData>
```

XMLでは `<data>` 要素の繰り返し出現がオブジェクトの繰り返しを表し、`<mail>` 要素の繰り返し出現がString配列（文字列の繰り返し）を表す。JSONの `[]` 構文とは異なり、XMLでは同名要素の繰り返しによって配列を表現する。

**Mapオブジェクト（変換結果）:**

| キー | 値 |
|------|----|
| `"header.msg_id"` | `"123456"` |
| `"data[0].name"` | `"nablarch1"` |
| `"data[0].age"` | `"30"` |
| `"data[0].mail"` | `["nablarch1-1@tis.co.jp", "nablarch1-2@tis.co.jp"]`（String配列） |
| `"data[1].name"` | `"nablarch2"` |
| `"data[1].age"` | `"31"` |
| `"data[1].mail"` | `["nablarch2-1@tis.co.jp"]`（String配列） |
| `"data[2].name"` | `"nablarch3"` |
| `"data[2].age"` | `"32"` |

<details>
<summary>keywords</summary>

DataRecordFormatter, FormatterFactory, フォーマット定義ファイル, readRecord, writeRecord, setInputStream, setOutputStream, createFormatter, hasNext, initialize, データ読み込み, データ書き込み, 固定長ファイル, 繰り返しデータ, String配列, 配列添字, [0], [1], 繰り返し項目, Mapキー, 配列インデックス, data[0].name, XMLデータ, mail要素繰り返し

</details>

## データ型について

JSON形式ではJSONの仕様として文字列型や数値型、真偽値などのデータ型が規定されている。本機能では内部的にはすべて文字列として取り扱い、出力時にフォーマット定義ファイルに従い適切な型でデータ出力を行う。

XML形式ではスキーマ定義を併用した場合を除き、特にデータ型は規定されていないため、本機能ではすべて文字列として取り扱う。

<details>
<summary>keywords</summary>

データ型, JSON文字列型, JSON数値型, JSON真偽値, 内部的に文字列, 出力時型変換, フォーマット定義ファイル, XMLデータ型なし, スキーマ定義

</details>

## XMLでDTDを使う

> **警告**: 本機能でXMLを入力する場合、DTDをデフォルトで使用することはできない。DTDを使用したXMLを読み込もうとした場合、例外が発生する。これはXML外部実体参照（XXE）を防止するための措置である。

読み込み対象となるXMLが信頼できる場合は、`nablarch.core.dataformat.XmlDataParser` の `allowDTD` プロパティを使用してDTDの使用を許可することができる。`XmlDataParser` という名前で明示的にコンポーネント設定ファイルに設定を記載し、DTDの使用を許可する。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<component-configuration
    xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration component-configuration.xsd">

  <component name="XmlDataParser" class="nablarch.core.dataformat.XmlDataParser">
    <!--
        DTDの使用を許可する。
        XXE攻撃の危険性があるため、信頼できるXML以外には使用してはならない。
     -->
    <property name="allowDTD" value="true" />
  </component>
</component-configuration>
```

> **注意**: 以下のバージョンのJDKにはAPIに不具合があり、本機能を使用した場合に `NullPointerException` が発生する。本バグを回避するには、JDKのバージョンをアップする。
> - JDK6 6u65 未満
> - JDK7 7u6 b15 未満

<details>
<summary>keywords</summary>

DTD, XXE, XML外部実体参照, セキュリティ, allowDTD, XmlDataParser, DTD禁止, 例外, JDK NullPointerException, JDK-7157610

</details>

## 名前空間について（XMLデータ形式のみ）

XMLデータ形式では、名前空間を使用した要素を扱うことができる。本機能で取り扱うMapオブジェクトでは、「:」を取り除いて、次の項目を大文字したキー名を使用して名前空間つきの要素名を表現する。

例: `tns:key1` → `tnsKey1`

名前空間の接頭辞の定義については、フィールド名の先頭に「?」をつけることにより読み飛ばす必要がある。

**フォーマット定義ファイル例:**

```bash
#-------------------------------------------------------------------------------
# ユーザデータのXMLデータフォーマット
#-------------------------------------------------------------------------------
file-type:       "JSON"       # JSONデータ形式
text-encoding:   "UTF-8"      # ファイルエンコーディング

[tns:response]
1 ?@xmlns:tns X  #名前空間の接頭辞の定義
2 tns:key1    X  #名前空間つきの項目
```

**XMLデータ例:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<tns:response xmlns:tns="http://foo.jp/general">
    <tns:key1>200</tns:key1>
</tns:response>
```

**Mapオブジェクト（変換結果）:**

| キー | 値 |
|------|----|
| `"tnsKey1"` | `"200"` |

<details>
<summary>keywords</summary>

名前空間, namespace, xmlns, コロン除去, キャメルケース変換, tns:key1, tnsKey1, 接頭辞定義, ?フィールド名, 読み飛ばし

</details>

## XMLで属性を持つ要素にコンテンツを定義する方法について

XMLで属性を持つ要素にコンテンツを定義したい場合は、フォーマット定義ファイルにコンテンツを表すフィールドを定義する。コンテンツを表すフィールド名のデフォルトは `body` である。

**フォーマット定義ファイル例:**

```bash
file-type:        "XML"
text-encoding:    "UTF-8"

[parent]
1 child   OB

[child]
1 @attr   X
2 body    X   # コンテンツを表すフィールド名には body を指定する。
```

**XMLデータ例:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<parent>
  <child attr="value1">value2</child>
</parent>
```

**Mapオブジェクト（変換結果）:**

| キー | 値 |
|------|----|
| `"child.attr"` | `"value1"` |
| `"child.body"` | `"value2"` |

コンテンツを表すフィールド名をデフォルトの `body` から変更したい場合は、以下のクラスをコンポーネント設定ファイルに設定し、`contentName` プロパティに変更後のコンテンツ名をそれぞれ設定する。

- `XmlDataParser`（コンポーネント名は `XmlDataParser` とすること）
- `XmlDataBuilder`（コンポーネント名は `XmlDataBuilder` とすること）

```xml
<!-- XmlDataParser のコンポーネント名は XmlDataParser とすること -->
<component name="XmlDataParser" class="nablarch.core.dataformat.XmlDataParser">
  <property name="contentName" value="change" />
</component>

<!-- XmlDataBuilder のコンポーネント名は XmlDataBuilder とすること -->
<component name="XmlDataBuilder" class="nablarch.core.dataformat.XmlDataBuilder">
  <property name="contentName" value="change" />
</component>
```

<details>
<summary>keywords</summary>

XML属性, コンテンツ定義, bodyフィールド, contentName, XmlDataParser, XmlDataBuilder, 属性とコンテンツ, child.body, child.attr

</details>

## ノード名に関する制約事項

\`レコードタイプ名に関する注意事項\`_ のとおり、レイアウト定義においてレコードタイプ名の重複は許容されない。そのため、**親ノード名が重複するXML・JSONは許容されない**。

**禁止例（NG）** — フォーマット定義ファイル:

```bash
file-type:        "XML"
text-encoding:    "UTF-8"
[a]               #この要素と
1 b OB
[b]
1 a OB
[a]               #この要素が重複(NG)
1 c X
```

XMLデータ:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<a>       <!-- この要素と -->
  <b>
    <a>   <!-- この要素が重複(NG) -->
      <c>val1</c>
    </a>
  </b>
</a>
```

以下の重複は許容される:

- **レコードタイプ名とフィールド名の重複**: レコードタイプ名が一意であることを妨げないため許容。

```bash
file-type:        "XML"
text-encoding:    "UTF-8"
[a]               #このレコードタイプ名と
1 a X             #このフィールド名が重複(OK)
2 b X9
```

- **異なるレコードタイプ間でのフィールド名の重複**: 別レコードタイプに同名フィールドが存在しても許容。

```bash
file-type:        "XML"
text-encoding:    "UTF-8"
[a]
1 b OB
2 c OB
[b]
1 d X9            #このフィールド名と
[c]
1 d X             #このフィールド名が重複(OK)
```

<details>
<summary>keywords</summary>

ノード名制約, レコードタイプ名重複禁止, 親ノード名重複, フィールド名重複許容, XMLデータ形式, JSONデータ形式

</details>
