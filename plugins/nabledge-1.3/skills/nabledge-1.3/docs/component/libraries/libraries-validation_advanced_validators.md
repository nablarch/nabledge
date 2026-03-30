# 拡張バリデータ・コンバータ

## 年月日コンバータ

拡張バリデータ・コンバータの精査仕様は変更できない。下記に示す精査仕様とは異なる精査を行う場合は、バリデータの場合は :ref:`add-validation-method` を参照して個別にバリデータを追加すること。コンバータの場合は [StringConvertor](libraries-validation_basic_validators.md) のextendedStringConvertors欄を参照して個別にコンバータを追加すること。

**クラス**: `nablarch.common.date.YYYYMMDDConvertor`
**アノテーション**: `@YYYYMMDD`

`YYYYMMDDConvertor`は`StringConvertor`の`extendedStringConvertors`属性に拡張コンバータとして設定する必要がある（[StringConvertor](libraries-validation_basic_validators.md) 参照）。

精査と同時に入力値を`yyyyMMdd`形式の8桁年月日文字列に変換する。変換後の文字列がFormオブジェクトのプロパティに設定される。

**コンバータ設定値**:

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| parseFailedMessageId | ○ | 日付精査失敗時のメッセージID（例: `{0}は有効な日付ではありません。`） |

**@YYYYMMDD アノテーション属性**:

| 属性名 | 必須 | 説明 |
|---|---|---|
| allowFormat | ○ | 許容する年月日フォーマット（`java.text.SimpleDateFormat`構文）。パターン文字はy（年）、M（月）、d（日）のみ指定可能 |
| messageId | | 日付精査失敗時のメッセージID。未指定時は`YYYYMMDDConvertor`に設定されたメッセージIDを使用 |

> **注意**: カスタムタグの :ref:`WebView_TextTag` で年月日フォーマットが指定された場合、`@YYYYMMDD`の`allowFormat`ではなく、textタグのフォーマットが精査に使用される（[web_view_format](libraries-07_DisplayTag.md) 参照）。

**精査仕様**:
- 必須精査は行わない（[validate-requiredvalidator-setting](libraries-validation_basic_validators.md) で精査すること）
- 指定フォーマット、または年月日の区切り文字を除去したフォーマットで解析できること

| フォーマット | 入力値 | 結果 |
|---|---|---|
| `yyyy/MM/dd` | `2011/09/28` | OK（フォーマット通り） |
| `yyyy/MM/dd` | `20110928` | OK（区切り文字除去後のフォーマット通り） |
| `yyyy/MM/dd` | `2011/02/29` | NG（存在しない日付） |
| `yyyy/MM/dd` | `2011-09-28` | NG（区切り文字が異なる） |
| `yyyy/MM/dd` | `2011928` | NG（区切り文字除去後のフォーマットに1桁不足） |

**変換仕様**: 入力値を`yyyyMMdd`形式の8桁年月日文字列に変換する。

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

YYYYMMDDConvertor, nablarch.common.date.YYYYMMDDConvertor, @YYYYMMDD, parseFailedMessageId, allowFormat, messageId, extendedStringConvertors, 年月日バリデーション, 日付コンバータ, 年月日フォーマット精査, yyyyMMdd, SimpleDateFormat, add-validation-method, カスタムバリデータ追加

</details>

## 年月コンバータ

**クラス**: `nablarch.common.date.YYYYMMConvertor`
**アノテーション**: `@YYYYMM`

年月日コンバータ（:ref:`ExtendedValidation_yyyymmddConvertor`）とほぼ同様の機能。年月日の代わりに6桁の年月文字列（`yyyyMM`形式）を扱う点のみが異なる。

**精査仕様**（年月日コンバータとの差分）:

| フォーマット | 入力値 | 結果 |
|---|---|---|
| `yyyy/MM` | `2011/09` | OK（フォーマット通り） |
| `yyyy/MM` | `201109` | OK（区切り文字除去後のフォーマット通り） |
| `yyyy/MM` | `2011/13` | NG（存在しない月） |
| `yyyy/MM/dd` | `2011-09` | NG（区切り文字が異なる） |
| `yyyy/MM` | `20119` | NG（区切り文字除去後のフォーマットに1桁不足） |

**変換仕様**: 入力値を`yyyyMM`形式の6桁年月文字列に変換する。

<details>
<summary>keywords</summary>

YYYYMMConvertor, nablarch.common.date.YYYYMMConvertor, @YYYYMM, 年月バリデーション, 年月コンバータ, yyyyMM, 年月フォーマット精査

</details>
