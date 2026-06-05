# class DomaDaoRepository

**パッケージ:** nablarch.integration.doma

---

```java
public final class DomaDaoRepository
```

Domaで使用するDaoの実装クラスを生成・保持するクラス。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### LEGACY_DAO_IMPL_MAP

```java
private static final Map<Class<?>,Object> LEGACY_DAO_IMPL_MAP
```

Dao実装クラスのインスタンスを保持するMap（{@link org.seasar.doma.SingletonConfig}および{@link Dao}のconfig属性を使用している実装向け

---

### DAO_IMPL_MAP

```java
private static final Map<DaoClassWithConfigKey,Object> DAO_IMPL_MAP
```

Dao実装クラスのインスタンスを保持するMap

---

### CONFIG_MAP

```java
private static final Map<Class<? extends Config>,Config> CONFIG_MAP
```

---

## コンストラクタの詳細

### DomaDaoRepository

```java
private DomaDaoRepository()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### get

```java
public static synchronized T get(Class<T> daoClass)
```

指定されたDaoインタフェースの実装クラスを取得する。
Daoの実装クラスのインスタンス生成の際には、{@link DomaConfig}をコンストラクタ引数に指定することを試みる。
Daoの実装クラスに{@link Config}を引数に取るコンストラクタが存在しない場合は、デフォルトコンストラクタを利用する。

**パラメータ:**
- `daoClass` - Daoインタフェースの{@link Class}
- `<T>` - Daoインタフェース

**戻り値:**
Dao実装クラス

---

### get

```java
public static synchronized T get(Class<T> daoClass, Class<? extends Config> configClass)
```

指定されたDaoインタフェースの実装クラスのインスタンスを、指定された{@link Config}をコンストラクタ引数として指定して取得する。
Daoインターフェースに{@link Dao}の{@code config}属性が指定されていた場合は、求められる動作を満たせないため例外をスローする

**パラメータ:**
- `daoClass` - Daoインタフェースの{@link Class}
- `configClass` - {@link Config}の{@link Class}
- `<T>` - Daoインタフェース

**戻り値:**
Dao実装クラス

---

### findDaoImplClass

```java
private static Class<T> findDaoImplClass(Class<T> daoClass)
```

Daoインタフェースの実装クラスを取得する。

**パラメータ:**
- `daoClass` - Daoインタフェースの{@link Class}
- `<T>` - Daoインタフェースの型

**戻り値:**
Daoインタフェースの実装クラス

---

### hasNonDefaultConfigAttribute

```java
private static boolean hasNonDefaultConfigAttribute(Class<?> daoClass)
```

Daoの{@link Class}に付与された{@link Dao}アノテーションにconfig属性がデフォルト値以外に設定されている場合、{@code true}を返却する。

**パラメータ:**
- `daoClass` - Daoの{@link Class}クラス

**戻り値:**
Daoの{@link Class}に付与された{@link Dao}アノテーションにconfig属性がデフォルト値以外に設定されている場合は{@code true}

---

### createInstance

```java
private static T createInstance(Class<T> daoClass, Config config)
```

指定されたDaoインタフェースの実装クラスのインスタンスを生成する。インスタンス生成の際には、{@link Config}をコンストラクタ引数に指定する。

**パラメータ:**
- `daoClass` - Daoインタフェースの{@link Class}
- `config` - {@link Config}のインスタンス
- `<T>` - Daoインタフェース

**戻り値:**
Dao実装クラス

---

### createInstance

```java
private static T createInstance(Class<T> daoClass)
```

指定されたDaoインタフェースの実装クラスのインスタンスを生成する。

**パラメータ:**
- `daoClass` - Daoインタフェースの{@link Class}
- `<T>` - Daoインタフェース

**戻り値:**
Dao実装クラス

---

### createConfigInstance

```java
private static Config createConfigInstance(Class<? extends Config> configClass)
```

{@link Config}のインスタンスを生成する。

**パラメータ:**
- `configClass` - {@link Config}の{@link Class}クラス

**戻り値:**
{@link Config}のインスタンス

---
