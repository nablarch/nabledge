# class ListSearchInfo

**パッケージ:** nablarch.core.db.support

**実装されたインタフェース:**
- Serializable

---

```java
public abstract class ListSearchInfo
implements Serializable
```

一覧検索用の情報を保持する基底クラス。

**作成者:** Kiyohito Itoh  
**関連項目:** DbAccessSupport#search(String, ListSearchInfo)  

---

## フィールドの詳細

### serialVersionUID

```java
private static final long serialVersionUID
```

serialVersionUID

---

### pageNumber

```java
private Integer pageNumber
```

取得対象のページ番号

---

### max

```java
private Integer max
```

1ページあたりの最大取得件数

---

### resultCount

```java
private int resultCount
```

検索結果の総件数

---

### pageCount

```java
private int pageCount
```

総ページ数

---

### maxResultCount

```java
private int maxResultCount
```

検索結果の最大件数(上限)

---

### sortId

```java
private String sortId
```

ソートID

---

## コンストラクタの詳細

### ListSearchInfo

```java
protected ListSearchInfo()
```

{@link SystemRepository}の設定値を元に{@code ListSearchInfo}を生成する。
<p/>
<pre>
下記の初期化処理を行う。

検索結果の最大件数(上限)：
    リポジトリの設定値(nablarch.listSearch.maxResultCount)を取得して設定する。
    リポジトリの設定値が存在しない場合は、200を設定する。

検索結果のページ番号：
    1を設定する。

1ページあたりの最大取得件数：
    リポジトリの設定値(nablarch.listSearch.max)を取得して設定する。
    リポジトリの設定値が存在しない場合は、20を設定する。
</pre>

---

## メソッドの詳細

### getConfigValue

```java
protected final Integer getConfigValue(String name)
```

{@link SystemRepository}から設定値を取得する。

**パラメータ:**
- `name` - 設定名

**戻り値:**
設定値。存在しない場合はnull

---

### getSearchConditionProps

```java
public abstract String[] getSearchConditionProps()
```

検索条件のプロパティ名を取得する。

**戻り値:**
検索条件のプロパティ名

---

### getPageNumber

```java
public final Integer getPageNumber()
```

取得対象のページ番号を取得する。

**戻り値:**
取得対象のページ番号

---

### setPageNumber

```java
public void setPageNumber(Integer pageNumber)
```

取得対象のページ番号を設定する。

**パラメータ:**
- `pageNumber` - 取得対象のページ番号

---

### getStartPosition

```java
public final int getStartPosition()
```

検索結果の取得開始位置を取得する。

**戻り値:**
検索結果の取得開始位置

---

### getEndPosition

```java
public final int getEndPosition()
```

検索結果の取得終了位置を取得する。
<pre>
検索結果の総件数が現在のページ番号に対する最大取得終了位置に満たない場合は、
検索結果の総件数を返す。

検索結果の総件数が現在のページ番号に対する最大取得終了位置以上の場合は、
現在のページ番号に対する最大取得終了位置を返す。
</pre>

**戻り値:**
検索結果の取得終了位置

---

### getMax

```java
public final Integer getMax()
```

1ページあたりの最大取得件数を取得する。

**戻り値:**
1ページあたりの最大取得件数

---

### setMax

```java
public void setMax(Integer max)
```

1ページあたりの最大取得件数を設定する。

**パラメータ:**
- `max` - 1ページあたりの最大取得件数

---

### getResultCount

```java
public final int getResultCount()
```

検索結果の総件数を取得する。

**戻り値:**
検索結果の総件数

---

### setResultCount

```java
public final void setResultCount(int resultCount)
```

検索結果の総件数を設定する。

本メソッドはフレームワークが検索処理を実行後に取得結果の総件数を設定するものである。
アプリケーション側では、本メソッドを使用して値の設定は行わないこと。

**パラメータ:**
- `resultCount` - 検索結果の総件数

---

### getMaxResultCount

```java
public final int getMaxResultCount()
```

検索結果の最大件数(上限)を取得する。

**戻り値:**
検索結果の最大件数(上限)

---

### setMaxResultCount

```java
public void setMaxResultCount(int maxResultCount)
```

検索結果の最大件数(上限)を設定する。

**パラメータ:**
- `maxResultCount` - 検索結果の最大件数(上限)

---

### getSortId

```java
public final String getSortId()
```

ソートIDを取得する。

**戻り値:**
ソートID

---

### setSortId

```java
public void setSortId(String sortId)
```

ソートIDを設定する。

**パラメータ:**
- `sortId` - ソートID

---

### getHasPrevPage

```java
public final boolean getHasPrevPage()
```

前のページが存在するか否かを取得する。

**戻り値:**
前のページが存在する場合は{@code true}

---

### getHasNextPage

```java
public final boolean getHasNextPage()
```

次のページが存在するか否かを取得する。

**戻り値:**
次のページが存在する場合は{@code true}

---

### getPageCount

```java
public final int getPageCount()
```

総ページ数を取得する。

**戻り値:**
総ページ数

---

### getFirstPageNumber

```java
public final int getFirstPageNumber()
```

最初のページ番号を取得する。

**戻り値:**
最初のページ番号

---

### getPrevPageNumber

```java
public final int getPrevPageNumber()
```

前のページ番号を取得する。

**戻り値:**
前のページ番号

---

### getNextPageNumber

```java
public final int getNextPageNumber()
```

次のページ番号を取得する。

**戻り値:**
次のページ番号

---

### getLastPageNumber

```java
public final int getLastPageNumber()
```

最終ページの番号を取得する。

**戻り値:**
最終ページの番号

---
