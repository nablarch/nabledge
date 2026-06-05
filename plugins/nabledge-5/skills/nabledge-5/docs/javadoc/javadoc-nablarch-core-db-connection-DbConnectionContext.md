# class DbConnectionContext

**パッケージ:** nablarch.core.db.connection

---

```java
public final class DbConnectionContext
```

データベース接続({@link AppDbConnection})をスレッド単位に管理するクラス。
<p/>
設定されたデータベース接続をスレッドに紐付けて管理する。<br/>
データベース接続の取得要求があった場合は、スレッドに紐付いているデータベース接続を返す。<br/>

**作成者:** Koichi Asano  

---

## フィールドの詳細

### connection

```java
private static final ThreadLocal<Map<String,AppDbConnection>> connection
```

スレッドに紐付けたDB接続

---

## コンストラクタの詳細

### DbConnectionContext

```java
private DbConnectionContext()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### setConnection

```java
public static void setConnection(AppDbConnection con)
```

データベース接続をデフォルトの名前でスレッドに設定する。
<p/>
データベース接続の設定には、"transaction"という名前が使用される。
設定できるデフォルトのデータベース接続はカレントスレッドに対して一つまでである。

**パラメータ:**
- `con` - データベース接続

**例外:**
- `IllegalArgumentException` - カレントスレッドに対してデフォルトのデータベース接続を複数設定した場合

---

### setConnection

```java
public static void setConnection(String connectionName, AppDbConnection con)
```

データベース接続を指定した名前でスレッドに設定する。
<p/>
名前はスレッド内でユニークでなければならない。

**パラメータ:**
- `connectionName` - データベース接続名
- `con` - データベース接続

**例外:**
- `IllegalArgumentException` - カレントスレッドに対して同じ名前のデータベース接続が設定されている場合

---

### getConnection

```java
public static AppDbConnection getConnection()
```

現在のスレッドに紐付けられたデフォルトのデータベース接続を取得する。
<p/>
データベース接続の取得には、"transaction"という名前が使用される。

**戻り値:**
データベース接続

---

### getConnection

```java
public static AppDbConnection getConnection(String connectionName)
```

現在のスレッドに紐付けられた指定した名前のデータベース接続を取得する。

**パラメータ:**
- `connectionName` - データベース接続名

**戻り値:**
データベース接続

**例外:**
- `IllegalArgumentException` - データベース接続が見つからなかった場合

---

### containConnection

```java
public static boolean containConnection(String connectionName)
```

現在のスレッドに指定した名前のデータベース接続が保持されているか判定する。

**パラメータ:**
- `connectionName` - データベース接続名

**戻り値:**
データベース接続が保持されていれば{@code true}

---

### removeConnection

```java
public static void removeConnection()
```

現在のスレッドに紐付いたデフォルトのデータベース接続を削除する。
<p/>
データベース接続の取得には"transaction"という名前が使用される。

---

### removeConnection

```java
public static void removeConnection(String connectionName)
```

現在のスレッドに紐付いた指定した名前のデータベース接続を削除する。

**パラメータ:**
- `connectionName` - データベース接続名

---

### getTransactionManagerConnection

```java
public static TransactionManagerConnection getTransactionManagerConnection()
```

現在のスレッドに紐付いたデフォルトのトランザクション制御を取得する。
<p/>
トランザクション制御の取得には、"transaction"という名前が使用される。

**戻り値:**
トランザクション制御

**例外:**
- `ClassCastException` - データベース接続の実体が{@link TransactionManagerConnection}を実装していない場合
- `IllegalArgumentException` - データベース接続が見つからなかった場合

---

### getTransactionManagerConnection

```java
public static TransactionManagerConnection getTransactionManagerConnection(String connectionName)
```

現在のスレッドから指定した名前のトランザクション制御を取得する。

**パラメータ:**
- `connectionName` - データベース接続名

**戻り値:**
トランザクション制御

**例外:**
- `ClassCastException` - データベース接続の実体が{@link TransactionManagerConnection}を実装していない場合
- `IllegalArgumentException` - データベース接続が見つからなかった場合

---
