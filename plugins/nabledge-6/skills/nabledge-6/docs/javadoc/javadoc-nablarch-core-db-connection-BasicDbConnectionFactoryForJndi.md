# class BasicDbConnectionFactoryForJndi

**パッケージ:** nablarch.core.db.connection

**継承階層:**
```
java.lang.Object
  └─ ConnectionFactorySupport
      └─ nablarch.core.db.connection.BasicDbConnectionFactoryForJndi
```

---

```java
public class BasicDbConnectionFactoryForJndi
extends ConnectionFactorySupport
```

JNDI経由で取得した{@link DataSource}からデータベース接続({@link Connection})を取得し、BasicDbConnectionを生成するクラス。
<p/>
JNDIから{@link DataSource}を取得するための情報は、#setJndiProperties(Map)及び、#setJndiResourceName(String)を使用して設定すること。

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### jndiProperties

```java
private Properties jndiProperties
```

JNDI properties

---

### jndiResourceName

```java
private String jndiResourceName
```

JNDI resource name

---

## メソッドの詳細

### getConnection

```java
public TransactionManagerConnection getConnection(String connectionName)
```

データベース接続オブジェクトを取得する。

**戻り値:**
指定されたリソース名に対応するデータベース接続オブジェクト

---

### setJndiProperties

```java
public void setJndiProperties(Map<String,String> jndiProperties)
```

JNDIプロパティを設定する。

**パラメータ:**
- `jndiProperties` - JNDIプロパティ

---

### setJndiResourceName

```java
public void setJndiResourceName(String jndiResourceName)
```

JNDIリソース名を設定する。

**パラメータ:**
- `jndiResourceName` - JNDIリソース名

---
