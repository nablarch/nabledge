# フォーマッタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/format.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/text/FormatterUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Date.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/String.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/Number.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/java/text/SimpleDateFormat.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/java/text/DecimalFormat.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/text/Formatter.html)

## 機能概要

日付や数値などのデータをフォーマットして文字列型に変換する機能。フォーマット設定を本機能に集約することで、画面・ファイル・メール等の形式ごとに個別設定が不要になる。

<details>
<summary>keywords</summary>

フォーマット, 日付フォーマット, 数値フォーマット, 文字列変換, フォーマッタ

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

nablarch-core, com.nablarch.framework, モジュール依存

</details>

## 使用方法

特に設定をしない場合でも、フレームワークがデフォルトでサポートしているフォーマッタを使用できる。デフォルトのフォーマットパターンの変更やフォーマッタの追加が必要な場合のみ、システムリポジトリへの設定が必要となる。

フォーマット実行には `FormatterUtil` を使用する。

`FormatterUtil.format` 呼び出し時にフォーマッタ名・フォーマット対象・フォーマットパターンを指定する。フォーマッタ名とデータ型に応じて適切なフォーマッタが選択される。パターン未指定の場合はフォーマッタのデフォルトパターンが使用される。

```java
// デフォルトパターン使用
FormatterUtil.format("dateTime", input);
// パターン指定
FormatterUtil.format("dateTime", input, "yyyy年MM月dd日");
```

デフォルト提供フォーマッタ:

| フォーマッタ名 | データ型 | デフォルトパターン | 備考 |
|---|---|---|---|
| dateTime | Date | yyyy/MM/dd | |
| dateTime | String | yyyy/MM/dd | フォーマット対象日付文字列のパターン必要（デフォルト: `yyyyMMdd`） |
| number | Number | #,###.### | |
| number | String | #,###.### | |

**dateTime**: 日付フォーマッタ。対象型は `Date` およびその派生クラスと `String`。パターンは `SimpleDateFormat` の構文。デフォルトパターン: `yyyy/MM/dd`。String型フォーマット時は日付文字列のパターン（デフォルト: `yyyyMMdd`）も設定が必要。変更する場合は :ref:`format_custom` を参照。

**number**: 数値フォーマッタ。対象型は `Number` の派生クラスと `String`。パターンは `DecimalFormat` の構文。デフォルトパターン: `#,###.###`。

使用例（データバインドでファイル出力時のBeanのgetter）:
```java
import java.util.Date;

public class SampleDto {
    private Date startDate;
    private Integer sales;

    public String getFormattedStartDate() {
        return FormatterUtil.format("dateTime", startDate);
    }

    public String getFormattedSales() {
        return FormatterUtil.format("number", sales, "#,### 円");
    }
}
```

<details>
<summary>keywords</summary>

FormatterUtil, DateTimeFormatter, NumberFormatter, DateTimeStrFormatter, NumberStrFormatter, formatterName, defaultPattern, dateStrPattern, dateTime, number, SimpleDateFormat, DecimalFormat, フォーマッタ使用方法, 日付フォーマット, 数値フォーマット

</details>

## フォーマッタの設定を変更する

コンポーネント設定ファイルに `nablarch.core.text.FormatterConfig` を設定する。

- コンポーネント名は `formatterConfig` とすること
- フォーマッタリストのプロパティ名は `formatters` とすること

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

> **重要**: コンポーネント定義でデフォルトフォーマッタの設定を変更する場合、変更しないフォーマッタやプロパティも必ず記述すること。コンポーネント定義に記述がないフォーマッタは使用できない。

<details>
<summary>keywords</summary>

FormatterConfig, formatterConfig, formatters, defaultPattern, dateStrPattern, フォーマッタ設定変更, コンポーネント設定, DateTimeFormatter, DateTimeStrFormatter, NumberFormatter, NumberStrFormatter

</details>

## フォーマッタを追加する

1. `Formatter` を実装したクラスを作成する
2. コンポーネント設定ファイルの `nablarch.core.text.FormatterConfig` の `formatters` リストに追加する（ :ref:`format_custom` 参照）

```xml
<component name="formatterConfig" class="nablarch.core.text.FormatterConfig">
  <property name="formatters">
    <list>
      <!-- デフォルトのフォーマッタ -->
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
      <!-- 追加したフォーマッタ -->
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

Formatter, フォーマッタ追加, カスタムフォーマッタ, FormatterConfig, formatters

</details>
