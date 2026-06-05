# class CacheableStatementFactory

**パッケージ:** nablarch.core.db.cache.statement

**継承階層:**
```
java.lang.Object
  └─ BasicStatementFactory
      └─ nablarch.core.db.cache.statement.CacheableStatementFactory
```

---

```java
public class CacheableStatementFactory
extends BasicStatementFactory
```

キャッシュ機能を備えた{@link nablarch.core.db.statement.StatementFactory}実装クラス。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### expirationSetting

```java
private ExpirationSetting expirationSetting
```

有効期限設定

---

### resultSetCache

```java
private ResultSetCache resultSetCache
```

キャッシュ

---

## メソッドの詳細

### getSqlPStatementBySqlId

```java
public SqlPStatement getSqlPStatementBySqlId(String sqlId, Connection con, DbExecutionContext context)
                                      throws SQLException
```

{@inheritDoc}
指定されたSQL IDがキャッシュ対象かどうかを判定し、
キャッシュ対象である場合は、キャッシュ機能を備えた{@link CacheableSqlPStatement}を返却する。
キャッシュ対象でない場合、スーパクラスのメソッドが起動される。

**パラメータ:**
- `sqlId` - 下記形式のSQL_ID（SQLリソース名 + "#" + SQL_ID）

**戻り値:**
{@link SqlPStatement}実装クラスのインスタンス

---

### getParameterizedSqlPStatementBySqlId

```java
public ParameterizedSqlPStatement getParameterizedSqlPStatementBySqlId(String sqlId, Connection con, DbExecutionContext context)
                                                                throws SQLException
```

{@inheritDoc}
指定されたSQL IDがキャッシュ対象かどうかを判定し、
キャッシュ対象である場合は、キャッシュ機能を備えた{@link CacheableSqlPStatement}を返却する。
キャッシュ対象でない場合、スーパクラスのメソッドが起動される。

**パラメータ:**
- `sqlId` - 下記形式のSQL_ID（SQLリソース名 + "#" + SQL_ID）
- `con` - コネクション

**戻り値:**
{@link ParameterizedSqlPStatement}実装クラスのインスタンス

---

### getParameterizedSqlPStatementBySqlId

```java
public ParameterizedSqlPStatement getParameterizedSqlPStatementBySqlId(String original, String sqlId, Connection con, DbExecutionContext context)
                                                                throws SQLException
```

{@inheritDoc}
指定されたSQL IDがキャッシュ対象かどうかを判定し、
キャッシュ対象である場合は、キャッシュ機能を備えた{@link CacheableSqlPStatement}を返却する。
キャッシュ対象でない場合、スーパクラスのメソッドが起動される。

**パラメータ:**
- `original` - オリジナルのSQL
- `sqlId` - SQL ID（SQLリソース名 + "#" + SQL_ID）
- `con` - コネクション

**戻り値:**
{@link ParameterizedSqlPStatement}実装クラスのインスタンス

---

### setRSCacheAttrTo

```java
protected void setRSCacheAttrTo(CacheableSqlPStatement sqlp)
```

指定されたステートメントにキャッシュに関する以下の属性を設定する。
<ul>
<li>有効期限設定</li>
<li>キャッシュ</li>
</ul>

**パラメータ:**
- `sqlp` - 設定対象となるステートメント

---

### isCacheTarget

```java
private boolean isCacheTarget(String sqlId)
```

指定されたSQL IDがキャッシュ対象かどうか判定する。

**パラメータ:**
- `sqlId` - 判定対象となるSQL ID

**戻り値:**
キャッシュ対象である場合、真

---

### setExpirationSetting

```java
public void setExpirationSetting(ExpirationSetting expirationSetting)
```

キャッシュ有効期限設定を設定する（必須）。
本メソッドはDIコンテナから起動されることを想定している。

**パラメータ:**
- `expirationSetting` - 有効期限設定

---

### setResultSetCache

```java
public void setResultSetCache(ResultSetCache resultSetCache)
```

キャッシュを設定する（必須）。
本メソッドはDIコンテナから起動されることを想定している。

**パラメータ:**
- `resultSetCache` - キャッシュ

---

### checkStatus

```java
private void checkStatus()
```

ステータスのチェックを行う。
必要なプロパティが全て設定されていることを確認する。

---
