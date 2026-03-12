# JSR310(Date and Time API)アダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/jsr310_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/java/time/LocalDate.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/java/time/LocalDateTime.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jsr310/util/DateTimeConfiguration.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jsr310/util/BasicDateTimeConfiguration.html)

## モジュール一覧

> **重要**: Nablarch 6u2以降、本アダプタの機能はフレームワーク本体に取り込まれているため、本アダプタを使用しなくても [bean_util](../libraries/libraries-bean_util.md) でJSR310(Date and Time API)を使用できる。本アダプタは後方互換維持のために残している。

> **重要**: 本アダプタが対応する型は `LocalDate` と `LocalDateTime` のみ。これら以外の型を扱う場合はプロジェクト側でConverterを追加する必要がある。

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-jsr310-adaptor</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-jsr310-adaptor, LocalDate, LocalDateTime, JSR310アダプタ, Date and Time API, 後方互換, BeanUtil JSR310対応

</details>

## 使用方法

[repository](../libraries/libraries-repository.md) のコンポーネント設定ファイルに以下を追加することで有効化：

```xml
<import file="JSR310.xml" />
```

> **補足**: 文字列からの変換フォーマットを変更する場合、以下の手順が必要：
> 1. `DateTimeConfiguration` の実装クラスを作成し、日付・日時フォーマットを定義する（`BasicDateTimeConfiguration` を参考にすること）
> 2. コンポーネント名 `dateTimeConfiguration` としてコンポーネント設定ファイルに定義する
>
> ```xml
> <component name="dateTimeConfiguration" class="sample.SampleDateTimeConfiguration" />
> ```

<details>
<summary>keywords</summary>

DateTimeConfiguration, BasicDateTimeConfiguration, dateTimeConfiguration, JSR310有効化, 日時フォーマット設定, コンポーネント設定, JSR310.xml

</details>
