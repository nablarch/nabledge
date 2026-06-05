# class SimpleDbTransactionExecutor

**パッケージ:** nablarch.core.db.transaction

---

```java
public abstract class SimpleDbTransactionExecutor
```

{@link SimpleDbTransactionManager}を使用して簡易的にSQL文を実行するクラス。
<br/>
本クラスを継承したクラスは、{@link #execute(nablarch.core.db.connection.AppDbConnection)}を実装し、
SQL文の実行を行う。<br/>
これにより、{@link SimpleDbTransactionManager}を直接使用するときと比べて、
トランザクション管理などを実装する必要がなく、簡易的にSQL文を実行出来るようになる。
<br/>

**param:** トランザクション実行結果の型  
**作成者:** hisaaki sioiri  
**関連項目:** SimpleDbTransactionManager  

---

## フィールドの詳細

### transactionManager

```java
private final SimpleDbTransactionManager transactionManager
```

トランザクションマネージャ

---

### LOG

```java
private static final Logger LOG
```

Logger

---

## コンストラクタの詳細

### SimpleDbTransactionExecutor

```java
public SimpleDbTransactionExecutor(SimpleDbTransactionManager transactionManager)
```

コンストラクタ。

**パラメータ:**
- `transactionManager` - トランザクションマネージャ

---

## メソッドの詳細

### doTransaction

```java
public T doTransaction()
```

トランザクションを実行する。<br/>

**戻り値:**
トランザクション実行結果

---

### writeWarnLog

```java
private static void writeWarnLog(Throwable orgError)
```

ワーニングレベルのログ出力を行う。<br/>
指定されたオリジナル例外がnull以外の場合のみログ出力を行い、
nullの場合には、処理は行わない。
<p/>

**パラメータ:**
- `orgError` - オリジナル例外

---

### execute

```java
public abstract T execute(AppDbConnection connection)
```

SQL文を実行する。<br/>

**パラメータ:**
- `connection` - コネクション

**戻り値:**
トランザクション実行結果

---
