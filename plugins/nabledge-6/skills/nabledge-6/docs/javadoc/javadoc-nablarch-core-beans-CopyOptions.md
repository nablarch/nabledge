# class CopyOptions

**パッケージ:** nablarch.core.beans

---

```java
public final class CopyOptions
```

{@link BeanUtil#copy(Object, Object) Beanのコピー}で使用される設定をまとめたクラス。

<p>
当クラスのインスタンスは{@link #options() options}メソッドを起点としたビルダーパターンで構築する。
</p>

<p>
例えば次のコードは日付パターン{@code yyyy/MM/dd}を設定して、
さらにプロパティ{@code createdDate}に対しては{@code yyyy/MM/dd HH:mm}を設定している。
</p>
<pre>{@code
CopyOptions copyOptions = CopyOptions.options()
        .datePattern("yyyy/MM/dd")
        .datePatternByName("createdDate", "yyyy/MM/dd HH:mm")
        .build();
}</pre>

<p>
{@link Builder#datePattern(String) datePattern}メソッドと{@link Builder#numberPattern(String) numberPattern}は
内部的には{@link Builder#converter(Class, Converter) converter}メソッドを呼び出している。
</p>

<p>
{@link Builder#datePattern(String) datePattern}メソッドは次のクラスに対する{@link Converter}を追加する。
</p>
<ul>
<li>{@link java.util.Date}</li>
<li>{@link java.sql.Date}</li>
<li>{@link java.sql.Timestamp}</li>
<li>{@link java.lang.String}</li>
</ul>

<p>
{@link Builder#numberPattern(String) numberPattern}メソッドは次のクラスに対する{@link Converter}を追加する。
</p>
<ul>
<li>{@code short}とそのラッパークラス</li>
<li>{@code int}とそのラッパークラス</li>
<li>{@code long}とそのラッパークラス</li>
<li>{@link java.math.BigDecimal}</li>
<li>{@link java.lang.String}</li>
</ul>

<p>
同じクラスに対して{@link Builder#converter(Class, Converter) converter}メソッドが複数回呼び出されると、
先に登録されたものが有効となる。
つまり次のコードで{@link java.util.Date}に対するフォーマットは{@code yyyy/MM/dd}が有効となり、
{@code CustomDateConverter}は無視される。
</p>

<pre>{@code
CopyOptions copyOptions = CopyOptions.options()
        .datePattern("yyyy/MM/dd")
        .converter(java.util.Date.class, new CustomDateConverter())
        .build();
}</pre>

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### FROM_ANNOTATION_CACHE

```java
private static final WeakHashMap<Class<?>,CopyOptions> FROM_ANNOTATION_CACHE
```

{@link CopyOption}アノテーションから構築される{@link CopyOptions}のキャッシュ

---

### EMPTY

```java
private static final CopyOptions EMPTY
```

空の{@link CopyOptions}

---

### typedConverters

```java
private final Map<Class<?>,Converter<?>> typedConverters
```

クラスに紐づいたコンバーター

---

### namedConverters

```java
private final Map<String,Map<Class<?>,Converter<?>>> namedConverters
```

プロパティ名とクラスに紐づいたコンバーター

---

### excludesNull

```java
private final boolean excludesNull
```

コピー元プロパティが{@code null}の場合にコピーしないかどうかを決定するフラグ

---

### excludesProperties

```java
private final Collection<String> excludesProperties
```

コピー対象外のプロパティ名

---

### includesProperties

```java
private final Collection<String> includesProperties
```

コピー対象のプロパティ名

---

## コンストラクタの詳細

### CopyOptions

```java
private CopyOptions(Map<Class<?>,Converter<?>> typedConverters, Map<String,Map<Class<?>,Converter<?>>> namedConverters, boolean excludesNull, Collection<String> excludesProperties, Collection<String> includesProperties)
```

当クラスは使用者が明示的にコンストラクタを呼び出すのではなく、
{@link Builder#build()}によってインスタンス化されることを想定しているため、
コンストラクタの可視性は{@code private}としている。

**パラメータ:**
- `typedConverters` - クラスに紐づいたコンバーター
- `namedConverters` - プロパティ名とクラスに紐づいたコンバーター
- `excludesNull` - コピー元プロパティが{@code null}の場合にコピーしないかどうかを決定するフラグ
- `excludesProperties` - コピー対象外のプロパティ名
- `includesProperties` - コピー対象のプロパティ名

---

### CopyOptions

```java
private CopyOptions(Map<Class<?>,Converter<?>> typedConverters, Map<String,Map<Class<?>,Converter<?>>> namedConverters, boolean excludesNull, Collection<String> excludesProperties)
```

{@link #cloneForNestedObjectInCreateMapInner()}から呼び出されるコンストラクタ。

<p>
深くネストされたオブジェクトがコピーされる場合、
{@link Collections#unmodifiableMap(Map)}および{@link Collections#unmodifiableCollection(Collection)}で多重にラップされることを避けるために、
このコンストラクタは定義されている。
</p>

<p>
<strong>このコンストラクタの呼び出し元は{@link #cloneForNestedObjectInCreateMapInner()}メソッドだけを想定している。
その他のメソッドからは呼び出してはいけない。</strong>
</p>

**パラメータ:**
- `typedConverters` - クラスに紐づいたコンバーター
- `namedConverters` - プロパティ名とクラスに紐づいたコンバーター
- `excludesNull` - コピー元プロパティが{@code null}の場合にコピーしないかどうかを決定するフラグ
- `excludesProperties` - コピー対象外のプロパティ名

---

## メソッドの詳細

### cloneForNestedObjectInCreateMapInner

```java
CopyOptions cloneForNestedObjectInCreateMapInner()
```

{@link BeanUtil}の{@code createMapInner}メソッドでネストしたプロパティのコピーをするため、
{@code createMapInner}メソッドを再帰的に呼び出す際に渡す{@link CopyOptions}を生成して返す。

<p>
具体的には{@link #includesProperties}が空で他のフィールドは元の{@link CopyOptions}の値を引き継ぐ。
</p>

<p>
<strong>このメソッドの呼び出し元は{@link BeanUtil}の{@code createMapInner}メソッドだけを想定している。
その他のメソッドからは呼び出してはいけない。</strong>
</p>

**戻り値:**
{@link #includesProperties}以外を引き継いで作られた{@link CopyOptions}のインスタンス

---

### options

```java
public static Builder options()
```

ビルダーを取得する。

**戻り値:**
ビルダー

---

### empty

```java
public static CopyOptions empty()
```

空の{@link CopyOptions}を取得する。

**戻り値:**
空の{@link CopyOptions}

---

### fromAnnotation

```java
public static CopyOptions fromAnnotation(Class<?> clazz)
```

{@link CopyOption}アノテーションを読み取って構築された{@link CopyOptions}を取得する。

**パラメータ:**
- `clazz` - アノテーションを読み取る対象のクラス

**戻り値:**
{@link CopyOption}アノテーションを読み取って構築された{@link CopyOptions}

---

### reduce

```java
CopyOptions reduce(String propertyName)
```

{@link CopyOptions#includesProperties}および{@link CopyOptions#excludesProperties}で、
指定した親プロパティ名を持つプロパティから親プロパティ名を削除した新しい{@link CopyOptions}を返す。

**パラメータ:**
- `propertyName` - 親プロパティ名

**戻り値:**
新しい {@link CopyOptions}

---

### merge

```java
public CopyOptions merge(CopyOptions other)
```

他の{@link CopyOptions}をマージする。

<p>
マージ処理は{@code this}をベースにして差分を{@code other}から持ってくる。
例えば同一のプロパティに紐づいた{@link Converter}が{@code this}と{@code other}の両方にあった場合、
マージ後の{@link CopyOptions}には{@code this}が持つ{@link Converter}が残る。
</p>

**パラメータ:**
- `other` - 他の{@link CopyOptions}インスタンス

**戻り値:**
マージされたインスタンス

---

### merge

```java
private static Map<K,V> merge(Map<K,V> main, Map<K,V> sub)
```

ふたつの{@link Map}をマージして作られた新しい{@link Map}を返す。

**パラメータ:**
- `<K>` - キーの型
- `<V>` - 値の型
- `main` - ベースとなる{@link Map}
- `sub` - マージされる{@link Map}

**戻り値:**
マージされた{@link Map}

---

### merge

```java
private static Collection<String> merge(Collection<String> main, Collection<String> sub)
```

ふたつの{@link Collection}をマージして作られた新しい{@link Collection}を返す。

**パラメータ:**
- `main` - ベースとなる{@link Collection}
- `sub` - マージされる{@link Collection}

**戻り値:**
マージされた{@link Collection}

---

### hasTypedConverter

```java
public boolean hasTypedConverter(Class<?> clazz)
```

指定されたクラスに紐づいたコンバーターを保持しているかどうかを返す。

**パラメータ:**
- `clazz` - クラス

**戻り値:**
指定されたクラスに紐づいたコンバーターを保持していれば{@code true}

---

### hasNamedConverter

```java
public boolean hasNamedConverter(String propertyName, Class<?> clazz)
```

指定されたプロパティ名とクラスに紐づいたコンバーターを保持しているかどうかを判断して返す。

**パラメータ:**
- `propertyName` - プロパティ名
- `clazz` - クラス

**戻り値:**
指定されたプロパティ名とクラスに紐づいたコンバーターを保持していれば{@code true}

---

### convertByType

```java
public Object convertByType(Class<?> clazz, Object value)
```

クラスに紐づいたコンバーターを使用して値を変換する。

<p>
クラスに紐づいたコンバーターが見つからなければ{@link IllegalArgumentException}をスローする。
</p>

**パラメータ:**
- `clazz` - クラス
- `value` - 変換前の値

**戻り値:**
変換後の値

---

### convertByName

```java
public Object convertByName(String propertyName, Class<?> clazz, Object value)
```

プロパティ名とクラスに紐づいたコンバーターを使用して値を変換する。

<p>
プロパティ名とクラスに紐づいたコンバーターが見つからなければ{@link IllegalArgumentException}をスローする。
</p>

**パラメータ:**
- `propertyName` - プロパティ名
- `clazz` - クラス
- `value` - 変換前の値

**戻り値:**
変換後の値

---

### isExcludesNull

```java
public boolean isExcludesNull()
```

コピー元プロパティが{@code null}の場合にコピーしないかどうかを返す。

**戻り値:**
コピー元プロパティが{@code null}の場合にコピーしない場合は{@code true}

---

### isTargetProperty

```java
public boolean isTargetProperty(String propertyName)
```

指定されたプロパティがコピー対象かどうかを返す。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
コピー対象なら{@code true}

---
