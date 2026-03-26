# データフォーマッタ機能におけるフィールドタイプの拡張

## 

なし

<details>
<summary>keywords</summary>

データフォーマッタ, フィールドタイプ拡張, EBCDIC, CP930, ダブルバイト文字

</details>

## 概要

EBCDIC(CP930)のダブルバイト文字データ連携では、接続先システムのインターフェースによりシフトコードが付与される場合とされない場合があるため、それぞれに対応するデータタイプクラスが必要。

Nablarchデフォルトの`DoubleByteCharacterString`はShift_JIS/MS932の全角文字フィールド用であり、EBCDIC(CP930)を扱う場合は各プロジェクトによる拡張が必要。

本サンプルが提供するデータタイプ:
- シフトコード付きEBCDIC(CP930)用: `EbcdicDoubleByteCharacterString`
- シフトコード無しEBCDIC(CP930)用: `EbcdicNoShiftCodeDoubleByteCharacterString`

> **注意**: CP930はダブルバイト文字に対して必ずシフトコードが付加されている必要がある(JDK依存)。本データタイプを使用することで、シフトコードの付加・除去を透過的に行い文字列化・エンコードが可能。

<details>
<summary>keywords</summary>

EbcdicDoubleByteCharacterString, EbcdicNoShiftCodeDoubleByteCharacterString, DoubleByteCharacterString, EBCDIC CP930, シフトコード, ダブルバイト文字列

</details>

## 提供パッケージ

**パッケージ**: `please.change.me.core.dataformat.convertor.datatype`

<details>
<summary>keywords</summary>

please.change.me.core.dataformat.convertor.datatype, 提供パッケージ, データタイプクラス

</details>

## フィールドタイプの構成

EBCDIC(CP930)固定長ファイルの全角文字列項目に対応するフィールドタイプクラス:

| パッケージ名 | クラス名 | 概要 |
|---|---|---|
| `please.change.me.core.dataformat.convertor.datatype` | `EbcdicDoubleByteCharacterString` | EBCDIC(CP930)ダブルバイト文字列用。固定長のデータフォーマットの全角文字（ダブルバイト文字）フィールドの入出力に利用する。入出力バイトデータに**シフトコードが付与されるケース**用 |
| `please.change.me.core.dataformat.convertor.datatype` | `EbcdicNoShiftCodeDoubleByteCharacterString` | EBCDIC(CP930)ダブルバイト文字列用。固定長のデータフォーマットの全角文字（ダブルバイト文字）フィールドの入出力に利用する。入出力バイトデータに**シフトコードが付与されないケース**用 |

<details>
<summary>keywords</summary>

EbcdicDoubleByteCharacterString, EbcdicNoShiftCodeDoubleByteCharacterString, シフトコード付き, シフトコード無し, フィールドタイプ構成

</details>

## フィールドタイプの使用方法

`FixedLengthConvertorSetting`の`convertorTable`に`ESN`と`EN`のデータタイプを追加する。

```xml
<component name="fixedLengthConvertorSetting"
    class="nablarch.core.dataformat.convertor.FixedLengthConvertorSetting">
  <property name="convertorTable">
    <map>
      <!-- EBCDIC(CP930)用のデータタイプ ESN, EN を追加する -->
      <entry key="ESN" value="please.change.me.core.dataformat.convertor.datatype.EbcdicDoubleByteCharacterString"/>
      <entry key="EN" value="please.change.me.core.dataformat.convertor.datatype.EbcdicNoShiftCodeDoubleByteCharacterString"/>
      <!-- 以下はデフォルト設定 -->
      <entry key="X" value="nablarch.core.dataformat.convertor.datatype.SingleByteCharacterString"/>
      <entry key="N" value="nablarch.core.dataformat.convertor.datatype.DoubleByteCharacterString"/>
      <entry key="XN" value="nablarch.core.dataformat.convertor.datatype.ByteStreamDataString"/>
      <entry key="Z" value="nablarch.core.dataformat.convertor.datatype.ZonedDecimal"/>
      <entry key="SZ" value="nablarch.core.dataformat.convertor.datatype.SignedZonedDecimal"/>
      <entry key="P" value="nablarch.core.dataformat.convertor.datatype.PackedDecimal"/>
      <entry key="SP" value="nablarch.core.dataformat.convertor.datatype.SignedPackedDecimal"/>
      <entry key="B" value="nablarch.core.dataformat.convertor.datatype.Bytes"/>
      <entry key="X9" value="nablarch.core.dataformat.convertor.datatype.NumberStringDecimal"/>
      <entry key="SX9" value="nablarch.core.dataformat.convertor.datatype.SignedNumberStringDecimal"/>
      <entry key="pad" value="nablarch.core.dataformat.convertor.value.Padding"/>
      <entry key="encoding" value="nablarch.core.dataformat.convertor.value.UseEncoding"/>
      <entry key="_LITERAL_" value="nablarch.core.dataformat.convertor.value.DefaultValue"/>
      <entry key="number" value="nablarch.core.dataformat.convertor.value.NumberString"/>
      <entry key="signed_number" value="nablarch.core.dataformat.convertor.value.SignedNumberString"/>
      <entry key="replacement" value="nablarch.core.dataformat.convertor.value.CharacterReplacer"/>
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

FixedLengthConvertorSetting, convertorTable, ESN, EN, 固定長コンバータ設定, データタイプ登録

</details>

## フィールドタイプ・フィールドコンバータ定義一覧

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| ESN | String | ダブルバイト文字列 (バイト長 = 文字数 × 2 + 2(シフトコード分))。デフォルトで全角空白による右トリム・パディング。入力時はシフトアウト・シフトインコード付きの状態を想定して文字列化、出力時はシフトコードを自動付加。実装クラス: `please.change.me.core.dataformat.converter.datatype.EbcdicDoubleByteCharacterString`。引数: バイト長(数値、必須) |
| EN | String | ダブルバイト文字列 (バイト長 = 文字数 × 2)。デフォルトで全角空白による右トリム・パディング。入力時はシフトコードを内部で補完して文字列化、出力時はシフトコードを付加しない。実装クラス: `please.change.me.core.dataformat.converter.datatype.EbcdicNoShiftCodeDoubleByteCharacterString`。引数: バイト長(数値、必須) |

<details>
<summary>keywords</summary>

ESN, EN, バイト長, フィールドタイプ定義, シフトコード, タイプ識別子

</details>
