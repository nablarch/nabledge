# フォーマッタ機能の拡張

## 

本サンプルで提供するフォーマッタ機能の仕様を解説する。汎用データフォーマット機能の概要および詳細はNablarch Application Framework解説書の汎用データフォーマット機能に関する解説を参照すること。

<details>
<summary>keywords</summary>

フォーマッタ機能の拡張, 汎用データフォーマット機能, フォーマッタ拡張サンプル

</details>

## 提供パッケージ

提供パッケージ:
- `please.change.me.core.dataformat`
- `please.change.me.core.dataformat.converter`

<details>
<summary>keywords</summary>

please.change.me.core.dataformat, please.change.me.core.dataformat.converter, 提供パッケージ

</details>

## 

KeyValueデータフォーマッタは `application/x-www-form-urlencoded` 形式のデータを処理する。データ形式: `name1=value1&name2=value2`（名前と値を `=` で結び `&` で区切る）。

**制約:**
- 値: URLエンコードを行う
- キー: URLエンコード不可（汎用データフォーマットのフォーマット定義書式に従い使用不可）
- 同一キーで複数の値を扱うことが可能

<details>
<summary>keywords</summary>

KeyValueデータフォーマッタ, application/x-www-form-urlencoded, URLエンコード, KeyValue形式, 同一キー複数値

</details>

## KeyValueデータフォーマッタ

| パッケージ | クラス名 | 概要 |
|---|---|---|
| `please.change.me.core.dataformat` | `KeyValueDataFormatterFactory` | フォーマッタファクトリクラス。`createFormatter(String fileType, String formatFilePath)` をオーバーライドし、`KeyValueDataRecordFormatter` のインスタンス生成を可能とする。 |
| `please.change.me.core.dataformat` | `KeyValueDataRecordFormatter` | フォーマッタクラス。KeyValue形式データの解析・構築。読み込み時はパラメータ出現順に依存しない。書き込み時はフォーマット定義順で出力する。 |
| `please.change.me.core.dataformat.converter` | `KeyValueDataConvertorFactory` | データコンバータのファクトリクラス。デフォルトのコンバータ名とコンバータ実装クラスの対応表を保持する。 |
| `please.change.me.core.dataformat.converter` | `KeyValueDataConvertorSetting` | コンバータ設定情報クラス。コンバータ名と実装クラスの対応表をDIコンテナから設定する。 |

<details>
<summary>keywords</summary>

KeyValueDataFormatterFactory, KeyValueDataRecordFormatter, KeyValueDataConvertorFactory, KeyValueDataConvertorSetting, フォーマッタクラス一覧, コンバータファクトリ

</details>

## KeyValueデータフォーマッタの使用方法

業務アプリケーションでフォーマッタファクトリクラスを使用する場合、以下のコンポーネント設定が必要:

```xml
<component name="formatterFactory" class="please.change.me.core.dataformat.KeyValueDataFormatterFactory"/>
```

<details>
<summary>keywords</summary>

KeyValueDataFormatterFactory, formatterFactory, XMLコンポーネント設定, フォーマッタファクトリ設定

</details>

## フィールドタイプ・フィールドコンバータ定義一覧

**フィールドタイプ**

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| X、N、XN、X9、SX9 | String | KeyValueデータ形式ではすべてのフィールドをStringとして読み書きする。どのタイプ識別子を指定しても動作は変わらない。フィールド長の概念がないため引数は不要。Number型（BigDecimalなど）を読み書きしたい場合は `number`/`signed_number` コンバータを使用する。 |

**フィールドコンバータ**

| コンバータ名 | Java型(変換前後) | 内容 |
|---|---|---|
| リテラル値 | Object <-> Object | **入力時:** 何もしない。**出力時:** 値が未設定の場合に指定されたリテラル値を出力する。デフォルト実装クラス: `nablarch.core.dataformat.convertor.value.DefaultValue`。引数: なし。 |
| number | String <-> BigDecimal | **入力時:** 符号なし数値であることを形式チェックしBigDecimalに変換。null/空文字の場合はnullを返す。**出力時:** 文字列に変換し符号なし数値であることをチェック。nullの場合は空文字を出力。デフォルト実装クラス: `nablarch.core.dataformat.convertor.value.NumberString`。引数: なし。 |
| signed_number | String <-> BigDecimal | 符号が許可される点以外は `number` コンバータと同じ仕様。デフォルト実装クラス: `nablarch.core.dataformat.convertor.value.SignedNumberString`。引数: なし。 |

<details>
<summary>keywords</summary>

フィールドタイプ, フィールドコンバータ, リテラル値, number, signed_number, NumberString, SignedNumberString, DefaultValue, BigDecimal, X, N, XN, X9, SX9

</details>

## 同一キーで複数の値を取り扱う場合

同一キーで複数の値を取り扱う場合、データはString配列形式で保持される。フォーマット定義ファイルにて多重度を設定する必要がある。定義方法はNablarch Application Framework解説書の汎用データフォーマット機能を参照。

<details>
<summary>keywords</summary>

同一キー, 複数値, String配列, 多重度, フォーマット定義ファイル

</details>
