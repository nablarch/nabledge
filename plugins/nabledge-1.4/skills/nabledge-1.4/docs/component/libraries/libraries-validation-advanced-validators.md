# 拡張バリデータ・コンバータ

本フレームワークが提供する基本となるバリデータ・コンバータの他に提供する利便的に拡張されたバリデータおよび拡張されたコンバータに関して記述する。
バリデーション機能の概要、基本となるバリデーションに関する詳細は、 [バリデーションとFormの生成](../../component/libraries/libraries-08-Validation.md#validation-and-form) を参照。

拡張バリデータ・コンバータの精査仕様は変更できない。
バリデータについて下記に示す精査仕様とは異なる精査を行う場合は、バリデータの場合は [バリデータの追加・変更](../../component/libraries/libraries-08-05-custom-validator.md#add-validation-method) 、
コンバータの場合は [StringConvertor](../../component/libraries/libraries-validation-basic-validators.md#stringconvertor-setting) のextendedStringConvertors欄をそれぞれ参照して
個別にバリデータまたはコンバータを追加すること。

## 年月日コンバータ

年月日に関する精査機能、システムが内部で使用する8桁の年月日を表す文字列(以降は年月日文字列と称す)への変換機能に関して解説する。

本機能では精査を行うと同時に、入力値をシステムが内部で使用する年月日文字列へ変換を行う。
精査後に生成するFormオブジェクトの該当プロパティには変換後の年月日文字列が設定される。

年月日コンバータで使用するコンバータとアノテーションを下記に示す。

| コンバータクラス名 | 対応するアノテーション |
|---|---|
| nablarch.common.date.YYYYMMDDConvertor | @YYYYMMDD |

YYYYMMDDConvertorを使用するには、StringConvertorの拡張コンバータとして、StringConvertorのextendedStringConvertors属性に設定する必要がある。
設定方法は、  [StringConvertor](../../component/libraries/libraries-validation-basic-validators.md#stringconvertor-setting) を参照。

コンバータに設定可能な設定値は下記のとおりである。

| property名 | 設定内容 |
|---|---|
| parseFailedMessageId(必須) | 日付の精査に失敗した際のメッセージID  例 : "{0}は有効な日付ではありません。" |

アノテーションに設定可能な属性値は下記のとおりである。

| 属性名 | 設定内容 |
|---|---|
| allowFormat(必須) | 入力値として許容する年月日フォーマット。java.text.SimpleDateFormatが規定している構文で指定する。パターン文字は、y(年)、M(月)、d(月における日)のみ指定可能。 |
| messageId | 日付の精査に失敗した際のメッセージID  例 : "{0}は有効な日付ではありません。"  messageId属性の指定がない場合はYYYYMMDDConvertorに設定されたメッセージIDが使用される。 |

> **Note:**
> カスタムタグの [textタグ](../../component/libraries/libraries-07-TagReference.md#webview-texttag) で年月日のフォーマットが指定された場合は、
> YYYYMMDDアノテーションのallowFormat属性でなく、
> textタグで指定されたフォーマットが精査に使用される。
> textタグのフォーマット指定については、 [値のフォーマット出力](../../component/libraries/libraries-07-DisplayTag.md#web-view-format) を参照。

### 精査仕様

精査仕様は下記のとおりである。

* 必須精査は行わない。（ [nablarch.core.validation.validator.RequiredValidator](../../component/libraries/libraries-validation-basic-validators.md#validate-requiredvalidator-setting) を用いて精査すること。）
* 指定されたフォーマットまたは指定されたフォーマットから年月日の区切り文字を取り除いたフォーマットで解析できること。

  | フォーマット | 入力値 | バリデーション結果 |
  |---|---|---|
  | "yyyy/MM/dd" | "2011/09/28" | OK。フォーマット通り。 |
  | "yyyy/MM/dd" | "20110928" | OK。年月日の区切り文字を取り除いたフォーマット通り。 |
  | "yyyy/MM/dd" | "2011/02/29" | NG。存在しない日付(閏年以外の年の2/29)。 |
  | "yyyy/MM/dd" | "2011-09-28" | NG。年月日の区切り文字が異なる。 |
  | "yyyy/MM/dd" | "2011928" | NG。年月日の区切り文字を取り除いたフォーマットに1桁足りない。 |

### 変換仕様

変換仕様は下記のとおりである。

* "yyyyMMdd"形式の年月日文字列に入力値を変換する。

### 実装例

精査対象プロパティのセッタにYYYYMMDDアノテーションを付与する。
YYYYMMDDアノテーションのallowFormat属性にフォーマットを指定する。
allowFormat属性にはjava.text.SimpleDateFormatが規定している構文を指定する。
フォーマットのパターン文字は、y(年)、M(月)、d(月における日)のみ指定可能である。

例：

```java
private String date;

@YYYYMMDD(allowFomat = "yyyy/MM/dd")
public void setDate(String date) {
    this.date = date;
}
```

## 年月コンバータ

年月に関する精査機能、システムが内部で使用する6桁の年月を表す文字列(以降は年月文字列と称す)への変換機能に関して解説する。

年月コンバータは、 年月日コンバータ とほぼ同様の機能である。
年月日コンバータが年月日を扱うのに対して、年月コンバータは年月を扱う点が異なるのみである。
よって、ここでは差分のみを説明する。

年月コンバータで使用するコンバータとアノテーションを下記に示す。

| コンバータクラス名 | 対応するアノテーション |
|---|---|
| nablarch.common.date.YYYYMMConvertor | @YYYYMM |

### 精査仕様

年月を扱う点以外は 年月日コンバータ と同様である。
例のみ提示しておく。

| フォーマット | 入力値 | バリデーション結果 |
|---|---|---|
| "yyyy/MM" | "2011/09" | OK。フォーマット通り。 |
| "yyyy/MM" | "201109" | OK。年月日の区切り文字を取り除いたフォーマット通り。 |
| "yyyy/MM" | "2011/13" | NG。存在しない日付。 |
| "yyyy/MM/dd" | "2011-09" | NG。年月日の区切り文字が異なる。 |
| "yyyy/MM" | "20119" | NG。年月日の区切り文字を取り除いたフォーマットに1桁足りない。 |

### 変換仕様

年月を扱う点以外は 年月日コンバータ と同様である。

### 実装例

年月を扱う点以外は 年月日コンバータ と同様である。
