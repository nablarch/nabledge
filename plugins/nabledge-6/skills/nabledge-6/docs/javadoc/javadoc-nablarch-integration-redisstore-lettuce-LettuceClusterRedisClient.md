# class LettuceClusterRedisClient

**パッケージ:** nablarch.integration.redisstore.lettuce

**継承階層:**
```
java.lang.Object
  └─ AbstractLettuceRedisClient
      └─ nablarch.integration.redisstore.lettuce.LettuceClusterRedisClient
```

**実装されたインタフェース:**
- Initializable

---

```java
public class LettuceClusterRedisClient
extends AbstractLettuceRedisClient
implements Initializable
```

Cluster 構成の Redis に接続するための {@link LettuceRedisClient} 実装クラス。
<p>
このクラスの {@link #getType()} は、識別子 {@code "cluster"} を返す。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### client

```java
private RedisClusterClient client
```

---

### connection

```java
private StatefulRedisClusterConnection<byte[],byte[]> connection
```

---

### commands

```java
private RedisAdvancedClusterCommands<byte[],byte[]> commands
```

---

### uriList

```java
protected List<String> uriList
```

接続するRedisクラスタの、各ノードURIのリスト。

---

## コンストラクタの詳細

### LettuceClusterRedisClient

```java
public LettuceClusterRedisClient()
```

コンストラクタ。

---

## メソッドの詳細

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

### setUriList

```java
public void setUriList(List<String> uriList)
```

接続するRedisクラスタの、各ノードのURIをリストで設定する。
<p>
URIの書式については、<a href="https://lettuce.io/core/release/reference/#redisuri.uri-syntax">Lettuceのドキュメント</a>を参照。
</p>

**パラメータ:**
- `uriList` - 各ノードのURIのリスト

---

### initialize

```java
public void initialize()
```

{@inheritDoc}
<p>
このメソッドは、 {@link #createClient()} と {@link #createConnection(RedisClusterClient)} メソッドを使って
{@link RedisClusterClient} と {@link StatefulRedisClusterConnection} のインスタンスを生成している。<br>
これらのインスタンスの設定を任意にカスタマイズしたい場合は、このクラスを継承したサブクラスを作り、
それぞれの {@code create} メソッドをオーバーライドすること。
</p>

---

### createClient

```java
protected RedisClusterClient createClient()
```

{@link RedisClusterClient} のインスタンスを生成する。

**戻り値:**
生成された {@link RedisClusterClient}

---

### createConnection

```java
protected StatefulRedisClusterConnection<byte[],byte[]> createConnection(RedisClusterClient client)
```

{@link StatefulRedisClusterConnection} のインスタンスを生成する。

**パラメータ:**
- `client` - {@link #createClient()} で生成された {@link RedisClusterClient} インスタンス

**戻り値:**
生成された {@link StatefulRedisClusterConnection}

---

### dispose

```java
public void dispose()
```

---
