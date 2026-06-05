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

### DAO_IMPL_MAP

```java
private static final Map<Class<?>,Object> DAO_IMPL_MAP
```

Dao実装クラスのインスタンスを保持するMap

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

**パラメータ:**
- `daoClass` - Daoインタフェースの{@link Class}
- `<T>` - Daoインタフェース

**戻り値:**
Dao実装クラス

---

### createInstance

```java
private static T createInstance(Class<T> daoClass)
```

指定されたDaoインタフェースの実装クラスを生成する。

**パラメータ:**
- `daoClass` - Daoインタフェースの{@link Class}
- `<T>` - Daoインタフェース

**戻り値:**
Dao実装クラス

---
