# データフォーマッタの拡張

## はじめに

フォーマッタ機能の概要および汎用データフォーマット機能の詳細は :ref:`data_format` を参照。

## 概要

## 概要

Nablarchが提供するフォーマッタ（JSON、XMLなど）以外のフォーマッタを使用する場合、データフォーマッタを追加して対応する。

本サンプルでは、application/x-www-form-urlencoded形式（`Key=Value` を `&` で結合）に対応したフォーマッタの実装例を示す。

## 提供パッケージ

## 提供パッケージ

**パッケージ**:
- `please.change.me.core.dataformat`
- `please.change.me.core.dataformat.convertor`
- `please.change.me.test.core.file`

## FormUrlEncodedデータフォーマッタの構成

## FormUrlEncodedデータフォーマッタの構成

application/x-www-form-urlencoded形式（`name1=value1&name2=value2`）のデータを取り扱う。同一キーで複数値も可能。

**エンコーディング規則**:
- 値: URLエンコードを実施
- キー: URLエンコードなし（汎用データフォーマットの定義書式に従う）。特殊文字使用不可

**クラス一覧**:

| パッケージ | クラス | 概要 |
|---|---|---|
| `please.change.me.core.dataformat` | `FormUrlEncodedDataFormatterFactory` | フォーマッタファクトリ。`createFormatter(String fileType, String formatFilePath)`をオーバーライドして`FormUrlEncodedDataRecordFormatter`を生成 |
| `please.change.me.core.dataformat` | `FormUrlEncodedDataRecordFormatter` | application/x-www-form-urlencodedデータの解析・構築。読込時は出現順非依存、書込時はフォーマット定義順で出力 |
| `please.change.me.core.dataformat.convertor` | `FormUrlEncodedDataConvertorFactory` | コンバータファクトリ。デフォルトのコンバータ名と実装クラスの対応表を保持 |
| `please.change.me.core.dataformat.convertor` | `FormUrlEncodedDataConvertorSetting` | コンバータ設定情報を保持。コンバータ名と実装クラスの対応表をDIコンテナから設定 |
| `please.change.me.test.core.file` | `FormUrlEncodedTestDataConverter` | テストデータコンバータ。Key=Value形式のテストデータを解析し、Value部を動的にURLエンコード |

## 使用方法

## 使用方法

（詳細は以下の各セクションを参照）

## FormUrlEncodedデータフォーマッタの使用方法

## FormUrlEncodedデータフォーマッタの使用方法

作成したフォーマッタファクトリクラスを使用する設定:

```xml
<component name="formatterFactory" class="please.change.me.core.dataformat.FormUrlEncodedDataFormatterFactory"/>
```

## フォーマット定義ファイルの記述例

## フォーマット定義ファイルの記述例

```
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

## フィールドタイプ・フィールドコンバータ定義一覧

## フィールドタイプ・フィールドコンバータ定義一覧

**フィールドタイプ**:

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| X、N、XN、X9、SX9 | String | すべてのフィールドを文字列として読み書き。タイプ識別子による動作の違いはない。フィールド長の概念がないため引数不要。Number型データを扱う場合はnumber/signed_numberコンバータを使用 |

**フィールドコンバータ**:

| コンバータ名 | Java型 | 内容 |
|---|---|---|
| リテラル値 | Object ↔ Object | **入力**: 何もしない<br>**出力**: 値が未設定の場合に指定リテラル値を出力<br>**実装**: `nablarch.core.dataformat.convertor.value.DefaultValue`<br>**引数**: なし |
| number | String ↔ BigDecimal | **入力**: 符号なし数値として形式チェック後BigDecimalに変換。null/空文字の場合null返却<br>**出力**: 文字列に変換後符号なし数値として形式チェック。nullの場合空文字出力<br>**実装**: `nablarch.core.dataformat.convertor.value.NumberString`<br>**引数**: なし |
| signed_number | String ↔ BigDecimal | 符号が許可される点以外はnumberコンバータと同じ<br>**実装**: `nablarch.core.dataformat.convertor.value.SignedNumberString`<br>**引数**: なし |

## 同一キーで複数の値を取り扱う場合

## 同一キーで複数の値を取り扱う場合

同一キーで複数値を扱う場合、データは`String[]`配列形式で保持される。フォーマット定義ファイルで多重度を設定する必要がある。

定義方法は汎用データフォーマット機能のドキュメントを参照。

## テストデータの記述方法

## テストデータの記述方法

FormUrlEncodedデータフォーマッタを使用する場合、入力データをURLエンコーディングする必要があるが、エンコード済みデータをExcelに直接記述することは現実的でない。テストデータコンバータを使用して解決する。

**コンポーネント設定**:

テスト側のコンポーネント設定ファイルに以下を追記:

```xml
<!-- テストデータコンバータ定義 -->
<component name="TestDataConverter_FormUrlEncoded"
           class="please.change.me.test.core.file.FormUrlEncodedTestDataConverter"/>
```

**Excelファイル**:

file-typeに`"FormUrlEncoded"`を指定し、テストデータを項目ごとにKey=Value形式で記述する。

![テストデータ記述例](../../knowledge/about/about-nablarch/assets/about-nablarch-0401_ExtendedDataFormatter/test_data_example.png)

テストフレームワークが`FormUrlEncodedTestDataConverter`を呼び出し、次のようなURLエンコード済みデータに変換:

```
kanjiName=%E6%BC%A2%E5%AD%97%E6%B0%8F%E5%90%8D&kanaName=%E3%82%AB%E3%83%8A%E3%82%B7%E3%83%A1%E3%82%A4&mailAddr=test%40anydomain.com
```
