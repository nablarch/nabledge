# JSR310(Date and Time API)アダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/jsr310_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jsr310/util/DateTimeConfiguration.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jsr310/util/BasicDateTimeConfiguration.html)

## モジュール一覧

[bean_util](../libraries/libraries-bean_util.md) でJSR310(Date and Time API)を使用できる。

> **重要**: 本アダプタで対応している型は `LocalDate` と `LocalDateTime` のみ。それ以外の型を扱いたい場合は、プロジェクト側でConverterの追加が必要。

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-jsr310-adaptor</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-jsr310-adaptor, LocalDate, LocalDateTime, JSR310アダプタ, BeanUtil連携, 対応型

</details>

## 使用方法

[repository](../libraries/libraries-repository.md) のコンポーネント設定ファイルに以下を追加することで機能が有効になる。

```xml
<import file="JSR310.xml" />
```

> **補足**: 文字列から変換する際のフォーマットを変更する場合:
> 1. `DateTimeConfiguration` の実装クラスを作成し、日付・日時フォーマットを定義する（`BasicDateTimeConfiguration` を参考）。
> 2. コンポーネント名 `dateTimeConfiguration` としてコンポーネント設定ファイルに定義する。
>
> ```xml
> <component name="dateTimeConfiguration" class="sample.SampleDateTimeConfiguration" />
> ```

<details>
<summary>keywords</summary>

DateTimeConfiguration, BasicDateTimeConfiguration, dateTimeConfiguration, JSR310.xml, 日時フォーマット変更, コンポーネント設定

</details>
