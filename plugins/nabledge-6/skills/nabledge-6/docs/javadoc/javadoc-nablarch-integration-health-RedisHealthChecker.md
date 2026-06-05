# class RedisHealthChecker

**パッケージ:** nablarch.integration.health

**継承階層:**
```
java.lang.Object
  └─ HealthChecker
      └─ nablarch.integration.health.RedisHealthChecker
```

---

```java
public class RedisHealthChecker
extends HealthChecker
```

Redisのヘルスチェックを行うクラス。

キーの存在チェックを行い、例外が発生しなければヘルシと判断する。
キーのデフォルトは"healthcheck"。
キーは存在しなくてよい。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### client

```java
private LettuceRedisClient client
```

---

### key

```java
private String key
```

---

## コンストラクタの詳細

### RedisHealthChecker

```java
public RedisHealthChecker()
```

---

## メソッドの詳細

### tryOut

```java
protected boolean tryOut(HttpRequest request, ExecutionContext context)
```

---

### setClient

```java
public void setClient(LettuceRedisClient client)
```

Redisのクライアントを設定する。

**パラメータ:**
- `client` - Redisのクライアント

---

### setKey

```java
public void setKey(String key)
```

存在チェックに使用するキーを設定する。

**パラメータ:**
- `key` - 存在チェックに使用するキー

---
