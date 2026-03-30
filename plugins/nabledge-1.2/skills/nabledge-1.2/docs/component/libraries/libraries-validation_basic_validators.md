# 基本バリデータ・コンバータ

## 基本バリデータ・コンバータ一覧

## バリデータ一覧

| バリデータクラス名 | アノテーション | 説明 |
|---|---|---|
| `nablarch.core.validation.validator.RequiredValidator` | `@Required` | 必須入力チェック |
| `nablarch.core.validation.validator.LengthValidator` | `@Length` | 文字列長チェック（String#length()による）。長さ0の文字列は常に受け付ける（長さ0のチェックは`@Required`で実施する想定） |
| `nablarch.core.validation.validator.NumberRangeValidator` | `@NumberRange` | 数値型プロパティが指定範囲内かチェック |
| `nablarch.core.validation.validator.unicode.SystemCharValidator` | `@SystemChar` | システム許容文字からなる文字列かチェック |

## コンバータ一覧（nablarch.core.validation.convertorパッケージ）

| コンバータクラス名 | 変換後の型 | 変換可能な入力型 | 説明 |
|---|---|---|---|
| `StringConvertor` | `java.lang.String` | `String`, `String[]`（要素数1のみ） | 文字列型プロパティへのデータ変換。設定によって前後スペースをtrimできる |
| `StringArrayConvertor` | `java.lang.String[]` | `String[]` | String配列プロパティへのデータ変換 |
| `BigDecimalConvertor` | `java.math.BigDecimal` | `Number`サブクラス, `String`, `String[]`（要素数1のみ） | BigDecimal型プロパティへのデータ変換。`@Digits`アノテーション設定が必須 |
| `IntegerConvertor` | `java.lang.Integer` | `Number`サブクラス, `String`, `String[]`（要素数1のみ） | Integer型プロパティへのデータ変換。9桁まで変換可能。9桁超は`LongConvertor`または`BigDecimalConvertor`を使用。`@Digits`アノテーション設定が必須 |
| `LongConvertor` | `java.lang.Long` | `Number`サブクラス, `String`, `String[]`（要素数1のみ） | Long型プロパティへのデータ変換。18桁まで変換可能。18桁超は`BigDecimalConvertor`を使用。`@Digits`アノテーション設定が必須 |

> **注意**: `BigDecimalConvertor`、`IntegerConvertor`、`LongConvertor`には`@Digits`アノテーションの設定が必須。セッタに設定すること。

```java
@PropertyName("認証失敗回数")
@Required
@NumberRange(min = 0, max = 9)
@Digits(integer = 1, fraction = 0)
public void setFailedCount(Integer failedCount) {
    this.failedCount = failedCount;
}
```

## nablarch.core.validation.convertor.StringConvertor

**クラス**: `nablarch.core.validation.convertor.StringConvertor`

| プロパティ名 | 設定内容 |
|---|---|
| conversionFailedMessageId(必須) | 変換失敗時のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}の値が不正です。" |
| allowNullValue | 変換対象の値にnullを許容するか否かを設定する。設定を省略した場合のデフォルト動作では、nullを許容しない。null値を許容するケースは、バッチアプリケーションのようにデータベースから取得したSqlRow(Mapインタフェースの実装クラス)をバリデーションする場合である。**画面処理ではnullを許可してはならない**（バリデーション対象のKEYがクライアントから送信されていない場合に精査エラーとして処理を停止できなくなるため）。 |
| trimPolicy | トリムを行う際のポリシーを設定する。"trimAll"（全文字トリム）または"noTrim"（トリムなし）。設定を省略した場合は"noTrim"と同様の動作となる。 |
| extendedStringConvertors | String型に変換後、追加の変換を行うExtendedStringConvertorインタフェースを実装したクラスのリストを設定する。省略時は追加変換を行わない。 |

> **注意**: trimはJavaのString#trim()を使用。'\u0020'以下のコード（半角スペース、タブ、改行、null文字など）を文字列前後から削除する。全角スペースなどのトリムが必要な場合はアクションで処理するか、全角スペーストリム機能を持つコンバータを独自作成すること。

`extendedStringConvertors`使用例（YYYYMMDDConvertorを使用する場合）:

設定ファイル:
```xml
<component class="nablarch.core.validation.convertor.StringConvertor">
  <property name="conversionFailedMessageId" value="MSG90001"/>
  <property name="extendedStringConvertors">
    <list>
      <component class="nablarch.common.date.YYYYMMDDConvertor">
        <property name="parseFailedMessageId" value="MSG90001" />
      </component>
    </list>
  </property>
</component>
```

Formクラス（追加変換するプロパティのセッタに対応アノテーションを付与）:
```java
@PropertyName("日付")
@YYYYMMDD(allowFomat = "yyyy/MM/dd")
public void setDate(String date) {
    this.date = date;
}
```

<details>
<summary>keywords</summary>

RequiredValidator, LengthValidator, NumberRangeValidator, SystemCharValidator, @Required, @Length, @NumberRange, @SystemChar, StringConvertor, StringArrayConvertor, BigDecimalConvertor, IntegerConvertor, LongConvertor, @Digits, バリデータ一覧, コンバータ一覧, 必須入力チェック, 文字列長チェック, 数値範囲チェック, nablarch.core.validation.convertor.StringConvertor, conversionFailedMessageId, allowNullValue, trimPolicy, extendedStringConvertors, ExtendedStringConvertor, @YYYYMMDD, YYYYMMDDConvertor, nablarch.common.date.YYYYMMDDConvertor, 文字列変換, nullバリュー許容, トリムポリシー

</details>

## システム許容文字のバリデーション - 概要とクラス構成

システムが許容する文字は、そのシステムの要件によって異なる。それぞれのシステムに相応しい許容文字を定義できるバリデーションを提供する。

> **注意**: サロゲートペアを許容する場合はchar値の数と実際の文字数が合わなくなる問題が発生する。JVMが扱える範囲（U+0000～U+10FFFF）は全て扱えるが注意すること。

## 基本的な考え方

* Unicodeのコードポイントを用いて、システムで使用可能な文字集合を定義する。
* 定義した文字集合の和集合をシステム許容文字として定義する。

## インタフェース

| インタフェース名 | 説明 |
|---|---|
| `nablarch.core.validation.validator.unicode.CharsetDef` | 許容する文字の集合を定義するインタフェース |

## クラス

| クラス名 | 説明 |
|---|---|
| `nablarch.core.validation.validator.unicode.CharsetDefSupport` | CharsetDef実装クラスのサポートクラス。CharsetDef毎のメッセージIDの保持のみを行う |
| `nablarch.core.validation.validator.unicode.RangedCharsetDef` | コードポイント範囲指定による許容文字集合定義クラス |
| `nablarch.core.validation.validator.unicode.LiteralCharsetDef` | リテラル文字列指定による許容文字集合定義クラス |
| `nablarch.core.validation.validator.unicode.CompositeCharsetDef` | 許容文字集合の組み合わせによる許容文字集合定義クラス |
| `nablarch.core.validation.validator.unicode.CachingCharsetDef` | 許容文字判定結果のキャッシュを行うクラス |
| `nablarch.core.validation.validator.unicode.SystemChar` | システム許容文字で構成された文字列であることを表すアノテーション |
| `nablarch.core.validation.validator.unicode.SystemCharValidator` | システム許容文字のみからなる文字列かチェックするクラス |

## nablarch.core.validation.convertor.StringArrayConvertor

**クラス**: `nablarch.core.validation.convertor.StringArrayConvertor`

本クラスは特に設定値を持たない。

<details>
<summary>keywords</summary>

CharsetDef, CharsetDefSupport, RangedCharsetDef, LiteralCharsetDef, CompositeCharsetDef, CachingCharsetDef, SystemChar, SystemCharValidator, @SystemChar, システム許容文字, 文字集合定義, Unicodeコードポイント, 許容文字バリデーション, 和集合, 基本的な考え方, StringArrayConvertor, nablarch.core.validation.convertor.StringArrayConvertor

</details>

## 許容文字集合の定義方法と登録

## コードポイント範囲指定による許容文字集合定義（RangedCharsetDef）

Unicodeコードポイントで開始・終了位置を定義し、その範囲内の文字を許容文字とする。コードポイント記載にはU+n表記を使用する。

```xml
<!-- 制御コードを除いたASCII文字 -->
<component name="asciiWithoutControlCode" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
  <property name="startCodePoint" value="U+0020" />
  <property name="endCodePoint" value="U+007F" />
  <property name="messageId" value="MSG00092" />
</component>
```

## リテラル文字列指定による許容文字集合定義（LiteralCharsetDef）

コードポイント上に散在する文字集合の定義に使用する。

```xml
<!-- "A"と"1"と"あ"を許容 -->
<component name="literal" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="A1あ" />
  <property name="messageId" value="MSG00092" />
</component>
```

> **注意**: `allowedCharacters`のvalue属性への直接記入より、config-file要素を利用した外部化を推奨。

## 許容文字集合の組み合わせによる定義（CompositeCharsetDef）

複数の許容文字集合を組み合わせて定義する。判定処理はリストの設定順に行われるため、出現頻度の高い文字集合を先頭に配置すると性能が向上する。

```xml
<component name="composite" class="nablarch.core.validation.validator.unicode.CompositeCharsetDef">
  <property name="charsetDefList">
    <list>
      <component-ref name="asciiWithoutControlCode"/>
      <component-ref name="kana"/>
    </list>
  </property>
</component>
```

## 許容文字判定結果のキャッシュ（CachingCharsetDef）

多数のCharsetDefを組み合わせる場合や処理時間のばらつきを抑えたい場合にキャッシュが有効。

```xml
<component name="charsetDefCache" class="nablarch.core.validation.validator.unicode.CachingCharsetDef">
  <property name="charsetDef" ref="composite"/>
</component>
```

## SystemCharValidatorへの許容文字集合登録

定義した許容文字集合を`SystemCharValidator`に設定することで、`@SystemChar`アノテーションによるチェックが実施できる。

```xml
<component class="nablarch.core.validation.validator.unicode.SystemCharValidator">
  <property name="defaultCharsetDef" ref="systemPermittedCharset"/>
  <property name="messageId" value="MSG90001"/>
</component>
```

## nablarch.core.validation.convertor.BigDecimalConvertor

**クラス**: `nablarch.core.validation.convertor.BigDecimalConvertor`

| プロパティ名 | 設定内容 |
|---|---|
| invalidDigitsIntegerMessageId(必須) | 小数部を指定しなかった場合の桁数不正時のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}には{1}桁の数値を入力してください。" |
| invalidDigitsFractionMessageId(必須) | 小数部を指定した場合の桁数不正時のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}には整数部{1}桁、小数部{2}桁の数値を入力してください。" |
| multiInputMessageId(必須) | 入力値に複数の文字列が設定された場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}の値が不正です。" |
| allowNullValue | 詳細は StringConvertor#allowNullValue を参照。 |

<details>
<summary>keywords</summary>

RangedCharsetDef, LiteralCharsetDef, CompositeCharsetDef, CachingCharsetDef, startCodePoint, endCodePoint, allowedCharacters, charsetDefList, charsetDef, defaultCharsetDef, コードポイント範囲指定, リテラル文字列指定, 許容文字集合の組み合わせ, 許容文字判定結果のキャッシュ, SystemCharValidator登録, BigDecimalConvertor, nablarch.core.validation.convertor.BigDecimalConvertor, invalidDigitsIntegerMessageId, invalidDigitsFractionMessageId, multiInputMessageId, allowNullValue

</details>

## 精査エラー時のメッセージID指定方法

精査エラー時にエラーメッセージを取得するためのメッセージIDは以下3種類の指定方法から用途に応じて選択する。

## メッセージIDの優先順位（高い順）

1. `@SystemChar`アノテーションに指定（個別機能でメッセージを切り替える場合）
2. `CharsetDef`に指定（文字集合の種別ごとにメッセージを切り替える場合）
3. `SystemCharValidator`に指定（デフォルト。必ず設定すること）

> **注意**: `SystemCharValidator`のmessageIdは、`@SystemChar`および`CharsetDef`にメッセージID指定がない場合のデフォルトとして使用されるため、必ず設定すること。

## `@SystemChar`アノテーションへの指定

```java
@PropertyName("パスワード")
@Required
@SystemChar(charsetDef = "alphaCharacter", messageId = "PASSWORD")
@Length(max = 20)
public void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
}
```

## `CharsetDef`への指定

```xml
<component name="alphaCharacter" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
  <property name="startCodePoint" value="U+0061" />
  <property name="endCodePoint" value="U+007A" />
  <property name="messageId" value="MSG00002" />
</component>
```

## `SystemCharValidator`への指定

```xml
<component class="nablarch.core.validation.validator.unicode.SystemCharValidator">
  <property name="defaultCharsetDef" ref="systemPermittedCharset"/>
  <property name="messageId" value="MSG99999"/>
</component>
```

## nablarch.core.validation.convertor.IntegerConvertor

**クラス**: `nablarch.core.validation.convertor.IntegerConvertor`

| プロパティ名 | 設定内容 |
|---|---|
| invalidDigitsIntegerMessageId(必須) | 小数部を指定しなかった場合の桁数不正時のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}には{1}桁の数値を入力してください。" |
| multiInputMessageId(必須) | 入力値に複数の文字列が設定された場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}の値が不正です。" |
| allowNullValue | 詳細は StringConvertor#allowNullValue を参照。 |

<details>
<summary>keywords</summary>

messageId, SystemChar, CharsetDef, SystemCharValidator, @SystemChar, メッセージID, 精査エラー, 優先順位, IntegerConvertor, nablarch.core.validation.convertor.IntegerConvertor, invalidDigitsIntegerMessageId, multiInputMessageId, allowNullValue

</details>

## LongConvertor の設定値

## nablarch.core.validation.convertor.LongConvertor

**クラス**: `nablarch.core.validation.convertor.LongConvertor`

| プロパティ名 | 設定内容 |
|---|---|
| invalidDigitsIntegerMessageId(必須) | 小数部を指定しなかった場合の桁数不正時のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}には{1}桁の数値を入力してください。" |
| multiInputMessageId(必須) | 入力値に複数の文字列が設定された場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}の値が不正です。" |
| allowNullValue | 詳細は StringConvertor#allowNullValue を参照。 |

<details>
<summary>keywords</summary>

LongConvertor, nablarch.core.validation.convertor.LongConvertor, invalidDigitsIntegerMessageId, multiInputMessageId, allowNullValue

</details>

## RequiredValidator の設定値

## nablarch.core.validation.validator.RequiredValidator

**クラス**: `nablarch.core.validation.validator.RequiredValidator`

| プロパティ名 | 設定内容 |
|---|---|
| messageId(必須) | デフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}は必ず入力してください。" |

<details>
<summary>keywords</summary>

RequiredValidator, nablarch.core.validation.validator.RequiredValidator, messageId, バリデーション設定

</details>

## LengthValidator の設定値

## nablarch.core.validation.validator.LengthValidator

**クラス**: `nablarch.core.validation.validator.LengthValidator`

| プロパティ名 | 設定内容 |
|---|---|
| maxMessageId(必須) | 最大文字列長を越えるエラーが発生した際に、最小文字列長が指定されていなかった場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}は{2}文字以下で入力してください。" |
| maxAndMinMessageId(必須) | 最大文字列長を越えるエラーが発生した際に、最小文字列長が指定されていた場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}は{1}文字以上{2}文字以下で入力してください。" |
| fixLengthMessageId(必須) | 固定桁数の文字列チェック（maxとminに同じ値を設定した場合）でエラーが発生した際のデフォルトのメッセージIDを設定する。例: "{0}は{1}文字で入力してください。" |

<details>
<summary>keywords</summary>

LengthValidator, nablarch.core.validation.validator.LengthValidator, maxMessageId, maxAndMinMessageId, fixLengthMessageId

</details>

## NumberRangeValidator の設定値

## nablarch.core.validation.validator.NumberRangeValidator

**クラス**: `nablarch.core.validation.validator.NumberRangeValidator`

| プロパティ名 | 設定内容 |
|---|---|
| maxMessageId(必須) | バリデーションの条件に最大値のみが指定されていた場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}は{2}以下で入力してください。" |
| maxAndMinMessageId(必須) | バリデーションの条件に最大値と最小値が指定されていた場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}は{1}以上{2}以下で入力してください。" |
| minMessageId(必須) | バリデーションの条件に最小値のみが指定されていた場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}は{1}以上で入力してください。" |

<details>
<summary>keywords</summary>

NumberRangeValidator, nablarch.core.validation.validator.NumberRangeValidator, maxMessageId, maxAndMinMessageId, minMessageId

</details>

## SystemCharValidator の設定値

## nablarch.core.validation.validator.unicode.SystemCharValidator

**クラス**: `nablarch.core.validation.validator.unicode.SystemCharValidator`

| プロパティ名 | 設定内容 |
|---|---|
| messageId(必須) | 有効文字以外が入力された場合のデフォルトのエラーメッセージのメッセージIDを設定する。例: "{0}に許容されない文字が含まれてています。" |
| defaultCharsetDef(必須) | バリデーションの条件に、許容文字集合定義の名称が指定されていない場合に使用するデフォルトの許容文字集合定義 |

<details>
<summary>keywords</summary>

SystemCharValidator, nablarch.core.validation.validator.unicode.SystemCharValidator, messageId, defaultCharsetDef, コンバータ設定, 有効文字チェック

</details>
