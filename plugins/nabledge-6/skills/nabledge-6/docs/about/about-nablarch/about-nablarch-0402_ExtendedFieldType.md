# データフォーマッタ機能におけるフィールドタイプの拡張

## 導入

フォーマッタ機能の概要、基本となる汎用データフォーマット機能に関する詳細は、:ref:`data_format` を参照すること。

## 概要

EBCDIC（CP930）のダブルバイト文字データ連携では、接続先システムのインターフェースにより、シフトコード付与の有無が異なる。本サンプルは両方に対応するため、シフトコード付きEBCDIC（CP930）とシフトコード無しEBCDIC（CP930）の2つのデータタイプクラスを提供する。

> **重要**: Nablarchデフォルトの`DoubleByteCharacterString`はShift_JIS/MS932を想定。EBCDIC（CP930）では各プロジェクトによる拡張が必要。JDKで使用されるCP930はダブルバイト文字に必ずシフトコードが付加されている必要がある。

このデータタイプは透過的にシフトコードを付加・除去し、上記の差を吸収して文字列化やバイトシーケンスへのエンコードを可能にする。

## 提供パッケージ

本機能は、下記のパッケージで提供される。

**パッケージ**: `please.change.me.core.dataformat.convertor.datatype`

## フィールドタイプの構成

| パッケージ名 | クラス名 | 概要 |
|---|---|---|
| `please.change.me.core.dataformat.convertor.datatype` | `EbcdicDoubleByteCharacterString` | EBCDIC(CP930)のダブルバイト文字列。固定長フォーマットの全角文字フィールド入出力用。入出力バイトデータに**シフトコード付与**を想定。 |
| `please.change.me.core.dataformat.convertor.datatype` | `EbcdicNoShiftCodeDoubleByteCharacterString` | EBCDIC(CP930)のダブルバイト文字列。固定長フォーマットの全角文字フィールド入出力用。入出力バイトデータに**シフトコード無し**を想定。 |

## フィールドタイプの使用方法

追加したフィールドタイプの使用方法は :ref:`data_format-field_type_add` を参照。

Fixed(固定長)フォーマットのファクトリクラス実装例:

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

## フィールドタイプ・フィールドコンバータ定義一覧

**フィールドタイプ**

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| ESN | String | ダブルバイト文字列 (バイト長 = 文字数 × 2 + 2(シフトコード分))<br>デフォルト: 全角空白による右トリム・パディング<br>入力: シフトアウト・シフトインコード付加状態を想定し文字列化<br>出力: シフトアウト・シフトインコードを自動付加<br>**クラス**: `please.change.me.core.dataformat.converter.datatype.EbcdicDoubleByteCharacterString`<br>**引数**: バイト長(数値、必須) |
| EN | String | ダブルバイト文字列 (バイト長 = 文字数 × 2)<br>デフォルト: 全角空白による右トリム・パディング<br>入力: シフトアウト・シフトインコードを内部補完して文字列化<br>出力: シフトアウト・シフトインコードを付加しない<br>**クラス**: `please.change.me.core.dataformat.converter.datatype.EbcdicNoShiftCodeDoubleByteCharacterString`<br>**引数**: バイト長(数値、必須) |
