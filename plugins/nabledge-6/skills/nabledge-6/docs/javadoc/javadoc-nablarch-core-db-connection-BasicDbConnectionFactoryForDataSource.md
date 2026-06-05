# class BasicDbConnectionFactoryForDataSource

**パッケージ:** nablarch.core.db.connection

**継承階層:**
```
java.lang.Object
  └─ ConnectionFactorySupport
      └─ nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource
```

---

```java
public class BasicDbConnectionFactoryForDataSource
extends ConnectionFactorySupport
```

{@link DataSource}からデータベース接続を取得し、BasicDbConnectionを生成すクラス。
<p/>
{@link DataSource}は、データベースへの接続情報を設定の上、#setDataSource(javax.sql.DataSource)を使用して本オブジェクトに設定すること。
<p/>
※{@link DataSource}へのデータベース接続情報の設定方法は、各データベースベンダーのJDBCマニュアルを参照の上実施すること。

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### dataSource

```java
private DataSource dataSource
```

データソースオブジェクト

---

## メソッドの詳細

### getConnection

```java
public TransactionManagerConnection getConnection(String connectionName)
```

データベース接続オブジェクトを取得する。

**戻り値:**
データベース接続オブジェクト

---

### setDataSource

```java
public void setDataSource(DataSource dataSource)
```

{@link DataSource}を設定する。

**パラメータ:**
- `dataSource` - データソース

---
