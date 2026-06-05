# class DomaStatementProperties

**パッケージ:** nablarch.integration.doma

---

```java
public class DomaStatementProperties
```

{@link Config Domaの設定}の中で{@link java.sql.Statement Statement}に関するものをまとめたクラス。
<br/>
バッチサイズはStatementに設定する項目ではないが、Statementを実行する単位を決定するための値なので当クラスに含んでいる。

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### maxRows

```java
private int maxRows
```

最大行数の制限値

---

### fetchSize

```java
private int fetchSize
```

フェッチサイズ

---

### queryTimeout

```java
private int queryTimeout
```

クエリタイムアウト（秒）

---

### batchSize

```java
private int batchSize
```

バッチサイズ

---

## メソッドの詳細

### getMaxRows

```java
public int getMaxRows()
```

最大行数の制限値を取得する。

**戻り値:**
最大行数の制限値

---

### setMaxRows

```java
public void setMaxRows(int maxRows)
```

最大行数の制限値をセットする。

**パラメータ:**
- `maxRows` - 最大行数の制限値

---

### getFetchSize

```java
public int getFetchSize()
```

フェッチサイズを取得する。

**戻り値:**
フェッチサイズ

---

### setFetchSize

```java
public void setFetchSize(int fetchSize)
```

フェッチサイズをセットする。

**パラメータ:**
- `fetchSize` - フェッチサイズ

---

### getQueryTimeout

```java
public int getQueryTimeout()
```

クエリタイムアウト（秒）を取得する。

**戻り値:**
クエリタイムアウト（秒）

---

### setQueryTimeout

```java
public void setQueryTimeout(int queryTimeout)
```

クエリタイムアウト（秒）をセットする。

**パラメータ:**
- `queryTimeout` - クエリタイムアウト（秒）

---

### getBatchSize

```java
public int getBatchSize()
```

バッチサイズを取得する。

**戻り値:**
バッチサイズ

---

### setBatchSize

```java
public void setBatchSize(int batchSize)
```

バッチサイズをセットする。

**パラメータ:**
- `batchSize` - バッチサイズ

---
