# 拡張バリデータ・コンバータ

## 

拡張バリデータ・コンバータの精査仕様は変更できない。精査仕様が要件に合わない場合は個別に追加する。

- バリデータ: :ref:`add-validation-method` を参照して追加
- コンバータ: [StringConvertor](libraries-validation_basic_validators.md) のextendedStringConvertors欄を参照して追加

<details>
<summary>keywords</summary>

拡張バリデータ, 拡張コンバータ, 精査仕様変更不可, バリデータ追加, コンバータ追加, extendedStringConvertors

</details>

## 年月日コンバータ

入力値を年月日として精査し、システム内部で使用する8桁の年月日文字列（yyyyMMdd形式）に変換する。

**コンバータクラス**: `nablarch.common.date.YYYYMMDDConvertor`
**アノテーション**: `@YYYYMMDD`

YYYYMMDDConvertorはStringConvertorのextendedStringConvertors属性に設定する必要がある（[StringConvertor](libraries-validation_basic_validators.md) 参照）。

## コンバータ設定プロパティ

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| parseFailedMessageId | ○ | 日付の精査に失敗した際のメッセージID |

## アノテーション属性

| 属性名 | 必須 | 説明 |
|---|---|---|
| allowFormat | ○ | 入力値として許容する年月日フォーマット（java.text.SimpleDateFormat構文; パターン文字はy/M/dのみ使用可） |
| messageId | | 日付の精査失敗時のメッセージID（未指定時はYYYYMMDDConvertorのparseFailedMessageIdを使用） |

> **注意**: :ref:`WebView_TextTag` でフォーマット指定された場合、allowFormat属性ではなくtextタグのフォーマットが精査に使用される（[web_view_format](libraries-07_DisplayTag.md) 参照）。

## 精査仕様

- 必須精査は行わない（[validate-requiredvalidator-setting](libraries-validation_basic_validators.md) を使用すること）
- 指定フォーマット、または区切り文字を除いたフォーマットで解析できること

| フォーマット | 入力値 | 結果 |
|---|---|---|
| "yyyy/MM/dd" | "2011/09/28" | OK |
| "yyyy/MM/dd" | "20110928" | OK（区切り文字除去フォーマット） |
| "yyyy/MM/dd" | "2011/02/29" | NG（存在しない日付） |
| "yyyy/MM/dd" | "2011-09-28" | NG（区切り文字が異なる） |
| "yyyy/MM/dd" | "2011928" | NG（区切り文字除去フォーマットより1桁少ない） |

## 変換仕様

入力値を"yyyyMMdd"形式の年月日文字列に変換する。

## 実装例

```java
@YYYYMMDD(allowFomat = "yyyy/MM/dd")
public void setDate(String date) {
    this.date = date;
}
```

<details>
<summary>keywords</summary>

YYYYMMDDConvertor, @YYYYMMDD, 年月日コンバータ, parseFailedMessageId, allowFormat, messageId, 日付フォーマット精査, yyyyMMdd変換, 8桁年月日

</details>

## 年月コンバータ

入力値を年月として精査し、システム内部で使用する6桁の年月文字列（yyyyMM形式）に変換する。年月日コンバータとほぼ同様の機能で、年月日ではなく年月を扱う点が異なる。

**コンバータクラス**: `nablarch.common.date.YYYYMMConvertor`
**アノテーション**: `@YYYYMM`

## 精査仕様

指定フォーマット、または区切り文字を除いたフォーマットで解析できること（必須精査は行わない）。

| フォーマット | 入力値 | 結果 |
|---|---|---|
| "yyyy/MM" | "2011/09" | OK |
| "yyyy/MM" | "201109" | OK（区切り文字除去フォーマット） |
| "yyyy/MM" | "2011/13" | NG（存在しない日付） |
| "yyyy/MM/dd" | "2011-09" | NG（区切り文字が異なる） |
| "yyyy/MM" | "20119" | NG（区切り文字除去フォーマットより1桁少ない） |

## 変換仕様

入力値を"yyyyMM"形式の年月文字列に変換する。

## 実装例

年月日コンバータと同様（allowFormat属性に年月フォーマットを指定する）。

<details>
<summary>keywords</summary>

YYYYMMConvertor, @YYYYMM, 年月コンバータ, 6桁年月, yyyyMM変換, 年月コンバータ精査仕様, 年月フォーマット検証, 年月バリデーション, 年月精査仕様テーブル

</details>
