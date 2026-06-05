# class BeanUtil

**パッケージ:** nablarch.core.beans

---

```java
public final class BeanUtil
```

JavaBeansおよびレコードに関する操作をまとめたユーティリティクラス。
<p>
レコードはJavaBeanではないものの、JavaBeansと同様に取り扱えると便利なため、
本ユーティリティにてレコードに関する操作もサポートしている。

**作成者:** kawasima  
**作成者:** tajima  

---

## フィールドの詳細

### PRIM_DEFAULT_VALUES

```java
private static final Map<Class<?>,Object> PRIM_DEFAULT_VALUES
```

プリミティブ型に対応するデフォルト値

---

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
<p>
ただし、classプロパティは取得対象外となる。
<p>
本メソッドの引数にレコードクラスを指定した場合、実行時例外が送出される。

**パラメータ:**
- `beanClass` - プロパティを取得したいクラス

**戻り値:**
PropertyDescriptor[] 全てのプロパティの {@link PropertyDescriptor}

**例外:**
- `BeansException` - プロパティの取得に失敗した場合。
- `IllegalArgumentException` - 引数の{@code beanClass}がレコードの場合

---

### getPropertyDescriptor

```java
public static PropertyDescriptor getPropertyDescriptor(Class<?> beanClass, String propertyName)
```

指定したクラスから、特定のプロパティの{@link PropertyDescriptor} を取得する。
<p>
本メソッドの引数にレコードクラスを指定した場合、実行時例外が送出される。

**パラメータ:**
- `beanClass` - プロパティを取得したいクラス
- `propertyName` - 取得したいプロパティ名

**戻り値:**
PropertyDescriptor 取得したプロパティ

**例外:**
- `BeansException` - {@code propertyName} に対応するプロパティが定義されていない場合。
- `IllegalArgumentException` - 引数の{@code beanClass}がレコードの場合

---

### getRecordComponents

```java
static RecordComponent[] getRecordComponents(Class<?> recordClass)
```

指定したレコードに属する全てのプロパティの {@link RecordComponent} を取得する。
<p>
本メソッドの引数にレコードクラスでないクラスを指定した場合、実行時例外が送出される。

**パラメータ:**
- `recordClass` - プロパティを取得したいクラス

**戻り値:**
RecordComponent[] 全てのプロパティの {@link RecordComponent}

**例外:**
- `BeansException` - プロパティの取得に失敗した場合。
- `IllegalArgumentException` - 引数の{@code recordClass}がレコードでない場合

---

### getRecordComponent

```java
static RecordComponent getRecordComponent(Class<?> recordClass, String propertyName)
```

指定したクラスから、特定のプロパティの{@link RecordComponent} を取得する。
<p>
本メソッドの引数にレコードクラスでないクラスを指定した場合、実行時例外が送出される。

**パラメータ:**
- `recordClass` - プロパティを取得したいクラス
- `propertyName` - 取得したいプロパティ名

**戻り値:**
RecordComponent 取得したプロパティ

**例外:**
- `BeansException` - {@code propertyName} に対応するプロパティが定義されていない場合。
- `IllegalArgumentException` - 引数の{@code recordClass}がレコードでない場合

---

### getPropertyNames

```java
static Set<String> getPropertyNames(Class<?> beanClass)
```

指定したクラスに属する全てのプロパティの名前を取得する。

**パラメータ:**
- `beanClass` - プロパティ名を取得したいクラス

**戻り値:**
Set<String> 全てのプロパティの名前

---

### getPropertyType

```java
static Class<?> getPropertyType(Class<?> beanClass, String propertyName)
```

指定したクラスから、特定プロパティの型を取得する。

**パラメータ:**
- `beanClass` - プロパティの型を取得したいクラス
- `propertyName` - 取得したいプロパティ名

**戻り値:**
Class<?> プロパティの型

---

### getReadMethod

```java
static Method getReadMethod(Class<?> beanClass, String propertyName)
```

指定したクラスから、特定プロパティの読み取りメソッドを取得する。

**パラメータ:**
- `beanClass` - プロパティの読み取りメソッドを取得したいクラス
- `propertyName` - 取得したいプロパティ名

**戻り値:**
Method プロパティの読み取りメソッド

---

### getProperty

```java
public static Object getProperty(Object bean, String propertyName)
```

指定したJavaBeansオブジェクトもしくはレコードから、特定のプロパティの値を取得する。
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
- `bean` - プロパティの値を取得したいBeanオブジェクトもしくはレコード
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

指定したJavaBeansオブジェクトもしくはレコードのプロパティの値を、指定した型に変換して取得する。
</p>
型変換の仕様は{@link ConversionUtil}を参照。
<p/>
{@code propertyName}の指定方法については{@link #getProperty(Object, String)}を参照。

**パラメータ:**
- `bean` - プロパティの値を取得したいBeanオブジェクトもしくはレコード
- `propertyName` - 取得したいプロパティの名称
- `type` - 変換したい型 (nullを指定した場合は変換を行わず、プロパティの値をそのまま返す。)

**戻り値:**
Object 取得したプロパティを{@code type}に変換したオブジェクト

**例外:**
- `BeansException` - {@code propertyName} に対応するプロパティが定義されていない場合。

---

### setProperty

```java
private static void setProperty(Object bean, PropertyExpression expression, Map<String,?> map, CopyOptions copyOptions)
```

JavaBeansのプロパティに値を設定する。
<p>
引数の{@code bean}がレコードの場合、実行時例外が送出される。

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

**例外:**
- `IllegalArgumentException` - 引数の{@code bean}がレコードの場合

---

### setNodeProperty

```java
private static void setNodeProperty(Object bean, PropertyExpression expression, Map<String,?> map)
```

JavaBeansのプロパティに値を設定する。（ネストしない場合用）

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap

**例外:**
- `BeansException` - インスタンス生成に失敗した場合

---

### setNestedProperty

```java
private static void setNestedProperty(Object bean, PropertyExpression expression, Map<String,?> map, CopyOptions copyOptions)
```

JavaBeansのプロパティに値を設定する。（ネストする場合用）

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

**例外:**
- `BeansException` - インスタンス生成に失敗した場合

---

### setNestedObjectProperty

```java
private static void setNestedObjectProperty(Object bean, PropertyExpression expression, Map<String,?> map, CopyOptions copyOptions)
```

{@link Object}のプロパティに値を設定する。（ネストする場合用）

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

---

### setNodeListProperty

```java
private static void setNodeListProperty(Object bean, PropertyExpression expression, Map<String,?> map)
```

{@link List}のプロパティに値を設定する。（ネストしない場合用）

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap

---

### setNestedListProperty

```java
private static void setNestedListProperty(Object bean, PropertyExpression expression, Map<String,?> map, CopyOptions copyOptions)
```

{@link List}のプロパティに値を設定する。（ネストする場合用）

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

---

### setNodeArrayProperty

```java
private static void setNodeArrayProperty(Object bean, PropertyExpression expression, Map<String,?> map)
```

配列のプロパティに値を設定する。（ネストしない場合用）

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap

---

### setNestedArrayProperty

```java
private static void setNestedArrayProperty(Object bean, PropertyExpression expression, Map<String,?> map, CopyOptions copyOptions)
```

配列のプロパティに値を設定する。（ネストする場合用）

**パラメータ:**
- `bean` - Beanオブジェクト
- `expression` - プロパティを表すオブジェクト
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

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
private static void setPropertyValue(Object bean, String propertyName, Object propertyValue, CopyOptions copyOptions)
```

プロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `propertyName` - 値を設定するプロパティ名
- `propertyValue` - プロパティに設定する値
- `copyOptions` - コピーの設定

**例外:**
- `BeansException` - プロパティの設定に失敗した場合。

---

### getGenericType

```java
private static Class<?> getGenericType(Object bean, String propertyName)
```

JavaBeansのプロパティから、リスト要素の型を取得する.
<p>
本メソッドは、JavaBeansのList型のプロパティの構築時に、型変数に指定された型を取得するために使用することを想定している。
したがって、プロパティがList型とならないような引数を指定してはならない。

**パラメータ:**
- `bean` - Beanオブジェクト
- `propertyName` - プロパティ名

**戻り値:**
リストの要素の型

**例外:**
- `BeansException` - Listプロパティが原型である場合
- `IllegalStateException` - コンポーネントの型が型変数である場合

---

### getGenericTypeForRecord

```java
private static Class<?> getGenericTypeForRecord(Class<?> beanClass, String propertyName)
```

レコードのコンポーネントから、リストの要素の型を取得する.
<p>
本メソッドは、レコードのList型のコンポーネントの構築時に、型変数に指定された型を取得するために使用することを想定している。
したがって、コンポーネントがList型とならないような引数を指定してはならない。

**パラメータ:**
- `beanClass` - Beanオブジェクト
- `propertyName` - プロパティ名

**戻り値:**
リストの要素の型

**例外:**
- `BeansException` - Listコンポーネントの型が原型である場合
- `IllegalStateException` - コンポーネントの型が型変数である場合

---

### setProperty

```java
public static void setProperty(Object bean, String propertyName, Object propertyValue)
```

指定したJavaBeansオブジェクトのプロパティに値を登録する。
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
<p>
実装例
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
引数の{@code bean}がレコードの場合、実行時例外が送出される。

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
- `IllegalArgumentException` - 引数の{@code bean}がレコードの場合

---

### setProperty

```java
private static void setProperty(Object bean, String propertyName, Map<String,?> map, CopyOptions copyOptions)
```

プロパティに値を設定する。

**パラメータ:**
- `bean` - Beanオブジェクト
- `propertyName` - 値を設定するプロパティ名
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

**例外:**
- `IllegalArgumentException` - 引数の{@code bean}がレコードの場合

---

### createAndCopy

```java
public static T createAndCopy(Class<T> beanClass, Map<String,?> map, CopyOptions copyOptions)
```

{@link Map}からBeanもしくはレコードを生成する。
<p/>
生成対象がBeanであり、かつ{@code map}がnullである場合は、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
生成対象がレコードであり、かつ{@code map}がnullである場合は、各コンポーネントにnullもしくはプリミティブ型のデフォルト値を設定したレコードを生成して返却する。
<p/>
{@code map}にvalueがnullのエントリがある場合、対応するプロパティの値はnullとなる。
<p/>
生成対象がBeanで、かつ対象のプロパティにsetterが定義されていない場合はなにもしない。
<p/>
プロパティの指定方法<br/>
  {@code map}に格納するエントリのキー値には、値を登録したいプロパティ名を指定する。
  List型・配列型のプロパティでは、"プロパティ名[インデックス]"という形式で要素番号を指定して値を登録できる。
  ネストしたプロパティを指定することも可能である。ネストの深さに制限はない。
  ネストの親となるプロパティがnullである場合は、インスタンスを生成してから値を登録する。
<p>
実装例
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
<p>
生成済みのインスタンスにコピーを行う点以外は、{@link #createAndCopy(Class, Map, CopyOptions)}と同じ動作である。

**パラメータ:**
- `beanClass` - 移送先BeanのClass
- `bean` - 移送先Beanインスタンス
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定
- `<T>` - 型引数

**例外:**
- `IllegalArgumentException` - 引数の{@code beanClass}がレコードクラスの場合

---

### copyMapInner

```java
private static void copyMapInner(Object bean, Map<String,?> map, CopyOptions copyOptions, PropertyExpression parentExpression)
```

{@link Map}からBeanインスタンスへコピーを行う。

**パラメータ:**
- `bean` - 移送先Beanインスタンス
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定
- `parentExpression` - 親プロパティ

**例外:**
- `BeansException` - コピーに失敗した場合
- `IllegalArgumentException` - 引数の{@code bean}がレコードの場合

---

### createRecord

```java
private static T createRecord(Class<? extends T> beanClass, Object srcBean, CopyOptions copyOptions)
```

JavaBeansもしくはレコードからレコードを生成する。

**パラメータ:**
- `beanClass` - 生成するレコードのClass
- `srcBean` - 生成元のJavaBeansもしくはレコード
- `copyOptions` - コピーの設定
- `<T>` - 型引数

**戻り値:**
レコード

**例外:**
- `BeansException` - レコードの生成に失敗した場合

---

### createRecord

```java
private static T createRecord(Class<? extends T> beanClass, Map<String,?> map, CopyOptions copyOptions)
```

{@link Map}からレコードを生成する。

**パラメータ:**
- `beanClass` - レコードのClass
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定
- `<T>` - 型引数

**戻り値:**
レコード

**例外:**
- `BeansException` - レコードの生成に失敗した場合

---

### getReducedMap

```java
static Map<String,Object> getReducedMap(String rootProperty, Map<String,?> map)
```

移送元のパラメータマップから、指定した親プロパティ名を持つエントリのみを抽出し、子パラメータのマップを生成する。

**パラメータ:**
- `rootProperty` - 親プロパティ名
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap

**戻り値:**
子パラメータのマップ

---

### createPropertyMap

```java
private static Map<String,?> createPropertyMap(Class<?> beanClass, Map<String,?> map, CopyOptions copyOptions)
```

レコードを生成するためのプロパティ値を格納したマップを生成する。

**パラメータ:**
- `beanClass` - レコードのClass
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

**戻り値:**
レコードを生成するためのプロパティ値を格納したマップ

---

### setNestedObjectPropertyToMap

```java
private static void setNestedObjectPropertyToMap(Class<?> beanClass, PropertyExpression expression, Map<String,Object> propertyMap, Map<String,?> map, CopyOptions copyOptions)
```

プロパティ値を格納したマップにオブジェクト値を設定する。

**パラメータ:**
- `beanClass` - レコードのClass
- `expression` - 設定するオブジェクトを表すPropertyExpression
- `propertyMap` - プロパティ値を格納したマップ
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

---

### setNodeArrayPropertyToMap

```java
private static void setNodeArrayPropertyToMap(Class<?> beanClass, PropertyExpression expression, Map<String,Object> propertyMap, Map<String,?> map)
```

プロパティ値を格納したマップに配列の値を設定する。（ネストしない場合用）

**パラメータ:**
- `beanClass` - レコードのClass
- `expression` - 設定する配列を表すPropertyExpression
- `propertyMap` - プロパティ値を格納したマップ
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap

---

### setNestedArrayPropertyToMap

```java
private static void setNestedArrayPropertyToMap(Class<?> beanClass, PropertyExpression expression, Map<String,Object> propertyMap, Map<String,?> map, CopyOptions copyOptions)
```

プロパティ値を格納したマップに配列の値を設定する。（ネストする場合用）

**パラメータ:**
- `beanClass` - レコードのClass
- `expression` - 設定する配列を表すPropertyExpression
- `propertyMap` - プロパティ値を格納したマップ
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

---

### setNodeListPropertyToMap

```java
private static void setNodeListPropertyToMap(Class<?> beanClass, PropertyExpression expression, Map<String,Object> propertyMap, Map<String,?> map)
```

プロパティ値を格納したマップにリストの値を設定する。（ネストしない場合用）

**パラメータ:**
- `beanClass` - レコードのClass
- `expression` - 設定するリストを表すPropertyExpression
- `propertyMap` - プロパティ値を格納したマップ
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap

---

### setNestedListPropertyToMap

```java
private static void setNestedListPropertyToMap(Class<?> beanClass, PropertyExpression expression, Map<String,Object> propertyMap, Map<String,?> map, CopyOptions copyOptions)
```

プロパティ値を格納したマップにリストの値を設定する。（ネストする場合用）

**パラメータ:**
- `beanClass` - レコードのClass
- `expression` - 設定するリストを表すPropertyExpression
- `propertyMap` - プロパティ値を格納したマップ
- `map` - JavaBeansのプロパティ名をエントリーのキー、プロパティの値をエントリーの値とする、移送元のMap
- `copyOptions` - コピーの設定

---

### createPropertyValue

```java
private static Object createPropertyValue(Class<?> beanClass, String propertyName, Object propertyValue, CopyOptions copyOptions)
```

プロパティ値を変換して生成する。

**パラメータ:**
- `beanClass` - レコードのClass
- `propertyName` - プロパティ名
- `propertyValue` - プロパティ値
- `copyOptions` - コピーの設定

**戻り値:**
変換済みのプロパティ値

**例外:**
- `BeansException` - プロパティ値の変換に失敗した場合

---

### createAndCopy

```java
public static T createAndCopy(Class<T> beanClass, Map<String,?> map)
```

{@link Map}からBeanもしくはレコードを生成する。

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

{@link Map}から、指定したプロパティのみをコピーしたBeanもしくはレコードを生成する。
<p/>
生成対象がBeanであり、かつ{@code map}がnullである場合は、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
生成対象がレコードであり、かつ{@code map}がnullである場合は、各コンポーネントにnullもしくはプリミティブ型のデフォルト値を設定したレコードを生成して返却する。
<p/>
{@code map}でvalueがnullであるプロパティの値はnullになる。例外の送出やログ出力は行わない。
<p/>
生成対象がBeanで、かつ対象のプロパティにsetterが定義されていない場合はなにもしない。
<p/>
プロパティの指定方法については{@link #createAndCopy(Class, Map)}を参照。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - 生成したいBeanクラス、もしくはレコードクラス
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

{@link Map}から指定されたプロパティ以外をコピーしてBeanもしくはレコードを生成する。
<p/>
生成対象がBeanであり、かつ{@code map}がnullである場合は、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
生成対象がレコードであり、かつ{@code map}がnullである場合は、各コンポーネントにnullもしくはプリミティブ型のデフォルト値を設定したレコードを生成して返却する。
<p/>
生成対象がBeanで、対象のプロパティにsetterが定義されていない場合はなにもしない。
<p/>
プロパティの指定方法については{@link #createAndCopy(Class, Map)}を参照。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - 生成したいBeanクラス、もしくはレコードクラス
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

Java Beansもしくはレコードからプロパティをコピーして、別のBeanを作成する。
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

Java Beansもしくはレコードからプロパティをコピーして、別のBeanを作成する。
<p/>
生成対象がBeanであり、かつ{@code srcBean}がnullである場合、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
生成対象がレコードであり、かつ{@code srcBean}がnullである場合は、各コンポーネントにnullもしくはプリミティブ型のデフォルト値を設定したレコードを生成して返却する。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - コピー先のBeanクラス
- `srcBean` - コピー元のBeanもしくはレコード
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

Java Beansもしくはレコードから指定されたプロパティをコピーして、別のBeanを作成する。
<p/>
生成対象がBeanであり、かつ{@code srcBean}がnullである場合、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
生成対象がレコードであり、かつ{@code srcBean}がnullである場合は、各コンポーネントにnullもしくはプリミティブ型のデフォルト値を設定したレコードを生成して返却する。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - コピー先のBeanクラス
- `srcBean` - コピー元のBeanもしくはレコード
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
生成対象がBeanであり、かつ{@code srcBean}がnullである場合、デフォルトコンストラクタで{@code beanClass}を生成して返却する。
<p/>
生成対象がレコードであり、かつ{@code srcBean}がnullである場合は、各コンポーネントにnullもしくはプリミティブ型のデフォルト値を設定したレコードを生成して返却する。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code beanClass}に存在しないプロパティはコピーされない。

**パラメータ:**
- `<T>` - 型引数
- `beanClass` - コピー先のBeanクラス
- `srcBean` - コピー元のBeanもしくはレコード
- `excludes` - コピー対象外のプロパティ名

**戻り値:**
プロパティに値がコピーされたBeanオブジェクト

**例外:**
- `BeansException` - {@code beanClass}のデフォルトコンストラクタの実行中に問題が発生した場合や、
  {@code beanClass}のプロパティのデフォルトコンストラクタの実行中に問題が発生した場合。

---

### copyInner

```java
static DEST copyInner(SRC srcBean, DEST destBean, CopyOptions copyOptions)
```

BeanもしくはレコードからBeanに値をコピーする。
<p/>
内部で共通的に使用されるメソッド。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクトもしくはレコード
- `destBean` - コピー先のBeanオブジェクト
- `copyOptions` - コピーの設定
- `<SRC>` - コピー元のBeanもしくはレコードの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - Beanのコピーに失敗した場合
- `IllegalArgumentException` - 引数の{@code destBean}がレコードの場合

---

### hasConverter

```java
private static boolean hasConverter(Class<?> beanClass, String propertyName, CopyOptions copyOptions)
```

指定されたプロパティの情報をもとに有効な{@link Converter}または{@link ExtensionConverter}が存在するか判定する。

**パラメータ:**
- `beanClass` - コピー先のbeanクラス
- `propertyName` - コピー先のプロパティ名
- `copyOptions` - コピーの設定

**戻り値:**
有効な{@link Converter}または{@link ExtensionConverter}が存在する場合は{@code true}

---

### copy

```java
public static DEST copy(SRC srcBean, DEST destBean)
```

BeanもしくはレコードからBeanに値をコピーする。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。
<p>
{@code destBean}にレコードが指定された場合は、{@link IllegalArgumentException}が送出される。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクトもしくはレコード
- `destBean` - コピー先のBeanオブジェクト
- `<SRC>` - コピー元のBeanもしくはレコードの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合
- `IllegalArgumentException` - 引数の{@code destBean}がレコードの場合

---

### copy

```java
public static DEST copy(SRC srcBean, DEST destBean, CopyOptions copyOptions)
```

BeanもしくはレコードからBeanに値をコピーする。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。
<p>
{@code destBean}にレコードが指定された場合は、{@link IllegalArgumentException}が送出される。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクトもしくはレコード
- `destBean` - コピー先のBeanオブジェクト
- `copyOptions` - コピーの設定
- `<SRC>` - コピー元のBeanもしくはレコードの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合
- `IllegalArgumentException` - 引数の{@code destBean}がレコードの場合

---

### copyExcludesNull

```java
public static DEST copyExcludesNull(SRC srcBean, DEST destBean)
```

BeanもしくはレコードからBeanに値をコピーする。ただしnullのプロパティはコピーしない。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。
<p>
{@code destBean}にレコードが指定された場合は、{@link IllegalArgumentException}が送出される。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクトもしくはレコード
- `destBean` - コピー先のBeanオブジェクト
- `<SRC>` - コピー元Beanもしくはレコードの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合
- `IllegalArgumentException` - 引数の{@code destBean}がレコードの場合

---

### copyIncludes

```java
public static DEST copyIncludes(SRC srcBean, DEST destBean, String includes)
```

BeanもしくはレコードからBeanに、指定されたプロパティをコピーする。
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
<p>
{@code destBean}にレコードが指定された場合は、{@link IllegalArgumentException}が送出される。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクトもしくはレコード
- `destBean` - コピー先のBeanオブジェクト
- `includes` - コピー対象のプロパティ名
- `<SRC>` - コピー元Beanもしくはレコードの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合
- `IllegalArgumentException` - 引数の{@code destBean}がレコードの場合

---

### copyExcludes

```java
public static DEST copyExcludes(SRC srcBean, DEST destBean, String excludes)
```

BeanもしくはレコードからBeanに、指定されたプロパティ以外をコピーする。
<p/>
プロパティのコピーは{@code srcBean}に定義されたプロパティをベースに実行される。
{@code srcBean}に存在し、{@code destBean}に存在しないプロパティはコピーされない。
<p>
{@code destBean}にレコードが指定された場合は、{@link IllegalArgumentException}が送出される。

**パラメータ:**
- `srcBean` - コピー元のBeanオブジェクトもしくはレコード
- `destBean` - コピー先のBeanオブジェクト
- `excludes` - コピー対象外のプロパティ名
- `<SRC>` - コピー元Beanもしくはレコードの型
- `<DEST>` - コピー先のBeanの型

**戻り値:**
コピー先のBeanオブジェクト

**例外:**
- `BeansException` - {@code destBean}のプロパティのインスタンス生成に失敗した場合
- `IllegalArgumentException` - 引数の{@code destBean}がレコードの場合

---

### createMapAndCopy

```java
public static Map<String,Object> createMapAndCopy(SRC srcBean, CopyOptions copyOptions)
```

BeanもしくはレコードからMapにプロパティの値をコピーする。
<p>
Mapのキーはプロパティ名で、値はプロパティ値となる。
値の型変換は行わず、Beanのプロパティの値を単純にMapの値に設定する。
BeanがBeanを持つ構造の場合、Mapのキー値は「.」で連結された値となる。

**パラメータ:**
- `srcBean` - Beanもしくはレコード
- `copyOptions` - コピーの設定
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapAndCopy

```java
public static Map<String,Object> createMapAndCopy(SRC srcBean)
```

BeanもしくはレコードからMapにプロパティの値をコピーする。

<p>
内部的には空の{@link CopyOptions}を渡して{@link #createMapAndCopy(Object, CopyOptions)}を呼び出している。
</p>

**パラメータ:**
- `srcBean` - Beanもしくはレコード
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapAndCopyExcludes

```java
public static Map<String,Object> createMapAndCopyExcludes(SRC srcBean, String excludeProperties)
```

BeanもしくはレコードからMapにプロパティの値をコピーする。
<p>
Mapのキーはプロパティ名で、値はプロパティ値となる。
値の型変換は行わず、Beanのプロパティの値を単純にMapの値に設定する。
BeanがBeanを持つ構造の場合、Mapのキー値は「.」で連結された値となる。
<p>
除外対象のプロパティ名が指定された場合は、そのプロパティがコピー対象から除外される。

**パラメータ:**
- `srcBean` - Beanもしくはレコード
- `excludeProperties` - 除外対象のプロパティ名
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapAndCopyIncludes

```java
public static Map<String,Object> createMapAndCopyIncludes(SRC srcBean, String includesProperties)
```

BeanもしくはレコードからMapに指定されたプロパティの値をコピーする。
<p>
Mapのキーはプロパティ名で、値はプロパティ値となる。
値の型変換は行わず、Beanのプロパティの値を単純にMapの値に設定する。
BeanがBeanを持つ構造の場合、Mapのキー値は「.」で連結された値となる。
<p>
コピー対象のプロパティ名として指定できるのは、トップ階層のBeanのプロパティ名となる。
このため、階層構造で子階層のBeanがinclude指定されていた場合、子階層のBeanのプロパティは全てコピーされる。

**パラメータ:**
- `srcBean` - Beanもしくはレコード
- `includesProperties` - コピー対象のプロパティ名のリスト
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

---

### createMapInner

```java
private static Map<String,Object> createMapInner(SRC srcBean, String prefix, CopyOptions copyOptions)
```

Mapを作成しBeanもしくはレコードのプロパティ値をコピーする。

**パラメータ:**
- `srcBean` - コピー元のBeanもしくはレコード
- `prefix` - プロパティ名のプレフィックス
- `copyOptions` - コピーの設定
- `<SRC>` - Beanの型

**戻り値:**
BeanのプロパティをコピーしたMap

**例外:**
- `BeansException` - Beanもしくはレコードのプロパティの読み取りに失敗した場合

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

**例外:**
- `BeansException` - インスタンスの生成に失敗した場合

---

### clearCache

```java
static void clearCache()
```

---
