# データフォーマッタ機能におけるフィールドタイプの拡張

**公式ドキュメント**: [データフォーマッタ機能におけるフィールドタイプの拡張](https://nablarch.github.io/docs/LATEST/doc/biz_samples/04/0402_ExtendedFieldType.html)

## イントロダクション

本サンプルはフォーマッタ機能のフィールドタイプ拡張仕様を提供する。基本となる汎用データフォーマット機能の詳細は :ref:`data_format` を参照すること。

<details>
<summary>keywords</summary>

データフォーマッタ, フィールドタイプ拡張, data_format, 汎用データフォーマット機能

</details>

## 概要

EBCDIC(CP930)のダブルバイト文字は、接続先システムにより以下の2パターンが存在し、それぞれ対応が必要:

- シフトコード付き: 項目前後にシフトコードを付与するケース
- シフトコード無し: ホストコンピュータとのデータ連携などで、シフトアウト状態で始まることを想定しシフトコードを付与しないケース

> **重要**: NablarchデフォルトのDoubleByteCharacterStringはShift_JIS/MS932の全角文字フィールド向けであり、EBCDIC(CP930)使用時は各プロジェクトによる拡張が必要。

シフトコードが付与されるかどうかはJDKに依存（CP930はダブルバイト文字に必ずシフトコードを付加）。本サンプルのデータタイプを使用することで、透過的にシフトコードの付加・除去を行い、文字列化やバイトシーケンスへのエンコードが可能となる。

<details>
<summary>keywords</summary>

EBCDIC, CP930, シフトコード, DoubleByteCharacterString, ダブルバイト文字列, シフトコード付き, シフトコード無し

</details>

## 提供パッケージ

**パッケージ**: `please.change.me.core.dataformat.convertor.datatype`

<details>
<summary>keywords</summary>

please.change.me.core.dataformat.convertor.datatype, フィールドタイプ, パッケージ

</details>

## フィールドタイプの構成

EBCDIC(CP930)固定長ファイルの全角文字列項目に対応するデータタイプクラス:

| パッケージ名 | クラス名 | 概要 |
|---|---|---|
| `please.change.me.core.dataformat.convertor.datatype` | `EbcdicDoubleByteCharacterString` | EBCDIC(CP930)ダブルバイト文字列対応。固定長フォーマットの全角文字フィールド入出力用。入出力バイトデータに**シフトコードが付与されるケース**向け。 |
| `please.change.me.core.dataformat.convertor.datatype` | `EbcdicNoShiftCodeDoubleByteCharacterString` | EBCDIC(CP930)ダブルバイト文字列対応。固定長フォーマットの全角文字フィールド入出力用。入出力バイトデータに**シフトコードが付与されないケース**向け。 |

<details>
<summary>keywords</summary>

EbcdicDoubleByteCharacterString, EbcdicNoShiftCodeDoubleByteCharacterString, EBCDIC, CP930, フィールドタイプクラス, シフトコード

</details>

## フィールドタイプの使用方法

フィールドタイプの追加方法は :ref:`data_format-field_type_add` を参照。Fixed(固定長)フォーマットのファクトリクラス実装例:

```java
public class EbcdicFixedLengthConvertorFactory extends FixedLengthConvertorFactory {
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

EbcdicFixedLengthConvertorFactory, FixedLengthConvertorFactory, getDefaultConvertorTable, フィールドタイプ追加, ESN, EN, data_format-field_type_add, CaseInsensitiveMap

</details>

## フィールドタイプ・フィールドコンバータ定義一覧

**フィールドタイプ**

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| ESN | String | ダブルバイト文字列 (バイト長 = 文字数 × 2 + 2(シフトコード分))。全角空白による右トリム・パディング(デフォルト)。入力時: シフトアウト・シフトインコード付き状態のままを文字列化。出力時: シフトアウト・シフトインコードを自動付加。実装クラス: `please.change.me.core.dataformat.converter.datatype.EbcdicDoubleByteCharacterString`。引数: バイト長(数値、必須) |
| EN | String | ダブルバイト文字列 (バイト長 = 文字数 × 2)。全角空白による右トリム・パディング(デフォルト)。入力時: シフトアウト・シフトインコードを内部で補完して文字列化。出力時: シフトコードを付加しない。実装クラス: `please.change.me.core.dataformat.converter.datatype.EbcdicNoShiftCodeDoubleByteCharacterString`。引数: バイト長(数値、必須) |

<details>
<summary>keywords</summary>

ESN, EN, ダブルバイト文字列, EbcdicDoubleByteCharacterString, EbcdicNoShiftCodeDoubleByteCharacterString, バイト長, シフトコード

</details>
