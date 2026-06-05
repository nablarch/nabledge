# class DeferredEntityList

**パッケージ:** nablarch.common.dao

**継承階層:**
```
java.lang.Object
  └─ EntityList<E>
      └─ nablarch.common.dao.DeferredEntityList
```

**実装されたインタフェース:**
- Closeable

---

```java
public class DeferredEntityList
extends EntityList<E>
implements Closeable
```

遅延Entityリストを表すクラス。
<p/>
本クラスでは、データベースの検索結果をクライアントカーソルとして保持するのではなくサーバサイドカーソルとして保持する。
そのため、必要な処理が終了したタイミングで{@link #close()}メソッドを使用し、リソース解放を行うこと。
<p/>
検索結果は、{@link #iterator()}で取得した{@link java.util.Iterator}を用いて取得する。
{@link java.util.Iterator#next()}を呼び出したタイミングで、
{@link java.sql.ResultSet#next()}を呼び出し次レコードの値を返却する。
<p/>
{@link #iterator()}の複数回呼び出しはサポートしない。
これは、{@link java.sql.ResultSet#TYPE_FORWARD_ONLY}のカーソルしかサポートしないため、
一度読み込んだレコードを再度読み込むことは出来ないためである。
<p/>
本クラスでは、{@link #iterator()}のみサポートする。
これ以外のメソッドが呼び出された場合は、{@link java.lang.UnsupportedOperationException}を送出する。

**param:** 型パラメータ  
**作成者:** kawasima  
**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### serialVersionUID

```java
private static final long serialVersionUID
```

serialVersionUID

---

### resourceHolder

```java
private final transient SqlResourceHolder resourceHolder
```

SQL情報

---

### entityClass

```java
private final Class<E> entityClass
```

エンティティクラス

---

## コンストラクタの詳細

### DeferredEntityList

```java
public DeferredEntityList(Class<E> entityClass, SqlResourceHolder resourceHolder)
```

遅延EntityListを生成する。

**パラメータ:**
- `entityClass` - Entityのクラス
- `resourceHolder` - SQLリソース

---

## メソッドの詳細

### iterator

```java
public Iterator<E> iterator()
```

---

### close

```java
public void close()
```

---

### dispose

```java
private void dispose()
```

SQLリソースを解放する。

---

### listIterator

```java
public ListIterator<E> listIterator()
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### listIterator

```java
public ListIterator<E> listIterator(int index)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### add

```java
public boolean add(E e)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### addAll

```java
public boolean addAll(Collection<? extends E> c)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### clear

```java
public void clear()
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### contains

```java
public boolean contains(Object o)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### ensureCapacity

```java
public void ensureCapacity(int minCapacity)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### get

```java
public E get(int index)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### indexOf

```java
public int indexOf(Object o)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### isEmpty

```java
public boolean isEmpty()
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### lastIndexOf

```java
public int lastIndexOf(Object o)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### remove

```java
public boolean remove(Object o)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### removeRange

```java
protected void removeRange(int fromIndex, int toIndex)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### size

```java
public int size()
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### toArray

```java
public Object[] toArray()
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### toArray

```java
public T[] toArray(T[] a)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### trimToSize

```java
public void trimToSize()
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### subList

```java
public List<E> subList(int fromIndex, int toIndex)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### containsAll

```java
public boolean containsAll(Collection<?> c)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### removeAll

```java
public boolean removeAll(Collection<?> c)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### retainAll

```java
public boolean retainAll(Collection<?> c)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### toString

```java
public String toString()
```

---
