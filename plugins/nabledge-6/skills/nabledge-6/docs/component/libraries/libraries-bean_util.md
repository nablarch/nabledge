# BeanUtil

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-beans</artifactId>
</dependency>
```

## 使用方法

`BeanUtil` のAPIを使用して、任意のJava Beansに対する操作を行う。

**Bean定義例**:
```java
public class User {
    private Long id;
    private String name;
    private Date birthDay;
    private Address address;
    // getter & setterは省略
}

public class Address {
    private String postNo;
    // getter & setterは省略
}

public class UserDto {
    private String name;
    private String birthDay;
    // getter & setterは省略
}
```

```java
// プロパティ値取得（getter経由）
final Long id = (Long) BeanUtil.getProperty(user, "id");

// プロパティ値設定（setter経由）
BeanUtil.setProperty(user, "name", "新しい名前");

// Bean→Beanコピー（プロパティ名が一致するものを移送、型変換あり、移送先に存在しないプロパティは無視）
final UserDto dto = BeanUtil.createAndCopy(UserDto.class, user);

// Bean→Mapコピー（ネストBeanのキーは"."区切り: 例 address.postNo）
// 注意: MapはMap→Mapとネストしない（フラットなMapに"address.postNo"のようなキーで格納される）
final Map<String, Object> map = BeanUtil.createMapAndCopy(user);
final String postNo = (String) map.get("address.postNo");

// Map→Beanコピー（ネストBeanへはMapキー名を"."区切りで指定）
// 注意: Map→Mapとネストしたものは扱えない（"."区切りキーのみサポート）
final Map<String, Object> userMap = new HashMap<>();
userMap.put("id", 1L);
userMap.put("address.postNo", 54321);
final User user = BeanUtil.createAndCopy(User.class, userMap);
```

> **重要**: BeanUtilはList型の型パラメータに対応していない。List型の型パラメータを使う場合は、具象クラスでgetterをオーバーライドすること。オーバーライドしない場合、`BeanUtil.createAndCopy` 呼び出し時に実行時例外が発生する。
>
> ```java
> public class ItemsForm<D extends Serializable> {
>     private List<D> items;
>     public List<D> getItems() {
>         return items;
>     }
>     public void setItems(List<D> items) {
>         this.items = items;
>     }
> }
>
> public class Item implements Serializable {
>     // プロパティは省略
> }
>
> // NG: オーバーライドなし → 実行時例外
> public class BadSampleForm extends ItemsForm<Item> {}
>
> // OK: 具象クラスでgetterをオーバーライド
> public static class GoodSampleForm extends ItemsForm<Item> {
>     @Override
>     public List<Item> getItems() {
>         return super.getItems();
>     }
> }
> ```

## BeanUtilの型変換ルール

`BeanUtil` はJava BeansオブジェクトやMapオブジェクトから別のJava Beansへのデータ移行時にプロパティを型変換する。Mapオブジェクトのキーに`.`が含まれる場合、そのプロパティをネストオブジェクトとして扱う。

型変換ルールは `Converter` 実装クラス（`nablarch.core.beans.converter` パッケージ配下）を参照。

> **重要**: デフォルトの型変換ルールでは、精度の小さい型へ変換した場合（例: LongからIntegerへの変換）に変換先の精度を超える値でも正常終了する。BeanUtilでコピーする前に :ref:`validation` で値を事前に検証すること。検証しなかった場合、不正な値がシステムに取り込まれ障害の原因となる可能性がある。

> **重要**: 型変換ルールはアプリケーション共通の設定。特定の処理のみ異なる型変換ルールを適用したい場合は :ref:`bean_util-format_logical` を参照し、特定のプロパティや型に対して `Converter` 実装を適用すること。

## 型変換ルールを追加する

型変換ルールを追加する手順:

1. `Converter` または `ExtensionConverter` を実装する。
2. `ConversionManager` の実装クラスを作成する。標準の型変換ルールに追加するため、既存の `ConversionManager` をプロパティとして持つ委譲構造にする:

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

3. コンポーネント設定ファイルに登録する。コンポーネント名は **conversionManager** とすること:

```xml
<component name="conversionManager" class="sample.SampleConversionManager">
  <property name="delegateManager">
    <component class="nablarch.core.beans.BasicConversionManager" />
  </property>
</component>
```

## 型変換時に許容するフォーマットを指定する

型変換時に許容するフォーマットを指定することで日付や数値のフォーマットを解除できる（例: カンマ編集された"1,000,000"を数値1000000に変換）。

許容するフォーマットの指定方法（優先順位が高い順）:
1. :ref:`bean_util-format_logical` - BeanUtil呼び出し時に設定
2. :ref:`bean_util-format_property_setting` - プロパティ単位にアノテーションで設定
3. :ref:`bean_util-format_default_setting` - デフォルト設定（システム共通）

## デフォルト(システム共通)の許容するフォーマットを設定する

フォーマットのデフォルト設定は、コンポーネント設定ファイルに設定する。例えば、画面上で入力される数値についてはカンマ編集されているものも許容する場合に、デフォルト設定しておくことで個別指定が不要となる。

ポイント:
- コンポーネント名を **conversionManager** で `BasicConversionManager` を定義する
- `datePatterns` プロパティに許容する日付・日時フォーマットを設定する
- `numberPatterns` プロパティに許容する数値フォーマットを設定する
- 複数のフォーマットを許容する場合は複数設定する

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

> **重要**: `yyyy/MM/dd` と `yyyy/MM/dd HH:mm:ss` のように日付と日時のフォーマットを両方デフォルト指定した場合、日時形式の値も `yyyy/MM/dd` でパースされ時間情報が欠落するケースがある。デフォルトには日付フォーマットのみ指定し、日時形式の項目は :ref:`bean_util-format_property_setting` でオーバーライドすること。

## コピー対象のプロパティに対して許容するフォーマットを設定する

特定機能だけ :ref:`bean_util-format_default_setting` を適用せずに異なるフォーマットを指定したい場合、コピー元またはコピー先のフィールドに `CopyOption` アノテーションを指定して許容するフォーマットを上書きする。

アノテーションはコピー元・コピー先どちらに指定しても動作するが、フォーマットした値を持つString型プロパティのフィールドへの指定が推奨。コピー元とコピー先の両方に指定されている場合はコピー元の設定を使用する。

ポイント:
- コピー元（コピー先）のプロパティに対応したフィールドに `CopyOption` アノテーションを設定する
- `CopyOption` の `datePattern` に許容する日付・日時フォーマットを指定する
- `CopyOption` の `numberPattern` に許容する数値フォーマットを指定する

```java
public class Bean {
    // 許容する日時フォーマットを指定する
    @CopyOption(datePattern = "yyyy/MM/dd HH:mm:ss")
    private String timestamp;

    // 許容する数値フォーマットを指定する
    @CopyOption(numberPattern = "#,###")
    private String number;

    // setter及びgetterは省略
}
```

## BeanUtil呼び出し時に許容するフォーマットを設定する

OSSなどを用いてBeanを自動生成しているためアノテーション付与が不可能な場合、または特定プロパティのみ異なる型変換ルールを適用したい場合に使用する。`CopyOptions` を使用してプロパティに対して設定し（構築方法は `CopyOptions.Builder` 参照）、`BeanUtil` 呼び出し時に渡す。

```java
final CopyOptions copyOptions = CopyOptions.options()
    // timestampプロパティに対して許容するフォーマットを指定
    .datePatternByName("timestamp", "yyyy年MM月dd日 HH時mm分ss秒")
    // customプロパティに対してCustomDateConverterを適用
    .converterByName("custom", Date.class, new CustomDateConverter())
    .build();

// CopyOptionsを指定してBeanUtilを呼び出す
final DestBean copy = BeanUtil.createAndCopy(DestBean.class, bean, copyOptions);
```

## BeanUtilでレコードを使用する

Java 16以降のレコードを `BeanUtil` でJava Beansと同様に取り扱うことができる。使用方法は :ref:`bean_util-use_java_beans` に準ずる。

> **重要**: レコードは一度生成すると後から変更できない。`BeanUtil.setProperty` や `BeanUtil.copy` の引数に変更対象オブジェクトとしてレコードを渡した場合、実行時例外が発生する。

> **重要**: BeanUtilはList型の型パラメータを含むレコードに対応していない。レコードは継承できないため、List型の型パラメータには最初から具象型を設定してレコードを定義すること。
>
> ```java
> // NG: BeanUtil.createAndCopy呼び出し時に実行時例外が発生する
> public class BadSampleRecord<T>(List<T> items) {}
>
> // OK: 具象型を設定した場合
> public record GoodSampleRecord(List<Item> items) {}
> ```
