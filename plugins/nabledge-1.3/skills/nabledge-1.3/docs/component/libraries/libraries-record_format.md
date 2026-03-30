# 汎用データフォーマット機能

## 

EDI等で利用される多様なデータ形式に対応する汎用の入出力ライブラリ。システム間通信、バッチ処理のデータファイル読み書き、ファイルアップロード処理など、様々な場面で使用される。

フォーマット定義ファイルは2つの部分で構成される。

1. **ディレクティブ宣言部**: データ形式全体に影響する共通設定（データ形式種別、エンコーディング等）
2. **レコードフォーマット定義部**: レコード内各フィールドの開始位置・データ型・変換処理の定義。マルチフォーマット形式では複数フォーマットを定義し条件で動的切替可能。

## コメント

`#`から行末はコメント。任意の行で使用可能。

## 文字コード

デフォルトはUTF-8。他の文字コードを使用する場合は**フォーマッターファクトリ**に設定追加が必要。

## リテラル表記

| リテラル型 | 例 | 備考 |
|---|---|---|
| 文字列 | `"Nablarch"`, `"\\r\\n"` | Javaの文字リテラルと同仕様。`\\Uxxxx` Unicodeエスケープは非サポート |
| 10進整数 | `0`, `123`, `-456` | 小数不可 |
| 真偽値 | `true`, `false`, `TRUE`, `FALSE` | |

## 任意識別子

フィールド名・レコードタイプ名等には以下の正規表現に合致する文字列を使用する（ASCIIでのJava識別子定義と同じ）。

```
/[a-zA-Z_$][a-zA-Z0-9_$]*/
```

## ディレクティブ宣言部

書式: `ディレクティブ名 : ディレクティブ値（リテラル）`

**共通ディレクティブ**

| ディレクティブ名 | 必須 | 内容 |
|---|---|---|
| `file-type` | ○ | データ形式。`"Fixed"`（固定長）または`"Variable"`（可変長） |
| `text-encoding` | ○ | 文字列フィールドのエンコーディング（`"UTF-8"`, `"SJIS"`, `"MS932"` 等） |
| `record-separator` | 可変長は○ | レコード終端文字列。可変長データ形式では必須指定であり、レコードの終端を判断するための文字列として使用する。固定長では各レコード直後に付加文字列として扱う（バイト長は`record-length`に含まれない）。 |

**固定長専用ディレクティブ**

| ディレクティブ名 | 必須 | 内容 |
|---|---|---|
| `record-length` | ○ | 1レコードのバイト長 |
| `positive-zone-sign-nibble` / `negative-zone-sign-nibble` | | 符号付きゾーン数値の符号Nibble値。デフォルト: ASCII互換（UTF-8/SJISなど）は正=0x3/負=0x7、EBCDIC互換は正=0xC/負=0xD |
| `positive-pack-sign-nibble` / `negative-pack-sign-nibble` | | 符号付きパック数値の符号Nibble値。デフォルトはzone同様 |
| `required-decimal-point` | | 数値の小数点要否。`true`=書込データに小数点付与。デフォルト`true` |
| `fixed-sign-position` | | 数値の符号位置固定/非固定。`true`=フィールド左端固定、`false`=数値直前。デフォルト`true` |
| `required-plus-sign` | | 正の符号要否。`true`=読込時に正符号がなければエラー、書込時に正符号を出力。デフォルト`false` |

**可変長専用ディレクティブ**

| ディレクティブ名 | 必須 | 内容 |
|---|---|---|
| `field-separator` | ○ | フィールド区切り文字 |
| `quoting-delimiter` | | フィールド値クォート文字。デフォルトはダブルクォート(`"`) |
| `ignore-blank-lines` | | 空行を無視するか。デフォルト`true` |
| `requires-title` | | 最初の行をタイトルとして読み書きするか。`true`の場合、レコードタイプ名`[Title]`で読み書き可能。デフォルト`false` |
| `max-record-length` | | 読込許容する1行の文字列数。デフォルト`1000000` |
| `title-record-type-name` | | タイトルのレコードタイプ名。デフォルト`[Title]` |

## レコードフォーマット定義部

書式（シングルフォーマット）:

```
[レコードタイプ名]
フィールド開始位置  フィールド名  フィールドタイプ定義  [コンバータ定義...]
```

| 要素名 | 必須 | 内容 |
|---|---|---|
| フィールド開始位置 | ○ | 固定長: 開始バイト数（1起算）、可変長: カラム通番 |
| フィールド名 | ○ | 任意識別子。先頭に`?`を付けるとFILLER項目（入力時にMapに格納されない）。数字のみのフィールド名は定義不可（実行時に例外が発生する）。 |
| フィールドタイプ定義 | ○ | データ型定義（詳細は [types_and_converters](#) 参照）。例: `X(20)`（シングルバイト20バイト）、`B(1024)`（バイナリ1024バイト）、`SP(11)`（符号付きゾーン10進11バイト） |
| フィールドコンバータ定義 | | オプション指定・データ変換等の事前処理（詳細は [types_and_converters](#) 参照）。例: `pad(" ")`（スペーストリム・パディング）、`"00"`（デフォルト値） |

定義例（固定長）:

```
[Default]
1    dataKbn       X(1)  "2"
39  ?tegataNum     X(4)  "9999"
114 ?unused        X(7)  pad("0")
```

## 固定長データ形式 - フィールドタイプ

| タイプ識別子 | Java型 | 内容 | デフォルト実装クラス | 引数 |
|---|---|---|---|---|
| X | String | シングルバイト文字列 (バイト長=文字数)。右トリム・パディング(半角空白)。null→空文字 | `nablarch.core.dataformat.convertor.datatype.SingleByteCharacterString` | バイト長(数値、必須) |
| N | String | ダブルバイト文字列 (バイト長=文字数÷2)。右トリム・パディング(全角空白)。バイト長が2の倍数でない場合は構文エラー。null→空文字 | `nablarch.core.dataformat.convertor.datatype.DoubleByteCharacterString` | バイト長(数値、必須) |
| XN | String | マルチバイト文字列。UTF-8等バイト長の異なる文字が混在するフィールド、または全角文字列のパディングに半角スペースを使用する場合に使用。右トリム・パディング(半角空白)。null→空文字 | `nablarch.core.dataformat.convertor.datatype.ByteStreamDataString` | バイト長(数値、必須) |
| Z | BigDecimal | ゾーン10進数値 (バイト長=桁数)。左トリム・パディング('0')。null→0 | `nablarch.core.dataformat.convertor.datatype.ZonedDecimal` | 引数1:バイト長(必須)、引数2:小数点以下桁数(任意、デフォルト=0) |
| SZ | BigDecimal | 符号付ゾーン10進数値 (バイト長=桁数)。左トリム・パディング('0')。null→0 | `nablarch.core.dataformat.convertor.datatype.SignedZonedDecimal` | 引数1:バイト長(必須)、引数2:小数点以下桁数(任意、デフォルト=0)、引数3:正数時最小桁バイト上位4ビットパターン(16進文字列[0-9A-F]、任意)、引数4:負数時最小桁バイト上位4ビットパターン(16進文字列[0-9A-F]、任意) |
| P | BigDecimal | パック10進数値 (バイト長=桁数÷2、端数切り上げ)。左トリム・パディング('0')。null→0 | `nablarch.core.dataformat.convertor.datatype.PackedDecimal` | 引数1:バイト長(必須)、引数2:小数点以下桁数(任意、デフォルト=0) |
| SP | BigDecimal | 符号付パック10進数値 (バイト長=(桁数+1)÷2、端数切り上げ)。左トリム・パディング('0')。null→0 | `nablarch.core.dataformat.convertor.datatype.SignedPackedDecimal` | 引数1:バイト長(必須)、引数2:小数点以下桁数(任意、デフォルト=0)、引数3:正数時最下位4ビットパターン(16進文字列[0-9A-F]、任意)、引数4:負数時最下位4ビットパターン(16進文字列[0-9A-F]、任意) |
| B | byte[] | バイナリ列。パディングなし。null時はInvalidDataFormatExceptionを送出(変換しない)。アプリ側で明示的に値を設定すること | `nablarch.core.dataformat.convertor.datatype.Bytes` | バイト長(数値、必須) |
| X9 | BigDecimal | 符号無し数値文字列 (バイト長=文字数)。左トリム・パディング('0')。小数点記号(".")を含めることができる。null→0 | `nablarch.core.dataformat.convertor.datatype.NumberStringDecimal` | 引数1:バイト長(必須)、引数2:小数点記号がない場合の小数点以下桁数(任意、デフォルト=0) |
| SX9 | BigDecimal | 符号付き数値文字列 (バイト長=文字数)。左トリム・パディング('0')。null→0 | `nablarch.core.dataformat.convertor.datatype.NumberStringDecimal` | 引数1:バイト長(必須)、引数2:小数点記号がない場合の小数点以下桁数(任意、デフォルト=0) |

## 固定長データ形式 - フィールドコンバータ

| コンバータ名 | Java型(変換前後) | 内容 | デフォルト実装クラス | 引数 |
|---|---|---|---|---|
| pad | N/A | パディング・トリムの対象値を設定。方向はフィールドタイプ毎: X/N/XN=右トリム・パディング、Z/SZ/P/SP/X9/SX9=左トリム・パディング、B=無効 | `nablarch.core.dataformat.convertor.value.Padding` | パディング・トリムの対象値(必須) |
| encoding | N/A | 文字エンコーディングを指定。X/N/XN以外は無視 | `nablarch.core.dataformat.convertor.value.UseEncoding` | エンコーディング名(文字列、必須) |
| リテラル値 | Object<->Object | 入力時: なにもしない。出力時: 値が未設定の場合にリテラル値を出力 | `nablarch.core.dataformat.convertor.value.DefaultValue` | なし |

## 可変長データ形式 - フィールドタイプ

X、N、XN、X9、SX9 はすべてString型。どのタイプ識別子を指定しても動作は同じ。フィールド長の概念がないため引数不要。Number型(BigDecimalなど)を扱う場合はnumber/signed_numberコンバータを使用。null→空文字

## 可変長データ形式 - フィールドコンバータ

| コンバータ名 | Java型(変換前後) | 内容 | デフォルト実装クラス | 引数 |
|---|---|---|---|---|
| encoding | N/A | 文字エンコーディングを指定。X/N以外は無視 | `nablarch.core.dataformat.convertor.value.UseEncoding` | エンコーディング名(文字列、必須) |
| リテラル値 | Object<->Object | 入力時: なにもしない。出力時: 値が未設定の場合にリテラル値を出力 | `nablarch.core.dataformat.convertor.value.DefaultValue` | なし |
| number | String<->BigDecimal | 入力: 符号なし数値チェック後BigDecimalに変換。null/空文字→null。出力: 文字列変換後符号なし数値チェック。null→空文字 | `nablarch.core.dataformat.convertor.value.NumberString` | なし |
| signed_number | String<->BigDecimal | numberと同仕様だが符号付き数値も許可 | `nablarch.core.dataformat.convertor.value.SignedNumberString` | なし |

<details>
<summary>keywords</summary>

汎用データフォーマット機能, EDIデータ処理, ファイル読み書き, ライブラリ概要, 固定長可変長, システム間通信, バッチ処理, フォーマット定義ファイル, ディレクティブ宣言部, レコードフォーマット定義部, file-type, text-encoding, record-separator, record-length, field-separator, quoting-delimiter, ignore-blank-lines, requires-title, max-record-length, title-record-type-name, positive-zone-sign-nibble, negative-zone-sign-nibble, positive-pack-sign-nibble, negative-pack-sign-nibble, required-decimal-point, fixed-sign-position, required-plus-sign, FILLER項目, 固定長, 可変長, SingleByteCharacterString, DoubleByteCharacterString, ByteStreamDataString, ZonedDecimal, SignedZonedDecimal, PackedDecimal, SignedPackedDecimal, Bytes, NumberStringDecimal, Padding, UseEncoding, DefaultValue, NumberString, SignedNumberString, InvalidDataFormatException, フィールドタイプ, フィールドコンバータ, 固定長データ形式, 可変長データ形式, パディング・トリム, number, signed_number, pad, encoding, X, N, Z, P, B, X9, SX9, XN, SZ, SP

</details>

## 基本構造

フォーマット定義ファイルにデータ形式定義を記述し、フレームワークがデータソースのレコード読み書きを行う。フィールドレイアウト、データ型、パディング・トリミング処理も定義可能。プログラム側はMapオブジェクトとしてレコードを扱うだけでよい。

> **補足**: 別添のツールを使用することで、データファイルや電文の形式を定義した各種仕様書からフォーマット定義ファイルを生成することが可能。

3つの構成要素:

1. **フォーマット定義ファイル**: データのフォーマット定義を記述したファイル。アプリケーションプログラマが作成する。
2. **レコードフォーマッター** (`DataRecordFormatter`): フォーマット定義に沿ってデータの読み書きを行うオブジェクト。入力ストリームからレコードを読み込み、フィールド名をキーとするMapで返す。Mapを実装したオブジェクトをレコードとして出力可能。
3. **レコードフォーマッターファクトリ** (`FormatterFactory`): フォーマット定義ファイルを解析し、フォーマッターを生成するクラス（フレームワーク提供）。フォーマッターの機能拡張時はこのファクトリに拡張クラスを設定する。

特定のフィールドの値に応じてフォーマットを動的に切り替える形式。ヘッダーレコードとデータレコードでフォーマットが異なる場合に必要。

## レコードタイプ識別フィールド定義

レコード中の特定フィールドの値をもとに使用フォーマットを決定する。このフィールドを**レコードタイプ識別フィールド**と呼ぶ。レコードタイプ名を**Classifier**とする特別なレコードフォーマット定義を追加して定義する。

```
[Classifier]
1   dataKbn   X(1)
```

## 各レコードフォーマットの適用条件

各レコードフォーマット定義のレコードタイプ名の直後に、識別フィールドの適用条件値を記述する。

```
[header]
dataKbn = "1"
1   dataKbn     X(1)  "1"
2   sysDate     X(8)
```

`dataKbn`が`"1"`の場合にヘッダーレコードのフォーマットを使用することを意味する。

> **注意**: Classifierの定義内容は、実際の各レコード定義内容と一致させる必要はない。

定義例（固定長マルチフォーマット）:

```
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
1   dataKbn   X(1)   "2"
2   userId    X(10)
12  loginId   X(20)
32  kanjiName N(100)

[trailer]
dataKbn = "8"
1   dataKbn    X(1)  "8"
2   totalCount Z(19)

[end]
dataKbn = "9"
1   dataKbn    X(1)  "9"
2   ?filler    X(419)
```

`requires-title: true` を設定することで、最初の行をタイトル行として読み書きできる。最初の行はレコードタイプ名 `[Title]` で読み書きされる。タイトル行とデータ行を識別するためのフィールドが存在しない場合でも、シングルフォーマット定義で読み込みが可能になる。

**推奨**: 最初の行にタイトルが存在するファイルを読み込む場合は、本機能を使用することを推奨する。

**追加のメリット**: 本機能を使用する場合、最初の行がタイトル行であることが保証されるので、ファイルレイアウトの精査を省略できる。

## 制約

- `[Title]` レコードタイプを必ずフォーマット定義すること
- 最初の行を書き込む際のレコードタイプは `[Title]` でなければならない
- 最初の行以降を書き込む際のレコードタイプは `[Title]` 以外でなければならない
- `[Title]` に適用条件が定義されている場合、最初の行はその条件を満たし、最初の行以降はその条件を満たしてはいけない

## シングルフォーマット定義の例

```bash
file-type:    "Variable"
text-encoding:     "ms932"
record-separator:  "\r\n"
field-separator:   ","
quoting-delimiter: "\""
requires-title: true

[Title]
1   Name       N  "書籍名"
2   Publisher  N  "出版社"
3   Authors    N  "著者"
4   Price      N  "価格"

[Books]
1   Name       X
2   Publisher  X
3   Authors    X
4   Price      X  Number
```

## マルチフォーマット定義の例

```bash
file-type:    "Variable"
text-encoding:     "ms932"
record-separator:  "\r\n"
field-separator:   ","
quoting-delimiter: "\""
requires-title: true

[Classifier]
1  Kubun X

[Title]
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

`title-record-type-name` ディレクティブでタイトル固有のレコードタイプ名を個別に指定可能。

<details>
<summary>keywords</summary>

DataRecordFormatter, FormatterFactory, フォーマット定義ファイル, レコードフォーマッター, レコードフォーマッターファクトリ, Mapオブジェクト, パディング, トリミング, マルチフォーマット形式, Classifier, レコードタイプ識別フィールド, 動的フォーマット切替, マルチフォーマット, requires-title, title-record-type-name, タイトル行, 可変長ファイル, シングルフォーマット, [Title]

</details>

## 使用例

フォーマット定義ファイルの例（固定長）:

```
file-type:     "Fixed"  # 固定長ファイル
text-encoding: "ms932"  # 文字列型フィールドの文字エンコーディング
record-length:  120     # 各レコードbyte長

[Default]
1    dataKbn       X(1)  "2"      # 1. データ区分
2    FIcode        X(4)           # 2. 振込先金融機関コード
6    FIname        X(15)          # 3. 振込先金融機関名称
21   officeCode    X(3)           # 4. 振込先営業所コード
24   officeName    X(15)          # 5. 振込先営業所名
39  ?tegataNum     X(4)  "9999"   # (手形交換所番号)
43   syumoku       X(1)           # 6. 預金種目
44   accountNum    X(7)           # 7. 口座番号
51   recipientName X(30)          # 8. 受取人名
81   amount        X(10)          # 9. 振込金額
91   isNew         X(1)           # 10.新規コード
92   ediInfo       X(20)          # 11.EDI情報
112  transferType  X(1)           # 12.振込区分
113  withEdi       X(1)  "Y"      # 13.EDI情報使用フラグ
114 ?unused        X(7)  pad("0") # (未使用領域)
```

`FormatterFactory` でフォーマッター (`DataRecordFormatter`) を作成:

```java
File formatFile = new File("./test.fmt");
DataRecordFormatter formatter = FormatterFactory
                               .getInstance()
                               .createFormatter(formatFile);
```

読み込み:

```java
InputStream in = new FileInputStream("./data.dat");
formatter.setInputStream(in).initialize();
List<Map<String, Object>> records = new ArrayList<Map<String, Object>>();
while (formatter.hasNext()) {
  records.add(formatter.readRecord());
}
```

書き込み:

```java
OutputStream out = new FileOutputStream("./data.dat");
formatter.setOutputStream(out).initialize();
formatter.writeRecord(new HashMap() {{
    put("FIcode",     "9999");
    put("FIname",     "ﾅﾌﾞﾗｰｸｷﾞﾝｺｳ");
    put("officeCode", "111");
}});
```

<details>
<summary>keywords</summary>

DataRecordFormatter, FormatterFactory, フォーマット定義ファイル, 固定長ファイル, readRecord, writeRecord, text-encoding, record-length, Fixed, ms932

</details>
