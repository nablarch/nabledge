# データフォーマッタ機能におけるフィールドタイプの拡張

**公式ドキュメント**: [データフォーマッタ機能におけるフィールドタイプの拡張](https://nablarch.github.io/docs/LATEST/doc/biz_samples/04/0402_ExtendedFieldType.html)

## 

本サンプルはEBCDIC（CP930）のダブルバイト文字を扱うデータフォーマッタ用フィールドタイプ拡張を提供する。汎用データフォーマット機能の概要・詳細は [data_format](../../component/libraries/libraries-data_format.md) を参照。

<details>
<summary>keywords</summary>

データフォーマッタ機能, フィールドタイプ拡張, EBCDIC, CP930, data_format

</details>

## 概要

NablarchデフォルトのDoubleByteCharacterString（ダブルバイト文字列データタイプ）はShift_JIS/MS932の全角文字フィールド用であり、EBCDIC（CP930）を扱う際には各プロジェクトによる拡張が必要。

シフトコードの付与はJDKに依存（CP930はダブルバイト文字に対して必ずシフトコードが付加されている必要がある）。このデータタイプを使用すると、透過的にシフトコードを付加および除去するため、差を吸収して文字列化やバイトシーケンスへのエンコードが可能。

接続先システムのインターフェースによりシフトコードが付与される場合とされない場合があるため、本サンプルでは両方に対応するデータタイプクラスを提供する。

<details>
<summary>keywords</summary>

EBCDIC, CP930, ダブルバイト文字, シフトコード, DoubleByteCharacterString, フィールドタイプ拡張, JDK依存

</details>

## 提供パッケージ

**パッケージ**: `please.change.me.core.dataformat.convertor.datatype`

<details>
<summary>keywords</summary>

please.change.me.core.dataformat.convertor.datatype, 提供パッケージ, EBCDIC, データタイプ

</details>

## フィールドタイプの構成

EBCDIC（CP930）の固定長ファイルの全角文字列項目向けクラス一覧:

| クラス名 | 概要 |
|---|---|
| `EbcdicDoubleByteCharacterString` | 入出力バイトデータに**シフトコードが付与されるケース**を想定。固定長データフォーマットの全角文字フィールドの入出力に使用 |
| `EbcdicNoShiftCodeDoubleByteCharacterString` | 入出力バイトデータに**シフトコードが付与されないケース**を想定。固定長データフォーマットの全角文字フィールドの入出力に使用 |

両クラスのパッケージ: `please.change.me.core.dataformat.convertor.datatype`

<details>
<summary>keywords</summary>

EbcdicDoubleByteCharacterString, EbcdicNoShiftCodeDoubleByteCharacterString, シフトコード付き, シフトコード無し, 固定長フォーマット

</details>

## フィールドタイプの使用方法

フィールドタイプ追加方法は [data_format-field_type_add](../../component/libraries/libraries-data_format.md) を参照。Fixed（固定長）フォーマットのファクトリクラス実装例:

```java
public class CustomFixedLengthConvertorFactory extends FixedLengthConvertorFactory {
    @Override
    protected Map<String, Class<?>> getDefaultConvertorTable() {
        final Map<String, Class<?>> defaultConvertorTable = new CaseInsensitiveMap<Class<?>>(
                new ConcurrentHashMap<String, Class<?>>(super.getDefaultConvertorTable()));
        // EBCDIC(CP930)用のデータタイプ ESN, EN を追加する
        defaultConvertorTable.put("ESN", EbcdicDoubleByteCharacterString.class);
        defaultConvertorTable.put("EN", EbcdicNoShiftCodeDoubleByteCharacterString.class);
        return Collections.unmodifiableMap(defaultConvertorTable);
    }
}
```

<details>
<summary>keywords</summary>

CustomFixedLengthConvertorFactory, FixedLengthConvertorFactory, ESN, EN, getDefaultConvertorTable, data_format-field_type_add

</details>

## フィールドタイプ・フィールドコンバータ定義一覧

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| ESN | String | ダブルバイト文字列（バイト長 = 文字数 × 2 + 2(シフトコード分)）。全角空白による右トリム・パディング。入力時はシフトアウト・シフトイン付き状態を想定し文字列化、出力時はシフトアウト・シフトインを自動付加。引数: バイト長（数値、必須）。実装クラス: `please.change.me.core.dataformat.converter.datatype.EbcdicDoubleByteCharacterString` |
| EN | String | ダブルバイト文字列（バイト長 = 文字数 × 2）。全角空白による右トリム・パディング。入力時はシフトアウト・シフトインを内部補完して文字列化、出力時はシフトコードを付加しない。引数: バイト長（数値、必須）。実装クラス: `please.change.me.core.dataformat.converter.datatype.EbcdicNoShiftCodeDoubleByteCharacterString` |

<details>
<summary>keywords</summary>

ESN, EN, EbcdicDoubleByteCharacterString, EbcdicNoShiftCodeDoubleByteCharacterString, バイト長, シフトコード, ダブルバイト文字列

</details>
