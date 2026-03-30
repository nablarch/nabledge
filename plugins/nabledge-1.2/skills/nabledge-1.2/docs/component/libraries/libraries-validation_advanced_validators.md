# 拡張バリデータ・コンバータ

## 拡張バリデータ・コンバータの概要と制約

拡張バリデータ・コンバータの精査仕様は変更できない。

精査仕様とは異なる精査を行いたい場合:
- **バリデータ**: :ref:`add-validation-method` を参照して個別にバリデータを追加すること
- **コンバータ**: [StringConvertor](libraries-validation_basic_validators.md) のextendedStringConvertors欄を参照して個別にコンバータを追加すること

<details>
<summary>keywords</summary>

拡張バリデータ, 拡張コンバータ, 精査仕様変更不可, カスタムバリデータ追加, add-validation-method, extendedStringConvertors, StringConvertor

</details>

## 年月日コンバータ

**クラス**: `nablarch.common.date.YYYYMMDDConvertor`
**アノテーション**: `@YYYYMMDD`

`YYYYMMDDConvertor`を使用するには、[StringConvertor](libraries-validation_basic_validators.md)のextendedStringConvertors属性に設定する必要がある。

**コンバータ設定プロパティ**:

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| parseFailedMessageId | ○ | 日付の精査に失敗した際のメッセージID（例："{0}は有効な日付ではありません。"） |

**アノテーション属性**:

| 属性名 | 必須 | 説明 |
|---|---|---|
| allowFormat | ○ | 入力値として許容する年月日フォーマット。`java.text.SimpleDateFormat`の構文で指定。パターン文字はy(年)・M(月)・d(日)のみ使用可能。 |
| messageId | | 日付の精査に失敗した際のメッセージID。未指定時はYYYYMMDDConvertorに設定されたメッセージIDを使用。 |

> **注意**: カスタムタグの:ref:`WebView_TextTag`で年月日フォーマットが指定された場合は、`@YYYYMMDD`のallowFormat属性ではなく、textタグで指定されたフォーマットが精査に使用される。[web_view_format](libraries-07_DisplayTag.md)を参照。

**精査仕様**:
- 必須精査は行わない（[validate-requiredvalidator-setting](libraries-validation_basic_validators.md)を使用すること）
- 指定フォーマット、またはフォーマットから区切り文字を除いたパターンで解析できること

| フォーマット | 入力値 | 結果 |
|---|---|---|
| "yyyy/MM/dd" | "2011/09/28" | OK（フォーマット通り） |
| "yyyy/MM/dd" | "20110928" | OK（区切り文字除去後のフォーマット通り） |
| "yyyy/MM/dd" | "2011/02/29" | NG（存在しない日付） |
| "yyyy/MM/dd" | "2011-09-28" | NG（区切り文字が異なる） |
| "yyyy/MM/dd" | "2011928" | NG（区切り文字除去後のフォーマットに1桁不足） |

**変換仕様**: 入力値を"yyyyMMdd"形式の年月日文字列に変換する。精査後に生成するFormオブジェクトの該当プロパティには変換後の年月日文字列が設定される。

**実装例**:

```java
private String date;

@YYYYMMDD(allowFomat = "yyyy/MM/dd")
public void setDate(String date) {
    this.date = date;
}
```

<details>
<summary>keywords</summary>

YYYYMMDDConvertor, @YYYYMMDD, nablarch.common.date.YYYYMMDDConvertor, parseFailedMessageId, allowFormat, messageId, 年月日バリデーション, 日付フォーマット変換, yyyyMMdd形式変換, extendedStringConvertors

</details>

## 年月コンバータ

**クラス**: `nablarch.common.date.YYYYMMConvertor`
**アノテーション**: `@YYYYMM`

年月を扱う点以外は年月日コンバータ（`YYYYMMDDConvertor` / `@YYYYMMDD`）と同様。

**精査仕様例**:

| フォーマット | 入力値 | 結果 |
|---|---|---|
| "yyyy/MM" | "2011/09" | OK（フォーマット通り） |
| "yyyy/MM" | "201109" | OK（区切り文字除去後のフォーマット通り） |
| "yyyy/MM" | "2011/13" | NG（存在しない日付） |
| "yyyy/MM/dd" | "2011-09" | NG（区切り文字が異なる） |
| "yyyy/MM" | "20119" | NG（区切り文字除去後のフォーマットに1桁不足） |

**変換仕様**: 入力値を"yyyyMM"形式の年月文字列に変換する（年月を扱う点以外は年月日コンバータと同様）。

<details>
<summary>keywords</summary>

YYYYMMConvertor, @YYYYMM, nablarch.common.date.YYYYMMConvertor, 年月バリデーション, yyyyMM形式変換, 年月フォーマット変換

</details>
