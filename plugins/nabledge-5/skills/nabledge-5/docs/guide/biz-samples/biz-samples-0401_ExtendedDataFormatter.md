# データフォーマッタの拡張

**公式ドキュメント**: [データフォーマッタの拡張](https://nablarch.github.io/docs/LATEST/doc/biz_samples/04/0401_ExtendedDataFormatter.html)

## 

本サンプルで提供するフォーマッタ機能の仕様を解説する。フォーマッタ機能の概要・基本となる汎用データフォーマット機能の詳細は [data_format](../../component/libraries/libraries-data_format.md) を参照すること。

<details>
<summary>keywords</summary>

データフォーマッタ拡張, 汎用データフォーマット機能, data_format

</details>

## 概要

Nablarch標準（JSON/XML等）とは別のフォーマッタを追加したい場合、データフォーマッタを追加することで対応できる。

本サンプルはHTTPのPOSTパラメータのようなapplication/x-www-form-urlencoded形式（`name1=value1&name2=value2`形式）のフォーマッタ実装例を示す。

<details>
<summary>keywords</summary>

FormUrlEncoded, データフォーマッタ追加, application/x-www-form-urlencoded, カスタムフォーマッタ

</details>

## 提供パッケージ

提供パッケージ:
- `please.change.me.core.dataformat`
- `please.change.me.core.dataformat.convertor`
- `please.change.me.test.core.file`

<details>
<summary>keywords</summary>

please.change.me.core.dataformat, please.change.me.core.dataformat.convertor, please.change.me.test.core.file, 提供パッケージ

</details>

## FormUrlEncodedデータフォーマッタの構成

application/x-www-form-urlencoded形式（`name1=value1&name2=value2`形式）のデータを処理する。

仕様:
- **値**: URLエンコードを行う
- **キー**: URLエンコードしない。汎用データフォーマットのフォーマット定義書式に従う。キー文字列に特殊文字は使用不可
- 同一キーで複数値を扱うことが可能
- 読み込み時: パラメータの出現順を意識しない
- 書き込み時: フォーマット定義順でパラメータを出力

<details>
<summary>keywords</summary>

URLエンコード, キー制約, application/x-www-form-urlencoded, FormUrlEncoded仕様, 複数値対応

</details>

## 

| パッケージ名 | クラス名 | 概要 |
|---|---|---|
| `please.change.me.core.dataformat` | `FormUrlEncodedDataFormatterFactory` | フォーマッタファクトリクラス。`createFormatter(String fileType, String formatFilePath)`をオーバーライドし`FormUrlEncodedDataRecordFormatter`のインスタンス生成を可能とする |
| `please.change.me.core.dataformat` | `FormUrlEncodedDataRecordFormatter` | application/x-www-form-urlencoded形式のデータを解析・構築するフォーマッタクラス |
| `please.change.me.core.dataformat.convertor` | `FormUrlEncodedDataConvertorFactory` | データコンバータのファクトリクラス。デフォルトコンバータ名とコンバータ実装クラスの対応表を保持 |
| `please.change.me.core.dataformat.convertor` | `FormUrlEncodedDataConvertorSetting` | コンバータ設定情報を保持するクラス。DIコンテナからコンバータ名と実装クラスの対応表を設定 |
| `please.change.me.test.core.file` | `FormUrlEncodedTestDataConverter` | テストデータコンバータクラス。Key=Value形式テストデータを解析し、Value部に動的URLエンコーディングを行う |

<details>
<summary>keywords</summary>

FormUrlEncodedDataFormatterFactory, FormUrlEncodedDataRecordFormatter, FormUrlEncodedDataConvertorFactory, FormUrlEncodedDataConvertorSetting, FormUrlEncodedTestDataConverter

</details>

## 使用方法

FormUrlEncodedデータフォーマッタの設定・フォーマット定義・フィールドタイプ・テストデータについては各サブセクション（FormUrlEncodedデータフォーマッタの使用方法、フォーマット定義ファイルの記述例、フィールドタイプ・フィールドコンバータ定義一覧、テストデータの記述方法）を参照。

<details>
<summary>keywords</summary>

FormUrlEncoded使用方法, フォーマッタ設定, データフォーマッタ設定

</details>

## FormUrlEncodedデータフォーマッタの使用方法

フォーマッタファクトリクラスを使用する場合、コンポーネント設定ファイルに以下を追加する:

```xml
<component name="formatterFactory" class="please.change.me.core.dataformat.FormUrlEncodedDataFormatterFactory"/>
```

<details>
<summary>keywords</summary>

FormUrlEncodedDataFormatterFactory, formatterFactory, コンポーネント設定, フォーマッタ登録

</details>

## フォーマット定義ファイルの記述例

file-type `"FormUrlEncoded"` のフォーマット定義ファイル記述例:

```bash
#
# ディレクティブ定義部
#
file-type:     "FormUrlEncoded"  # フォームURLエンコード形式ファイル
text-encoding: "UTF-8"  # 文字列型フィールドの文字エンコーディング

#
# データレコード定義部
#
[data]
1    key1   X      # 項目1
2    key2   X      # 項目2
```

<details>
<summary>keywords</summary>

file-type, FormUrlEncoded, フォーマット定義, text-encoding, ディレクティブ

</details>

## フィールドタイプ・フィールドコンバータ定義一覧

**フィールドタイプ**

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| X、N、XN、X9、SX9 | String | すべてのフィールドをString型として読み書き。どのタイプ識別子を指定しても動作は変わらない。フィールド長の概念がないため引数不要。Number型（BigDecimal等）を扱う場合はnumber/signed_numberコンバータを使用すること |

**フィールドコンバータ**

| コンバータ名 | Java型(変換前後) | 内容 |
|---|---|---|
| リテラル値 | Object <-> Object | 入力時: 何もしない。出力時: 値が未設定の場合に指定リテラル値を出力。デフォルト実装: `nablarch.core.dataformat.convertor.value.DefaultValue`。引数: なし |
| number | String <-> BigDecimal | 入力時: 符号なし数値チェック後BigDecimal型に変換。null/空文字はnullを返却。出力時: 文字列変換後符号なし数値チェックして出力。nullは空文字を出力。デフォルト実装: `nablarch.core.dataformat.convertor.value.NumberString`。引数: なし |
| signed_number | String <-> BigDecimal | 符号を許可する点以外はnumberと同仕様。デフォルト実装: `nablarch.core.dataformat.convertor.value.SignedNumberString`。引数: なし |

<details>
<summary>keywords</summary>

number, signed_number, DefaultValue, NumberString, SignedNumberString, BigDecimal, フィールドタイプ, フィールドコンバータ, X N XN X9 SX9

</details>

## 同一キーで複数の値を取り扱う場合

同一キーで複数値を扱う場合、データはString配列形式で保持される。フォーマット定義ファイルで多重度を設定する必要がある。定義方法についてはNablarch Application Framework解説書の汎用データフォーマット機能を参照すること。

<details>
<summary>keywords</summary>

String配列, 多重度, 同一キー複数値, 配列型フィールド

</details>

## テストデータの記述方法

FormUrlEncoded形式のテストデータはURLエンコードが必要だが、Excelに直接URLエンコード済みデータを記述することは可読性・保守性の観点から非現実的。テストデータコンバータを使用して対応する。

**コンポーネント設定ファイル（テスト側）**:

```xml
<!-- テストデータコンバータ定義 -->
<component name="TestDataConverter_FormUrlEncoded"
           class="please.change.me.test.core.file.FormUrlEncodedTestDataConverter"/>
```

**Excelファイル**: file-typeに`"FormUrlEncoded"`を指定し、テストデータとして項目ごとにKey=Value形式で記述する。

![テストデータ例](../../../knowledge/guide/biz-samples/assets/biz-samples-0401_ExtendedDataFormatter/test_data_example.png)

テストフレームワークがテストデータ読み込み時に`FormUrlEncodedTestDataConverter`を呼び出し、Value部を動的にURLエンコードしてフォーマッタに渡す（例: `kanjiName=%E6%BC%A2%E5%AD%97%E6%B0%8F%E5%90%8D&kanaName=%E3%82%AB%E3%83%8A%E3%82%B7%E3%83%A1%E3%82%A4&mailAddr=test%40anydomain.com`）。

<details>
<summary>keywords</summary>

FormUrlEncodedTestDataConverter, URLエンコーディング, テストデータ, TestDataConverter_FormUrlEncoded, Excelテストデータ

</details>
