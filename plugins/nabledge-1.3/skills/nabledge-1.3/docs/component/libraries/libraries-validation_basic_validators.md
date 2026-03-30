# 基本バリデータ・コンバータ

## 基本バリデータ・コンバータ一覧

## バリデータ一覧

| バリデータクラス名 | アノテーション | 説明 |
|---|---|---|
| `nablarch.core.validation.validator.RequiredValidator` | `@Required` | 必須入力チェック |
| `nablarch.core.validation.validator.LengthValidator` | `@Length` | String#length()による文字列長チェック |
| `nablarch.core.validation.validator.NumberRangeValidator` | `@NumberRange` | 数値型プロパティが指定数値範囲内にあるかチェック |
| `nablarch.core.validation.validator.unicode.SystemCharValidator` | `@SystemChar` | システム許容文字からなる文字列かチェック |

> **注意**: `@Length`は長さ0の文字列を常に受け付ける。長さ0の入力バリデーションは`@Required`で実施すること。

## コンバータ一覧（nablarch.core.validation.convertorパッケージ）

| コンバータクラス名 | 変換後の型 | 変換可能な型 | 説明 |
|---|---|---|---|
| `StringConvertor` | `java.lang.String` | `String`、`String[]`（要素数1のみ） | 前後スペースのtrim設定可能 |
| `StringArrayConvertor` | `java.lang.String[]` | `String[]` | String配列プロパティ用 |
| `BigDecimalConvertor` | `java.math.BigDecimal` | `Number`サブクラス、`String`、`String[]`（要素数1のみ） | `@Digits`アノテーション必須 |
| `IntegerConvertor` | `java.lang.Integer` | `Number`サブクラス、`String`、`String[]`（要素数1のみ） | 9桁まで変換可。9桁超は`LongConvertor`または`BigDecimalConvertor`を使用。`@Digits`必須 |
| `LongConvertor` | `java.lang.Long` | `Number`サブクラス、`String`、`String[]`（要素数1のみ） | 18桁まで変換可。18桁超は`BigDecimalConvertor`を使用。`@Digits`必須 |

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

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| conversionFailedMessageId | ○ | | 変換失敗時のデフォルトエラーメッセージID。例: "{0}の値が不正です。" |
| allowNullValue | | null不許容 | バリデーション対象値のnull許容設定。 |
| trimPolicy | | noTrim相当 | `trimAll`（全文字トリム）または`noTrim`（トリムなし）。 |
| extendedStringConvertors | | | String変換後の追加変換を行う`ExtendedStringConvertor`実装クラスリスト。スラッシュ付き年月日文字列（2011/09/09）からスラッシュを除去したい場合などに指定する。 |

**allowNullValue設定指針**:
- バッチアプリケーション（SqlRowをバリデーションする場合）: null許容にすること。
- 画面処理（HTTPリクエストのKEY-VALUE）: null不許容にすること。nullを許可するとKEY未送信時にエラー停止できない。

> **注意**: `trimPolicy`はJavaの`String#trim()`を使用するため、`\u0020`以下のコード（半角スペース、タブ、改行等）がトリム対象。全角スペースはトリムされない。全角スペースのトリムが必要な場合はアクション側で処理するか、全角スペーストリム機能を持つカスタムコンバータを作成すること。

`extendedStringConvertors`の設定例（YYYYMMDDConvertorを使用する場合）:

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

```java
private String date;

// 追加の変換を行うコンバータに対応したアノテーションを
// 追加で変換を行うプロパティのセッタに付与する。
@PropertyName("日付")
@YYYYMMDD(allowFomat = "yyyy/MM/dd")
public void setDate(String date) {
    this.date = date;
}
```

<details>
<summary>keywords</summary>

RequiredValidator, LengthValidator, NumberRangeValidator, SystemCharValidator, StringConvertor, StringArrayConvertor, BigDecimalConvertor, IntegerConvertor, LongConvertor, @Required, @Length, @NumberRange, @SystemChar, @Digits, 必須入力チェック, 文字列長チェック, 数値範囲チェック, バリデータ一覧, コンバータ一覧, 型変換, YYYYMMDDConvertor, ExtendedStringConvertor, @YYYYMMDD, @PropertyName, conversionFailedMessageId, allowNullValue, trimPolicy, extendedStringConvertors, parseFailedMessageId, バリデーション設定, コンバータ設定, null許容設定, 文字列トリム設定

</details>

## システム許容文字のバリデーション：基本的な考え方・インタフェース・クラス定義

> **注意**: JVMが扱える範囲の文字(U+0000～U+10FFFF)は全て扱えるが、サロゲートペアを許容する場合は、文字列中のchar値の数と実際の文字数が合わなくなる問題が発生する点に注意すること。

## 基本的な考え方

以下のようにして文字集合を定義する:

- Unicodeのコードポイントを用いて、システムで使用可能な文字集合を定義する。
- 定義した文字集合の和集合をシステム許容文字として定義する。

## インタフェース

| インタフェース名 | 概要 |
|---|---|
| `nablarch.core.validation.validator.unicode.CharsetDef` | 許容する文字集合を定義するインタフェース |

## クラス一覧

| クラス名 | 概要 |
|---|---|
| `nablarch.core.validation.validator.unicode.CharsetDefSupport` | CharsetDef実装クラスのサポートクラス。CharsetDef毎のメッセージIDを保持 |
| `nablarch.core.validation.validator.unicode.RangedCharsetDef` | コードポイント範囲指定による許容文字集合定義クラス |
| `nablarch.core.validation.validator.unicode.LiteralCharsetDef` | リテラル文字列指定による許容文字集合定義クラス |
| `nablarch.core.validation.validator.unicode.CompositeCharsetDef` | 許容文字集合の組み合わせによる許容文字集合定義クラス |
| `nablarch.core.validation.validator.unicode.CachingCharsetDef` | 許容文字判定結果のキャッシュを行うクラス |
| `nablarch.core.validation.validator.unicode.SystemChar` | システム許容文字で構成された文字列であることを表すアノテーション |
| `nablarch.core.validation.validator.unicode.SystemCharValidator` | システム許容文字のみからなる文字列かチェックするクラス |

## nablarch.core.validation.convertor.StringArrayConvertor

**クラス**: `nablarch.core.validation.convertor.StringArrayConvertor`

設定値なし。

<details>
<summary>keywords</summary>

CharsetDef, CharsetDefSupport, RangedCharsetDef, LiteralCharsetDef, CompositeCharsetDef, CachingCharsetDef, SystemChar, SystemCharValidator, @SystemChar, システム許容文字, 文字集合定義, Unicodeコードポイント, サロゲートペア, U+0000, U+10FFFF, StringArrayConvertor, コンバータ設定

</details>

## コードポイント範囲指定による許容文字集合定義

## コードポイント範囲指定による許容文字集合定義（RangedCharsetDef）

最も基本的な許容文字集合の定義方法。Unicodeのコードポイントで開始位置と終了位置を定義し、その範囲に含まれる文字が許容文字となる。

```xml
<!-- 制御コードを除いたASCII文字 -->
<component name="asciiWithoutControlCode" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
  <property name="startCodePoint" value="U+0020" />
  <property name="endCodePoint" value="U+007F" />
  <property name="messageId" value="MSG00092" />
</component>
```

> **注意**: コードポイント記載にはUnicode標準の`U+n`表記を使用する。

## nablarch.core.validation.convertor.BigDecimalConvertor

**クラス**: `nablarch.core.validation.convertor.BigDecimalConvertor`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| invalidDigitsIntegerMessageId | ○ | | 小数部未指定時の桁数不正エラーメッセージID。例: "{0}には{1}桁の数値を入力してください。" |
| invalidDigitsFractionMessageId | ○ | | 小数部指定時の桁数不正エラーメッセージID。例: "{0}には整数部{1}桁、小数部{2}桁の数値を入力してください。" |
| multiInputMessageId | ○ | | 入力値に複数文字列が設定された場合のエラーメッセージID。例: "{0}の値が不正です。" |
| allowNullValue | | null不許容 | StringConvertor#allowNullValue 参照。 |

<details>
<summary>keywords</summary>

RangedCharsetDef, startCodePoint, endCodePoint, messageId, コードポイント範囲, U+n表記, ASCII文字, 許容文字集合, BigDecimalConvertor, invalidDigitsIntegerMessageId, invalidDigitsFractionMessageId, multiInputMessageId, allowNullValue, 桁数バリデーション, コンバータ設定

</details>

## リテラル文字列指定による許容文字集合定義

## リテラル文字列指定による許容文字集合定義（LiteralCharsetDef）

定義したい文字集合の要素がUnicodeコードポイント上に散在する場合、コードポイント範囲指定では煩雑になる。そのような場合に本クラスを利用することで簡便に文字集合を定義できる。

```xml
<!-- "A"と"1"と"あ"を許容 -->
<component name="literal" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="A1あ" />
  <property name="messageId" value="MSG00092" />
</component>
```

> **注意**: 許容文字リテラルはvalue属性への直接記入ではなく、config-file要素で外部化することを推奨。

## nablarch.core.validation.convertor.IntegerConvertor

**クラス**: `nablarch.core.validation.convertor.IntegerConvertor`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| invalidDigitsIntegerMessageId | ○ | | 桁数不正エラーメッセージID。例: "{0}には{1}桁の数値を入力してください。" |
| multiInputMessageId | ○ | | 複数文字列入力時のエラーメッセージID。例: "{0}の値が不正です。" |
| allowNullValue | | null不許容 | StringConvertor#allowNullValue 参照。 |

<details>
<summary>keywords</summary>

LiteralCharsetDef, allowedCharacters, messageId, リテラル文字列, 許容文字集合, config-file, 外部化, IntegerConvertor, invalidDigitsIntegerMessageId, multiInputMessageId, allowNullValue, 桁数バリデーション, コンバータ設定

</details>

## 許容文字集合の組み合わせによる許容文字集合定義

## 許容文字集合の組み合わせによる許容文字集合定義（CompositeCharsetDef）

複数の許容文字集合を組み合わせて許容文字集合を定義する。

```xml
<!-- 組み合わせ -->
<component name="composite" class="nablarch.core.validation.validator.unicode.CompositeCharsetDef">
  <property name="charsetDefList">
    <list>
      <component-ref name="asciiWithoutControlCode"/>
      <component-ref name="kana"/>
    </list>
  </property>
</component>
<!-- ASCII -->
<component name="asciiWithoutControlCode" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
  <property name="startCodePoint" value="U+0020" />
  <property name="endCodePoint" value="U+007E" />
</component>
```

> **注意**: 判定処理はリストの設定順に実施される。出現頻度が高い許容文字集合定義を先頭に配置することで処理性能が向上する。

## nablarch.core.validation.convertor.LongConvertor

**クラス**: `nablarch.core.validation.convertor.LongConvertor`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| invalidDigitsIntegerMessageId | ○ | | 桁数不正エラーメッセージID。例: "{0}には{1}桁の数値を入力してください。" |
| multiInputMessageId | ○ | | 複数文字列入力時のエラーメッセージID。例: "{0}の値が不正です。" |
| allowNullValue | | null不許容 | StringConvertor#allowNullValue 参照。 |

<details>
<summary>keywords</summary>

CompositeCharsetDef, charsetDefList, component-ref, 許容文字集合の組み合わせ, 判定順序, 出現頻度, 処理性能, LongConvertor, invalidDigitsIntegerMessageId, multiInputMessageId, allowNullValue, 桁数バリデーション, コンバータ設定

</details>

## 許容文字判定結果のキャッシュ

## 許容文字判定結果のキャッシュ（CachingCharsetDef）

多数のCharsetDefを組み合わせる場合、判定結果をキャッシュして性能を改善できる。特に処理時間のばらつきを抑えたい場合に有効。

```xml
<!-- 許容文字集合定義のキャッシュ -->
<component name="charsetDefCache" class="nablarch.core.validation.validator.unicode.CachingCharsetDef">
  <!-- キャッシュする対象となる許容文字集合定義 -->
  <property name="charsetDef" ref="composite"/>
</component>
```

## nablarch.core.validation.validator.RequiredValidator

**クラス**: `nablarch.core.validation.validator.RequiredValidator`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messageId | ○ | | デフォルトエラーメッセージID。例: "{0}は必ず入力してください。" |

<details>
<summary>keywords</summary>

CachingCharsetDef, charsetDef, キャッシュ, 性能改善, 処理時間, 許容文字判定, RequiredValidator, messageId, バリデーション設定

</details>

## 許容文字集合の登録方法

## 許容文字集合の登録方法

定義した許容文字集合をSystemCharValidatorに設定することで、`@SystemChar`アノテーションによるシステム許容文字チェックが実施できる。

```xml
<component class="nablarch.core.validation.validator.unicode.SystemCharValidator">
  <!-- 定義した許容文字集合を設定 -->
  <property name="defaultCharsetDef" ref="systemPermittedCharset"/>
  <property name="messageId" value="MSG90001"/>
</component>
```

## nablarch.core.validation.validator.LengthValidator

**クラス**: `nablarch.core.validation.validator.LengthValidator`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| maxMessageId | ○ | | 最大文字列長超過時（最小未指定）のエラーメッセージID。例: "{0}は{2}文字以下で入力してください。" |
| maxAndMinMessageId | ○ | | 最大文字列長超過時（最小指定あり）のエラーメッセージID。例: "{0}は{1}文字以上{2}文字以下で入力してください。" |
| fixLengthMessageId | ○ | | 固定桁数チェック（maxとminに同値設定）のエラーメッセージID。例: "{0}は{1}文字で入力してください。" |

<details>
<summary>keywords</summary>

SystemCharValidator, defaultCharsetDef, messageId, @SystemChar, 許容文字集合の登録, systemPermittedCharset, LengthValidator, maxMessageId, maxAndMinMessageId, fixLengthMessageId, バリデーション設定

</details>

## 精査エラー時に使用するメッセージIDの指定方法

## 精査エラー時に使用するメッセージIDの指定方法

精査エラー時のメッセージID指定方法（優先順位順）:

1. **`@SystemChar`アノテーション**: 個別機能ごとにメッセージを切り替えたい場合

   ```java
   @PropertyName("パスワード")
   @Required
   @SystemChar(charsetDef = "alphaCharacter", messageId = "PASSWORD")
   @Length(max = 20)
   public void setConfirmPassword(String confirmPassword) {
       this.confirmPassword = confirmPassword;
   }
   ```

2. **`CharsetDef`**: 文字集合ごとにメッセージを切り替えたい場合（精査種別ごとにメッセージを切り替えるシステムで使用）

   ```xml
   <component name="alphaCharacter" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
     <property name="startCodePoint" value="U+0061" />
     <property name="endCodePoint" value="U+007A" />
     <property name="messageId" value="MSG00002" />
   </component>
   ```

3. **`SystemCharValidator`**: システム全体でメッセージを統一したい場合（必須設定）

   ```xml
   <component class="nablarch.core.validation.validator.unicode.SystemCharValidator">
     <property name="defaultCharsetDef" ref="systemPermittedCharset"/>
     <property name="messageId" value="MSG99999"/>
   </component>
   ```

> **注意**: `SystemCharValidator`のメッセージIDは、`@SystemChar`および`CharsetDef`にメッセージID指定がない場合のデフォルト値として必ず設定が必要。

## nablarch.core.validation.validator.NumberRangeValidator

**クラス**: `nablarch.core.validation.validator.NumberRangeValidator`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| maxMessageId | ○ | | 最大値のみ指定時のエラーメッセージID。例: "{0}は{2}以下で入力してください。" |
| maxAndMinMessageId | ○ | | 最大値・最小値指定時のエラーメッセージID。例: "{0}は{1}以上{2}以下で入力してください。" |
| minMessageId | ○ | | 最小値のみ指定時のエラーメッセージID。例: "{0}は{1}以上で入力してください。" |

<details>
<summary>keywords</summary>

SystemChar, CharsetDef, SystemCharValidator, messageId, @SystemChar, 精査エラー, メッセージID, 優先順位, defaultCharsetDef, NumberRangeValidator, maxMessageId, maxAndMinMessageId, minMessageId, 桁数バリデーション, バリデーション設定

</details>

## SystemCharValidator設定値

## nablarch.core.validation.validator.unicode.SystemCharValidator

**クラス**: `nablarch.core.validation.validator.unicode.SystemCharValidator`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messageId | ○ | | 有効文字以外の入力時エラーメッセージID。例: "{0}に許容されない文字が含まれてています。" |
| defaultCharsetDef | ○ | | バリデーション条件に許容文字集合定義名が指定されない場合のデフォルト許容文字集合定義。 |

<details>
<summary>keywords</summary>

SystemCharValidator, messageId, defaultCharsetDef, 文字種バリデーション, バリデーション設定

</details>
