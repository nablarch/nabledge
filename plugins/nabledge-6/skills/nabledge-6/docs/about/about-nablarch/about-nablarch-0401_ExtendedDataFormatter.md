# データフォーマッタの拡張

**公式ドキュメント**: [データフォーマッタの拡張](https://nablarch.github.io/docs/LATEST/doc/biz_samples/04/0401_ExtendedDataFormatter.html)

## 

なし

<details>
<summary>keywords</summary>

データフォーマッタ拡張, カスタムフォーマッタ

</details>

## 概要

Nablarch標準（Json、Xml等）とは別のフォーマッタが必要な場合、データフォーマッタを追加することで対応できる。

本サンプルはapplication/x-www-form-urlencoded形式（`name1=value1&name2=value2`のようにKey=Valueを`&`で結合する形式）に対応したフォーマッタの実装例を示す。

<details>
<summary>keywords</summary>

データフォーマッタ追加, カスタムフォーマッタ, application/x-www-form-urlencoded, FormUrlEncodedフォーマッタ

</details>

## 提供パッケージ

- `please.change.me.core.dataformat`
- `please.change.me.core.dataformat.convertor`
- `please.change.me.test.core.file`

<details>
<summary>keywords</summary>

please.change.me.core.dataformat, please.change.me.core.dataformat.convertor, please.change.me.test.core.file, 提供パッケージ

</details>

## FormUrlEncodedデータフォーマッタの構成

FormUrlEncodedデータフォーマッタはapplication/x-www-form-urlencodedデータ（`name1=value1&name2=value2`形式）を処理する。

> **重要**: 値はURLエンコードされる。キーはURLエンコードされないため、キー文字列に特殊文字は使用不可。

| クラス | パッケージ | 概要 |
|---|---|---|
| `FormUrlEncodedDataFormatterFactory` | `please.change.me.core.dataformat` | フォーマッタファクトリクラス。`createFormatter(String fileType, String formatFilePath)`をオーバーライドし、`FormUrlEncodedDataRecordFormatter`のインスタンスを生成する。 |
| `FormUrlEncodedDataRecordFormatter` | `please.change.me.core.dataformat` | フォーマッタクラス。読み込み時はパラメータ出現順不問、書き込み時はフォーマット定義順で出力する。 |
| `FormUrlEncodedDataConvertorFactory` | `please.change.me.core.dataformat.convertor` | データコンバータのファクトリクラス。コンバータ名と実装クラスの対応表を保持する。 |
| `FormUrlEncodedDataConvertorSetting` | `please.change.me.core.dataformat.convertor` | コンバータ設定情報保持クラス。DIコンテナからコンバータ名と実装クラスの対応表を設定する。 |
| `FormUrlEncodedTestDataConverter` | `please.change.me.test.core.file` | テストデータコンバータクラス。Key=Value形式のテストデータを解析し、Value部にURLエンコーディングを動的に適用する。 |

<details>
<summary>keywords</summary>

FormUrlEncodedDataFormatterFactory, FormUrlEncodedDataRecordFormatter, FormUrlEncodedDataConvertorFactory, FormUrlEncodedDataConvertorSetting, FormUrlEncodedTestDataConverter, URLエンコーディング, クラス構成

</details>

## 使用方法

なし

<details>
<summary>keywords</summary>

使用方法, FormUrlEncodedデータフォーマッタ設定

</details>

## FormUrlEncodedデータフォーマッタの使用方法

業務アプリケーションでFormUrlEncodedDataFormatterFactoryを使用する場合、以下のコンポーネント設定を追加する。

```xml
<component name="formatterFactory" class="please.change.me.core.dataformat.FormUrlEncodedDataFormatterFactory"/>
```

<details>
<summary>keywords</summary>

FormUrlEncodedDataFormatterFactory, formatterFactory, コンポーネント設定

</details>

## フォーマット定義ファイルの記述例

```
file-type:     "FormUrlEncoded"  # フォームURLエンコード形式ファイル
text-encoding: "UTF-8"           # 文字列型フィールドの文字エンコーディング

[data]
1    key1   X      # 項目1
2    key2   X      # 項目2
```

<details>
<summary>keywords</summary>

フォーマット定義ファイル, FormUrlEncoded, file-type, text-encoding

</details>

## フィールドタイプ・フィールドコンバータ定義一覧

> **重要**: FormUrlEncodedデータフォーマッタでは全フィールドをString型として処理する。タイプ識別子（X、N、XN、X9、SX9）による動作差はなく、フィールド長の概念がないため引数不要。Number型（BigDecimalなど）を扱う場合はnumber/signed_numberコンバータを使用すること。

**フィールドタイプ**

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| X、N、XN、X9、SX9 | String | 全タイプでStringとして読み書き。引数不要。 |

**フィールドコンバータ**

| コンバータ名 | Java型(変換前後) | 内容 |
|---|---|---|
| リテラル値 | Object <-> Object | 入力時: 何もしない。出力時: 値が未設定の場合に指定リテラル値を出力。デフォルト実装: `nablarch.core.dataformat.convertor.value.DefaultValue`。引数: なし |
| number | String <-> BigDecimal | 入力時: 符号なし数値チェック後にBigDecimalへ変換（null/空文字はnull）。出力時: 文字列変換後に符号なし数値チェック（nullは空文字）。デフォルト実装: `nablarch.core.dataformat.convertor.value.NumberString`。引数: なし |
| signed_number | String <-> BigDecimal | 符号付き数値を許可する以外はnumberと同仕様。デフォルト実装: `nablarch.core.dataformat.convertor.value.SignedNumberString`。引数: なし |

<details>
<summary>keywords</summary>

フィールドタイプ, タイプ識別子, X, N, XN, X9, SX9, number, signed_number, リテラル値, nablarch.core.dataformat.convertor.value.NumberString, nablarch.core.dataformat.convertor.value.SignedNumberString, nablarch.core.dataformat.convertor.value.DefaultValue, BigDecimal変換

</details>

## 同一キーで複数の値を取り扱う場合

同一キーで複数の値を取り扱う場合、データはString配列形式で保持される。フォーマット定義ファイルにて多重度の設定が必要。

<details>
<summary>keywords</summary>

同一キー複数値, String配列, 多重度設定

</details>

## テストデータの記述方法

URLエンコーディングされたデータをExcelファイルに直接記述することは可読性・保守性の面で現実的ではないため、テストデータコンバータを使用する。

**コンポーネント設定ファイル**

```xml
<component name="TestDataConverter_FormUrlEncoded"
           class="please.change.me.test.core.file.FormUrlEncodedTestDataConverter"/>
```

**Excelファイル**

file-typeに`"FormUrlEncoded"`を指定し、テストデータを項目ごとにKey-Value形式で記述する。

![テストデータExcelファイル例](../../knowledge/about/about-nablarch/assets/about-nablarch-0401_ExtendedDataFormatter/test_data_example.png)

テストフレームワークにより`FormUrlEncodedTestDataConverter`が呼び出され、FormUrlEncodedデータフォーマッタには以下のデータが入力される:

```
kanjiName=%E6%BC%A2%E5%AD%97%E6%B0%8F%E5%90%8D&kanaName=%E3%82%AB%E3%83%8A%E3%82%B7%E3%83%A1%E3%82%A4&mailAddr=test%40anydomain.com
```

<details>
<summary>keywords</summary>

FormUrlEncodedTestDataConverter, テストデータコンバータ, TestDataConverter_FormUrlEncoded, URLエンコーディングテスト, Excelテストデータ

</details>
