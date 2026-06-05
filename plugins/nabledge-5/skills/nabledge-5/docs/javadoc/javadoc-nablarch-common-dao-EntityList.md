# class EntityList

**パッケージ:** nablarch.common.dao

**継承階層:**
```
java.lang.Object
  └─ ArrayList<E>
      └─ nablarch.common.dao.EntityList
```

---

```java
public class EntityList
extends ArrayList<E>
```

{@link UniversalDao}から返される結果リストの保持クラス。
<p/>
ページネーションのためのページ数や検索条件に一致した件数なども本クラスで保持する。

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

### pagination

```java
private Pagination pagination
```

ページング情報

---

## コンストラクタの詳細

### EntityList

```java
public EntityList()
```

デフォルトコンストラクタ

---

### EntityList

```java
public EntityList(int initCapacity)
```

指定の初期容量でEntityListを生成する。

**パラメータ:**
- `initCapacity` - 初期容量

---

### EntityList

```java
public EntityList(Collection<? extends E> collection)
```

指定のコレクションでEntityListを生成する。

**パラメータ:**
- `collection` - コレクション

---

## メソッドの詳細

### setPage

```java
protected void setPage(long page)
```

ページ番号を設定する。

**パラメータ:**
- `page` - ページ番号

---

### setMax

```java
protected void setMax(long max)
```

検索結果の取得最大件数を設定する。

**パラメータ:**
- `max` - 取得最大件数

---

### setResultCount

```java
protected void setResultCount(long resultCount)
```

検索結果の総件数を設定する。

**パラメータ:**
- `resultCount` - 検索結果の総件数

---

### getPagination

```java
public Pagination getPagination()
```

ページングのための情報を取得する。

**戻り値:**
ページングの情報

---

### initPagination

```java
private void initPagination()
```

ページングのための情報を初期化する。
<p/>
既に初期化済みの場合には、何もしない。

---

### add

```java
public void add(int index, E element)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### addAll

```java
public boolean addAll(int index, Collection<? extends E> c)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### remove

```java
public E remove(int index)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---

### set

```java
public E set(int index, E element)
```

本メソッドは利用できない。

呼び出した場合、{@link UnsupportedOperationException}を送出する。

---
