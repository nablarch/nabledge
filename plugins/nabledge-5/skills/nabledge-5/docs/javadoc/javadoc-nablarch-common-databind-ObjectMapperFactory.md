# class ObjectMapperFactory

**パッケージ:** nablarch.common.databind

---

```java
public abstract class ObjectMapperFactory
```

{@link ObjectMapper}を生成するクラス。

ObjectMapper生成に利用するファクトリクラス({@link ObjectMapperFactory})の実装クラスは、以下の通り決定される。
<ul>
    <li>{@link SystemRepository}にコンポーネント名"objectMapperFactory"でオブジェクトが登録されている場合、
    そのオブジェクトを利用する。</li>
    <li>SystemRepositoryに登録されていない場合、本クラスをファクトリクラスとして利用する。</li>
</ul>

**関連項目:** ObjectMapper  
**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### FACTORY

```java
private static final ObjectMapperFactory FACTORY
```

唯一のインスタンス

---

## メソッドの詳細

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, InputStream stream)
```

入力用の{@link ObjectMapper}を生成する。
<p/>
{@code stream}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `stream` - 入力ストリーム
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, InputStream stream, DataBindConfig dataBindConfig)
```

入力用の{@link ObjectMapper}を生成する。
<p/>
{@code stream}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `stream` - 入力ストリーム
- `dataBindConfig` - マッパー設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, Reader reader)
```

入力用の{@link ObjectMapper}を生成する。
<p/>
{@code stream}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `reader` - リーダ
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, Reader reader, DataBindConfig dataBindConfig)
```

入力用の{@link ObjectMapper}を生成する。
<p/>
{@code reader}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `reader` - リーダ
- `dataBindConfig` - マッパー設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, String input)
```

入力用の{@link ObjectMapper}を生成する。
<p/>
使用後に{@link ObjectMapper#close()}を呼び出してストリームを閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `input` - 入力テキスト
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, String input, DataBindConfig dataBindConfig)
```

入力用の{@link ObjectMapper}を生成する。
<p/>
使用後に{@link ObjectMapper#close()}を呼び出してストリームを閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `input` - 入力テキスト
- `dataBindConfig` - マッパー設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, OutputStream stream)
```

出力用の{@link ObjectMapper}を生成する。
<p/>
{@code stream}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `stream` - 出力ストリーム
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, OutputStream stream, DataBindConfig dataBindConfig)
```

出力用の{@link ObjectMapper}を生成する。
<p/>
{@code stream}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `stream` - 出力ストリーム
- `dataBindConfig` - マッパー設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, Writer writer)
```

出力用の{@link ObjectMapper}を生成する。
<p/>
{@code writer}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `writer` - 出力ストリーム
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### create

```java
public static ObjectMapper<T> create(Class<T> clazz, Writer writer, DataBindConfig dataBindConfig)
```

出力用の{@link ObjectMapper}を生成する。
<p/>
{@code writer}は、使用後に{@link ObjectMapper#close()}を呼び出して閉じること。

**パラメータ:**
- `clazz` - バインディング対象のJavaのクラス
- `writer` - 出力ストリーム
- `dataBindConfig` - マッパー設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, InputStream stream)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `stream` - 入力ストリーム
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, InputStream stream, DataBindConfig dataBindConfig)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `stream` - 入力ストリーム
- `dataBindConfig` - マッピング設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, Reader reader)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `reader` - 入力ストリーム
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, Reader reader, DataBindConfig dataBindConfig)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `reader` - 入力ストリーム
- `dataBindConfig` - マッピング設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, OutputStream stream)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `stream` - 出力ストリーム
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, OutputStream stream, DataBindConfig dataBindConfig)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `stream` - 出力ストリーム
- `dataBindConfig` - マッピング設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, Writer writer)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `writer` - Writer
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createMapper

```java
public abstract ObjectMapper<T> createMapper(Class<T> clazz, Writer writer, DataBindConfig dataBindConfig)
```

{@link ObjectMapper}を生成する。

**パラメータ:**
- `clazz` - データとのバインディングを行うクラス
- `writer` - Writer
- `dataBindConfig` - マッピング設定
- `<T>` - バインディング対象のJavaのクラス

**戻り値:**
データとJava ObjectのMapper

---

### createFactory

```java
private static ObjectMapperFactory createFactory()
```

{@code ObjectMapperFactory}を生成する。
<p/>
{@link SystemRepository}上に存在する場合には、その値を返却する。
存在しない場合には、{@link #FACTORY}を返す。

**戻り値:**
{@code ObjectMapperFactory}

---
