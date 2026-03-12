# フォーマット定義ファイルの記述ルール

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_io/data_format/format_definition.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Map.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/FixedLengthConvertorSetting.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/VariableLengthConvertorSetting.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/InvalidDataFormatException.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/convertor/datatype/SignedNumberStringDecimal.html)

## フォーマット定義ファイルの共通の記法

フォーマット定義ファイルの文字コードは`UTF-8`。

**リテラル表記**

| リテラル型 | 説明 | 記述例 |
|---|---|---|
| 文字列 | `"`で値を囲む。Unicodeエスケープ・8進数エスケープ非対応 | `"Nablarch"`, `"\r\n"` |
| 10進整数 | Javaの数値リテラルと同様。小数非対応 | `123`, `-123` |
| 真偽値 | `true`または`false`（大文字可） | |

**コメント**

行中の`#`以降はコメントとして扱われる。

```
#
# サンプルファイル
# 
file-type:     "Fixed"  # 固定長
text-encoding: "ms932"  # 文字コードはms932
record-length:  120     # 各業の長さは120バイト
```

レコードタイプ名を `[` `]` で囲んで定義する。レコードタイプ名はフォーマット定義ファイル内で一意であること。

```bash
[data]              # レコードタイプ名:data
1 name  N(100)      # 名前
2 age   X9(3)       # 年齢
```

> **重要**: JSONおよびXMLデータ形式で同一フィールド名に `OB` タイプとそれ以外を混在させてはいけない。OBの定義が優先されるため、OB以外を指定したフィールドのフィールドタイプは無視される。その結果、本来OBではないフィールドがOB型として取り扱われ、データが正しく読み書きできない問題が発生する。

不適切な例:
```bash
[order]
1 id     N
2 data   OB  # フィールドタイプ:OB
3 detail OB

[data]
1 value  N

[detail]
1 data   N   # フィールドタイプ:N ← OBとして取り扱われる
```

フィールド定義の書式:

```text
<フィールド開始位置> <フィールド名> <多重度> <フィールドタイプ> <フィールドコンバータ>
```

| 要素 | 必須 | 説明 |
|---|---|---|
| フィールド開始位置 | ○ | Fixed(固定長): 開始バイト数(1起算)。Variable(可変長): 項目通番。JSON/XML: 要素通番 |
| フィールド名 | ○ | `java.util.Map` のキー。先頭に `?` を付けると入力時にMapに読み込まれない（例: ホストの固定長ファイルのfiller項目に使用することで余計な項目を入力対象から除外できる）。XML形式では先頭に `@` を付けると属性値として扱われる |
| 多重度 | | JSON/XMLのみ指定可。`[下限..上限]` 形式、上限なしは `*`。省略時は `[1]` |
| フィールドタイプ | ○ | [data_format-field_type_list](#) を参照 |
| フィールドコンバータ | | 複数設定可。[data_format-field_convertor_list](#) を参照 |

> **重要**: 数字のみのフィールド名は定義できない。

XMLで `@` を使った属性値定義例:
```bash
[tagName]
@attr
```
→ `<tagName attr="val">...</tagName>`

多重度の指定例(JSON/XMLのみ):
```bash
address [1..3]    # 1から3の定義が可能
address           # 省略時は[1]
address [0..*]    # 条件なし(0から無制限)
address [*]       # 条件なし(0から無制限)
address [1..*]    # 1以上
```

以下のXMLの場合、`address` フィールドの定義数は `2` となる:
```xml
<person>
  <address>自宅住所</address>
  <address>勤務先住所</address>
</person>
```

以下のJSONの場合、`address` フィールドの要素数は `3` となる:
```json
{
  "address" : ["自宅住所", "勤務先住所", "送付先住所"]
}
```

## Fixed(固定長)データ形式のフィールドタイプ

| タイプ | Java型 | 説明 |
|---|---|---|
| X | String | シングルバイト文字列(バイト長=文字列長)。デフォルト: 半角空白で右トリム・パディング。引数: バイト長(必須)。null→空文字変換して処理。読込値が空文字→null変換。空文字→null変換を無効化する場合は `convertEmptyToNull` に `false` を設定する |
| N | String | ダブルバイト文字列(バイト長=文字数÷2)。デフォルト: 全角空白で右トリム・パディング。引数: バイト長(必須)。バイト長が2の倍数でない場合は構文エラー。null/空文字扱いは :ref:`data_format-field_type-single_byte_character_string` と同じ |
| XN | String | マルチバイト文字列。UTF-8等バイト長が異なる文字が混在するフィールド、または全角文字列パディングに半角スペースを使う場合に使用。デフォルト: 半角空白で右トリム・パディング。引数: バイト長(必須)。null/空文字扱いは :ref:`data_format-field_type-single_byte_character_string` と同じ |
| Z | BigDecimal | ゾーン数値(バイト長=桁数)。デフォルト: 0で左トリム・パディング。引数1: バイト長(必須)、引数2: 小数点以下桁数(任意, デフォルト0)。null→0変換して処理。読込値のバイト数0→null変換。無効化: `convertEmptyToNull` に `false` を設定する |
| SZ | BigDecimal | 符号付きゾーン数値(バイト長=桁数)。デフォルト: 0で左トリム・パディング。引数1: バイト長(必須)、引数2: 小数点以下桁数(任意, デフォルト0)、引数3: ゾーン部正符号(16進, 任意)、引数4: ゾーン部負符号(16進, 任意)。引数3/4は :ref:`data_format-positive_zone_sign_nibble` および :ref:`data_format-negative_zone_sign_nibble` を上書きする場合に設定。null/バイト数0扱いは :ref:`data_format-field_type-zoned_decimal` と同じ |
| P | BigDecimal | パック数値(バイト長=桁数÷2[端数切り上げ])。デフォルト: 0で左トリム・パディング。引数1: バイト長(必須)、引数2: 小数点以下桁数(任意, デフォルト0)。null/バイト数0扱いは :ref:`data_format-field_type-zoned_decimal` と同じ |
| SP | BigDecimal | 符号付きパック数値(バイト長=(桁数+1)÷2[端数切り上げ])。デフォルト: 0で左トリム・パディング。引数1: バイト長(必須)、引数2: 小数点以下桁数(任意, デフォルト0)、引数3: 符号ビット正符号(16進, 任意)、引数4: 符号ビット負符号(16進, 任意)。引数3/4は :ref:`data_format-positive_pack_sign_nibble` および :ref:`data_format-negative_pack_sign_nibble` を上書きする場合に設定。null/バイト数0扱いは :ref:`data_format-field_type-zoned_decimal` と同じ |
| B | byte[] | バイナリ列。パディング・トリムなし。引数: バイト長(必須)。null時は値変換を行わず `InvalidDataFormatException` を送出。アプリ側で明示的に値を設定すること |
| X9 | BigDecimal | 符号無し数値文字列(バイト長=文字数)。フィールド中のシングルバイト文字列(X)を数値として扱う。デフォルト: 0で左トリム・パディング。文字列中に小数点記号(.)を含められる。引数1: バイト長(必須)、引数2: 固定小数点の小数点以下桁数(任意, デフォルト0)。null扱いは :ref:`data_format-field_type-zoned_decimal` と同じ。空文字扱いは :ref:`data_format-field_type-single_byte_character_string` と同じ |
| SX9 | BigDecimal | 符号付き数値文字列(バイト長=文字数)。フィールド中のシングルバイト文字列(X)を符号付き数値として扱う。デフォルト: 0で左トリム・パディング。引数1: バイト長(必須)、引数2: 固定小数点の小数点以下桁数(任意, デフォルト0)。null扱いは :ref:`data_format-field_type-zoned_decimal` と同じ。空文字扱いは :ref:`data_format-field_type-single_byte_character_string` と同じ。符号文字を変更する場合は `SignedNumberStringDecimal` を参考にプロジェクト固有フィールドタイプを作成( [data_format-field_type_add](libraries-data_format.md) 参照) |

## Variable(可変長)データ形式のフィールドタイプ

| タイプ | Java型 | 説明 |
|---|---|---|
| X, N, XN, X9, SX9 | String | 可変長データ形式ではすべてのフィールドをStringとして読み書き。タイプ識別子による動作差なし。フィールド長の概念なし(引数不要)。数値形式(BigDecimal)で読み書きしたい場合は :ref:`data_format-number_convertor` または :ref:`data_format-signed_number_convertor` を使用。null→空文字変換。空文字→null変換。無効化: `convertEmptyToNull` に `false` を設定する |

## JSONおよびXMLデータ形式のフィールドタイプ

| タイプ | Java型 | 説明 |
|---|---|---|
| X, N, XN | String | 文字列データタイプ。パディングなし。JSON出力時はダブルクォート`"`で括られる。null→JSON: 変換なし、XML: 空文字変換 |
| X9, SX9 | String | 数値文字列タイプ。パディングなし。値がそのまま出力される。数値形式(BigDecimal)で読み書きしたい場合は :ref:`data_format-number_convertor` または :ref:`data_format-signed_number_convertor` を使用。null扱いは :ref:`data_format-field_type-nullable_string` と同じ |
| BL | String | 文字列(`true` または `false` を文字列で表現)。パディングなし。null扱いは :ref:`data_format-field_type-nullable_string` と同じ |
| OB | - | ネストされたレコードタイプ指定に使用。フィールド名に対応したレコードタイプがネスト要素として入出力される。null扱いは :ref:`data_format-field_type-nullable_string` と同じ |

OB使用例:

JSON入出力データ:

```json
{
  "users": [
    {
      "name"    : "名前",
      "age"     : 30,
      "address" : "住所"
    },
    {
      "name"    : "名前1",
      "age"     : 31,
      "address" : "住所1"
    }
  ]
}
```

XML入出力データ:

```xml
<users>
  <user>
    <name>名前</name>
    <age>30</age>
    <address>住所</address>
  </user>
  <user>
    <name>名前1</name>
    <age>31</age>
    <address>住所1</address>
  </user>
</users>
```

上記のJSONおよびXMLに対応したフォーマット定義ファイル:

```bash
[users]       # ルート要素
1 user [1..*] OB

[user]        # ネストした要素
1 name    N   # 最下層の要素
2 age     X9
3 address N
```

| コンバータ名 | 型変換仕様 | 説明 |
|---|---|---|
| pad | 型変換無し | パディング・トリムする文字を設定する。フィールドタイプ別のトリム・パディング位置: X/N/XN=右トリム・右パディング、Z/SZ/P/SP/X9/SX9=左トリム・左パディング。フィールドタイプ詳細は [data_format-field_type_list](#) を参照。引数: パディング・トリムの対象となる値（必須） |
| encoding | 型変換なし | 文字列型フィールドの文字エンコーディングを設定する。共通設定( :ref:`text-encoding <data_format-directive_text_encoding>` )を特定フィールドで上書きする場合に使用。X/N/XNフィールドのみ使用可（それ以外のフィールドタイプに設定した場合は無視される）。引数: エンコーディング名（必須） |
| リテラル値 | 型変換なし | 出力時のデフォルト値を設定する。出力時に値が未設定の場合に指定されたリテラル値を出力する。入力時は使用しない。 |
| number | String <-> BigDecimal | 数字文字列をBigDecimalに変換する。入力時: 符号なし数値形式であることをチェックしBigDecimalに変換。出力時: 文字列に変換し符号なし数値形式であることをチェック後に出力。 |
| signed_number | String <-> BigDecimal | 符号付きの数字文字列をBigDecimalに変換する。符号が許可される点以外は :ref:`numberコンバータ <data_format-number_convertor>` と同じ仕様。 |
| replacement | 型変換なし | 入出力とも置換対象文字を変換先の文字に置換して返す。引数: 置き換えタイプ名（任意）。詳細は [data_format-replacement](libraries-data_format.md) を参照。 |

<details>
<summary>keywords</summary>

文字コード, UTF-8, リテラル表記, コメント, フォーマット定義ファイル記法, 文字列リテラル, 真偽値, 10進整数, フィールド定義, フィールド開始位置, フィールド名, フィールドタイプ, フィールドコンバータ, 多重度, OBフィールドタイプ混在禁止, レコードタイプ名, java.util.Map, 数字のみフィールド名禁止, XML属性値定義, JSON多重度, XML多重度, ?プレフィックス, filler項目, 入力対象除外, 項目通番, 要素通番, 固定長フィールドタイプ, 可変長フィールドタイプ, JSONフィールドタイプ, XMLフィールドタイプ, ゾーン数値, パック数値, バイナリ列, 数値文字列, FixedLengthConvertorSetting, VariableLengthConvertorSetting, InvalidDataFormatException, SignedNumberStringDecimal, convertEmptyToNull, フォーマット定義フィールドタイプ, X, N, XN, Z, SZ, P, SP, B, X9, SX9, BL, OB, pad, encoding, number, signed_number, replacement, リテラル値, デフォルト値, BigDecimal, パディング, トリム, 文字エンコーディング, 数値変換, 文字置換

</details>

## フォーマット定義ファイルの構造

フォーマット定義ファイルは以下の2要素で構成される。

- **ディレクティブ宣言部**: データ形式（固定長やJSONなど）やエンコーディングなどの共通設定を定義する。
- **レコードフォーマット定義部**: レコード内のフィールド定義、フィールドごとのデータ型やデータ変換ルールを定義する。

フォーマット定義ファイルに複数のレコードフォーマットを定義する。どのレコードフォーマットかは特定フィールドの値で自動判定される。いずれのレコードタイプにもマッチしない場合は不正データとして異常終了する。

**定義ルール**:
- レコード識別フィールドのレコードタイプ名は `Classifier` とする
- 各レコード定義のレコードタイプ名直下に、そのレコードと判断するための条件を定義する
- Classifierに定義したフィールドは各レコード定義内に存在している必要がある

```bash
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    40
record-separator: "\r\n"

[Classifier]
1 dataKbn X(1)

[header]
dataKbn = "1"         # dataKbnが"1"の場合ヘッダレコード
1 dataKbn X(1)
2 data    X(39)

[data]
dataKbn = "2"         # dataKbnが"2"の場合データレコード
1 dataKbn X(1)
2 data    X(39)
```

> **補足**: JSON及びXMLデータ形式にはレコードの概念が存在しないため、マルチフォーマット形式のフォーマット定義には対応していない。

**固定長・可変長データ**: 実際のデータとフォーマット定義の項目定義は厳密に一致させる必要がある。アプリケーションで不要な項目でも、フォーマット定義ファイルに定義が必要。

**JSON・XMLデータ**: フォーマット定義ファイルに定義されていない項目は読み取り対象外となる。実際のデータに存在していても、アプリケーションで不要であれば定義しなくてよい。

<details>
<summary>keywords</summary>

ディレクティブ宣言部, レコードフォーマット定義部, フォーマット定義ファイル構造, マルチフォーマット, Classifier, レコード識別, レコード判定条件, 固定長マルチレコード, 複数レコードフォーマット, dataKbn, 項目定義省略, 固定長, 可変長, JSON, XML, フォーマット定義, 項目定義, 読み取り対象外

</details>

## 共通で使用可能なディレクティブ一覧

全てのデータ形式で使用するディレクティブ定義は以下のとおり。

| ディレクティブ | 必須/任意 | 説明 |
|---|---|---|
| file-type | 必須 | データ形式を指定。標準対応: Fixed（固定長）/ Variable（CSV・TSVなど可変長）/ JSON / XML |
| text-encoding | 必須 | 文字列フィールドの読み書き時のエンコーディング。JSONの場合はUTF-8/UTF-16(BE or LE)/UTF-32(BE or LE)のみ指定可能。XMLの場合はXML宣言部のエンコーディングが優先される |
| record-separator | 任意 | レコード終端文字（改行文字）。Variableの場合は必須。JSON/XMLでは使用しない |

<details>
<summary>keywords</summary>

file-type, text-encoding, record-separator, 共通ディレクティブ, ディレクティブ定義, ディレクティブ宣言部

</details>

## Fixed(固定長)形式で指定可能なディレクティブ一覧

Fixed（固定長）形式のデータで使用するディレクティブは以下のとおり。

| ディレクティブ | 必須/任意 | デフォルト値 | 説明 |
|---|---|---|---|
| record-length | 必須 | | 1レコードのバイト長 |
| positive-zone-sign-nibble | 任意 | ASCII互換: 0x3、EBCDIC互換: 0xC | 符号付きゾーン数値の正符号（16進数文字列） |
| negative-zone-sign-nibble | 任意 | ASCII互換: 0x7、EBCDIC互換: 0xD | 符号付きゾーン数値の負符号（16進数文字列） |
| positive-pack-sign-nibble | 任意 | ASCII互換: 0x3、EBCDIC互換: 0xC | 符号付きパック数値の正符号ビット（16進数文字列） |
| negative-pack-sign-nibble | 任意 | ASCII互換: 0x7、EBCDIC互換: 0xD | 符号付きパック数値の負符号ビット（16進数文字列） |
| required-decimal-point | 任意 | true | 小数点付与の要否。`true`=付与、`false`=固定小数点（付与しない） |
| fixed-sign-position | 任意 | true | 符号位置の固定要否。`true`=項目先頭に固定（例: `-000123456`）、`false`=パディング前の数値先頭に付加（例: `000-123456`） |
| required-plus-sign | 任意 | false | 正符号(`+`)の要否。`true`=読み込み時に正符号必須・書き込み時に付加 |

```
#
# ディレクティブ定義部
#
file-type:                      "Fixed"  # 固定長ファイル
text-encoding:                  "ms932"  # 文字列型フィールドの文字エンコーディング
record-length:                  120      # 各レコードbyte長
positive-zone-sign-nibble:      "C"      # ゾーン数値の正符号
negative-zone-sign-nibble:      "D"      # ゾーン数値の負符号
positive-pack-sign-nibble:      "C"      # パック数値の正符号
negative-pack-sign-nibbleL      "D"      # パック数値の負符号
required-decimal-point:         true     # 小数点あり
fixed-sign-position:            true     # 符号は先頭に
required-plus-sign:             false    # 正符号は付加しない
```

<details>
<summary>keywords</summary>

record-length, positive-zone-sign-nibble, negative-zone-sign-nibble, positive-pack-sign-nibble, negative-pack-sign-nibble, required-decimal-point, fixed-sign-position, required-plus-sign, 固定長, Fixed, ゾーン数値, パック数値, 符号付き数値

</details>

## Variable(可変長)形式で指定可能なディレクティブ一覧

Variable（可変長）形式のデータで使用するディレクティブは以下のとおり。

| ディレクティブ | 必須/任意 | デフォルト値 | 説明 |
|---|---|---|---|
| field-separator | 必須 | | フィールド区切り文字。CSVなら`,`、TSVなら`\t` |
| quoting-delimiter | 任意 | なし（クォートなし） | フィールド値のクォート文字。出力時は全フィールドがクォートされる。入力時はクォート文字が除去される。改行やフィールド内クォートの扱いはRFC4180参照 |
| ignore-blank-lines | 任意 | true | 空行を無視するか。`true`=空行（改行のみのレコード）を無視 |
| requires-title | 任意 | false | 最初のレコードをタイトルとして扱うか。`true`=タイトル扱い。タイトルレコードのレイアウト定義は`title-record-type-name`ディレクティブを参照 |
| title-record-type-name | 任意 | Title | タイトルのレコードタイプ名。指定したレコードタイプ名に紐づくレコードフォーマット定義に従いタイトルレコードが編集される |
| max-record-length | 任意 | 1,000,000文字 | 読み込みを許容する1レコードの最大文字数。設定値を超えてもレコード区切り文字が存在しない場合、不正データとして例外を送出する |

```
#
# ディレクティブ定義部
#
file-type:                  "Variable"  # 可変長ファイル
text-encoding:              "utf-8"     # 文字列型フィールドの文字エンコーディング
record-separator:           "\r\n"      # 改行
field-separator:            ","         # CSV
quoting-delimiter:          "\""        # ダブルクォートで項目を囲む
ignore-blank-lines:         true        # 空行は無視
requires-title:             false       # タイトルレコードは無し
max-record-length:          1000        # このcsvのレコードには最大でも1000文字まで
```

<details>
<summary>keywords</summary>

field-separator, quoting-delimiter, ignore-blank-lines, requires-title, title-record-type-name, max-record-length, 可変長, Variable, CSV, TSV, タイトルレコード, RFC4180

</details>

## JSON形式で指定可能なディレクティブ一覧

JSON形式固有のディレクティブは存在しない。`file-type: "JSON"`と`text-encoding`のみ設定する。

```
file-type:      "JSON"      # jsonフォーマット
text-encoding:  "utf-8"     # 文字列型フィールドの文字エンコーディング
```

<details>
<summary>keywords</summary>

JSON, JSON形式, JSONディレクティブ

</details>

## XML形式で指定可能なディレクティブ一覧

XML形式固有のディレクティブは存在しない。`file-type: "XML"`と`text-encoding`のみ設定する。

```
file-type:      "XML"       # xmlフォーマット
text-encoding:  "utf-8"     # 文字列型フィールドの文字エンコーディング
```

<details>
<summary>keywords</summary>

XML, XML形式, XMLディレクティブ

</details>
