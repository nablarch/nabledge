# フォーマッタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/format.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/text/FormatterUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Date.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/String.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/Number.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/java/text/SimpleDateFormat.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/java/text/DecimalFormat.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/text/Formatter.html)

## 機能概要

日付や数値などのデータをフォーマットして文字列型に変換する機能。フォーマット設定を本機能に集約することで、画面・ファイル・メール等の形式ごとに個別設定が不要になる。

<details>
<summary>keywords</summary>

フォーマッタ, 日付フォーマット, 数値フォーマット, データ変換, FormatterUtil

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, Maven依存関係, モジュール設定

</details>

## 使用方法

特に設定しない場合でもデフォルトのフォーマッタを使用できる。デフォルトパターンの変更やフォーマッタの追加をする場合は :ref:`format_custom` を参照してシステムリポジトリに設定を追加すること。

フォーマット処理は `FormatterUtil` を使用する。フォーマッタ名とデータ型に応じて適切なフォーマッタが選択され、指定パターン（省略時はデフォルトパターン）でフォーマットされる。

```java
// デフォルトパターンを使用
FormatterUtil.format("dateTime", input);

// パターンを指定して使用
FormatterUtil.format("dateTime", input, "yyyy年MM月dd日");
```

デフォルトで提供されるフォーマッタ:

| フォーマッタ名 | データ型 | デフォルトパターン | 備考 |
|---|---|---|---|
| dateTime | `Date` | yyyy/MM/dd | |
| dateTime | `String` | yyyy/MM/dd | フォーマット対象の日付文字列パターンが必要（デフォルト: `yyyyMMdd`） |
| number | `Number` | #,###.### | |
| number | `String` | #,###.### | |

**dateTime**: 日付フォーマッタ。対象型は `Date` およびその派生クラスと `String`。パターン構文は `SimpleDateFormat` に準拠。デフォルトパターン: `yyyy/MM/dd`。String型フォーマット時は日付文字列パターンも必要（デフォルト: `yyyyMMdd`）。変更は :ref:`format_custom` を参照。

**number**: 数値フォーマッタ。対象型は `Number` の派生クラスと `String`。パターン構文は `DecimalFormat` に準拠。デフォルトパターン: `#,###.###`。

データバインドでファイル出力時などBeanのgetterでの使用例:

```java
import java.util.Date;

public class SampleDto {
    private Date startDate;
    private Integer sales;

    // フォーマットされた文字列を取得するgetterを作成
    public String getFormattedStartDate() {
        return FormatterUtil.format("dateTime", startDate);
    }

    public String getFormattedSales() {
        return FormatterUtil.format("number", sales, "#,### 円");
    }

    // 他の getter & setter は省略
}
```

<details>
<summary>keywords</summary>

FormatterUtil, dateTime, number, SimpleDateFormat, DecimalFormat, DateTimeFormatter, DateTimeStrFormatter, NumberFormatter, NumberStrFormatter, dateStrPattern, 日付フォーマット, 数値フォーマット, フォーマッタ使用方法

</details>

## フォーマッタの設定を変更する

`nablarch.core.text.FormatterConfig` をコンポーネント設定ファイルに設定する。コンポーネント名は `formatterConfig` とすること。フォーマッタリストは `formatters` プロパティに設定する。

> **重要**: コンポーネント定義でデフォルトフォーマッタの設定を変更する場合、変更しないフォーマッタやプロパティも必ず記述すること。記述がないフォーマッタは使用不可。

```xml
<component name="formatterConfig" class="nablarch.core.text.FormatterConfig">
  <property name="formatters">
    <list>
      <component class="nablarch.core.text.DateTimeFormatter">
        <property name="formatterName" value="dateTime" />
        <property name="defaultPattern" value="yyyy/MM/dd" />
      </component>
      <component class="nablarch.core.text.DateTimeStrFormatter">
        <property name="formatterName" value="dateTime" />
        <property name="defaultPattern" value="yyyy/MM/dd" />
        <property name="dateStrPattern" value="yyyyMMdd" />
      </component>
      <component class="nablarch.core.text.NumberFormatter">
        <property name="formatterName" value="number" />
        <property name="defaultPattern" value="#,###.###" />
      </component>
      <component class="nablarch.core.text.NumberStrFormatter">
        <property name="formatterName" value="number" />
        <property name="defaultPattern" value="#,###.###" />
      </component>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

FormatterConfig, formatterConfig, formatters, DateTimeFormatter, DateTimeStrFormatter, NumberFormatter, NumberStrFormatter, dateStrPattern, フォーマッタ設定変更, デフォルトパターン変更

</details>

## フォーマッタを追加する

フォーマッタ追加手順:

1. `Formatter` の実装クラスを作成する。
2. :ref:`format_custom` を参照して、コンポーネント設定ファイルに `nablarch.core.text.FormatterConfig` とフォーマッタリストの設定を追加する。

```xml
<component name="formatterConfig" class="nablarch.core.text.FormatterConfig">
  <property name="formatters">
    <list>
      <component class="nablarch.core.text.DateTimeFormatter">
        <property name="formatterName" value="dateTime" />
        <property name="defaultPattern" value="yyyy/MM/dd" />
      </component>
      <component class="nablarch.core.text.DateTimeStrFormatter">
        <property name="formatterName" value="dateTime" />
        <property name="defaultPattern" value="yyyy/MM/dd" />
        <property name="dateStrPattern" value="yyyyMMdd" />
      </component>
      <component class="nablarch.core.text.NumberFormatter">
        <property name="formatterName" value="number" />
        <property name="defaultPattern" value="#,###.###" />
      </component>
      <component class="nablarch.core.text.NumberStrFormatter">
        <property name="formatterName" value="number" />
        <property name="defaultPattern" value="#,###.###" />
      </component>
      <component class="sample.SampleFormatter">
        <property name="formatterName" value="sample" />
        <property name="defaultPattern" value="#,### 円" />
      </component>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

Formatter, FormatterConfig, カスタムフォーマッタ追加, Formatter実装, nablarch.core.text.Formatter

</details>
