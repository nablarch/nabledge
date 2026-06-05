# class DbHealthChecker

**パッケージ:** nablarch.fw.web.handler.health

**継承階層:**
```
java.lang.Object
  └─ HealthChecker
      └─ nablarch.fw.web.handler.health.DbHealthChecker
```

---

```java
public class DbHealthChecker
extends HealthChecker
```

DBのヘルスチェックを行うクラス。

SQLを発行し、例外が発生しなければヘルシと判断する。
{@link Dialect#getPingSql()}から取得したSQLを発行する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### dataSource

```java
private DataSource dataSource
```

---

### dialect

```java
private Dialect dialect
```

---

## コンストラクタの詳細

### DbHealthChecker

```java
public DbHealthChecker()
```

---

## メソッドの詳細

### tryOut

```java
protected boolean tryOut(HttpRequest request, ExecutionContext context)
               throws Exception
```

---

### setDataSource

```java
public void setDataSource(DataSource dataSource)
```

データソースを設定する。

**パラメータ:**
- `dataSource` - データソース

---

### setDialect

```java
public void setDialect(Dialect dialect)
```

ダイアレクトを設定する。

**パラメータ:**
- `dialect` - ダイアレクト

---
