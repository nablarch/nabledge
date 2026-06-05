# class LettuceMasterReplicaRedisClient

**パッケージ:** nablarch.integration.redisstore.lettuce

**継承階層:**
```
java.lang.Object
  └─ AbstractLettuceRedisClient
      └─ nablarch.integration.redisstore.lettuce.LettuceMasterReplicaRedisClient
```

**実装されたインタフェース:**
- Initializable

---

```java
public class LettuceMasterReplicaRedisClient
extends AbstractLettuceRedisClient
implements Initializable
```

Master/Replica 構成の Redis に接続するための {@link LettuceRedisClient} 実装。
<p>
このクラスの {@link #getType()} は、識別子 {@code "masterReplica"} を返す。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### client

```java
private RedisClient client
```

---

### connection

```java
private StatefulRedisMasterReplicaConnection<byte[],byte[]> connection
```

---

### commands

```java
private RedisCommands<byte[],byte[]> commands
```

---

### uri

```java
protected String uri
```

接続するRedisサーバーのURI。

---

## コンストラクタの詳細

### LettuceMasterReplicaRedisClient

```java
public LettuceMasterReplicaRedisClient()
```

コンストラクタ。

---

## メソッドの詳細

### setUri

```java
public void setUri(String uri)
```

接続するRedisサーバーのURIを設定する。
<p>
URIの書式については、<a href="https://lettuce.io/core/release/reference/#redisuri.uri-syntax">Lettuceのドキュメント</a>を参照。
</p>

**パラメータ:**
- `uri` - 接続するRedisサーバーのURI

---

### set

```java
public void set(String key, byte[] value)
```

---

### pexpire

```java
public void pexpire(String key, long milliseconds)
```

---

### pexpireat

```java
public void pexpireat(String key, long milliseconds)
```

---

### pttl

```java
public long pttl(String key)
```

---

### get

```java
public byte[] get(String key)
```

---

### del

```java
public void del(String key)
```

---

### exists

```java
public boolean exists(String key)
```

---

### initialize

```java
public void initialize()
```

{@inheritDoc}
<p>
このメソッドは、 {@link #createClient()} と {@link #createConnection(RedisClient)} メソッドを使って
{@link RedisClient} と {@link StatefulRedisMasterReplicaConnection} のインスタンスを生成している。<br>
これらのインスタンスの設定を任意にカスタマイズしたい場合は、このクラスを継承したサブクラスを作り、
それぞれの {@code create} メソッドをオーバーライドすること。
</p>

---

### createClient

```java
protected RedisClient createClient()
```

{@link RedisClient} のインスタンスを生成する。

**戻り値:**
生成された {@link RedisClient}

---

### createConnection

```java
protected StatefulRedisMasterReplicaConnection<byte[],byte[]> createConnection(RedisClient client)
```

{@link StatefulRedisMasterReplicaConnection} のインスタンスを生成する。

**パラメータ:**
- `client` - {@link #createClient()} で生成された {@link RedisClient} インスタンス

**戻り値:**
生成された {@link StatefulRedisMasterReplicaConnection}

---

### dispose

```java
public void dispose()
```

---
