# class DbAccessException

**パッケージ:** nablarch.core.db

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.core.db.DbAccessException
```

---

```java
public class DbAccessException
extends RuntimeException
```

データベースアクセス時に発生する例外。
<p/>
データベースアクセス時に{@link java.sql.SQLException}が発生した場合、本クラスでラップし再送出すること。

**作成者:** Hisaaki Sioiri  
**関連項目:** java.sql.SQLException  

---

## フィールドの詳細

### se

```java
private SQLException se
```

SQLException

---

## コンストラクタの詳細

### DbAccessException

```java
public DbAccessException(String message, SQLException e)
```

本クラスのインスタンスを生成する。

**パラメータ:**
- `message` - エラーメッセージ
- `e` - データベースアクセス時に送出された{@link SQLException}オブジェクト

---

## メソッドの詳細

### getSQLState

```java
public final String getSQLState()
```

SQLState値を取得する。

**戻り値:**
SQLState値

---

### getErrorCode

```java
public final int getErrorCode()
```

エラーコードを取得する。

**戻り値:**
エラーコード

---
