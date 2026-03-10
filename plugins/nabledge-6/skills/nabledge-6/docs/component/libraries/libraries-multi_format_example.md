# マルチフォーマット定義のサンプル集

**公式ドキュメント**: [マルチフォーマット定義のサンプル集](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_io/data_format/multi_format_example.html)

## Fixed(固定長)のマルチフォーマット定義のサンプル集

### 単一フィールドでフォーマットを識別する例

単一フィールドが条件の場合、フィールド値が各フォーマットに定義した条件と一致した場合に、そのレコード定義で処理される。

- `dataKbn`が`"1"`: headerレコードタイプ
- `dataKbn`が`"2"`: dataレコードタイプ

```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    40
record-separator: "\r\n"

[Classifier]
1 dataKbn X(1)

[header]
dataKbn = "1"
1 dataKbn X(1)
2 data    X(39)

[data]
dataKbn = "2"
1 dataKbn X(1)
2 data    X(39)
```

### 複数フィールドでフォーマットを識別する例

複数フィールドでレコードを識別する場合、全ての条件を満たした場合にそのレコード定義で処理される。

- `dataKbn`が`"1"`かつ`type`が`"01"`: parentDataレコードタイプ
- `dataKbn`が`"2"`かつ`type`が`"02"`: childDataレコードタイプ

```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    40
record-separator: "\r\n"

[Classifier]
1   dataKbn X(1)
10  type    X(2)

[parentData]
dataKbn = "1"
type    = "01"
1  dataKbn X(1)
2  ?filler X(9)
10 type    X(2)
13 data    X(28)

[childData]
dataKbn = "1"
type    = "02"
1  dataKbn X(1)
2  ?filler X(9)
10 type    X(2)
13 data    X(28)
```

### レコード毎に識別項目が異なる場合の例

レコード毎に識別に使用する項目が異なる場合、レコード識別フィールドには識別に使用する全てのフィールドを定義する。個別のレコードの条件定義部には、そのレコードを識別する条件を定義する。

- `dataKbn`が`"1"`: headerレコードタイプ
- `dataKbn`が`"2"`かつ`type`が`"01"`: data1レコードタイプ
- `dataKbn`が`"2"`かつ`type`が`"02"`: data2レコードタイプ

```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    40
record-separator: "\r\n"

[Classifier]
1   dataKbn X(1)
10  type    X(2)

[header]
dataKbn = "1"
1  dataKbn X(1)
2  ?filler X(39)

[data1]
dataKbn = "2"
type    = "01"
1  dataKbn X(1)
2  ?filler X(9)
10 type    X(2)
13 data    X(28)

[data2]
dataKbn = "2"
type    = "02"
1  dataKbn X(1)
2  ?filler X(9)
10 type    X(2)
13 data    X(28)
```

<details>
<summary>keywords</summary>

固定長マルチフォーマット, Fixed, レコード識別, Classifier, dataKbn, record-length, マルチフォーマット定義

</details>

## Variable(可変長)でマルチフォーマット定義のサンプル集

### 単一フィールドでフォーマットを識別する例

単一フィールドが条件の場合、フィールド値が各フォーマットに定義した条件と一致した場合に、そのレコード定義で処理される。

- `dataKbn`が`"1"`: headerレコードタイプ
- `dataKbn`が`"2"`: dataレコードタイプ

```
file-type:        "Variable"
text-encoding:    "MS932"
record-separator: "\r\n"
field-separator:  ","

[Classifier]
1 dataKbn X

[header]
dataKbn = "1"
1 dataKbn X
2 data    X

[data]
dataKbn = "2"
1 dataKbn X
2 data    X
```

### 複数フィールドでフォーマットを識別する例

複数フィールドでレコードを識別する場合、全ての条件を満たした場合にそのレコード定義で処理される。

- `dataKbn`が`"1"`かつ`type`が`"01"`: parentDataレコードタイプ
- `dataKbn`が`"2"`かつ`type`が`"02"`: childDataレコードタイプ

```
file-type:        "Variable"
text-encoding:    "MS932"
record-separator: "\r\n"
field-separator:  ","

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

### レコード毎に識別項目が異なる場合の例

レコード毎に識別に使用する項目が異なる場合、レコード識別フィールドには識別に使用する全てのフィールドを定義する。個別のレコードの条件定義部には、そのレコードを識別する条件を定義する。

- `dataKbn`が`"1"`: headerレコードタイプ
- `dataKbn`が`"2"`かつ`type`が`"01"`: data1レコードタイプ
- `dataKbn`が`"2"`かつ`type`が`"02"`: data2レコードタイプ

```
file-type:        "Variable"
text-encoding:    "MS932"
record-separator: "\r\n"
field-separator:  ","

[Classifier]
1   dataKbn X
3   type    X

[header]
dataKbn = "1"
1 dataKbn X
2 ?filler X

[data1]
dataKbn = "2"
type    = "01"
1 dataKbn X
2 ?filler X
3 type    X
4 data    X

[data2]
dataKbn = "2"
type    = "02"
1 dataKbn X
2 ?filler X
3 type    X
4 data    X
```

### タイトルレコードを使用した場合の例

:ref:`タイトルレコードあり <data_format-requires-title>` の可変長ファイルの場合、タイトルレコードに関してはレコード識別条件を定義する必要が無い。

タイトルレコード以外のフォーマットがシングルフォーマットの場合、レコード識別（`Classifier`）の定義は不要。タイトルレコードのレイアウト定義はレコードタイプ名を`Title`として定義する。

```
requires-title: true

[Title]
1   Kubun      N
2   Name       N
3   Publisher  N
4   Authors    N
5   Price      N

[DataRecord]
1   Kubun      X
2   Name       N
3   Publisher  N
4   Authors    N
5   Price      N
```

タイトルレコード以外のフォーマットがマルチフォーマットの場合、レコード識別（`Classifier`）の定義が必要。`Title`レコードタイプについてはマルチフォーマット時に必要となる条件定義は不要。

```
file-type:         "Variable"
text-encoding:     "ms932"
record-separator:  "\r\n"
field-separator:   ","
quoting-delimiter: "\""
requires-title:    true

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

> **補足**: タイトルレコードのレコードタイプ名を`Title`から変更したい場合は、:ref:`data_format-title_type_nameディレクティブ <data_format-title_type_name>` を使用すること。その場合、タイトルレコードのレコードタイプ名を:ref:`data_format-title_type_nameディレクティブ <data_format-title_type_name>`で設定した値に変更すること。

<details>
<summary>keywords</summary>

可変長マルチフォーマット, Variable, タイトルレコード, requires-title, field-separator, Classifier, data_format-variable_title_sample

</details>
