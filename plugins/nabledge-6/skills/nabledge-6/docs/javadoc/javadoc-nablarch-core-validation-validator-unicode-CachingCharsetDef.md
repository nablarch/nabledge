# class CachingCharsetDef

**パッケージ:** nablarch.core.validation.validator.unicode

**継承階層:**
```
java.lang.Object
  └─ CharsetDefSupport
      └─ nablarch.core.validation.validator.unicode.CachingCharsetDef
```

---

```java
public class CachingCharsetDef
extends CharsetDefSupport
```

許容文字かどうかの判定結果をキャッシュする{@link CharsetDef}実装クラス。<br/>
他の{@link CharsetDef}実装クラスにラップして使用することで、
判定処理に要する処理速度を改善できる。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### MAX

```java
private static final int MAX
```

文字（コードポイント）の最大数。
{@link BitSet}はスレッドセーフでないため、初期状態で十分な容量を確保し
使用領域に拡張が発生しないようにする。

---

### allowed

```java
private final BitSet allowed
```

許可文字のキャッシュ

---

### rejected

```java
private final BitSet rejected
```

不許可許可文字のキャッシュ

---

### charsetDef

```java
private CharsetDef charsetDef
```

実際の許容文字定義

---

## メソッドの詳細

### setCharsetDef

```java
public void setCharsetDef(CharsetDef charsetDef)
```

許容文字集合定義を設定する。

**パラメータ:**
- `charsetDef` - 許容文字集合定義

---

### contains

```java
public synchronized boolean contains(int codePoint)
```

{@inheritDoc}

---

### getDelegate

```java
private CharsetDef getDelegate()
                       throws IllegalStateException
```

委譲先の許容文字集合定義を取得する。

**戻り値:**
許容文字集合定義

**例外:**
- `IllegalStateException` - 委譲先の許容文字集合定義が設定されていな場合

---
