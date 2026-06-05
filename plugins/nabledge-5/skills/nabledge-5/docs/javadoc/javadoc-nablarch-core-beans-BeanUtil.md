# class BeanUtil

**パッケージ:** nablarch.core.beans

---

```java
public final class BeanUtil
```

JavaBeansに関する操作をまとめたユーティリティクラス。

**作成者:** kawasima  
**作成者:** tajima  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## コンストラクタの詳細

### BeanUtil

```java
private BeanUtil()
```

本クラスはインスタンスを生成しない。

---

## メソッドの詳細

### getPropertyDescriptors

```java
public static PropertyDescriptor[] getPropertyDescriptors(Class<?> beanClass)
```

指定したクラスに属する全てのプロパティの {@link PropertyDescriptor} を取得する。
ただし、classプロパティは取得対象外となる。

**パラメータ:**
- `beanClass` - プロパティを取得したいクラス

**戻り値:**
PropertyDescriptor[] 全てのプロパティの {@link PropertyDescriptor}

**例外:**
- `BeansException` - プロパティの取得に失敗した場合。

---

### getPropertyDescriptor

```java
public static PropertyDescriptor getPropertyDescriptor(Class<?> beanClass, String propertyName)
```

指定したクラスから、特定のプロパティの{@link PropertyDescriptor} を取得する。<br/>

**パラメータ:**
- `beanClass` - プロパティを取得したいクラス
- `propertyName` - 取得したいプロパティ名

**戻り値:**
PropertyDescriptor 取得したプロパティ

**例外:**
- `BeansException` - {@code propertyName} に対応するプロパティが定義されていない場合。

---

### getProperty

```java
public static Object getProperty(Object bean, String propertyName)
```

指定したオブジェクトから、特定のプロパティの値を取得する。
<p/>
{@code propertyName}には、{@code bean}のトップレベル要素のみ指定可能である。
<pre>
    {@code
    // ----------サンプルで使用するBean----------
    public class SampleBean {
        private String stringProp;
        private List<String> listProp;
        private String[] arrayProp;
        private NestedBean nestedBean;
        // setter及びgetterは省略
    }

    public class NestedBean {
        private String nestedStringProp;
        // setter及びgetterは省略
    }

    // ----------実装例----------
    // 問題のないコード1
    String stringProp = BeanUtil.getProperty(sampleBean, "stringProp");

    // 問題のないコード2
    String stringProp = BeanUtil.getProperty(sampleBean.nestedBean, "nestedStringProp");

    // 以下のコードは動作しない
    String nestedStringProp = BeanUtil.getProperty(sampleBean, "nestedBean.nestedStringProp");

    }
</pre>

**パラメータ:**
- `bean` - プロパティの値を取得したいBeanオブジェクト
- `propertyName` - 取得したいプロパティ名

**戻り値:**
Object オブジェクトから取得したプロパティの値

**例外:**
- `BeansException` - {@code propertyName} に対応するプロパティが定義されていない場合。

---

### getProperty

```java
public static Object getProperty(Object bean, String propertyName, Class<?> type)
```

指定したオブジェクトのプロパティの値を、指定した型に変換して取得する。
</p>
型変換の仕様は{@link ConversionUtil}を参照。
<p/>
{@code propertyName}の指定方法については{@link #getProperty(Object, String)}を参照。

**パラメータ:**
- `bean` - プロパティの値を取得したいBeanオブジェクト
- `propertyName` - 取得したいプロパティの名称
- `type` - 変換したい型 (nullを指定した場合は変換を行わず、プロパティの値をそのまま返す。)

**戻り値:**
Object 取得したプロパティを{@code type}に変換したオブジェクト

**例外:**
- `BeansException` - {@code propertyName} に対応するプロパティが定義されていない場合。

---

### setProperty

```java
private static void setProperty(Object bean, PropertyExpression expression, Object propertyValue)
```

プロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `propertyValue` - プロパティに登録する値

**例外:**
- `BeansException` - インスタンス生成に失敗した場合

---

### setObjectProperty

```java
private static void setObjectProperty(Object bean, PropertyExpression expression, Object propertyValue)
```

{@link Object}のプロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `propertyValue` - プロパティに設定する値

---

### setListProperty

```java
private static void setListProperty(Object bean, PropertyExpression expression, Object propertyValue, PropertyDescriptor pd)
```

{@link List}のプロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `propertyValue` - プロパティに設定する値
- `pd` - プロパティに対する{@link PropertyDescriptor}

---

### setArrayProperty

```java
private static void setArrayProperty(Object bean, PropertyExpression expression, Object propertyValue, PropertyDescriptor pd)
```

配列のプロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `propertyValue` - プロパティに設定する値
- `pd` - プロパティに対する{@link PropertyDescriptor}

---

### setPropertyValue

```java
private static void setPropertyValue(Object bean, String propertyName, Object propertyValue)
```

プロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `propertyName` - 値を設定するプロパティ名
- `propertyValue` - プロパティに設定する値

---

### setPropertyValue

```java
private static void setPropertyValue(Object bean, PropertyDescriptor pd, Object propertyValue, CopyOptions copyOptions)
```

プロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `pd` - 値を設定するプロパティのプロパティディスクリプタ
- `propertyValue` - プロパティに設定する値
- `copyOptions` - コピーの設定

---

### getGenericType

```java
private static Class<?> getGenericType(Object bean, String propertyName, PropertyDescriptor pd)
```

リスト、配列の要素の型を取得する.

**パラメータ:**
- `bean` - Beanオブジェクト
- `propertyName` - プロパティ名
- `pd` - プロパティディスクリプタ

**戻り値:**
リスト、配列の要素の型

---

### setProperty

```java
public static void setProperty(Object bean, String propertyName, Object propertyValue)
```

指定したオブジェクトのプロパティに値を登録する。
<p/>
対象のプロパティにsetterが定義されていない場合はなにもしない。
<p/>
{@code propertyValue}がnullの場合は、例外の送出やログ出力は行わずに、対象プロパティの値はnullになる。
<p/>
プロパティの指定方法<br/>
    {@code propertyName}にはプロパティ名を指定する。
    List型・配列型のプロパティでは、"プロパティ名[インデックス]"という形式で要素番号を指定して値を登録できる。
    ネストしたプロパティを指定することも可能である。ネストの深さに制限はない。
    ネストの親となるプロパティがnullである場合は、デフォルトコンストラクタを起動し
    インスタンスを生成してから値を格納する。
実装例<br/>
<pre>
{@code
    // ----------サンプルで使用するBean----------
    public class SampleBean {
        private String stringProp;
        private List<String> listProp;
        private String[] arrayProp;
        private NestedBean nestedBean;
        // setter及びgetterは省略
    }
    public class NestedBean {
        private String nestedStringProp;

        // setter及びgetterは省略
    }

    // ----------実装例----------
    SampleBean sampleBean = new SampleBean();

    // stringPropプロパティに"value"を登録
    BeanUtil.setProperty(sampleBean,"stringProp", "value");

    // stringPropプロパティにnullを登録。stringPropはnullとなる
    BeanUtil.setProperty(sampleBean,"stringProp", null);

    // listPropPropプロパティの要素番号0の位置に"list_value"を登録
    BeanUtil.setProperty(sampleBean,"listProp[0]", "list_value");

    // 配列型のプロパティの要素番号0の位置に"array_value"を登録
    // 十分な要素数が自動で確保される
    BeanUtil.setProperty(sampleBean, "arrayProp[0]", "array_value");

    // nestedBeanプロパティのnestedStringPropプロパティに"nested_value"を登録
    BeanUtil.setProperty(sampleBean, "nestedBean.nestedStringProp", "nested_value");
}
</pre>
<p/>

**パラメータ:**
- `bean` - 値を登録したいBeanオブジェクト
- `propertyName` - 値を登録したいプロパティ名
- `propertyValue` - 登録したい値

**例外:**
- `BeansException` - <ul>
      <li>{@code propertyName}に対応するプロパティが定義されていない場合</li>
      <li>List型・配列型以外のプロパティに、"プロパティ名[インデックス]"という形式で指定した場合</li>
      <li>ネストの親となるプロパティのインスタンス生成に失敗した場合</li>
  </ul>

---

### createAndCopy

```java
public static T createAndCopy(Class<T> beanClass, Map<String,?> map, CopyOptions copyOptions)
```

{@link Map}からBeanを生成する。
<p/>
{@code map}がnullである場合は、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
{@code map}にvalueがnullのエントリがある場合、対応するプロパティの値はnullとなる。
<p/>
対象のプロパティにsetterが定義されていない場合はなにもしない。
<p/>
プロパティの指定方法<br/>
  {@code map}に格納するエントリのキー値には、値を登録したいプロパティ名を指定する。
  List型・配列型のプロパティでは、"プロパティ名[インデックス]"という形式で要素番号を指定して値を登録できる。
  ネストしたプロパティを指定することも可能である。ネストの深さに制限はない。
  ネストの親となるプロパティがnullである場合は、インスタンスを生成してから値を登録する。
実装例<br/>
<pre>
{@code
    // ----------サンプルで使用するBean----------
    public class SampleBean {
        private String stringProp;
        private List<String> listProp;
        private String[] arrayProp;
        private NestedBean nestedBean;

        // setter及びgetterは省略
    }

    public class NestedBean {
        private String nestedStringProp;

        // setter及びgetterは省略
    }

    // ----------実装例----------
    // 格納したいプロパティ名をkeyに、値をvalueにもつMapを作成する
    Map<String,Object> map = new HashMap();

    // String型のプロパティに"value"を登録
    map.put("stringProp", "value");

    // stringPropプロパティにnullを登録。stringPropはnullとなる。
    map.put("stringProp", null);

    // List型のプロパティの要素番号0の位置に"list_value"を登録
    map.put("listProp[0]", "list_value");

    // 配列型のプロパティの要素番号0の位置に"array_value"を登録
    // 十分な要素数が自動で確保される
    map.put("arrayProp[0]", "array_value");

    // ネストしたオブジェクトのプロパティに"nested_value"を登録
    map.put("nestedBean.nestedStringProp", "nested_value");

    SampleBean sampleBean = BeanUtil.createAndCopy(SampleBean.class,map);
}
</pre>
<p/>

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - 生成したいBeanクラス
- `map` - JavaBeansのプロパティ名をエントリーのキー
  プロパティの値をエントリーの値とするMap
- `copyOptions` - コピーの設定

**戻り値:**
プロパティに値が登録されたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}にデフォルトコンストラクタが定義されていない場合や、
  {@code beanClass}のコンストラクタ実行時に問題が発生した場合。

---

### copy

```java
public static void copy(Class<? extends T> beanClass, T bean, Map<String,?> map, CopyOptions copyOptions)
```

{@link Map}からBeanインスタンスへコピーを行う。
生成済みのインスタンスにコピーを行う点以外は、{@link #createAndCopy(Class, Map, CopyOptions)}と同じ動作である。

**パラメータ:**
- `beanClass` - 移送先BeanのClass
- `bean` - 移送先Beanインスタンス
- `map` - 移送元のMap
           JavaBeansのプロパティ名をエントリーのキー
           プロパティの値をエントリーの値とするMap
- `copyOptions` - コピーの設定
- `<T>` - 型引数

---

### createAndCopy

```java
public static T createAndCopy(Class<T> beanClass, Map<String,?> map)
```

{@link Map}からBeanを生成する。

<p>
内部的には空の{@link CopyOptions}を渡して{@link #createAndCopy(Class, Map, CopyOptions)}を呼び出している。
</p>

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - 生成したいBeanクラス
- `map` - JavaBeansのプロパティ名をエントリーのキー
  プロパティの値をエントリーの値とするMap

**戻り値:**
プロパティに値が登録されたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}にデフォルトコンストラクタが定義されていない場合や、
  {@code beanClass}のコンストラクタ実行時に問題が発生した場合。

---

### createAndCopyIncludes

```java
public static T createAndCopyIncludes(Class<T> beanClass, Map<String,?> map, String includes)
```

{@link Map}から、指定したプロパティのみをコピーしたBeanを生成する。
<p/>
{@code map}がnullである場合は、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
{@code map}でvalueがnullであるプロパティの値はnullになる。例外の送出やログ出力は行わない。
<p/>
対象のプロパティにsetterが定義されていない場合はなにもしない。
<p/>
プロパティの指定方法については{@link #createAndCopy(Class, Map)}を参照。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - 生成したいBeanクラス
- `map` - JavaBeansのプロパティ名をエントリーのキー
  プロパティの値をエントリーの値とするMap
- `includes` - コピー対象のプロパティ名

**戻り値:**
Beanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}にデフォルトコンストラクタが定義されていない場合や、
  {@code beanClass}のコンストラクタ実行時に問題が発生した場合。

---

### createAndCopyExcludes

```java
public static T createAndCopyExcludes(Class<T> beanClass, Map<String,?> map, String excludes)
```

{@link Map}から指定されたプロパティ以外をコピーしてBeanを生成する。
<p/>
{@code map}がnullである場合は、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
{@code map}でvalueがnullであるプロパティの値はnullになる。例外の送出やログ出力は行わない。
<p/>
対象のプロパティにsetterが定義されていない場合はなにもしない。
<p/>
プロパティの指定方法については{@link #createAndCopy(Class, Map)}を参照。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - 生成したいBeanクラス
- `map` - JavaBeansのプロパティ名をエントリーのキー
  プロパティの値をエントリーの値とするMap
- `excludes` - コピー対象外のプロパティ名

**戻り値:**
プロパティに値が登録されたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}にデフォルトコンストラクタが定義されていない場合や、
  {@code beanClass}のコンストラクタ実行時に問題が発生した場合。

---

### createAndCopy

```java
public static T createAndCopy(Class<T> beanClass, Object srcBean)
```

Java Beansからプロパティをコピーして、別のBeanを作成する。
<p/>
{@code srcBean}がnullである場合、デフォルトコンストラクタで{@code beanClass}を生成して返却する。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - コピー先のBeanクラス
- `srcBean` - コピー元のBean

**戻り値:**
コピーされたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}にデフォルトコンストラクタが定義されていない場合や、
  {@code beanClass}のコンストラクタの実行中に問題が発生した場合。

---

### createAndCopy

```java
public static T createAndCopy(Class<T> beanClass, Object srcBean, CopyOptions copyOptions)
```

Java Beansからプロパティをコピーして、別のBeanを作成する。
<p/>
{@code srcBean}がnullである場合、デフォルトコンストラクタで{@code beanClass}を生成して返却する。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - コピー先のBeanクラス
- `srcBean` - コピー元のBean
- `copyOptions` - コピーの設定

**戻り値:**
コピーされたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}にデフォルトコンストラクタが定義されていない場合や、
  {@code beanClass}のコンストラクタの実行中に問題が発生した場合。

---

### createAndCopyIncludes

```java
public static T createAndCopyIncludes(Class<T> beanClass, Object srcBean, String includes)
```

Java Beansから指定されたプロパティをコピーして、別のBeanを作成する。
<p/>
{@code srcBean}がnullである場合、デフォルトコンストラクタで{@code beanClass}を生成して返却する。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - コピー先のBeanクラス
- `srcBean` - コピー元のBean
- `includes` - コピー対象のプロパティ名

**戻り値:**
コピーされたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}にデフォルトコンストラクタが定義されていない場合や、
  {@code beanClass}のデフォルトコンストラクタの実行中に問題が発生した場合。

---

### createAndCopyExcludes

```java
public static T createAndCopyExcludes(Class<T> beanClass, Object srcBean, String excludes)
```

Java Beansから指定されたプロパティ以外をコピーして、別のBeanを作成する。
<p/>
{@code srcBean}がnullである場合、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code beanClass}に存在しないプロパティはコピーされない。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - コピー先のBeanクラス
- `srcBean` - コピー元のBean
- `excludes` - コピー対象外のプロパティ名

**戻り値:**
プロパティに値がコピーされたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}のデフォルトコンストラクタの実行中に問題が発生した場合や、
  {@code beanClass}のプロパティのデフォルトコンストラクタの実行中に問題が発生した場合。

---

### copyInner

```java
protected static DEST copyInner(SRC srcBean, DEST destBean, CopyOptions copyOptions)
```

BeanからBeanに値をコピーする。
<p/>
内部で共通的に使用されるメソッド。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクト
- `destBean` - コピー先のBeanオブジェクト
- `copyOptions` - コピーの設定
- `<SRC>` - コピー元のBeanの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

---

### hasConverter

```java
private static boolean hasConverter(PropertyDescriptor pd, CopyOptions copyOptions)
```

指定されたプロパティの情報をもとに有効な{@link Converter}または{@link ExtensionConverter}が存在するか判定する。

**パラメータ:**
- `pd` - プロパティの情報
- `copyOptions` - コピーの設定

**戻り値:**
有効な{@link Converter}または{@link ExtensionConverter}が存在する場合は{@code true}

---

### getProperty

```java
private static Object getProperty(Object bean, PropertyDescriptor pd)
```

指定したオブジェクトのプロパティの値を取得する。

**パラメータ:**
- `bean` - プロパティの値を取得したいBeanオブジェクト
- `pd` - 取得したいプロパティのプロパティディスクリプタ

**戻り値:**
オブジェクトから取得したプロパティの値

**例外:**
- `BeansException` - 取得したいプロパティにgetterが存在しない場合

---

### copy

```java
public static DEST copy(SRC srcBean, DEST destBean)
```

BeanからBeanに値をコピーする。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクト
- `destBean` - コピー先のBeanオブジェクト
- `<SRC>` - コピー元のBeanの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合

---

### copy

```java
public static DEST copy(SRC srcBean, DEST destBean, CopyOptions copyOptions)
```

BeanからBeanに値をコピーする。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクト
- `destBean` - コピー先のBeanオブジェクト
- `copyOptions` - コピーの設定
- `<SRC>` - コピー元のBeanの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合

---

### copyExcludesNull

```java
public static DEST copyExcludesNull(SRC srcBean, DEST destBean)
```

BeanからBeanに値をコピーする。ただしnullのプロパティはコピーしない。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクト
- `destBean` - コピー先のBeanオブジェクト
- `<SRC>` - コピー元Beanの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合

---

### copyIncludes

```java
public static DEST copyIncludes(SRC srcBean, DEST destBean, String includes)
```

BeanからBeanに、指定されたプロパティをコピーする。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。
<p/>
{@code includes}には、{@code srcBean}のトップレベル要素のみ指定可能である。
それ以外を指定した場合はコピーされない。
<pre>
    {@code
    // aaa.bbbはコピーされない
    SampleBean copiedSampleBean = BeanUtil.createAndCopyIncludes(SampleBean.class, sampleBean, "aaa.bbb");
    }
</pre>

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクト
- `destBean` - コピー先のBeanオブジェクト
- `includes` - コピー対象のプロパティ名
- `<SRC>` - コピー元Beanの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合

---

### copyExcludes

```java
public static DEST copyExcludes(SRC srcBean, DEST destBean, String excludes)
```

BeanからBeanに、指定されたプロパティ以外をコピーする。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクト
- `destBean` - コピー先のBeanオブジェクト
- `excludes` - コピー対象外のプロパティ名
- `<SRC>` - コピー元Beanの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合

---

### createMapAndCopy

```java
public static Map<String,Object> createMapAndCopy(SRC srcBean, CopyOptions copyOptions)
```

BeanからMapにプロパティの値をコピーする。
<p>
Mapのキーはプロパティ名で、値はプロパティ値となる。
値の型変換は行わず、Beanのプロパティの値を単純にMapの値に設定する。
BeanがBeanを持つ構造の場合、Mapのキー値は「.」で連結された値となる。

**パラメータ:**
- `srcBean` - Bean
- `copyOptions` - コピーの設定
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapAndCopy

```java
public static Map<String,Object> createMapAndCopy(SRC srcBean)
```

BeanからMapにプロパティの値をコピーする。

<p>
内部的には空の{@link CopyOptions}を渡して{@link #createMapAndCopy(Object, CopyOptions)}を呼び出している。
</p>

**パラメータ:**
- `srcBean` - Bean
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapAndCopyExcludes

```java
public static Map<String,Object> createMapAndCopyExcludes(SRC srcBean, String excludeProperties)
```

BeanからMapにプロパティの値をコピーする。
<p>
Mapのキーはプロパティ名で、値はプロパティ値となる。
値の型変換は行わず、Beanのプロパティの値を単純にMapの値に設定する。
BeanがBeanを持つ構造の場合、Mapのキー値は「.」で連結された値となる。
<p>
除外対象のプロパティ名が指定された場合は、そのプロパティがコピー対象から除外される。

**パラメータ:**
- `srcBean` - Bean
- `excludeProperties` - 除外対象のプロパティ名
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapAndCopyIncludes

```java
public static Map<String,Object> createMapAndCopyIncludes(SRC srcBean, String includesProperties)
```

BeanからMapに指定されたプロパティの値をコピーする。
<p>
Mapのキーはプロパティ名で、値はプロパティ値となる。
値の型変換は行わず、Beanのプロパティの値を単純にMapの値に設定する。
BeanがBeanを持つ構造の場合、Mapのキー値は「.」で連結された値となる。
<p>
コピー対象のプロパティ名として指定できるのは、トップ階層のBeanのプロパティ名となる。
このため、階層構造で子階層のBeanがinclude指定されていた場合、子階層のBeanのプロパティは全てコピーされる。

**パラメータ:**
- `srcBean` - Bean
- `includesProperties` - コピー対象のプロパティ名のリスト
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapInner

```java
private static Map<String,Object> createMapInner(SRC srcBean, String prefix, CopyOptions copyOptions)
```

Mapを作成しBeanのプロパティ値をコピーする。

**パラメータ:**
- `srcBean` - コピー元のBean
- `prefix` - プロパティ名のプレフィックス
- `copyOptions` - コピーの設定
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createInstance

```java
private static T createInstance(Class<T> clazz)
```

インスタンスを生成する.

**パラメータ:**
- `clazz` - クラス

**戻り値:**
インスタンス

---

### clearCache

```java
static void clearCache()
```

---
