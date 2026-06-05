# class ObjectUtil

**パッケージ:** nablarch.core.util

---

```java
public final class ObjectUtil
```

フレームワークで使用する、オブジェクトの取り扱いを助けるユーティリティクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### PRIMITIVE_TYPE_MAP

```java
private static final Map<Class<?>,Class<?>> PRIMITIVE_TYPE_MAP
```

プリミティブ型のマップ。

---

### SETTER_METHOD_NAME_PATTERN

```java
private static final Pattern SETTER_METHOD_NAME_PATTERN
```

setterメソッドのメソッド名パターン。

---

### GETTER_METHOD_NAME_PATTERN

```java
private static final Pattern GETTER_METHOD_NAME_PATTERN
```

getterメソッドのメソッド名パターン。

---

## コンストラクタの詳細

### ObjectUtil

```java
private ObjectUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### createInstance

```java
public static T createInstance(String className)
```

クラス名からインスタンスを生成する。

**パラメータ:**
- `<T>` - 型引数
- `className` - 完全修飾クラス名

**戻り値:**
インスタンス

**例外:**
- `IllegalArgumentException` - インスタンスの生成に失敗した場合

---

### setProperty

```java
public static void setProperty(Object obj, String propertyName, Object value)
```

オブジェクトのプロパティに値を設定する。

本メソッドでは、対象プロパティがstaticの場合でも値は設定される。

**パラメータ:**
- `obj` - 対象のオブジェクト
- `propertyName` - プロパティ名
- `value` - 設定する値(NOT {@code null})

**例外:**
- `RuntimeException` - 対象プロパティにsetterが定義されていない場合か、
  対象プロパティのsetterが対象プロパティの型かそのサブクラスを引数にとらない場合

---

### setProperty

```java
public static void setProperty(Object obj, String propertyName, Object value, boolean allowStatic)
```

オブジェクトのプロパティに値を設定する。

本メソッドでは、対象プロパティがstaticの場合に値を設定するかどうかを引数で制御できる。
引数allowStaticが{@code false}（許容しない）かつ対象プロパティがstaticである場合、
例外が発生する。

**パラメータ:**
- `obj` - 対象のオブジェクト
- `propertyName` - プロパティ名
- `value` - 設定する値(NOT {@code null})
- `allowStatic` - staticなプロパティに対する値の設定を許容するかどうか

**例外:**
- `RuntimeException` - 対象プロパティにsetterが定義されていない場合か、
  対象プロパティのsetterが対象プロパティの型かそのサブクラスを引数にとらない場合
- `IllegalConfigurationException` - 引数allowStaticが{@code false}（許容しない）かつ対象プロパティがstaticである場合。
  (システムプロパティやweb.xml等の設定誤り)

---

### getSetterMethodName

```java
public static String getSetterMethodName(String propertyName)
```

プロパティ名からsetterメソッド名を取得する。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
setterメソッド名

---

### findMatchMethod

```java
public static Method findMatchMethod(Class<?> objectClass, String methodName, Class<?> valueTypes)
```

指定したシグネチャにマッチするメソッドを検索する。
<p/>
マッチするメソッドが見つからなかった場合は{@code null}を返す。
<p/>
マッチング条件は以下である。
<ul>
    <li>{@code methodName}とメソッド名が一致していること</li>
    <li>{@code valueTypes}と引数の数が一致していること</li>
    <li>{@code valueTypes}と引数の型が一致していること。ただし、以下の場合は「同一の型」と見なす。
        <ul>
            <li>プリミティブ型とそのラッパー型とを比較した場合</li>
            <li>{@code valueTypes}で指定した型とそのスーパークラスとを比較した場合</li>
        </ul>
    </li>
</ul>

**パラメータ:**
- `objectClass` - 検索対象のクラス
- `methodName` - メソッド名
- `valueTypes` - 引数の型リスト(NOT {@code null})。
                  引数の型の他、そのサブクラスでもマッチする。
                  引数を取らないメソッドを検索する場合は、空の配列を引き渡す。

**戻り値:**
検索されたメソッド

---

### getAncestorClasses

```java
public static List<Class<?>> getAncestorClasses(Class<?> clazz)
```

クラスの全ての祖先を取得する。
<p/>
祖先のリストの並び順は、{@code clazz}からの近さ順となる。
<p/>
{@link Object}は取得結果リストに含まれない。<br/>
そのため、{@code clazz}が{@link Object}以外を継承していないクラスである場合、空のリストを返す。

**パラメータ:**
- `clazz` - 祖先を取得するクラス

**戻り値:**
クラスの全ての祖先のリスト

---

### getPropertyType

```java
public static Class<?> getPropertyType(Class<?> clazz, String propertyName)
```

プロパティの型を取得する。
<p/>
setterが定義されているプロパティのみ取得可能である。
<p/>
該当するプロパティが見つからない場合は{@code null}を返す。

**パラメータ:**
- `clazz` - プロパティの型を取得するクラス
- `propertyName` - プロパティ名

**戻り値:**
プロパティの型

---

### getWritablePropertyNames

```java
public static List<String> getWritablePropertyNames(Class<?> clazz)
```

{@code clazz}に定義されたプロパティの名称リストを取得する。
setterが定義されているプロパティのみが対象となる。
<p/>
{@code clazz}にsetterが定義されたプロパティがない場合、空のリストを返す。

**パラメータ:**
- `clazz` - 取得対象のクラス

**戻り値:**
{@code clazz}に定義されたプロパティの名称リスト(setterが定義されているプロパティのみ取得する)

---

### getPropertyNameFromSetter

```java
public static String getPropertyNameFromSetter(Method method)
```

setterメソッドからプロパティ名を取得する。

**パラメータ:**
- `method` - セッタメソッド

**戻り値:**
プロパティ名

**例外:**
- `IllegalArgumentException` - {@code method}の名称が"set"で開始していない場合

---

### getSetterMethods

```java
public static List<Method> getSetterMethods(Class<?> clazz)
```

{@code clazz}に定義されたsetterのリストを取得する。
<p/>
setterが一つも定義されていない場合は空のリストを返す。

**パラメータ:**
- `clazz` - 取得対象のクラス

**戻り値:**
{@code clazz}に定義されたセッタのリスト

---

### getSetterMethod

```java
public static Method getSetterMethod(Class<?> targetClass, String propertyName)
```

setterメソッドを検索する。

**パラメータ:**
- `targetClass` - ターゲットのクラス
- `propertyName` - プロパティ名

**戻り値:**
setterメソッド

**例外:**
- `RuntimeException` - {@code propertyName}に対応するsetterがない場合

---

### getGetterMethod

```java
public static Method getGetterMethod(Class<?> targetClass, String propertyName)
```

getterメソッドを検索する。

**パラメータ:**
- `targetClass` - ターゲットのクラス
- `propertyName` - プロパティ名

**戻り値:**
getterメソッド

**例外:**
- `RuntimeException` - {@code propertyName}に対応するgetterがない場合

---

### getGetterMethodName

```java
public static String getGetterMethodName(String propertyName)
```

プロパティ名からgetterメソッド名を取得する。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
getterメソッド名

**例外:**
- `IllegalArgumentException` - {@code propertyName}が{@code null}か空文字である場合

---

### getPropertyNameFromGetter

```java
public static String getPropertyNameFromGetter(Method method)
```

getterメソッドからプロパティ名を取得する。
<p/>

**パラメータ:**
- `method` - getterメソッド

**戻り値:**
プロパティ名

**例外:**
- `IllegalArgumentException` - {@code method}の名前が"get"で開始していない場合

---

### getGetterMethods

```java
public static List<Method> getGetterMethods(Class<?> clazz)
```

クラスにあるgetterのリストを取得する。
<p/>
{@link Object#getClass()}は取得対象から除く。
<p/>
getterが一つも定義されていない場合は空のリストを返す。

**パラメータ:**
- `clazz` - 取得対象のクラス

**戻り値:**
クラスにあるgetterのリスト

---

### getProperty

```java
public static Object getProperty(Object object, String propertyName)
```

オブジェクトからプロパティの値を取得する。

**パラメータ:**
- `object` - {@link Map}、またはプロパティ名のgetterを備えたオブジェクト
- `propertyName` - プロパティ名

**戻り値:**
プロパティの値

**例外:**
- `IllegalArgumentException` - <ul>
    <li>{@code object}がnullである場合</li>
    <li>{@code propertyName}がnullか空文字である場合</li>
    <li>{@code propertyName}に対応する、getterメソッドが定義されたプロパティがない場合</li>
</ul>

---

### getPropertyIfExists

```java
public static Object getPropertyIfExists(Object object, String propertyName)
```

オブジェクトに、指定したプロパティが存在する場合に値を取得する。
<br />
プロパティが存在しなかった場合は{@code null}を返す。

**パラメータ:**
- `object` - {@link Map}またはプロパティ名のgetterを備えたオブジェクト
- `propertyName` - プロパティ名

**戻り値:**
プロパティの値
<ul>
    <li>{@code object}がnullである場合</li>
    <li>{@code propertyName}が{@code null}か空文字である場合</li>
</ul>

---

### getProperty

```java
private static Object getProperty(Object object, String propertyName, boolean throwException)
```

オブジェクトからプロパティの値を取得する。
<br />
throwException が false の場合、プロパティが存在しなかった場合に{@code null}を返す。 <br />
throwException が true の場合、そうでなかった場合には IllegalArgumentException を送出する。

**パラメータ:**
- `object` - オブジェクト。Mapまたはプロパティ名のgetterを備えたオブジェクト
- `propertyName` - プロパティ名
- `throwException` - プロパティが存在しなかった場合に例外を送出するか否かを指定するフラグ

**戻り値:**
プロパティの値

---

### createExceptionsClassList

```java
public static List<Class<? extends RuntimeException>> createExceptionsClassList(List<String> originalExceptions)
```

例外の名称のリストから例外クラスのリストを生成する。
<p/>
指定された{@literal List<String>}の各要素を
{@literal Class<? extends RuntimeException>}に変換し返却する。
<p/>
例外クラスは、{@code originalExceptions}の文字列クラス名の格納順にリストに格納されて返される。
<p/>
{@code originalExceptions}が空の場合は、空のリストを返す。

**パラメータ:**
- `originalExceptions` - 例外クラス名リスト。({@literal List<String>})

**戻り値:**
例外クラスリスト。({@literal List<Class<? extends RuntimeException>>})

**例外:**
- `RuntimeException` - 要素内の文字列クラス名が、RuntimeExceptionのサブクラス以外の場合

---
