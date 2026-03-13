# BeanUtil

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/bean_util.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/Converter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/ExtensionConverter.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/ConversionManager.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BasicConversionManager.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/CopyOption.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/CopyOptions.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/CopyOptions.Builder.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-beans</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

BeanUtil, nablarch-core-beans, com.nablarch.framework, モジュール依存関係

</details>

## 使用方法

`BeanUtil` が提供するAPI:

- `getProperty(bean, "propertyName")`: getter経由でプロパティ値を取得
- `setProperty(bean, "propertyName", value)`: setter経由でプロパティ値を設定
- `createAndCopy(DestClass.class, sourceBean)`: 名前が一致するプロパティに値を移送。移送先に存在しないプロパティは無視。型が異なる場合はConversionUtilで変換
- `createMapAndCopy(bean)`: BeanをMapに変換。ネストしたBeanは「.」区切りでフラット化（例: `address.postNo`）。Map→Mapのネストはしない
- `createAndCopy(Class, map)`: MapをBeanに変換。「.」区切りキーはネストオブジェクトのプロパティとして設定。Map→Mapのネストは扱えない

> **重要**: BeanUtilはList型の型パラメータに対応していない。List型の型パラメータを使いたい場合は具象クラスでgetterをオーバーライドして対応すること。オーバーライドしない場合、`createAndCopy` 呼び出し時に実行時例外が発生する。

```java
// 具象クラスでオーバーライドした場合のみ正常動作する
public static class GoodSampleForm extends ItemsForm<Item> {
    @Override
    public List<Item> getItems() {
        return super.getItems();
    }
}
```

<details>
<summary>keywords</summary>

BeanUtil, getProperty, setProperty, createAndCopy, createMapAndCopy, プロパティコピー, Bean間データ移送, Map変換, List型パラメータ制限, nablarch.core.beans.BeanUtil

</details>

## BeanUtilの型変換ルール

Java BeansオブジェクトやMapオブジェクトから別のJava Beansオブジェクトにデータ移行する際にプロパティを型変換する。Mapオブジェクトのキーにドット（`.`）が含まれていればネストオブジェクトとして扱う。

型変換ルールは `nablarch.core.beans.converter` パッケージ配下の `Converter` 実装クラスを参照。

> **重要**: 精度の小さい型への変換（例: LongからIntegerへ）で変換先の精度を超える値を指定しても正常終了する。BeanUtilでコピーする前に [validation](libraries-validation.md) で値を検証すること。未検証の場合、不正な値がシステムに取り込まれ障害の原因となる。

> **重要**: 型変換ルールはアプリケーション共通設定。特定の処理のみ異なる型変換ルールを適用したい場合は [bean_util-format_logical](#s5) を参照し、`Converter` 実装を適用すること。

<details>
<summary>keywords</summary>

BeanUtil, Converter, ConversionManager, 型変換ルール, nablarch.core.beans.converter, nablarch.core.beans.Converter, 精度変換, validation

</details>

## 型変換ルールを追加する

型変換ルールを追加する手順:

1. 必要に応じて以下のインタフェースを実装する:
   - `Converter`
   - `ExtensionConverter`

2. `ConversionManager` の実装クラスを作成する。標準の変換ルールに追加する場合は、既存の `ConversionManager` をプロパティとして持つ実装クラスを作成する。

```java
public class SampleConversionManager implements ConversionManager {
    private ConversionManager delegateManager;

    @Override
    public Map<Class<?>, Converter<?>> getConverters() {
        Map<Class<?>, Converter<?>> converters = new HashMap<Class<?>, Converter<?>>();
        converters.putAll(delegateManager.getConverters());
        converters.put(BigInteger.class, new CustomConverter());
        return Collections.unmodifiableMap(converters);
    }

    @Override
    public List<ExtensionConverter<?>> getExtensionConvertor() {
        final List<ExtensionConverter<?>> extensionConverters =
            new ArrayList<ExtensionConverter<?>>(delegateManager.getExtensionConvertor());
        extensionConverters.add(new CustomExtensionConverter());
        return extensionConverters;
    }

    public void setDelegateManager(ConversionManager delegateManager) {
        this.delegateManager = delegateManager;
    }
}
```

3. コンポーネント設定ファイルに設定する。**コンポーネント名は `conversionManager`** とすること。

```xml
<component name="conversionManager" class="sample.SampleConversionManager">
  <property name="delegateManager">
    <component class="nablarch.core.beans.BasicConversionManager" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

ConversionManager, Converter, ExtensionConverter, BasicConversionManager, 型変換ルール追加, conversionManager, nablarch.core.beans.ConversionManager, nablarch.core.beans.Converter, nablarch.core.beans.ExtensionConverter

</details>

## 型変換時に許容するフォーマットを指定する

許容するフォーマットの指定方法（優先順位の高い順）:
1. [BeanUtil呼び出し時に設定](#s5)
2. [プロパティ単位にアノテーションで設定](#s5)
3. [デフォルト設定(システム共通設定)](#s5)

### デフォルト(システム共通)の設定

コンポーネント名 `conversionManager` で `BasicConversionManager` を定義し、`datePatterns`（日付・日時フォーマット）と `numberPatterns`（数値フォーマット）を設定する。

```xml
<component name="conversionManager" class="nablarch.core.beans.BasicConversionManager">
  <property name="datePatterns">
    <list>
      <value>yyyy/MM/dd</value>
      <value>yyyy-MM-dd</value>
    </list>
  </property>
  <property name="numberPatterns">
    <list>
      <value>#,###</value>
    </list>
  </property>
</component>
```

> **重要**: `yyyy/MM/dd` と `yyyy/MM/dd HH:mm:ss` を両方指定した場合、日時形式の値も `yyyy/MM/dd` でパースされ時間情報が欠落するケースがある。デフォルト設定では日付フォーマットのみ指定し、日時形式の項目は [プロパティ単位にアノテーションで設定](#s5) でオーバーライドすること。

### プロパティ単位のアノテーション設定

コピー元またはコピー先のBeanの該当フィールドに `CopyOption` アノテーションを指定する。コピー元とコピー先の両方に指定されている場合はコピー元の設定を使用する。許容するフォーマットはString型のプロパティに対応するフィールドに指定するのが好ましい。

```java
public class Bean {
    @CopyOption(datePattern = "yyyy/MM/dd HH:mm:ss")
    private String timestamp;

    @CopyOption(numberPattern = "#,###")
    private String number;
}
```

### BeanUtil呼び出し時の設定

OSSなどでBeanが自動生成されてアノテーション設定できない場合や、特定プロパティのみ異なる型変換ルールを適用したい場合に使用する。`CopyOptions` を使用してプロパティに設定し（構築方法は `CopyOptions.Builder` を参照）、`BeanUtil` 呼び出し時に渡す。

```java
final CopyOptions copyOptions = CopyOptions.options()
        .datePatternByName("timestamp", "yyyy年MM月dd日 HH時mm分ss秒")
        .converterByName("custom", Date.class, new CustomDateConverter())
        .build();

final DestBean copy = BeanUtil.createAndCopy(DestBean.class, bean, copyOptions);
```

<details>
<summary>keywords</summary>

BasicConversionManager, CopyOption, CopyOptions, datePatterns, numberPatterns, datePattern, numberPattern, フォーマット設定, 日付変換, 数値変換, nablarch.core.beans.BasicConversionManager, nablarch.core.beans.CopyOption, nablarch.core.beans.CopyOptions, nablarch.core.beans.CopyOptions.Builder, bean_util-format_logical, bean_util-format_property_setting, bean_util-format_default_setting, datePatternByName, converterByName

</details>
